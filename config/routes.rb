Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: 'registrations', invitations: 'users/invitations' }
  root to: 'home#index'

  get '/mygroups', to: 'groups#my_groups', as: 'groups_users'
  put '/mygroups/:id', to: 'groups#update_my_group', as: 'accept'
  delete '/mygroups/:id', to: 'groups#delete_my_group', as: 'decline'
  post '/groups/:id', to: 'groups#invite', as: 'invite'
  get '/groups/:id/filters', to: 'lunch_picks#filters', as: 'filters'
  post '/groups/:id/filters', to: 'lunch_picks#post_filters', as: 'post_filters'

  resources :groups do
    resources :lunch_picks
  end
end
