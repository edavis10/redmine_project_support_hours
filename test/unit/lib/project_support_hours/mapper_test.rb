require File.dirname(__FILE__) + '/../../../test_helper'

class ProjectSupportHours::MapperTest < Test::Unit::TestCase
  should_get_the_project_custom_field_for :hours_field, :using => :hours, :format => 'float'
end

