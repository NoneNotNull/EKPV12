<%@ page language="java" contentType="text/html;  charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/resource/jsp/common.jsp"%>
Com_RegisterFile("calendar_lang.jsp");
var Calendar_Lang = {
	format : {
		data : '<kmss:message key="date.format.date" />',
		time : '<kmss:message key="date.format.time" />',
		dataTime : '<kmss:message key="date.format.datetime" />'
	},
	dateLabel : '<kmss:message key="date.label" />',
	timeLabel : '<kmss:message key="time.label" />',
	submitButtonLabel: '<kmss:message key="button.ok" />',
	resetButtonLabel: '<kmss:message key="button.cancel" />',
	clearButtonLabel: '<kmss:message key="button.cancelSelect" />',
	weekLabels: [<kmss:message key="date.shortWeekDayNames" />],
	monthLabels: [<kmss:message key="calendar.shortMonthNames" />],
	toXML : function() {
		var buf = [];
		buf.push('<root><dateLabel>', Calendar_Lang.dateLabel, ':</dateLabel>');
		buf.push('<timeLabel>', Calendar_Lang.timeLabel, ':</timeLabel>');
		buf.push('<submitButtonLabel>', Calendar_Lang.submitButtonLabel, '</submitButtonLabel>');
		buf.push('<resetButtonLabel>', Calendar_Lang.resetButtonLabel, '</resetButtonLabel>');
		buf.push('<clearButtonLabel>', Calendar_Lang.clearButtonLabel, '</clearButtonLabel>');
		buf.push('<weekLabels>', Calendar_Lang.weekLabels.join('|'), '</weekLabels>');
		buf.push('<monthLabels>', Calendar_Lang.monthLabels.join('|'), '</monthLabels></root>');
		return buf.join('');
	}
};