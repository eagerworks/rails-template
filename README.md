# Rails Template

Ruby on rails template project with test and code analysis gems.

### Getting Started

These instructions will get you a copy of the project up and running on your local machine.

1. Clone rails template project
  `git clone git@github.com:eagerworks/rails-template.git`

2. Change app name
  - `sed -i '' 's/template/your_new_app_name/g' ".ruby-version"`
  - `rails g rename:into your_new_app_name`
  - `cd ..; cd your_new_app_name`
  - `bundle install`

3. Add ENV variables in /.env
  - DB_USERNAME
  - DB_PASSWORD

4. Run migrations
5. Start server

### Instructions

Run static code analizis tools
`rake code_analysis`

### Versions

1. Use `master` branch for a clean version of RoR with Rspec configuration, code analysis rake task and essential gems
2. Use `api_template` branch for implementing APIs. It comes with jwt authentication and CORS configuration.
3. Use `auth_template` branch for implementing a RoR project with user authentication using devise.
4. Use `dashboard_template` branch for implementing a RoR project with user authentication and a dashboard UI.


