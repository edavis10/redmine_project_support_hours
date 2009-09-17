require File.dirname(__FILE__) + '/../../../../test_helper'

class ProjectSupportHours::Hooks::ExternalSignupsHooksTest < Test::Unit::TestCase
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
    setup do
      setup_plugin_configuration
      @project = Project.generate!
      @user = User.generate_with_protected!
    end

    # These "should" be automatic but lets test our assumptions
    should "have the custom fields added to the project" do
      hook :project => @project, :user => @user
      assert !@project.custom_values.empty?
      assert_contains @project.custom_values.collect(&:custom_field), @hours_custom_field
      assert_contains @project.custom_values.collect(&:custom_field), @start_date_custom_field
      assert_contains @project.custom_values.collect(&:custom_field), @end_date_custom_field
    end
    
    context "for hours" do
      should "do nothing if the hours_field is not configured" do
        configure_plugin('hours_field' => nil)
        hook :project => @project, :user => @user
        field = @project.custom_values.find_by_custom_field_id(@hours_custom_field)
        assert_equal nil, field.value
      end

      should "do nothing if the form paramters don't have hours" do
        hook :project => @project, :user => @user
        field = @project.custom_values.find_by_custom_field_id(@hours_custom_field)
        assert_equal nil, field.value
      end

      should "save the form parameters to the project" do
        hook :project => @project, :user => @user, :params => {:support => {:hours => 10.2}}
        field = @project.custom_value_for(@hours_custom_field)
        assert_equal 10.2, field.value
      end
    end
    
    context "for start date" do
      should "do nothing if the start_date_field is not configured"
      should "do nothing if the form paramters don't have a start date"
      should "save the form parameters to the project"
    end

    context "for end date" do
      should "do nothing if the end_date_field is not configured"
      should "do nothing if the form paramters don't have a end date"
      should "save the form parameters to the project"
    end

  end
end
