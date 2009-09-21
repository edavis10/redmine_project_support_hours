require File.dirname(__FILE__) + '/../../../../test_helper'

class ProjectSupportHours::Hooks::ExternalSignupsUpdateHooksTest < Test::Unit::TestCase
  include Redmine::Hook::Helper

  def controller
    @controller ||= ExternalSignupsController.new
    @controller.response ||= ActionController::TestResponse.new
    @controller
  end

  def request
    @request ||= ActionController::TestRequest.new
  end

  def hook(args={})
    call_hook :plugin_external_signup_controller_external_signups_update, args
  end
    
  context "#plugin_external_signup_controller_external_signups_update" do

    should_set_the_fields_for_the_external_signups_controller do
      @project.reload
    end

  end
end
