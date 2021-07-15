class SessionController < ApplicationController
  # def login
  #   user = User.find_by(:googleId=>params[:googleId])

  #   if user && user.authenticate(params[:password])
  #     payload = {user_id: user.id}
  #     token = encode_token(payload)
  #     user_json = user.to_json(:include => [
  #       :portfolios, :trades, :coins])
  #     render json: {
  #       user: user_json,
  #       jwt: token
  #     }
  #   else
  #     print("Yeahhhhhhhhhhhhhhhhhhhhh")
  #     print(params)
  #     print("Yeahhhhhhhhhhhhhhhhhhhhh")
  #     user = User.new(params)
  #     if user.save
  #       # Creating an initial Portfolio for user.
  #       Portfolio.create(:name => "Initial Portfolio", :description => "For training", :initial_balance => 1000000, :user_id => user.id, :current_balance => 1000000)
  #       payload = {user_id: user.id}
  #       token = encode_token(payload)
  #       render json: {
  #         # :user => user.to_json(:include => [
  #         #   :portfolios=>{:include=> :trades}]),
  #         :user => user.to_json(:include => [
  #           :portfolios, :trades, :coins]),
  #         :jwt => token
  #       }
  #     else
  #       # render json: {@user.errors, status: :unprocessable_entity}
  #       render json: {error: "Error creating account, We can't find a user according to your information, please try again."}
  #     end
  #   end
  # end
  
  def auto_login
    if session_user
      portfolio = session_user.portfolios.first
      total_value = portfolio.buying_power
      portfolio.coins.each do |coin|
        coin.fetchCoinUpdatePriceData
        coin.totalReturnsCalculation
        total_value = total_value + coin.total_value
      end
      # Handling coin Deletion
      portfolio.coins.each do |coin|
        coin.deleteCoinIfZero
      end

      portfolio.total_value = total_value
      portfolio.totalReturnsCalculation
      portfolio.save

      render json: session_user, include: ['trades', 'portfolios', 'coins']
    else
      render json: {errors: "No User Logged In!"}
    end
  end
end
