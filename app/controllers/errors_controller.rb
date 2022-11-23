class ErrorsController < ApplicationController
  include Robots

  before_action :norobot

  # GET /404
  def missing
    render status: 404
  end

  # GET /422
  def unprocessable
    render status: 422
  end

  # GET /500
  def exception
    render status: 500
  end
end
