<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/edit_top.jsp"%>
<script type="text/javascript">
Com_IncludeFile("common.js|doclist.js|dialog.js");
</script>
<script type="text/javascript">
//重新选择类别刷新页面
function changeCategory(rtnData){
	if(rtnData==null)
		return;
	bCancel = true;
	if(document.kmForumPostForm.fdForumId.value!=''&& document.kmForumPostForm.fdForumId.value!=null){
		var url = location.href;
		var info = rtnData.GetHashMapArray()[0];
		url = Com_SetUrlParameter(url, "fdForumId", info.id);
		document.kmForumPostForm.action = url;
		Com_Submit(document.kmForumPostForm, "reload");
	}
}
function submitKmForumPostForm(method, forumId) {
	//为兼容新UED，暂时把帖子内容校验去掉
	//RTF_UpdateLinkedFieldToForm("docContent");
	Com_Submit(document.kmForumPostForm, method, forumId);
}
// 将RTF的内容更新到Form表单，为了RTF内容不能为空的验证
function RTF_UpdateLinkedFieldToForm(prop) {
	var cframeName = prop + "___Frame";
	var frame = window.frames[cframeName];
	var fck = frame.contentDocument ? frame.contentWindow.FCK : frame.FCK;
	//更新相关联字段
	fck.UpdateLinkedField();
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
	Boolean fdForumAnonymous=new Boolean(false);
	if(kmForumCategory!=null){
		fdForumAnonymous=kmForumCategory.getFdAnonymous();
	}
    pageContext.setAttribute("fdForumAnonymous",fdForumAnonymous);  
    request.setAttribute("globalIsAnonymous",new KmForumConfig().getAnonymous());
%>

<html:form action="/km/forum/km_forum/kmForumPost.do" onsubmit="return validateKmForumPostForm(this);">
<div id="optBarDiv">
	<c:if test="${kmForumPostForm.method_GET=='edit' && kmForumTopic.fdStatus == '10'}">
		<input type=button value="<bean:message key="button.savedraft"/>"
			onclick="submitKmForumPostForm('saveDraft', 'fdForumId');">
	</c:if>
	<c:if test="${kmForumPostForm.method_GET=='edit'}">		
		<input type=button value="<bean:message key="button.update"/>"
			onclick="submitKmForumPostForm('update');">
	</c:if>
	<c:if test="${kmForumPostForm.method_GET=='add'}">
		<input type=button value="<bean:message key="button.savedraft"/>"
			onclick="submitKmForumPostForm('saveDraft', 'fdForumId');">
		<input type=button value="<bean:message key="button.update"/>"
			onclick="submitKmForumPostForm('save', 'fdForumId');">
	</c:if>
	<c:if test="${kmForumPostForm.method_GET=='reply'}">
		<input type=button value="<bean:message key="button.update"/>"
			onclick="submitKmForumPostForm('save');">
	</c:if>
	<c:if test="${kmForumPostForm.method_GET=='quote'}">
		<input type=button value="<bean:message key="button.update"/>"
			onclick="submitKmForumPostForm('save');">
	</c:if>
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
<table class="tb_normal" width=95% style="table-layout:fixed;">
	<html:hidden property="fdId"/>
	<html:hidden property="fdTopicId"/>
	<html:hidden property="fdQuoteMsg"/>
	<html:hidden property="quoteMsg"/>
	<tr>
		<td width="15%" class="td_normal_title"  valign="top">
			<bean:message  bundle="km-forum" key="kmForumTopic.docSubject"/>
		</td>
		<td colspan=3>
			<html:text property="docSubject" style="width:90%"/><span class="txtstrong">*</span>	
		</td>
	</tr>
	
	<tr>
		<td width="15%" class="td_normal_title" >
			<bean:message  bundle="km-forum" key="kmForumTopic.fdForumId"/>
		</td>
		<td width="35%">
		<c:if test="${kmForumPostForm.method_GET=='add'}">
			<html:hidden property="fdForumId" />
			<html:text property="fdForumName" readonly="true" style="width:50%;" styleClass="inputsgl" />
			<a href="#" onclick="Dialog_Tree(false, 'fdForumId', 'fdForumName', ',', 'kmForumCategoryTreeSelectService&categoryId=!{value}', '<bean:message key="dialog.tree.title" bundle="km-forum"/>', null, changeCategory, '${param.fdId}', null, null, '<bean:message key="dialog.title" bundle="km-forum"/>');">
			<bean:message key="dialog.selectOther" /></a><span class="txtstrong">*</span>
		</c:if>
		<c:if test="${kmForumPostForm.method_GET!='add'}">
			<html:hidden property="fdForumId"/>
			<html:text property="fdForumName" readonly="true"/>
		</c:if>
		</td>
		<c:if test="${kmForumPostForm.method_GET!='edit'|| kmForumTopic.fdStatus == '10'}">
			<c:if test="${globalIsAnonymous==true && fdForumAnonymous==true}">
			<td width="15%" class="td_normal_title"  valign="top">
				<bean:message  bundle="km-forum" key="kmForumTopic.fdIsAnonymous"/>
			</td>
			<td width="35%">
				<sunbor:enums property="fdIsAnonymous" enumsType="common_yesno" elementType="radio" />
			</td>
			</c:if>
		</c:if>
		<c:if test="${kmForumPostForm.method_GET =='edit' && kmForumTopic.fdStatus != '10'}">
			<html:hidden property="fdIsAnonymous"/>
		</c:if>
	</tr>
	<c:if test="${kmForumPostForm.method_GET =='edit'}">
		<tr>
			<td width="15%" class="td_normal_title" >
				<bean:message  bundle="km-forum" key="kmForumTopic.fdPosterId"/>
			</td>
			<td>
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
			<td>
				<html:text property="docCreateTime" readonly="true"/>
			</td>
		</tr>
	</c:if>
	<tr>
		<td width="15%" class="td_normal_title" >
			<bean:message  bundle="km-forum" key="kmForumPost.docContent"/>
		</td>
		<td colspan=3 width="85%" >
			<kmss:editor property="docContent" height="400px" needFilter="false"/>
		</td>
	</tr>
	
 	<tr>
		<td width="11%" class="td_normal_title">
			<bean:message  bundle="sys-attachment" key="table.sysAttMain"/>
		</td>
		<td width="89%" colspan=3>
						
		<c:import url="/sys/attachment/sys_att_main/sysAttMain_edit.jsp" charEncoding="UTF-8">
			<c:param name="fdKey" value="attachment"/>
			<c:param name="fdAttType" value="byte"/>
			<c:param name="fdModelId" value="${param.fdId }"/>
			<c:param name="fdModelName" value="com.landray.kmss.km.forum.model.KmForumPost"/>
		</c:import>
		</td>
	</tr>
	<c:if test="${param.method == 'edit' || param.method == 'add'||param.method=='reload' }">	
	<tr>
		<td width="15%" class="td_normal_title" >
		   <bean:message key="KmForumPost.notify.title" bundle="km-forum"/>
		</td>
		<td colspan=3>
		<html:checkbox property="fdIsNotify" value="1" onclick="clickCheckBox(this)" />
		<html:hidden property="fdIsNotify"/>
		<bean:message key="KmForumPost.notify.title.message" bundle="km-forum"/>
		</td>
	</tr>
	<tr id = "id_notify_type" style="display:none" >
		<td width="15%" class="td_normal_title" >
			<bean:message key="KmForumPost.notify.fdNotifyType" bundle="km-forum"/>
		</td>
		<td colspan=3>
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
var reg = /method=edit|method=add|method=reload/;
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
//新建页面如果没有类别，则弹出对话框选择类别
<c:if test="${kmForumPostForm.method_GET=='add'}">
function loadCategory(){
	var fdForumId = document.getElementsByName("fdForumId")[0];
	if(fdForumId.value==null ||fdForumId.value==''){
		Dialog_Tree(false,null,null,null,
			'kmForumCategoryTreeSelectService&categoryId=!{value}',
			'<bean:message key="dialog.tree.title" bundle="km-forum"/>',null,
			function(rtnVal){
				if(rtnVal==null){
					Com_Parameter.CloseInfo = null;
					Com_CloseWindow();
					return;
				}
				var url = location.href;
				var info = rtnVal.GetHashMapArray()[0];
				url = Com_SetUrlParameter(url, "fdForumId", info.id);
				url = Com_SetUrlParameter(url, "fdForumName", info.name);
			    setTimeout("location.href='"+url+"';", 100);
			},null,null,true,'<bean:message key="dialog.title" bundle="km-forum"/>');
	}
}
loadCategory();
</c:if>
</script>
<%@ include file="/resource/jsp/edit_down.jsp"%>