require File.dirname(__FILE__) + '/../../../test_helper'

class ProjectSupportHours::CalculatorTest < ActiveSupport::TestCase
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

  context '#total_hours_used_for' do
    setup do
      setup_plugin_configuration
      @project = Project.generate!
    end

    should "return the sum of the project's TimeEntries" do
      user = User.generate_with_protected!
      activity = TimeEntryActivity.generate!
      
      assert_difference 'TimeEntry.count', 3 do
        TimeEntry.generate!(:user => user, :activity => activity, :project => @project, :hours => 5.50)
        TimeEntry.generate!(:user => user, :activity => activity, :project => @project, :hours => 2.00)
        TimeEntry.generate!(:user => user, :activity => activity, :project => @project, :hours => 0.50)
      end

      assert_equal 8.0, ProjectSupportHours::Calculator.total_hours_used_for(@project)
    end

    should "exclude time entries with the excluded activity" do
      user = User.generate_with_protected!
      activity = TimeEntryActivity.generate!
      assert_difference 'TimeEntry.count', 3 do
        TimeEntry.generate!(:user => user, :activity => activity, :project => @project, :hours => 5.50)
        TimeEntry.generate!(:user => user, :activity => activity, :project => @project, :hours => 2.00)
        TimeEntry.generate!(:user => user, :activity => activity, :project => @project, :hours => 0.50)
      end

      assert_difference 'TimeEntry.count', 3 do
        TimeEntry.generate!(:user => user, :activity => @excluded_time_entry_activity, :project => @project, :hours => 10.0)
        TimeEntry.generate!(:user => user, :activity => @excluded_time_entry_activity, :project => @project, :hours => 2.0)
        TimeEntry.generate!(:user => user, :activity => @excluded_time_entry_activity, :project => @project, :hours => 4.0)
      end

      assert_equal 8.0, ProjectSupportHours::Calculator.total_hours_used_for(@project)

    end
  end

  context '#total_hours_remaining_for' do
    setup do
      @project = Project.generate!
    end

    context 'configured project' do
      setup do
        setup_plugin_configuration
      end

      should "return the balance of the hours that have not been used" do
        user = User.generate_with_protected!
        activity = TimeEntryActivity.generate!
        @project.custom_values << CustomValue.spawn(:custom_field => @hours_custom_field, :customized_id => @project, :value => '20.585')
      
        assert_difference 'TimeEntry.count', 2 do
          TimeEntry.generate!(:user => user, :activity => activity, :project => @project, :hours => 5.50)
          TimeEntry.generate!(:user => user, :activity => activity, :project => @project, :hours => 2.00)
        end

        assert_equal 13.085, ProjectSupportHours::Calculator.total_hours_remaining_for(@project)
      end
    end

    context 'not configured project' do
      should 'return nil' do
        assert_nil ProjectSupportHours::Calculator.total_hours_remaining_for(@project)
      end
    end
  end

end

