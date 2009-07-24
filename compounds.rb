require 'rubygems'
require 'sinatra'
require 'rest_client'
require 'sinatra/url_for'

mime :smiles, "chemical/x-daylight-smiles"
mime :inchi, "chemical/x-inchi"
mime :sdf, "chemical/x-mdl-sdfile"
mime :image, "image/gif"
mime :names, "text/plain"

CACTUS_URI="http://cactus.nci.nih.gov/chemical/structure/"

get '/' do 
	status 404
	"No index available for this component."
end

get '/*.*' do
	begin
		identifier = URI.encode(params[:splat][0])
		format = params[:splat][1]
		case format 
		when 'smiles'
			RestClient.get "#{CACTUS_URI}#{identifier}/smiles"
		when 'inchikey'
			RestClient.get "#{CACTUS_URI}#{identifier}/stdinchikey"
		when 'inchi'
			RestClient.get "#{CACTUS_URI}#{identifier}/stdinchi"
		when 'sdf'
			RestClient.get "#{CACTUS_URI}#{identifier}/sdf"
		when 'names'
			RestClient.get "#{CACTUS_URI}#{identifier}/names"
		when 'image'
			"#{CACTUS_URI}#{identifier}/image"
		else
			status 400
			"Cannot provide #{format}."
		end
	rescue
		status 404
		"Cannot find #{identifier}."
	end
end

# TODO: select format by media type

# default format is smiles
get '/:identifier' do
	begin
		RestClient.get "#{CACTUS_URI}#{URI.encode(params[:identifier])}/smiles"
	rescue
		status 404
		"Cannot find #{params[:identifier]}."
	end
end

# return canonical uri
post '/' do
	begin
		inchikey = RestClient.get "#{CACTUS_URI}#{URI.encode(params[:name])}/stdinchikey"
		inchikey.chomp!
		if inchikey.match(/\n/)
			status 400
			"More than one structure found for #{params[:name]}."
		else
			url_for("/", :full) + URI.encode(inchikey)
		end
	rescue
		status 500
		"Cannot find an InChI Key for #{params[:name]}."
	end
end

delete '/*' do
	status 404
	"Cannot delete - compounds are not stored permanently"
end
