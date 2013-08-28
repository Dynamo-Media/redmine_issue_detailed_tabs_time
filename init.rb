require 'redmine'
require 'issue_tabs_listener.rb'

Redmine::Plugin.register :redmine_issue_detailed_tabs_time do
  
  project_module :issue_tracking do
	  permission :view_all, { :all => :index }
	  permission :view_comments, { :all => :index }
	  permission :view_activity, { :all => :index }
  end
  
  name 'Redmine Issue Detailed Tabs & Time'
  author 'Mark Kalender'
  description 'This plugin provide breaks down issues comments into tabs, also adds a time log'
  version '0.1.0'
end
