require 'spec_helper'

describe "Static pages" do

  subject { page }

  describe "Home page" do
    before { visit root_path }

    it { should have_selector('title', :text => "Eqlea") }
    it { should have_selector('a', :text => "About") }
    it { should have_submit_button("Sign in") }
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

      describe "after submission" do
        before { click_button submit }

        it { should have_selector('title', text: 'Eqlea') }
        it { should have_content('error') }
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

      describe "after saving the user" do
        before { click_button submit }
        let(:user) { User.find_by_email('user@example.com') }

        it { should have_selector('h1', text: user.name) }
        it { should have_selector('div.alert.alert-success', text: 'Welcome') }
        it { should have_link('Sign out') }
      end
    end
  end

  describe "signin" do
    before { visit root_path }

    describe "with invalid information" do
      before { click_button "Sign in" }

      it { should have_selector('title', text: 'Eqlea') }
      it { should have_error_message('Invalid') }

      # Invalid input error should not appear twice
      describe "after visiting another page" do
        before { visit root_path }
        it { should_not have_selector('div.alert.alert-error') }
      end
    end

    describe "with valid information" do
      let(:user) { FactoryGirl.create(:user) }
      before { valid_signin(user) }
      
      it { should have_selector('title', text: 'Eqlea') }
      it { should have_selector('h1', text: user.name) }
      it { should have_link('Public profile', href: user_path(user)) }
      it { should have_link('Sign out', href: signout_path) }

      describe "followed by signout" do
        before { click_link "Sign out" }
        it { should have_submit_button("Sign in") }
      end
    end
  end
end