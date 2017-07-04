<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/list_top.jsp"%>
<script type="text/javascript" src="../../js/Search_Div_scroll.js" ></script>
<script type="text/javascript">

function refineSearch(){
	var url ="<c:url value="/sys/ftsearch/expand/sys_ftsearch_chinese_legend/sysFtsearchChineseLegend.do?method=refineSearch"/>"; 
	var queryString = document.getElementsByName("queryString")[0];
	if(queryString.value==""){
		alert('<bean:message bundle="sys-ftsearch-db" key="ftsearch.select.queryString" />');
		queryString.focus();
		return ;
    }	
    url = Com_SetUrlParameter(url, "queryStr", queryString.value); 
	Com_OpenWindow(url,"_self");
}

function scall(){ 
	document.getElementById("Search_Div").style.top= GetPageScrollTop();
	document.getElementById("Search_Div").style.left= GetPageScrollLeft();
} 

window.onscroll=scall; 
window.onresize=scall; 
window.onload=scall;
</script>


<html:form action="/sys/ftsearch/expand/sys_ftsearch_chinese_legend/sysFtsearchChineseLegend.do">
<div id="Search_Div" style="display:block; position:absolute; top:0px; left:0px;z-index:2000;">
		<table class="">
			<tr>
				<td nowrap>
					&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<bean:message bundle="sys-ftsearch-expand" key="sysFtsearchChineseLegend.search"/>
				</td>
				<td nowrap>
					<input type="text" name="queryString" value="${queryString}" class="input_search" onkeyup="if (event.keyCode == 13 && this.value !='') refineSearch();">
					<input type="button" class="btn_search" onclick="refineSearch();" value="<bean:message bundle="sys-ftsearch-expand" key="button.search"/>" >
				</td>
			</tr>
		</table>
		
	</div>

	<div id="optBarDiv">
		<kmss:auth requestURL="/sys/ftsearch/expand/sys_ftsearch_chinese_legend/sysFtsearchChineseLegend.do?method=add">
			<input type="button" value="<bean:message key="button.add"/>"
				onclick="Com_OpenWindow('<c:url value="/sys/ftsearch/expand/sys_ftsearch_chinese_legend/sysFtsearchChineseLegend.do" />?method=add');">
		</kmss:auth>
		<kmss:auth requestURL="/sys/ftsearch/expand/sys_ftsearch_chinese_legend/sysFtsearchChineseLegend.do?method=deleteall">
			<input type="button" value="<bean:message key="button.delete"/>"
				onclick="if(!List_ConfirmDel())return;Com_Submit(document.sysFtsearchChineseLegendForm, 'deleteall');">
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
				
				<sunbor:column property="sysFtsearchChineseLegend.fdSearchWord">
					<bean:message bundle="sys-ftsearch-expand" key="sysFtsearchChineseLegend.fdSearchWord"/>
				</sunbor:column>
				<sunbor:column property="sysFtsearchChineseLegend.fdSearchFrequency">
					<bean:message bundle="sys-ftsearch-expand" key="sysFtsearchChineseLegend.fdSearchFrequency"/>
				</sunbor:column>
				<sunbor:column property="sysFtsearchChineseLegend.fdShieldFlag">
					<bean:message bundle="sys-ftsearch-expand" key="sysFtsearchChineseLegend.fdShieldFlag"/>
				</sunbor:column>
				<sunbor:column property="sysFtsearchChineseLegend.fdUserName">
					<bean:message bundle="sys-ftsearch-expand" key="sysFtsearchChineseLegend.fdUserName"/>
				</sunbor:column>
				<sunbor:column property="sysFtsearchChineseLegend.fdSearchTime">
					<bean:message bundle="sys-ftsearch-expand" key="sysFtsearchChineseLegend.fdSearchTime"/>
				</sunbor:column>
			</sunbor:columnHead>
		</tr>
		<c:forEach items="${queryPage.list}" var="sysFtsearchChineseLegend" varStatus="vstatus">
			<tr
				kmss_href="<c:url value="/sys/ftsearch/expand/sys_ftsearch_chinese_legend/sysFtsearchChineseLegend.do" />?method=view&fdId=${sysFtsearchChineseLegend.fdId}">
				<td>
					<input type="checkbox" name="List_Selected" value="${sysFtsearchChineseLegend.fdId}">
				</td>
				<td>
					${vstatus.index+1}
				</td>
				
				<td width="30%">
					<c:out value="${sysFtsearchChineseLegend.fdSearchWord}" />
				</td>
				<td>
					<c:out value="${sysFtsearchChineseLegend.fdSearchFrequency}" />
				</td>
				<td>
				<%--  
					<c:if test="${sysFtsearchChineseLegend.fdShieldFlag == true}">
						<c:out value="${sysFtsearchChineseLegend.fdShieldFlag}" />
					</c:if> 
				--%>
					<sunbor:enumsShow value="${sysFtsearchChineseLegend.fdShieldFlag}" enumsType="common_yesno" />		
				</td>
				<td>
					<c:out value="${sysFtsearchChineseLegend.fdUserName}" />
				</td>
				<td>
					<kmss:showDate value="${sysFtsearchChineseLegend.fdSearchTime}" />
				</td>
			</tr>
		</c:forEach>
	</table>
	<%@ include file="/resource/jsp/list_pagenav_down.jsp" %>
</c:if>
</html:form>
<%@ include file="/resource/jsp/list_down.jsp"%>