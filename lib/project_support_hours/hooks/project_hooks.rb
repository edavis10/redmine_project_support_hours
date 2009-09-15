module ProjectSupportHours
  module Hooks
    class ProjectHooks < Redmine::Hook::ViewListener

      def view_projects_show_sidebar_bottom(context={})
        start_date = ProjectSupportHours::Calculator.start_date_for(context[:project])
        end_date = ProjectSupportHours::Calculator.end_date_for(context[:project])
        total_hours = ProjectSupportHours::Calculator.total_support_hours_for(context[:project]).to_f.round_with_precision(2)
        remaining_hours = ProjectSupportHours::Calculator.total_hours_remaining_for(context[:project]).to_f.round_with_precision(2)

        return context[:controller].send(:render_to_string, {
                                           :partial => 'project_support_hours/sidebar',
                                           :locals => {
                                             :project => context[:project],
                                             :total_hours => total_hours,
                                             :remaining_hours => remaining_hours,
                                             :start_date => start_date,
                                             :end_date => end_date
                                           },
                                           :layout => false
                                         })
      end

    end
  end
end

