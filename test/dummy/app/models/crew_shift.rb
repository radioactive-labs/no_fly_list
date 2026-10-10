# frozen_string_literal: true

# A taggable whose scope value is not a column of its own: the airline is
# reached through the crew member, and tags are kept per airline.
class CrewShift < ApplicationRecord
  include NoFlyList::TaggableRecord

  belongs_to :crew_member
  delegate :airline_id, to: :crew_member

  has_tags :duties, scope: :airline_id, case_sensitive: false
end
