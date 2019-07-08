class WebhooksController < ApplicationController

  skip_before_action :verify_authenticity_token
  before_action :verify_request

  def receive
    # to avoid too much traffic we are filtering webhooks that have been updated
    # in the last 10 seconds
    return head 200, content_type: 'application/json' if webhook_newly_updated?

    org_uid = params[:org_uid]
    organization = Maestrano::Connector::Rails::Organization.find_by_uid(org_uid)

    return render_org_not_found(org_uid) unless organization
    return render_org_not_linked(organization) unless organization.oauth_uid

    Maestrano::Connector::Rails::ConnectorLogger.log('debug', organization, "WebhooksController.receive with params:#{webhook_params}")

    if (params[:entity] == 'products')
      entity_name = 'variants'
      entities = Entities::Item.get_product_variants webhook_params
    else
      entity_name = params[:entity]
      entities = [webhook_params]
    end

    if (entity_name == 'orders')
      # transactions are not sent via webhooks, we need to manually retrieve them
      # webhook_params is read-only, we need to make a copy to add 'transactions'
      order = webhook_params.to_hash
      client = Maestrano::Connector::Rails::External.get_client organization
      transactions = Entities::SubEntities::Order.get_order_transactions client, order
      order['transactions'] = transactions
      entities_hash = {'Order' => [order]}
    else
      entities_hash = {entity_name.singularize.capitalize => entities}
    end

    Maestrano::Connector::Rails::PushToConnecWorker.perform_async(organization.id, entities_hash)

    head 200, content_type: 'application/json'
  end

  private
    def webhook_params
      params.except(:controller, :action, :type)
    end

    def webhook_type
      params[:type]
    end

    def verify_request
      data = request.raw_post
      return head :unauthorized unless hmac_valid?(data)
    end

    def hmac_valid?(data)
      secret = ENV['shopify_api_key']
      digest = OpenSSL::Digest.new('sha256')
      ActiveSupport::SecurityUtils.variable_size_secure_compare(
        shopify_hmac,
        Base64.encode64(OpenSSL::HMAC.digest(digest, secret, data)).strip
      )
    end

    def shop_domain
      request.headers['HTTP_X_SHOPIFY_SHOP_DOMAIN']
    end

    def shopify_hmac
      request.headers['HTTP_X_SHOPIFY_HMAC_SHA256']
    end

    def webhook_newly_updated?
      return unless entity_exists = Maestrano::Connector::Rails::IdMap.find_by(external_id: params[:id])
      Time.parse(params[:updated_at]).utc < entity_exists.updated_at.utc + 10
    end

    def render_org_not_found(org_uid)
      Maestrano::Connector::Rails::ConnectorLogger.log('debug', nil, "WebhooksController.receive: organization not found: #{org_uid}")
      head 200, content_type: 'application/json'
    end

    def render_org_not_linked(organization)
      Maestrano::Connector::Rails::ConnectorLogger.log('debug', organization, "WebhooksController.receive: account not linked: #{organization.org_uid}")
      head 200, content_type: 'application/json'
    end
end
