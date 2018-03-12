require 'httparty'
require 'geokit'

class LunchPicksController < ApplicationController
  before_action :find_group, except: [:filters, :post_filters]
  before_action :filters_params, only: [:post_filters]

  def filters
    @group = Group.find(params[:id])
  end

  def filters_params
    @latitude = params["/groups/#{params[:id]}/filters"]['latitude']
    @longitude = params["/groups/#{params[:id]}/filters"]['longitude']
    @address = params["/groups/#{params[:id]}/filters"]['address']
    @city = params["/groups/#{params[:id]}/filters"]['city']
    @state = params['state']
    @zip = params["/groups/#{params[:id]}/filters"]['zip']
    @search = params["/groups/#{params[:id]}/filters"]['search']
  end

  def post_filters
    Geokit::Geocoders::GoogleGeocoder.api_key = Rails.application.secrets.GOOGLE_API_KEY
    @converted_address = Geokit::Geocoders::GoogleGeocoder.geocode "#{@address}, #{@city}, #{@state} #{@zip}"
    @latitude = @converted_address.lat if @latitude.empty?
    @longitude = @converted_address.lng if @longitude.empty?

    @lunch_pick = current_user.lunch_picks.new
    @group = Group.find(params[:id])
    find_yelp_data
    render :index
  end

  def find_yelp_data
    headers = { 'Authorization' => "Bearer #{Rails.application.secrets.YELP_API_KEY}" }

    url = "https://api.yelp.com/v3/businesses/search?term=#{@search}&latitude=#{@latitude}&longitude=#{@longitude}"

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
