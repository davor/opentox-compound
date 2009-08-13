require 'rubygems'
require 'rake'

desc "Install required gems and openbabel"
task :install do
	`sudo gem sources -a http://gems.github.com`
	`sudo gem install sinatra rest-client emk-sinatra-url-for cehoffman-sinatra-respond_to`
	begin
		require 'openbabel'
		puts "Openbabel is already installed"
	rescue
		Dir.chdir('/tmp')
		`wget http://downloads.sourceforge.net/project/openbabel/openbabel/2.2.2/openbabel-2.2.2.tar.gz`
		`tar xzf openbabel-2.2.2.tar.gz`
		Dir.chdir('openbabel-2.2.2')
		`configure && make`
		`sudo make install`
		Dir.cd('srcipts/ruby')
		`ruby extconf.rb --with-openbabel-include=../../include --with-openbabel-lib=../../src/.libs`
		`make`
		`make install`
	end
end

desc "Run tests"
task :test do
	load 'test.rb'
end

