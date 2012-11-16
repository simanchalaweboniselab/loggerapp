class AdminsController < ApplicationController
  before_filter :should_be_login
  def index

  end
end
