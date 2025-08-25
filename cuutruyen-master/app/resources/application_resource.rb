# frozen_string_literal: true
class ApplicationResource < Graphiti::Resource
  self.abstract_class = true
  self.adapter = Graphiti::Adapters::ActiveRecord
  self.base_url = Rails.application.routes.default_url_options[:host]
  self.endpoint_namespace = '/api/v1'

  ####
  # I don't use before_create here because before_create trigger
  # even when belongs_to relationship failed the validation, messing with
  # the authorization.
  ####
  before_save only: [:create] do |model|
    authorize(model, :create?) if model.changed? && model.valid?
  end

  before_save only: [:update] do |model|
    authorize(model, :update?) if model.changed? && model.valid?
  end

  before_destroy do |model|
    authorize(model, :destroy?)
  end

  def current_user
    context&.current_user
  end

  def authorize(model, query = nil)
    policy = Pundit.policy(current_user, model)
    unless policy.public_send(query)
      raise Pundit::NotAuthorizedError, query: query, record: model, policy: policy
    end
  end
end
