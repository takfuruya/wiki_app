require 'spec_helper'

describe "Note pages" do

  subject { page }

  let(:user) { FactoryGirl.create(:user) }
  before do
    visit root_path
    valid_signin user
  end

  describe "note creation" do
    it "should create a note" do
      expect { click_button "+" }.to change(Note, :count).by(1)
    end
  end
end
