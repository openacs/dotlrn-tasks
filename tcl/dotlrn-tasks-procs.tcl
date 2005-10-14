#  Copyright (C) 2001, 2002 MIT
#  This file is part of dotLRN.
#  dotLRN is free software; you can redistribute it and/or modify it under the
#  terms of the GNU General Public License as published by the Free Software
#  Foundation; either version 2 of the License, or (at your option) any later
#  version.
#  dotLRN is distributed in the hope that it will be useful, but WITHOUT ANY
#  WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
#  FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
#  details.

ad_library {
    
    the dotlrn applet for calendar
    
    @author Miguel Marin (miguelmarin@viaro.net)
    @author Viaro Networks www.viaro.net

}

namespace eval dotlrn_tasks {}

ad_proc -public dotlrn_tasks::package_key {
} {
    What package does this applet deal with?
} {
    return "tasks"
}

ad_proc -public dotlrn_tasks::my_package_key {
} {
    What's my package key?
} {
    return "dotlrn-tasks"
}

ad_proc -public dotlrn_tasks::applet_key {
} {
    What's my applet key?
} {
    return "dotlrn_tasks"
}

ad_proc -public dotlrn_tasks::get_pretty_name {
} {
} {
    return "Tasks"
}

ad_proc -public dotlrn_tasks::add_applet {
} {
    Called for one time init - must be repeatable!
    @return new pkg_id or 0 on failure
} {
    
    # FIXME: won't work with multiple dotlrn instances Use the package_key
    # for the -url param - "/" are not allowed!
    
    set package_id 0
    
    dotlrn_applet::add_applet_to_dotlrn -applet_key [applet_key] -package_key [my_package_key]
    
}

ad_proc -public dotlrn_tasks::remove_applet {
} {
    One-time destroy for when the entire applet is removed from dotlrn.
} {
    ad_return_complaint 1 "[applet_key] remove_applet not implimented!"
}

ad_proc -public dotlrn_tasks::tasks_create_helper {
    {-community_id:required}
    {-package_id:required}
} {
    A helper proc to create a tasks for a comm, returns the new calendar_id
} {
    return "00"
}

ad_proc -public dotlrn_tasks::add_applet_to_community {
    community_id
} {
    Add the tasks applet to a specific dotlrn community
} {
    set results [add_applet_to_community_helper -community_id $community_id]
    
    return [lindex $results 0]
}

ad_proc -public dotlrn_tasks::add_applet_to_community_helper {
    {-community_id:required}
} {
    Add the tasks applet to a specific dotlrn community
    
    @params community_id
} {
    
    # Create and Mount the Tasks Package
    set package_id [apm_package_id_from_key tasks]
    
    # Set up the tasks portlet for this portal/community
    
    set portal_id [dotlrn_community::get_portal_id \
		       -community_id $community_id]
    
    # Add the portlet to the Portal.
    
    tasks_portlet::add_self_to_page -portal_id $portal_id -package_id $package_id
    
    # this should return the package_id
    return $package_id
}

ad_proc -public dotlrn_tasks::remove_applet_from_community {
    community_id
} {
    remove the applet from the community
} {
    ad_return_complaint 1 "[applet_key] remove_applet_from_community not implimented!"
}

ad_proc -public dotlrn_tasks::add_user {
    user_id
} {
    Called once when a user is added as a dotlrn user.
} {
}

ad_proc -public dotlrn_tasks::remove_user {
    user_id
} {
    Remove a user from dotlrn
} {
    
    # Not yet implemented.
}

ad_proc -public dotlrn_tasks::add_user_to_community {
    community_id
    user_id
} {
    Add a user to a community
} {
    
    set package_id [dotlrn_community::get_applet_package_id \
			-community_id $community_id \
			-applet_key [applet_key]]

    set portal_id [dotlrn::get_portal_id -user_id $user_id]
    
    # use "append" here since we want to aggregate
    set param_action append
    
    tasks_portlet::add_self_to_page \
        -portal_id $portal_id \
        -package_id $package_id \
        -param_action $param_action
}

ad_proc -public dotlrn_tasks::remove_user_from_community {
    community_id
    user_id
} {
    Remove a user from a community
} {
}

ad_proc -public dotlrn_tasks::add_portlet {
    portal_id
} {
    Set up default params for templates about to call add_portlet_helper
    
    @param portal_id
} {

    tasks_portlet::add_self_to_page \
	-portal_id $portal_id \
	-package_id 0
}

ad_proc -public dotlrn_tasks::remove_portlet {
    portal_id
    args
} {
    A helper proc to remove the underlying portlet from the given portal.
    This is alot simpler than add_portlet.
    
    @param portal_id
} {
    set package_id [dotlrn_community::get_applet_package_id -community_id $community_id -applet_key [applet_key]]
    tasks_portlet::remove_self_from_page \
	-portal_id $portal_id \
	-package_id $pacakge_id]
}

ad_proc -public dotlrn_tasks::clone {
    old_community_id
    new_community_id
} {
    Clone this applet's content from the old community to the new one
} {
}

ad_proc -public dotlrn_tasks::change_event_handler {
    community_id
    event
    old_value
    new_value
} {
    listens for the following events: rename
} {

}

# Some dotlrn_project_manager specific procs

ad_proc -private dotlrn_tasks::register_portlet_in_templates {

} {
    Procedure that register the portal in the user, communities, classes and subcomunnities
    Templates
} {
    # We are going to add the portlet of tasks to the
    # templates
    
    db_foreach get_portal_templates { } {
	tasks_portlet::add_self_to_page -portal_id $portal_id -package_id 0
    }

}