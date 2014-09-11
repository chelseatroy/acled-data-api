require 'rails_helper'

describe Event do

  describe "returns events for a specific date" do

    before do
      3.times{Event.create(event_date: Date.today - 7.days)}
      5.times{Event.create(event_date: Date.today)}
    end

    it "requires a valid date" do
      expect{Event.for(nil)}.to raise_error("No start date provided")
    end

    it "returns events for the given date" do
      expect(Event.for(Date.today).count).to eq(5)
    end

  end

  describe "returns events between a start and end date" do

    before do
      (1..120).each do |days|
        Event.create(event_date: Date.today - days.days)
      end
    end

    it "requiring a start date" do
      expect{Event.between(nil, Date.today)}.to raise_error
    end

    it "requiring valid start and end dates" do
      expect{Event.between("foo", "bar")}.to raise_error
    end

    it "returns event objects" do
      expect(Event.between(Date.today - 1.day, Date.today).first.class).to eq(Event)
    end

    it "defaulting to end date of today" do
      expect(Event.between(Date.today - 7.days, nil).count).to eq(7)
    end

  end

end