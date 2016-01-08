require 'test_helper'
require 'virtus'

describe 'Git gateway' do
  describe 'using the default (master) branch' do
    let(:path) { File.expand_path('./test/fixtures') }
    let(:rom) do
      ROM.container(:git, path, branch: 'refs/heads/master') do |rom_setup|
        rom_setup.use(:macros)
        
        rom_setup.relation(:commits) do

          def by_sha1(sha1)
            restrict(sha1: sha1)
          end

          def by_committer(committer_name)
            restrict(committer: committer_name)
          end
        end

        rom_setup.mappers do
          define(:commits) do
            model(Class.new do
              include Virtus.model

              attribute :sha1,     String
              attribute :message,  String
              attribute :committer, String
            end)

            register_as :entity
          end
        end
      end
    end

    describe 'env#relation' do
      it 'returns restricted and mapped object' do
        commit = rom.relation(:commits).as(:entity).by_sha1('101868c4ce62b7e96a1f7c3b64fa40285ee00d5e').to_a.first

        assert_equal '101868c4ce62b7e96a1f7c3b64fa40285ee00d5e', commit.sha1
        assert_equal 'commit (initial): Initial commit', commit.message
        assert_equal 'Franck Verrot', commit.committer
      end
    end

    # describe 'with a custom branch'
  end
end
