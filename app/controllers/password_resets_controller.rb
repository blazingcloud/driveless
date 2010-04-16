class PasswordResetsController < ApplicationController

  before_filter :require_no_user
  before_filter :load_user_using_perishable_token, :only => [:edit, :update]

  def edit
  end

  def index
    render :new
  end

  def create
    @user = User.find_by_email(params[:email])
    if @user
      @user.deliver_password_reset_instructions!
      flash[:notice] = 'Instructions to reset your password have been emailed to you. Please check your mail.'
    else
      flash[:notice] = "User not found."
    end
    redirect_to root_url
  end

  def update
    @user.password = params[:user][:password]
    @user.password_confirmation = params[:user][:password_confirmation]
    if @user.save
      flash[:notice] = "Password Sucessfully Updated!"
      redirect_to root_url
    else
      render :edit
    end
  end

  private

  def load_user_using_perishable_token
    @user = User.find_using_perishable_token(params[:id])
    unless @user
      flash[:notice] = "Account not found"
      redirect_to root_url
    end
  end

end
