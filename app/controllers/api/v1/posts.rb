module API
  module V1
    class Posts < Grape::API
      include API::V1::Defaults

      resource :posts do
        before do
          authenticate!
        end

        desc "Return all posts"
        params do
          requires :user_id, type: String, desc: "User Id"
          requires :access_token, type: String, desc: "Access token"
          optional :page, type: Integer, desc: "Page number"
        end
        get "", root: :posts do
          Post.page(params[:page]).per(PER_PAGE)
        end

        desc "Return a post"
        params do
          requires :user_id, type: String, desc: "User Id"
          requires :access_token, type: String, desc: "Access token"
          requires :id, type: String, desc: "ID of the post"
        end
        get ":id", root: "post" do
          Post.where(id: permitted_params[:id]).first || raise(CustomError::RecordNotFound, 'Record not found!')
        end

        desc "Create a post"
        params do
          requires :user_id, type: String, desc: "User Id"
          requires :access_token, type: String, desc: "Access token"
          requires :post, type: Hash do
            requires :title, type: String, desc: "Title of the post"
            requires :content, type: String, desc: "Content of the post"
          end
        end
        post "", root: "post" do
          @post = Post.new(params[:post])
          @post.user = @current_user
          if @post.save
            @post
          else
            error!(@post.errors.full_messages, 403)
          end
        end

        desc "Update a post"
        params do
          requires :user_id, type: String, desc: "User Id"
          requires :access_token, type: String, desc: "Access token"
          requires :id, type: String, desc: "ID of the post"
          requires :post, type: Hash do
            requires :title, type: String, desc: "Title of the post"
            requires :content, type: String, desc: "Content of the post"
            optional :views, type: String, desc: "Content of the post"
          end
        end
        post ":id", root: "post" do
          post = Post.where(id: permitted_params[:id]) || raise(CustomError::RecordNotFound)
          post.update(params[:post]) if post.present?
          post
        end

        desc "Destoy a post"
        params do
          requires :user_id, type: String, desc: "User Id"
          requires :access_token, type: String, desc: "Access token"
          requires :id, type: String, desc: "ID of the post"
        end
        delete ":id", root: "post" do
          post = Post.where(id: permitted_params[:id]) || raise(CustomError::RecordNotFound)
          post.destroy
        end
      end
    end
  end
end
