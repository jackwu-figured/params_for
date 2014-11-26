require 'json'
require 'spec_helper'

describe DummyController, type: :controller do

  describe '.index with valid params' do
    let(:valid_params) { { id: 123, name: 'new_name' } }
    let(:response_data) { JSON.parse(subject.body) }

    before { get :index, valid_params }

    subject { response }

    it { should be_success }
    it { expect(response_data).to include('id') }
    it { expect(response_data['id']).to eql('123') }
    it { expect(response_data).to include('name') }
    it { expect(response_data['name']).to eql('new_name') }
  end

end
