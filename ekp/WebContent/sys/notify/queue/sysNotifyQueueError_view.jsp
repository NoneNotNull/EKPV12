<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@page import="com.landray.kmss.sys.notify.queue.model.SysNotifyQueueError
				,com.landray.kmss.util.*
				,com.landray.kmss.common.model.IBaseModel
				,com.landray.kmss.sys.metadata.interfaces.ISysMetadataParser
				,com.landray.kmss.sys.config.dict.SysDictModel
				,com.landray.kmss.sys.organization.service.ISysOrgPersonService
				,com.landray.kmss.sys.organization.model.SysOrgPerson"%>
<%@ taglib uri="/WEB-INF/kmss-xform.tld" prefix="xform"%>
<%@ include file="/resource/jsp/view_top.jsp"%>

<%
ISysOrgPersonService ps = (ISysOrgPersonService)SpringBeanUtil.getBean("sysOrgPersonService");
ISysMetadataParser sysMetadataParser = (ISysMetadataParser)SpringBeanUtil.getBean("sysMetadataParser");

SysNotifyQueueError sysNotifyQueueError=(SysNotifyQueueError)request.getAttribute("_model");
%>

<script>
	function confirmDelete(msg){
	var del = confirm("<bean:message key="page.comfirmDelete"/>");
	return del;
}
</script>
<div id="optBarDiv">
	<kmss:auth requestURL="/sys/notify/queue/sysNotifyQueueError.do?method=run&fdId=${param.fdId}" requestMethod="GET">
		<input type="button"
			value="<bean:message bundle="sys-notify" key="sysNotifyQueueError.run"/>"
			onclick="Com_OpenWindow('sysNotifyQueueError.do?method=run&fdId=${param.fdId}','_self');">
	</kmss:auth>
	<kmss:auth requestURL="/sys/notify/queue/sysNotifyQueueError.do?method=delete&fdId=${param.fdId}" requestMethod="GET">
		<input type="button"
			value="<bean:message key="button.delete"/>"
			onclick="if(!confirmDelete())return;Com_OpenWindow('sysNotifyQueueError.do?method=delete&fdId=${param.fdId}','_self');">
	</kmss:auth>

	<input type="button"
		value="<bean:message key="button.close"/>"
		onclick="Com_CloseWindow();">
</div>

<p class="txttitle"><bean:message bundle="sys-notify" key="table.sysNotifyQueueError"/></p>

<center>
<table class="tb_normal" width=95%>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-notify" key="sysNotifyQueueError.fdModelId"/>
		</td><td width="35%">
			<%=sysNotifyQueueError.getFdModelId()%>
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-notify" key="sysNotifyQueueError.fdModelName"/>
		</td><td width="35%">
			<%=sysNotifyQueueError.getFdModelName()%>
		</td>
	</tr>

	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-notify" key="sysNotifyQueueError.fdModelName.text"/>
		</td>
		<td width="35%">
		<%
		SysOrgPerson p = (SysOrgPerson)ps.findByPrimaryKey(sysNotifyQueueError.getFdUserId());

		String mn = "";
		IBaseModel mModel = null;
		if (ModelUtil.isModelMerge(sysNotifyQueueError.getFdModelName(), sysNotifyQueueError.getFdModelId())) {
			mModel = ps.findByPrimaryKey(sysNotifyQueueError.getFdModelId(),sysNotifyQueueError.getFdModelName(),false);
			SysDictModel dictModel = sysMetadataParser.getDictModel(mModel);
			if(StringUtil.isNotNull(dictModel.getMessageKey())){
				mn=ResourceUtil.getString(dictModel.getMessageKey(),
						request.getLocale());
			}
		}
		out.print(mn);

		%>
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-notify" key="sysNotifyQueueError.fdType"/>
		</td><td width="35%">
				<%=StringUtil.getString(sysNotifyQueueError.getFdType())%>
		</td>
	</tr>

	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-notify" key="sysNotifyQueueError.fdMethodType"/>
		</td>
		<td width="35%">
				<%=StringUtil.getString(sysNotifyQueueError.getFdMethodType())%>
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-notify" key="sysNotifyQueueError.fdTime"/>
		</td><td width="35%">
				<%
				if(sysNotifyQueueError.getFdTime()!=null){
					out.print(DateUtil.convertDateToString(DateUtil.getCalendar(sysNotifyQueueError.getFdTime()).getTime(),"yyyy-MM-dd HH:mm:ss"));
				}
				%>
		</td>
	</tr>

	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-notify" key="sysNotifyQueueError.fdExecutor"/>
		</td>
		<td width="35%">
				<%=StringUtil.getString(sysNotifyQueueError.getFdExecutor())%>
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-notify" key="sysNotifyQueueError.fdUserId"/>
		</td><td width="35%">
					<%=p.getFdName()%>
		</td>
	</tr>

	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-notify" key="sysNotifyQueueError.fdFlag"/>
		</td>
		<td width="35%">
			<%
			if("0".equals(sysNotifyQueueError.getFdFlag())){
			%>
						<bean:message bundle="sys-notify" key="sysNotifyQueueError.fdFlag.0"/>
			<%
			}
			%>
			<%
			if("1".equals(sysNotifyQueueError.getFdFlag())){
			%>
						<bean:message bundle="sys-notify" key="sysNotifyQueueError.fdFlag.1"/>
			<%
			}
			%>
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-notify" key="sysNotifyQueueError.fdErrorMsg"/>
		</td><td width="35%">
				<%=StringUtil.getString(sysNotifyQueueError.getFdErrorMsg())%>
		</td>
	</tr>


	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-notify" key="sysNotifyQueueError.doc.title"/>
		</td>
		<td colspan="3" width="85%">
					<%
					String link = "";
					if(mModel!=null){
						link = request.getContextPath()+"/"+ModelUtil.getModelUrl(mModel);
					}
					%>
					<a href="<%= link%>" target="_blank"><bean:message bundle="sys-notify" key="sysNotifyQueueError.doc.link"/></a>
					
		</td>
	</tr>

	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-notify" key="sysNotifyQueueError.fdJSON"/>
		</td>
		<td colspan="3" width="85%">
					<%=sysNotifyQueueError.getFdJson()%>
	</td>
	</tr>

</table>
</center>
<%@ include file="/resource/jsp/view_down.jsp"%>