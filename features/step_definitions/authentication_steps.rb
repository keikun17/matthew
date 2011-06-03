Given /^I am not authenticated$/ do
  visit('/admins/sign_out') # ensure that at least
end

Given /^I have one\s+admin "([^\"]*)" with password "([^\"]*)"$/ do |email, password|
  puts email
  puts password
  Admin.create(:email => email,
           :password => password,
           :password_confirmation => password).save!
end

Given /^I am a new, authenticated admin$/ do
  email = 'testing@man.net'
  password = 'secretpass'

  Given %{I have one admin "#{email}" with password "#{password}"}
  And %{I go to login}
  And %{I fill in "admin_email" with "#{email}"}
  And %{I fill in "admin_password" with "#{password}"}
  And %{I press "Sign in"}
end