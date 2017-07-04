<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib uri="/WEB-INF/KmssConfig/sys/ui/lfn.tld" prefix="lfn"%>
{$
	<input type="checkbox"  name="label_checkbox" checked="checked" value="myEvent"  onclick="clickCheckbox(this)"/>
	${ lfn:message('km-calendar:kmCalendar.nav.title') }
$}
for(var i=0;i<data.length;i++){
	{$
		<input type="checkbox"  name="label_checkbox" checked="checked"  value="{%data[i].fdId%}"  onclick="clickCheckbox(this)"/>
		{%data[i].fdName%}
	$}
}