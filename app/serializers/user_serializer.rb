class UserSerializer < ActiveModel::Serializer
  attributes :id, :email, :familyName, :givenName, :googleId, :imageUrl, :name, :password
  has_many :portfolios
  has_many :trades, through: :portfolios
  has_many :coins, through: :portfolios
end
