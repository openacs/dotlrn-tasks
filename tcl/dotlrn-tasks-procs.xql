<?xml version="1.0"?>
<queryset>

<fullquery name="dotlrn_tasks::register_portlet_in_templates.get_portal_templates">
  <querytext>
        select
                portal_id
        from
                portals
        where
                name in ('#dotlrn.user_portal_pretty_name# Portal','#dotlrn.subcommunities_pretty_plural# Portal','#dotlrn.class_instance_portal_pretty_name# Portal','#dotlrn.clubs_pretty_plural# Portal')
                and template_id is null;
  </querytext>
</fullquery>

</queryset>


