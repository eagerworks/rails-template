task :code_analysis do
  puts 'BRAKEMAN --------------'
  sh 'bundle exec brakeman . -z -q'
  puts 'RUBOCOP ---------------'
  sh 'bundle exec rubocop'
  puts 'REEK ------------------'
  sh 'bundle exec reek app config lib'
  puts 'RAILS BEST PRACTICES --'
  sh 'bundle exec rails_best_practices .'
end
