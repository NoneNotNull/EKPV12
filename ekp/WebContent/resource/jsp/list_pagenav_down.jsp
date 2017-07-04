<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<link href="${KMSS_Parameter_ResPath}style/common/list/list.css" rel="stylesheet" type="text/css" />
<div class="pageBox">
	<sunbor:page name="queryPage" rowsizeText="rowsizeText2" pagenoText="pagenoText2" pageListSize="5" pageListSplit="" textStyleClass="pagenav_input" >
	<table width="100%" height="22" cellspacing="0" cellpadding="0" border="0" class="pageNav_tb">
		<tr>
			<td width="2%" valign="top">&nbsp;</td>
			<td width="55%" valign="top">
				<div class="page_box">
				<sunbor:leftPaging><bean:message key="page.thePrev"/></sunbor:leftPaging>
				{11}
				<sunbor:rightPaging><bean:message key="page.theNext"/></sunbor:rightPaging>
				</div>
			</td>
			<td width="15%" valign="top">
				<bean:message key="page.to"/><bean:message key="page.the"/>{9}<bean:message key="page.page"/><a href="#" class="btn_go" title="<bean:message key="page.changeTo"/>"
				 onclick="{10}">Go</a>
			</td>
			<td width="10%" valign="top">
				<bean:message key="page.total"/>&nbsp;{3}&nbsp;<bean:message key="page.row"/>
			</td>
			<td width="10%" valign="top">
				<bean:message key="page.rowPerPage"/>{8}<bean:message key="page.row"/>
			</td>
			<td width="5%" valign="top">
				<c:if test="${pageNavJsFunction==null}">
					<a class="refresh" href="javascript:location.reload();"><bean:message key="button.refresh"/></a>
				</c:if>
				<c:if test="${pageNavJsFunction!=null}">
					<a class="refresh" href="javascript:${pageNavJsFunction}(location.href);"><bean:message key="button.refresh"/></a>
				</c:if>
			</td>
			<td width="2%" valign="top">&nbsp;</td>
		</tr>
	</table>
	</sunbor:page>
</div>