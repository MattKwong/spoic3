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

//$(document).ready(function() {
//    $("#budget-toggle h3").click(function() {
//        $("div#budget-info").toggle("fast");
//    });
//});
//

$(document).ready(function() {
$("#budget-toggle h3").hover(function() {
$(this).addClass('hover');
}, function() {
$(this).removeClass('hover');
 });
});



//$(document).ready(function() {
//    $("#budget-toggle h3").trigger('click');
//});


//$(document).ready(function() {
//  $("#food-snapshot-toggle h3").click(function() {
//     $("div#food-snapshot-info").toggle("fast");
// });
//});

$(document).ready(function() {
$("#food-snapshot-toggle h3").hover(function() {
$(this).addClass('hover');
}, function() {
$(this).removeClass('hover');
 });
});
//$(document).ready(function() {
//    $("#food-snapshot-toggle h3").trigger('click');
//});
//
//$(document).ready(function() {
//  $("#projects-toggle h3").click(function() {
//     $("div#projects-info").toggle("fast");
// });
//});

$(document).ready(function() {
$("#projects-toggle h3").hover(function() {
$(this).addClass('hover');
}, function() {
$(this).removeClass('hover');
 });
});

//$(document).ready(function() {
//    $("#projects-toggle h3").trigger('click');
//});
//$(document).ready(function() {
//  $("#purchases-toggle h3").click(function() {
//     $("div#purchases-info").toggle("fast");
// });
//});

$(document).ready(function() {
$("#purchases-toggle h3").hover(function() {
$(this).addClass('hover');
}, function() {
$(this).removeClass('hover');
 });
});

//$(document).ready(function() {
//    $("#purchases-toggle h3").trigger('click');
//});
//
//$(document).ready(function() {
//  $("#sessions-toggle h3").click(function() {
//     $("div#sessions-info").toggle("fast");
// });
//});

$(document).ready(function() {
$("#sessions-toggle h3").hover(function() {
$(this).addClass('hover');
}, function() {
$(this).removeClass('hover');
 });
});

//$(document).ready(function() {
//    $("#sessions-toggle h3").trigger('click');
//});

//$(document).ready(function() {
//  $("#staff-toggle h3").click(function() {
//     $("div#staff-info").toggle("fast");
// });
//});

$(document).ready(function() {
$("#staff-toggle h3").hover(function() {
$(this).addClass('hover');
}, function() {
$(this).removeClass('hover');
});
});
//$(document).ready(function() {
//    $("#staff-toggle h3").trigger('click');
//});

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
    $("#budget-toggle").click(function(){
        $.get("3/get_budget_info",
            function(data){ $("#budget-info").html(data); }
        );
    });
});

$(document).ready(function() {
    $("#food-snapshot-toggle").click(function(){
        $.get("3/get_food_info",
            function(data){ $("#food-snapshot-info").html(data); }
        );
    });
});

$(document).ready(function() {
    $("#projects-toggle").click(function(){
        $.get("3/get_projects_info",
            function(data){ $("#projects-info").html(data); }
        );
    });
});

$(document).ready(function() {
    $("#purchases-toggle").click(function(){
        $.get("3/get_purchases_info",
            function(data){ $("#purchases-info").html(data); }
        );
    });
});
$(document).ready(function() {
    $("#sessions-toggle").click(function(){
        $.get("3/get_sessions_info",
            function(data){ $("#sessions-info").html(data); }
        );
    });
});

$(document).ready(function() {
    $("#staff-toggle").click(function(){
        $.get("3/get_staff_info",
            function(data){ $("#staff-info").html(data); }
        );
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
//    $("#itemType").change(function(){
//        $.get("get_item_categories?newValue="+$("#itemType").val(),
//        function(data){ $("#item_category_form").html(data); }
//        );
//    });
//});

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

//$(document).ready(function() {
//    $("#purchase_scopes").click(function(){
//        $.get("limit_purchases?scope="+$("#purchase_scopes").val(),
//            function(data){ $("#similar_items_table").html(data); }
//        );
//    });
//});