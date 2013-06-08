require 'spec_helper'

describe "Static pages" do

  subject { page }

  describe "Home page" do
    before { visit root_path }

    it { should have_selector('title', :text => "Eqlea") }
  end

  describe "signup" do

    before do
      visit root_path
      check "sign_up?"
    end

    let(:submit) { "Sign in" }

    describe "with invalid information" do
      it "should not create a user" do
        expect { click_button submit }.not_to change(User, :count)
      end
    end

    describe "with valid information" do
      before do
        fill_in "email",                 with: "user@example.com"
        fill_in "password",              with: "foobar"
        fill_in "password_confirmation", with: "foobar"
      end

      it "should create a user" do
        expect { click_button submit }.to change(User, :count).by(1)
      end
    end
  end

end