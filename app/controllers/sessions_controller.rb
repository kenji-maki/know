class SessionsController < ApplicationController
  #skip_before_action :login_required
  
  def new
    @user = User.new
  end
  
  def create
    user = User.find_by(email: session_params[:email])
    if user && user.authenticate(session_params[:password])
      log_in user
      redirect_to user_path(current_user), success:'ログインに成功しました'
    else
      flash.now[:danger]='ログインに失敗しました'
      render :new
    end
  end

 def destroy
   log_out
   redirect_to root_url, info: 'ログアウトしました'
 end

  private
  def log_in(user)
    session[:user_id] = user.id
  end
  
  def log_out
    session.delete(:user_id)
    @current_user = nil
  end
  
  def session_params
    params.require(:session).permit(:email, :password)
  end
end