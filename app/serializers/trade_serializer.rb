class TradeSerializer < ActiveModel::Serializer
  attributes :id, :name, :trade_type, :coin_id, :price, :quantity, :symbol, :image, :user_id, :portfolio_id, :created_at
  # belongs_to :user
  # belongs_to :portfolio
end
