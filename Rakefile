require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'

desc 'Default: run unit tests.'
task :default => :test

desc 'Test the backup_data plugin.'
Rake::TestTask.new(:test) do |t|
  t.libs << 'lib'
  t.libs << 'test'
  t.pattern = 'test/**/*_test.rb'
  t.verbose = true
end

desc 'Generate documentation for the backup_data plugin.'
Rake::RDocTask.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'BackupData'
  rdoc.options << '--line-numbers' << '--inline-source'
  rdoc.rdoc_files.include('README')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gemspec|
    gemspec.name = "backup_data"
    gemspec.summary = "Backup Files and Database Rails Engine"
    gemspec.description = "Backup and Compress Files and Database (mysql only) and send to user as a file (Rails Engine)"
    gemspec.email = "kris.leech@interkonect.com"
    gemspec.homepage = "http://github.com/krisleech/backup_data"
    gemspec.authors = ["Kris Leech"]
  end
rescue LoadError
  puts "Jeweler not available. Install it with: gem install jeweler"
end
