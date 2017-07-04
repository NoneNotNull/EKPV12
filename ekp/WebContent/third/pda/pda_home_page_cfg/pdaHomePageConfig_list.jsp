<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/list_top.jsp"%>
<script>
	 function List_ConfirmUpdate(){
		 if(List_CheckSelect()){
			 var obj = document.getElementsByName("List_Selected");
			 var j=0;
			 for(var i=0; i<obj.length; i++)
					if(obj[i].checked)
						j++;
			 if(j>1){
				 alert('<bean:message bundle="third-pda" key="pdaHomePageConfig.warnning.list.alert"/>');
				 return false;
			 }
			 return confirm('<bean:message bundle="third-pda" key="pdaHomePageConfig.warnning.list.confirm"/>');
		 }
			return false;
	 }
	 function List_ConfirmDel(){
		var obj = document.getElementsByName("List_Selected");
		var hasUsedPage=false;
		var hasSelected=false; 
		for(var i=0; i<obj.length; i++){
			if(obj[i].checked){
				if(obj[i].getAttribute("isUsed")=='1'){
					hasUsedPage=true;
				}
				hasSelected = true;
			}
		}
		if(hasSelected==false){
			alert('<bean:message key="page.noSelect"/>');
			return false;
		}
		if(hasUsedPage==true){
			if(confirm('<bean:message bundle="third-pda" key="pdaHomePageConfig.warnning.list.del.confirm"/>'))
				return true;
			return false;
		}
		return true;
	 }
</script>
<form method="post" name="pdaHomePageConfigForm" autocomplete="off" action="${KMSS_Parameter_ContextPath}third/pda/pda_home_page_cfg/pdaHomePageConfig.do">
	<div id="optBarDiv">
		<kmss:auth requestURL="/third/pda/pda_home_page_cfg/pdaHomePageConfig.do?method=add">
			<input type="button" value="<bean:message key="button.add"/>"
				onclick="Com_OpenWindow('<c:url value="/third/pda/pda_home_page_cfg/pdaHomePageConfig.do" />?method=add');">
		</kmss:auth>
		<kmss:auth requestURL="/third/pda/pda_home_page_cfg/pdaHomePageConfig.do?method=deleteall">
			<input type="button" value="<bean:message key="button.delete"/>"
				onclick="if(!List_ConfirmDel())return;Com_Submit(document.pdaHomePageConfigForm, 'deleteall');">
			<input type="button" value="<bean:message key="pdaHomePageConfig.fdSetAvailable" bundle="third-pda"/>"
				onclick="if(!List_ConfirmUpdate())return;Com_Submit(document.pdaHomePageConfigForm, 'updateStatus');">
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
				<sunbor:column property="pdaHomePageConfig.fdName">
					<bean:message bundle="third-pda" key="pdaHomePageConfig.fdName"/>
				</sunbor:column>
				<sunbor:column property="pdaHomePageConfig.fdOrder">
					<bean:message bundle="third-pda" key="pdaHomePageConfig.fdOrder"/>
				</sunbor:column>
				<sunbor:column property="pdaHomePageConfig.fdIsDefault">
					<bean:message bundle="third-pda" key="pdaHomePageConfig.fdIsDefault"/>
				</sunbor:column>
				<sunbor:column property="pdaHomePageConfig.docCreator.fdName">
					<bean:message bundle="third-pda" key="pdaHomePageConfig.docCreator"/>
				</sunbor:column>
				<sunbor:column property="pdaHomePageConfig.fdCreateTime">
					<bean:message bundle="third-pda" key="pdaHomePageConfig.fdCreateTime"/>
				</sunbor:column>
			</sunbor:columnHead>
		</tr>
		<c:forEach items="${queryPage.list}" var="pdaHomePageConfig" varStatus="vstatus">
			<tr
				kmss_href="<c:url value="/third/pda/pda_home_page_cfg/pdaHomePageConfig.do" />?method=view&fdId=${pdaHomePageConfig.fdId}">
				<td>
					<input type="checkbox" name="List_Selected" value="${pdaHomePageConfig.fdId}" 
					<c:if test="${pdaHomePageConfig.fdIsDefault=='1'}">
						isUsed="1"
					</c:if> />
				</td>
				<td>
					${vstatus.index+1}
				</td>
				<td>
					<c:out value="${pdaHomePageConfig.fdName}" />
				</td>
				<td>
					<c:out value="${pdaHomePageConfig.fdOrder}" />
				</td>
				<td>
					<c:if test="${pdaHomePageConfig.fdIsDefault=='1'}">
					<bean:message key="message.yes"/>
					</c:if>&nbsp;
				</td>
				<td>
					<c:out value="${pdaHomePageConfig.docCreator.fdName}" />
				</td>
				<td>
					<kmss:showDate value="${pdaHomePageConfig.fdCreateTime}" />
				</td>
			</tr>
		</c:forEach>
	</table>
	<%@ include file="/resource/jsp/list_pagenav_down.jsp" %>
</c:if>
</form>
<%@ include file="/resource/jsp/list_down.jsp"%>