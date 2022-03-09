# frozen_string_literal: true

# Copyright The OpenTelemetry Authors
#
# SPDX-License-Identifier: Apache-2.0

module OpenTelemetry
  module Instrumentation
    module ActiveRecord
      module Patches
        # Module to prepend to ActiveRecord::Base for instrumentation
        # contains the ActiveRecord::Calculations methods to be patched
        module Calculations
          def pluck(*column_names)
            tracer.in_span("#{self.class}.pluck") do
              super
            end
          end
        end
      end
    end
  end
end
