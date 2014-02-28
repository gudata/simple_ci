require 'spec_helper'

describe Commit do
  context "create" do
    it "every new commit has a pending build" do
      Commit.skip_create_builds_flag = false
      expect{
        Fabricate(:commit)
      }.to change {
        Build.count()
      }.by(1)

      expect(Build.last.state_name).to eq(:pending)
    end

    it "should be possible to skip making builds" do
      Commit.skip_create_builds_flag = true

      expect{
        Fabricate(:commit)
      }.to_not change {
        Build.count()
      }
    end
  end
end
