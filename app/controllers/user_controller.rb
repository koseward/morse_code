class UserController < ApplicationController
  allow_unauthenticated_access
  # before_action :set_user_by_token, only: %i[ edit update ]

  def new
  end

  def create
    if user = User.new(user_params)
      PasswordsMailer.reset(user).deliver_later
    end

    redirect_to new_session_path, notice: "Password reset instructions sent (if user with that email address exists)."
  end

  def edit
  end

  def update
  end

  private
    def user_params
        params.expect(user: [ :email_address, :password, :password_confirmation ])
    end
end
