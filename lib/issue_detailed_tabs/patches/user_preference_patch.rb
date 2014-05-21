module IssueDetailedTabs
  module Patches

    module UserPreferencePatch
      unloadable
      
      def self.included(base)
        base.extend(ClassMethods)
        base.send(:include, InstanceMethods)
        base.class_eval do
        end
      end
      
      module ClassMethods
      end
      
      module InstanceMethods
	  def default_history_tab; self[:default_history_tab] end
	  def default_history_tab=(value); self[:default_history_tab]=value end

          def def_history_tab
            return Setting[:plugin_redmine_issue_detailed_tabs_time][:default_tab] unless default_history_tab
            return Setting[:plugin_redmine_issue_detailed_tabs_time][:default_tab] if default_history_tab == 'use_global_settings'
            return default_history_tab
          end
           
      end

    end
  end
end

UserPreference.send(:include,  IssueDetailedTabs::Patches::UserPreferencePatch)
