require 'spec_helper'

describe "builds/new" do
  before(:each) do
    assign(:build, stub_model(Build).as_new_record)
  end

  it "renders new build form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", builds_path, "post" do
    end
  end
end
