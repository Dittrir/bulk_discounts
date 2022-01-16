require 'rails_helper'

RSpec.describe BulkDiscount, type: :model do
  describe 'validations' do
    subject { @merchant_1.bulk_discounts.new(percent_discount: 20, quantity_threshold: 20) }

    describe '#percent_discount' do
      it { should_not allow_value("abcd").for(:percent_discount) }
      it { should_not allow_value(nil).for(:percent_discount) }
      it { should allow_value("5").for(:percent_discount) }
    end

    describe '#quantity_threshold' do
      it { should_not allow_value("abcd").for(:quantity_threshold) }
      it { should_not allow_value(nil).for(:quantity_threshold) }
      it { should allow_value("5").for(:quantity_threshold) }
    end
  end
end
