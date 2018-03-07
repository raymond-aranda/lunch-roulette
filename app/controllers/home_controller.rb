class HomeController < ApplicationController
  before_action :find_accepted_all, only: [:index, :invitation]
  before_action :find_accepted_row
  before_action :invitation

  def index
  end

  def notice?
    current_user.groups_users.first.notice
  end

  def accepted?
    @accepted_row.accepted
  end

  private

  def invitation
    return unless @accepted_all.any?
    @sender = @accepted_row.sender
    @group = @accepted_row.group
    if notice? && !accepted?
      flash[:invitation] = "#{@sender} invited you to #{@group.name}.</a>".html_safe
    end
  end

  private

  def find_accepted_row
    @accepted_row = current_user.groups_users.where(accepted: false).last
  end

  def find_accepted_all
    @accepted_all = current_user.groups_users.where(accepted: false)
  end
end
