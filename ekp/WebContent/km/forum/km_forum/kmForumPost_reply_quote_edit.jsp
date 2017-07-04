<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/edit_top.jsp"%>
<script type="text/javascript">
Com_IncludeFile("common.js|doclist.js|dialog.js");
function openCategoryWindow(){
	dialog_Category_Tree(null, 'fdForumId', 'fdForumName', ',', 'kmForumCategoryTeeService&categoryId=!{value}', '<bean:message key="dialog.tree.title" bundle="km-forum"/>', null, null, '${param.fdId}', null, null, '<bean:message key="dialog.title" bundle="km-forum"/>');
}
function dialog_Category_Tree(mulSelect, idField, nameField, splitStr, treeBean, treeTitle, treeAutoSelChilde, action, exceptValue, isMulField, notNull, winTitle){
	var dialog = new KMSSDialog(mulSelect, false);
	var node = dialog.CreateTree(treeTitle);
	node.AppendBeanData(treeBean, null, null, null, exceptValue);
	dialog.tree.isAutoSelectChildren = treeAutoSelChilde;
	dialog.winTitle = winTitle==null?treeTitle:winTitle;
	dialog.BindingField(idField, nameField, splitStr);
	dialog.SetAfterShow(action);
	dialog.Show();
}
function submitKmForumPostForm(method, forumId) {
	RTF_UpdateLinkedFieldToForm("docContent");
	Com_Submit(document.kmForumPostForm, method, forumId);
}
// 将RTF的内容更新到Form表单，为了RTF内容不能为空的验证
function RTF_UpdateLinkedFieldToForm(prop) {
	var ck = CKEDITOR.instances[prop];
	ck.updateElement();
	/*
	var cframeName = prop + "___Frame";
	var frame = window.frames[cframeName];
	var fck = frame.contentDocument ? frame.contentWindow.FCK : frame.FCK;
	//更新相关联字段
	fck.UpdateLinkedField();
	*/
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

<html:form action="/km/forum/km_forum/kmForumPost.do" onsubmit="return validateKmForumPostForm(this);">
<div id="optBarDiv">	
	<input type=button value="<bean:message key="button.update"/>"
			onclick="submitKmForumPostForm('saveReplyQuote');">	
	<input type="button" value="<bean:message key="button.close"/>" onclick="Com_CloseWindow();">
</div>
<p class="txttitle">
<c:if test="${kmForumPostForm.method_GET=='add'}">
	<bean:message bundle="km-forum" key="kmForumPost.new.post"/>
	<html:hidden property="fdImportInfo" value="${param.fdImportInfo}"/>
</c:if>
<c:if test="${kmForumPostForm.method_GET=='reply' or kmForumPostForm.method_GET=='quote'}">
	<bean:message bundle="km-forum" key="kmForumPost.reply.post"/>
</c:if>
<c:if test="${kmForumPostForm.method_GET=='edit'}">
	<bean:message bundle="km-forum" key="table.kmForumPost"/><bean:message key="button.edit"/>
	<html:hidden property="fdImportInfo"/>
</c:if>
</p>

<center>
<table class="tb_normal" width="95%">
		<html:hidden property="fdId"/>
		<html:hidden property="fdTopicId"/>
		<html:hidden property="fdQuoteMsg"/>
		<html:hidden property="quoteMsg"/>
	<tr>
		<td width="15%" class="td_normal_title"  valign="top">
			<bean:message  bundle="km-forum" key="kmForumTopic.docSubject"/>
		</td>
		<td colspan=3 width="85%">
			<html:text property="docSubject" style="width:90%"/><span class="txtstrong">*</span>	
		</td>
	</tr>
	
	<tr>
	    <%--新增回复--%>
		<c:if test="${kmForumPostForm.method_GET=='add'}">
			<td width="15%" class="td_normal_title" >
				<bean:message  bundle="km-forum" key="kmForumTopic.fdForumId"/>
			</td>
			<td width="35%">
				<html:hidden property="fdForumId" />
				<html:text property="fdForumName" readonly="true" style="width:50%;" styleClass="inputsgl" />
						<a href="#" onclick="openCategoryWindow();"><bean:message key="dialog.selectOther" /></a><span class="txtstrong">*</span>
			</td>
			<c:if test="${kmForumPostForm.method_GET!='edit'}">
				<c:if test="${globalIsAnonymous==true && fdForumAnonymous==true}">
					<td width="15%" class="td_normal_title"  valign="top">
						<bean:message  bundle="km-forum" key="kmForumTopic.fdIsAnonymous"/>
					</td>
					<td width="35%">
						<sunbor:enums property="fdIsAnonymous" enumsType="common_yesno" elementType="radio" />
					</td>
				</c:if>
			</c:if>
		</c:if>
		<%--编辑--%>
		<c:if test="${kmForumPostForm.method_GET =='edit'}">
			<td width="15%" class="td_normal_title" >
				<bean:message  bundle="km-forum" key="kmForumTopic.fdForumId"/>
			</td>
			<td colspan="3" width="85%">
				<html:hidden property="fdForumId"/>
				<html:text property="fdForumName" readonly="true"/>
			</td>
			<c:if test="${kmForumPostForm.method_GET =='edit'}">
				<html:hidden property="fdIsAnonymous"/>
			</c:if>
		</c:if>
		<%--引用和楼层回复--%>
		<c:if test="${kmForumPostForm.method_GET !='edit' && kmForumPostForm.method_GET !='add'}">
					<td width="15%" class="td_normal_title"><bean:message
							bundle="km-forum" key="kmForumTopic.fdForumId" /></td>
			<c:choose>
			  <c:when test="${globalIsAnonymous==true && fdForumAnonymous==true}">
			        	<td width="35%"><html:hidden property="fdForumId" /> <html:text
								property="fdForumName" readonly="true" /></td>
						<td width="15%" class="td_normal_title" valign="top"><bean:message
								bundle="km-forum" key="kmForumTopic.fdIsAnonymous" /></td>
						<td width="35%"><sunbor:enums property="fdIsAnonymous"
								enumsType="common_yesno" elementType="radio" /></td>
			  </c:when>
			  <c:otherwise>
					   <td colspan="3"><html:hidden property="fdForumId" /> <html:text
								property="fdForumName" readonly="true" /></td>
			  </c:otherwise>
			</c:choose>
		</c:if>
	</tr>
	<c:if test="${kmForumPostForm.method_GET =='edit'}">
		<tr>
			<td width="15%" class="td_normal_title" >
				<bean:message  bundle="km-forum" key="kmForumTopic.fdPosterId"/>
			</td>
			<td width="35%">
				<c:if test="${kmForumPostForm.fdIsAnonymous == false}">
					<html:text property="fdPosterName" readonly="true"/>
				</c:if>
				<c:if test="${kmForumPostForm.fdIsAnonymous == true}">
					<bean:message bundle="km-forum" key="kmForumTopic.fdIsAnonymous.title"/>
				</c:if>
			</td>	
			<td width="15%" class="td_normal_title" >
				<bean:message  bundle="km-forum" key="kmForumTopic.docCreateTime"/>
			</td>
			<td width="35%">
				<html:text property="docCreateTime" readonly="true"/>
			</td>
		</tr>
	</c:if>
	<c:if test="${kmForumPostForm.method_GET=='edit'}">
	<!-- 
	<tr>
		<td width="15%" class="td_normal_title" >
			<bean:message  bundle="km-forum" key="kmForumTopic.docAlterTime"/>
		</td>
		<td colspan=3>
			<html:text property="docAlterTime" readonly="true"/>
		</td>
	</tr>
	-->
	</c:if>

	<tr>
		<td width="15%" class="td_normal_title" >
			<bean:message  bundle="km-forum" key="kmForumPost.docContent"/>
		</td>
		<td colspan="3" width="85%" >
			<kmss:editor property="docContent" height="400px"/>
		</td>
	</tr>
	
 	<tr>
		<td width="15%" class="td_normal_title">
			<bean:message  bundle="sys-attachment" key="table.sysAttMain"/>
		</td>
		<td colspan="3" width="85%" >
			<c:import url="/sys/attachment/sys_att_main/sysAttMain_edit.jsp" charEncoding="UTF-8">
				<c:param name="fdKey" value="attachment"/>
				<c:param name="fdAttType" value="byte"/>
				<c:param name="fdModelId" value="${param.fdId }"/>
				<c:param name="fdModelName" value="com.landray.kmss.km.forum.model.KmForumPost"/>
			</c:import>
		</td>
	</tr>
	<c:if test="${param.method == 'edit' || param.method == 'add' }">	
	<tr>
		<td width="15%" class="td_normal_title" >
			<bean:message key="KmForumPost.notify.title" bundle="km-forum"/>
		</td>
		<td colspan=3 width="85%">
		<html:checkbox property="fdIsNotify" value="1" onclick="clickCheckBox(this)" />
		<html:hidden property="fdIsNotify"/>
		<bean:message key="KmForumPost.notify.title.message" bundle="km-forum"/>
		<td colspan=4>
			<html:checkbox property="fdIsNotify" value="1" onclick="clickCheckBox(this)" />
			<html:hidden property="fdIsNotify"/>
			<bean:message key="KmForumPost.notify.title.message" bundle="km-forum"/>
		</td>
	</tr>
	<tr id = "id_notify_type" style="display:none" >
		<td width="15%" class="td_normal_title" >
			<bean:message key="KmForumPost.notify.fdNotifyType" bundle="km-forum"/>
		</td>
		<td colspan=3 width="85%">
			<kmss:editNotifyType property="fdNotifyType"/>
		</td>
	</tr>
	</c:if>
</table>







</center>
<html:hidden property="method_GET"/>
</html:form>
<script language="JavaScript">Com_IncludeFile("calendar.js");</script>
<html:javascript formName="kmForumPostForm"  cdata="false"
      dynamicJavascript="true" staticJavascript="false"/>
<script language="javascript">
var href = window.location.href; 
var reg = /method=edit|method=add/;
if(reg.test(href)){
var value = "<c:out value="${kmForumPostForm.fdIsNotify}"/>"
	if(value == '1'){
		document.getElementById("id_notify_type").style.display="";
	}else{
		document.getElementById("id_notify_type").style.display="none";
	}
}
function clickCheckBox(obj){
	if(obj.checked){			
		document.getElementById("id_notify_type").style.display="";
		document.kmForumPostForm.fdIsNotify[0].value='1';
		document.kmForumPostForm.fdIsNotify[1].value='1';		
	}else{
		document.kmForumPostForm.fdIsNotify[0].value='0';
		document.kmForumPostForm.fdIsNotify[1].value='0';
		document.getElementById("id_notify_type").style.display="none";	
	}
}
</script>
<%@ include file="/resource/jsp/edit_down.jsp"%>