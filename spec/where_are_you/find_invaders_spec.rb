# frozen_string_literal: true

require "spec_helper"

RSpec.describe WhereAreYou::FindInvaders do # rubocop:disable Metrics/BlockLength
  def locate(radar_char_map, *invader_char_maps, threshold: 0.9)
    radar_map = WhereAreYou::Map.new(radar_char_map)
    invader_maps = invader_char_maps.map do |invader_char_map|
      WhereAreYou::Map.new(invader_char_map)
    end
    described_class.call(radar_map, invader_maps, threshold).to_lines
  end

  it "locates nothing on an empty map" do
    expect(locate(<<~MAP, <<~INVADER)).to eq(<<~LOCATIONS.strip)
      -
    MAP
      o
    INVADER
      -
    LOCATIONS
  end

  it "locates a trivial invader on a trivial map" do
    expect(locate(<<~MAP, <<~INVADER)).to eq(<<~LOCATIONS.strip)
      o
    MAP
      o
    INVADER
      o
    LOCATIONS
  end

  it "locates a complex invader on a complex map" do
    expect(locate(<<~MAP, <<~INVADER)).to eq(<<~LOCATIONS.strip)
      -----
      -ooo-
      --o--
      -ooo-
      -----
    MAP
      ooo
      -o-
      ooo
    INVADER
      -----
      -----
      --o--
      -----
      -----
    LOCATIONS
  end

  it "locates a complex invader on a noisy map" do
    expect(locate(<<~MAP, <<~INVADER)).to eq(<<~LOCATIONS.strip)
      -ooo-
      -ooo-
      ----o
      -ooo-
      -ooo-
    MAP
      ooo
      ooo
      -o-
      ooo
      ooo
    INVADER
      -----
      -----
      --o--
      -----
      -----
    LOCATIONS
  end

  it "locates a complex invader on a very noisy map with a looser threshold" do
    # Too noisy, can't find it.
    expect(locate(<<~MAP, <<~INVADER)).to eq(<<~LOCATIONS.strip)
      -----
      -o-o-
      --o--
      -o-o-
      -----
    MAP
      ooo
      -o-
      ooo
    INVADER
      -----
      -----
      -----
      -----
      -----
    LOCATIONS

    # Loosen up the threshold.
    expect(locate(<<~MAP, <<~INVADER, threshold: 0.7)).to eq(<<~LOCATIONS.strip)
      -----
      -o-o-
      --o--
      -o-o-
      -----
    MAP
      ooo
      -o-
      ooo
    INVADER
      -----
      -----
      --o--
      -----
      -----
    LOCATIONS
  end
end
