Rails.application.routes.draw do
  default_url_options(Rails.env.production? ? { host: 'ksylvest.com' } : {})

  mount Analytic::Engine, at: '/analytic'

  get 'up', to: 'rails/health#show'

  root to: 'posts#index'

  get '404', to: 'errors#missing', as: :missing
  get '422', to: 'errors#unprocessable', as: :unprocessable
  get '500', to: 'errors#exception', as: :exception

  get 'about', to: 'main#about', as: :about
  get 'contact', to: 'main#contact', as: :contact
  get 'projects', to: 'main#projects', as: :projects
  get 'portfolio', to: 'main#portfolio', as: :portfolio

  resource :feed, only: :show
  resource :archive, only: :show
  resource :sitemap, only: :show

  resource :search, only: %i[show]

  get 'admin', to: 'admin/dashboard#index', as: :admin

  resource :auth, only: %i[create destroy]

  namespace :admin do
    resource :user, only: %i[edit update]
    resource :session, only: %i[new create destroy]
    resources :attachments, only: %i[index new edit update create destroy]
    resources :posts, only: %i[index new edit update create destroy]
    resources :pages, only: %i[index new edit update create destroy]
  end

  get '(tagged/:tag)/(page/:page)', to: 'posts#index', as: :posts

  get 'posts/:segment/:slug', to: 'posts#show', as: :post
  get 'pages/:slug', to: 'pages#show', as: :page

  direct :github do
    'https://github.com/ksylvest'
  end

  direct :twitter do
    'https://twitter.com/ksylvest'
  end

  direct :facebook do
    'https://facebook.com/ksylvest'
  end

  direct :dribbble do
    'https://dribbble.com/ksylvest'
  end

  direct :linkedin do
    'https://www.linkedin.com/in/ksylvest'
  end

  direct :vimeo do
    'https://vimeo.com/ksylvest'
  end

  direct :stackoverflow do
    'https://stackoverflow.com/users/259900/kevin-sylvestre?rel=author'
  end

  %w[wp-login.php].each do |path|
    get path, to: redirect('/')
  end
end
