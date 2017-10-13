module API
  module V1
    class Comments < Grape::API
      include API::V1::Defaults

      resource :comments do
        before do
          authenticate!
        end

        desc "Return all comments"
        params do
          requires :user_id, type: String, desc: "User Id"
          requires :access_token, type: String, desc: "Access token"
          requires :post_id, type: String, desc: "ID of the post"
          optional :page, type: Integer, desc: "Page number"
        end
        get "", root: :comments do
          Comment.where(post_id: params[:post_id]).page(params[:page]).per(PER_PAGE)
        end

        desc "Return a comment"
        params do
          requires :user_id, type: String, desc: "User Id"
          requires :access_token, type: String, desc: "Access token"
          requires :id, type: String, desc: "ID of the comment"
        end
        get ":id", root: "comment" do
          Comment.where(id: permitted_params[:id]).first || raise(CustomError::RecordNotFound)
        end

        desc "Create a comment"
        params do
          requires :user_id, type: String, desc: "User Id"
          requires :access_token, type: String, desc: "Access token"
          requires :comment, type: Hash do
            requires :post_id, type: String, desc: "ID of the post"
            requires :message, type: String, desc: "Title of the comment"
          end
        end
        post "", root: "comment" do
          @comment = Comment.new(params[:comment])
          @comment.user = @current_user
          if @comment.save
            @comment
          else
            error!(@comment.errors.full_messages, 403)
          end
        end

        desc "Update a comment"
        params do
          requires :user_id, type: String, desc: "User Id"
          requires :access_token, type: String, desc: "Access token"
          requires :id, type: String, desc: "ID of the comment"
          requires :comment, type: Hash do
            requires :message, type: String, desc: "Title of the comment"
            optional :like, type: Integer, desc: "Like of the comment"
          end
        end
        post ":id", root: "comment" do
          comment = Comment.where(id: permitted_params[:id]) || raise(CustomError::RecordNotFound)
          comment.update(params[:comment]) if comment.present?
          comment
        end

        desc "Destoy a comment"
        params do
          requires :user_id, type: String, desc: "User Id"
          requires :access_token, type: String, desc: "Access token"
          requires :id, type: String, desc: "ID of the comment"
        end
        delete ":id", root: "comment" do
          comment = Comment.where(id: permitted_params[:id]) || raise(CustomError::RecordNotFound)
          comment.destroy
        end
      end
    end
  end
end
