# frozen_string_literal: true

module WhereAreYou
  # Represents a 2d matrix of `false`s and `true`s.
  class Map
    TRUTHY_VALUES = %w[o O].freeze

    # Initialize the map with a 2d boolean matrix or with a multiline string
    # representing 'false' and 'true' with '-'s and 'o's respectively.
    def initialize(char_or_bool_map)
      @map = if char_or_bool_map.is_a?(String)
               chars_to_bools(char_or_bool_map)
             else
               char_or_bool_map
             end
      ensure_rectangular!(@map)
    end

    def to_bool
      @map
    end

    def to_lines
      @map.map do |line|
        line.map { |cell| cell ? "o" : "-" }.join
      end.join("\n")
    end

    def width
      @map.first.size
    end

    def height
      @map.size
    end

    private

    def chars_to_bools(map)
      map.strip.each_line.map do |line|
        line.strip.each_char.map(&TRUTHY_VALUES.method(:include?))
      end
    end

    def ensure_rectangular!(map)
      map.each_cons(2) do |line1, line2|
        if line1.size != line2.size
          raise MapNotRectangularError, "Map must be rectangular"
        end
      end
    end
  end
end
