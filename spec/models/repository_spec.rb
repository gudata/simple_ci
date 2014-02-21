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

end
