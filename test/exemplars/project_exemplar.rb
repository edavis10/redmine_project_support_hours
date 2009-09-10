class Project < ActiveRecord::Base
  generator_for :name, :method => :next_name
  generator_for :identifier, :method => :next_identifier

  def self.next_name
    @last_name ||= 'Project 0'
    @last_name.succ!
    @last_name
  end
  
  def self.next_identifier
    @last_identifier ||= 'project0'
    @last_identifier.succ!
  end
end
