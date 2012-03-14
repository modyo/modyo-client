Rails.application.routes.draw do
  get "callback" => "modyo/modyo#callback" , :as => :callback
  get "modyo" => "modyo/modyo#create", :as => :modyo		
end
