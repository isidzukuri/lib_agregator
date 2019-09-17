# frozen_string_literal: true

Library::Engine.routes.draw do
  scope module: 'library' do
    root to: 'home#index'
  end
end
