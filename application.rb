require 'rubygems'
require 'opentox-ruby-api-wrapper'
require 'sinatra/respond_to'

mime :smiles, "chemical/x-daylight-smiles"
mime :inchi, "chemical/x-inchi"
mime :sdf, "chemical/x-mdl-sdfile"
mime :image, "image/gif"
mime :names, "text/plain"

set :default_content, :smiles

get %r{/(.+)} do |inchi| # catches all remaining get requests
	inchi = URI.unescape request.env['REQUEST_URI'].sub(/^\//,'') # hack to avoid sinatra's URI/CGI unescaping, splitting, ...
	respond_to do |format|
		format.smiles { OpenTox::Compound.new(:inchi => inchi).smiles }
		format.names  { RestClient.get "#{CACTUS_URI}#{inchi}/names" }
		format.inchi  { inchi }
		format.sdf    { RestClient.get "#{CACTUS_URI}#{inchi}/sdf" }
		format.image  { "#{CACTUS_URI}#{inchi}/image" }
	end
end

post '/?' do 
	if params[:smiles]
		OpenTox::Compound.new(:smiles => params[:smiles]).uri
	elsif params[:inchi]
		OpenTox::Compound.new(:inchi => params[:inchi]).uri
	elsif params[:name]
		OpenTox::Compound.new(:name => params[:name]).uri
	end
end
