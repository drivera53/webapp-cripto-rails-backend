class User < ApplicationRecord
  has_secure_password

  has_many :portfolios
  has_many :trades, through: :portfolios
  has_many :coins, through: :portfolios
end
