<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<template:include ref="default.simple">
	<template:replace name="body">
		<table>
			<tr><td colspan="3" height="50"></td></tr>
			<tr>
				<td width="50"></td>
				<td><ui:panel layout="sys.ui.panel.light" id="p_aacfc21686291a3aa836" toggle="true" >
					<ui:content title="tab1"> 
					    	tab1
				    	</ui:content>
				</ui:panel></td>
				<td width="50"></td>
				<td></td>
			</tr>
		</table>
	</template:replace>
</template:include>

