# Add a declarative step here for populating the DB with movies.

Given /the following movies exist/ do |movies_table|
  steps %Q{
    Given I am on the RottenPotatoes home page
  }
  movies_table.hashes.each do |movie|
    Movie.create! movie
    steps %Q{
      Given I am on the RottenPotatoes home page
      Then I should see "#{movie[:title]}"
    }
  end
end

Then /I should (not )?see following movies: (.*)$/ do |negative, array|
  array.split(/, */).each do |mov|
    steps %Q{ Then I should #{negative}see "#{mov}" }
  end
end

# Make sure that one string (regexp) occurs before or after another one
#   on the same page

Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
  #  ensure that that e1 occurs before e2.
  #  page.content  is the entire content of the page as a string.
  flunk "Unimplemented"
end

# Make it easier to express checking or unchecking several boxes at once
#  "When I uncheck the following ratings: PG, G, R"
#  "When I check the following ratings: G"
When /I (un)?check the following ratings: (.*)/ do |uncheck, rating_list|
  rating_list.split(/, */).each do |rating|
    steps %Q{ When I #{uncheck}check "ratings[#{rating}]" }
  end
  # HINT: use String#split to split up the rating_list, then
  #   iterate over the ratings and reuse the "When I check..." or
  #   "When I uncheck..." steps in lines 89-95 of web_steps.rb
end

Then /^I should see all of the movies$/ do
  databasemovies   = Movie.all.size
  moviesshowinpage = page.all( "#movies tr" ).size - 1
  if databasemovies != moviesshowinpage
    flunk "Error"
  end
end
