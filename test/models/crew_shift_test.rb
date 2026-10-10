# frozen_string_literal: true

require "test_helper"

class CrewShiftTest < ActiveSupport::TestCase
  setup do
    @acme = Airline.create!(name: "Acme Air")
    @zenith = Airline.create!(name: "Zenith")
    @alice = CrewMember.create!(airline: @acme, name: "Alice")
    @bob = CrewMember.create!(airline: @acme, name: "Bob")
    @zoe = CrewMember.create!(airline: @zenith, name: "Zoe")
  end

  test "reads the scope value from a method when the taggable has no such column" do
    shift = CrewShift.create!(crew_member: @alice, name: "Morning")
    shift.duties_list = "boarding"
    shift.save!

    assert_equal [ @acme.id ], CrewShiftTag.where(name: "boarding").pluck(:airline_id)
  end

  test "shifts in the same scope share a tag, other scopes get their own" do
    morning = CrewShift.create!(crew_member: @alice, name: "Morning")
    evening = CrewShift.create!(crew_member: @bob, name: "Evening")
    night = CrewShift.create!(crew_member: @zoe, name: "Night")
    [ morning, evening, night ].each do |shift|
      shift.duties_list = "Boarding"
      shift.save!
    end

    assert_equal morning.duties.first, evening.duties.first
    assert_not_equal morning.duties.first, night.duties.first
    assert_equal 2, CrewShiftTag.where(name: "Boarding").count
  end

  test "finds an existing tag in the scope case-insensitively" do
    CrewShiftTag.create!(airline_id: @acme.id, name: "Boarding")
    shift = CrewShift.create!(crew_member: @alice, name: "Morning")
    shift.duties_list = "boarding"
    shift.save!

    assert_equal 1, CrewShiftTag.where(airline_id: @acme.id).count
    assert_equal [ "Boarding" ], shift.reload.duties_list.to_a
  end
end
