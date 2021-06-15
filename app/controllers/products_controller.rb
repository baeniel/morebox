require "browser"

class ProductsController < ApplicationController

  def marketing
    sign_out
    @browser = Browser.new(request.env["HTTP_USER_AGENT"])
    # redirect_to "http://morebox.co.kr/"
  end
end
