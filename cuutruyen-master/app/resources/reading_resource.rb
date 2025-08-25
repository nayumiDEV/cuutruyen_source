# frozen_string_literal: true
class ReadingResource < ApplicationResource
  self.model = Chapter
  self.type = :readings

  attribute :pages, :string, only: [:readable] do
    ua = context.request.user_agent
    if ua && (ua.include?('CPU OS 12') || ua.include?('CPU iPhone OS 12'))
      Rails.cache.fetch(['v5', @object, :pages, :no_drm]) do
        @object.pages.order(:order).map.with_index{|page, index|
          {
            id: page.id,
            order: page.order,
            index: index,
            imageNormalUrl: page.image(:normal)&.url,
            width: page.image(:normal)&.width,
            height: page.image(:normal)&.height,
            status: page.status,
            isDrm: false,
          }
        }.to_json
      end
    else
      Rails.cache.fetch(['v5', @object, :pages]) do
        @object.pages.order(:order).map.with_index{|page, index|
          {
            id: page.id,
            order: page.order,
            index: index,
            imageUrl: page.image(:scrambled)&.url,
            width: page.image(:normal)&.width,
            height: page.image(:normal)&.height,
            status: page.status,
            isDrm: true,
            drmData: page.drm_data
          }
        }.to_json
      end
    end
  end

  def base_scope
    Pundit.policy_scope(current_user, Chapter.kept)
  end
end
