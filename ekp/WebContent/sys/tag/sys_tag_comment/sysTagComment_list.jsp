<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/view_top.jsp"%>
<%@ page import="com.sunbor.web.tag.Page" %>
<%@ page import="com.landray.kmss.sys.tag.model.SysTagComment"%>
<script>Com_IncludeFile("optbar.js|list.js|dialog.js");</script>
<html:form action="/sys/tag/sys_tag_comment/sysTagComment.do">
	<table class="tb_normal" width=100%>
		<tr>
			<td class="td_normal_title" colspan="5">
				<FONT size="5"><b><bean:message bundle="sys-tag" key="table.sysTagComment"/></b></FONT>
			</td>
		</tr>
	<% if (((Page)request.getAttribute("queryPage")).getTotalrows()!=0){ %>
		<tr class="tr_normal_title">
			<sunbor:columnHead htmlTag="td">
				<td width="40pt"><bean:message key="page.serial"/></td>
				<sunbor:column property="sysTagComment.fdRemark">
					<bean:message  bundle="sys-tag" key="sysTagComment.fdRemark"/>
				</sunbor:column>
				<sunbor:column property="sysTagComment.fdAppraise">
					<bean:message  bundle="sys-tag" key="sysTagComment.fdAppraise"/>
				</sunbor:column>
				<sunbor:column property="sysTagComment.docCreator.fdName">
					<bean:message  bundle="sys-tag" key="sysTagComment.docCreatorId"/>
				</sunbor:column>
				<sunbor:column property="sysTagComment.docCreateTime">
					<bean:message  bundle="sys-tag" key="sysTagComment.docCreateTime"/>
				</sunbor:column>
			</sunbor:columnHead>
		</tr>
		<c:forEach items="${queryPage.list}" var="sysTagComment" varStatus="vstatus">
			<tr style="cursor:pointer" onclick="Dialog_PopupWindow(Com_Parameter.ContextPath+'resource/jsp/frame.jsp?url='+encodeURIComponent(Com_Parameter.ContextPath+'sys/tag/sys_tag_comment/sysTagComment.do?method=view&fdId=${sysTagComment.fdId}'),'600','300');" onmouseover="this.style.backgroundColor='#F3F3F3'" onmouseout="this.style.backgroundColor='#FFFFFF'">
				<td>${vstatus.index+1}</td>
				<td width="50%" title="${sysTagComment.fdRemark}">
					<%
						SysTagComment sysTagComment = (SysTagComment) pageContext.getAttribute("sysTagComment");
						String fdRemark = sysTagComment.getFdRemark();
						if(fdRemark==null)
							pageContext.setAttribute("fdRemark","");
						if(fdRemark!=null&&fdRemark.length()>80){
							String value = null;
							value = fdRemark.substring(0,80)+"...";
							pageContext.setAttribute("fdRemark",value);
						}else{
							pageContext.setAttribute("fdRemark",fdRemark);
						}
					%>
					<c:out value="${fdRemark}" />
				</td>
				<td>
					<center>
						<sunbor:enumsShow value="${sysTagComment.fdAppraise}" enumsType="sysTagComment_fdAppraise" bundle="sys-tag"/>
					</center>
				</td>
				<td>
					<center>
						<c:out value="${sysTagComment.docCreator.fdName}" />
					</center>
				</td>
				<td>
					<center>
						<kmss:showDate value="${sysTagComment.docCreateTime}" type="datetime"/>
					</center>
				</td>
			</tr>
		</c:forEach>
		<%@ include file="/resource/jsp/list_pagenav_down.jsp"%>
	<% } %>
	</table>
</html:form>
<%@ include file="/resource/jsp/view_down.jsp"%>