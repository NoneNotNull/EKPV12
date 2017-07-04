<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8" import="com.landray.kmss.util.ResourceUtil,java.io.File"%>
<%@ include file="/resource/jsp/edit_top.jsp"%>
<%@page import="com.landray.kmss.sys.news.model.SysNewsConfig"%>
<%
	 pageContext.setAttribute("_isJGEnabled", new Boolean(
			com.landray.kmss.sys.attachment.util.JgWebOffice
					.isJGEnabled()));
   	 SysNewsConfig sysNewsConfig = new SysNewsConfig();
     pageContext.setAttribute("ImageW",sysNewsConfig.getfdImageW());
     pageContext.setAttribute("ImageH",sysNewsConfig.getfdImageH());

%>
<script language="JavaScript">Com_IncludeFile("calendar.js|dialog.js");</script>
<script>
	<c:if test="${sysNewsMainForm.method_GET=='add'}">
		var fdModelId='${param.fdModelId}';
		var fdModelName='${param.fdModelName}';
		var url='<c:url value="/sys/news/sys_news_main/sysNewsMain.do" />?method=add&fdTemplateId=!{id}&fdTemplateName=!{name}';
		if(fdModelId!=null&&fdModelId!=''){
			url+="&fdModelId="+fdModelId+"&fdModelName="+fdModelName;
		}
		Com_NewFileFromSimpleCateory('com.landray.kmss.sys.news.model.SysNewsTemplate',url);
	</c:if>

	function submitForm(method, status){
		//提交时根据编辑方式，清空没有选中的编辑方式的文档内容
		var editTypeObj = document.getElementsByName("fdEditType");
		for(var i=0;i<editTypeObj.length;i++){
			if(!editTypeObj[i].checked){
				if("rtf" == editTypeObj[i].value){
					RTF_SetContent("docContent","");//清空rtf域的内容
				}
			}
		}
		if(status!=null)
			document.getElementsByName("docStatus")[0].value = status;
		Com_Submit(document.sysNewsMainForm, method);
	}
	function SetAuthorField() {
		var checkBox = document.getElementById("isWriter");
		var checked = checkBox.checked;
		var authorId = document.getElementById("authorId");
		var authorName = document.getElementById("authorName");
		var authorSelect = document.getElementById("authorSelect");
		if (true == checked) {
			authorId.value = "";
			authorId.disabled = true;
			authorName.value = "";
			authorName.readOnly = false;
			authorSelect.style.display = "none";
		} else {
			authorId.disabled = false;
			authorName.value = "";
			authorName.readOnly = true;
			authorSelect.style.display = "";
		}
	}
	Com_AddEventListener(window, "load", function() {
		alert('load');
		if (true == document.getElementById("isWriter").checked) {
			document.getElementById("authorSelect").style.display = "none";
		}
		checkEditType("${sysNewsMainForm.fdContentType}", null);
	});
	var hasSetHtmlToContent = false;
	var htmlContent = "";
	Com_Parameter.event["submit"].push(function() {
		var type=document.getElementsByName("fdContentType")[0];
		if ("word" == type.value) {
			if ("${pageScope._isJGEnabled}" == "true") {
				// 保存附件
				if(!JG_SaveDocument()){return false;}
				// 保存附件为html
				if(!JG_WebSaveAsHtml()){return false;}
			} else {
				//蓝凌控件需要做的事
				return getHTMLtoContent("editonline", "fdAttachmentPic");
			}
		}
		return true;
	});
	Com_Parameter.event["confirm"].push(function() {
		if (hasSetHtmlToContent) {
			document.sysNewsMainForm.fdHtmlContent.value = htmlContent;
		}
		return true;
	});
	function checkEditType(value, obj){
		//alert(1);
		//debugger;
		var type=document.getElementsByName("fdContentType")[0];
		//alert(type);
		type.value = "rtf";
		var _rtfEdit = document.getElementById('rtfEdit');
		var _wordEdit = document.getElementById('wordEdit');
		if (_rtfEdit == null || _wordEdit == null) {
			return ;
		}
		if("word" == value){
			type.value = "word";
			_rtfEdit.style.display = "none";
			_wordEdit.style.display = "block";
			if ("${pageScope._isJGEnabled}" == "true") {
				JG_Load();
			}
		} else {
			_rtfEdit.style.display = "block";
			_wordEdit.style.display = "none";
		}
	}
	function getTempFilePath(fdKey){
		Attachment_ObjectInfo[fdKey].getOcxObj();
		var tempFold = Attachment_ObjectInfo[fdKey].ocxObj.GetUniqueFileName();
		tempFold = tempFold.substring(0, tempFold.lastIndexOf('\\'));
		return tempFold;
	}
	
	function getHTMLtoContent(fdKey, picfdKey) {
		if (!fdKey || !picfdKey) {
			return false;
		}
		if (hasSetHtmlToContent) return true;
		var hasImg = false;
		var path = getTempFilePath(fdKey);
		var tbody = document.createElement('tempdom');
  		tbody.innerHTML = Attachment_ObjectInfo[fdKey].ocxObj.getHTMLEx();
  		for(var i = 0; i < tbody.all.length; i++) {
			if(tbody.all[i].src != null) {
				var Vshape = tbody.all[i].parentElement;
				if(Vshape.tagName == "shape" || tbody.all[i].tagName == "img") {
					var ImgUrl = tbody.all[i].src;
					ImgUrl = "\\" + ImgUrl;
					ImgUrl = ImgUrl.replace("/","\\");
					Attachment_ObjectInfo[fdKey].getOcxObj();
					Attachment_ObjectInfo[fdKey].addDoc(path+ImgUrl,null,false,null,null);
					hasImg = true;
				}
			}
		}
		Attachment_ObjectInfo[fdKey].onFinishPostCustom = function(fileList) {
			var fdIds = new Array();
			for(var i = 0; i < fileList.length; i ++) {
				fdIds.push(fileList[i].fdId+":"+fileList[i].fileName);
			}
			if (fdIds.length > 0) {
				updatePicHTML(tbody, fdIds);
			}
		};
		if (!hasImg && typeof tbody == "object") {
			htmlContent = tbody.innerHTML;
		}
		hasSetHtmlToContent = true;
		return true;
	}

	function formatHTML(html){
		var up = "<%=request.getRequestURL()%>";
        if(up.indexOf("https")==0){
           //https下
		  up = up.substring(0,up.indexOf("/",8));
		}else{
			//http下
			up = up.substring(0,up.indexOf("/",7));
			}
		up = up.replace("//","\\/\\/");
		var rep = "/"+up+"/gi";
		html = html.replace(eval(rep),"");
		return html;
	}
	
	function updatePicHTML(tbody, fdIds){
  		for(var i = 0; i < tbody.all.length; i++) {	
			if(tbody.all[i].src != null) {
				var Vshape = tbody.all[i].parentElement;
				if(Vshape.tagName == "shape" || tbody.all[i].tagName == "img") {
					var objstr = Vshape.innerHTML;
					var fdId='';
					var result = getImgFdId(fdIds,objstr);
					if(result != "false"){
						fdId = result;
					}
					var pp = 'sys/attachment/sys_att_main/sysAttMain.do?method=download&fdId='+fdId;
					if(tbody.all[i].tagName == "img") {
						tbody.all[i].src = Com_Parameter.ContextPath + pp;
						tbody.all[i].kmss_ref = pp;
					}else{
						Vshape.innerHTML = "<img  src=\"" + Com_Parameter.ContextPath + pp + "\" style=\"" + Vshape.style.cssText + "\" kmss_ref='" + pp + "'>";
					}
				}
			}
		}
  		htmlContent = formatHTML(tbody.innerHTML);
	}

	//获取图片的id
	function getImgFdId(fdIds,fileName){
		for(var i = 0; i < fdIds.length; i ++) {
			var fdName = fdIds[i].split(":")[1];
			var fdid = fdIds[1].split(":")[0];
			if(fileName.indexOf(fdName,0)>0){
				//return fdName.split(":")[0];
				return fdid;
			}
		}
		return false;
	}

	function len(s) { var l = 0; var a = s.split(""); for (var i=0;i<a.length;i++) { if (a[i].charCodeAt(0)<299) { l++; } else { l+=2; } } return l; }
</script>
<html:form action="/sys/news/sys_news_main/sysNewsMain.do"
	onsubmit="return validateSysNewsMainForm(this);">
	<c:if test="${sysNewsMainForm.method_GET=='add'}">
		<kmss:windowTitle
			subjectKey="sys-news:sysNews.create.title"
			moduleKey="sys-news:news.moduleName" />
	</c:if>
	<c:if test="${sysNewsMainForm.method_GET=='edit'}" >
		<kmss:windowTitle
			subject="${sysNewsMainForm.docSubject}"
			moduleKey="sys-news:news.moduleName" />
	</c:if> 
	<div id="optBarDiv">
		<c:if test="${sysNewsMainForm.method_GET=='add'}">
			<input type=button
				value="<bean:message bundle="sys-news" key="news.button.store"/>"
				onclick="submitForm('save','10');">
			<input type=button value="<bean:message key="button.submit"/>"
				onclick="submitForm('save','20');">
		</c:if>
		<c:if test="${sysNewsMainForm.method_GET=='edit' && (sysNewsMainForm.docStatus=='10' || sysNewsMainForm.docStatus=='11')}">
			<input type=button
				value="<bean:message bundle="sys-news" key="news.button.store"/>"
				onclick="submitForm('update','10');">
			<input type=button value="<bean:message key="button.submit"/>"
				onclick="submitForm('update','20');">
		</c:if>
		<c:if test="${sysNewsMainForm.method_GET=='edit'&& sysNewsMainForm.docStatus!='10'&& sysNewsMainForm.docStatus!='11'}">
			<input type=button value="<bean:message key="button.submit"/>"
				onclick="submitForm('update');">
		</c:if>
		<input type="button" value="<bean:message key="button.close"/>"
			onclick="Com_CloseWindow();">
	</div>

	<p class="txttitle"><bean:message bundle="sys-news"
		key="table.sysNewsMain" /></p>
	<center>
	<table id="Label_Tabel" width=95%>
		<!--  主要内容 -->
		<tr
			LKS_LabelName="<bean:message bundle='sys-news' key='news.document.content'/>">
			<td>
			<table id="base_info" class="tb_normal" width=100%>
				<!-- 新闻主题 -->
				<tr>
					<td class="td_normal_title" width=15%>
						<bean:message bundle="sys-news"
						key="sysNewsMain.docSubject" /></td>
					<td colspan=3><html:text property="docSubject"
						style="width:80%" maxlength="200" /> <span class="txtstrong">*</span>
						<html:checkbox property="fdIsHideSubject" />
						<bean:message bundle="sys-news" key="sysNewsMain.fdIsHideSubject" />
					</td>
				</tr>
				<!-- 关 键 字 -->
				
				<tr>
					<td class="td_normal_title" width=15%>
					<bean:message
						bundle="sys-news" key="sysNewsMain.fdNewsSource" />
					</td>
					<td width=35%>
						<html:text property="fdNewsSource" style="width:80%;"/>
					</td>
					<td class="td_normal_title" width=15% rowspan="2"><bean:message
						bundle="sys-news" key="sysNewsMain.fdMainPicture" /></td>
					<td width=35% rowspan="2">
						<c:import
							url="/sys/attachment/sys_att_main/sysAttMain_edit.jsp"
							charEncoding="UTF-8">
							<c:param name="fdKey" value="Attachment" />
							<c:param name="fdMulti" value="false" />
							<c:param name="fdAttType" value="pic" />
							<c:param name="fdImgHtmlProperty" value="width=120" />
							<c:param name="fdModelId" value="${param.fdId }" />
							<c:param name="fdModelName"
								value="com.landray.kmss.sys.news.model.SysNewsMain" />
							<%-- 图片设定大小 --%>
							<c:param name="picWidth" value="${ImageW}" />
							<c:param name="picHeight" value="${ImageH}" />
							<c:param name="proportion" value="false" />
						</c:import><br>
						<bean:message bundle="sys-news" key="sysNewsMain.config.desc" />
						 <font color="red">${ImageW}(<bean:message bundle="sys-news" key="sysNewsMain.config.width"/>)*${ImageH}(<bean:message bundle="sys-news" key="sysNewsMain.config.height"/>)</font>						
					</td>
				</tr>
				<%--关键字去掉
				<tr>
					<td class="td_normal_title" width=15%><bean:message
						bundle="sys-news" key="sysNews.docKeyword" /></td>
					<td width=35%><html:hidden property="docKeywordIds" /> <html:text
						property="docKeywordNames" style="width:80%;" /></td>
				</tr>--%>
				<tr>
					<!-- 新闻重要度 -->
					<td class="td_normal_title" width=15%><bean:message
						bundle="sys-news" key="sysNewsTemplate.fdImportance" /></td>
					<td width=35%><sunbor:enums property="fdImportance"
						enumsType="sysNewsMain_fdImportance" elementType="radio" />
					</td>
				</tr>
				<!-- 标签机制 -->
				<c:import url="/sys/tag/include/sysTagMain_edit.jsp"
					charEncoding="UTF-8">
					<c:param name="formName" value="sysNewsMainForm" />
					<c:param name="fdKey" value="newsMainDoc" /> 
					<c:param name="modelName" value="com.landray.kmss.sys.news.model.SysNewsMain" />
					<c:param name="fdQueryCondition" value="fdTemplateId;fdDepartmentId" /> 
				</c:import>
				<!-- 标签机制 -->
				<%-- 所属场所 --%>
                <c:import url="/sys/authorization/sys_auth_area/sysAuthArea_field.jsp" charEncoding="UTF-8">
                    <c:param name="id" value="${sysNewsMainForm.authAreaId}"/>
                </c:import> 
            				
				<tr>
					<!-- 新闻模板 -->
					<td class="td_normal_title" width=15%><bean:message
						bundle="sys-news" key="sysNewsMain.fdTemplateId" /></td>
					<td width=35%>
						<html:hidden property="fdTemplateId" />
						<html:hidden property="fdTemplateName" />
						<c:out value="${sysNewsMainForm.fdTemplateName }" />
					</td>
					<td class="td_normal_title" width=15%><bean:message
						bundle="sys-news" key="sysNewsMain.docPublishTime" /></td>
					<td width=35%>
						<html:text property="docPublishTime" readonly="true" style="width:80%" styleClass="inputsgl" />
						<a href="#" onclick="selectDate('docPublishTime');return false;">
							<bean:message key="dialog.selectTime"/>
						</a>
					</td>
				</tr>
				<!-- 录 入 者 -->
				<tr>
					<td class="td_normal_title" width=15%><bean:message
						bundle="sys-news" key="sysNewsTemplate.docCreatorId" /></td>
					<td colspan=1><html:hidden property="fdCreatorId" /> <html:text
						property="fdCreatorName" readonly="true" style="width:100%" /></td>
					<td class="td_normal_title" width=15%><bean:message
						bundle="sys-news" key="sysNewsMain.docCreateTime" /></td>
					<td width=33%><html:text property="docCreateTime"
						readonly="true" style="width:100%" /></td>
				</tr>
				<!-- 所属部门 -->
				<tr>
					<%-- 作者 --%>
					<td class="td_normal_title" width=15%><bean:message
						bundle="sys-news" key="sysNewsMain.fdAuthorId" /></td>
					<td width=35%><html:hidden property="fdAuthorId" styleId="authorId" />
					<html:text property="fdAuthorName" readonly="true" 
						styleClass="inputsgl" styleId="authorName" />
					<span class="txtstrong">*</span>&nbsp;&nbsp;&nbsp; <a href="#" id="authorSelect"
						onclick="Dialog_Address(false, 'fdAuthorId','fdAuthorName', ';',ORG_TYPE_PERSON);"><bean:message
						key="dialog.selectOrg" /></a>
						<html:checkbox property="fdIsWriter" onclick="SetAuthorField();" styleId="isWriter" />
						<bean:message bundle="sys-news" key="sysNewsMain.fdIsWriter" /></td>
					<td class="td_normal_title" width=15%><bean:message
						bundle="sys-news" key="sysNewsMain.fdDepartmentId" /></td>
					<td width=35%><html:hidden property="fdDepartmentId" /> <html:text
						property="fdDepartmentName"  readonly="true" styleClass="inputsgl" />
					<span class="txtstrong">*</span>&nbsp;&nbsp;&nbsp; <a href="#"
						onclick="Dialog_Address(false, 'fdDepartmentId','fdDepartmentName', ';',ORG_TYPE_ORG|ORG_TYPE_DEPT);"><bean:message
						key="dialog.selectOrg" /></a></td>
				</tr>
				<tr>
					<td class="td_normal_title" width=15%><bean:message
						bundle="sys-news" key="sysNewsMain.fdDescription" /></td>
					<td width="85%" colspan="3">
						<html:textarea property="fdDescription" style="width:100%;height:90px"
						styleClass="inputmul" />
					</td>
				</tr>
				<%-- 编辑方式 --%>
				<html:hidden property="fdContentType" />
				<html:hidden property="fdHtmlContent" />
				<c:if test="${sysNewsMainForm.method_GET=='add'}">
				<tr>
					<td class="td_normal_title" width=15%>
						<bean:message bundle="sys-news" key="sysNewsMain.fdContentType" />
					</td>
					<td width="85%" colspan="3">
						<xform:radio property="fdEditType" showStatus="edit" value="${sysNewsMainForm.fdContentType}" onValueChange="checkEditType">
							<xform:enumsDataSource enumsType="sysNewsMain_fdContentType" />
						</xform:radio>
					</td>
				</tr>
				</c:if>
				<!-- 新闻内容 -->
				<tr>
					<td class="td_normal_title" colspan=4 align="center"><bean:message
						bundle="sys-news" key="sysNewsMain.docContent" /></td>
				</tr>
				<tr>
					<td colspan=4>
						<c:if test="${sysNewsMainForm.fdIsLink&& not empty sysNewsMainForm.fdLinkUrl}">
							<bean:message bundle="sys-news" key="SysNewsMain.linkNews" />
							<a href='<c:url value="${sysNewsMainForm.fdLinkUrl}"/>'/>
								${sysNewsMainForm.docContent}
							</a>
						</c:if> 
						<c:if test="${empty sysNewsMainForm.fdIsLink || empty sysNewsMainForm.fdLinkUrl}">
							<div id="rtfEdit" 
							<c:if test="${sysNewsMainForm.fdContentType!='rtf'}">style="display:none"</c:if>>
							<kmss:editor property="docContent" toolbarSet="Default" height="500" />
							</div>
							<div id="wordEdit" style="height:600px;"
							<c:if test="${sysNewsMainForm.fdContentType!='word'}">style="display:none"</c:if>>
							<c:choose>
							<c:when test="${pageScope._isJGEnabled == 'true'}">
								<c:import url="/sys/attachment/sys_att_main/jg_ocx.jsp"
									charEncoding="UTF-8">
									<c:param name="fdModelId" value="${sysNewsMainForm.fdId}" />
									<c:param name="fdModelName" value="com.landray.kmss.sys.news.model.SysNewsMain" />
									<c:param name="fdKey" value="editonline" />
									<c:param name="formBeanName" value="sysNewsMainForm" />
									<c:param name="fdAttType" value="${sysNewsMainForm.fdContentType}" />
									<c:param name="fdCopyId" value="" />
									<c:param name="fdTemplateModelId" value="${param.fdTemplateId}" />
									<c:param name="fdTemplateModelName" value="com.landray.kmss.sys.news.model.SysNewsTemplate" />
									<c:param name="fdTemplateKey" value="editonline" />
								</c:import>
							</c:when>
							<c:otherwise>
								<c:import url="/sys/attachment/sys_att_main/sysAttMain_edit.jsp" charEncoding="UTF-8">
									<c:param name="fdModelId" value="${sysNewsMainForm.fdId}"/>
									<c:param name="fdModelName" value="com.landray.kmss.sys.news.model.SysNewsMain"/>
									<c:param name="fdKey" value="editonline"/>
									<c:param name="formBeanName" value="sysNewsMainForm" />
									<c:param name="fdAttType" value="office"/>
									<c:param name="fdTemplateModelId" value="${param.fdTemplateId}" />
									<c:param name="fdTemplateModelName" value="com.landray.kmss.sys.news.model.SysNewsTemplate" />
									<c:param name="fdTemplateKey" value="editonline" />
									<c:param name="templateBeanName" value="sysNewsTemplateForm" />
								</c:import>
								<div id="pic" style="display:none">
									<c:import url="/sys/attachment/sys_att_main/sysAttMain_edit.jsp" charEncoding="UTF-8">
										<c:param name="fdKey" value="fdAttachmentPic" />
										<c:param name="fdModelName" value="com.landray.kmss.sys.news.model.SysNewsMain"/>
									</c:import>
								</div>
							</c:otherwise>
							</c:choose>
							</div>
						</c:if>
					</td>
				</tr>
				<!-- 附件 -->
				<tr KMSS_RowType="documentNews">
					<td class="td_normal_title" width=17%><bean:message
						bundle="sys-news" key="sysNewsMain.attachment" /></td>
					<td colspan=3><c:import
						url="/sys/attachment/sys_att_main/sysAttMain_edit.jsp"
						charEncoding="UTF-8">
						<c:param name="fdAttType" value="byte" />
						<c:param name="fdMulti" value="true" />
						<c:param name="fdShowMsg" value="true" />
						<c:param name="fdImgHtmlProperty" />
						<c:param name="fdKey" value="fdAttachment" />
						<c:param name="fdModelId" value="${param.fdId }" />
						<c:param name="fdModelName"
							value="com.landray.kmss.sys.news.model.SysNewsMain" />
					</c:import></td>
				</tr>
			</table>
			</td>
		</tr>
		<!-- 权限 -->
		<tr LKS_LabelName="<bean:message bundle="sys-right" key="right.moduleName" />">
			<td>
			<table
				class="tb_normal"
				width=100%>
				<c:import
					url="/sys/right/right_edit.jsp"
					charEncoding="UTF-8">
					<c:param
						name="formName"
						value="sysNewsMainForm" />
					<c:param
						name="moduleModelName"
						value="com.landray.kmss.sys.news.model.SysNewsMain" />
				</c:import>
			</table>
			</td>
		</tr>		
		<!-- 相关新闻 -->
		<tr
			LKS_LabelName="<bean:message bundle="sys-news" key="news.document.relation" />">
			<c:set var="mainModelForm" value="${sysNewsMainForm}" scope="request" />
			<c:set var="currModelName"
				value="com.landray.kmss.sys.news.model.SysNewsMain" scope="request" />
			<td>
				<c:import url="/sys/relation/include/sysRelationMain_edit.jsp" charEncoding="UTF-8">
				</c:import>
			</td>
		</tr>
		<!-- 以下代码为嵌入流程模板标签的代码 -->
		<c:import url="/sys/workflow/include/sysWfProcess_edit.jsp" charEncoding="UTF-8">
			<c:param name="formName" value="sysNewsMainForm"/>
			<c:param name="fdKey" value="newsMainDoc"/>
		</c:import>
		<!-- 以上代码为嵌入流程模板标签的代码 -->
	</table>
	</center>
	<html:hidden property="method_GET" />
	<html:hidden property="fdId" />
	<html:hidden property="fdModelId" />
	<html:hidden property="fdModelName" />
	<html:hidden property="docStatus" />
</html:form>
<html:javascript formName="sysNewsMainForm" cdata="false"
	dynamicJavascript="true" staticJavascript="false" />
<%@ include file="/resource/jsp/edit_down.jsp"%>
