<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/list_top.jsp"%>
<script>
		function confirmOpt(isEnable){
			if(isEnable==true)
				return confirm('<bean:message bundle="third-pda" key="pdaModuleConfigMain.opt.enable.desc"/>');
			return confirm('<bean:message bundle="third-pda" key="pdaModuleConfigMain.opt.disable.desc"/>');
		}
</script>
<form name="pdaModuleConfigMainForm" method="post" action="${KMSS_Parameter_ContextPath}third/pda/pda_module_config_main/pdaModuleConfigMain.do" autocomplete="off">
	<div id="optBarDiv">
		<kmss:auth requestURL="/third/pda/pda_module_config_main/pdaModuleConfigMain.do?method=add">
			<input type="button" value="<bean:message key="button.add"/>"
				onclick="Com_OpenWindow('<c:url value="/third/pda/pda_module_config_main/pdaModuleConfigMain.do" />?method=add');">
		</kmss:auth>
		<kmss:auth requestURL="/third/pda/pda_module_config_main/pdaModuleConfigMain.do?method=deleteall">
			<input type="button" value="<bean:message key="button.delete"/>"
				onclick="if(!List_ConfirmDel())return;Com_Submit(document.pdaModuleConfigMainForm, 'deleteall');">
		</kmss:auth>
		<kmss:auth requestURL="/third/pda/pda_module_config_main/pdaModuleConfigMain.do?method=update">
			<input type="button" value="<bean:message bundle="third-pda" key="pdaModuleConfigMain.status.enable"/>" 
				onclick="if(!confirmOpt(true)) return;
					document.getElementsByName('fdEnabled')[0].value='1';
					Com_Submit(document.pdaModuleConfigMainForm, 'updateStatus');"
				/>
			<input type="button" value="<bean:message bundle="third-pda" key="pdaModuleConfigMain.status.disable"/>" 
				onclick="if(!confirmOpt(false)) return;
					document.getElementsByName('fdEnabled')[0].value='0';
					Com_Submit(document.pdaModuleConfigMainForm, 'updateStatus');"
				/>
		</kmss:auth>
		<kmss:auth requestURL="/third/pda/pda_module_config_main/pdaModuleConfigMain.do?method=updateIconVersion">
			<input type="button" value="<bean:message bundle="third-pda" key="pdaModuleConfigMain.updateVersion"/>"
				onclick="Com_OpenWindow('<c:url value="/third/pda/pda_module_config_main/pdaModuleConfigMain.do" />?method=updateIconVersion','_self');">
		</kmss:auth>
	</div>
<input type="hidden" name="fdEnabled">
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
				<sunbor:column property="pdaModuleConfigMain.fdName">
					<bean:message bundle="third-pda" key="pdaModuleConfigMain.fdName"/>
				</sunbor:column>
				<sunbor:column property="pdaModuleConfigMain.fdOrder">
					<bean:message bundle="third-pda" key="pdaModuleConfigMain.fdOrder"/>
				</sunbor:column>
				<sunbor:column property="pdaModuleConfigMain.fdModuleCate.fdName">
					<bean:message key="pdaModuleConfigMain.fdModuleCate" bundle="third-pda"/>
				</sunbor:column>
				<sunbor:column property="pdaModuleConfigMain.fdUrlPrefix">
					<bean:message bundle="third-pda" key="pdaModuleConfigMain.fdUrlPrefix"/>
				</sunbor:column>
				<sunbor:column property="pdaModuleConfigMain.fdIconUrl">
					<bean:message bundle="third-pda" key="pdaModuleConfigMain.fdIconUrl"/>
				</sunbor:column>
				<sunbor:column property="pdaModuleConfigMain.fdStatus">
					<bean:message bundle="third-pda" key="pdaModuleConfigMain.fdStatus"/>
				</sunbor:column>
				<sunbor:column property="pdaModuleConfigMain.docCreator.fdName">
					<bean:message bundle="third-pda" key="pdaModuleConfigMain.docCreator"/>
				</sunbor:column>
				<sunbor:column property="pdaModuleConfigMain.fdCreateTime">
					<bean:message bundle="third-pda" key="pdaModuleConfigMain.fdCreateTime"/>
				</sunbor:column>
			</sunbor:columnHead>
		</tr>
		<c:forEach items="${queryPage.list}" var="pdaModuleConfigMain" varStatus="vstatus">
			<tr
				kmss_href="<c:url value="/third/pda/pda_module_config_main/pdaModuleConfigMain.do" />?method=view&fdId=${pdaModuleConfigMain.fdId}">
				<td>
					<input type="checkbox" name="List_Selected" value="${pdaModuleConfigMain.fdId}">
				</td>
				<td>
					${vstatus.index+1}
				</td>
				<td>
					<c:out value="${pdaModuleConfigMain.fdName}" />
				</td>
				<td>
					<c:out value="${pdaModuleConfigMain.fdOrder}" />
				</td>
				<td>
					<c:out value="${pdaModuleConfigMain.fdModuleCate.fdName}" />
				</td>
				<td>
					<c:out value="${pdaModuleConfigMain.fdUrlPrefix}" />
				</td>
				<td>
					<img src="<c:url value="${pdaModuleConfigMain.fdIconUrl}" />" width="30px" height="30px">
				</td>
				<td>
					<xform:select property="fdStatus" showStatus="view" value="${pdaModuleConfigMain.fdStatus}">
						<xform:enumsDataSource enumsType="pda_module_config_status" />
					</xform:select>
				</td>
				<td>
					<c:out value="${pdaModuleConfigMain.docCreator.fdName}" />
				</td>
				<td>
					<kmss:showDate value="${pdaModuleConfigMain.fdCreateTime}" />
				</td>
			</tr>
		</c:forEach>
	</table>
	<%@ include file="/resource/jsp/list_pagenav_down.jsp" %>
</c:if>
</form>
<%@ include file="/resource/jsp/list_down.jsp"%>