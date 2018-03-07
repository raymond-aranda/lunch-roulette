class GroupsController < ApplicationController
  before_action :find_group, only: [:show, :edit, :update, :destroy, :invite]
  before_action :find_accepted_row, only: [:delete_my_group, :update_my_group]
  before_action :find_accepted_all, only: [:update_my_group]

  def my_groups
    @groups = current_user.groups
  end

  def update_my_group
    @accepted_row.accepted = true
    @accepted_row.save
    @accepted_true = current_user.groups_users.where(accepted: true).last

    if @accepted_all.count == 0
      redirect_to @accepted_true.group
    else
      redirect_to '/'
    end
  end

  def delete_my_group
    @accepted_row.destroy
    redirect_to '/'
  end

  def new
    @group = Group.new
  end

  def create
    @group = Group.new(group_params)
    @group.save
    current_user.groups << @group
    @groups_user = GroupsUser.last
    @groups_user.accepted = true
    current_user.save
    @groups_user.save
    redirect_to groups_users_path
  end

  def show
    @groups_users = GroupsUser.where(group_id: params[:id])
    # @restaraunts = []
    # @lunch_picks = Group.where(id: params[:id]).last.lunch_picks
    # @lunch_picks.each do |lunch_pick|
    #   @restaraunts << lunch_pick.restaurant
    # end
  end

  def edit
  end

  def update
    @group.update(group_params)
    redirect_to groups_users_path
  end

  def destroy
    @groups_user = current_user.groups_users.where(group_id: params[:id]).last
    @group.destroy
    @groups_user.destroy
    redirect_to groups_users_path
  end

  def invite
    @email = params["/groups/#{params[:id]}"].first
    @user = User.where(email: @email)

    if @user.any?
      @groups_user = GroupsUser.new(group_id: params[:id], user_id: @user.first.id, sender: current_user.name, notice: true)
      if @groups_user.save
        redirect_to @group, notice: "You successfully invited #{@user.first.name}"
      end
    else
      redirect_to @group, notice: 'Email not found.'
    end
  end

  private

  def find_group
    @group = Group.find(params[:id])
  end

  def find_accepted_row
    @accepted_row = current_user.groups_users.where(accepted: false).last
  end

  def find_accepted_all
    @accepted_all = current_user.groups_users.where(accepted: false)
  end

  def group_params
    params.require(:group).permit(:name)
  end
end
