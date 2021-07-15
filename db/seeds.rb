# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

user1 = User.create(:email => "switchbink@gmail.com", :familyName => "Switch", :givenName => "BINK", :googleId => "105450538938316950775", :imageUrl => "https://lh3.googleusercontent.com/a/AATXAJyvXB9eV5bn9agowOu2ZUfvEXcTkYAwSaoqYTun=s96-c", :name => "BINK Switch", :password => "105450538938316950775")

portfolio1 = Portfolio.create(:name => "Doge Portfolio", :description => "Testing Doge", :initial_balance => 1000000, :buying_power => 1000000, :user_id => 1)

trade1 = Trade.create(:name => "Bitcoin", :trade_type => "buy", :coin_id => "bitcoin", :price => 109, :quantity => 90, :symbol => "btc", :image => "https://assets.coingecko.com/coins/images/1/large/bitcoin.png?1547033579", :user_id => 1, :portfolio_id => 1)

Coin1 = Coin.create(:name => "Bitcoin", :coin_id => "bitcoin", :current_price => 909, :quantity => 90, :portfolio_id => 1, :image => "https://assets.coingecko.com/coins/images/1/large/bitcoin.png?1547033579", :user_id => 1, :symbol => "btc")