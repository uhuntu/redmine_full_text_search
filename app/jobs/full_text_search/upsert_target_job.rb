module FullTextSearch
  class UpsertTargetJob < ActiveJob::Base
    queue_as :default

    def perform(mapper_class_name, source_id)
      mapper_class = mapper_class_name.constantize
      source = mapper_class.redmine_class.find(source_id)
      mapper = mapper_class.redmine_mapper(source)
      mapper.upsert_fts_target
    end
  end
end