class UsersController < ApplicationController
  before_action :set_user, only: [:show, :update, :destroy]

  # GET /users
  def index
    @users = User.all

    render json: @users
  end

  # GET /users/1
  def show
    render json: @user
  end

  # POST /users
  def create
    user = User.find_by(:googleId=>params[:googleId])
    print("####################################")
    if user && user.authenticate(params[:password])
      print(user)
      print("####################################")
      payload = {user_id: user.id}
      token = encode_token(payload)
      user_json = user.to_json(:include => [
        :portfolios, :trades, :coins])
      render json: {
        user: user_json,
        jwt: token
      }
    else 
    # print("####################################")
    # print(params)
    # print("####################################")
      user = User.new(user_params)
      if user.save
        # Creating an initial Portfolio for user.
        Portfolio.create(:name => "Initial Portfolio", :description => "For training", :initial_balance => 1000000, :user_id => user.id, :buying_power => 1000000)
        payload = {user_id: user.id}
        token = encode_token(payload)
        render json: {
          # :user => user.to_json(:include => [
          #   :portfolios=>{:include=> :trades}]),
          :user => user.to_json(:include => [
            :portfolios, :trades, :coins]),
          :jwt => token
        }
      else
        # render json: {@user.errors, status: :unprocessable_entity}
        render json: {error: 'Error creating account'}
      end
    end
  end

  # PATCH/PUT /users/1
  def update
    if @user.update(user_params)
      render json: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  # DELETE /users/1
  def destroy
    @user.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def user_params
      # params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation)
      params.permit(:email, :familyName, :givenName, :googleId, :imageUrl, :name, :password)
    end
end
