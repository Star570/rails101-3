class GroupsController < ApplicationController
	before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]
	before_action :find_group, only: [:show, :edit, :update, :destroy, :join, :quit]
	before_action :check_permission, only: [:edit, :update, :destroy]

	def index
		@groups = Group.all
	end

	def new
		@group = Group.new
	end

	def create
		@group = Group.new(group_params)
		@group.user = current_user
		if @group.save
			current_user.join!(@group)
			redirect_to groups_path
		else
			render :new
		end
	end

	def show
		@posts = @group.posts.recent.paginate(:page => params[:page], :per_page => 5)
	end

	def edit	
	end

	def update
		if @group.update(group_params)
			redirect_to groups_path, notice: "Update Success"
		else
			render :edit
		end
	end

	def destroy
		@group.destroy
		redirect_to groups_path, alert: "Group deleted" 
	end

	def join
		if !current_user.is_member_of?(@group)
			current_user.join!(@group)
			flash[:notice] = "Succeed to join the group!"
		else
			flash[:warning] = "You have already been the group member!"
		end
		redirect_to group_path(@group)
	end

	def quit
		if current_user.is_member_of?(@group)
			current_user.quit!(@group)
			flash[:alert] = "Quit group!"
		else
			flash[:warning] = "You are not the group member, how to quit XD"
		end
		redirect_to group_path(@group)
	end

	private
	
	def find_group
		@group = Group.find(params[:id])
	end

	def check_permission
		if current_user != @group.user
			redirect_to root_path, alert: "You have no permission."
		end
	end

	def group_params
		params.require(:group).permit(:title, :description)
	end
end
