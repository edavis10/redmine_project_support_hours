require File.dirname(__FILE__) + '/../../../test_helper'

class ProjectSupportHours::MapperTest < Test::Unit::TestCase
  should_get_the_project_custom_field_for :hours_field, :using => :hours, :format => 'float'
  should_get_the_project_custom_field_for :start_date_field, :using => :start_date, :format => 'date'
  should_get_the_project_custom_field_for :end_date_field, :using => :end_date, :format => 'date'
end

