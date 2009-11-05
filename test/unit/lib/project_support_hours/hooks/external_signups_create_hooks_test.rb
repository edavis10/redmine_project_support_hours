require File.dirname(__FILE__) + '/../../../../test_helper'

if Redmine::Plugin.all.collect(&:id).include? :redmine_external_signup
  
class ProjectSupportHours::Hooks::ExternalSignupsCreateHooksTest < Test::Unit::TestCase
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
    call_hook :plugin_external_signup_controller_external_signups_create_pre_validate, args
  end
    
  context "#plugin_external_signup_controller_external_signups_create_pre_validate" do

    should_set_the_fields_for_the_external_signups_controller

  end
end

else
print 'P'
end
