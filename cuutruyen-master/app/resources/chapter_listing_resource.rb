# frozen_string_literal: true
class ChapterListingResource < ApplicationResource
  self.model = Manga
  self.type = :chapter_listings

  attribute :chapters, :string, only: [:readable] do
    Rails.cache.fetch(['v2', @object, :chapters]) do
      translation = @object.translations.first
      if translation.present?
        listing = translation.chapters.kept.order(order: :desc).map.with_index do |chapter, index|
          {
            id: chapter.id,
            order: chapter.order,
            number: chapter.number,
            name: chapter.name,
            viewsCount: chapter.views_count,
            commentsCount: chapter.comments_count,
            status: chapter.status,
            createdAt: chapter.created_at,
            updatedAt: chapter.updated_at
          }
        end

        listing.to_json
      else
        [].to_json
      end
    end
  end

  def base_scope
    Pundit.policy_scope(current_user, Manga.kept)
  end
end
