<%@ page language="java" contentType="javascript/x-javascript; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/resource/jsp/common.jsp"%>
$KMSSValidation_Lang = {
	"required"  : "<bean:message key="errors.required" arg0="{name}" />",
	"number"   : "<bean:message key="errors.number" arg0="{name}" />",
	"date"      : "<bean:message key="errors.date" arg0="{name}" />",
	"email"     : "<bean:message key="errors.email" arg0="{name}" />",
	"maxLength" : "<bean:message key="errors.maxLength.simple" arg0="{name}" arg1="{maxLength}" />",
	"range" : "<bean:message key="errors.range" arg0="{name}" arg1="{min}" arg2="{max}" />",
	"min" : "<bean:message key="errors.min" arg0="{name}" arg1="{num}" />",
	"max" : "<bean:message key="errors.max" arg0="{name}" arg1="{num}" />",
	"scaleLength" : "<bean:message key="errors.scaleLength" arg0="{name}" arg1="{num}" />",
	"before" : "<bean:message key="errors.time.before" arg0="{name}"/>",
	"after"  : "<bean:message key="errors.time.after" arg0="{name}"/>",
	"__datetime"  : "<bean:message key="errors.datetime" arg0="{name}" />",
	"__date"      : "<bean:message key="errors.date" arg0="{name}" />",
	"__time"      : "<bean:message key="errors.time" arg0="{name}" />"
}