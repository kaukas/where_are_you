# frozen_string_literal: true

require "spec_helper"

RSpec.describe WhereAreYou::Map do # rubocop:disable Metrics/BlockLength
  describe "string parsing" do
    it "parses '-' as false" do
      expect(described_class.new("--\n--").to_bool)
        .to eq([[false, false], [false, false]])
    end

    it "parses 'o' or 'O' to true" do
      expect(described_class.new("-o\noO").to_bool)
        .to eq([[false, true], [true, true]])
    end

    it "ignores whitespace around lines" do
      expect(described_class.new("\n \n- \n   -\n\t \n").to_bool)
        .to eq([[false], [false]])
    end

    it "parses everything else to false" do
      expect(described_class.new("invador").to_bool)
        .to eq([[false, false, false, false, false, true, false]])
    end

    it "parses a blank string to an empty array" do
      expect(described_class.new("\n \n").to_bool).to eq([])
    end
  end

  describe "bool parsing" do
    it "parses a boolean matrix to itself" do
      expect(described_class.new([[false, true], [true, false]]).to_bool)
        .to eq([[false, true], [true, false]])
    end
  end

  it "throws an error if the map is not rectangular" do
    expect { described_class.new([[false], [false, false]]) }
      .to raise_error(WhereAreYou::MapNotRectangularError)
  end

  it "converts booleans to '-' and 'o' and creates a multiline string" do
    expect(described_class.new([[false, true], [true, false]]).to_lines)
      .to eq("-o\no-")
  end

  it "calculates the width and height of the map" do
    map = described_class.new([[false], [true]])
    expect(map.width).to eq(1)
    expect(map.height).to eq(2)
  end
end
