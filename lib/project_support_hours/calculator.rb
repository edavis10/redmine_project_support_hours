module ProjectSupportHours
  class Calculator
    # Gets the start_date for the project if set
    def self.start_date_for(project)
      start_date_field = project.custom_value_for(ProjectSupportHours::Mapper.start_date)
      start_date_field ? start_date_field.value : nil
    end

    # Gets the end_date for the project if set
    def self.end_date_for(project)
      end_date_field = project.custom_value_for(ProjectSupportHours::Mapper.end_date)
      end_date_field ? end_date_field.value : nil
    end
    
    # Gets the total support hours for the project if set
    def self.total_support_hours_for(project)
      hours_field = project.custom_value_for(ProjectSupportHours::Mapper.hours)
      hours_field ? hours_field.value.to_f : nil
    end

    def self.total_hours_used_for(project)
      project.time_entries.sum('hours', :conditions => ["activity_id NOT IN (?)",
                                                        Setting.plugin_redmine_project_support_hours['excluded_activities']])
    end

    def self.total_hours_remaining_for(project)
      total_hours = total_support_hours_for(project)
      if total_hours
        total_hours - total_hours_used_for(project)
      else
        nil
      end
    end
  end
end
