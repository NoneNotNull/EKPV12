<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/view_top.jsp"%>
<%@page import="com.landray.kmss.km.smissive.util.KmSmissiveConfigUtil"%>
<%@page import="com.landray.kmss.km.smissive.forms.KmSmissiveMainForm"%>

<%@page import="com.landray.kmss.sys.attachment.util.JgWebOffice"%><script>
	function confirmDelete(msg){
		var del = confirm('<bean:message key="page.comfirmDelete"/>');
		return del;
	}
	//解决当在新窗口打开主文档时控件显示不全问题，这里打开时即为最大化修改by张文添
	function max_window(){
		window.moveTo(0, 0);
		window.resizeTo(window.screen.width, window.screen.height);
	}
	function fn_dialog(url){
		var width = 600;
		var height = 480;
		var winStyle = "resizable:1;dialogwidth:"+width+"px;dialogheight:"+height+"px;";
		url = "<c:url value="/resource/jsp/frame.jsp?url=" />" + encodeURIComponent(url);
		return window.showModalDialog(url, null, winStyle);
	}
	max_window();
</script>

<div id="optBarDiv">
	<c:if test="${kmSmissiveMainForm.docStatus!='10'}">
		<kmss:auth
			requestURL="/km/smissive/km_smissive_main/kmSmissiveMain.do?method=printContent&fdId=${param.fdId}"
			requestMethod="GET">
			<input type=button
				value="<bean:message key="kmSmissive.button.print" bundle="km-smissive"/>"
				onclick="Com_OpenWindow('kmSmissiveMain.do?method=print&fdId=${param.fdId}','_blank');">
		</kmss:auth>
	</c:if>
	<kmss:auth requestURL="/km/smissive/km_smissive_main/kmSmissiveMain.do?method=edit&forward=modifyAttRight&fdId=${param.fdId}" requestMethod="GET">
		<input type="button" value="<bean:message bundle="km-smissive" key="smissive.button.attright"/>"
	onclick="fn_dialog('<c:url value="/km/smissive/km_smissive_main/kmSmissiveMain.do"/>?method=edit&forward=modifyAttRight&fdId=${param.fdId}');">
	</kmss:auth>
	<kmss:auth requestURL="/km/smissive/km_smissive_main/kmSmissiveMain.do?method=edit&forward=modifyRight&fdId=${param.fdId}" requestMethod="GET">
		<input type="button" value="<bean:message bundle="km-smissive" key="smissive.button.changeright"/>"
	onclick="fn_dialog('<c:url value="/km/smissive/km_smissive_main/kmSmissiveMain.do"/>?method=edit&forward=modifyRight&fdId=${param.fdId}');">
	</kmss:auth>
	<kmss:auth requestURL="/km/smissive/km_smissive_main/kmSmissiveMain.do?method=edit&forward=modifyIssuer&fdId=${param.fdId}" requestMethod="GET">
		<input type="button" value="<bean:message bundle="km-smissive" key="smissive.button.changeissuer"/>"
	onclick="fn_dialog('<c:url value="/km/smissive/km_smissive_main/kmSmissiveMain.do"/>?method=edit&forward=modifyIssuer&fdId=${param.fdId}');">
	</kmss:auth>
	<%-- 取消多余的打印按钮和下载按钮
	<c:if test="${kmSmissiveMainForm.docStatus != '10'}">
		<kmss:auth requestURL="/km/smissive/km_smissive_main/kmSmissiveMain.do?method=printContent" requestMethod="GET">
			<script>
				function fn_printContent(){
					Doc_SetCurrentLabel("Label_Tabel",2);
					attachmentObject_mainAtt.getOcxObj();
					attachmentObject_mainAtt.ocxObj.EditPrint();
				}
			</script>
			<c:if test="${pageScope._isJGEnabled=='false'}">
			<input type="button"
				value="<bean:message bundle="km-smissive" key="smissive.button.printcontent"/>"
				onclick="fn_printContent();">
				</c:if>
		</kmss:auth>
		<kmss:auth requestURL="/km/smissive/km_smissive_main/kmSmissiveMain.do?method=downloadContent" requestMethod="GET">
			<script>
				function fn_downloadContent(){
					Doc_SetCurrentLabel("Label_Tabel",2);
					attachmentObject_editonline.getOcxObj();
					attachmentObject_editonline.ocxObj.EditUnProtect();
					attachmentObject_mainOnline.ocxObj.AcceptRevisions(true);
					if(attachmentObject_editonline.ocxObj.EditSaveAs("")) {
						alert(Attachment_MessageInfo["msg.downloadSucess"]);
					}
				}
			</script>
			<c:if test="${pageScope._isJGEnabled=='false'}">
			<input type="button"
				value="<bean:message bundle="km-smissive" key="smissive.button.downloadcontent"/>"
				onclick="fn_downloadContent();">
			</c:if>
		</kmss:auth>
	</c:if>
	--%>
	<!-- 切换阅读 -->
	<%if(JgWebOffice.isExistFile(request)&&JgWebOffice.isJGEnabled()&&Boolean.parseBoolean(KmSmissiveConfigUtil.isShowImg(((KmSmissiveMainForm)request.getAttribute("kmSmissiveMainForm"))))){ %>
	<kmss:auth requestURL="/km/smissive/km_smissive_main/kmSmissiveMain.do?method=view&fdId=${param.fdId}" requestMethod="GET">
		<input type="button" value="<bean:message bundle="km-smissive" key="smissive.button.change.view"/>"
		       onclick="Com_OpenWindow('kmSmissiveMain.do?method=view&fdId=${param.fdId}&isShowImg=${isShowImg}','_self');">
	</kmss:auth>	
	<%} %>
	<c:if test="${kmSmissiveMainForm.docStatusFirstDigit > '0' }">
		<kmss:auth requestURL="/km/smissive/km_smissive_main/kmSmissiveMain.do?method=edit&fdId=${param.fdId}" requestMethod="GET">
			<input type="button"
				value="<bean:message key="button.edit"/>"
				onclick="Com_OpenWindow('kmSmissiveMain.do?method=edit&fdId=${param.fdId}','_self');">
		</kmss:auth>
	</c:if>
	<c:if test="${kmSmissiveMainForm.docStatus =='20' }">
		<kmss:auth requestURL="/km/smissive/km_smissive_main/kmSmissiveMain.do?method=edit&fdId=${param.fdId}" requestMethod="GET">
				<!--用于标识显示附件编辑还是查看页面 -->
				<c:set var="editStatus" value="true"/>
		</kmss:auth>
		<c:if  test="${kmSmissiveMainForm.sysWfBusinessForm.fdNodeAdditionalInfo.editDocContent =='true'}">
				<c:set var="editStatus" value="true"/>
		</c:if>
	</c:if>
	<kmss:auth requestURL="/km/smissive/km_smissive_main/kmSmissiveMain.do?method=delete&fdId=${param.fdId}" requestMethod="GET">
		<input type="button"
			value="<bean:message key="button.delete"/>"
			onclick="if(!confirmDelete())return;Com_OpenWindow('kmSmissiveMain.do?method=delete&fdId=${param.fdId}','_self');">
	</kmss:auth>
	<input type="button" value="<bean:message key="button.close"/>" onclick="Com_CloseWindow();">
</div>
<p class="txttitle">${kmSmissiveMainForm.fdTitle}</p>
<center>

<table id="Label_Tabel" width=95% LKS_LabelDefaultIndex=2>

<tr	LKS_LabelName="<bean:message bundle="km-smissive" key="kmSmissiveMain.label.baseinfo" />"><td>
	<table class="tb_normal" width=100%>
		<tr>
			<td class="td_normal_title" width=15%>
				<bean:message  bundle="km-smissive" key="kmSmissiveMain.docSubject"/>
			</td><td width=85% colspan="3">
				${kmSmissiveMainForm.docSubject }
			</td>
		</tr>
		<tr>
			<td class="td_normal_title" width=15%>
				<bean:message  bundle="km-smissive" key="kmSmissiveMain.docAuthorId"/>
			</td><td width=35%>
				${kmSmissiveMainForm.docAuthorName }
			</td>
			<td class="td_normal_title" width=15%>
				<bean:message  bundle="km-smissive" key="kmSmissiveMain.docCreateTime"/>
			</td><td width=35%>
				${kmSmissiveMainForm.docCreateTime }
			</td>
		</tr>
		<tr>
			<td class="td_normal_title" width=15%>
				<bean:message  bundle="km-smissive" key="kmSmissiveMain.fdUrgency"/>
			</td><td width=35%>
				<sunbor:enumsShow
					value="${kmSmissiveMainForm.fdUrgency}"
					enumsType="km_smissive_urgency" bundle="km-smissive" />
			</td>
			<td class="td_normal_title" width=15%>
				<bean:message  bundle="km-smissive" key="kmSmissiveMain.fdSecret"/>
			</td><td width=35%>
				<sunbor:enumsShow
					value="${kmSmissiveMainForm.fdSecret}"
					enumsType="km_smissive_secret" bundle="km-smissive" />
			</td>
		</tr>
		<tr>
			<td class="td_normal_title" width=15%>
				<bean:message  bundle="km-smissive" key="kmSmissiveMain.fdTemplateId"/>
			</td><td width=35%>
				${kmSmissiveMainForm.fdTemplateName }
			</td>
			<td class="td_normal_title" width=15%>
				<bean:message  bundle="km-smissive" key="kmSmissiveMain.fdFileNo"/>
			</td><td width=35%>
				<c:choose>
					<c:when test="${kmSmissiveMainForm.docStatus == '30'}">
						${kmSmissiveMainForm.fdFileNo }
					</c:when>
					<c:otherwise>
						<bean:message  bundle="km-smissive" key="kmSmissiveMain.fdFileNo.describe"/>
					</c:otherwise>
				</c:choose>
			</td>
		</tr>
		<%-- 所属场所 --%>
        <c:import url="/sys/authorization/sys_auth_area/sysAuthArea_field.jsp" charEncoding="UTF-8">
             <c:param name="id" value="${kmSmissiveMainForm.authAreaId}"/>
        </c:import>			
		<tr>
			<td class="td_normal_title" width=15%>
				<bean:message  bundle="km-smissive" key="kmSmissiveMainProperty.fdPropertyId"/>
			</td><td width=35% colspan="3">
				${kmSmissiveMainForm.docPropertyNames }
			</td>
		</tr>
		<tr>
			<td class="td_normal_title" width=15%>
				<bean:message  bundle="km-smissive" key="kmSmissiveMain.fdMainDeptId"/>
			</td><td width=35%>
				${kmSmissiveMainForm.fdMainDeptName }
			</td>
			<td class="td_normal_title" width=15%>
				<bean:message  bundle="km-smissive" key="kmSmissiveMain.docDeptId"/>
			</td><td width=35%>
				${kmSmissiveMainForm.docDeptName }
			</td>
		</tr>
		<tr>
			<td class="td_normal_title" width=15%>
				<bean:message  bundle="km-smissive" key="kmSmissiveMain.fdSendDeptId"/>
			</td><td colspan="3" width=35%>
				${kmSmissiveMainForm.fdSendDeptNames }
			</td>
		</tr>
		<tr>
			<td class="td_normal_title" width=15%>
				<bean:message  bundle="km-smissive" key="kmSmissiveMain.fdCopyDeptId"/>
			</td><td colspan="3" width=35%>
				${kmSmissiveMainForm.fdCopyDeptNames }
			</td>
			
		</tr>
		<tr>
			<td class="td_normal_title" width=15%>
				<bean:message  bundle="km-smissive" key="kmSmissiveMain.fdIssuerId"/>
			</td><td width=35%>
				${kmSmissiveMainForm.fdIssuerName }
			</td>
			<td class="td_normal_title" width=15%>
				<bean:message  bundle="km-smissive" key="kmSmissiveMain.docCreatorId"/>
			</td><td width=35%>
				${kmSmissiveMainForm.docCreatorName }
			</td>
		</tr>
		
		<!-- 标签机制 -->
		<c:import url="/sys/tag/include/sysTagMain_view.jsp"
			charEncoding="UTF-8">
			<c:param name="formName" value="kmSmissiveMainForm" />
			<c:param name="fdKey" value="smissiveDoc" /> 
		</c:import>
		<!-- 标签机制 -->	
		
	</table>
</td></tr>

	<!-- 其他机制 -->
	<%-- 以下代码为在线编辑的代码 --%>
	<tr	LKS_LabelName="<bean:message  bundle="km-smissive" key="kmSmissiveMain.label.content"/>"><td>
	
	<table class="tb_normal" width="100%">
		  <!--   提示信息 -->
		  <%if(com.landray.kmss.sys.attachment.util.JgWebOffice.isJGEnabled()&&JgWebOffice.isExistFile(request)){%>
			   <c:if test="${isShowImg&&kmSmissiveMainForm.docStatus!='20'}">
			   <tr>
			        <td class="td_normal_title" width=15%>
						<bean:message  bundle="km-smissive" key="kmSmissiveMain.prompt.title"/>
					</td>
			     	<td colspan="3">
			     	  <font style="color:red;text-align:center"><bean:message  bundle="km-smissive" key="kmSmissiveMain.prompt"/></font>
			        </td>
			      </tr>
			  </c:if>
		  <%} %>
			  <tr>
				<td colspan="4">
					
	    	<c:if test="${editStatus == true}">
			<%
				// 金格启用模式
					if (com.landray.kmss.sys.attachment.util.JgWebOffice.isJGEnabled()) {
						pageContext.setAttribute("sysAttMainUrl","/sys/attachment/sys_att_main/jg/sysAttMain_edit.jsp");
					} else {
						pageContext.setAttribute("sysAttMainUrl","/sys/attachment/sys_att_main/sysAttMain_edit.jsp");
					}
			%>
			<c:import url="${sysAttMainUrl}" charEncoding="UTF-8">
				<c:param name="fdKey" value="mainOnline" />
				<c:param name="fdAttType" value="office" />
				<c:param name="fdModelId" value="${kmSmissiveMainForm.fdId}" />
				<c:param name="fdModelName"
					value="com.landray.kmss.km.smissive.model.KmSmissiveMain" />
				<c:param name="formBeanName" value="kmSmissiveMainForm" />
				<c:param name="isToImg" value="<%=KmSmissiveConfigUtil.isToImg()%>"/>
			</c:import>
		</c:if> <c:if test="${editStatus != true}">
			<%
				// 金格启用模式
					if (com.landray.kmss.sys.attachment.util.JgWebOffice
							.isJGEnabled()) {
						pageContext.setAttribute("sysAttMainUrl","/sys/attachment/sys_att_main/jg/sysAttMain_include_view.jsp");
					} else {
						pageContext.setAttribute("sysAttMainUrl","/sys/attachment/sys_att_main/sysAttMain_view.jsp");
			 		}
			%>
			<c:import url="${sysAttMainUrl}" charEncoding="UTF-8">
				<c:param name="fdKey" value="mainOnline" />
				<c:param name="fdAttType" value="office" />
				<c:param name="fdModelId" value="${kmSmissiveMainForm.fdId}" />
				<c:param name="fdModelName"
					value="com.landray.kmss.km.smissive.model.KmSmissiveMain" />
				<c:param name="formBeanName" value="kmSmissiveMainForm" />
				<c:param name="isShowImg" value="${isShowImg}"/>
				<c:param name="bookMarks" value="docSubject:${kmSmissiveMainForm.docSubject},docAuthorName:${kmSmissiveMainForm.docAuthorName},fdUrgency:${kmSmissiveMainForm.fdUrgency},fdTemplateName:${kmSmissiveMainForm.fdTemplateName},docCreateTime:${kmSmissiveMainForm.docCreateTime},fdSecret:${kmSmissiveMainForm.fdSecret},fdFileNo:${kmSmissiveMainForm.fdFileNo},fdMainDeptName:${kmSmissiveMainForm.fdMainDeptName},fdSendDeptNames:${kmSmissiveMainForm.fdSendDeptNames},fdCopyDeptNames:${kmSmissiveMainForm.fdCopyDeptNames},fdIssuerName:${kmSmissiveMainForm.fdIssuerName},docCreatorName:${kmSmissiveMainForm.docCreatorName}" />
			</c:import>
		</c:if> <%-- 
		<c:if test="${editStatus == 'true'}">
		<c:import url="/sys/attachment/sys_att_main/sysAttMain_edit.jsp"
					charEncoding="UTF-8">
					<c:param name="fdKey" value="mainOnline" />
					<c:param name="fdAttType" value="office" />
					<c:param name="formBeanName" value="kmSmissiveMainForm" />
			</c:import>
		</c:if>
		<c:if test="${editStatus != 'true'}">
			<c:import url="/sys/attachment/sys_att_main/sysAttMain_view.jsp"
				charEncoding="UTF-8">
				<c:param name="fdKey" value="mainOnline" />
				<c:param name="fdAttType" value="office" />
				<c:param name="formBeanName" value="kmSmissiveMainForm" />
		</c:import>
		</c:if>--%>
		</td>
		</tr>
		<!-- 附件 -->	
		<tr>
			<td	class="td_normal_title"	width="15%">
				<bean:message  bundle="km-smissive" key="kmSmissiveMain.main.att"/>
			</td>
			<td width="85%" colspan="3">
				<c:import url="/sys/attachment/sys_att_main/sysAttMain_view.jsp"
					charEncoding="UTF-8">
					<c:param name="fdKey" value="mainAtt" />
					<c:param name="formBeanName" value="kmSmissiveMainForm" />
				</c:import>
			</td>
		</tr>
		</table>
	   </td>
	   
	   </tr>
	<%-- 以上代码为在线编辑的代码 --%>
	
	<%-- 以下代码为嵌入关联机制的代码 --%>
	<tr	LKS_LabelName="<bean:message bundle="sys-relation" key="sysRelationMain.tab.label" />">
		<c:set var="mainModelForm" value="${kmSmissiveMainForm}" scope="request"/>
		<c:set var="currModelName" value="com.landray.kmss.km.smissive.model.KmSmissiveMain" scope="request"/>
		<td><%@ include	file="/sys/relation/include/sysRelationMain_view.jsp"%>
		</td>
	</tr>
	<%-- 以上代码为嵌入关联机制的代码 --%>
	
	<c:choose>
	 <c:when test="${kmSmissiveMainForm.docStatus != '30' 
	|| (kmSmissiveMainForm.docStatus == '30' && kmSmissiveMainForm.fdFlowFlag == 'false')}">
		<%-- 流程机制 --%>
		<%-- 以下代码为嵌入流程模板标签的代码 --%>
		<c:import url="/sys/workflow/include/sysWfProcess_view.jsp"
			charEncoding="UTF-8">
			<c:param name="formName" value="kmSmissiveMainForm" />
			<c:param name="fdKey" value="smissiveDoc" />
		</c:import>
		<%-- 以上代码为嵌入流程模板标签的代码 --%>
	 </c:when>
	 <c:otherwise>
	    <kmss:auth requestURL="/km/smissive/km_smissive_main/kmSmissiveMain.do?method=viewWfLog&fdId=${param.fdId}">
		<c:import url="/sys/workflow/include/sysWfProcess_view.jsp"
			charEncoding="UTF-8">
			<c:param name="formName" value="kmSmissiveMainForm" />
			<c:param name="fdKey" value="smissiveDoc" />
		</c:import>
		</kmss:auth>
	  </c:otherwise>
	</c:choose>
	
	<%--发布机制开始--%>
	<c:import
		url="/sys/news/include/sysNewsPublishMain_view.jsp"
		charEncoding="UTF-8">
		<c:param name="formName" value="kmSmissiveMainForm" />
	</c:import>
	<%--发布机制结束--%>
	
	<%--以下代码为嵌入阅读机制--%>
	<c:import url="/sys/readlog/include/sysReadLog_view.jsp"
		charEncoding="UTF-8">
		<c:param name="formName" value="kmSmissiveMainForm" />
	</c:import>
	<%--以上代码为嵌入阅读机制--%>
	
	<%--以下代码为嵌入点评机制 --%>
	<c:import url="/sys/evaluation/include/sysEvaluationMain_view.jsp"
		charEncoding="UTF-8">
		<c:param name="formName" value="kmSmissiveMainForm" />
		<c:param name="bundel" value="km-smissive" />
		<c:param name="key" value="kmSmissiveMain.docCreatorId" />
	</c:import>
	<%--以上代码为嵌入点评机制 --%>
	
	<tr LKS_LabelName="<bean:message bundle="sys-right" key="right.moduleName" />"><td>
		<table class="tb_normal" width=100%>
			<c:import url="/sys/right/right_view.jsp" charEncoding="UTF-8">
				<c:param name="formName" value="kmSmissiveMainForm" />
				<c:param name="moduleModelName" value="com.landray.kmss.km.smissive.model.KmSmissiveMain" />
			</c:import>
		</table>
	</td></tr>
	<c:import
		url="/sys/circulation/include/sysCirculationMain_view.jsp"
		charEncoding="UTF-8">
		<c:param
			name="formName"
			value="kmSmissiveMainForm" />
	</c:import>
	
	<%--以下代码为嵌入收藏机制--%>
	<c:import url="/sys/bookmark/include/bookmark_bar.jsp"
		charEncoding="UTF-8">
		<c:param name="fdSubject" value="${kmSmissiveMainForm.docSubject}" />
		<c:param name="fdModelId" value="${kmSmissiveMainForm.fdId}" />
		<c:param name="fdModelName"
			value="com.landray.kmss.km.smissive.model.KmSmissiveMain" />
	</c:import>
	<%--以上代码为嵌入收藏机制--%>
	<kmss:ifModuleExist path="/tools/datatransfer/">
		<c:import
			url="/tools/datatransfer/include/toolsDatatransfer_old_data.jsp"
			charEncoding="UTF-8">
			<c:param
				name="fdModelId"
				value="${kmSmissiveMainForm.fdId}" />
			<c:param 
				name="fdModelName"
				value="com.landray.kmss.km.smissive.model.KmSmissiveMain" />
		</c:import>
	</kmss:ifModuleExist>

</table>

</center>
<%@ include file="/resource/jsp/view_down.jsp"%>

<script language="javascript" for="window" event="onload">
	//Doc_SetCurrentLabel("Label_Tabel",2);
	//var obj = document.getElementsByName("mainOnline_print");	//公司产品JS库有问题，其中生成的按钮没有ID属性，导致ie6不能够用该语句查找
	//obj[0].style.display = "none";
	var tt = document.getElementsByTagName("INPUT");
	
	for(var i=0;i<tt.length;i++){
		if(tt[i].name == "mainOnline_print"){
			tt[i].style.display = "none";
		}
		if(tt[i].name == "mainOnline_printPreview"){
			tt[i].style.display = "none";
		}
		if(tt[i].name == "mainOnline_download"){
			tt[i].style.display = "none";
		}
	}
	
	
</script>