require 'redmine'

module IssueDetailedTabs
  module Hooks
    class MyAccountPrefsHook < Redmine::Hook::ViewListener
      render_on :view_my_account_preferences, :partial => 'my/tab_settings_form', :multipart => true
    end
  end
end
