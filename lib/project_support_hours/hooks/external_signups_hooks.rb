module ProjectSupportHours
  module Hooks
    class ExternalSignupsHooks < Redmine::Hook::ViewListener

      def plugin_external_signup_controller_external_signups_create_pre_validate(context={})
        configuration = Setting.plugin_redmine_project_support_hours
        params = context[:params]

        if params && params[:support]
          set_custom_value_on_project(context[:project], configuration['hours_field'], params[:support][:hours])
          set_custom_value_on_project(context[:project], configuration['start_date_field'], params[:support][:start_date])
          set_custom_value_on_project(context[:project], configuration['end_date_field'], params[:support][:end_date])
        end
      end

      private

      def set_custom_value_on_project(project, custom_field, param)
        if param && custom_field.present?
          field = project.custom_value_for(custom_field)
          field.value = param if field
        end
      end

    end
  end
end

