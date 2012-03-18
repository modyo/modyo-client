Rails.application.routes.draw do
  get "modyo/callback" => "modyo/session#callback"
  get "modyo/login" => "modyo/session#create"
  get "modyo/logout" => "modyo/session#destroy"
end
