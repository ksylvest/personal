class MainController < ApplicationController
  # GET /about
  def about
    http_cache_forever(public: !params[:fresh]) { render }
  end

  # GET /contact
  def contact
    http_cache_forever(public: !params[:fresh]) { render }
  end

  # GET /projects
  def projects
    http_cache_forever(public: !params[:fresh]) { render }
  end

  # GET /portfolio
  def portfolio
    http_cache_forever(public: !params[:fresh]) { render }
  end
end
