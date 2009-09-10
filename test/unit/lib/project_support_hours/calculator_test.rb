require File.dirname(__FILE__) + '/../../../test_helper'

class ProjectSupportHours::CalculatorTest < Test::Unit::TestCase
  context '#start_date_for' do

    context 'configured project' do
      should 'return the start date of the project' do
        @project = Project.generate!
        @start_date_custom_field = ProjectCustomField.generate!(:field_format => 'date')
        @project.custom_values << CustomValue.spawn(:custom_field => @start_date_custom_field, :customized_id => @project, :value => '2009-09-10')
        configure_plugin('start_date_field' => @start_date_custom_field.id.to_s)

        assert_equal '2009-09-10', ProjectSupportHours::Calculator.start_date_for(@project)
      end
    end

    context 'not configured project' do

      should 'return nil' do
        @project = Project.generate!
        assert_nil ProjectSupportHours::Calculator.start_date_for(@project)
      end

    end

  end

  context '#end_date_for' do

    context 'configured project' do
      should 'return the end date of the project' do
        @project = Project.generate!
        @end_date_custom_field = ProjectCustomField.generate!(:field_format => 'date')
        @project.custom_values << CustomValue.spawn(:custom_field => @end_date_custom_field, :customized_id => @project, :value => '2009-09-22')
        configure_plugin('end_date_field' => @end_date_custom_field.id.to_s)

        assert_equal '2009-09-22', ProjectSupportHours::Calculator.end_date_for(@project)
      end
    end

    context 'not configured project' do
      should 'return nil' do
        @project = Project.generate!
        assert_nil ProjectSupportHours::Calculator.end_date_for(@project)
      end
    end

  end

  context '#total_support_hours_for' do

    context 'configured project' do
      should 'return the total support hours for the project' do
        @project = Project.generate!
        @total_hours_custom_field = ProjectCustomField.generate!(:field_format => 'float')
        @project.custom_values << CustomValue.spawn(:custom_field => @total_hours_custom_field, :customized_id => @project, :value => '100.2595')
        configure_plugin('hours_field' => @total_hours_custom_field.id.to_s)

        assert_equal 100.2595, ProjectSupportHours::Calculator.total_support_hours_for(@project)
      end
    end

    context 'not configured project' do
      should 'return nil' do
        @project = Project.generate!
        assert_nil ProjectSupportHours::Calculator.total_support_hours_for(@project)
      end
    end

  end

end

