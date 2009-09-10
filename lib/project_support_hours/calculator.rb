module ProjectSupportHours
  class Calculator
    # Gets the start_date for the project if set
    def self.start_date_for(project)
      start_date_field = project.custom_value_for(ProjectSupportHours::Mapper.start_date)
      start_date_field ? start_date_field.value : nil
    end
  end
end
