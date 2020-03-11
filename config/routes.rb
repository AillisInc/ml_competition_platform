# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users
  root to: 'competitions#index'

  resource :account, only: %i[edit update]
  resources :competitions, shallow: true do
    resources :competition_versions, shallow: true do
      resources :predict_logs do
        get 'sort', on: :collection
      end
    end
  end
end
