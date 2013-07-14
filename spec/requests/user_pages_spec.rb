require 'spec_helper'

describe "User pages" do
    
  subject { page }
  
  describe "index" do
    let(:user) { FactoryGirl.create(:user) }
    before do
      user.reload
      visit users_path
    end

    it { should have_selector('title', text: 'All Users') }
    it { should have_selector('h1',    text: 'All Users') }

    it "should list each user" do
      User.all.each do |user|
        page.should have_selector('li', text: user.name)
      end
    end

    describe "delete links" do
      it { should_not have_link('delete') }
      
      describe "as an admin user" do
        let(:admin) { FactoryGirl.create(:admin) }
        before do
          admin.reload
          visit root_path
          valid_signin admin
          visit users_path
        end
        
        it { should have_link('delete', href: user_path(User.first)) }
        it "should be able to delete another user" do
          expect { click_link('delete') }.to change(User, :count).by(-1)
        end
        it { should_not have_link('delete', href: user_path(admin)) }
      end
    end
  end

  describe "profile page" do
    let(:user) { FactoryGirl.create(:user) }
    let!(:n1) { FactoryGirl.create(:note, user: user, content: "Foo") }
    let!(:n2) { FactoryGirl.create(:note, user: user, content: "Bar") }

    before { visit user_path(user) }
  
    it { should have_selector('title', text: user.name) }
    it { should have_selector('h1', text: user.name) }

    describe "notes" do
      it { should have_content(n1.name) }
      it { should have_content(n2.name) }
    end
  end
end