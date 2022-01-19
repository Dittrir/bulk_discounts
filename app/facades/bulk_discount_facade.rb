class BulkDiscountFacade
  def holidays
    three_holidays = BulkDiscountService.three_upcoming

    @holidays = three_holidays.map do |data|
      Holiday.new(data)
    end
  end
end
