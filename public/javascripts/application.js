// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

// These routines change the disabled submit changes button on the group
// change page from disabled to enabled when a changed value has been input
//$(document).ready(function() {
//  $("input[type=submit]").attr("disabled", "disabled");
//});

$(document).ready(function() {
    $('#scheduled_group_current_youth').change(function() {
        $("input[type=submit]").removeAttr("disabled");
    });
    $('#scheduled_group_current_counselors').change(function() {
        $("input[type=submit]").removeAttr("disabled");
    });
    $('#scheduled_group_session_id').change(function() {
        $("input[type=submit]").removeAttr("disabled");
    });
});
