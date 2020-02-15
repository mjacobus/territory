# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :require_master_user

  def index
    @users = User.all
  end

  private

  def require_master_user
    unless current_user.master?
      redirect_to('/')
    end
  end
end
