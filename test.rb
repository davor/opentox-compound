require 'application'
require 'test/unit'
require 'rack/test'


class CompoundsTest < Test::Unit::TestCase
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  def test_uri_generation_from_smiles
    post '/', :smiles => 'CC(=O)CC(C)C#N'
		assert last_response.body.include?('CC%28CC%28%3DO%29C%29C%23N')
  end

  def test_uri_generation_from_name
    post '/', :name => 'Benzene'
		assert last_response.body.include?('c1ccccc1')
  end

  def test_smiles
    get '/CC%28CC%28%3DO%29C%29C%23N'
    assert last_response.body.include?('CC(CC(=O)C)C#N')
  end

	def test_smarts_match_true
    get '/CC%28CC%28%3DO%29C%29C%23N/match/CC'
    assert last_response.body.include?('true')
	end

	def test_smarts_match_false
    get '/CC%28CC%28%3DO%29C%29C%23N/match/Cl'
    assert last_response.body.include?('false')
	end
end
