require File.dirname(__FILE__) + '/../../../test_helper'

class ProjectSupportHours::MapperTest < Test::Unit::TestCase
  context '#hours' do
    should "return nil if the 'hours_field' is not configured" do
      assert_nil ProjectSupportHours::Mapper.hours
    end

    should "return nil if the ProjectCustomField doesn't exist" do
      configure_plugin('hours_field' => '100')
      assert_nil ProjectSupportHours::Mapper.hours
    end

    should "return the ProjectCustomField" do
      custom_field = ProjectCustomField.generate!(:field_format => 'float')
      configure_plugin('hours_field' => custom_field.id.to_s)
      
      assert_equal custom_field, ProjectSupportHours::Mapper.hours
    end
  end
end

