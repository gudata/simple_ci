require 'spec_helper'

describe Repository do
  let(:repository) {Fabricate(:repository)}

  it "find all branches" do
    repository.open
    expect {
      repository.refresh_branches
    }.to change {
      Branch.count()
    }.by(1)
  end

  it "discover new branches" do
    repository.open
    execute = Git.new(repository.path)
    repository.refresh_branches

    expect {
      execute.switch_branch 'second_branch'
      execute.commit_file 'hello_branch', 'first commit in second_branch'
      repository.refresh_branches
    }.to change {
      Branch.count()
    }.from(1).to(2)
  end

  context "#refresh_all_commits" do

    specify "New builds should be created first" do
      repository = Fabricate(:repository_with_builds)
      builds = Build.in_active_branch.newest.pending
      expect(builds.first.commit.message).to eq("2 commited\n")
      expect(builds.last.commit.message).to eq("1 commited\n")
    end
  end

end
