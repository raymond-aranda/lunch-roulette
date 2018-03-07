require 'httparty'
# dotenv
class LunchPicksController < ApplicationController
  before_action :find_group, except: [:filters, :post_filters]
  before_action :find_yelp_data, only: [:index]

  def index
    @lunch_pick = current_user.lunch_picks.new
  end

  def filters
    @group = Group.find(params[:id])
  end

  def post_filters
    @location = params["/groups/#{params[:id]}/filters"]
  end

  def find_yelp_data
    headers = { 'Authorization' => "Bearer #{Rails.application.secrets.YELP_API_KEY}" }

    url = 'https://api.yelp.com/v3/businesses/search?term=lunch&latitude=41.8804874&longitude=-87.6324572'

    response = HTTParty.get(url, headers: headers)

    @yelp_data = response.parsed_response
  end

  def create
    @lunch_pick = current_user.lunch_picks.new(lunch_pick_params)
    @lunch_pick.save
    redirect_to @group
  end

  def destroy
    @lunch_pick = current_user.lunch_picks.where(group_id: @group.id).last
    @lunch_pick.destroy
    redirect_to @group
  end

  private

  def lunch_pick_params
    output = params.require(:lunch_pick).permit(:user_id, :restaurant)
    output.merge(group_id: @group.id)
  end

  def find_group
    @group = Group.find(params[:group_id])
  end
end
