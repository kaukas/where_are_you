# frozen_string_literal: true

require "spec_helper"

RSpec.describe WhereAreYou::InvaderProbability do # rubocop:disable Metrics/BlockLength
  def map(char_map)
    WhereAreYou::Map.new(char_map)
  end

  def point(x, y) # rubocop:disable Naming/MethodParameterName
    WhereAreYou::Point.new(x, y)
  end

  it("calculates proportion of identical cells between invader map and " \
     "radar map at a given center position") do
       # 2 out of 6 cells match.
       prob = described_class.call(map(<<~MAP), map(<<~MAP), point(1, 0))
         -o-
         o-o
       MAP
         oo-
         o--
       MAP
       expect(prob).to eq(2.0 / 6)
     end

  it "picks the center of the radar map on an odd sized matrix" do
    # Exact match.
    prob = described_class.call(map("o"), map(<<~MAP), point(1, 1))
      ---
      -o-
      ---
    MAP
    expect(prob).to eq(1)

    # Point too high.
    prob = described_class.call(map("o"), map(<<~MAP), point(0, 1))
      ---
      -o-
      ---
    MAP
    expect(prob).to eq(0)
  end

  it "picks the center of the radar map on an even sized matrix" do
    # Exact match.
    prob = described_class.call(map("o"), map(<<~MAP), point(1, 1))
      --
      -o
    MAP
    expect(prob).to eq(1)

    # Point too high.
    prob = described_class.call(map("o"), map(<<~MAP), point(0, 1))
      --
      -o
    MAP
    expect(prob).to eq(0)
  end

  it "picks the center with an odd sized invader" do
    # Exact match.
    prob = described_class.call(map(<<~IMAP), map(<<~RMAP), point(1, 1))
      oo
      oo
    IMAP
      oo-
      oo-
      ---
    RMAP
    expect(prob).to eq(1)

    # Barely a match.
    prob = described_class.call(map(<<~IMAP), map(<<~RMAP), point(1, 1))
      oo
      oo
    IMAP
      ---
      -oo
      -oo
    RMAP
    expect(prob).to eq(0.25)
  end

  it "wraps around the radar map for negative x indices" do
    # Exact match.
    prob = described_class.call(map(<<~IMAP), map(<<~RMAP), point(0, 1))
      oo
      oo
    IMAP
      o-o
      o-o
    RMAP
    expect(prob).to eq(1)

    # Point too far right.
    prob = described_class.call(map(<<~IMAP), map(<<~RMAP), point(1, 1))
      oo
      oo
    IMAP
      o-o
      o-o
    RMAP
    expect(prob).to eq(0.5)
  end

  it "wraps around the radar map for too large x indices" do
    # Exact match.
    prob = described_class.call(map(<<~IMAP), map(<<~RMAP), point(3, 1))
      oo
      oo
    IMAP
      o-o
      o-o
    RMAP
    expect(prob).to eq(1)

    # Point too far left.
    prob = described_class.call(map(<<~IMAP), map(<<~RMAP), point(2, 1))
      oo
      oo
    IMAP
      o-o
      o-o
    RMAP
    expect(prob).to eq(0.5)
  end

  it "wraps around the radar map for negative y indices" do
    # Exact match.
    prob = described_class.call(map(<<~IMAP), map(<<~RMAP), point(1, 0))
      oo
      oo
    IMAP
      oo-
      ---
      oo-
    RMAP
    expect(prob).to eq(1)

    # Point too far down.
    prob = described_class.call(map(<<~IMAP), map(<<~RMAP), point(1, 1))
      oo
      oo
    IMAP
      oo-
      ---
      oo-
    RMAP
    expect(prob).to eq(0.5)
  end

  it "wraps around the radar map for too large y indices" do
    # Exact match.
    prob = described_class.call(map(<<~IMAP), map(<<~RMAP), point(1, 3))
      oo
      oo
    IMAP
      oo-
      ---
      oo-
    RMAP
    expect(prob).to eq(1)

    # Point too far up.
    prob = described_class.call(map(<<~IMAP), map(<<~RMAP), point(1, 2))
      oo
      oo
    IMAP
      oo-
      ---
      oo-
    RMAP
    expect(prob).to eq(0.5)
  end
end
