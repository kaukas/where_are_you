# frozen_string_literal: true

module WhereAreYou
  # Uses Hamming distance to calculate the proportion of identical cells between
  # an invader map and a radar map at a position given as the center of the
  # radar map. In other words, a probability that there is an invader cenered at
  # the given coordinates.
  module InvaderProbability
    def self.call(invader_map, radar_map, radar_map_center_point)
      radar_top_left_point = top_left_point(invader_map, radar_map_center_point)
      distance = hamming_distance(invader_map, radar_map, radar_top_left_point)
      probability(invader_map, distance)
    end

    # From the given center point on the radar map find the top left point of
    # the possible invader.
    def self.top_left_point(invader_map, radar_map_center_point)
      Point.new(
        radar_map_center_point.x - (invader_map.width / 2),
        radar_map_center_point.y - (invader_map.height / 2)
      )
    end
    private_class_method :top_left_point

    # Calculate the hamming distance between an invader and a radar map given
    # the top-left starting point.
    def self.hamming_distance(invader_map, radar_map, radar_top_left_point)
      invader_coordinates(invader_map).count do |invader_x, invader_y|
        # Wrap around the map for out of range indices.
        radar_x = (radar_top_left_point.x + invader_x) % radar_map.width
        radar_y = (radar_top_left_point.y + invader_y) % radar_map.height

        radar_map.to_bool[radar_y][radar_x] ==
          invader_map.to_bool[invader_y][invader_x]
      end
    end
    private_class_method :hamming_distance

    # Produce an array of X and Y coordinates to traverse the invader map.
    def self.invader_coordinates(invader_map)
      (0...invader_map.width)
        .to_a
        .product((0...invader_map.height).to_a)
    end
    private_class_method :invader_coordinates

    # Considering the invader map (its size really) and the hamming distance
    # from the current map location calculate the probability that there is an
    # invader there.
    def self.probability(invader_map, distance)
      distance.to_f / (invader_map.width * invader_map.height)
    end
    private_class_method :probability
  end
end
