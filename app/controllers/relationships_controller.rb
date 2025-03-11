class RelationshipsController < ApplicationController
  before_action :logged_in_user
  before_action :find_user, only: :create
  before_action :find_relationship, only: :destroy
  def create
    current_user.follow(@user)
    respond_to do |format|
      format.html{redirect_to @user}
      format.turbo_stream
    end
  end

  def destroy
    @user = @relationship.followed
    current_user.unfollow(@user)
    respond_to do |format|
      format.html{redirect_to @user}
      format.turbo_stream
    end
  end

  private
  def find_user
    @user = User.find(params[:followed_id])
  end

  def find_relationship
    @relationship = Relationship.find(params[:id])
  end
end
