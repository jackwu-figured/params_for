require 'active_support/concern'

module ParamsFor
  module Connectors
    module Glue
      extend ActiveSupport::Concern

      module ClassMethods
        # Define params_for
        #
        # @param name [Symbol] camelcased validator class name
        # @param options [Hash] optional
        # @option options [Boolean] :class class of the validator
        # @option options [Array] any option that before_action takes
        def params_for(name, options = {})
          method_name = "#{name}_params"

          define_method(method_name) do
            return validate_params(name, options)
          end
        end
      end

      private

      # Strong params checker
      #
      # @param name [Symbol] camelcased validator class name
      # @param options [Hash] optional
      # @option options [Boolean] :class class of the validator
      # @return [Hash]
      def validate_params(name, options = {})
        if options[:class]
          validator_klass = options[:class]
        else
          validator_name = "ParamsFor::#{name.to_s.classify}"
          validator_klass = validator_name.constantize
        end

        validator = validator_klass.new(params)

        unless validator.valid?
          render status: :bad_request, json: validator.errors.to_json and return false
        end

        validator.to_params
      end
    end
  end
end
