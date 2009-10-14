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
require 'project_support_hours/hooks/external_signups_hooks'

Redmine::Plugin.register :redmine_project_support_hours do
  name 'Project Support Hours'
  author 'Eric Davis'
  url 'https://projects.littlestreamsoftware.com/projects/support-hours'
  author_url 'http://www.littlestreamsoftware.com'
  description 'Project Support Hours is a plugin to implement per-project buckets of hours that are used for support.'
  version '0.1.2'

  requires_redmine :version_or_higher => '0.8.0'

  settings({
             :partial => 'settings/project_support_hours',
             :default => {
               'hours_field' => nil,
               'start_date_field' => nil,
               'end_date_field' => nil
             }})

end
