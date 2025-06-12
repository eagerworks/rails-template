require 'rails_helper'

RSpec.describe "friends/edit", type: :view do
  let(:friend) {
    Friend.create!(
      name: "MyString",
      description: "MyText",
      user: nil,
      best_friend: false,
      awards: 1,
      height: 1.5,
      gender: 1
    )
  }

  before(:each) do
    assign(:friend, friend)
  end

  it "renders the edit friend form" do
    render

    assert_select "form[action=?][method=?]", friend_path(friend), "post" do

      assert_select "input[name=?]", "friend[name]"

      assert_select "textarea[name=?]", "friend[description]"

      assert_select "input[name=?]", "friend[user_id]"

      assert_select "input[name=?]", "friend[best_friend]"

      assert_select "input[name=?]", "friend[awards]"

      assert_select "input[name=?]", "friend[height]"

      assert_select "input[name=?]", "friend[gender]"
    end
  end
end
