require 'spec_helper'

describe "Static pages" do

  subject { page }

  shared_examples_for "all static pages" do
    it { should have_content(heading) }
    it { should have_title(full_title(page_title)) }
  end

  it "should have the right links on the layout" do
    visit root_path
    click_link "About"
    expect(page).to have_title(full_title('About Us'))
    click_link "Help"
    expect(page).to have_title(full_title('Help'))
    click_link "Contact"
    expect(page).to have_title(full_title('Contact'))
    click_link "Home"
    click_link "Sign up now!"
    expect(page).to have_title(full_title('Sign up'))
    click_link "sample app"
    expect(page).to have_content('Sample App')
  end

  describe "Home page" do
    before { visit root_path }
    let(:heading)    { 'Sample App' }
    let(:page_title) { '' }

    it_should_behave_like "all static pages"
    it { should_not have_title('| Home') }

    describe "for signed-in users" do
      let(:user) { FactoryGirl.create(:user) }
      #let(:post1) { FactoryGirl.create(:micropost, user: user, content: "Lorem ipsum") }
      #let(:post2) { FactoryGirl.create(:micropost, user: user, content: "Dolor sit amet") }
      before do
        FactoryGirl.create(:micropost, user: user, content: "Lorem ipsum")
        FactoryGirl.create(:micropost, user: user, content: "Dolor sit amet")
        sign_in user
        visit root_path
      end

      it "should render the user's feed" do
        user.feed.each do |item|
          expect(page).to have_selector("li##{item.id}", text: item.content)
        end
      end
      describe "should display the correct count of microposts" do
        describe "for one micropost" do
          before do 
            user.microposts.destroy(user.microposts.first) 
            visit root_path
          end
          it { should_not have_content("#{user.microposts.count} microposts") }
          it { should have_content("#{user.microposts.count} micropost") }
        end
        describe "for other than one micropost" do
          it { should have_content("#{user.microposts.count} microposts") }
        end
      end
      describe "should have paginated microposts" do
        before do 
          35.times { FactoryGirl.create(:micropost, user: user, content: Faker::Lorem.sentence(5)) }
          visit root_path
        end
        describe "pagination" do
          it { should have_selector('div.pagination') }
          it "should list each micropost" do
            user.feed.paginate(page: 1).each do |micropost|
              expect(page).to have_selector('li', text: micropost.content)
            end
          end
        end
      end
    end
  end

  describe "Help page" do
    before { visit help_path }
    let(:heading)    { 'Help' }
    let(:page_title) { 'Help' }

    it_should_behave_like "all static pages"
  end

  describe "About page" do
    before { visit about_path }
    let(:heading)    { 'About' }
    let(:page_title) { 'About Us' }

    it_should_behave_like "all static pages"
  end

  describe "Contact page" do
    before { visit contact_path }
    let(:heading)    { 'Contact' }
    let(:page_title) { 'Contact' }

    it_should_behave_like "all static pages"
  end
end