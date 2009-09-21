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
    setup do
      setup_plugin_configuration
      @project = Project.generate!
      @user = User.generate_with_protected!
    end

    context "for hours" do
      should "do nothing if the hours_field is not configured" do
        configure_plugin('hours_field' => nil)
        hook :project => @project, :user => @user, :params => {:support => {:hours => 10.2}}
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
      should "do nothing if the start_date_field is not configured" do
        configure_plugin('start_date_field' => nil)
        hook :project => @project, :user => @user, :params => {:support => {:start_date => '2009-09-01'}}
        field = @project.custom_value_for(@start_date_custom_field)
        assert_equal nil, field.value
      end

      should "do nothing if the form paramters don't have start_date" do
        hook :project => @project, :user => @user
        field = @project.custom_value_for(@start_date_custom_field)
        assert_equal nil, field.value
      end

      should "save the form parameters to the project" do
        hook :project => @project, :user => @user, :params => {:support => {:start_date => '2009-09-01'}}
        field = @project.custom_value_for(@start_date_custom_field)
        assert_equal '2009-09-01', field.value
      end
    end

    context "for end date" do
      should "do nothing if the end_date_field is not configured" do
        configure_plugin('end_date_field' => nil)
        hook :project => @project, :user => @user, :params => {:support => {:end_date => '2009-09-22'}}
        field = @project.custom_value_for(@end_date_custom_field)
        assert_equal nil, field.value
      end

      should "do nothing if the form paramters don't have end_date" do
        hook :project => @project, :user => @user
        field = @project.custom_value_for(@end_date_custom_field)
        assert_equal nil, field.value
      end

      should "save the form parameters to the project" do
        hook :project => @project, :user => @user, :params => {:support => {:end_date => '2009-09-22'}}
        field = @project.custom_value_for(@end_date_custom_field)
        assert_equal '2009-09-22', field.value
      end
    end

  end
end
