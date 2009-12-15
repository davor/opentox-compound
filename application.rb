require 'rubygems'
#gem 'opentox-ruby-api-wrapper', '=1.1.3'
require 'opentox-ruby-api-wrapper'

CACTUS_URI="http://cactus.nci.nih.gov/chemical/structure/"

get %r{/(.+)} do |inchi| # catches all remaining get requests
	inchi = URI.unescape request.env['REQUEST_URI'].sub(/^\//,'').sub(/.*\/compound\//,'') # hack to avoid sinatra's URI/CGI unescaping, splitting, ..."
	case request.env['HTTP_ACCEPT']
	when "*/*"
		OpenTox::Compound.new(:inchi => inchi).smiles
	when "chemical/x-daylight-smiles"
		OpenTox::Compound.new(:inchi => inchi).smiles
	when "chemical/x-inchi"
		inchi 
	when "chemical/x-mdl-sdfile"
		OpenTox::Compound.new(:inchi => inchi).sdf
	when "image/gif"
		"#{CACTUS_URI}#{inchi}/image" 
	when "text/plain"
		uri = File.join CACTUS_URI,inchi,"names"
		RestClient.get(uri).to_s
	else
		status 400
		"Unsupported MIME type '#{request.content_type}'"
	end
end

post '/?' do 

	input =	request.env["rack.input"].read
	case request.content_type
	when /chemical\/x-daylight-smiles/
		OpenTox::Compound.new(:smiles => input).uri
	when /chemical\/x-inchi/
		OpenTox::Compound.new(:inchi => input).uri
	when /chemical\/x-mdl-sdfile|chemical\/x-mdl-molfile/
		OpenTox::Compound.new(:sdf => input).uri
	when /text\/plain/
		OpenTox::Compound.new(:name => input).uri
	else
		status 400
		"Unsupported MIME type '#{request.content_type}'"
	end
end
