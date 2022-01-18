class BulkDiscount < ApplicationRecord
  validates :percent_discount,
            :presence => {message: "can't be blank"},
            :numericality => { only_integer: true,
                               greater_than: 0,
                               less_than: 100,
                               message: "must be between 0 and 100"}
  validates :quantity_threshold,
            :presence => {message: "can't be blank"},
            :numericality => {only_integer: true,
                              greater_than: 1,
                              message: "must be 2 or greater."}
  belongs_to :merchant
end
