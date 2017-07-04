<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="com.landray.kmss.sys.property.model.SysPropertyDefine" %>
<%@ page import="com.landray.kmss.sys.property.util.PluginUtil" %>
<%@ page import="com.landray.kmss.sys.property.util.SysPropertyCateLoadUtil" %>
<%@ page import="com.landray.kmss.util.*" %>
<%@page import="java.util.List"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib uri="/WEB-INF/kmss-xform.tld" prefix="xform"%>
<%@ include file="/resource/jsp/list_top.jsp"%>
<script type="text/javascript">
Com_IncludeFile("jquery.js");
function openNew(){
	var url = '<c:url value="/sys/property/sys_property_define/sysPropertyDefine.do" />?method=add&displayType=text';
	url = Com_SetUrlParameter(url,"type",'${type}'||'String');
	var categoryId = $("option[selected=true]").val();
	if(categoryId){
		url = Com_SetUrlParameter(url,"categoryId",categoryId);
	}
	Com_OpenWindow(url);
}
function categorySelected(val){
	var url = location.href;
	url = Com_SetUrlParameter(url,"q.category",val);
	location.href = url;
}
</script>
<html:form action="/sys/property/sys_property_define/sysPropertyDefine.do">
	<div id="optBarDiv">
		<kmss:auth requestURL="/sys/property/sys_property_define/sysPropertyDefine.do?method=add">
			<input type="button" value="<bean:message key="button.add"/>"
				onclick="openNew()">
		</kmss:auth>
		<kmss:auth requestURL="/sys/property/sys_property_define/sysPropertyDefine.do?method=deleteall">
			<input type="button" value="<bean:message key="button.delete"/>"
				onclick="if(!List_ConfirmDel())return;Com_Submit(document.sysPropertyDefineForm, 'deleteall');">
		</kmss:auth>
	</div>
	<table class="tb_normal" style="margin-top:4px;width: 100%;">
		<tr>
			<td style="padding: 8px;border: 1px #e8e8e8 solid;">
				分类&nbsp;&nbsp;&nbsp;
				<select name="categoryId" style="width:200px;" onchange="categorySelected(this.value)">
					<option value="">=公共分类=</option>
					<%
					List list = SysPropertyCateLoadUtil.findCategoryList();
					for(Object object:list){
						Object[] vals = (Object[]) object;
						String key = (String) vals[0];
						String name = (String) vals[1];
						if(request.getParameter("q.category")!=null && request.getParameter("q.category").equals(key)){
							out.append("<option value='"+key+"' selected='true'>"+name+"</option>");
						}else{
							out.append("<option value='"+key+"'>"+name+"</option>");
						}
					}
					%>
				</select>
			</td>
		</tr>
	</table>
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
				<sunbor:column property="sysPropertyDefine.fdName">
					<bean:message bundle="sys-property" key="sysPropertyDefine.fdName"/>
				</sunbor:column>
				<sunbor:column property="sysPropertyDefine.fdType">
					<bean:message bundle="sys-property" key="sysPropertyDefine.fdType"/>
				</sunbor:column>
				<sunbor:column property="sysPropertyDefine.fdDisplayType">
					<bean:message bundle="sys-property" key="sysPropertyDefine.fdDisplayType"/>
				</sunbor:column>
				<sunbor:column property="sysPropertyDefine.fdStructureName">
					<bean:message bundle="sys-property" key="sysPropertyDefine.fdStructureName"/>
				</sunbor:column>
				<sunbor:column property="sysPropertyDefine.fdStatus">
					<bean:message bundle="sys-property" key="sysPropertyDefine.fdStatus"/>
				</sunbor:column>
				<sunbor:column property="sysPropertyDefine.docCreator.fdId">
					<bean:message bundle="sys-property" key="sysPropertyDefine.docCreator"/>
				</sunbor:column>
				<sunbor:column property="sysPropertyDefine.docCreateTime">
					<bean:message bundle="sys-property" key="sysPropertyDefine.docCreateTime"/>
				</sunbor:column>
			</sunbor:columnHead>
		</tr>
		<c:forEach items="${queryPage.list}" var="sysPropertyDefine" varStatus="vstatus">
			<tr
				kmss_href="<c:url value="/sys/property/sys_property_define/sysPropertyDefine.do" />?method=view&fdId=${sysPropertyDefine.fdId}">
				<td>
					<input type="checkbox" name="List_Selected" value="${sysPropertyDefine.fdId}">
				</td>
				<td>
					${vstatus.index+1}
				</td>
				<td>
					<c:out value="${sysPropertyDefine.fdName}" />
				</td>
				<td>
					<%-- 日期类型、其它类型特殊处理 --%>
					<c:choose>
					<c:when test="${sysPropertyDefine.fdType == 'DateTime'}">
						<bean:message bundle="sys-property" key="sysPropertyDefine.fdDateType.Date" />
					</c:when>
					<c:when test="${sysPropertyDefine.fdType == 'Date'}">
						<bean:message bundle="sys-property" key="sysPropertyDefine.fdDateType.Date" />
					</c:when>
					<c:when test="${sysPropertyDefine.fdType == 'Time'}">
						<bean:message bundle="sys-property" key="sysPropertyDefine.fdDateType.Time" />
					</c:when>
					<c:otherwise>
						<xform:select property="fdType" value="${sysPropertyDefine.fdType}">
							<xform:customizeDataSource className="com.landray.kmss.sys.property.service.spring.SysPropertyDefineType" />
						</xform:select>
					</c:otherwise>
					</c:choose>
				</td>
				<td>
					<%
						SysPropertyDefine sysPropertyDefine = (SysPropertyDefine)pageContext.getAttribute("sysPropertyDefine");
						String fdDisplayTypeText = PluginUtil.getDefineDisplayTypeText(sysPropertyDefine.getFdType(), sysPropertyDefine.getFdDisplayType());
					%>
					<%=StringUtil.XMLEscape(fdDisplayTypeText) %>
				</td>
				<td>
					<c:out value="${sysPropertyDefine.fdStructureName}" />
				</td>
				<td>
					<sunbor:enumsShow value="${sysPropertyDefine.fdStatus}" enumsType="common_yesno" />
				</td>
				<td>
					<c:out value="${sysPropertyDefine.docCreator.fdName}" />
				</td>
				<td>
					<kmss:showDate value="${sysPropertyDefine.docCreateTime}" />
				</td>
			</tr>
		</c:forEach>
	</table>
	<%@ include file="/resource/jsp/list_pagenav_down.jsp" %>
</c:if>
</html:form>
<%@ include file="/resource/jsp/list_down.jsp"%>