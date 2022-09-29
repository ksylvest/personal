class ErrorsController < ApplicationController
  include Robots

  before_action :norobot

  # GET /404
  def missing
    http_cache_forever(public: !params[:fresh]) do
      render status: 404
    end
  end

  # GET /422
  def unprocessable
    http_cache_forever(public: !params[:fresh]) do
      render status: 422
    end
  end

  # GET /500
  def exception
    http_cache_forever(public: !params[:fresh]) do
      render status: 500
    end
  end
end
