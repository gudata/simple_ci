require 'spec_helper'

describe Runner do
  let(:commit) { Fabricate(:commit) }
  let(:runner) { Runner.new }

  it "should not run the same build twise" do
    repository = Fabricate(:repository_with_builds)
    build = repository.builds.first
    build.update_column(:state, Runnable::States[:running])
    expect(runner).to_not receive(:refresh_repositories)
    runner.runonce
  end

end