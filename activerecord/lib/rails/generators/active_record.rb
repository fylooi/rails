require 'rails/generators/named_base'
require 'rails/generators/migration'
require 'rails/generators/active_model'
require 'active_record'

module ActiveRecord
  module Generators
    class Base < Rails::Generators::NamedBase #:nodoc:
      include Rails::Generators::Migration

      def self.source_root
        @_ar_source_root ||= begin
          if base_name && generator_name
            File.expand_path(File.join(base_name, generator_name, 'templates'), File.dirname(__FILE__))
          end
        end
      end

      # Implement the required interface for Rails::Generators::Migration.
      #
      def self.next_migration_number(dirname) #:nodoc:
        next_migration_number = current_migration_number(dirname) + 1
        if ActiveRecord::Base.timestamped_migrations
          [Time.now.utc.strftime("%Y%m%d%H%M%S"), "%.14d" % next_migration_number].max
        else
          "%.3d" % next_migration_number
        end
      end
    end
  end
end
