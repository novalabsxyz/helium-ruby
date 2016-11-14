require 'spec_helper'

describe Helium::Client, '#organization' do
  let(:client) { Helium::Client.new(api_key: API_KEY) }
  let(:organization) { client.organization }

  use_cassette 'organization/get'

  it 'is an Organization' do
    expect(organization).to be_a(Helium::Organization)
  end

  it 'has an id' do
    expect(organization.id).to eq('dev-accounts@helium.co')
  end

  it 'has a name' do
    expect(organization.name).to eq('dev-accounts@helium.co')
  end

  it 'has a timezone' do
    expect(organization.timezone).to eq('UTC')
  end

  it 'has a created_at datetime' do
    expect(organization.created_at).to eq(DateTime.parse("2015-09-10T20:50:18.183896Z"))
  end

  it 'has an updated_at datetime' do
    expect(organization.updated_at).to eq(DateTime.parse("2015-09-10T20:50:18.183896Z"))
  end
end

describe Helium::Organization, '#users' do
  let(:client) { Helium::Client.new(api_key: API_KEY) }
  let(:organization) { client.organization }

  use_cassette 'organization/users'

  it 'returns the Users associated with the organization' do
    users = organization.users
    expect(users).to be_an(Array)
    expect(users).to all( be_a(Helium::User) )
  end

  it 'returns proper Users' do
    user = organization.users.last
    expect(user.name).to eq("HeliumDevAccount Demo")
    expect(user.id).to eq('dev-accounts@helium.co')
  end

  it 'returns pending_invite status' do
    user = organization.users.last
    expect(user.pending_invite).to eq(false)
  end
end

describe Helium::Organization, '#labels' do
  let(:client) { Helium::Client.new(api_key: API_KEY) }
  let(:organization) { client.organization }

  use_cassette 'organization/labels'

  it 'returns the Labels associated with the organization' do
    labels = organization.labels
    expect(labels).to be_an(Array)
    expect(labels).to all( be_a(Helium::Label) )
  end

  it 'returns proper Labels' do
    label = organization.labels.first
    expect(label.name).to eq("SF Office")
    expect(label.id).to eq("ce9aad92-70d0-44a3-9ba4-8bc834d71256")
  end
end

describe Helium::Organization, '#elements' do
  let(:client) { Helium::Client.new(api_key: API_KEY) }
  let(:organization) { client.organization }

  use_cassette 'organization/elements'

  it 'returns the Elements associated with the organization' do
    elements = organization.elements
    expect(elements).to be_an(Array)
    expect(elements).to all( be_a(Helium::Element) )
  end

  it 'returns proper Elements' do
    element = organization.elements.first
    expect(element.name).to eq("Coco's Element")
    expect(element.id).to eq("483e3c7d-8f42-45bc-a21d-c45e02edc80d")
    expect(element.mac).to eq("6081f9fffe0002f0")
  end
end

describe Helium::Organization, '#sensors' do
  let(:client) { Helium::Client.new(api_key: API_KEY) }
  let(:organization) { client.organization }

  use_cassette 'organization/sensors'

  it 'returns the Sensors associated with the organization' do
    sensors = organization.sensors
    expect(sensors).to be_an(Array)
    expect(sensors).to all( be_a(Helium::Sensor) )
  end

  it 'returns proper Sensors' do
    sensor = organization.sensors.first
    expect(sensor.name).to eq("COS MiniDemo Sensor")
    expect(sensor.id).to eq("6d3df343-6620-4e96-b1fc-5fd4141b0a8d")
    expect(sensor.mac).to eq("6081f9fffe000777")
  end
end

describe Helium::Organization, '#update' do
  let(:client) { Helium::Client.new(api_key: API_KEY) }
  let(:organization) { client.organization }

  use_cassette 'organization/update'

  it 'returns an updated org' do
    updated_org = organization.update(timezone: 'US/Pacific')
    expect(updated_org.timezone).to eq('US/Pacific')
  end
end
