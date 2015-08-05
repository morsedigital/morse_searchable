require 'rails_helper'

RSpec.describe "api/search/feed.json.jbuilder", type: :view do

  let(:current_user) { [new_sample] }

  before do
    view.stub(:feed).and_return(current_user)
  end

  it 'does something' do
    render_template "api/search/feed.json.jbuilder"
    binding.pry
    expect(rendered).to match('foo@bar.com')
  end
end