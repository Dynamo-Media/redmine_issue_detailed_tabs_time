require 'redmine'

module IssueDetailedTabs
  module Hooks
    class BaseHtmlHeadHook < Redmine::Hook::ViewListener
      # Adds javascript
      def view_layouts_base_html_head(context)
        javascript_include_tag('issue-history-tabs.js', :plugin => :redmine_issue_detailed_tabs_time)
      end
    end
  end
end
