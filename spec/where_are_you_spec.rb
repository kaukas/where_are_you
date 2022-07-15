# frozen_string_literal: true

require "spec_helper"

RSpec.describe WhereAreYou do # rubocop:disable Metrics/BlockLength
  it "highlights the center point for the first invader" do
    expect(described_class.call(<<~SAMPLE.strip, 0.9)).to eq(<<~CENTER.strip)
      -----o-----o-----
      ------o---o------
      -----ooooooo-----
      ----oo-ooo-oo----
      ---ooooooooooo---
      ---o-ooooooo-o---
      ---o-o-----o-o---
      ------oo-oo------
    SAMPLE
      -----------------
      -----------------
      -----------------
      -----------------
      --------o--------
      -----------------
      -----------------
      -----------------
    CENTER
  end

  it "highlights the center point for the second invader" do
    expect(described_class.call(<<~SAMPLE.strip, 0.9)).to eq(<<~CENTER.strip)
      ------oo------
      -----oooo-----
      ----oooooo----
      ---oo-oo-oo---
      ---oooooooo---
      -----o--o-----
      ----o-oo-o----
      ---o-o--o-o---
    SAMPLE
      --------------
      --------------
      --------------
      --------------
      -------o------
      --------------
      --------------
      --------------
    CENTER
  end
end
