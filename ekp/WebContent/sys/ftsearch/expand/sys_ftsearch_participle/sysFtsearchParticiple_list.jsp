<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/list_top.jsp"%>
<script type="text/javascript" src="../../js/Search_Div_scroll.js" ></script>

<script type="text/javascript">
Com_IncludeFile("optbar.js|list.js");



function participle_search(){
	var queryString = document.getElementById("Search_Keyword").value;
	if(!checkQueryString(queryString)){//如果搜索内容为空 则不进行搜索
	       return false;
	}
	window.location.href = Com_SetUrlParameter(window.location.href,"queryString",queryString);

	//window.location.href = "<c:url value="/sys/ftsearch/expand/sys_ftsearch_participle/sysFtsearchParticiple.do?method=list" />" + "&queryString=" + encodeURIComponent(queryString);
}

//检测输入内容不许为空
function checkQueryString(obj)
{
 if(obj.value==""){//请输入内容
	alert("<bean:message bundle='sys-tag' key='sysTag.inputContent' />");
	obj.focus();
	return false;
 }
    return true;
}

function scall(){ 
	document.getElementById("Search_Div").style.top= GetPageScrollTop();
	document.getElementById("Search_Div").style.left= GetPageScrollLeft();
} 

window.onscroll=scall; 
window.onresize=scall; 
window.onload=scall;
</script>

<html:form action="/sys/ftsearch/expand/sys_ftsearch_participle/sysFtsearchParticiple.do">
	
	<div id="Search_Div" style="display:block; position:absolute; top:0px; left:0px;z-index:2000;">
		<table class="">
			<tr>
				<td nowrap>
					&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<bean:message bundle="sys-ftsearch-expand" key="sysFtsearchParticiple.search"/>
				</td>
				<td nowrap>
					<input type="text" id="Search_Keyword" value="${param.queryString}" class="input_search" onkeyup="if (event.keyCode == 13 && this.value !='') participle_search();" >
					<input type="button" class="btn_search" onclick="participle_search();" value="<bean:message bundle="sys-ftsearch-expand" key="button.search"/>" >
					
				</td>

			</tr>
		</table>
	</div>
	<%-- 搜索框
	<c:import url="/sys/ftsearch/expand/sys_ftsearch_synonym/sysFtsearchSynonym_search.jsp" charEncoding="UTF-8">
	
		<c:param name="fdModelName" value="com.landray.kmss.sys.ftsearch.expand.model.SysFtsearchParticiple"/>
		
	</c:import>
	 --%>
	
	
	<div id="optBarDiv">
	
	
		<%-- 搜索 
	 	<input type="button" value="<bean:message bundle="sys-ftsearch-expand" key="button.advanced.search"/>" onclick="Search_More();">
		--%>
		<%-- 新建 --%> 
		<kmss:auth requestURL="/sys/ftsearch/expand/sys_ftsearch_participle/sysFtsearchParticiple.do?method=add">
		
			<input type="button" value="<bean:message key="button.add"/>"
				onclick="Com_OpenWindow('<c:url value="/sys/ftsearch/expand/sys_ftsearch_participle/sysFtsearchParticiple.do" />?method=add&docCategoryId=${param.docCategoryId}');">
		
		</kmss:auth>
		<kmss:auth requestURL="/sys/ftsearch/expand/sys_ftsearch_participle/sysFtsearchParticiple.do?method=deleteall">
			<input type="button" value="<bean:message key="button.delete"/>"
				onclick="if(!List_ConfirmDel())return;Com_Submit(document.sysFtsearchParticipleForm, 'deleteall');">
		</kmss:auth>
		<%-- 导出 --%>
		<kmss:authShow roles="ROLE_FTSEARCH_EXPORT">
			<c:if test="${param.fdExportState =='0'}">	
				<input
					type="button"
					value="<bean:message bundle="sys-ftsearch-expand" key="sysFtsearchParticiple.export"/>"
					onclick="Com_Submit(document.sysFtsearchParticipleForm, 'export');">
			</c:if>
		</kmss:authShow>
		<%-- 生成文件 --%>
		<input type="button"
			   value="<bean:message bundle="sys-ftsearch-expand" key="sysFtsearchParticiple.gen.flie"/>"
			   onclick="Com_Submit(document.sysFtsearchParticipleForm, 'makeFile');">
		<input type="button" value="<bean:message bundle="sys-ftsearch-expand" key="sysFtsearchParticiple.init"/>"
				onclick="Com_OpenWindow('<c:url value="/sys/ftsearch/expand/sys_ftsearch_participle/sysFtsearchParticiple.do" />?method=importDic&docCategoryId=${param.docCategoryId}');">
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
				<sunbor:column property="sysFtsearchParticiple.fdParticiple">
					<bean:message bundle="sys-ftsearch-expand" key="sysFtsearchParticiple.fdParticiple"/>
				</sunbor:column>
				<sunbor:column property="sysFtsearchParticiple.fdExportState">
					<bean:message bundle="sys-ftsearch-expand" key="sysFtsearchParticiple.export.status"/>
				</sunbor:column>
				<sunbor:column property="sysFtsearchParticiple.docCreatorName">
					<bean:message bundle="sys-ftsearch-expand" key="sysFtsearchParticiple.docCreatorName"/>
				</sunbor:column>
				<sunbor:column property="sysFtsearchParticiple.docCreateTime">
					<bean:message bundle="sys-ftsearch-expand" key="sysFtsearchParticiple.fdCreateTime"/>
				</sunbor:column>
				
			</sunbor:columnHead>
		</tr>
		<c:forEach items="${queryPage.list}" var="sysFtsearchParticiple" varStatus="vstatus">
			<tr
				kmss_href="<c:url value="/sys/ftsearch/expand/sys_ftsearch_participle/sysFtsearchParticiple.do" />?method=view&fdId=${sysFtsearchParticiple.fdId}">
				<td>
					<input type="checkbox" name="List_Selected" value="${sysFtsearchParticiple.fdId}">
				</td>
				<td>
					${vstatus.index+1}
				</td>
				<td>
					<c:out value="${sysFtsearchParticiple.fdParticiple}" />
				</td>
				<td>
					<sunbor:enumsShow value="${sysFtsearchParticiple.fdExportState}" enumsType="ftsearch_export_status" />
				</td>
				<td>
					<c:out value="${sysFtsearchParticiple.docCreatorName}" />
				</td>
				<td>
					<kmss:showDate value="${sysFtsearchParticiple.docCreateTime}" />
				</td>
				
			</tr>
		</c:forEach>
	</table>
	<%@ include file="/resource/jsp/list_pagenav_down.jsp" %>
</c:if>
</html:form>
<%@ include file="/resource/jsp/list_down.jsp"%>