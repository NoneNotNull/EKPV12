var calendar = layout.calendar;
var frame = null;
function createFrame(){
	return $('<div class="lui_calendar_frame"/>');
}
function createGroupContent(){
	return $('<div data-lui-mark="calender.content.inside.groupCalendar" class="lui_calendar_content"/>');
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
	$('<div class="lui_calendar_header_today" cal-opt="today">今天</div>').appendTo(leftTd).click(function(){
		calendar.today();
	});
	var centerTd = $('<td class="lui_calendar_header_center"/>').appendTo(trTmp);
	$('<div class="lui_calendar_header_title"/>').appendTo(centerTd);
	
	var rightTd = $('<td class="lui_calendar_header_right"/>').appendTo(trTmp);
	
	$('<div class="lui_calendar_header_refresh"/>').appendTo(rightTd).click(function(){
		calendar.refreshSchedules();
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
frame.append(createGroupContent());
calendar.on("viewOrModeChange", displayChange);
calendar.onErase(function() {
		calendar.off('viewOrModeChange', displayChange);
		});

done(frame);