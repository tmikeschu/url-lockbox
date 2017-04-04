# URL Lockbox

### Intro

We live in an era of of clicking links, often resulting in a black hole [of
sorts](http://stream1.gifsoup.com/view5/2875073/down-the-rabbit-hole-o.gif). There are obviously more links to be clicked and content to read than we
have time for, so URL Lockbox allows you to keep track of your links.

This is a app for the final assessment for backend engineering module4 at TuringSchool of Software and Design.

### What you can do

As a visitor, you can create an account.

As a user, you can add links, edit them, filter them, and mark them as
read/undread.

## Setup and Development

To get started, clone the repo in your preferred way and:

```
cd url-lockbox
bundle install
rake db:{create,migrate}
bundle exec rspec
rails s
```

Everything will be installed with Bundle.

You will need to download version 46 of Firefox [here](https://www.softexia.com/windows/web-browsers/firefox-46). If you do have it, make sure it is on version 46. Selenium does not work with all versions of Firefox, so make sure that you are using Firefox 46 or else it will potentially cause you problems. 

If you already have Firefox and it's on a version more recent than 46, the easiest way to downgrade is to uninstall Firefox then install version 46.

### Testing your JS with Selenium

The app has the `selenium-webdriver` gem listed in the `Gemfile` and setup in the `rails_helper.rb`

You can then write capybara feature tests and add `js: true` tag if you'd like your test to use the Selenium WebDriver rather than the default WebDriver.  Your tests will execute and recognize your JavaScript.

If you're having problems troubleshooting asynchronous actions (like DOM changes after an AJAX request), [peruse this section of Capybara's docs](https://github.com/teamcapybara/capybara#asynchronous-javascript-ajax-and-friends)

For more info on Selenium testing, check out the Capybara docs and and the section on [selenium-webdriver](https://github.com/teamcapybara/capybara#selenium).
