module RedmineIssueDetailedTabsTimeIssuesHelperPatch
  module IssuesHelperPatch
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
      def reply_links
        authorize_for('issues', 'edit')
      end
      
      def validTabs 
        ['history_comments','history_all','history_activity','history_private','tabtime_time']
      end
      
      def get_issue_history_index(index, count)
        if User.current.wants_comments_in_reverse_order?
          return count - index + 1
        else
          return index
        end
      end
      
      def get_issue_history_tab_entries()
        # Get a list of all journals and time entries to iterate through.  This ensures
        # that the bookmarks will be consistent for all users regardless of permission
        # level.  Combine the list for journals and time entries and sort by date. This
        # intersperses the time entries and journals together in chronological order.
        entries = @issue.journals + @issue.time_entries
        entries.sort! { |x,y| x.created_on <=> y.created_on }
        entries.reverse! if User.current.wants_comments_in_reverse_order?
        entries
      end
      
      def get_issue_history_tabs(entries, journals)
        tabs = []
        # we will first go trough all the items once so that we can determine what
        # tabs are available for us to select default tab or tab in url
        tabs.push({:label => :label_history_tab_all, :name => 'history_all'}) if User.current.allowed_to?(:view_all,@project,:global => true)
        for entry in entries
          if entry.is_a?(Journal) && journals.include?(entry) 
            tabs.push({:label => :label_history_tab_comments, :name => 'history_comments'}) if entry.notes? && User.current.allowed_to?(:view_comments,@project,:global => true)
            tabs.push({:label => :label_history_tab_private, :name => 'history_private'} ) if entry.private_notes?
            tabs.push( {:label => :label_history_tab_activity, :name => 'history_activity'}) if (entry.details.any?) && User.current.allowed_to?(:view_activity,@project,:global => true)
          elsif entry.is_a?(TimeEntry) && User.current.allowed_to?(:view_time_entries, @project) 
            tabs.push( {:label => :label_history_tab_time, :name => 'tabtime_time'})    
          end
        end 
        tabs
      end
      
      def get_selected_issue_history_tab(tabs)
        tabsContainContent = []
        tabs.each { |tab| tabsContainContent.push(tab[:name])}
        if validTabs.include?(params[:tab]) && tabsContainContent.include?(params[:tab]) 
          selected_tab = params[:tab]
        end
        selected_tab ||= validTabs.each.find{ |v| tabsContainContent.include? v }
      end
      
      def draw_entries_in_issue_history_tab(entries, journals)
        c = ""
        index = 1
        for entry in entries
            c << draw_entry_in_tab(entry, get_issue_history_index(index, entries.count), journals)
            index += 1
        end #for entries
        c
      end
      
      def draw_entry_in_tab(entry, index, journals)
        c = ""
        if entry.is_a?(Journal) && journals.include?(entry) # only show if visible
          c << draw_journal_in_tab(entry, index)
        elsif entry.is_a?(TimeEntry)
          c << draw_timelog_in_tab(entry, index)
        end
        c
      end
      
      def draw_journal_in_tab(journal, index)
        c = ""
        # this is a check to ensure that the journal entry should be visible for the user.
        if (((journal.details.any?) && User.current.allowed_to?(:view_activity,@project,:global => true)) || journal.private_notes? || (journal.notes? && User.current.allowed_to?(:view_comments,@project,:global => true)))
          c << "<div id='change-#{journal.id}' class='#{journal.css_classes}'>"
            c << "<h4>"
              c << link_to("##{index}", {:anchor => "note-#{index}"}, :class => "journal-link" )
              c << avatar(journal.user, :size => "24")
              c << content_tag('a', '', :name => "note-#{index}")
              c << authoring(journal.created_on, journal.user, :label => :label_updated_time_by)
            c << "</h4>"
          
            if (journal.details.any?) && User.current.allowed_to?(:view_activity,@project,:global => true)
              c << "<ul class='details'>"
                details_to_strings(journal.details).each do |string|
                c << "<li>" + string + "</li>"
                end
              c << "</ul>"
            end
            if User.current.allowed_to?(:view_comments,@project,:global => true) || journal.private_notes?
              c << render_notes(@issue, journal, :reply_links => reply_links) unless journal.notes.blank?
            end
          c << "</div>" 
        end
        c <<  call_hook(:view_issues_history_journal_bottom, { :journal => journal })
        c
      end
      
      def draw_timelog_in_tab(timelog, index)
        c = ""
        if User.current.allowed_to?(:view_time_entries, @project) 
          c << "<div id='time-#{timelog.id}' class='journal has-time'>"
            c << "<h4>"
              c << link_to("##{index}", {:anchor => "note-#{index}"}, :class => "journal-link")
              c << avatar(timelog.user, :size => "24")
              c << content_tag('a', '', :name => "note-#{index}")
              c << authoring(timelog.created_on, timelog.user, :label => :label_history_time_logged_by) 
            c << '</h4>'
            c << '<ul class="details">'
              c << '<li><strong>'+ l(:label_history_time_spent) + ":</strong> " + html_hours("%.2f" % timelog.hours) + " " + l(:label_history_time_hours_on) + " " + h(timelog.activity) + '</li>'
              unless timelog.comments.nil? || timelog.comments.empty?     
                c << '<li><blockquote><p>' + timelog.comments + '</p></blockquote></li>'
              end
            c << '</ul>'
          c << '</div>'
        end
        c
      end
    end
  end
end

IssuesHelper.send(:include, RedmineIssueDetailedTabsTimeIssuesHelperPatch::IssuesHelperPatch)