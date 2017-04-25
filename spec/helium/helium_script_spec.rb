require 'spec_helper'

describe Helium::Script do

  use_cassette 'helium_script/script'

  before(:each) do
    client = Helium::Client.new(api_key: API_KEY)
    @script_content = '-- Test Script'
    @script = client.create_script('test.lua', @script_content)
    # pre-fetch the content for cassette
    @script.content
  end

  after(:each) do
    @script.destroy
  end

  it 'has an id' do
    expect(@script).to respond_to(:id)
  end

  it 'has a name' do
    expect(@script.name).to eq('test.lua')
  end

  it 'has a type' do
    expect(@script.type).to eq("script")
  end

  it 'has content' do
    expect(@script.content).to eq(@script_content)
  end
end

describe Helium::Library do

  use_cassette 'helium_script/library'

  before(:each) do
    client = Helium::Client.new(api_key: API_KEY)
    @lib_content = '-- Test Library'
    @lib = client.create_library('test.lua', @lib_content)
    # pre-fetch the content for cassette
    @lib.content
  end

  after(:each) do
    @lib.destroy
  end

  it 'has an id' do
    expect(@lib).to respond_to(:id)
  end

  it 'has a name' do
    expect(@lib.name).to eq('test.lua')
  end

  it 'has a type' do
    expect(@lib.type).to eq("library")
  end

  it 'has content' do
    expect(@lib.content).to eq(@lib_content)
  end
end

describe Helium::Package do

  use_cassette 'helium_script/package'

  before(:each) do
    client = Helium::Client.new(api_key: API_KEY)
    @script_content = '-- Test Script'
    @script = client.create_script('test.lua', @script_content)
    @lib_content = '-- Test Library'
    @lib = client.create_library('test.lua', @lib_content)
    @package = client.create_package(@script, [@lib], 'Test Package')
    # pre-fetch for the cassette
    @package.script
    @package.libraries.first
  end

  after(:each) do
    @package.destroy
    @lib.destroy
    @script.destroy
  end

  it 'has an id' do
    expect(@package).to respond_to(:id)
  end

  it 'has a name' do
    expect(@package.name).to eq('Test Package')
  end

  it 'has a type' do
    expect(@package.type).to eq("package")
  end

  it 'has a script' do
    expect(@package.script).to eq(@script)
  end

  it 'has a collection of Libraries' do
    expect(@package.libraries).to be_a(Helium::Collection)
    expect(@package.libraries.first).to eq(@lib)
  end
end

describe Helium::SensorPackage do

  use_cassette 'helium_script/sensor_package'

  before(:each) do
    client = Helium::Client.new(api_key: API_KEY)
    @script_content = '-- Test Script'
    @script = client.create_script('test.lua', @script_content)
    @lib_content = '-- Test Library'
    @lib = client.create_library('test.lua', @lib_content)
    @sensor = client.sensor('7132021b-d7ff-4a61-a014-c99b77810ff4')
    @package = client.create_package(@script, [@lib], 'Test Package')
    @sensor_package = client.create_sensor_package(@sensor, @package)
    # pre-fetch for the cassette
    @sensor_package.sensor
    @sensor_package.package
  end

  after(:each) do
    @sensor_package.destroy
    @package.destroy
    @lib.destroy
    @script.destroy
  end

  it 'has an id' do
    expect(@sensor_package).to respond_to(:id)
  end

  it 'has a type' do
    expect(@sensor_package.type).to eq("sensor-package")
  end

  it 'has a sensor' do
    expect(@sensor_package.sensor).to eq(@sensor)
  end

  it 'has a package' do
    expect(@sensor_package.package).to eq(@package)
  end
end

