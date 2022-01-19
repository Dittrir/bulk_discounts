class BulkDiscountService
  def self.three_upcoming
    holidays.first(3)
  end

  def self.holidays
   response = HTTParty.get("https://date.nager.at/api/v3/NextPublicHolidays/US")
   JSON.parse(response.body, symbolize_names: true)
  end
end
