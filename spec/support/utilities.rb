include ApplicationHelper

RSpec::Matchers.define :have_error_message do |message|
  match do |page|
    expect(page).to have_selector('div.alert.alert-error', text: message)
  end
end

def signin( user, options = {} )
	if options[:no_capybara]
    # Sign in when not using Capybara.
    remember_token = User.new_remember_token
    cookies[:remember_token] = remember_token
    user.update_attribute(:remember_token, User.digest(remember_token))
  else
	  visit signin_path
    fill_in "Email",    with: user.email
    fill_in "Password", with: user.password
    click_button "Sign in"
  end
end

def submit_user_form
  click_button "Create my account"
end

def sign_out_user
 	click_link "Sign out"
end

def fill_in_new_user_form(params)
	fill_in "Name",         with: params[:full_name]
  fill_in "Email",        with: params[:email]
  fill_in "Password",     with: "foobar"
  fill_in "Confirm Password", with: "foobar"
end

