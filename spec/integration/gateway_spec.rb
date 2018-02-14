require 'ostruct'

RSpec.describe 'Git gateway' do
  describe 'using the default (master) branch' do
    let(:path) { File.expand_path('./spec/fixtures') }

    let(:rom) do
      ROM.container(:git, path) do |conf|
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

    shared_context 'a mapped relation tuple' do
      it 'returns restricted and mapped object' do
        expect(commit.sha1).to eql('101868c4ce62b7e96a1f7c3b64fa40285ee00d5e')
        expect(commit.message).to eql('commit (initial): Initial commit')
        expect(commit.committer).to eql('Franck Verrot')
      end
    end

    describe 'using a relation with a custom mapper' do
      let(:commit) do
        rom.relations[:commits]
          .map_with(:entity).by_sha1('101868c4ce62b7e96a1f7c3b64fa40285ee00d5e').one
      end

      include_context 'a mapped relation tuple'
    end

    describe 'using a repository' do
      let(:repo) do
        Class.new(ROM::Repository[:commits]) do
          def find(sha1)
            root.by_sha1(sha1).one
          end
        end.new(rom)
      end

      let(:commit) { repo.find('101868c4ce62b7e96a1f7c3b64fa40285ee00d5e') }

      include_context 'a mapped relation tuple'
    end

    describe 'setup' do
      it 'raises when branch name is invalid' do
        expect { ROM.container(:git, path, branch: 'not-here') { |conf| conf.relation(:commits) } }
          .to raise_error(Rugged::ReferenceError, /not-here/)
      end

      it 'configures with a custom branch' do
        rom = ROM.container(:git, path, branch: 'refs/heads/feature') { |conf| conf.relation(:commits) }
        expect(rom.relations[:commits].count).to be(0)
      end
    end
  end
end
