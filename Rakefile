require 'rubygems'
require 'rake'

@gems = "sinatra rest-client emk-sinatra-url-for cehoffman-sinatra-respond_to"

desc "Install required gems and openbabel"
task :install do
	puts `sudo gem sources -a http://gems.github.com`
	puts `sudo gem install #{@gems}`
	begin
		require 'openbabel'
		puts "Openbabel is already installed"
	rescue  Exception => exc
		puts "Trying to install openbabel"
		Dir.chdir('/tmp')
		puts `wget http://downloads.sourceforge.net/project/openbabel/openbabel/2.2.2/openbabel-2.2.2.tar.gz` unless File.exists?('openbabel-2.2.2.tar.gz')
		puts `tar xzf openbabel-2.2.2.tar.gz`  unless File.exists?('openbabel-2.2.2')
		Dir.chdir('openbabel-2.2.2')
		puts `./configure`
		puts "Compiling Openbabel - this may take some time ..."
 		puts `make`
		puts `sudo make install`
		Dir.chdir('scripts/ruby')
		puts `ruby extconf.rb --with-openbabel-include=../../include --with-openbabel-lib=../../src/.libs`
		puts "Compiling Ruby extension for Openbabel - this may take some time ..."
		puts `make`
		puts `sudo make install`
		begin
			require 'openbabel'
			puts "Openbabel sucessfully installed"
		rescue Exception => exc
			puts "Failed to install Openbabel - please try manually."
		end
	end
end

desc "Run tests"
task :test do
	load 'test.rb'
end

