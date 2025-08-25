# frozen_string_literal: true
Rails.application.routes.draw do
  resources :abitrary_photos, only: [:show]

  namespace :api do
    namespace :v1, defaults: { format: :jsonapi } do
      resources :users, only: [:index, :show, :create, :update]
      resources :mangas
      resources :translations
      resources :titles
      resources :chapters do
        member do
          patch 'increment'
        end
      end
      resources :readings, only: [:show]
      resources :chapter_listings, only: [:show]
      resources :notification_read_alls, only: :create
      resources :pages
      resources :authors
      resources :teams
      resources :categories
      resources :comments
      resources :notifications
      resources :users_follow_mangas
      resources :web_push_endpoints do
        collection do
          post 'trigger_demo'
        end
      end

      # Directupload endpoints
      post '/upload/image', to: 'upload#image'
      post '/upload/cover', to: 'upload#cover'
      post '/upload/panorama', to: 'upload#panorama'

      # Sessions
      post '/login', to: 'sessions#login'
      delete '/logout', to: 'sessions#logout'
      get '/geo', to: 'sessions#geo'
    end

    namespace :v2, defaults: { format: :json } do
      get '/home_a', to: 'special_pages#home_a'
      post '/login', to: 'sessions#login'
      delete '/logout', to: 'sessions#logout'
      get '/geo', to: 'sessions#geo'
      post '/register', to: 'users#create'
      post '/request_reset_password', to: 'users#request_reset_password'
      post '/reset_password', to: 'users#reset_password'
      post '/change_password', to: 'users#change_password'
      get '/generate_captcha', to: 'captchas#generate'
      get '/get_team_by_slug/:slug', to: 'teams#get_team_by_slug'
      post '/commit_views', to: 'chapters#commit_views'

      resources :banking_orders, only: [:show, :create]
      resources :donations, only: [:index]

      resource :user, only: [:show]

      resources :abitrary_photos, only: [:show, :create]

      resources :mangas, only: [:show] do
        collection do
          get 'search'
          get 'quick_search'
          get 'spotlight'
          get 'recently_updated'
          get 'top'
          get 'suggested'
          get 'suggested_a'
          get 'following'
        end

        member do
          post 'follow'
          delete 'unfollow'
        end

        resources :chapters, only: [:index]
      end

      resources :chapters, only: [:show] do
        member do
          patch 'increment'
        end

        resources :comments, only: [:index, :create], module: :chapters
      end

      resources :team_posts, only: [] do
        resources :comments, only: [:index, :create], module: :team_posts
      end

      resources :comments, only: [:destroy] do
        member do
          delete 'remove'
        end
      end

      resources :teams, only: [:show] do
        collection do
          get 'top'
        end

        resources :team_posts, only: [:index, :show]

        resources :mangas, only: [] do
          collection do
            get 'recently_updated'
            get 'top'
          end
        end
      end

      resources :notifications do
        member do
          post 'mark_as_read'
        end

        collection do
          post 'mark_all_as_read'
          get 'unread_count'
        end
      end

      resources :tags, only: [:show], param: :slug do
        collection do
          get 'popular'
          get 'search'
        end
      end

      namespace :team_manage do
        scope '/:team_id' do
          resource :team, only: [:show, :update]

          resources :team_posts

          resources :users, only: [] do
            collection do
              get 'search'
            end
          end

          resources :notifications do
            member do
              post 'mark_as_read'
            end

            collection do
              post 'mark_all_as_read'
              get 'unread_count'
            end
          end

          resources :mangas, only: [:index, :show, :create, :update, :destroy] do
            member do
              patch 'change_chapters_order'
            end
            resources :chapters, only: [:index, :create] do
              collection do
                post 'sort'
              end
            end
          end

          resources :chapters, only: [:show, :update, :destroy]
        end
      end

      namespace :admin_manage do
        resources :teams, only: [:index, :create]

        resources :users, only: [:index, :show, :update] do
          collection do
            get "search"
          end

          member do
            post "ban"
            post "unban"
          end
        end

        resources :mangas, only: [:index, :show, :update]
        resources :donations
      end

      # Directupload endpoints
      post '/upload/image', to: 'upload#image'
      post '/upload/cover', to: 'upload#cover'
      post '/upload/panorama', to: 'upload#panorama'
      post '/upload/abitrary_photo', to: 'upload#abitrary_photo'
      post '/upload/avatar', to: 'upload#avatar'

      post '/webhooks/sepay_payment', to: 'webhooks#sepay_payment'
      post '/webhooks/sepay_spend', to: 'webhooks#sepay_spend'
    end
  end
end
