include ApplicationHelper

RSpec::Matchers.define :have_error_message do |message|
  match do |page|
    expect(page).to have_selector('div.alert.alert-error', text: message)
  end
end

def signin(user)
  fill_in "Email",    with: user.email
  fill_in "Password", with: user.password
  click_button "Sign in"
end

RSpec::Matchers.define :land_on_profile_page_for_logged_in_user do |user|
  match do |page|
  	( expect(page).to have_title(user.name) ) &&
      ( expect(page).to have_link('Profile',     href: user_path(user)) ) &&
      ( expect(page).to have_link('Sign out',    href: signout_path) ) # &&
      # ( expect(page).to_not have_link('Sign in', href: signin_path) )
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
  fill_in "Confirmation", with: "foobar"
end

