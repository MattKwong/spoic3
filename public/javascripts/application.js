// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

// These routines change the disabled submit changes button on the group
// change page from disabled to enabled when a changed value has been input
$(document).ready(function() {
  $("input.group-change-button").attr("disabled", "disabled");
});

$(document).ready(function() {
    $('#scheduled_group_current_youth').change(function() {
        $("input.[type=submit]").removeAttr("disabled");
    });
    $('#scheduled_group_current_counselors').change(function() {
        $("input[type=submit]").removeAttr("disabled");
    });
    $('#scheduled_group_session_id').change(function() {
        $("input[type=submit]").removeAttr("disabled");
    });
});

$(document).ready(function() {
  $('input.jq-date').live("focus", function() {
    $(this).datepicker();
  });
  $('select.jq-combo').combobox();

  $('#action-links div').buttonset();

  $("input[type='submit']").button();


  $("ul.orderable").sortable({
      axis: 'y',
      dropOnEmpty: false,
      cursor: 'crosshair',
      items: 'li',
      opacity: 0.4,
      scroll: true,
      update: function () {
        $this = $(this);
        $.ajax({
          type: 'post',
          data: $(this).sortable('serialize'),
          dataType: 'script',
          complete: function () {
              $this.effect('highlight');
            },
          url: $(this).attr('url')
          });
        }
      });

});