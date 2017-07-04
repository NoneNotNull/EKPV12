<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<template:include ref="default.simple">
	<template:replace name="body">
		<table width="100%">
			<tr><td colspan="3" height="50"></td></tr>
			<tr>
				<td width="50"></td>
				<td>
				<ui:dataview format="sys.ui.iframe">
					<ui:source type="Static">
					{"src":"http://test.liyong.com:8080/ekp/resource/test.jsp?LUIID=!{lui.element.id}"}
					</ui:source> 
				</ui:dataview> 
				
				</td>
				<td width="50"></td>
				<td></td>
			</tr>
		</table>
	</template:replace>
</template:include>

