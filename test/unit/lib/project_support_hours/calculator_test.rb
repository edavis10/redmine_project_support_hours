require File.dirname(__FILE__) + '/../../../test_helper'

class ProjectSupportHours::CalculatorTest < Test::Unit::TestCase
  context '#start_date_for' do
    setup do
      @project = Project.generate!
    end

    context 'configured project' do
      setup do
        setup_plugin_configuration
      end

      should 'return the start date of the project' do
        @project.custom_values << CustomValue.spawn(:custom_field => @start_date_custom_field, :customized_id => @project, :value => '2009-09-10')

        assert_equal '2009-09-10', ProjectSupportHours::Calculator.start_date_for(@project)
      end
    end

    context 'not configured project' do
      should 'return nil' do
        assert_nil ProjectSupportHours::Calculator.start_date_for(@project)
      end
    end

  end

  context '#end_date_for' do
    setup do
      @project = Project.generate!
    end

    context 'configured project' do
      setup do
        setup_plugin_configuration
      end

      should 'return the end date of the project' do
        @project.custom_values << CustomValue.spawn(:custom_field => @end_date_custom_field, :customized_id => @project, :value => '2009-09-22')

        assert_equal '2009-09-22', ProjectSupportHours::Calculator.end_date_for(@project)
      end
    end

    context 'not configured project' do
      should 'return nil' do
        assert_nil ProjectSupportHours::Calculator.end_date_for(@project)
      end
    end
  end

  context '#total_support_hours_for' do
    setup do
      @project = Project.generate!
    end

    context 'configured project' do
      setup do
        setup_plugin_configuration
      end

      should 'return the total support hours for the project' do
        @project.custom_values << CustomValue.spawn(:custom_field => @hours_custom_field, :customized_id => @project, :value => '100.2595')

        assert_equal 100.2595, ProjectSupportHours::Calculator.total_support_hours_for(@project)
      end
    end

    context 'not configured project' do
      should 'return nil' do
        assert_nil ProjectSupportHours::Calculator.total_support_hours_for(@project)
      end
    end

  end

end

