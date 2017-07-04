<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib uri="/WEB-INF/kmss-xform.tld" prefix="xform"%>
var devicesIds="${kmImeetingMainForm.kmImeetingDeviceIds}";
for(var i=0;i< data.length; i++){
	var checked=devicesIds.indexOf(data[i].fdId)>-1?'checked':'';
	{$
		<label>
		 	<input type="checkbox" name="_kmImeetingDeviceIds" value="{%data[i].fdId%}"  {%checked%}
		 			onclick="__cbClick('kmImeetingDeviceIds',null,false,null);"/>
		 		{%data[i].fdName%}
		 </label>&nbsp;
	$}
}
{$<div id="div_kmImeetingDeviceIds" style="display:none">
	<input name="kmImeetingDeviceIds" type="hidden" value="{%devicesIds%}" />
</div>
$}