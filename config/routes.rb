Rails.application.routes.draw do

  root "home#home"
  
  get "/encyclopedia/vision" =>  "encyclopedia#vision"
  get "/encyclopedia/rules" => "encyclopedia#rules"
  get "/encyclopedia/careers" => "encyclopedia#careers"
  get "/encyclopedia/contact" => "encyclopedia#contact"
  
  get '/join' => "users#new"
  
  get '/newsletter' => "newsletter#newsletter"

  resources :users do
    get '/avatar' => 'users#avatar'
    patch '/updateavatar' => 'users#updateavatar'
    get '/followcommunities' => 'users#followcommunities'
    get '/buildfeed' => 'users#buildfeed'   
    put 'fan' => 'users#fan'
    delete 'unfan' => 'users#unfan'
    get 'notifications' => 'users#notifications'
    get 'activate' => 'users#activate' 
  end
   
  get '/signin' => "sessions#new"
  get '/resetpasswordlogin' => "sessions#new1"  
  post '/signin' => "sessions#create"
  post '/resetpasswordlogin' => "sessions#create"  
  delete '/signout' => "sessions#destroy"
  
  resources :password_resets
  resources :user_activate

  resources :communities do
    resources :posts do
     put "givecoins" => "posts#givecoins"
    end
    put 'follow' => 'communities#follow'
    delete 'unfollow' => 'communities#unfollow'
  end

  resources :posts do
    resources :comments, only: :create
  end

  get 'newpost' => "communities#newpost"
  
  resources :comments do
    post "createresponse" => "comments#createresponse"
    put "givecommentcoins" => "comments#givecommentcoins"
   end

  get '/feed' => "feed#feed"

  get '/searchposts' => "posts#search"
  get '/searchcommunities' => "communities#search"

  get '/404' => 'errors#not_found'
  get '/500' => 'errors#internal_server_error'
  get '/sitemap.xml' => 'sitemaps#index', :format => "xml", :as => :sitemap

end
