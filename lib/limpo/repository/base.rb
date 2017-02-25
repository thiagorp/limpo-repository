module Limpo
  module Repository
    class AggregateAlreadyCreatedError < StandardError; end
    class AggregateNotCreatedError < StandardError; end

    class Base
      attr_reader :mapper, :dataset

      def initialize(params)
        @mapper = params.fetch(:mapper)
        @dataset = params.fetch(:dataset)
      end

      def find(id)
        mapper.from_database(dataset.find(id))
      end

      def create(aggregate)
        raise AggregateAlreadyCreatedError unless aggregate.id.nil?

        aggregate.id = SecureRandom.uuid
        dataset.create(mapper.to_database(aggregate))
      end

      def update(aggregate)
        raise AggregateNotCreatedError if aggregate.id.nil?

        dataset.update(mapper.to_database(aggregate))
      end
    end
  end
end
