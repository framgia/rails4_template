template_path = "#{File.dirname(__FILE__)}/templates/"

gem_group :development, :test do
  gem "pry-rails"
  gem "pry-coolline"
  gem "pry-byebug"
  gem "awesome_print"

  gem "rubocop"

  gem "guard-rspec"
  gem "guard-spring"
  gem "guard-rubocop"

  gem "rspec-rails"
  gem "factory_girl_rails"
  gem "database_rewinder"

  gem "better_errors"
  gem "binding_of_caller"
end

if yes? "Would you like to use carrierwave?"
  gem "carrierwave"
end

if yes? "Would you like to use devise?"
  gem "devise"
  included_devise = true
end

if yes? "Would you like to use rails_config"
  gem "rails_config"
  included_rails_config = true
end

run "bundle install"

generate "rspec:install"

if included_devise
  generate "devise:install"
  empty_directory "config/locales/devises"
  run "mv config/locales/devise.en.yml config/locales/devises/devise.en.yml"
end

generate "rails_config:install" if included_rails_config

remove_file "spec/spec_helper.rb"
remove_file "spec/rails_helper.rb"
create_file "spec/spec_helper.rb",
  File.read(template_path + "spec/spec_helper.rb")
create_file "spec/rails_helper.rb",
  File.read(template_path + "spec/rails_helper.rb")

run "wget https://raw.githubusercontent.com/framgia/coding-standards/master/rubocop/.rubocop.yml"
run "wget https://raw.githubusercontent.com/framgia/coding-standards/master/rubocop/.rubocop_disabled.yml"
run "wget https://raw.githubusercontent.com/framgia/coding-standards/master/rubocop/.rubocop_enabled.yml"

create_file "Guardfile",
  File.read(template_path + "Guardfile")

run "mv config/database.yml config/database.yml.example"

remove_file "config/locales/en.yml"

remove_dir "test"

directory (template_path + "locales"), "config/locales"

application <<-EOF
config.i18n.load_path += Dir[
      Rails.root.join("config", "locales", "**", "*.yml").to_s
    ]
    config.i18n.default_locale = :ja
EOF

def run_bundle; end
