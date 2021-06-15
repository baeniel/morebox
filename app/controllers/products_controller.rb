require "browser"

class ProductsController < ApplicationController
  before_filter :redirect_to_http

  def marketing
    sign_out
    @browser = Browser.new(request.env["HTTP_USER_AGENT"])
  end

  private

  def redirect_to_http
    redirect_to :protocol => "http://"
  end
end
