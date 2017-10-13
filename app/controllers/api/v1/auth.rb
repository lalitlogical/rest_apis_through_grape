module API
  module V1
    class Auth < Grape::API
      include API::V1::Defaults

      resource :auth do
        desc "Register new user"
        params do
          requires :user, type: Hash do
            requires :first_name, type: String, desc: "First Name", allow_blank: false
            optional :last_name, type: String, desc: "Last Name"
            requires :email, type: String, desc: "Email address", allow_blank: false
            requires :password, type: String, desc: "Password", allow_blank: false
            requires :password_confirmation, type: String, desc: "Password Confirmation", allow_blank: false
          end
        end
        post :register do
          @user = User.new(params[:user])
          @user.access_token = User.generate_key
          if @user.save
            @user
          else
            error!(@user.errors.full_messages, 403)
          end
        end

        desc "Creates and returns user with access token if valid login"
        params do
          requires :user, type: Hash do
            requires :email, type: String, desc: "Email address", allow_blank: false
            requires :password, type: String, desc: "Password", allow_blank: false
          end
        end
        post :login do
          user = User.find_by(email: params[:user][:email].downcase)
          if user && user.valid_password?(params[:user][:password])
            user.update(access_token: User.generate_key)
            user
          else
            error!('Invalid email or password.', 401)
          end
        end

        desc "Returns pong if logged in correctly"
        params do
          requires :user_id, type: String, desc: "User Id"
          requires :access_token, type: String, desc: "Access token"
        end
        get :ping do
          authenticate!
          { message: "pong" }
        end
      end
    end
  end
end
