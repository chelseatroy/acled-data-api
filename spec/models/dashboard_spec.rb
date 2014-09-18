require 'rails_helper'

describe Dashboard do

  describe "#dates" do
    let(:dashboard) { Dashboard.new(number_of_days: 7) }
    it "returns the correct number of dates" do
      expect(dashboard.dates.count).to eq(7)
    end
  end

end