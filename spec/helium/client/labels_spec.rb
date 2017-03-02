require 'spec_helper'

describe Helium::Client, '#labels' do
  let(:client) { Helium::Client.new(api_key: API_KEY) }
  let(:labels) { client.labels }

  use_cassette 'labels/index'

  it 'is a Collection' do
    expect(labels).to be_a(Helium::Collection)
  end

  it 'returns all labels associated with the current org' do
    expect(labels.count).to eq(9)
  end
end

describe Helium::Client, "#label" do
  let(:client) { Helium::Client.new(api_key: API_KEY) }
  let(:label) { client.label("d85ae875-1d02-4ed1-84f3-c5949bcda1d9") }

  use_cassette 'labels/show'

  it 'is a Label' do
    expect(label).to be_a(Helium::Label)
  end

  it 'has an id' do
    expect(label.id).to eq("d85ae875-1d02-4ed1-84f3-c5949bcda1d9")
  end

  it 'has a name' do
    expect(label.name).to eq("The Isotopes")
  end
end

describe Helium::Client, '#new_label' do
  let(:client) { Helium::Client.new(api_key: API_KEY) }
  use_cassette 'labels/create'

  it 'creates a new label' do
    new_label = client.create_label(name: "A Test Label")
    expect(new_label).to be_a(Helium::Label)
    expect(new_label.name).to eq("A Test Label")

    # verify it's now in the org's labels
    all_labels = client.labels
    new_labels = all_labels.select{ |s| s.name == "A Test Label" }
    expect(new_labels.count).to eq(1)
  end
end

describe Helium::Client, '#update_label' do
  let(:client) { Helium::Client.new(api_key: API_KEY) }
  use_cassette 'labels/update'

  it 'updates a label' do
    # create a new label to update
    new_label = client.create_label(name: "A Test Label")

    updated_label = new_label.update(name: "An Updated Label")
    expect(updated_label.name).to eq("An Updated Label")

    # fetch it again just to make sure
    fetched_label = client.label(new_label.id)
    expect(fetched_label.name).to eq("An Updated Label")
  end
end

describe Helium::Client, '#delete_label' do
  let(:client) { Helium::Client.new(api_key: API_KEY) }
  use_cassette 'labels/destroy'

  it 'destroys a label' do
    # create a new label to destroy
    new_label = client.create_label(name: "A Test Label")

    # make sure it's in the org labels first
    all_labels = client.labels
    new_labels = all_labels.select{ |s| s.name == "A Test Label" }

    expect(new_labels.count).to eq(1)
    label = new_labels.first

    # deleting should return 204 code
    expect(label.destroy).to eq(true)

    # verify it's no longer in the org's labels
    all_labels = client.labels
    new_labels = all_labels.select{ |s| s.name == "A Test Label" }
    expect(new_labels.count).to eq(0)
  end
end
