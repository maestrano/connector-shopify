class Entities::Organization < Maestrano::Connector::Rails::Entity

  def self.connec_entity_name
    'Organization'
  end

  def self.external_entity_name
    'Customer'
  end

  def self.mapper_class
    OrganizationMapper
  end

  def self.object_name_from_connec_entity_hash(entity)
    entity['name']
  end

  def self.object_name_from_external_entity_hash(entity)
    "#{entity['first_name']} #{entity['last_name']}"
  end

  def self.references
    {
      record_references: %w(),
      id_references: %W(lines/id)
    }

  end

  class OrganizationMapper
    extend HashMapper
    # normalize from Connec to Shopify
    # denormalize from Shopify to Connec
    # map from (connect_field) to (shopify_field)

    after_denormalize do |input, output|
      if input['default_address'] && !input['default_address']['company'].blank?
        output[:name] = input['default_address']['company']
      else
        output[:name] = "#{input['first_name']} #{input['last_name']}".strip
      end

      output
    end

    map from('name'), to('last_name')

    map from('address/billing/line1'), to('default_address/address1')
    map from('address/billing/line2'), to('default_address/address2')
    map from('address/billing/city'), to('default_address/city')
    map from('address/billing/region'), to('default_address/province')
    map from('address/billing/postal_code'), to('default_address/zip')
    map from('address/billing/country'), to('default_address/country')

    map from('email/address'), to('email')
    map from('phone/landline'), to('default_address/phone')

    after_normalize do |input, output|

      address1 = {
        address1: input['address']['billing']['line1'],
        address2: input['address']['billing']['line2'],
        city: input['address']['billing']['city'],
        phone: input['phone']['landline'],
        province: input['address']['billing']['region'],
        zip: input['address']['billing']['postal_code'],
        country: input['address']['billing']['country']&.downcase
      } if input['address']['billing']

      address2 = {
        address1: input['address']['billing2']['line1'],
        address2: input['address']['billing2']['line2'],
        city: input['address']['billing2']['city'],
        phone: input['phone']['landline'],
        province: input['address']['billing2']['region'],
        zip: input['address']['billing2']['postal_code'],
        country: input['address']['billing2']['country']&.downcase
      } if input['address']['billing2']

      address3 = {
        address1: input['address']['shipping']['line1'],
        address2: input['address']['shipping']['line2'],
        city: input['address']['shipping']['city'],
        phone: input['phone']['landline2'],
        province: input['address']['shipping']['region'],
        zip: input['address']['shipping']['postal_code'],
        country: input['address']['shipping']['country']&.downcase
      } if input['address']['shipping']

      address4 = {
        address1: input['address']['shipping2']['line1'],
        address2: input['address']['shipping2']['line2'],
        city: input['address']['shipping2']['city'],
        phone: input['phone']['landline2'],
        province: input['address']['shipping2']['region'],
        zip: input['address']['shipping2']['postal_code'],
        country: input['address']['shipping2']['country']&.downcase
      } if input['address']['shipping2']

      output[:addresses] = [address1, address2, address3, address4].compact

      output
    end

  end
end
