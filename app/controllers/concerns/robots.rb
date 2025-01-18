module Robots
  extend ActiveSupport::Concern

  def robots(value = "all")
    response.headers["X-Robots-Tag"] = value
  end

  def norobot
    robots("noindex,nofollow")
  end
end
