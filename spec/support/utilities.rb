include ApplicationHelper

def valid_signin(user)
  fill_in "email",    with: user.email
  fill_in "password", with: user.password
  click_button "Sign in"
  # Sign in when not using Capybara as well.
  cookies[:remember_token] = user.remember_token
end

RSpec::Matchers.define :have_error_message do |message|
  match do |page|
    page.should have_selector('div.alert.alert-error', text: message)
  end
end

RSpec::Matchers.define :have_submit_button do |value|
  match do |actual|
    actual.should have_selector("input[type=submit][value='#{value}']")
  end
end