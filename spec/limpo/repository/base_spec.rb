require 'spec_helper'
require 'limpo/repository/base'

RSpec.describe Limpo::Repository::Base do
  class FakeAggregate
    attr_accessor :id 

    def initialize(id: nil)
      @id = id
    end
  end

  class FakeDataset
    def create(aggregate); end
    def find(id); end
    def update(aggregate); end
  end

  describe '#create' do
    it 'sets the id field on the aggregate' do
      aggregate = build_aggregate(id: nil)
      repository = build_repository

      creation = -> { repository.create(aggregate) }

      expect(creation).to change { aggregate.id }
    end

    it 'raises if the id is set on the aggregate' do
      aggregate = build_aggregate(id: SecureRandom.uuid)
      repository = build_repository

      creation = -> { repository.create(aggregate) }

      expect(creation).to(
        raise_error(Limpo::Repository::AggregateAlreadyCreatedError)
      )
    end

    it 'calls #create on the aggregate dataset with the mapped aggregate' do
      aggregate = build_aggregate
      mapper = double('mapper')
      dataset = double('dataset')
      repository = build_repository(mapper: mapper, dataset: dataset)
      allow(mapper).to receive(:to_database).and_return('mapped aggregate')

      expect(dataset).to receive(:create).with('mapped aggregate')

      repository.create(aggregate)
    end
  end

  describe '#find' do
    it 'passes the dataset result to the mapper' do
      id = SecureRandom.uuid
      dataset = build_dataset
      mapper = build_mapper
      repository = build_repository(mapper: mapper, dataset: dataset)

      expect(dataset).to receive(:find).with(id).and_return('aggregate').ordered
      expect(mapper).to receive(:from_database).with('aggregate').ordered

      repository.find(id)
    end

    it 'returns the result of the mapping' do
      aggregate = build_aggregate
      mapper = build_mapper
      repository = build_repository(mapper: mapper)

      allow(mapper).to receive(:from_database).and_return('mapped aggregate')
      fetched_aggregate = repository.find(aggregate.id)

      expect(fetched_aggregate).to eq('mapped aggregate')
    end
  end

  describe '#update' do
    it 'raises if the aggregate has no id' do
      aggregate = build_aggregate(id: nil)
      repository = build_repository

      update_action = -> { repository.update(aggregate) }

      expect(update_action).to(
        raise_error(Limpo::Repository::AggregateNotCreatedError)
      )
    end

    it 'passes the mapped aggregate to the dataset' do
      aggregate = build_aggregate(id: SecureRandom.uuid)
      dataset = build_dataset
      mapper = build_mapper
      repository = build_repository(mapper: mapper, dataset: dataset)

      expect(mapper).to(
        receive(:to_database)
          .with(aggregate)
          .and_return('mapped aggregate').ordered
      )
      expect(dataset).to receive(:update).with('mapped aggregate').ordered

      repository.update(aggregate)
    end
  end

  def build_mapper
    double('mapper').tap do |mapper|
      allow(mapper).to receive(:to_database)
    end
  end

  def build_dataset
    FakeDataset.new
  end

  def build_repository(override = {})
    described_class.new(
      {
        mapper: build_mapper,
        dataset: build_dataset
      }.merge(override)
    )
  end

 def build_aggregate(override = {})
    FakeAggregate.new(override)
  end
end
