class TradesController < ApplicationController
  before_action :set_trade, only: [:show, :update, :destroy]

  # GET /trades
  def index
    @trades = Trade.all

    render json: @trades
  end

  # GET /trades/1
  def show
    render json: @trade
  end

  # POST /trades
  def create
    @trade = Trade.new(trade_params)
    portfolio = Portfolio.find_by_id(trade_params[:portfolio_id])
    user = User.find_by_id(trade_params[:user_id])
    buying_power_after_buy = portfolio.buying_power - (trade_params[:quantity] * trade_params[:price])
    buying_power_after_sell = portfolio.buying_power + (trade_params[:quantity] * trade_params[:price])
    coin = portfolio.coins.where(coin_id:trade_params[:coin_id])

    if @trade.save && buying_power_after_buy > 0 && trade_params[:trade_type] == "buy"
      if coin.count > 0
        # Coin
        #Updating average cost
        new_average_cost = ((coin[0].quantity * coin[0].average_cost) + (trade_params[:quantity] * trade_params[:price])) / (coin[0].quantity + trade_params[:quantity])
        coin[0].average_cost = new_average_cost
        # Updating quantity 
        coin[0].quantity = coin[0].quantity + trade_params[:quantity]
        # Updating total value
        new_total_value = coin[0].quantity * coin[0].average_cost
        coin[0].total_value = new_total_value
        coin[0].save
        # Updating Total returns
        coin[0].totalReturnsCalculation
        # Portfolio
        portfolio.buying_power = buying_power_after_buy
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
      else
        coin = Coin.create(:coin_id => trade_params[:coin_id], :average_cost => trade_params[:price], :quantity => trade_params[:quantity], :portfolio_id => trade_params[:portfolio_id], :user_id => trade_params[:user_id])
        # Fetching data from newly created Coin
        coin.fetchCoinUpdatePriceData
        coin.totalReturnsCalculation
        # Portfolio
        portfolio.buying_power = buying_power_after_buy
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
      end
      portfolio.save
      user.save
      trade_json = user.to_json(:include => [
        :trades, :coins, :portfolios])
        render json: {
          user: trade_json
        }
    elsif @trade.save && trade_params[:trade_type] == "sell" && (coin[0].quantity - trade_params[:quantity]) >= 0
        # Coin
        # Average cost remains the same
        # Updating quantity
        coin[0].quantity = coin[0].quantity - trade_params[:quantity]
        # Updating total value
        new_total_value = coin[0].quantity * coin[0].average_cost
        coin[0].total_value = new_total_value
        coin[0].save
        # Updating Total returns
        coin[0].totalReturnsCalculation
        # Portfolio
        coin[0].deleteCoinIfZero
        portfolio.buying_power = buying_power_after_sell
        portfolio.save
        # Render JSON
        user.save
        trade_json = user.to_json(:include => [
          :trades, :coins, :portfolios])
          render json: {
            user: trade_json
          }
    else
      render json: {error: 'Invalid Trade, please try again!'}
    end
  end

  # PATCH/PUT /trades/1
  def update
    if @trade.update(trade_params)
      render json: @trade
    else
      render json: @trade.errors, status: :unprocessable_entity
    end
  end

  # DELETE /trades/1
  def destroy
    @trade.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_trade
      @trade = Trade.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def trade_params
      params.require(:trade).permit(:name, :trade_type, :coin_id, :price, :quantity, :symbol, :image, :user_id, :portfolio_id)
    end
end
