class Trade < ApplicationRecord
    belongs_to :user
    belongs_to :portfolio 

    # validates :quantity, presence: true, numericality: { only_integer: true }
    # validates :quantity, presence: true
end
