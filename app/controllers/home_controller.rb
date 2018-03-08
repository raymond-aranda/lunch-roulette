class HomeController < ApplicationController
  before_action :find_accepted_all, only: [:index, :invitation]
  before_action :find_accepted_false
  before_action :invitation

  def index
  end

  def notice?
    current_user.groups_users.last.notice
  end

  private

  def invitation
    return unless @accepted_all.any?
    @sender = @accepted_false.sender
    @group = @accepted_false.group
    if notice? && @accepted_false.accepted == false
      flash[:info] = "#{@sender} invited you to #{@group.name}".html_safe
    end
  end

  private

  def find_accepted_false
    @accepted_false = current_user.groups_users.where(accepted: false).last
  end

  def find_accepted_all
    @accepted_all = current_user.groups_users.where(accepted: false)
  end
end
