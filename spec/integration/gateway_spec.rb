require 'ostruct'

RSpec.describe 'Git gateway' do
  describe 'using the default (master) branch' do
    let(:path) { File.expand_path('./spec/fixtures') }

    let(:rom) do
      ROM.container(:git, path, branch: 'refs/heads/master') do |conf|
        conf.relation(:commits) do

          def by_sha1(sha1)
            restrict(sha1: sha1)
          end

          def by_committer(committer_name)
            restrict(committer: committer_name)
          end
        end

        conf.mappers do
          define(:commits) do
            model OpenStruct
            register_as :entity
          end
        end
      end
    end

    describe 'rom#relation' do
      it 'returns restricted and mapped object' do
        commit = rom.relation(:commits)
          .as(:entity).by_sha1('101868c4ce62b7e96a1f7c3b64fa40285ee00d5e').one

        expect(commit.sha1).to eql('101868c4ce62b7e96a1f7c3b64fa40285ee00d5e')
        expect(commit.message).to eql('commit (initial): Initial commit')
        expect(commit.committer).to eql('Franck Verrot')
      end
    end
  end
end
