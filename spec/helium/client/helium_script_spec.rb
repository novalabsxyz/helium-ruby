require 'spec_helper'

describe Helium::Client, '#create_scripts' do
  let(:client) { Helium::Client.new(api_key: API_KEY) }

  use_cassette 'helium_scripts/create_scripts'

  it 'creates a new Script' do
    script = client.create_script('test.lua', '-- Test Script')
    expect(script).to be_a(Helium::Script)
    expect(script.name).to eq('test.lua')
    expect(script).to respond_to(:id)
    script.destroy
  end

end

describe Helium::Client, '#scripts' do
  let(:client) { Helium::Client.new(api_key: API_KEY) }

  use_cassette 'helium_scripts/scripts'

  before(:each) do
    @script = client.create_script('test.lua', '-- Test Script')
  end

  after(:each) do
    @script.destroy
  end

  it 'is a Collection of Scripts' do
    scripts = client.scripts
    expect(scripts).to be_a(Helium::Collection)
    expect(scripts.first).to be_a(Helium::Script)
  end
end

describe Helium::Client, '#script' do
  let(:client) { Helium::Client.new(api_key: API_KEY) }

  use_cassette 'helium_scripts/script'

  before(:each) do
    @script = client.create_script('test.lua', '-- Test Script')
  end

  after(:each) do
    @script.destroy
  end

  it 'finds a Script by ID' do
    script = client.script(@script.id)
    expect(script).to eq(@script)
  end
end

describe Helium::Client, '#create_library' do
  let(:client) { Helium::Client.new(api_key: API_KEY) }

  use_cassette 'helium_scripts/create_library'

  before(:each) do
    @lib = client.create_library('test.lua', '-- Test Library')
  end

  after(:each) do
    @lib.destroy
  end

  it 'creates a new Library' do
    expect(@lib).to be_a(Helium::Library)
    expect(@lib.name).to eq('test.lua')
    expect(@lib).to respond_to(:id)
  end

end

describe Helium::Client, '#libraries' do
  let(:client) { Helium::Client.new(api_key: API_KEY) }

  use_cassette 'helium_scripts/libraries'

  before(:each) do
    @lib = client.create_library('test.lua', '-- Test Library')
  end

  after(:each) do
    @lib.destroy
  end

  it 'is a Collection of Libraries' do
    libs = client.libraries
    expect(libs).to be_a(Helium::Collection)
    expect(libs.first).to be_a(Helium::Library)
  end
end

describe Helium::Client, '#library' do
  let(:client) { Helium::Client.new(api_key: API_KEY) }

  use_cassette 'helium_scripts/library'

  before(:each) do
    @lib = client.create_library('test.lua', '-- Test Library')
  end

  after(:each) do
    @lib.destroy
  end

  it 'finds a Library by ID' do
    lib = client.library(@lib.id)
    expect(lib).to eq(@lib)
  end
end


describe Helium::Client, '#create_package' do
  let(:client) { Helium::Client.new(api_key: API_KEY) }

  use_cassette 'helium_scripts/create_package'

  before(:each) do
    @script = client.create_script('script.lua', '-- Test Script')
    @lib = client.create_library('lib.lua', '-- Test Library')
    @package = client.create_package(@script, [@lib], 'test package')
  end

  after(:each) do
    @package.destroy
    @script.destroy
    @lib.destroy
  end

  it 'creates a new Package' do
    expect(@package).to be_a(Helium::Package)
    expect(@package).to respond_to(:id)
    # [2017-05-18] Bug in the API currently prevents setting name
    pending("API bug prevents setting name")
    expect(@package.name).to eq('test package')
  end

end

describe Helium::Client, '#packages' do
  let(:client) { Helium::Client.new(api_key: API_KEY) }

  use_cassette 'helium_scripts/packages'

  before(:each) do
    @script = client.create_script('script.lua', '-- Test Script')
    @lib = client.create_library('lib.lua', '-- Test Library')
    @package = client.create_package(@script, [@lib], 'test package')
  end

  after(:each) do
    @package.destroy
    @script.destroy
    @lib.destroy
  end

  it 'is a Collection of Packages' do
    packages = client.packages
    expect(packages).to be_a(Helium::Collection)
    expect(packages.first).to be_a(Helium::Package)
  end
end

describe Helium::Client, '#package' do
  let(:client) { Helium::Client.new(api_key: API_KEY) }

  use_cassette 'helium_scripts/package'

  before(:each) do
    @script = client.create_script('script.lua', '-- Test Script')
    @lib = client.create_library('lib.lua', '-- Test Library')
    @package = client.create_package(@script, [@lib], 'test package')
  end

  after(:each) do
    @package.destroy
    @script.destroy
    @lib.destroy
  end

  it 'finds a Package by ID' do
    package = client.package(@package.id)
    expect(package).to eq(@package)
  end
end

describe Helium::Client, '#create_sensor_package' do
  let(:client) { Helium::Client.new(api_key: API_KEY) }

  use_cassette 'helium_scripts/create_sensor_package'

  before(:each) do
    @script = client.create_script('script.lua', '-- Test Script')
    @lib = client.create_library('lib.lua', '-- Test Library')
    @package = client.create_package(@script, [@lib], 'test package')
    @sensor = client.sensor('7132021b-d7ff-4a61-a014-c99b77810ff4')
    @sensor_package = client.create_sensor_package(@sensor, @package)
  end

  after(:each) do
    @sensor_package.destroy
    @package.destroy
    @script.destroy
    @lib.destroy
  end

  it 'creates a new Sensor Package' do
    expect(@sensor_package).to be_a(Helium::SensorPackage)
    expect(@sensor_package).to respond_to(:id)
  end

end

describe Helium::Client, '#sensor_packages' do
  let(:client) { Helium::Client.new(api_key: API_KEY) }

  use_cassette 'helium_scripts/sensor_packages'

  before(:each) do
    @script = client.create_script('script.lua', '-- Test Script')
    @lib = client.create_library('lib.lua', '-- Test Library')
    @package = client.create_package(@script, [@lib], 'test package')
    @sensor = client.sensor('7132021b-d7ff-4a61-a014-c99b77810ff4')
    @sensor_package = client.create_sensor_package(@sensor, @package)
  end

  after(:each) do
    @sensor_package.destroy
    @package.destroy
    @script.destroy
    @lib.destroy
  end

  it 'is a Collection of Sensor Packages' do
    sensor_packages = client.sensor_packages
    expect(sensor_packages).to be_a(Helium::Collection)
    expect(sensor_packages.first).to be_a(Helium::SensorPackage)
  end
end

describe Helium::Client, '#sensor_package' do
  let(:client) { Helium::Client.new(api_key: API_KEY) }

  use_cassette 'helium_scripts/sensor_package'

  before(:each) do
    @script = client.create_script('script.lua', '-- Test Script')
    @lib = client.create_library('lib.lua', '-- Test Library')
    @package = client.create_package(@script, [@lib], 'test package')
    @sensor = client.sensor('7132021b-d7ff-4a61-a014-c99b77810ff4')
    @sensor_package = client.create_sensor_package(@sensor, @package)
  end

  after(:each) do
    @sensor_package.destroy
    @package.destroy
    @script.destroy
    @lib.destroy
  end

  it 'finds a Sensor Package by ID' do
    sensor_package = client.sensor_package(@sensor_package.id)
    expect(sensor_package).to eq(@sensor_package)
  end
end
