require 'spec_helper'

describe "builds/index" do
  before(:each) do
    assign(:builds, [
      stub_model(Build),
      stub_model(Build)
    ])
  end

  it "renders a list of builds" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
