require 'spec_helper'

describe "User pages" do

  subject { page }

  describe "signup page" do
    before { visit signup_path }

    it { should have_content('Sign up') }
    it { should have_title(full_title('Sign up')) }
  end

  describe "signup" do

    before { visit signup_path }

    describe "with invalid information" do
      it "should not create a user" do
        expect { submit_user_form }.not_to change(User, :count)
      end
      describe "after submit" do
      	before { submit_user_form }
      	it { should have_title(full_title('Sign up')) }
      	it { should have_content("error") }
      end
    end

    describe "with valid information" do
      let(:new_user_full_name) { "Example User" }
      let(:new_user_email) { "user@example.com" }
      before { fill_in_new_user_form(full_name: new_user_full_name, email: new_user_email) }

      it "should create a user" do
        expect { submit_user_form }.to change(User, :count).by(1)
      end

      describe "After submit" do
      	before { submit_user_form }
        it { should have_title(full_title(new_user_full_name)) }
        it { should have_content('Welcome to the Sample App!') }
      end

      describe "after saving the user" do
        before { submit_user_form }
        let(:user) { User.find_by(email: new_user_email) }
        it { should have_link('Sign out') }
        it { should_not have_link('Sign in') }
        it { should have_title(user.name) }
        it { should have_selector('div.alert.alert-success', text: 'Welcome') }

        describe "followed by signout" do
          before { sign_out_user }
          it { should have_link('Sign in') }
          it { should_not have_link('Sign out') }
        end
      end
    end
  end

  describe "profile page" do
    let(:user) { FactoryGirl.create(:user) }
    before { visit user_path(user) }

    it { should have_content(user.name) }
    it { should have_title(user.name) }
  end
end