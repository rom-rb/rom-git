require 'rom/memory/dataset'

module ROM
  module Git
    class Dataset < ROM::Memory::Dataset
      def self.row_proc
        lambda do |row|
          {
            sha1:      row[:id_new] || row[:sha1],
            message:   row[:message],
            committer: (begin
                          row[:committer].fetch(:name, 'unknown committer name')
                        rescue
                          row[:committer].to_s
                        end)
          }
        end
      end
    end
  end
end
