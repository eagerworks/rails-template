require 'rails_helper'

RSpec.describe "friends/show", type: :view do
  before(:each) do
    assign(:friend, Friend.create!(
      name: "Name",
      description: "MyText",
      user: nil,
      best_friend: false,
      awards: 2,
      height: 3.5,
      gender: 4
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(//)
    expect(rendered).to match(/false/)
    expect(rendered).to match(/2/)
    expect(rendered).to match(/3.5/)
    expect(rendered).to match(/4/)
  end
end
