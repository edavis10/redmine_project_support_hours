module ProjectSupportHours
  module Hooks
    class ExternalSignupsHooks < Redmine::Hook::ViewListener

      def plugin_external_signup_controller_external_signups_create_pre_validate(context={})
      end

    end
  end
end

