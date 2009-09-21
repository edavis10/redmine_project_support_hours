module ProjectSupportHours
  module Hooks
    class ExternalSignupsHooks < Redmine::Hook::ViewListener

      def plugin_external_signup_controller_external_signups_create_pre_validate(context={})
        update_signup_controller_data(context)
      end

      def plugin_external_signup_controller_external_signups_update(context={})
        update_signup_controller_data(context)
        context[:project].save
      end

      private

      def update_signup_controller_data(context)
        configuration = Setting.plugin_redmine_project_support_hours
        params = context[:params]

        if params && params[:support]
          set_custom_value_on_project(context[:project], configuration['hours_field'], params[:support][:hours].to_f)
          set_custom_value_on_project(context[:project], configuration['start_date_field'], params[:support][:start_date])
          set_custom_value_on_project(context[:project], configuration['end_date_field'], params[:support][:end_date])
        end
      end

      def set_custom_value_on_project(project, custom_field, param)
        if param && custom_field.present?
          custom_field_record = CustomField.find_by_id(custom_field)

          if custom_field_record
            field = project.custom_value_for(custom_field_record)
            if field
              field.value = param
            else
              project.custom_values.build(:custom_field => custom_field_record, :value => param)
            end
          end
        end
      end

    end
  end
end

