require 'spec_helper'

describe Script do
  let(:repository) { Fabricate(:repository) }
  let(:script){ Fabricate(:script)  }
  let(:runner) { Runner.new }

  it "Should build on the right commit" do
    repository.refresh_all_commits
    puts repository.builds.collect(&:commit).inspect
  end
end
