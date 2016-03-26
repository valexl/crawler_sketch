class ESRepository
  include Elasticsearch::Persistence::Repository
  client Elasticsearch::Client.new url: '127.0.0.1:9200', log: false #TODO change to ENV['ELASTICSEARCH_URL']

  index :crawler_sket

  type  :industries

  klass ::Industry

  # settings number_of_shards: 1 do
  #   mapping do
  #     indexes :text, analyzer: 'snowball'
  #   end
  # end

  settings analysis: {
    analyzer: {
      default: {
        type: "custom",
        tokenizer: "standard",
        filter: ["lowercase", "project_filter"]
      },
      sortable: {
        tokenizer: 'keyword',
        filter: ["lowercase"]
      }
    },
    filter: {
      project_filter: {
        type: "nGram",
        min_gram: 3,
        max_gram: 50
      }
    }
  }

end

class IndustriesRepositories
  include Singleton

  attr_reader :es_repository

  def initialize
    @es_repository = ESRepository.new
  end

  def self.destroy_index!
    es_repository.gateway.client.indices.delete index: es_repository.index_name rescue nil
  end

  def self.refresh_index!
    es_repository.refresh_index!
  end

  def self.search(query)
    es_repository.search(query).results
  end

  def self.find(id)
    es_repository.find(id)
  end

  def self.es_repository
    self.instance.es_repository
  end


end

