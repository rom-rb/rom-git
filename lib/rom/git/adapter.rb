module ROM
  module Git
    class Adapter < ROM::Adapter
      def self.schemes
        [:git]
      end

      class Dataset
        include Charlatan.new(:rows)
        include Enumerable

        def each
          rows.each do |row|
            res = {
              sha1:      row[:id_new],
              message:   row[:message],
              committer: row[:committer].fetch(:name, 'Unknown committer name')
            }
            yield(res)
          end
        end
      end

      # Expect a path to a single csv file which will be registered by
      # rom to the given name or :default as the repository.
      def initialize(*args)
        super
        repo   = Rugged::Repository.new(uri.path)
        walker = Rugged::Walker.new(repo)
        branch = (@options || {}).fetch(:branch, 'refs/head/master')
        ref    = repo.references[branch]

        @connection = ref.log rescue []
      end

      def [](_name)
        connection
      end

      def dataset(_name, _header)
        Dataset.new(connection)
      end

      def dataset?(_name)
        connection
      end
    end
  end
end
