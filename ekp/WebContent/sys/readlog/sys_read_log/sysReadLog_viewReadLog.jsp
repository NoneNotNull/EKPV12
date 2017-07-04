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
					(${fdReadNameCount})
				</td>
			</tr>
			<tr>			
				<td> 
					<div id="readerList" class="read_readed_detail">
						<c:out value="${fdReaderNameList}" />
					</div>
				</td>
			</tr>
		</table> 
	</template:replace>
</template:include>