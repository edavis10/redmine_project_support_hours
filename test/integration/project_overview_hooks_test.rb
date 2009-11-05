require File.dirname(__FILE__) + '/../test_helper'

class ProjectOverviewHooksTest < ActionController::IntegrationTest
  def get_project_overview
    get "/projects/#{@project.identifier}"
  end

  context "the project overview page" do
    setup do
      @project = Project.generate!
      setup_plugin_configuration
      setup_non_member_role
      setup_anonymous_role
    end

    context "in the support time section" do
      context "start date" do
        should "not be displyed if it's empty" do
          get_project_overview

          assert_select '#project-support-hours li.start-date', 0
        end

        should "be formatted based on the user's language" do
          @project.custom_values << CustomValue.spawn(:custom_field => @start_date_custom_field, :customized_id => @project, :value => '2009-09-10')

          get_project_overview

          assert_select '#project-support-hours li.start-date', "Start Date: 09/10/2009"
        end
      end
      
      context "for end date" do
        should "not be displyed if it's empty" do
          get_project_overview

          assert_select '#project-support-hours li.start-date', 0
        end

        should "be formatted  based on the user's language" do
          @project.custom_values << CustomValue.spawn(:custom_field => @end_date_custom_field, :customized_id => @project, :value => '2009-09-22')

          get_project_overview

          assert_select '#project-support-hours li.end-date', "End Date: 09/22/2009"
        end
      end

      should "show the total hours on the project" do
        @project.custom_values << CustomValue.spawn(:custom_field => @hours_custom_field, :customized_id => @project, :value => '100.25')

        get_project_overview

        assert_select "#project-support-hours li.support-hours-total", /100\.25/
      end

      should "show the hours remaining" do
        @project.custom_values << CustomValue.spawn(:custom_field => @hours_custom_field, :customized_id => @project, :value => '100.25')

        user = User.generate_with_protected!
        activity = TimeEntryActivity.generate!
      
        assert_difference 'TimeEntry.count', 3 do
          3.times do 
            TimeEntry.generate!(:user => user, :activity => activity, :project => @project, :hours => 10.0)
          end
        end

        get_project_overview

        assert_select "#project-support-hours li.support-hours-remaining", /70\.25/

      end
    end
  end
end
