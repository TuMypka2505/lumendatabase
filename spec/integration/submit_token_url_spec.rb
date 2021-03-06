require 'rails_helper'

feature 'token url submission' do
  let(:notice) { create(:dmca) }

  scenario 'submits successfully', js: true do
    visit request_access_notice_path(notice)

    expect_correct_title

    submit

    expect(page).to have_content 'A new single-use link has been generated and sent to'
  end

  scenario 'won\'t allow to submit twice using the same email', js: true do
    visit request_access_notice_path(notice)

    expect_correct_title

    submit

    expect(page).to have_content 'A new single-use link has been generated and sent to'

    submit

    expect(page).to have_content 'This email address has been used already'
  end

  scenario 'won\'t allow to submit using a not valid email', js: true do
    visit request_access_notice_path(notice)

    expect_correct_title

    submit('hohoho')

    expect(page).to have_content 'Email is invalid'
  end

  scenario 'will contain all the form fields', js: true do
    visit request_access_notice_path(notice)

    expect(page).to have_content 'Email address'
    expect(page).to have_content 'Select to get a notification when new notice documents are added (or when existing notice documents are updated)'
  end

  private

  def submit(email = 'user@example.com')
    fill_in 'Email', with: email
    click_on 'Submit'
  end

  def expect_correct_title
    expect(page).to have_content notice.title
  end
end
