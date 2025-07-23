class UserMailer < ApplicationMailer
    def reset_password_email(user)
      @user = user
      @token = @user.reset_password_token
      mail(
        to: @user.email,
        subject: 'パスワード再設定のご案内'
      )
    end
  end
  