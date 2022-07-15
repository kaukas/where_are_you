# frozen_string_literal: true

require "spec_helper"

EXE_PATH = File.expand_path("../exe/where_are_you", __dir__)

RSpec.describe "executable" do # rubocop:disable Metrics/BlockLength
  let(:map) do
    <<~MAP
      -----oo-----
      ----oooo----
      ---oooooo---
      --oo-oo-oo--
      --oooooooo--
      ----o--o----
      ---o-oo-o---
      --o-o--o-o--
    MAP
  end

  it "prints a map with most likely invader spots marked" do
    stub_const("STDIN", StringIO.new(map))
    stub_const("ARGV", [])

    expect { load(EXE_PATH, true) }.to output(<<~MAP).to_stdout
      ------------
      ------------
      ------------
      ------------
      ------o-----
      ------------
      ------------
      ------------
    MAP
  end

  it "accepts a probability threshold" do
    stub_const("STDIN", StringIO.new(map))
    stub_const("ARGV", ["--probability-threshold", "0.6"])

    expect { load(EXE_PATH, true) }.to output(<<~MAP).to_stdout
      ------------
      ------------
      ------------
      ----oooo----
      -----oo-----
      -----o-o----
      ------------
      ------------
    MAP
  end

  it "prints help" do
    stub_const("ARGV", ["--help"])

    expect { load(EXE_PATH, true) }
      .to raise_error(SystemExit)
      .and output(<<~HELP).to_stdout
        Usage: cat sample.txt | where_are_you [options]
            -p THRESHOLD,                    Set the probability threshold, defaults to 0.72.
                --probability-threshold
            -h, --help                       Prints this help
      HELP
  end
end
