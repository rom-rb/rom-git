require 'rom/constants'
require 'rom/gateway'
require 'rom/initializer'

require 'rom/git/dataset'

module ROM
  module Git
    class Gateway < ROM::Gateway
      extend Initializer

      DEFAULT_BRANCH = 'refs/heads/master'.freeze

      # @!attribute [r] path
      #   @return [String]
      param :path, Types::Coercible::String
      # @!attribute [r] branch
      #   @return [String]
      option :branch, Types::Coercible::String, default: proc { DEFAULT_BRANCH }
      # @!attribute [r] repo
      #   @return [Rugged::Repository]
      option :repo, Types.Instance(Rugged::Repository), default: proc { Rugged::Repository.new(path) }

      # @return [Hash]
      def datasets
        @datasets ||= {}
      end

      # @return [Dataset]
      def [](name)
        datasets[name]
      end

      # @return [Dataset]
      def dataset(name)
        datasets[name] = Dataset.new(repo.references[branch].log)
      end

      # @return [Boolean]
      def dataset?(name)
        datasets.key?(name)
      end
    end
  end
end
