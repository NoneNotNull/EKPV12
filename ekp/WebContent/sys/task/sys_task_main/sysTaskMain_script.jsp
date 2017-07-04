<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/common.jsp"%>
<script type="text/javascript"> 
function isLeapYear(year) {
    if(year%4 == 0 && year%100 != 0 || year%400 == 0){
        return true;
    }
}
function MonthDays (year,month) {
    switch (month) {
        case 1: return 31;
        case 2: return isLeapYear(year)?29:28; 
        case 3: return 31;
        case 4: return 30;
        case 5: return 31;
        case 6: return 30;
        case 7: return 31;
        case 8: return 31;
        case 9: return 30;
        case 10: return 31;
        case 11: return 30;
        case 12: return 31;      
    }
    return 0;
}
function getYearDays(year) {
    return isLeapYear(year)?366:365;
}
function getYearWeek(year) {
    var i, days=0, week;
    if (year >= 2000) {
        for (i=2000; i<year; i++)  
         days += getYearDays(i);
        week = (days+6)%7;          
    } else  {
        for (i=year; i<2000; i++) 
         days +=getYearDays(i); 
        week = 6-days%7;
    }  
    return week;
}
function getMonthWeek (year,month) {
    var i, days=0;
    for (i=1; i<month; i++) {
        days += MonthDays(year,i);                 
    }
    return (getYearWeek(year)+days)%7;
}
function getDayWeek (year,month,day) {
    return (getMonthWeek(year,month)+day-1)%7;
}
function setWeek(val){
	var weekspan = document.getElementById("weekspan");
	var d = new Date(val.substring(0,4),val.substring(5,7)-1,val.substring(8,10));
	var week = getDayWeek(getYear(d),getMonth(d),getDate(d));
	setWeekSpan(week);
}
function setWeekSpan(week){
	 switch (week) {
        case 0: weekspan.innerHTML = "周日";break;
        case 1: weekspan.innerHTML = "周一";break;
        case 2: weekspan.innerHTML = "周二";break;
        case 3: weekspan.innerHTML = "周三";break;
        case 4: weekspan.innerHTML = "周四";break;
        case 5: weekspan.innerHTML = "周五";break;
        case 6: weekspan.innerHTML = "周六";break;
      }
}
function changeDateTime(obj){
	var _date = new Date();
	var month_ = getMonth(_date);
	var year_ = getYear(_date);
	var date_  = getDate(_date);
	var hour_ = getHours(_date);
	var minutes_ = getMinutes(_date);
	if(obj == '1'){
		 month_ = getMonth(_date);
		 year_ = getYear(_date);
		 date_  = getDate(_date);
		 hour_ = getHours(_date);
		 minutes_ = getMinutes(_date);
		 setWeekSpan(getDayWeek(year_,month_,date_));
		 setDate(year_,month_,date_,hour_,minutes_);
	}
	if(obj == '2'){
		_date.setDate(_date.getDate()+1);
		 month_ = getMonth(_date);
		  year_ = getYear(_date);
		 date_  = getDate(_date);
		 hour_ = getHours(_date);
		 minutes_ = getMinutes(_date);
		 setWeekSpan(getDayWeek(year_,month_,date_));
		 setDate(year_,month_,date_,hour_,minutes_);
	}
	if(obj == '3'){
		_date.setDate(_date.getDate()+2);
		month_ = getMonth(_date);
		 year_ = getYear(_date);
		 date_  = getDate(_date);
		 hour_ = getHours(_date);
		 minutes_ = getMinutes(_date);
		 setWeekSpan(getDayWeek(year_,month_,date_));
		 setDate(year_,month_,date_,hour_,minutes_);
	}
	if(obj == '4'){
		_date.setDate(_date.getDate()+7);
		month_ = getMonth(_date);
		 year_ = getYear(_date);
		 date_  = getDate(_date);
		 hour_ = getHours(_date);
		 minutes_ = getMinutes(_date);
		 setWeekSpan(getDayWeek(year_,month_,date_));
		 setDate(year_,month_,date_,hour_,minutes_);
	}
	if(obj == '5'){
		_date.setMonth(_date.getMonth()+1);
		 month_ = getMonth(_date);
		 year_ = getYear(_date);
		 date_  = getDate(_date);
		 hour_ = getHours(_date);
		 minutes_ = getMinutes(_date);
		 setWeekSpan(getDayWeek(year_,month_,date_));
		 setDate(year_,month_,date_,hour_,minutes_);
	}
}
function getMinutes(obj){
	return obj.getMinutes();
}
function getHours(obj){
	return obj.getHours();
}
function getDate(obj){
	return obj.getDate();
}
function getMonth(obj){
	return obj.getMonth()+1;
}
function getYear(obj){
	return obj.getFullYear();
}
function showCondiction(obj){
	var show = obj.getAttribute('data-status') !='1';
	obj.setAttribute('data-status', show?'1':'0');
	var TbObj = document.getElementById("tbObj");
	for(var i=4;i <TbObj.rows.length;i++){
		if(show){
			$(TbObj.rows[i]).show();
		}else{
			$(TbObj.rows[i]).hide();
		}
		if(show){
			document.getElementById("showMoreSet").className ="task_slideUp";
			document.getElementById("showMoreSet").innerHTML="<bean:message bundle='sys-task' key='sysTaskMain.more.set.slideUp' />";
			
		}else{
			document.getElementById("showMoreSet").className ="task_slideDown";
			document.getElementById("showMoreSet").innerHTML="<bean:message bundle='sys-task' key='sysTaskMain.more.set.slideDown' />";
		}
	}
}

window.onload = function(){
	  Pda_init("fdPerformId","fdPerformName",";",true);
	 
	  	$("ul.txt_c_date li:first span:eq(1)").css("color", "#0749d1");
	  	changeDateTime('2');
	 	$("ul.txt_c_date li:first span").click(function () {
        	$(this).css("color", "#0749d1").siblings().css("color", "#222");
    	});
};
</script>