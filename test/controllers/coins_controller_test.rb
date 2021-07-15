require "test_helper"

class CoinsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @coin = coins(:one)
  end

  test "should get index" do
    get coins_url, as: :json
    assert_response :success
  end

  test "should create coin" do
    assert_difference('Coin.count') do
      post coins_url, params: { coin: { average_price: @coin.average_price, coin_id: @coin.coin_id, coin_name: @coin.coin_name, image: @coin.image, portfolio_id: @coin.portfolio_id, quantity: @coin.quantity, user_id: @coin.user_id } }, as: :json
    end

    assert_response 201
  end

  test "should show coin" do
    get coin_url(@coin), as: :json
    assert_response :success
  end

  test "should update coin" do
    patch coin_url(@coin), params: { coin: { average_price: @coin.average_price, coin_id: @coin.coin_id, coin_name: @coin.coin_name, image: @coin.image, portfolio_id: @coin.portfolio_id, quantity: @coin.quantity, user_id: @coin.user_id } }, as: :json
    assert_response 200
  end

  test "should destroy coin" do
    assert_difference('Coin.count', -1) do
      delete coin_url(@coin), as: :json
    end

    assert_response 204
  end
end
