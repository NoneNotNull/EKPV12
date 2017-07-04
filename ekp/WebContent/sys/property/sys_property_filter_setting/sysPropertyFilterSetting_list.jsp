<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="com.landray.kmss.sys.property.util.SysPropertyCateLoadUtil" %>
<%@page import="java.util.List"%>
<%@ include file="/resource/jsp/list_top.jsp"%>
<script>
function categorySelected(val){
	var url = location.href;
	url = Com_SetUrlParameter(url,"q.category",val);
	location.href = url;
}
</script>
<html:form action="/sys/property/sys_property_filter_setting/sysPropertyFilterSetting.do">
	<div id="optBarDiv">
		<kmss:auth requestURL="/sys/property/sys_property_filter_setting/sysPropertyFilterSetting.do?method=add">
			<input type="button" value="<bean:message key="button.add"/>"
				onclick="Com_OpenWindow('<c:url value="/sys/property/sys_property_filter_setting/sysPropertyFilterSetting.do" />?method=add&filterBean=${filterBean}');">
		</kmss:auth>
		<kmss:auth requestURL="/sys/property/sys_property_filter_setting/sysPropertyFilterSetting.do?method=deleteall">
			<input type="button" value="<bean:message key="button.delete"/>"
				onclick="if(!List_ConfirmDel())return;Com_Submit(document.sysPropertyFilterSettingForm, 'deleteall');">
		</kmss:auth>
	</div>
	<table class="tb_normal" style="margin-top:4px;width: 100%;">
		<tr>
			<td style="padding: 8px;border: 1px #e8e8e8 solid;">
				分类&nbsp;&nbsp;&nbsp;
				<select name="categoryId" style="width:200px;"  onchange="categorySelected(this.value)">
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
				<sunbor:column property="sysPropertyFilterSetting.fdName">
					<bean:message bundle="sys-property" key="sysPropertyFilterSetting.fdName"/>
				</sunbor:column>
				<sunbor:column property="sysPropertyFilterSetting.fdFilterBean">
					<bean:message bundle="sys-property" key="sysPropertyFilterSetting.fdFilterBean"/>
				</sunbor:column>
				<sunbor:column property="sysPropertyFilterSetting.fdDefine">
					<bean:message bundle="sys-property" key="sysPropertyFilterSetting.fdDefine"/>
				</sunbor:column>
			</sunbor:columnHead>
		</tr>
		<c:forEach items="${queryPage.list}" var="sysPropertyFilterSetting" varStatus="vstatus">
			<tr
				kmss_href="<c:url value="/sys/property/sys_property_filter_setting/sysPropertyFilterSetting.do" />?method=view&fdId=${sysPropertyFilterSetting.fdId}">
				<td>
					<input type="checkbox" name="List_Selected" value="${sysPropertyFilterSetting.fdId}">
				</td>
				<td>
					${vstatus.index+1}
				</td>
				<td>
					<c:out value="${sysPropertyFilterSetting.fdName}" />
				</td>
				<td>
					<xform:select property="fdFilterBean" value="${sysPropertyFilterSetting.fdFilterBean}">
						<xform:customizeDataSource className="com.landray.kmss.sys.property.service.spring.SysPropertyFilterListService" />
					</xform:select>
				</td>
				<td>
					<c:out value="${sysPropertyFilterSetting.fdDefine.fdName}" />
					<c:out value="${sysPropertyFilterSetting.fdPropertyText}" />
				</td>
			</tr>
		</c:forEach>
	</table>
	<%@ include file="/resource/jsp/list_pagenav_down.jsp" %>
</c:if>
</html:form>
<%@ include file="/resource/jsp/list_down.jsp"%>