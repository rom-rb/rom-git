require 'rom/memory/dataset'

module ROM
  module Git
    class Dataset < ROM::Memory::Dataset
      option :path, reader: true
      option :options, reader: true
      option :gateway, reader: true

      def self.row_proc
        lambda do |row|
          {
            sha1:      row[:id_new] || row[:sha1],
            message:   row[:message],
            committer: (row[:committer].fetch(:name, 'unknown committer name') rescue row[:committer].to_s)
          }
        end
      end

      def reload!
        @data = gateway.reset_data
      end

      def count
        @data.count
      end
    end
  end
end
