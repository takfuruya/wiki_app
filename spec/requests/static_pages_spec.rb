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
      it { should have_link('Sign out', href: root_path) }

      describe "followed by signout" do
        before { click_link "Sign out" }
        it { should have_submit_button("Sign in") }
      end

      describe "followed by update user profile" do

        describe "with invalid information" do
          before { click_button "Save changes" }

          it { should have_content('error') }
        end

        describe "with valid information" do
          let(:new_name)  { "New Name" }
          let(:new_email) { "new@example.com" }
          before do
            fill_in "name",                  with: new_name
            fill_in "email",                 with: new_email
            fill_in "password",              with: user.password
            fill_in "password_confirmation", with: user.password
            click_button "Save changes"
          end

          it { should have_selector('title', text: 'Eqlea') }
          it { should have_selector('h1', text: new_name) }
          it { should have_selector('div.alert.alert-success') }
          it { should have_link('Sign out', href: root_path) }
          specify { user.reload.name.should  == new_name }
          specify { user.reload.email.should == new_email }
        end
      end
    end
  end

  describe "authorization" do

    describe "for non-signed-in users" do
      let(:user) { FactoryGirl.create(:user) }

      describe "in the Users controller" do
        describe "submitting to the update action" do
          before { put user_path(user) }
          specify { response.should redirect_to(root_path) }
        end

        describe "visiting the user index" do
          before { visit users_path }
          it { should have_selector('title', text: 'All Users') }
        end
      end
    end

    describe "as wrong user" do
      let(:user) { FactoryGirl.create(:user) }
      let(:wrong_user) { FactoryGirl.create(:user, email: "wrong@example.com") }
      before do
        visit root_path
        valid_signin user
      end

      describe "submitting a PUT request to the Users#update action" do
        before { put user_path(wrong_user) }
        specify { response.should redirect_to(root_path) }
      end
    end

    describe "as non-admin user" do
      let(:user) { FactoryGirl.create(:user) }
      let(:non_admin) { FactoryGirl.create(:user) }

      before do
        visit root_path
        valid_signin non_admin
      end

      describe "submitting a DELETE request to the Users#destroy action" do
        before { delete user_path(user) }
        specify { response.should redirect_to(root_path) }
      end
    end

    describe "as signed-in users" do
      let(:user) { FactoryGirl.create(:user) }
      before do
        visit root_path
        valid_signin user
      end

      describe "submitting a POST request to the Users#create action" do
        before { post root_path, sign_up?: true }
        specify { response.should redirect_to(root_path) }
      end
    end
  end
end