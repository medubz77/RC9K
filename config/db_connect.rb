dbconfig = YAML::load_file(File.join(__dir__, 'database.yml'))
# dbconfig = YAML::load(File.open('database.yml'))
ActiveRecord::Base.establish_connection(dbconfig)
