class GroupsController < ApplicationController
  before_action :find_group, only: [:show, :edit, :update, :destroy, :invite]
  before_action :find_accepted_true, :find_accepted_false, only: [:delete_my_group, :update_my_group]
  before_action :find_accepted_all, only: [:update_my_group]

  def accepted?
    @accepted_true.accepted
  end

  def my_groups
    @groups = current_user.groups
  end

  def update_my_group
    @accepted_false.accepted = true
    if @accepted_false.save
      redirect_to @accepted_false.group
    else
      redirect_to '/'
    end
  end

  def delete_my_group
    if @accepted_true && accepted?
      @accepted_true.destroy
      lunch_pick = current_user.lunch_picks.find_by(group_id: params[:id])
      lunch_pick && lunch_pick.destroy
      redirect_to '/'
    else
      @accepted_false.destroy
      redirect_to '/'
    end
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
    @pick_lunch_statuses = []
    @user_names = []
    @user_acceptances = []
    @lunch_picks = []

    @groups_users.each do |groups_user|
      @user_names << groups_user.user.name
      @user_acceptances << groups_user.accepted
    end

    @groups_users.each do |groups_user|
      lunch_pick = groups_user.user.lunch_picks.find_by(group_id: @group.id)
      @lunch_picks << lunch_pick
      @pick_lunch_statuses << (current_user.lunch_picks.where(group_id: @group.id).empty? && !lunch_pick && current_user == groups_user.user)
    end
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
      @name = params["/groups/#{params[:id]}"]['name']
      @email = params["/groups/#{params[:id]}"]['email']
    @user = User.where(email: @email)

    if @user.any? && !current_user
      @groups_user = GroupsUser.new(group_id: params[:id], user_id: @user.first.id, sender: current_user.name, notice: true)
      if @groups_user.save
        redirect_to @group, notice: "You successfully invited #{@user.first.name}"
      end
    elsif !@user.any?
      User.invite!(:email => @email, :name => @name)
      redirect_to @group, notice: "An invitation has been sent to #{@email}"
    else
      flash[:error] = 'Invite was unsuccessful'
      redirect_to @group
    end
  end

  private

  def find_group
    @group = Group.find(params[:id])
  end

  def find_accepted_true
    @accepted_true = current_user.groups_users.where(accepted: true).last
  end

  def find_accepted_false
    @accepted_false = current_user.groups_users.where(accepted: false).last
  end

  def find_accepted_all
    @accepted_all = current_user.groups_users.where(accepted: false)
  end

  def group_params
    params.require(:group).permit(:name)
  end
end
