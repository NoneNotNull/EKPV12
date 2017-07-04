<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/third/pda/htmlhead.jsp"%>
<style>
 .com_btnBox{ margin:12px 0; padding:0 20px;}
 .button_one{border:0; width:25%; height:40px; line-height:40px;margin-right:10px; text-align:center;font-size:20px;color:#FFF; border-radius:8px; box-shadow:1px 2px 3px #009fc9; cursor:pointer;background-color:#3592cd}
</style>
<script src='${KMSS_Parameter_ContextPath}sys/bookmark/import/bookmark.js'></script>
<script src='${ KMSS_Parameter_ContextPath }sys/mobile/js/mui/device/device.js'></script>
<script type="text/javascript">
Com_IncludeFile("common.js");
function submitKmForumPostForm(method, forumId) {
	Com_Submit(document.kmForumPostForm, method, forumId);
}
</script>
<%@ page import="java.util.*"%>
<%@ page import="org.springframework.context.ApplicationContext"%>
<%@ page import="org.springframework.web.context.support.WebApplicationContextUtils"%>
<%@ page import="com.landray.kmss.km.forum.service.IKmForumCategoryService"%>
<%@ page import="com.landray.kmss.km.forum.model.*"%>
<%
	ApplicationContext ctx = WebApplicationContextUtils.getRequiredWebApplicationContext(session.getServletContext());
	IKmForumCategoryService kmForumCategoryService = (IKmForumCategoryService) ctx.getBean("kmForumCategoryService");
	KmForumCategory kmForumCategory = (KmForumCategory)kmForumCategoryService.findByPrimaryKey(request.getParameter("fdForumId"));	
    pageContext.setAttribute("fdForumAnonymous",kmForumCategory.getFdAnonymous());
    request.setAttribute("globalIsAnonymous",new KmForumConfig().getAnonymous());
%>

<html:form action="/km/forum/km_forum/kmForumPost.do">
<center>
<table class="docView" width="95%">
		<html:hidden property="fdId"/>
		<html:hidden property="fdTopicId"/>
		<html:hidden property="fdQuoteMsg"/>
		<html:hidden property="quoteMsg"/>
		<input type="hidden" name="flag" value = "pda"/>
		<input type="hidden" name="fdPdaType"/>
		<script type="text/javascript">
			var fdPdaType = device.getClientType();
			document.getElementsByName("fdPdaType")[0].value=fdPdaType;
		</script>
	<tr>
		<td width="15%"    valign="top">
			<bean:message  bundle="km-forum" key="kmForumTopic.docSubject"/>
		</td>
		<td colspan=3 width="85%">
			<html:text property="docSubject" style="width:90%"/><span class="txtstrong">*</span>	
		</td>
	</tr>
	<tr>
			<c:choose>
		  <c:when test="${globalIsAnonymous==true && fdForumAnonymous==true}">
				<td width="15%"   >
					<bean:message  bundle="km-forum" key="kmForumTopic.fdForumId"/>
				</td>
				<td width="85%">
					<html:hidden property="fdForumId"/>
					<html:text property="fdForumName" readonly="true"/>
				</td>
				<td width="15%" >
					<bean:message  bundle="km-forum" key="kmForumTopic.fdIsAnonymous"/>
				</td>
				<td width="35%">
					<sunbor:enums property="fdIsAnonymous" enumsType="common_yesno" elementType="radio" />
				</td>
		  </c:when>
		  <c:otherwise>
				<td width="15%"   >
					<bean:message  bundle="km-forum" key="kmForumTopic.fdForumId"/>
				</td>
				<td colspan="3" width="85%">
					<html:hidden property="fdForumId"/>
					<html:text property="fdForumName" readonly="true"/>
				</td>
				<html:hidden property="fdIsAnonymous"/>
		  </c:otherwise>
	  </c:choose>
	</tr>
	<tr>
		<td width="15%"   >
			<bean:message  bundle="km-forum" key="kmForumPost.docContent"/>
		</td>
		<td colspan="3" width="85%" >
		    <html:textarea property="docContent" style="width:90%" rows="4"/>
		</td>
	</tr>
</table>
 <div class="com_btnBox">
     <input type="button" id="btn_submit" value="<bean:message key="button.submit"/>" class="button_one" onclick="submitKmForumPostForm('saveQuick');"/>
     <input type="button" value="<bean:message bundle="km-forum" key="KmForumPost.return"/>" class="button_one" 
     onclick="history.go(-1);"/>
 </div>
</center>
<html:hidden property="method_GET"/>
</html:form>