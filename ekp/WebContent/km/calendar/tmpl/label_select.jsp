<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib uri="/WEB-INF/KmssConfig/sys/ui/lfn.tld" prefix="lfn"%>
{$<select name="labelId">
		<option value="">
			${ lfn:message('km-calendar:kmCalendar.nav.title') }
		</option>
$}
for(var i=0;i<data.length;i++){
	{$
		<option value="{%data[i].fdId%}">{%data[i].fdName%}</option>
	$}
}
{$</select>$}