$(document).ready(function() {
 $("#general-toggle h3").click(function() {
     $("div#general-info").toggle("fast");
 });
});

$(document).ready(function() {
$("#general-toggle h3").hover(function() {
$(this).addClass('hover');
}, function() {
$(this).removeClass('hover');
 });
});

$(document).ready(function() {
 $("#plan-material-toggle h3").click(function() {
     $("div#plan-material-info").toggle("fast");
 });
});

$(document).ready(function() {
$("#plan-material-toggle h3").hover(function() {
$(this).addClass('hover');
}, function() {
$(this).removeClass('hover');
 });
});

$(document).ready(function() {
 $("#plan-summary-toggle h3").click(function() {
     $("div#plan-material-summary").toggle("fast");
 });
});

$(document).ready(function() {
$("#plan-summary-toggle h3").hover(function() {
$(this).addClass('hover');
}, function() {
$(this).removeClass('hover');
 });
});

$(document).ready(function() {
 $("#deliveries-toggle h3").click(function() {
     $("div#deliveries-info").toggle("fast");
 });
});

$(document).ready(function() {
$("#deliveries-toggle h3").hover(function() {
$(this).addClass('hover');
}, function() {
$(this).removeClass('hover');
 });
});

$(document).ready(function() {
 $("#labor-toggle h3").click(function() {
     $("div#labor-info").toggle("fast");
 });
});

$(document).ready(function() {
$("#labor-toggle h3").hover(function() {
$(this).addClass('hover');
}, function() {
$(this).removeClass('hover');
 });
});

$(document).ready(function() {
 $("#labor-item-toggle h3").click(function() {
     $("div#labor-item-info").toggle("fast");
 });
});

$(document).ready(function() {
$("#labor-item-toggle h3").hover(function() {
$(this).addClass('hover');
}, function() {
$(this).removeClass('hover');
 });
});

$(document).ready(function() {
 $("#deliver-material-toggle h3").click(function() {
     $("div#deliver-material-info").toggle("fast");
 });
});
$(document).ready(function() {
$("#deliver-material-toggle h3").hover(function() {
$(this).addClass('hover');
}, function() {
$(this).removeClass('hover');
 });
});
$(document).ready(function() {
 $("#budget-toggle h3").click(function() {
     $("tbody#budget-info").toggle("fast");
 });
});

$(document).ready(function() {
$("#budget-toggle h3").hover(function() {
$(this).addClass('hover');
}, function() {
$(this).removeClass('hover');
 });
});

$(document).ready(function() {
  $("#food-snapshot-toggle h3").click(function() {
     $("tbody#food-snapshot-info").toggle("fast");
 });
});

$(document).ready(function() {
$("#food-snapshot-toggle h3").hover(function() {
$(this).addClass('hover');
}, function() {
$(this).removeClass('hover');
 });
});

$(document).ready(function() {
  $("#projects-toggle h3").click(function() {
     $("div#projects-info").toggle("fast");
 });
});

$(document).ready(function() {
$("#projects-toggle h3").hover(function() {
$(this).addClass('hover');
}, function() {
$(this).removeClass('hover');
 });
});

$(document).ready(function() {
  $("#purchases-toggle h3").click(function() {
     $("div#purchases-info").toggle("fast");
 });
});

$(document).ready(function() {
$("#purchases-toggle h3").hover(function() {
$(this).addClass('hover');
}, function() {
$(this).removeClass('hover');
 });
});

$(document).ready(function() {
  $("#sessions-toggle h3").click(function() {
     $("div#sessions-info").toggle("fast");
 });
});

$(document).ready(function() {
$("#sessions-toggle h3").hover(function() {
$(this).addClass('hover');
}, function() {
$(this).removeClass('hover');
 });
});

$(document).ready(function() {
  $("#staff-toggle h3").click(function() {
     $("div#staff-info").toggle("fast");
 });
});

$(document).ready(function() {
$("#staff-toggle h3").hover(function() {
$(this).addClass('hover');
}, function() {
$(this).removeClass('hover');
 });
});

$(document).ready(function() {
  $("input.group-change-button").attr("disabled", "disabled");
});

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

$(document).ready(function() {
    $("#itemDropdown").change(function(){
        $.get("update_item_info/"+$("#itemDropdown").val(),
        function(data){ $("#item_info_table").html(data); }
        );
    });
});

$(document).ready(function() {
    $("#newItemField").change(function(){
        $.get("show_similar_items?newValue="+$("#newItemField").val(),
        function(data){ $("#similar_items_table").html(data); }
        );
    });
});

//
//$(document).ready(function() {
//    $("#item-filter").change(function(){
//        $location.reload();
//    });
//});
$(document).ready(function() {
 $("#recorded-items-toggle h3").click(function() {
     $("div#recorded-items-info").toggle("fast");
 });
});


$(document).ready(function() {
 $("#recorded-items-toggle h3").trigger('click');
});

$(document).ready(function() {
$("#recorded-items-toggle h3").hover(function() {
$(this).addClass('hover');
}, function() {
$(this).removeClass('hover');
 });
});

$(document).ready(function() {
    $("#purchase_scopes").click(function(){
        $.get("limit_purchases?scope="+$("#purchase_scopes").val(),
            function(data){ $("#similar_items_table").html(data); }
        );
    });
});