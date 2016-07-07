class Entities::Payment < Maestrano::Connector::Rails::ComplexEntity
  def self.connec_entities_names
    %w(Payment Opportunity)
  end

  def self.external_entities_names
    %w(Transaction)
  end
#   # input :  {
#   #             connec_entity_names[0]: [unmapped_connec_entitiy1, unmapped_connec_entitiy2],
#   #             connec_entity_names[1]: [unmapped_connec_entitiy3, unmapped_connec_entitiy4]
#   #          }
#   # output : {
#   #             connec_entity_names[0]: {
#   #               external_entities_names[0]: [unmapped_connec_entitiy1, unmapped_connec_entitiy2]
#   #             },
#   #             connec_entity_names[1]: {
#   #               external_entities_names[0]: [unmapped_connec_entitiy3],
#   #               external_entities_names[1]: [unmapped_connec_entitiy4]
#   #             }
#   #          }

  def connec_model_to_external_model(connec_hash_of_entities)
    {
        'Payment' => {'Transaction' => connec_hash_of_entities['Payment']}
    }
  end

#   # input :  {
#   #             external_entities_names[0]: [unmapped_external_entity1, unmapped_external_entity2],
#   #             external_entities_names[1]: [unmapped_external_entity3, unmapped_external_entity4]
#   #          }
#   # output : {
#   #             external_entities_names[0]: {
#   #               connec_entity_names[0]: [unmapped_external_entity1],
#   #               connec_entity_names[1]: [unmapped_external_entity2]
#   #             },
#   #             external_entities_names[1]: {
#   #               connec_entity_names[0]: [unmapped_external_entity3, unmapped_external_entity4]
#   #             }
#   #           }
  def external_model_to_connec_model(external_hash_of_entities)
    payments = external_hash_of_entities['Transaction']
    {
        'Transaction' => {'Payment' => payments, 'Opportunity' => payments}
    }
  end
end
