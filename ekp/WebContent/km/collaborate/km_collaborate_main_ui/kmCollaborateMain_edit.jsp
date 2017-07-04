<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<template:include ref="default.edit" sidebar="no">
	<%--标签页标题--%>
	<template:replace name="title">
		<c:choose>
			<c:when test="${ kmCollaborateMainForm.method_GET == 'add' }">
				<c:out value="${lfn:message('km-collaborate:kmcollaborateMain.create')} - ${ lfn:message('km-collaborate:table.kmCollaborateMainTitle') } "></c:out>	
			</c:when>
			<c:otherwise>
				<c:out value="${kmCollaborateMainForm.docSubject} - ${ lfn:message('km-collaborate:table.kmCollaborateMainTitle') }"></c:out>
			</c:otherwise>
		</c:choose>
	</template:replace>
	
	<%--操作按钮--%>
	<template:replace name="toolbar">
		<ui:toolbar id="toolbar" layout="sys.ui.toolbar.float">
		      	<%--add页面的按钮--%>
		     	 	<c:if test="${kmCollaborateMainForm.method_GET=='add'}">
						 	 <ui:button text="${lfn:message('button.savedraft') }" order="2" onclick="Com_Submit(document.kmCollaborateMainForm, 'saveDraft');"></ui:button>
					      	 <ui:button text="${lfn:message('button.submit') }" order="2" onclick="checkIfMore('save');"></ui:button>
					 </c:if>
				<%--edit页面的按钮--%>
					<c:if test="${kmCollaborateMainForm.method_GET=='edit'}">
							<ui:button text="${lfn:message('button.savedraft') }" order="2" onclick="Com_Submit(document.kmCollaborateMainForm, 'updateDraft');"></ui:button>
							<ui:button text="${lfn:message('button.submit') }" order="2" onclick="checkIfMore('update');"></ui:button>
				   </c:if>
			   <%--editCotent显示按钮--%>
				   <c:if test="${kmCollaborateMainForm.method_GET=='editContent'}">
					     <ui:button text="${lfn:message('button.save')}" onclick="Com_Submit(document.kmCollaborateMainForm, 'updateContent');"></ui:button> 
					</c:if>
				<%--关闭--%>
			 <ui:button text="${lfn:message('button.close')}" order="5" onclick="Com_CloseWindow();">
			</ui:button>
		</ui:toolbar>
	</template:replace>

	<%--导航路径--%>
	<template:replace name="path">
		<ui:menu layout="sys.ui.menu.nav" style="height:40px;line-height:40px;" id="pathNav">
			<ui:menu-item text="${ lfn:message('home.home') }" icon="lui_icon_s_home" >
			</ui:menu-item>
			<ui:menu-item text="${ lfn:message('km-collaborate:table.kmCollaborateMainTitle') }">
			</ui:menu-item>
			<c:if test="${not empty kmCollaborateMainForm.fdCategoryId}">
			    <ui:menu-source autoFetch="false">
					 <ui:source type="AjaxJson">
						{"url":"/km/collaborate/km_collaborate_category/kmCollaborateCategory.do?method=getCategoryNavPath&cateId=${kmCollaborateMainForm.fdCategoryId}"} 
					</ui:source>
			    </ui:menu-source>
			 </c:if>
		</ui:menu>
	</template:replace>	
	
	
	<%--工作沟通--%>
	<template:replace name="content"> 
		<script type="text/javascript">
	       Com_IncludeFile("docutil.js|optbar.js|validator.jsp|validation.js|plugin.js|validation.jsp|xform.js", null, "js");
		   Com_IncludeFile("jquery.js");
		   Com_IncludeFile("dialog.js");
		</script>
		
		<script>
			$(function(){
				//是否催办
                var fdIsRender="${kmCollaborateMainForm.fdIsReminders}";
				var todoD = document.getElementById("todoDays");
				if(fdIsRender=="true"){
					todoD.style.display = "";
				}
				   
				$("#fdNotifyType").hide();
				$("#participantIds").hide();
				// name会发生改变
				$("input[name^='__notify_type_']").click(function() {
					checkNotifyType();
				});
				$("#partnerInfos").click(function(){
					checkParticipantIds();
				});
			});
		</script>
		<script>
		  function checkIfMore(method){
		   var participantIds=document.getElementsByName("participantIds")[0];
		   var url="${KMSS_Parameter_ContextPath}km/collaborate/km_collaborate_main/kmCollaborateMain.do?method=checkIfMore"; 
		   $.ajax({     
			     type:"post",     
			     url:url,     
			     data:{type:"check",personIds:participantIds.value},    
			     async:true,     
			     success:function(data){ 
			    	 if(data.indexOf("true")>-1){		    		 
			      		  alert("<bean:message key='kmCollaborate.jsp.morethan.comNum' bundle='km-collaborate' />");
			      		  return false;
			      	  } else{
			      		Com_Submit(document.kmCollaborateMainForm, method);
			      	  }   
				   }     
		      });			 
		};
			  
		 //  $KMSSValidation();
		    Com_Parameter.event["submit"][Com_Parameter.event["submit"].length] = function() {
		    		if(validator_km())
		    			 return true ;
		    		else 
		    			return false ;
		    	  
		    	}
			function doReminderOp(el){
				var todoD = document.getElementById("todoDays");
				if(el.value=="true"){
					todoD.style.display = "";
				}else{
					var fdDay = document.getElementsByName("fdRemindersDay")[0];
					document.getElementsByName("fdRemindersDay")[0].value= document.getElementsByName("fdRemindersDay")[0].value=="" ? document.getElementsByName("fdRemindersDay_hidden")[0].value:document.getElementsByName("fdRemindersDay")[0].value;
					var advice = $KMSSValidation_GetAdvice(fdDay);
					if (advice) advice.style.display = "none";
					todoD.style.display = "none";
				}
			}
			//验证
			function validator_km(){
		     var method="${param.method}";
		     //editContent不能选择通知方式，故不验证
		     var r1;
		     if(method=="editContent"){
			     r1=true;
		     }else{
		    	 r1=checkNotifyType();
		     }
				var r2=checkParticipantIds();
				return r1&&r2;
			}
			//通知方式
			function checkNotifyType() {
				var fdNotifyType = document.getElementsByName("fdNotifyType")[0].value;
				//提示【通知方式不能为空】
				if(null == fdNotifyType || fdNotifyType==""){
					$("#fdNotifyType").show();
					$("input[type='checkbox']").focus();
					return false;
				}else{
					$("#fdNotifyType").hide();
					return true;
				}
			}
			
			function checkParticipantIds() {
				var participantIdsDoc = document.getElementsByName("participantIds")[0];
				//如果是editCntent则不验证
				if(!participantIdsDoc){
					return true;
				}
				var participantIds=participantIdsDoc.value;
				if(null == participantIds || participantIds==""){
					$("#participantNames").focus();
					$("#participantIds").show();
					return false;
				}else{
					$("#participantIds").hide();
					return true;
				}
			}
		</script>
		
		<html:form action="/km/collaborate/km_collaborate_main/kmCollaborateMain.do">
	 	 <div class="lui_form_content_frame" style="padding-top:20px">		
						<table class="tb_simple" width=100%>
								<tr>
								   <!-- 主题 -->
									<td class="td_normal_title" width=12%><bean:message bundle="km-collaborate" key="kmCollaborateMain.docSubject"/></td>
									<td colspan="3">
										<xform:text property="docSubject" style="width:85%" showStatus="edit"/>
									<!-- 高优先级-->
										<xform:checkbox property="fdIsPriority"  dataType="boolean" showStatus="edit">
							   				<xform:simpleDataSource value="true"><bean:message bundle="km-collaborate" key="kmCollaborateMain.highPriority"/></xform:simpleDataSource>
							 			</xform:checkbox>
									</td>
								</tr>
								<tr>
								     <!-- 沟通类型-->
								    <td class="td_normal_title" width=12%><bean:message bundle="km-collaborate" key="kmCollaborateMain.fdCategory"/></td>
									<td  colspan=3>
										<xform:select property="fdCategoryId" validators="required" subject="${lfn:message('km-collaborate:kmCollaborateMain.fdCategory')}" showStatus="edit" isLoadDataDict="false">
											<xform:beanDataSource serviceBean="kmCollaborateCategoryService" selectBlock="fdId,fdName" whereBlock="fdDeleted = true" orderBy="fdOrder,fdName"/>
										</xform:select><span class="txtstrong">*</span>
									</td> 
								</tr>
							    <html:hidden property="fdId" />	
							    	   <!--来源链接-->
								<c:if test="${not empty kmCollaborateMainForm.fdSourceUrl}">
								<tr>
								     <td class="td_normal_title" width="12%">
										<bean:message bundle="km-collaborate" key="kmCollaborateMain.fdSource" />
									</td>
								    <td colspan="3">
								      <html:hidden property="fdModelId" />
									  <html:hidden property="fdModelName" />
									  <html:hidden property="fdKey" />
								      <html:hidden property="fdSourceUrl" />
							          <html:hidden property="fdSourceSubject" />
										 <a href="<c:url value="${kmCollaborateMainForm.fdSourceUrl}"/>" target="_blank">${kmCollaborateMainForm.fdSourceSubject}</a>
								   </td>
								</tr>
								</c:if>
								
								<tr >
								    <!-- 内容-->
									<td class="td_normal_title" width=12%><bean:message bundle="km-collaborate" key="kmCollaborateMain.fdContent"/></td>
									<td colspan="3" >
                                            <kmss:editor property="fdContent" width="97%"></kmss:editor>	 
									</td>
								</tr>
								<tr>
							    	<!-- 附件-->
								    <td class="td_normal_title" width=12%><bean:message bundle="km-collaborate" key="kmCollaborateMain.related.attachment"/></td>
									<td  colspan="3">
									    <c:import  url="/sys/attachment/sys_att_main/sysAttMain_edit.jsp"  charEncoding="UTF-8" >
									        <c:param name="fdKey" value="attachment"/>
									   </c:import>
									</td>
								</tr>
								<tr>
							<c:if test="${kmCollaborateMainForm.method_GET!='editContent'}">	 
								    <!-- 参与者,add,edit页面-->
									<td class="td_normal_title" width=12%><bean:message bundle="km-collaborate" key="kmCollaborateMain.participant"/></td>
									<td colspan=3>
								    	 <xform:address isLoadDataDict="false" required="true" subject="${lfn:message('km-collaborate:kmCollaborateMain.participant')}"  style="width:97%" mulSelect="true" propertyId="participantIds" propertyName="participantNames" orgType='ORG_TYPE_ALL' textarea="true"></xform:address>
									</td>
								</c:if>	
								<c:if test="${kmCollaborateMainForm.method_GET=='editContent'}">	 
										 <!-- 参与者,editContent页面-->
										<td class="td_normal_title" width=12%>
											<bean:message bundle="km-collaborate" key="kmCollaborateMain.participant"/>
										</td>
										<td colspan=3>
											<xform:address propertyId="participantIds" propertyName="participantNames" mulSelect="true" orgType="ORG_TYPE_ALL" textarea="true" style="width:85%" />
										</td>
									</c:if>
								</tr>
						    <!-- 通知方式-->
							<c:if test="${kmCollaborateMainForm.method_GET!='editContent'}">	 
								<tr>
									<td class="td_normal_title" width=12%><bean:message bundle="km-collaborate" key="kmCollaborateMain.fdNotifyType"/></td>
									<td colspan="3">
										<kmss:editNotifyType property="fdNotifyType"/>
										<div class="notNull" id="fdNotifyType" style="display:none;padding-left:10px;border:solid #DFA387 1px;padding-top:8px;padding-bottom:8px;background:#FFF6D9;color:#C30409;margin-top:3px">×&nbsp;&nbsp;&nbsp;<bean:message bundle="km-collaborate" key="kmCollaborateMain.choose.notifytype"/></div>
									</td>
								</tr>
							  </c:if>
							  	<c:if test="${kmCollaborateMainForm.method_GET=='editContent'}">	 
							 	  <tr>
											<td class="td_normal_title" width=12%><bean:message bundle="km-collaborate" key="kmCollaborateMain.fdNotifyType"/></td>
											<td  colspan="3" >
												<sunbor:enumsShow enumsType="sys_notify_fdNotifyType" value="${kmCollaborateMainForm.fdNotifyType}"></sunbor:enumsShow>
											</td>
									</tr>
							  	</c:if>
							  	
						 <c:if test="${kmCollaborateMainForm.method_GET!='editContent'}">	 	  	
								<tr>
									<td class="td_normal_title" width=12%><bean:message bundle="km-collaborate" key="kmCollaborateMain.fdIsReminders"/></td>
									<!-- 是否催办-->
									<td  colspan="3">
										<xform:radio property="fdIsReminders" onValueChange="doReminderOp(this);" showStatus="edit" value="${kmCollaborateMainForm.fdIsReminders!=null ? kmCollaborateMainForm.fdIsReminders : 'false' }" >
											<xform:enumsDataSource enumsType="common_yesno" />
										</xform:radio>
							             &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
										<span id="todoDays" class="txtstrong" <c:if test="${!kmCollaborateMainForm.fdIsReminders}">style="display:none"</c:if>>
											<input type="hidden" value="${fdRemindersDay}" name="fdRemindersDay_hidden" id="fdRemindersDay_hidden"/> 
											(<xform:text property="fdRemindersDay" style="width:20px" required="true"  validators="min(0)" />
											<bean:message bundle="km-collaborate" key="kmCollaborateMain.fdReceiveHint" />)
										</span>
									</td>
								</tr>
							</c:if> 
							 <c:if test="${kmCollaborateMainForm.method_GET=='editContent'}">	 	
								<tr>
										<td class="td_normal_title" width=12%><bean:message bundle="km-collaborate" key="kmCollaborateMain.fdIsReminders"/></td>
										<td colspan="3">
										<html:hidden property="fdIsReminders"/>
										<xform:select property="fdIsReminders" value="${kmCollaborateMainForm.fdIsReminders!=null ? kmCollaborateMainForm.fdIsReminders : 'false' }">
											<xform:enumsDataSource enumsType="common_yesno" />
										</xform:select>
										    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
										<span id="todoDays" class="txtstrong" <c:if test="${!kmCollaborateMainForm.fdIsReminders}">style="display:none"</c:if>>
											<input type="hidden" value="${fdRemindersDay}" name="fdRemindersDay_hidden" id="fdRemindersDay_hidden"/> 
											(<xform:text property="fdRemindersDay" style="width:20px" required="true"  validators="min(0)" />
											<bean:message bundle="km-collaborate" key="kmCollaborateMain.fdReceiveHint" />)
										</span>
										</td>
								</tr>
							</c:if>	
								<tr>
								  <!-- 参与者权限-->
									<td class="td_normal_title" width=12%><bean:message bundle="km-collaborate" key="kmCollaborateMain.fdPartnerOperating"/></td>
									<td colspan="3">
										<xform:checkbox property="fdPartnerOperating" showStatus="edit">
										    <xform:simpleDataSource value="true"><bean:message bundle="km-collaborate" key="kmCollaborateMain.allow.append.partnerInfo"/></xform:simpleDataSource>
										</xform:checkbox>&nbsp;&nbsp;&nbsp;&nbsp;
										<xform:checkbox property="fdEditAtt" showStatus="edit">
										    <xform:simpleDataSource value="true"><bean:message bundle="km-collaborate" key="kmCollaborateMain.fdEditAtt"/></xform:simpleDataSource>
										</xform:checkbox>
										<xform:checkbox property="fdIsOnlyView" showStatus="edit">
								            <xform:simpleDataSource value="true"> ${lfn:message("km-collaborate:kmCollaboratePartnerInfo.fdIsOnlyView")}</xform:simpleDataSource>
								        </xform:checkbox> 
									</td>
								</tr>
								<!-- 创建者和创建时间 -->
								<tr>
								   <td class="td_normal_title" width="12%">
								   			<bean:message bundle="km-collaborate" key="kmCollaborateMain.docCreator"/>
								   	</td>
								   <td width="35%">
								   			 <c:out value="${kmCollaborateMainForm.docCreatorName}"/>
								   			 <input type="hidden" name="docCreatorId" value="${kmCollaborateMainForm.docCreatorId}"/>
								   </td>
								    <td class="td_normal_title" width="12%">
								   			<bean:message bundle="km-collaborate" key="kmCollaborateMain.docCreateTime"/>
								   	</td>
								   <td width="35%">
								   			 <c:out value="${kmCollaborateMainForm.docCreateTime}"/>
								   </td>
								</tr>
							</table>
						</div>	
		</html:form>
		<script>
		  $KMSSValidation();
		</script>
	</template:replace>
</template:include>
