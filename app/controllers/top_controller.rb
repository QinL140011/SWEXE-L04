# app/controllers/top_controller.rb
class TopController < ApplicationController
  def main
    if session[:login_uid].nil?
      render "login"
    else
      render "main"
    end
  end

  def login
    # 基礎課題2をやるときすでに発展課題の仕様に利用しました
    user = User.find_by(uid: params[:uid])

    if user && BCrypt::Password.new(user.pass) == params[:pass]
      session[:login_uid] = user.uid
      redirect_to top_main_path
    else
      @error = "IDまたはパスワードが違います"
      render "error"
    end
  end

  def logout
    session.delete(:login_uid)
    redirect_to top_main_path
  end
end