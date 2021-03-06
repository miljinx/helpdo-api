class FriendshipsController < ApplicationController
  before_action :authenticate_user
  before_action :set_friendship, only: [:update, :destroy]

  # GET /friendships
  def index
    friends_and_requests = {
      friends: current_user.all_friends.pluck(:id, :name),
      sent_friend_requests: current_user.friend_requests.pluck(:id, :name),
      received_friend_requests: current_user.inverse_friend_requests.pluck(:id, :name)
    }
    json_response(friends_and_requests)
  end

  # POST /friendships
  def create
    friendship = current_user.friendships.create!(friendship_params)
    json_response(friendship, :created)
  end

  # PUT /friendships/:id
  def update
    # user cannot accept a friend request that they initiated
    if @friendship.user_id == current_user.id
      json_response('Cannot accept own friend request', :unauthorized)
    else
      @friendship.update!(friendship_params) # FIXME what if friendship row no longer exists
      head :no_content
    end
  end

  # DELETE /friendships/:id
  def destroy
    @friendship.destroy
    head :no_content
  end

  private

  def friendship_params
    params.permit(:friend_id, :is_accepted)
  end

  def set_friendship
    @friendship = Friendship.find(params[:id])
  end
end
