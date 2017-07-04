<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/list_top.jsp"%>
<%@page import="com.landray.kmss.km.forum.model.KmForumTopic"%>
<c:import url="/resource/jsp/search_bar.jsp" charEncoding="UTF-8">
<c:param name="fdModelName"
		value="com.landray.kmss.km.forum.model.KmForumTopic" />
</c:import>
<script type="text/javascript">
	function distillate(){
	Com_OpenWindow('<c:url value="/km/forum/km_forum/kmForumTopic.do?method=list&fdPinked=1&fdForumId=${param.fdForumId}"/>',"_self");
	} 
	function  checkSelect(){
		var values="";
		var selected;
		var select = document.getElementsByName("List_Selected");
		for(var i=0;i<select.length;i++) {
			if(select[i].checked){
				values+=select[i].value;
				values+=",";
				selected=true;
			}
		}
		if(selected) {
			values = values.substring(0,values.length-1);
			if(selected) {
				Com_OpenWindow('<c:url value="/km/forum/km_forum/kmForumTopic_changeCategory.jsp" />?values='+values);
				return;
			}
		}
		alert('<bean:message bundle="km-forum" key="kmForumCategory.chooseDocument" />');
		return false;
	}
</script>
<c:if test="${not empty param.fdForumId}">
	<c:set value="&fdForumId=${param.fdForumId}" var="paramForumId"/>
</c:if>

<html:form action="/km/forum/km_forum/kmForumTopic.do">
	<div id="optBarDiv">	
		<c:if test="${empty param.fdPinked}">	
			<input type="button"  onclick="distillate();" value="<bean:message  bundle="km-forum" key="menu.kmForum.pink"/>" title="<bean:message  bundle="km-forum" key="menu.kmForum.pink"/>">
		</c:if>
		<%---新建修改为发帖 modify by zhouchao 20090525--%>
		<c:if test="${empty param.fdForumId}">
			<kmss:auth requestURL="/km/forum/km_forum/kmForumPost.do?method=add&owner=true" requestMethod="GET">
				<input type="button" value="<bean:message key="kmForum.button.publish"  bundle="km-forum"/>"
					onclick="Com_OpenWindow('<c:url value="/km/forum/km_forum/kmForumPost.do" />?method=add&owner=true');">
			</kmss:auth>		
		</c:if>
		<%---新建修改为发帖 modify by zhouchao 20090525--%>
		<c:if test="${not empty param.fdForumId}">		
		<kmss:auth requestURL="/km/forum/km_forum/kmForumPost.do?method=add&fdForumId=${param.fdForumId}" requestMethod="GET">
			<input type="button" value='<bean:message key="kmForum.button.publish" bundle="km-forum"/>'
				onclick="Com_OpenWindow('<c:url value="/km/forum/km_forum/kmForumPost.do" />?method=add${paramForumId}');">
		</kmss:auth>
		
		<kmss:auth requestURL="/km/forum/km_forum/kmForumTopic.do?method=deleteall&fdForumId=${param.fdForumId}" requestMethod="GET">
			<input type="button" value="<bean:message key="button.delete"/>"
				onclick="if(!List_ConfirmDel())return;Com_Submit(document.kmForumTopicForm, 'deleteall');">
			<c:set value="true" var="hasDeleteRight"/>
		</kmss:auth>	
		</c:if>
		<!-- 版块转移 -->
		<input type="button" value='<bean:message key="kmForumCategory.button.changeDirectory" bundle="km-forum"/>' onclick="checkSelect();">
		<%-- 在草稿中显示删除按钮，其中权限为 --%>
		<c:if test="${not empty param.isDraft}">
		<kmss:auth requestURL="/km/forum/km_forum/kmForumTopic.do?method=deleteallDraft" requestMethod="GET">
			<input type="button" value="<bean:message key="button.delete"/>"
					onclick="if(!List_ConfirmDel())return;Com_Submit(document.kmForumTopicForm, 'deleteallDraft');">
		</kmss:auth>
		</c:if>
		<%--搜索 modify by zhouchao 20090525---%>
		<%--<input type="button"  onclick="goSearch();" value="<bean:message key="button.search"/>" title="<bean:message key="button.search"/>">--%>
		
		<input type="button" value="<bean:message key="button.search"/>"
			onclick="Search_Show();">
	</div>
	
	<div id="DIV_SearchBar" style="display:none; position:absolute; top:5px; width:340px; right:20px;">
		<table width="100%" bgcolor="444444" cellspacing="0" cellpadding="1" height="26">
			<tr>
				<td>
				<table width="100%" cellspacing="1" cellpadding="1" class="tbsearchbar">
					<tr>
						<td nowrap>&nbsp;<bean:message key="message.quickSearch"/>：<bean:message key="message.keyword"/></td>
						<td nowrap>
						<input name="keywords" onkeydown="if (event.keyCode == 13 && this.value !='') StartSearch.click();" >
						<input type="button" class="searchButtin" onclick="doSearch();" value="<bean:message key="button.search"/>" name="StartSearch">
						<input type="button" class="searchButtin"  onclick="showSearchPage();" value="<bean:message key="button.advancedSearch"/>" >
						</td>
						<td valign="top"><a href="#">
						<img alt="<bean:message key="button.close"/>" border="0" src="${KMSS_Parameter_StylePath}icons/x.gif" width="5" height="5" hspace="2" vspace="2" onclick="showSearchBar(false)"></a></td>
					</tr>
				</table>
				</td>
			</tr>
		</table>
	</div>
		
	<% if (((Page)request.getAttribute("queryPage")).getTotalrows()==0){ %>
	<%@ include file="/resource/jsp/list_norecord.jsp"%>
	<% }else{ %>
	<%@ include file="/resource/jsp/list_pagenav_top.jsp"%>
	<table id="List_ViewTable">
		<tr>
			<sunbor:columnHead htmlTag="td">
				<td width="10pt"><input type="checkbox" name="List_Tongle"></td>				
				
				<td><bean:message key="page.serial"/></td>
	
				<sunbor:column property="kmForumTopic.docSubject">
					<bean:message  bundle="km-forum" key="kmForumTopic.docSubject"/>
				</sunbor:column>

				<td>
					<bean:message  bundle="km-forum" key="kmForumTopic.fdForumId"/>
				</td>
				
				<sunbor:column property="kmForumTopic.fdPoster.fdId">
					<bean:message  bundle="km-forum" key="kmForumTopic.fdPosterId"/>
				</sunbor:column>

				<sunbor:column property="kmForumTopic.fdHitCount">
					<bean:message  bundle="km-forum" key="kmForumTopic.fdHitCount"/>
				</sunbor:column>

				<sunbor:column property="kmForumTopic.fdReplyCount">
					<bean:message  bundle="km-forum" key="kmForumTopic.fdReplyCount"/>
				</sunbor:column>

				<sunbor:column property="kmForumTopic.fdLastPostTime">
					<bean:message  bundle="km-forum" key="kmForumTopic.docAlterTime"/>
				</sunbor:column>
			
				<sunbor:column property="kmForumTopic.fdLastPoster.fdId">
					<bean:message  bundle="km-forum" key="kmForumTopic.fdLastPosterId"/>
				</sunbor:column>

			</sunbor:columnHead>
		</tr>
		<c:forEach items="${queryPage.list}" var="kmForumTopic" varStatus="vstatus">
			<tr
					kmss_href="<c:url value="/km/forum/km_forum/kmForumPost.do" />?method=view&fdForumId=${kmForumTopic.kmForumCategory.fdId}&fdTopicId=${kmForumTopic.fdId}"
					kmss_target="_blank">
				<td><input type="checkbox" name="List_Selected"
					value="${kmForumTopic.fdId}"></td>
					<td>${vstatus.index+1}</td>
					<td width="40%" align="left" title='<c:out value="${kmForumTopic.docSubject }" />' style="text-align: left;">
						<c:if test="${kmForumTopic.fdSticked==true}">
							<img src="${KMSS_Parameter_StylePath}forum/stick.gif" border="0">
						</c:if>				
						<c:if test="${kmForumTopic.fdPinked==true}">
							<img src="${KMSS_Parameter_StylePath}forum/pink.gif" border="0">
						</c:if>
						<c:if test="${kmForumTopic.fdReplyCount>='10'}">
							<img src="${KMSS_Parameter_StylePath}forum/hot.gif" border="0">
						</c:if>
						<c:if test="${kmForumTopic.fdStatus=='40'}">
							<img src="${KMSS_Parameter_StylePath}forum/end.gif" border="0">
						</c:if>
						<%	
							KmForumTopic kmForumTopic = (KmForumTopic) pageContext.getAttribute("kmForumTopic");
							String fdValue = kmForumTopic.getDocSubject();
							if(fdValue==null)
								pageContext.setAttribute("fdValue","");
							if(fdValue!=null&&fdValue.length()>40){
								String value = null;
								value = fdValue.substring(0,40)+"...";
								pageContext.setAttribute("fdValue",value);
							}else{
								pageContext.setAttribute("fdValue",fdValue);
							}
						%>
						<c:out value="${fdValue}" />
					</td>
					
					<td width="12%">
						<c:out value="${kmForumTopic.kmForumCategory.fdName}" />
					</td>
					
					
					<td width="8%">
					<c:if test="${kmForumTopic.fdIsAnonymous==false}">
						<c:out value="${kmForumTopic.fdPoster.fdName}" />
					</c:if>
					<c:if test="${kmForumTopic.fdIsAnonymous==true}">
						<bean:message  bundle="km-forum" key="kmForumTopic.fdIsAnonymous.title"/>
					</c:if>
					</td>
					<td width="5%">
						<c:out value="${kmForumTopic.fdHitCount}" />
					</td>
					<td width="5%">
						<c:out value="${kmForumTopic.fdReplyCount}" />
					</td>
				<td width="15%">
					<c:if test="${!empty kmForumTopic.fdLastPosterName}">
						<kmss:showDate value="${kmForumTopic.fdLastPostTime}" type="datetime"/>	
					</c:if>
					<c:if test="${empty kmForumTopic.fdLastPosterName}">
						<kmss:showDate value="${kmForumTopic.docAlterTime}" type="datetime"/>		
					</c:if>
					</td>
					<td width="8%">
					<c:if test="${!empty kmForumTopic.fdLastPosterName}">
					    <c:choose>
					    <c:when test="${kmForumTopic.fdLastPosterName =='匿名'}">
					      <bean:message  bundle="km-forum" key="kmForumTopic.fdIsAnonymous.title"/>
					    </c:when>
					    <c:otherwise>
					      <c:out value="${kmForumTopic.fdLastPosterName}" />
					    </c:otherwise>
					    </c:choose>
					</c:if>
					<c:if test="${empty kmForumTopic.fdLastPosterName}">
						-
					</c:if>
					</td>
			</tr>
		</c:forEach>
	</table>
	<%@ include file="/resource/jsp/list_pagenav_down.jsp" %>
<% } %>
<%--bookmark--%>
<c:import url="/sys/bookmark/include/bookmark_bar_all.jsp"
	charEncoding="UTF-8">
	<c:param name="fdTitleProName" value="docSubject" />
	<c:param name="fdModelName"
		value="com.landray.kmss.km.forum.model.KmForumTopic" />
</c:import>
</html:form>
<%@ include file="/resource/jsp/list_down.jsp"%>