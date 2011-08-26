class UsersController < ApplicationController

  before_filter :authenticate, :only => [:index, :edit, :update]
  before_filter :correct_user, :only => [:edit, :update]
  before_filter :admin_user,   :only => :destroy
  
  def index
    @title = "All users"
    @users = User.paginate(:page => params[:page])
  end

  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.paginate(:page => params[:page])
    @title = @user.name
  end

  def new
    @title = "Sign up"
      if !current_user.nil?
        redirect_to root_path
      else
        @user = User.new
      end
  end

  def edit
    @title = "Edit user"
  end

  def create
      @user = User.new(params[:user])
      if @user.save
        sign_in @user
        flash[:success] = "Welcome to the Sample App!"
        redirect_to @user
      else
        @user.password = ""
        @user.password_confirmation = ""
        @title = "Sign up"
        render 'new'
      end
  end

  def update
    if @user.update_attributes(params[:user])
      flash[:success] = "Profile updated."
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    if User.find(params[:id]) == current_user
       flash[:error] = "You can't destroy yourself."
       redirect_to users_path
    else
       User.find(params[:id]).destroy
       flash[:success] = "User destroyed."
       redirect_to users_path
    end
  end


   private


    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_path) unless current_user?(@user)
    end

    def admin_user
      redirect_to(root_path) unless current_user.admin?
    end

end
