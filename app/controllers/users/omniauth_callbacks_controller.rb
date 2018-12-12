class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  
  def vkontakte
    if request.env["omniauth.auth"].info.email.nil?
      flash[:notice] = "WTF?!?!?!? WE NEED YOU EMAIL"
      redirect_to root_path and return true
    else
      @user = User.from_omniauth(request.env["omniauth.auth"])
    end

    if @user.persisted?
      flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => "Vkontakte"
      sign_in_and_redirect @user, :event => :authentication
    else
      flash[:notice] = "authentication error"
      redirect_to root_path
    end
    
  end
end
