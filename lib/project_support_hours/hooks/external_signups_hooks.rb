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

          # Start date
          if params[:support][:start_date] && configuration['start_date_field'].present?
            field = context[:project].custom_value_for(configuration['start_date_field'])
            field.value = params[:support][:start_date] if field
          end

          # End date
          if params[:support][:end_date] && configuration['end_date_field'].present?
            field = context[:project].custom_value_for(configuration['end_date_field'])
            field.value = params[:support][:end_date] if field
          end

        end
      end

    end
  end
end

