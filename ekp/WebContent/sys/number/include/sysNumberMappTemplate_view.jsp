<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/common.jsp"%>
<tr id="TR_ID_sysNumberMainMapp" style="display:none"
	LKS_LabelName="<kmss:message key="${not empty param.messageKey ? param.messageKey : 'sys-number:sysNumberMainMapp.tab.name'}" />">
	<td>
		 <%@ include file="/sys/number/import/sysNumberMappTemplate_view.jsp"%>
	</td>
</tr>