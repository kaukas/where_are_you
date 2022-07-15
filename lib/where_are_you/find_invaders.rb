# frozen_string_literal: true

module WhereAreYou
  # Creates a matrix of floats that represent probabilities of some invader
  # centered at that point.
  class FindInvaders
    def self.call(radar_map, invader_maps, probability_threshold)
      probabilities = calculate_probabilities(radar_map, invader_maps)
      booleanize_probabilities(probabilities, probability_threshold)
    end

    # Create a matrix of probabilities.
    def self.calculate_probabilities(radar_map, invader_maps)
      (0...radar_map.height).map do |y|
        (0...radar_map.width).map do |x|
          probabilities = invader_maps.map do |invader_map|
            InvaderProbability.call(invader_map, radar_map, Point.new(x, y))
          end
          # Pick the highest probability between detected invaders.
          probabilities.max
        end
      end
    end
    private_class_method :calculate_probabilities

    def self.booleanize_probabilities(probabilities, threshold)
      bool_map = probabilities.map do |line|
        line.map { |c| c >= threshold }
      end
      Map.new(bool_map)
    end
    private_class_method :booleanize_probabilities
  end
end
