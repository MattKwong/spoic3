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
var budgetState = 'new'
$(document).ready(function() {
    $("#budget-toggle").click(function(){
        if(budgetState == 'new') {
            $.get($('div#program-number').text() + "/get_budget_info",
                function(data){ $("#budget-info").html(data);} )
            budgetState = 'loaded'; }
        else { $("div#budget-info").toggle("fast"); }
    });
});

var foodSnapshotState = 'new'
$(document).ready(function() {
    $("#food-snapshot-toggle").click(function(){
        if(foodSnapshotState == 'new') {
            $.get($('div#program-number').text() + "/get_food_info",
                function(data){ $("#food-snapshot-info").html(data);} )
            foodSnapshotState = 'loaded'; }
        else { $("div#food-snapshot-info").toggle("fast"); }

    });
});
//
//$(document).ready(function() {
//    $("#projects-toggle").click(function(){
//        $.get($('div#program-number').text() + "/get_projects_info",
//            function(data){ $("#projects-info").html(data); }
//        );
//    });
//});
var projectsState = 'new'
$(document).ready(function() {
    $("#projects-toggle").click(function(){
        if(projectsState == 'new') {
            $.get($('div#program-number').text() + "/get_projects_info",
                function(data){ $("#projects-info").html(data);} )
            projectsState = 'loaded'; }
        else { $("div#projects-info").toggle("fast"); }

    });
});

$(document).ready(function() {
    $("#past7-select").click(function(){
        $.get($('div#program-number').text() + "/get_purchases_info?scope=past7",
            function(data){ $("#purchases-info").html(data); }
        );
    });
});
var purchasesState = 'new'
$(document).ready(function() {
    $("#purchases-toggle").click(function(){
        if(purchasesState == 'new') {
            $.get($('div#program-number').text() + "/get_purchases_info",
                function(data){ $("#purchases-info").html(data);} )
            purchasesState = 'loaded'; }
        else { $("div#purchases-info").toggle("fast"); }
    });
});

var sessionsState = 'new'
$(document).ready(function() {
    $("#sessions-toggle").click(function(){
        if(sessionsState == 'new') {
            $.get($('div#program-number').text() + "/get_sessions_info",
                function(data){ $("#sessions-info").html(data);} )
            sessionsState = 'loaded'; }
        else { $("div#sessions-info").toggle("fast"); }
    });
});
//$(document).ready(function() {
//    $("#sessions-toggle").click(function(){
//        $.get($('div#program-number').text() + "/get_sessions_info",
//            function(data){ $("#sessions-info").html(data); }
//        );
//    });
//});
var staffState = 'new'
$(document).ready(function() {
    $("#staff-toggle").click(function(){
        if(staffState == 'new') {
            $.get($('div#program-number').text() + "/get_staff_info",
                function(data){ $("#staff-info").html(data);} )
            staffState = 'loaded'; }
        else { $("div#staff-info").toggle("fast"); }

    });
});

//$(document).ready(function() {
//    $("#staff-toggle").click(function(){
//        $.get($('div#program-number').text() + "/get_staff_info",
//            function(data){ $("#staff-info").html(data); }
//        );
//    });
//});

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