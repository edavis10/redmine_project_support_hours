module ProjectSupportHours
  module Hooks
    class ExternalSignupsHooks < Redmine::Hook::ViewListener

      def plugin_external_signup_controller_external_signups_create_pre_validate(context={})
        configuration = Setting.plugin_redmine_project_support_hours
        params = context[:params]

        if params && params[:support]
          # Support hours
          if params[:support][:hours] && configuration['hours_field'].present?
            field = context[:project].custom_value_for(configuration['hours_field'])
            field.value = params[:support][:hours] if field
          end
          
        end
      end

    end
  end
end

