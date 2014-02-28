require 'spec_helper'

describe "builds/edit" do
  before(:each) do
    @build = assign(:build, stub_model(Build))
  end

  it "renders the edit build form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", build_path(@build), "post" do
    end
  end
end
