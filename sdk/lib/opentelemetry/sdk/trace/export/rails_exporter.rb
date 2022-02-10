# frozen_string_literal: true

# Copyright The OpenTelemetry Authors
#
# SPDX-License-Identifier: Apache-2.0

require 'pp'

module OpenTelemetry
  module SDK
    module Trace
      module Export
        # Outputs formated {SpanData} to the rails console.
        #
        # Potentially useful for exploratory purposes.
        class RailsExporter
          def initialize
            @stopped = false
          end

          def export(spans, timeout: nil)
            return FAILURE if @stopped

            Array(spans).each do |span|
              Rails.logger.info format_output(span)
            end

            SUCCESS
          end

          def force_flush(timeout: nil)
            SUCCESS
          end

          def shutdown(timeout: nil)
            @stopped = true
            SUCCESS
          end

          private

          def format_output(span)
            @span = span
            if span.name.match("^HTTP") || span.name.include?("Controller")
              return ""
            end
            "name: #{name}, trace_id: #{trace_id}, span_id: #{span_id}, start_time: #{start_time}, end_time: #{end_time}, parent_span_id: #{parent_span_id}"
          end

          private

          def name
            if @span.attributes["identifier"]
              "#{@span.name} -> #{@span.attributes["identifier"].split("views")[1]}"
            else
              @span.name
            end
          end

          def trace_id
            @span.trace_id.unpack1('H*')
          end

          def span_id
            @span.span_id.unpack1('H*')
          end

          def start_time
            Time.at(0, @span.start_timestamp, :nanosecond)
          end

          def end_time
            Time.at(0, @span.end_timestamp, :nanosecond)
          end

          def parent_span_id
             @span.parent_span_id.unpack1('H*')
          end
        end
      end
    end
  end
end
