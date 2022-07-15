# frozen_string_literal: true

require "optparse"

module WhereAreYou
  # The convenient command line interface to WhereAreYou.
  module Cli
    def self.call(stdin, argv)
      threshold = options(argv)
      puts WhereAreYou.call(stdin.read, threshold)
    end

    # Parse options.
    def self.options(argv) # rubocop:disable Metrics/MethodLength
      # Default.
      probability_threshold = nil

      OptionParser.new do |opts|
        opts.banner = "Usage: cat sample.txt | where_are_you [options]"

        def_pt = DEFAULT_PROBABILITY_THRESHOLD
        opts.on("-p", "--probability-threshold THRESHOLD",
                "Set the probability threshold, defaults to #{def_pt}.") do |v|
                  probability_threshold = Float(v)
                end

        opts.on("-h", "--help", "Prints this help") do
          puts opts
          exit
        end
      end.parse!(argv)

      probability_threshold
    end
    private_class_method :options
  end
end
