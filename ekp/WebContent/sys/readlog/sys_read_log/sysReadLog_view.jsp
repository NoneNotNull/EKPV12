<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<template:include ref="default.simple">
	<template:replace name="body">
		<script type="text/javascript">	
			seajs.use(['${KMSS_Parameter_ContextPath}sys/readlog/import/resource/read.css']);
		</script>
		<table width=100%>
			<tr>
				<td class="lui_form_subhead">
					<bean:message key="sysReadLog.showText.readerList" bundle="sys-readlog" />
					(${sysReadLogForm.fdReadNameCount})
				</td>
			</tr>
			<tr>			
				<td> 
					<div id="readerList" class="read_readed_detail">
						<c:out value="${sysReadLogForm.fdReaderNameList}" />
					</div>
				</td>
			</tr>
			<tr>
				<td class="lui_form_subhead"><bean:message key="sysReadLog.readDetailRecord" bundle="sys-readlog" /> </td>	
			</tr>
			<tr>			
				<td>
					 <list:listview>
						<ui:source type="AjaxJson">
							{"url":"/sys/readlog/sys_read_log/sysReadLog.do?method=listdata&rowsize=10&modelName=${param['modelName']}&modelId=${param['modelId']}"}
						</ui:source>
						<list:colTable isDefault="true" layout="sys.ui.listview.listtable" cfg-norecodeLayout="simple">
							<list:col-auto props=""></list:col-auto>
						</list:colTable>						
						<ui:event topic="list.loaded">  
						   seajs.use(['lui/jquery'],function($){
								if(window.frameElement!=null && window.frameElement.tagName=="IFRAME"){
									window.frameElement.style.height =  $(document.body).height() + "px";
								}
							});
						</ui:event>	
					</list:listview>
					<div style="height: 15px;"></div>
					<list:paging layout="sys.ui.paging.simple"></list:paging>
				</td>
			</tr>
		</table> 
	</template:replace>
</template:include>