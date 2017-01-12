require 'spec_helper'

describe Entities::Organization do
  describe 'class methods' do
    subject { Entities::Organization }

    it { expect(subject.connec_entity_name).to eql('Organization') }
    it { expect(subject.external_entity_name).to eql('Customer') }
    it { expect(subject.mapper_class).to eql(Entities::Organization::OrganizationMapper) }
    it { expect(subject.object_name_from_connec_entity_hash({'name' => 'Robert'})).to eql('Robert') }
    it { expect(subject.object_name_from_external_entity_hash({'first_name' => 'Robert', 'last_name' => 'Patinson'})).to eql('Robert Patinson') }
  end

  describe 'instance methods' do
    let!(:organization) { create(:organization) }
    subject { Entities::Organization.new(organization,nil,nil) }

    describe 'connec_model_to_external_model' do

      let(:connec_hash) {
        {
            name: 'Patinson',
            address: {
                billing: {
                    line1: 'line1',
                    line2: 'line2',
                    city: 'city',
                    region: 'region',
                    postal_code: 'postal_code',
                    country: 'Country Name'
                }
            },
            phone: {
              landline: '0208 111 222 33'
            },
            email: {
                address: 'robert.patinson@touilaight.com'
            }
          }
        }

      let(:external_hash) {
        {
            id: 'id',
            last_name: 'Patinson',
            default_address: {
              address1: "line1",
              address2: "line2",
              city: "city",
              province: "region",
              zip: "postal_code",
              country: "Country Name",
              phone: "0208 111 222 33"
            },
            addresses: [
              {
                address1: 'line1',
                address2: 'line2',
                city: 'city',
                phone: '0208 111 222 33',
                province: 'region',
                zip: 'postal_code',
                country: 'country name',
              }
            ],
            email: 'robert.patinson@touilaight.com'
        }
      }

      it { expect(subject.map_to_connec(external_hash.with_indifferent_access)).to eql(connec_hash.merge({id:[{id:'id', provider: organization.oauth_provider, realm: organization.oauth_uid}]}).with_indifferent_access) }
      it { expect(subject.map_to_external(connec_hash.with_indifferent_access)).to eql(external_hash.with_indifferent_access.except(:id)) }

      context 'with company' do
        before do
            external_hash[:default_address].merge!(company: 'Pty Ltd')
        end

      end
    end


  end
end
