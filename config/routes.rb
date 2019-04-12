Rails.application.routes.draw do
  
	resources :users, only: [:new, :create, :show, :index]
	resources :lists, only: [:new, :create, :edit, :update, :destroy]
	resources :tasks, only: [:new, :create, :edit, :update, :destroy]

	resources :sessions, only: [:create]

	get 'login', to: 'sessions#new'
	get 'logout', to: 'sessions#destroy'

	get 'done/:id', to: 'tasks#done', as: 'done'
	get 'in_progress/:id', to: 'tasks#in_progress', as: 'in_progress'
	get 'order_up/:id', to: 'tasks#order_up', as: 'order_up'
	get 'order_down/:id', to: 'tasks#order_down', as: 'order_down'
	get 'show_list_form/:id', to: 'users#show_list_form', as: 'show_list_form'

	root 'users#show'
end