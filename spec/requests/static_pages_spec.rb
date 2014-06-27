require 'spec_helper'

describe "StaticPages" do
  let(:base_title) { "Ruby on Rails Tutorial Sample App" }
  subject { page }

  shared_examples_for "all static pages" do
    it { should have_selector('h1', text: heading) }
    it { should have_title(full_title(page_title)) }
  end

  describe "Home page" do
    before { visit root_path }
    let(:heading) { 'Sample App' }
    let(:page_title) { '' }
    it_should_behave_like "all static pages"
    it { should_not have_title  "| Home" }

    describe "for signed-in users" do
      let(:user) { FactoryGirl.create(:user) }
      before do
        FactoryGirl.create(:micropost, user: user, content: "Lorem ipsum")
        FactoryGirl.create(:micropost, user: user, content: "Dolor sit amet")
        signin user
        visit root_path
      end

      it "should render the user's feed" do
        user.feed.each do |item|
          expect(page).to have_selector("li##{item.id}", text: item.content)
        end
      end

      it "should display correct count of microposts" do
        expect(page).to have_content( "#{user.microposts.count} " + "micropost".pluralize(user.microposts.count) )
      end

      describe "microposts feed" do
        before do
          50.times do
            FactoryGirl.create(:micropost, user: user, content: "Lirum Larum")
          end
          visit root_path
        end
        it "should be paginated" do
          expect(page).to have_selector('div.pagination')
          expect(page).to have_selector('ol li', count: 30)
        end

        describe "deletion of micropost" do 
          let(:wrong_user) { FactoryGirl.create(:user, email: "wrong@example.com") }            
          before do    
            FactoryGirl.create(:micropost, user: user, content: "Hokus Pokus")
            FactoryGirl.create(:micropost, user: wrong_user, content: "Pokus Hokus")
            visit root_path
          end       
          it "should be possible only for posts created by oneself" do
                      pending "Activate this test when user following has been implemented. Remember to add user association to test code"
            expect(page).to have_selector("ol li span.user", :text => user.name)        # check that page has microposts from both the user
            expect(page).to have_selector("ol li span.user", :text => wrong_user.name)  # and the wrong user          
            page.all("ol li").each do |feeditem|
              if feeditem.find("span.user a").text == user.name
                expect(feeditem).to have_selector("a", :text => "delete")
              else
                expect(feeditem).not_to have_selector("a", :text => "delete")
              end
            end
          end
        end
      end
    end    
  end

  describe "Help page" do
    before { visit help_path }   
    let(:heading) { 'Help' }
    let(:page_title) { 'Help' }     
    it_should_behave_like "all static pages"    
  end

  describe "About page" do
    before { visit about_path }    
    let(:heading) { 'About' }
    let(:page_title) { 'About' }     
    it_should_behave_like "all static pages"    
  end

  describe "Contact page" do
    before { visit contact_path }
    let(:heading) { 'Wanna chat?' }
    let(:page_title) { 'Contact Us' }     
    it_should_behave_like "all static pages"      
	  it { should have_content('Reach out') }
  end

  it "should have the right links on the layout" do
    visit root_path
    expect(page).to have_selector('h1', text: "Sample App" )
    click_link "About"
    expect(page).to have_title(full_title('About Us'))
    click_link "Help"
    expect(page).to have_title(full_title('Help'))
    click_link "Contact"
    expect(page).to have_title(full_title('Contact Us'))
    click_link "Home"
    expect(page).to have_title(full_title(''))
    click_link "Sign up now!"
    expect(page).to have_title(full_title('Sign up'))
    click_link "sample app"
    expect(page).to have_title(full_title(''))
    click_link "Sign in"
    expect(page).to have_title(full_title('')) # should pass until sign-in page is implemented
  end
end
