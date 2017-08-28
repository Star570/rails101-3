class PostsController < ApplicationController
	before_action :authenticate_user!, :only => [:new, :create, :edit, :update, :destroy]
	before_action :find_group, :only => [:new, :create, :edit, :update, :destroy]
	before_action :find_post, :only => [:edit, :update, :destroy]

	def new
		@post = Post.new
	end

	def create
		@post = Post.new(post_params)
		@post.group = @group
		@post.user = current_user
		if @post.save
			redirect_to group_path(@group)
		else
			render :new
		end
	end

	def edit
	end

	def update
		if @post.update(post_params)
			redirect_to group_path(@group), notice: "Update Seccess"
		else
			render :edit
		end
	end

	def destroy
		@post.destroy
		redirect_to group_path(@group), alert: "Post deleted"
	end



	private
	
	def find_group
		@group = Group.find(params[:group_id])
	end

	def find_post
		@post = Post.find(params[:id])
	end

	def post_params
		params.require(:post).permit(:content)
	end

end
