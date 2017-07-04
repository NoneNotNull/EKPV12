seajs.use(['lang!sys-ui','lang!sys-task'],function(lang,taskLang){
var calendar = layout.calendar;
var frame = null;
function createFrame(){
	return $('<div class="lui_calendar_frame"/>');
}
function createDefaultContent(){
	return $('<div data-lui-mark="calender.content.inside.default" class="lui_calendar_content"/>');
}
function createListContent(){
	return $('<div data-lui-mark="calender.content.inside.list" class="lui_calendar_content"/>');
}
function createHeader(){
	var headObj = $('<div class="lui_calendar_header"/>');
	var tabTmp = $('<table class="lui_calendar_header_tab"/>').appendTo(headObj);
	var trTmp  = $('<tr/>').appendTo(tabTmp);
	var leftTd = $('<td class="lui_calendar_header_left"/>').appendTo(trTmp);
	$('<div cal-opt="prev"/>').append('<span class="lui_calendar_header_prev"/>').appendTo(leftTd).click(function(){
		calendar.prev();
	});
	$('<div cal-opt="next"/>').append('<span class="lui_calendar_header_next"/>').appendTo(leftTd).click(function(){
		calendar.next();
	});
	$('<div class="lui_calendar_header_today" cal-opt="today">'+lang['ui.calendar.today']+'</div>').appendTo(leftTd).click(function(){
		calendar.today();
	});
	var centerTd = $('<td class="lui_calendar_header_center"/>').appendTo(trTmp);
	$('<div class="lui_calendar_header_title"/>').appendTo(centerTd);
	
	var rightTd = $('<td class="lui_calendar_header_right"/>').appendTo(trTmp);
	
	$('<div class="lui_calendar_header_month" cal-opt="month" cal-mode="default">'+lang['ui.calendar.mode.month']+'</div>').appendTo(rightTd).click(function(){
		calendar.changeView('month');
	});
	
	$('<div class="lui_calendar_header_month" cal-opt="agendaWeek" cal-mode="default">'+lang['ui.calendar.mode.week']+'</div>').appendTo(rightTd).click(function(){
		calendar.changeView('agendaWeek');
	});
	
	$('<div class="lui_calendar_header_list" cal-mode="default"/>').appendTo(rightTd).click(function(){
		calendar.changeMode('list');
	});
	
	$('<div class="lui_calendar_header_date" cal-mode="list"/>').appendTo(rightTd).click(function(){
		calendar.changeMode('default');
	});
	
	$('<div class="lui_calendar_header_refresh"/>').appendTo(rightTd).click(function(){
		calendar.refreshSchedules();
	});
	
	//按任务状态
	var ul=$("<ul class='calendar_status_dropdown calendar_dropdown'/>")
					.append("<li  class='setting_select_on'><span ><a onclick='changeStatus(this,\"all\");'>"+taskLang['calendar.complete.all']+"</a></span></li>"
								+"<li><span><a onclick='changeStatus(this,\"no\");'>"+taskLang['calendar.complete.false']+"</a></span></li>"
								+"<li><span><a onclick='changeStatus(this,\"yes\");'>"+taskLang['calendar.complete.true']+"</a></span></li>");
	$("<div class='calendar-setting' id='calendar_status' unselectable='on'>"+taskLang['sysTaskMain.fdStatus']+"<i class='trig'></i></div>")
		.append($("<div id='setting_status_down' />").append(ul))
		.appendTo(rightTd).mousemove(function(evt){ 
            $(".calendar_status_dropdown").show();
        }).mouseleave(function (evt) {
            $('.calendar_status_dropdown').hide();
        });
	
	//显示时间
	var ul=$("<ul class='calendar_date_dropdown calendar_dropdown'/>")
					.append("<li  class='setting_select_on'><span><a onclick='changeDate(this,\"createTime\");'>"+taskLang['calendar.select.createTime']+"</a></span></li>"
								+"<li><span><a onclick='changeDate(this,\"completeTime\");'>"+taskLang['calendar.select.completeTime']+"</a></span></li>"
								+"<li><span><a onclick='changeDate(this,\"feedbackTime\");'>"+taskLang['calendar.select.feedbackTime']+"</a></span></li>");
	$("<div class='calendar-setting' id='calendar_date' unselectable='on'>"+taskLang['calendar.show.mode']+"<i class='trig'></i></div>")
		.append($("<div id='setting_date_down' />").append(ul))
		.appendTo(rightTd).mousemove(function(evt){ 
            $(".calendar_date_dropdown").show();
        }).mouseleave(function (evt) {
            $('.calendar_date_dropdown').hide();
        });

	return headObj;
}

function displayChange(info){
	var mode = info.mode;
	var view = info.view;
	frame.find(".lui_calendar_header_tab div[cal-mode]").hide();
	frame.find(".lui_calendar_header_tab div[cal-mode='" + mode + "']").show();
	if(view!=null){
		$(".lui_calendar_header .lui_calendar_header_center .lui_calendar_header_title").text(view.title);
		$(".lui_calendar_header_tab div[cal-opt]").removeClass("lui_calendar_header_button_on");
		$(".lui_calendar_header_tab div[cal-opt='"+view.name+"']").addClass("lui_calendar_header_button_on");
		var today = new Date().getTime();
		if(view.start.getTime() <= today && today <= view.end.getTime() ){
			$(".lui_calendar_header_tab div[cal-opt='today']").addClass("lui_calendar_header_button_on");
		}
	}
}

var frame = createFrame();
frame.append(createHeader());
frame.append(createDefaultContent());
frame.append(createListContent());


calendar.on("viewOrModeChange", displayChange);
calendar.onErase(function() {
		calendar.off('viewOrModeChange', displayChange);
		});

done(frame);

});