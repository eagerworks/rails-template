require 'rails_helper'

RSpec.describe "friends/index", type: :view do
  before(:each) do
    assign(:friends, [
      Friend.create!(
        name: "Name",
        description: "MyText",
        user: nil,
        best_friend: false,
        awards: 2,
        height: 3.5,
        gender: 4
      ),
      Friend.create!(
        name: "Name",
        description: "MyText",
        user: nil,
        best_friend: false,
        awards: 2,
        height: 3.5,
        gender: 4
      )
    ])
  end

  it "renders a list of friends" do
    render
    cell_selector = 'div>p'
    assert_select cell_selector, text: Regexp.new("Name".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("MyText".to_s), count: 2
    assert_select cell_selector, text: Regexp.new(nil.to_s), count: 2
    assert_select cell_selector, text: Regexp.new(false.to_s), count: 2
    assert_select cell_selector, text: Regexp.new(2.to_s), count: 2
    assert_select cell_selector, text: Regexp.new(3.5.to_s), count: 2
    assert_select cell_selector, text: Regexp.new(4.to_s), count: 2
  end
end
