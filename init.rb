require 'redmine'

Dir[File.join(directory,'vendor','plugins','*')].each do |dir|
  path = File.join(dir, 'lib')
  $LOAD_PATH << path
  ActiveSupport::Dependencies.load_paths << path
  ActiveSupport::Dependencies.load_once_paths.delete(path)
end

if Rails.env == "test"
  
  # Bootstrap ObjectDaddy since it's needs to load before the Models
  # (it hooks into ActiveRecord::Base.inherited)
  require 'object_daddy'

  # Use the plugin's exemplar_path :nodoc:
  module ::ObjectDaddy
    module RailsClassMethods
      def exemplar_path
        File.join(File.dirname(__FILE__), 'test', 'exemplars')
      end
    end
  end
end

require 'project_support_hours/hooks/project_hooks'

Redmine::Plugin.register :redmine_project_support_hours do
  name 'Redmine Project Support Hours plugin'
  author 'Author name'
  description 'This is a plugin for Redmine'
  version '0.0.1'

  settings({
             :partial => 'settings/project_support_hours',
             :default => {
               'hours_field' => nil,
               'start_date_field' => nil,
               'end_date_field' => nil
             }})

end
