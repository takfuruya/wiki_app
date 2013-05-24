require 'spec_helper'

describe "Static pages" do

  describe "Home page" do

    it "should have the h1 'Eqlea'" do
      visit '/static_pages/home'
      page.should have_selector('h1', :text => 'Eqlea')
    end
    
    it "should have the title 'Eqlea'" do
      visit '/static_pages/home'
      page.should have_selector('title', :text => "Eqlea")
    end
  end
end