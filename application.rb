[ 'rubygems', 'sinatra', 'rest_client', 'sinatra/url_for', 'sinatra/respond_to', 'openbabel' ].each do |lib|
	require lib
end

mime :uid, "text/plain"
mime :smiles, "chemical/x-daylight-smiles"
mime :inchi, "chemical/x-inchi"
mime :sdf, "chemical/x-mdl-sdfile"
mime :image, "image/gif"
mime :names, "text/plain"

CACTUS_URI="http://cactus.nci.nih.gov/chemical/structure/"

set :default_content, :smiles

get '/*/match/*' do
	smiles = URI.decode(params[:splat][0])
	smarts = URI.decode(params[:splat][1])
	smi2mol = OpenBabel::OBConversion.new
	smi2mol.set_in_format('smi')
	obmol = OpenBabel::OBMol.new
	smi2mol.read_string(obmol,smiles) 
	obmol.add_hydrogens
	smarts_pattern = OpenBabel::OBSmartsPattern.new
	smarts_pattern.init(smarts)
	if smarts_pattern.match(obmol)
		'true'
	else
		'false'
	end
end

get %r{/(.+)} do |cansmi| # catches all remaining get requests
	respond_to do |format|
		format.uid   { URI.escape(cansmi, /[^#{URI::PATTERN::UNRESERVED}]/) }
		format.smiles { URI.unescape(cansmi).chomp }
		format.names  { RestClient.get "#{CACTUS_URI}#{cansmi}/names" }
		format.inchi  { RestClient.get "#{CACTUS_URI}#{cansmi}/stdinchi" }
		format.sdf    { RestClient.get "#{CACTUS_URI}#{cansmi}/sdf" }
		format.image  { "#{CACTUS_URI}#{cansmi}/image" }
	end
end

post '/?' do 
	if params[:smiles]
		cansmi = canonical_smiles(URI.unescape(params[:smiles]),'smi')
	elsif params[:name]
		cansmi = RestClient.get "#{CACTUS_URI}#{params[:name]}/smiles"
	end
	url_for("/", :full) + URI.escape(cansmi.gsub(/\s+/,''), /[^#{URI::PATTERN::UNRESERVED}]/)
end

def canonical_smiles(identifier,format)
	conversion = OpenBabel::OBConversion.new
	conversion.set_in_and_out_formats format, 'can'
	mol = OpenBabel::OBMol.new
	conversion.read_string mol, identifier
	conversion.write_string mol
end

