require 'spec_helper'

describe "When checking the results" do
  context "as an admin" do
    before do
      work = Destination.find_by_name("Work")
      work.should_not be_nil
      school = Destination.find_by_name("School")
      school.should_not be_nil
      walk = Mode.find_by_name("Walk")
      walk.should_not be_nil
      bike = Mode.find_by_name("Bike")
      bike.should_not be_nil
      mile = Unit.find_by_name("Mile")
      mile.should_not be_nil
      @user1 = User.make
      @user1.save!
      @user1.trips.create!(:destination_id => work.id, :mode_id => bike.id,
                        :distance => 10.0, :unit_id => mile.id, :made_at => Date.today)
      @user1.trips.create!(:destination_id => work.id, :mode_id => walk.id,
                        :distance => 3.0, :unit_id => mile.id, :made_at => Date.today)
      @user2 = User.make
      @user2.save!
      @user2.trips.create!(:destination_id => school.id, :mode_id => walk.id,
                        :distance => 2.0, :unit_id => mile.id, :made_at => Date.today)
      @user2.trips.create!(:destination_id => school.id, :mode_id => walk.id,
                        :distance => 3.0, :unit_id => mile.id, :made_at => Date.today - 1.day)
      @user2.trips.create!(:destination_id => school.id, :mode_id => walk.id,
                        :distance => 3.0, :unit_id => mile.id, :made_at => Date.today - 1.year)


      @admin = login_as_admin
      visit '/results'
    end
    it "shows most miles for green modes" do
      Mode.green.each do |mode|
        page.should have_content("#{mode.name}")
      end
    end

  end

end
