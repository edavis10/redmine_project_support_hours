require File.dirname(__FILE__) + '/../../../../test_helper'

class ProjectSupportHours::Hooks::ProjectHooksTest < Test::Unit::TestCase
  include Redmine::Hook::Helper

  def controller
    @controller ||= ProjectsController.new
    @controller.response ||= ActionController::TestResponse.new
    @controller
  end

  def request
    @request ||= ActionController::TestRequest.new
  end
    
  context "#view_projects_show_sidebar_bottom" do
    setup do
      @project = Project.generate!
      controller.stubs(:render_to_string).returns(:mock_result)
    end

    # MOCK
    should "render the sidebar partial" do
      controller.expects(:render_to_string).returns(:mock_result)
      call_hook(:view_projects_show_sidebar_bottom, :project => @project, :controller => controller)
    end
  end
end
