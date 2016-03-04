require 'spec_helper'

describe Entities::Item do

  describe 'instance methods' do
    subject { Entities::Item.new }

    it { expect(subject.connec_entity_name).to eql('Item') }
    it { expect(subject.external_entity_name).to eql('Product') }
    it { expect(subject.mapper_class).to eql(Entities::Item::ItemMapper) }
    it { expect(subject.object_name_from_connec_entity_hash({'name' => 'the name'})).to eql('the name') }
    it { expect(subject.object_name_from_external_entity_hash({'title' => 'the name'})).to eql('the name') }


    describe 'mapping' do

      let(:connec_hash) {
        {
            name: 'product name',
            description: 'product description',
            variants: [
                {
                    id: 'VARIANT_ID_1',
                    external_id: 'EXTERNAL_ID_1',
                    description: 'red|blue',
                    name: 'name',
                    code: 'code',
                    sale_price: {
                        net_amount: 450
                    },
                    quantity_available: 12,
                    weight: 8,
                    weight_unit: 'lb'
                }
            ]
        }
      }
      let(:external_hash) {
        {
            title: 'product name',
            body_html: 'product description',
            variants: [
                {
                    connec_id: 'VARIANT_ID_1',
                    id: 'EXTERNAL_ID_1',
                    option1: 'red',
                    option2: 'blue',
                    title: 'name',
                    sku: 'code',
                    price: 450,
                    inventory_quantity: 12,
                    weight: 8,
                    weight_unit: 'lb'
                }
            ]
        }
      }

      it { expect(subject.map_to_connec(external_hash.deep_stringify_keys, nil)).to eql(connec_hash) }
      it { expect(subject.map_to_external(connec_hash.deep_stringify_keys, nil)).to eql(external_hash) }
    end
    describe 'group_items_variants' do
      let(:items) { [
          {
              id: 'PARENT_ID_1',
              name: 'product 1',
              description: 'product description 1',
              updated_at: Time.new(1985, 9, 17).iso8601
          },
          {
              id: 'VARIANT_ID_1',
              parent_item_id: 'PARENT_ID_1',
              external_id: 'EXTERNAL_ID_1',
              name: 'name1',
              updated_at: Time.new(1986, 9, 17).iso8601
          },
          {
              id: 'VARIANT_ID_3',
              parent_item_id: 'PARENT_ID_2',
              external_id: 'EXTERNAL_ID_3',
              name: 'name3',
              updated_at: Time.new(1985, 9, 17).iso8601
          },
          {
              id: 'PARENT_ID_2',
              name: 'product 2',
              description: 'product description 2',
              updated_at: Time.new(2000, 9, 17).iso8601
          },
          {
              id: 'VARIANT_ID_2',
              parent_item_id: 'PARENT_ID_1',
              external_id: 'EXTERNAL_ID_2',
              name: 'name2',
              updated_at: Time.new(1987, 9, 17).iso8601
          }]
      }

      let(:item_with_variants) { [
          {
              id: 'PARENT_ID_1',
              name: 'product 1',
              description: 'product description 1',
              updated_at: Time.new(1987, 9, 17).iso8601,
              variants: [
                  {
                      id: 'VARIANT_ID_1',
                      parent_item_id: 'PARENT_ID_1',
                      external_id: 'EXTERNAL_ID_1',
                      name: 'name1',
                      updated_at: Time.new(1986, 9, 17).iso8601
                  },
                  {
                      id: 'VARIANT_ID_2',
                      parent_item_id: 'PARENT_ID_1',
                      external_id: 'EXTERNAL_ID_2',
                      name: 'name2',
                      updated_at: Time.new(1987, 9, 17).iso8601
                  }
              ]
          },
          {
              id: 'PARENT_ID_2',
              name: 'product 2',
              description: 'product description 2',
              updated_at: Time.new(2000, 9, 17).iso8601,
              variants: [
                  {
                      id: 'VARIANT_ID_3',
                      parent_item_id: 'PARENT_ID_2',
                      external_id: 'EXTERNAL_ID_3',
                      name: 'name3',
                      updated_at: Time.new(1985, 9, 17).iso8601
                  }
              ]
          }]
      }
      # group_items_variants is a private method, using send to call it
      # http://stackoverflow.com/questions/16599256/testing-private-method-in-ruby-rspec
      it { expect(subject.send(:group_items_variants,items.map(&:deep_stringify_keys))).to eql(item_with_variants.map(&:deep_stringify_keys)) }
    end
  end
end