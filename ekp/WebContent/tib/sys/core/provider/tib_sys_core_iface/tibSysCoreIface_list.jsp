<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/list_top.jsp"%>
<script type="text/javascript">
	Com_IncludeFile("dialog.js|jquery.js");
	Com_IncludeFile("tib_util.js","${KMSS_Parameter_ContextPath}tib/sys/core/provider/resource/js/","js",true);
</script>
<html:form action="/tib/sys/core/provider/tib_sys_core_iface/tibSysCoreIface.do">
	<div id="optBarDiv">
		<kmss:auth requestURL="/tib/sys/core/provider/tib_sys_core_iface/tibSysCoreIface.do?method=add">
			<input type="button" value="<bean:message key="button.add"/>"
				onclick="Com_OpenWindow('<c:url value="/tib/sys/core/provider/tib_sys_core_iface/tibSysCoreIface.do" />?method=add');">
		</kmss:auth>
		<kmss:auth requestURL="/tib/sys/core/provider/tib_sys_core_iface/tibSysCoreIface.do?method=deleteall">
			<input type="button" value="<bean:message key="button.delete"/>"
				onclick="if(!List_ConfirmDel())return;Com_Submit(document.tibSysCoreIfaceForm, 'deleteall');">
		</kmss:auth>
		
	
	<kmss:authShow roles="ROLE_TIBSYSCOREPROVIDER_TAGMANAGE">
		<input type="button" value="<bean:message bundle="tib-sys-core-provider" key="tibSysCoreIface.tagMaintain"/>"
				onclick="Com_OpenWindow('<c:url value="/tib/sys/core/provider/tib_sys_core_tag/tibSysCoreTag.do" />?method=list');">
	</kmss:authShow>
	
	
	</div>
	
	<bean:message bundle="tib-sys-core-provider" key="table.tibSysCoreTag"/>: 
	<span id="tagHtml"></span>
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
				<sunbor:column property="tibSysCoreIface.fdIfaceName">
					<bean:message bundle="tib-sys-core-provider" key="tibSysCoreIface.fdIfaceName"/>
				</sunbor:column>
				<sunbor:column property="tibSysCoreIface.fdIfaceKey">
					<bean:message bundle="tib-sys-core-provider" key="tibSysCoreIface.fdIfaceKey"/>
				</sunbor:column>
				<sunbor:column property="tibSysCoreIface.controlPattern">
					<bean:message bundle="tib-sys-core-provider" key="tibSysCoreIface.controlPattern"/>
				</sunbor:column>
				<sunbor:column property="tibSysCoreIface.fdIfaceControl">
					<bean:message bundle="tib-sys-core-provider" key="tibSysCoreIface.fdIfaceControl"/>
				</sunbor:column>
				<sunbor:column property="tibSysCoreIface.fdIfaceTags.fdTagName">
					<bean:message bundle="tib-sys-core-provider" key="tibSysCoreIface.fdIfaceTags"/>
				</sunbor:column>
			</sunbor:columnHead>
		</tr>
		<c:forEach items="${queryPage.list}" var="tibSysCoreIface" varStatus="vstatus">
			<tr
				kmss_href="<c:url value="/tib/sys/core/provider/tib_sys_core_iface/tibSysCoreIface.do" />?method=view&fdId=${tibSysCoreIface.fdId}">
				<td>
					<input type="checkbox" name="List_Selected" value="${tibSysCoreIface.fdId}">
				</td>
				<td>
					${vstatus.index+1}
				</td>
				<td>
					<c:out value="${tibSysCoreIface.fdIfaceName}" />
				</td>
				<td>
					<c:out value="${tibSysCoreIface.fdIfaceKey}" />
				</td>
				<td>
					<xform:select property="fdControlPattern" showStatus="view" value="${tibSysCoreIface.fdControlPattern}">
						<xform:enumsDataSource enumsType="fd_control_pattern_enums" />
					</xform:select>
				</td>
				<td>
					<xform:radio value="${tibSysCoreIface.fdIfaceControl}" property="fdIfaceControl" showStatus="view">
						<xform:enumsDataSource enumsType="common_yesno" />
					</xform:radio>
				</td>
				<td>
					<c:forEach items="${tibSysCoreIface.fdIfaceTags}" var="fdIfaceTag" varStatus="vstatus">
						${fdIfaceTag.fdTagName }&nbsp;
					</c:forEach>
				</td>
			</tr>
		</c:forEach>
	</table>

	<%@ include file="/resource/jsp/list_pagenav_down.jsp" %>
</c:if>

<script type="text/javascript">
$(document).ready(function(){
	var tagHtml = "";
	<c:forEach items="${list }" var="tibSysCoreTag">
		// 遍历数组
		<c:forEach items="${tibSysCoreTag }" var="attr" varStatus="vstatus">
			<c:if test="${vstatus.index != 0}">
				<c:if test="${vstatus.index == 1}">
					if(Com_GetUrlParameter(location.href, "tag")=="${attr }"){
						tagHtml += "<font color='red'>${attr }</font>";
					}else{
						tagHtml += "<a href='#' onclick='openByTag(this);'>${attr }</a>";
					}
				</c:if>
				<c:if test="${vstatus.index == 2}">
					tagHtml += "(<font color='blue'>${attr }</font>)&nbsp;&nbsp;&nbsp;&nbsp;";
				</c:if>
			</c:if>
		</c:forEach>
		
	</c:forEach>
	$("#tagHtml").html(tagHtml);
});

function openByTag(o){
	var url=o.toString().replace("#","");
	location.href=Com_SetUrlParameter(url, "tag", o.innerHTML);
}
</script>

</html:form>

<%@ include file="/resource/jsp/list_down.jsp"%>