# Rails Template

Ruby on rails template project with test and code analysis gems.

### Getting Started

These instructions will get you a copy of the project up and running on your local machine.

1. Clone rails template project
  `git clone git@bitbucket.org:eagerworks/rails-template.git`

2. Change app name
  - `sed -i '' 's/template/your_new_app_name/g' ".ruby-version"`
  - `rails g rename:into your_new_app_name
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


