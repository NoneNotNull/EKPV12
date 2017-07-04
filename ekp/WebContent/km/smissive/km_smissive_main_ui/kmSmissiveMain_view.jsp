<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<%@page import="java.util.List"%>
<%@page import="com.landray.kmss.km.smissive.util.KmSmissiveConfigUtil"%>
<%@page import="com.landray.kmss.km.smissive.forms.KmSmissiveMainForm"%>

<%@page import="com.landray.kmss.sys.attachment.util.JgWebOffice"%>
<template:include ref="default.view"   sidebar="auto">
	<template:replace name="title">
		<c:out value="${ kmSmissiveMainForm.docSubject } - ${ lfn:message('km-smissive:table.kmSmissiveMain') }"></c:out>
	</template:replace>
	<template:replace name="toolbar">
		<ui:toolbar id="toolbar" layout="sys.ui.toolbar.float"  count="3">
		<!-- 切换阅读 -->
<%
	//out.print(request.getHeader("User-Agent"));
	if(request.getHeader("User-Agent").toUpperCase().indexOf("MSIE")>-1){
		request.setAttribute("isIE",true);
	}else if(request.getHeader("User-Agent").toUpperCase().indexOf("TRIDENT")>-1){
		request.setAttribute("isIE",true);
	}else{
		request.setAttribute("isIE",false);
	}
%>
		<%if(JgWebOffice.isJGEnabled()&&Boolean.parseBoolean(KmSmissiveConfigUtil.isShowImg(((KmSmissiveMainForm)request.getAttribute("kmSmissiveMainForm"))))){ %>
		<c:choose>
		  <c:when test="${isIE}">
			<kmss:auth requestURL="/km/smissive/km_smissive_main/kmSmissiveMain.do?method=view&fdId=${param.fdId}" requestMethod="GET">
				<ui:button text="${lfn:message('km-smissive:smissive.button.change.view') }" order="2" 
			        onclick="Com_OpenWindow('kmSmissiveMain.do?method=view&fdId=${param.fdId}&isShowImg=${isShowImg}','_self');">
				</ui:button>
			</kmss:auth>	
		  </c:when>
		  <c:otherwise>
		   <%if(JgWebOffice.isJGMULEnabled()){%>
		    <kmss:auth requestURL="/km/smissive/km_smissive_main/kmSmissiveMain.do?method=view&fdId=${param.fdId}" requestMethod="GET">
				<ui:button text="${lfn:message('km-smissive:smissive.button.change.view') }" order="2" 
			        onclick="Com_OpenWindow('kmSmissiveMain.do?method=view&fdId=${param.fdId}&isShowImg=${isShowImg}','_self');">
				</ui:button>
			</kmss:auth>
		   <%} %>
		  </c:otherwise>
		</c:choose>
		<%} %>
		<c:if test="${kmSmissiveMainForm.docStatus!='10'}"> 
		<kmss:auth
			requestURL="/km/smissive/km_smissive_main/kmSmissiveMain.do?method=printContent&fdId=${param.fdId}"
			requestMethod="GET">
			<ui:button text="${lfn:message('km-smissive:kmSmissive.button.print') }" order="4" onclick="Com_OpenWindow('kmSmissiveMain.do?method=print&fdId=${param.fdId}','_blank');">
			</ui:button>
		</kmss:auth>
		</c:if>
		<c:if test="${kmSmissiveMainForm.docStatusFirstDigit > '0' }">
			<kmss:auth requestURL="/km/smissive/km_smissive_main/kmSmissiveMain.do?method=edit&fdId=${param.fdId}" requestMethod="GET">
				<ui:button text="${lfn:message('button.edit') }" order="4" 
			        onclick="Com_OpenWindow('kmSmissiveMain.do?method=edit&fdId=${param.fdId}','_self');">
				</ui:button>
			</kmss:auth>
		</c:if>
		<%--
		<kmss:auth requestURL="/km/smissive/km_smissive_main/kmSmissiveMain.do?method=edit&forward=modifyAttRight&fdId=${param.fdId}" requestMethod="GET">
		    <ui:button text="${lfn:message('km-smissive:smissive.button.attright') }" order="4" 
		        onclick="fn_dialog('${LUI_ContextPath }/km/smissive/km_smissive_main/kmSmissiveMain.do?method=edit&forward=modifyAttRight&fdId=${param.fdId}');">
			</ui:button>
		</kmss:auth>
		<kmss:auth requestURL="/km/smissive/km_smissive_main/kmSmissiveMain.do?method=edit&forward=modifyRight&fdId=${param.fdId}" requestMethod="GET">
		    <ui:button text="${lfn:message('km-smissive:smissive.button.changeright') }" order="4" 
		        onclick="fn_dialog('${LUI_ContextPath }/km/smissive/km_smissive_main/kmSmissiveMain.do?method=edit&forward=modifyRight&fdId=${param.fdId}');">
			</ui:button>
		</kmss:auth>
		--%>
		<kmss:auth requestURL="/km/smissive/km_smissive_main/kmSmissiveMain.do?method=edit&forward=modifyIssuer&fdId=${param.fdId}" requestMethod="GET">
		    <ui:button text="${lfn:message('km-smissive:smissive.button.changeissuer') }" order="4" 
		        onclick="fn_dialog('${LUI_ContextPath }/km/smissive/km_smissive_main/kmSmissiveMain.do?method=edit&forward=modifyIssuer&fdId=${param.fdId}');">
			</ui:button>
		</kmss:auth>
		<c:if test="${kmSmissiveMainForm.docStatus =='20' }">
			<kmss:auth requestURL="/km/smissive/km_smissive_main/kmSmissiveMain.do?method=edit&fdId=${param.fdId}" requestMethod="GET">
					<!--用于标识显示附件编辑还是查看页面 -->
					<c:set var="editStatus" value="true"/>
			</kmss:auth>
			<c:if  test="${kmSmissiveMainForm.sysWfBusinessForm.fdNodeAdditionalInfo.editDocContent =='true'}">
					<c:set var="editStatus" value="true"/>
			</c:if>
			<c:if  test="${kmSmissiveMainForm.sysWfBusinessForm.fdNodeAdditionalInfo.modifyDocNum =='true'}">
					<c:set var="editStatus" value="true"/>
			</c:if>
		</c:if>
		<kmss:auth requestURL="/km/smissive/km_smissive_main/kmSmissiveMain.do?method=delete&fdId=${param.fdId}" requestMethod="GET">
		     <ui:button text="${lfn:message('button.delete') }" order="4" 
			        onclick="Delete();">
			 </ui:button>
		</kmss:auth>
	
		<ui:button text="${ lfn:message('button.close') }" order="5"  onclick="Com_CloseWindow()">
	    </ui:button>
		</ui:toolbar>
	</template:replace>
	<template:replace name="path">
			<ui:combin ref="menu.path.simplecategory">
				<ui:varParams 
					moduleTitle="${ lfn:message('km-smissive:table.kmSmissiveMain') }" 
					modulePath="/km/smissive/" 
					modelName="com.landray.kmss.km.smissive.model.KmSmissiveTemplate" 
					autoFetch="false"
					href="/km/smissive/" 
					categoryId="${kmSmissiveMainForm.fdTemplateId}" />
			</ui:combin>
	</template:replace>
	<template:replace name="content"> 
	<script>
	seajs.use(['sys/ui/js/dialog'], function(dialog) {
		window.dialog=dialog;
	});
	function Delete(){
    	dialog.confirm("${lfn:message('page.comfirmDelete')}",function(flag){
	    	if(flag==true){
	    		Com_OpenWindow('kmSmissiveMain.do?method=delete&fdId=${param.fdId}','_self');
	    	}else{
	    		return false;
		    }
	    },"warn");
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
	//max_window();

	//解决非ie下控件高度问题
	window.onload = function(){
		var obj = document.getElementById("JGWebOffice_mainOnline");
		if(obj){
			obj.setAttribute("height", 550);
		}
	};
</script>
<p class="txttitle">${kmSmissiveMainForm.fdTitle}</p>
<div class="lui_form_content_frame" style="padding-top:10px">
		<table class="tb_normal" width="100%">
		  <!--   提示信息 -->
		  <%if(com.landray.kmss.sys.attachment.util.JgWebOffice.isJGEnabled()&&JgWebOffice.isExistFile(request)){%>
			   <c:if test="${isShowImg&&kmSmissiveMainForm.docStatus!='20'}">
			   <tr>
			        <td class="td_normal_title" width=15%>
						<bean:message  bundle="km-smissive" key="kmSmissiveMain.prompt.title"/>
					</td>
			     	<td colspan="3">
			     	  <font style="text-align:center"><bean:message  bundle="km-smissive" key="kmSmissiveMain.prompt"/></font>
			        </td>
			      </tr>
			  </c:if>
		  <%} %>
			  <tr>
				<td colspan="4">
					<div id="missiveButtonDiv" style="text-align:right;padding-bottom:5px">&nbsp;
				    </div>
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
				<c:param name="buttonDiv" value="missiveButtonDiv" />
				<c:param name="isToImg" value="false"/>
			</c:import>
		</c:if> 
		<c:if test="${editStatus != true}">
			<%
				// 金格启用模式
					if (com.landray.kmss.sys.attachment.util.JgWebOffice
							.isJGEnabled()) {
						pageContext.setAttribute("sysAttMainUrl","/sys/attachment/sys_att_main/jg/sysAttMain_include_viewHtml.jsp");
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
				<c:param name="buttonDiv" value="missiveButtonDiv" />
				<c:param name="isExpand" value="true" />
				<c:param name="bookMarks" value="docSubject:${kmSmissiveMainForm.docSubject},docAuthorName:${kmSmissiveMainForm.docAuthorName},fdUrgency:${kmSmissiveMainForm.fdUrgencyName},fdTemplateName:${kmSmissiveMainForm.fdTemplateName},docCreateTime:${kmSmissiveMainForm.docCreateTime},fdSecret:${kmSmissiveMainForm.fdSecretName},fdFileNo:${kmSmissiveMainForm.fdFileNo},fdMainDeptName:${kmSmissiveMainForm.fdMainDeptName},fdSendDeptNames:${kmSmissiveMainForm.fdSendDeptNames},fdCopyDeptNames:${kmSmissiveMainForm.fdCopyDeptNames},fdIssuerName:${kmSmissiveMainForm.fdIssuerName},docCreatorName:${kmSmissiveMainForm.docCreatorName}" />
			</c:import>
		</c:if>
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
	</div>
	<ui:tabpage expand="false">
	<ui:content title="${lfn:message('km-smissive:kmSmissiveMain.label.baseinfo')}">
	  <table class="tb_normal" width=100%>
	  <tr>
			<td class="td_normal_title" width=15%>
				<bean:message  bundle="km-smissive" key="kmSmissiveMain.docSubject"/>
			</td><td width=85% colspan="3">
			  <c:out value="${kmSmissiveMainForm.docSubject }"></c:out>
			</td>
		</tr>
		<tr>
			<td class="td_normal_title" width=15%>
				<bean:message  bundle="km-smissive" key="kmSmissiveMain.docAuthorId"/>
			</td><td width=35%>
			  <c:out value="${kmSmissiveMainForm.docAuthorName }"></c:out>
			</td>
			<td class="td_normal_title" width=15%>
				<bean:message  bundle="km-smissive" key="kmSmissiveMain.docCreateTime"/>
			</td><td width=35%>
			  <c:out value="${kmSmissiveMainForm.docCreateTime }"></c:out>
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
			  <c:out value="${kmSmissiveMainForm.fdTemplateName }"></c:out>
			</td>
			<td class="td_normal_title" width=15%>
				<bean:message  bundle="km-smissive" key="kmSmissiveMain.fdFileNo"/>
			</td><td width=35%>
			<c:choose>
			  <c:when test="${kmSmissiveMainForm.sysWfBusinessForm.fdNodeAdditionalInfo.modifyDocNum =='true'}">
			     <input type="hidden"  name="fdFileNo" value="${kmSmissiveMainForm.fdFileNo}"/>
				<span id="fileNo"></span>
			  </c:when>
			  <c:otherwise>
			     <c:out value="${kmSmissiveMainForm.fdFileNo}" />
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
			   <c:out value="${kmSmissiveMainForm.docPropertyNames }"></c:out>
			</td>
		</tr>
		<tr>
			<td class="td_normal_title" width=15%>
				<bean:message  bundle="km-smissive" key="kmSmissiveMain.fdMainDeptId"/>
			</td><td width=35%>
			  <c:out value="${kmSmissiveMainForm.fdMainDeptName }"></c:out>
			</td>
			<td class="td_normal_title" width=15%>
				<bean:message  bundle="km-smissive" key="kmSmissiveMain.docDeptId"/>
			</td><td width=35%>
			  <c:out value="${kmSmissiveMainForm.docDeptName }"></c:out>
			</td>
		</tr>
		<tr>
			<td class="td_normal_title" width=15%>
				<bean:message  bundle="km-smissive" key="kmSmissiveMain.fdSendDeptId"/>
			</td><td  width=35%>
			   <c:out value="${kmSmissiveMainForm.fdSendDeptNames }"></c:out>
			</td>
			<td class="td_normal_title" width=15%>
				<bean:message  bundle="km-smissive" key="kmSmissiveMain.fdCopyDeptId"/>
			</td><td  width=35%>
			  <c:out value="${kmSmissiveMainForm.fdCopyDeptNames }"></c:out>
			</td>
		</tr>
		<tr>
			<td class="td_normal_title" width=15%>
				<bean:message  bundle="km-smissive" key="kmSmissiveMain.fdIssuerId"/>
			</td><td width=35%>
			 <c:out value="${kmSmissiveMainForm.fdIssuerName }"></c:out>
			</td>
			<td class="td_normal_title" width=15%>
				<bean:message  bundle="km-smissive" key="kmSmissiveMain.docCreatorId"/>
			</td><td width=35%>
			  <c:out value="${kmSmissiveMainForm.docCreatorName }"></c:out>
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
	</ui:content>
		<c:choose>
	 <c:when test="${kmSmissiveMainForm.docStatus != '30' || (kmSmissiveMainForm.docStatus == '30' && kmSmissiveMainForm.fdFlowFlag == 'false')}">
		<%-- 流程机制 --%>
		<%-- 以下代码为嵌入流程模板标签的代码 --%>
		<c:import url="/sys/workflow/import/sysWfProcess_view.jsp"
			charEncoding="UTF-8">
			<c:param name="formName" value="kmSmissiveMainForm" />
			<c:param name="fdKey" value="smissiveDoc" />
		</c:import>
		<%-- 以上代码为嵌入流程模板标签的代码 --%>
	 </c:when>
	 <c:otherwise>
	    <kmss:auth requestURL="/km/smissive/km_smissive_main/kmSmissiveMain.do?method=viewWfLog&fdId=${param.fdId}">
		<c:import url="/sys/workflow/import/sysWfProcess_view.jsp"
			charEncoding="UTF-8">
			<c:param name="formName" value="kmSmissiveMainForm" />
			<c:param name="fdKey" value="smissiveDoc" />
		</c:import>
		</kmss:auth>
	  </c:otherwise>
	</c:choose>
	<%--以下代码为嵌入阅读机制--%>
	<c:import url="/sys/readlog/import/sysReadLog_view.jsp"
		charEncoding="UTF-8">
		<c:param name="formName" value="kmSmissiveMainForm" />
	</c:import>
	<%--以上代码为嵌入阅读机制--%>
	<c:import
		url="/sys/circulation/import/sysCirculationMain_view.jsp"
		charEncoding="UTF-8">
		<c:param
			name="formName"
			value="kmSmissiveMainForm" />
	</c:import>
	<%--发布机制开始--%>
	<c:import
		url="/sys/news/import/sysNewsPublishMain_view.jsp"
		charEncoding="UTF-8">
		<c:param name="formName" value="kmSmissiveMainForm" />
	</c:import>
	<%--发布机制结束--%>
	<c:import url="/sys/right/import/right_view.jsp" charEncoding="UTF-8">
		<c:param name="formName" value="kmSmissiveMainForm" />
		<c:param name="moduleModelName" value="com.landray.kmss.km.smissive.model.KmSmissiveMain" />
	</c:import>

		<%--以下代码为嵌入收藏机制--%>
	<c:import url="/sys/bookmark/import/bookmark_bar.jsp"
		charEncoding="UTF-8">
		<c:param name="fdSubject" value="${kmSmissiveMainForm.docSubject}" />
		<c:param name="fdModelId" value="${kmSmissiveMainForm.fdId}" />
		<c:param name="fdModelName"
			value="com.landray.kmss.km.smissive.model.KmSmissiveMain" />
	</c:import>
	<%--以上代码为嵌入收藏机制--%>
	<kmss:ifModuleExist path="/tools/datatransfer/">
		<c:import
			url="/tools/datatransfer/import/toolsDatatransfer_old_data.jsp"
			charEncoding="UTF-8">
			<c:param
				name="fdModelId"
				value="${kmSmissiveMainForm.fdId}" />
			<c:param 
				name="fdModelName"
				value="com.landray.kmss.km.smissive.model.KmSmissiveMain" />
		</c:import>
	</kmss:ifModuleExist>
</ui:tabpage>
<script>

   function generateFileNum(){
	   var docNum = document.getElementsByName("fdFileNo")[0];
	    var url="${KMSS_Parameter_ContextPath}km/smissive/km_smissive_main/kmSmissiveMain.do?method=generateNum"; 
		 $.ajax({     
   	     type:"post",     
   	     url:url,     
   	     data:{fdDocNum:docNum.value,fdId:"${kmSmissiveMainForm.fdId}"},    
   	     async:false,    //用同步方式 
   	     success:function(data){
   	 	    var results =  eval("("+data+")");
   		    if(results['docNum']!=null){
   		   	   docNum.value = results['docNum'];
   		       //填充控件中的文号书签 
   		       Attachment_ObjectInfo['mainOnline'].setBookmark('fdFileNo',document.getElementsByName("fdFileNo")[0].value);
   			}
   		}    
       });
	}
<c:if  test="${kmSmissiveMainForm.sysWfBusinessForm.fdNodeAdditionalInfo.modifyDocNum =='true'}">
Com_Parameter.event["submit"].push(function(){
		//操作类型为通过类型 ，才写回编号 
		if(lbpm.globals.getCurrentOperation().operation['isPassType'] == true){			
		    var docNum = document.getElementsByName("fdFileNo")[0];
		    var flag = false;
		    var results;
		    if(""==docNum.value){
	    	generateFileNum();
	    	 var url="${KMSS_Parameter_ContextPath}km/smissive/km_smissive_main/kmSmissiveMain.do?method=saveDocNum"; 
	    	 $.ajax({     
	    	     type:"post",     
	    	     url:url,     
	    	     data:{fdDocNum:docNum.value,fdId:"${kmSmissiveMainForm.fdId}"},    
	    	     async:false,    //用同步方式 
	    	     success:function(data){
	    	    	 results =  eval("("+data+")");
	    	    	 if(results['flag']=="true"){
	    	    		 flag = true;
	    	    	 }
			    }     
	          });
	    	 if(results['flag']=="false"){
			        alert("生成文档编号不成功");
			        return false;
			    }else{
		    	    return flag;
			    }   	  
		     }else{
				return true;
		    }
		}else{
			return true;
		}
});
 </c:if>
</script>
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
</template:replace>
	<template:replace name="nav">
	<%--关联机制 --%>
		<c:import url="/sys/relation/import/sysRelationMain_view.jsp" charEncoding="UTF-8">
			<c:param name="formName" value="kmSmissiveMainForm" />
		</c:import> 
	<!-- 关联机制 -->
	</template:replace>
</template:include>

