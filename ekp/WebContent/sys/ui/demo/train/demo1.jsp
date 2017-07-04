<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<template:include ref="default.simple">
	<template:replace name="title">
	q
		<template:super/>
		r
	</template:replace>
	<template:replace name="body">	
		Hello World <br>		
		<table align="center">
			<tr>
				<td width="300" valign="top">
					<ui:tabpanel style="width:90%;margin-left:15px;">
						<ui:content title="面板1">
							面板1 的内容。这里可以是任意的JSP代码
						</ui:content>
						<ui:content title="面板2">
							<ui:layout ref="sys.ui.content.default"></ui:layout>
							<ui:dataview format="sys.ui.classic">
								<ui:source ref="sys.ui.demo.source"></ui:source>
							</ui:dataview>
							<ui:operation href="#" name="更多"></ui:operation>
						</ui:content>
					</ui:tabpanel>
				</td>
				<td width="300" valign="top">
					<ui:accordionpanel style="width:90%;margin-left:15px;">
						<ui:content title="面板2">
							内容3
						</ui:content>
						<ui:content title="面板4">
							内容4
						</ui:content>
					</ui:accordionpanel>
				</td>
			</tr>
		</table>
	</template:replace>
</template:include>