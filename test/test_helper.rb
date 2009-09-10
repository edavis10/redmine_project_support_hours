# Load the normal Rails helper
require File.expand_path(File.dirname(__FILE__) + '/../../../../test/test_helper')

# Ensure that we are using the temporary fixture path
Engines::Testing.set_fixture_path

Rails::Initializer.run do |config|
  config.gem "thoughtbot-shoulda", :lib => "shoulda", :source => "http://gems.github.com"
  config.gem "nofxx-object_daddy", :lib => "object_daddy", :source => "http://gems.github.com"
end

# TODO: The gem or official version of ObjectDaddy doesn't set protected attributes.
def User.generate_with_protected!(attributes={})
  user = User.spawn(attributes) do |user|
    user.login = User.next_login
    attributes.each do |attr,v|
      user.send("#{attr}=", v)
    end
  end
  user.save!
end

# Helpers
class Test::Unit::TestCase
  def configure_plugin(fields={})
    Setting.plugin_redmine_project_support_hours = fields.stringify_keys
  end

  def setup_plugin_configuration
    @hours_custom_field = ProjectCustomField.generate!(:field_format => 'float')
    @start_date_custom_field = ProjectCustomField.generate!(:field_format => 'date')
    @end_date_custom_field = ProjectCustomField.generate!(:field_format => 'date')

    configure_plugin({
                       'hours_field' => @hours_custom_field.id.to_s,
                       'start_date_field' => @start_date_custom_field.id.to_s,
                       'end_date_field' => @end_date_custom_field.id.to_s
                     })
  end
end

# Shoulda
class Test::Unit::TestCase
  def self.should_get_the_project_custom_field_for(field_name, options)
    method_call = options.delete(:using) || field_name
    format = options.delete(:format) || 'string'

    context "##{method_call}" do
      should "return nil if the '#{field_name}' is not configured" do
        assert_nil ProjectSupportHours::Mapper.send(method_call)
      end

      should "return nil if the ProjectCustomField doesn't exist for '#{field_name}'" do
        configure_plugin(field_name.to_s => '100')
        assert_nil ProjectSupportHours::Mapper.send(method_call)
      end

      should "return the ProjectCustomField for '#{field_name}'" do
        custom_field = ProjectCustomField.generate!(:field_format => format)
        configure_plugin(field_name.to_s => custom_field.id.to_s)
      
        assert_equal custom_field, ProjectSupportHours::Mapper.send(method_call)
      end
    end
  end
end
