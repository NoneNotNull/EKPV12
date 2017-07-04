seajs.use(['lang!sys-ui','lang!km-calendar'],function(lang,calendarLang){
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
	$('<div class="lui_calendar_header_today" cal-opt="today">'+lang['ui.calendar.today']+'</div>').appendTo(leftTd).click(function(){
		calendar.today();
	});
	var centerTd = $('<td class="lui_calendar_header_center"/>').appendTo(trTmp);
	$('<div class="lui_calendar_header_title"/>').appendTo(centerTd);
	
	var rightTd = $('<td class="lui_calendar_header_right"/>').appendTo(trTmp);
	
	$('<div class="lui_calendar_header_refresh"/>').appendTo(rightTd).click(function(){
		calendar.refreshSchedules();
	});
	
	var ul=$("<ul class='calendar_dropdown'/>");
	
	//设置
	$("<div class='calendar-setting' id='calendar_setting' unselectable='on'>"+calendarLang['km.calendar.tree.set']+"<i class='trig'></i></div>")
		.append($("<div id='setting_down' />").append(ul))
		.appendTo(rightTd).one('mousemove',function(evt){ 
            $(".calendar_dropdown").show();
            syncroMunu();
        }).mouseleave(function (evt) {
            $('.calendar_dropdown').hide();
            $("#calendar_setting").one('mousemove',function(evt){
                $(".calendar_dropdown").show();
                syncroMunu();
            });
        });

	return headObj;
}

var syncroMunuJson={};
function getMenuHtml(){
	
	var menuHtml ="<li><span><a onclick='kmCalendarExport();' class='textEllipsis' title='"+calendarLang['kmCalendarMain.exportGroupTitle']+"'>"+calendarLang['kmCalendarMain.exportGroupTitle']+"</a></span></li>" 
	+"<li><span><a onclick='kmCalendarList();' class='textEllipsis' title='"+calendarLang['kmCalendarLabel.tab.list']+"'>"+calendarLang['kmCalendarLabel.tab.list']+"</a></span></li>"
	+"<li><span><a onclick='kmCalendarAuth()' class='textEllipsis' title='"+calendarLang['kmCalendar.setting.authSetting']+"'>"+calendarLang['kmCalendar.setting.authSetting']+"</a></span></li>"
	+"<li  class='split'><span><a onclick='kmCalendarShareGroup()' class='textEllipsis' title='"+calendarLang['kmCalendar.setting.groupSetting']+"'>"+calendarLang['kmCalendar.setting.groupSetting']+"</a></span></li>";
	for(var appKey in syncroMunuJson){
		for(var i=0;i<syncroMunuJson[appKey].length;i++){
			var menu=syncroMunuJson[appKey][i];
			var cssClass="";
			if(i==syncroMunuJson[appKey].length-1){
				cssClass="split";
			}
			menuHtml += "<li class='"+cssClass+"'><span><a target='_blank' class='textEllipsis' title='"+menu.text+"' href='"+env.fn.formatUrl('/'+menu.url)+"'>"+menu.text+"</a></span></li>";
		}
	}
	menuHtml += "</ul>";
	return menuHtml;
}
function syncroMunu(){
	$.ajax({
		url: env.fn.formatUrl("/km/calendar/km_calendar_main/kmCalendarMain.do?method=getSyncroMenuDataJson"),
		type: 'POST',
		dataType: 'json',
		async: false	,
		success: function(data, textStatus, xhr) {//操作成功
			syncroMunuJson=data;
			var menuHtml = getMenuHtml();
			$(".calendar_dropdown").html(menuHtml);
			$(".calendar_dropdown").show();
		}
	});
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
});