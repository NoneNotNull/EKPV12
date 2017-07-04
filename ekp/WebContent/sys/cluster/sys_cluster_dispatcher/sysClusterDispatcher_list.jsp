<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="/WEB-INF/kmss-xform.tld" prefix="xform"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ include file="/resource/jsp/edit_top.jsp"%>
<script>
function submitForm(){
	var dispatchers = document.getElementsByName("fdDispatchers");
	outloop:
	for(var i=0; i<dispatchers.length; i++){
		var servers = document.getElementsByName("fdServer."+dispatchers[i].value);
		if(servers.length>0){
			if(servers[0].type=="radio"){
				for(var j=0; j<servers.length; j++){
					if(servers[j].checked && servers[j].value!=""){
						continue outloop;
					}
				}
			}else{
				if(servers[0].value!=""){
					continue outloop;
				}
			}
		}
		alert('<kmss:message key="errors.required" argKey0="sys-cluster:sysClusterDispatcher.server" />');
		return;
	}
	if(confirm('<bean:message bundle="sys-cluster" key="sysClusterDispatcher.submit"/>'))
		Com_Submit(document.forms[0], 'update');
}
</script>
<form method="post" action="<c:url value="/sys/cluster/sys_cluster_dispatcher/sysClusterDispatcher.do" />">

<div id="optBarDiv">
	<input type=button value="<bean:message key="button.update"/>"
		onclick="submitForm();">
	<input type="button" value="<bean:message key="button.close"/>" onclick="Com_CloseWindow();">
</div>
<p class="txttitle"><bean:message bundle="sys-cluster" key="sysClusterDispatcher.setting"/></p>
<center>
<table class="tb_normal" style="width:800px;">
	<tr class="tr_normal_title">
		<td width="50%">
			<bean:message bundle="sys-cluster" key="sysClusterDispatcher.dispatcher"/>
		</td>
		<td width="50%">
			<bean:message bundle="sys-cluster" key="sysClusterDispatcher.server"/>
		</td>
	</tr>
<xform:config isLoadDataDict="false">
<c:forEach items="${dispatcherList}" var="dispatcher">
	<tr>
		<td>
			<c:out value="${dispatcher.name}" />
			<xform:text property="fdDispatchers" value="${dispatcher.id}" showStatus="noShow"/>
		</td>
		<td>
			<c:if test="${dispatcher.multi=='true'}">
				<xform:checkbox property="fdServer.${dispatcher.id}" value="${dispatcher.server}" showStatus="edit">
					<xform:customizeDataSource className="com.landray.kmss.sys.cluster.interfaces.ServerDataSource" />
				</xform:checkbox>
			</c:if>
			<c:if test="${dispatcher.multi!='true'}">
				<xform:radio property="fdServer.${dispatcher.id}" value="${dispatcher.server}" showStatus="edit">
					<xform:customizeDataSource className="com.landray.kmss.sys.cluster.interfaces.ServerDataSource" />
				</xform:radio>
			</c:if>
			<span class="txtstrong">*</span>
		</td>
	</tr>
</c:forEach>
</xform:config>
</table>
</center>
</form>
<%@ include file="/resource/jsp/edit_down.jsp"%>