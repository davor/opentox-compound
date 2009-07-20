require 'compounds'
require 'test/unit'
require 'rack/test'


class CompoundsTest < Test::Unit::TestCase
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  def test_uri_generation
    post '/', :name => 'c1ccccc1'
		assert last_response.body.include?('InChIKey=UHOVQNZJYSORNB-UHFFFAOYSA-N')
  end

  def test_smiles
    get '/InChIKey=UHOVQNZJYSORNB-UHFFFAOYSA-N'
    assert last_response.body.include?('c1ccccc1')
  end

  def test_inchi
    get '/Benzene.inchi'
    assert last_response.body.include?('InChI=1S/C6H6/c1-2-4-6-5-3-1/h1-6H')
  end

end
