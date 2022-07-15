# frozen_string_literal: true

require_relative "where_are_you/version"

INVADER_MAPS = [<<~INVADER1, <<~INVADER2].freeze
  --o-----o--
  ---o---o---
  --ooooooo--
  -oo-ooo-oo-
  ooooooooooo
  o-ooooooo-o
  o-o-----o-o
  ---oo-oo---
INVADER1
  ---oo---
  --oooo--
  -oooooo-
  oo-oo-oo
  oooooooo
  --o--o--
  -o-oo-o-
  o-o--o-o
INVADER2

# Finds the likely invader locations in a given sample radar reading.
#
# The radar map is noisy; it contains false positive and false negative
# readings. Therefore this is a game of probabilities: what are the chances that
# there is an invader at a given point allowing for some incorrect readings?
#
# Accepts a probability threshold parameter which defaults to (scientifically
# derived) 0.72.
module WhereAreYou
  class Error < StandardError; end
  class MapNotRectangularError < Error; end

  # Derived from some experimentation with the sample.
  DEFAULT_PROBABILITY_THRESHOLD = 0.72

  def self.call(sample, probability_threshold = nil)
    probability_threshold ||= DEFAULT_PROBABILITY_THRESHOLD

    radar_map = Map.new(sample)
    invader_maps = INVADER_MAPS.map { |char_map| Map.new(char_map) }
    location_map = FindInvaders.call(radar_map, invader_maps,
                                     probability_threshold)
    location_map.to_lines
  end
end

require_relative "where_are_you/point"
require_relative "where_are_you/map"
require_relative "where_are_you/find_invaders"
require_relative "where_are_you/invader_probability"
