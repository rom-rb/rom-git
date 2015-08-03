require 'rom/gateway'
require 'rom/git/dataset'

module ROM
  module Git
    class Gateway < ROM::Gateway
      def initialize(path, options = {})
        super()
        @path = path
        @options = options
        @datasets = {}
        reset_data
      end

      def [](name)
        @datasets[name]
      end

      def dataset(name)
        @datasets[name] = Dataset.new(@connection, path: @path, options: @options, gateway: self)
      end

      def dataset?(name)
        @datasets.key?(name)
      end

      def reset_data
        repo   = Rugged::Repository.new(@path)
        walker = Rugged::Walker.new(repo)
        branch = (@options || {}).fetch(:branch, 'refs/head/master')
        ref    = repo.references[branch]

        @connection = ref.log rescue []
      end
    end
  end
end
