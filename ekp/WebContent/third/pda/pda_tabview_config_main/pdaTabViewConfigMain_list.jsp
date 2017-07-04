<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/list_top.jsp"%>
<script>
	 function List_Confirm(){
		var obj = document.getElementsByName("List_Selected");
		var hasSelected=false; 
		for(var i=0; i<obj.length; i++){
			if(obj[i].checked){
				hasSelected = true;
			}
		}
		if(hasSelected==false){
			alert('<bean:message key="page.noSelect"/>');
			return false;
		}
		return true;
	 }
	 
</script>
<html:form action="/third/pda/pda_tabview_config_main/pdaTabViewConfigMain.do">
<input type="hidden" name="fdEnabled">
	<div id="optBarDiv">
		<kmss:auth requestURL="/third/pda/pda_tabview_config_main/pdaTabViewConfigMain.do?method=add">
			<input type="button" value="<bean:message key="button.add"/>"
				onclick="Com_OpenWindow('<c:url value="/third/pda/pda_tabview_config_main/pdaTabViewConfigMain.do" />?method=add');">
		</kmss:auth>
		<kmss:auth requestURL="/third/pda/pda_tabview_config_main/pdaTabViewConfigMain.do?method=deleteall">
			<input type="button" value="<bean:message key="button.delete"/>"
				onclick="if(!List_Confirm())return;Com_Submit(document.pdaTabViewConfigMainForm, 'deleteall');">
		</kmss:auth>
		<kmss:auth requestURL="/third/pda/pda_module_config_main/pdaModuleConfigMain.do?method=update">
			<input type="button" value="<bean:message key="pdaTabViewConfigMain.status.enable" bundle="third-pda"/>"
				onclick="if(!List_Confirm())return;document.getElementsByName('fdEnabled')[0].value='1';Com_Submit(document.pdaTabViewConfigMainForm, 'updateStatus');">
			<input type="button" value="<bean:message key="pdaTabViewConfigMain.status.disable" bundle="third-pda"/>"
				onclick="if(!List_Confirm())return;document.getElementsByName('fdEnabled')[0].value='0';Com_Submit(document.pdaTabViewConfigMainForm, 'updateStatus');">
		</kmss:auth>
	</div>
<c:if test="${queryPage.totalrows==0}">
	<%@ include file="/resource/jsp/list_norecord.jsp"%>
</c:if>
<c:if test="${queryPage.totalrows>0}">
	<%@ include file="/resource/jsp/list_pagenav_top.jsp"%>
	<table id="List_ViewTable">
		<tr>
			<sunbor:columnHead htmlTag="td">
				<td width="10pt">
					<input type="checkbox" name="List_Tongle">
				</td>
				<td width="40pt">
					<bean:message key="page.serial"/>
				</td>
				<sunbor:column property="pdaTabViewConfigMain.fdName">
					<bean:message bundle="third-pda" key="pdaTabViewConfigMain.fdName"/>
				</sunbor:column>
				<sunbor:column property="pdaTabViewConfigMain.fdModule.fdName">
					<bean:message bundle="third-pda" key="pdaTabViewConfigMain.fdModuleId"/>
				</sunbor:column>
				<sunbor:column property="pdaTabViewConfigMain.fdOrder">
					<bean:message bundle="third-pda" key="pdaTabViewConfigMain.fdOrder"/>
				</sunbor:column>
				<sunbor:column property="pdaTabViewConfigMain.docCreator.fdName">
					<bean:message bundle="third-pda" key="pdaTabViewConfigMain.docCreator"/>
				</sunbor:column>
				<sunbor:column property="pdaTabViewConfigMain.fdCreateTime">
					<bean:message bundle="third-pda" key="pdaTabViewConfigMain.fdCreateTime"/>
				</sunbor:column>
				<sunbor:column property="pdaTabViewConfigMain.fdStatus">
					<bean:message bundle="third-pda" key="pdaTabViewConfigMain.fdStatus"/>
				</sunbor:column>
			</sunbor:columnHead>
		</tr>
		<c:forEach items="${queryPage.list}" var="pdaTabViewConfigMain" varStatus="vstatus">
			<tr
				kmss_href="<c:url value="/third/pda/pda_tabview_config_main/pdaTabViewConfigMain.do" />?method=view&fdId=${pdaTabViewConfigMain.fdId}">
				<td>
					<input type="checkbox" name="List_Selected" value="${pdaTabViewConfigMain.fdId}" />
				</td>
				<td>
					${vstatus.index+1}
				</td>
				<td>
					<c:out value="${pdaTabViewConfigMain.fdName}" />
				</td>
				<td>
					<c:out value="${pdaTabViewConfigMain.fdModule.fdName}" />
				</td>
				<td>
					<c:out value="${pdaTabViewConfigMain.fdOrder}" />
				</td>
				<td>
					<c:out value="${pdaTabViewConfigMain.docCreator.fdName}" />
				</td>
				<td>
					<kmss:showDate value="${pdaTabViewConfigMain.fdCreateTime}" />
				</td>
				<td>
					<c:if test="${pdaTabViewConfigMain.fdStatus=='1'}">
					<bean:message key="message.yes"/>
					</c:if>
					<c:if test="${pdaTabViewConfigMain.fdStatus!='1'}">
					<bean:message key="message.no"/>
					</c:if>
				</td>
			</tr>
		</c:forEach>
	</table>
	<%@ include file="/resource/jsp/list_pagenav_down.jsp" %>
</c:if>
</html:form>
<%@ include file="/resource/jsp/list_down.jsp"%>