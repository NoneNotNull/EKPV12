<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/edit_top.jsp"%>
<c:if test="${kmReviewTemplateForm.fdIsExternal != 'true'}">	
    <script src="./kmReviewTemplate_edit_external.js"></script>
</c:if>
<script language="JavaScript">
	Com_IncludeFile("dialog.js");
	Com_IncludeFile("data.js");
	function refreshDisplay() {
		var fields = document.getElementsByName("fdLableVisiable");
		var tableRows = document.getElementById("Table_Info").rows;
		if(fields[0].checked) {
			tableRows[2].style.display="none";
		}
		if(fields[1].checked) {
			tableRows[2].style.display="";
		}
	}
	function XForm_Mode_Listener(key,value) {
		if (value == '1') {
			ShowRtfView(true);
		} else {
			ShowRtfView(false);
		}
	}
	function ShowRtfView(b) {
		var rtfView = document.getElementById('rtfView');
		var display = b ? '' : 'none';
		rtfView.style.display = display;
		var fdUseForm = document.getElementsByName('fdUseForm')[0];
		fdUseForm.value = (!b);
	}

	function checkPrefix(){
		<% if(com.landray.kmss.sys.number.util.NumberResourceUtil.isModuleNumberEnable("com.landray.kmss.km.review.model.KmReviewMain")){ %>
			return true;
		<%}%>
		var prefix = document.getElementsByName("fdNumberPrefix")[0].value;
		var fdId = document.getElementsByName("fdId")[0].value;
		var url = encodeURI(Com_Parameter.ResPath+"jsp/ajax.jsp?&tempId="+fdId+"&serviceName=kmReviewTemplateService&prefixStr="+prefix);
		var xmlHttpRequest;
		if (window.XMLHttpRequest) { // Non-IE browsers
	       xmlHttpRequest = new XMLHttpRequest();
	    }else if (window.ActiveXObject) { // IE   
	    	try {		  
				xmlHttpRequest = new ActiveXObject("Msxml2.XMLHTTP");
			} catch (othermicrosoft) {
				try {				
					xmlHttpRequest = new ActiveXObject("Microsoft.XMLHTTP");
				} catch (failed) {					
					xmlHttpRequest = false;
				}
			}
		}	
		if (xmlHttpRequest) {	      
	        xmlHttpRequest.open("GET", url, false);
	        xmlHttpRequest.send();	    
			var result = xmlHttpRequest.responseText.replace(/\s/g,"").replace(/;/g,"\n");
			if(trim(result)!=""){
				if(!confirm("<bean:message bundle="km-review" key="message.template.same.prefix" />".replace("%result%",result))){   
					return false;
				}
			}
		}
		return true;
	}
	//公式选择器
	function genTitleRegByFormula(fieldId, fieldName){
	//	Formula_Dialog(idField,nameField,Formula_GetVarInfoByModelName("com.landray.kmss.km.review.model.KmReviewMain"), "String");
		Formula_Dialog(fieldId, fieldName, XForm_getXFormDesignerObj_reviewMainDoc(), 'String');
	}
    
    function submitForm(method){
        var fdIsExternalValue = "${kmReviewTemplateForm.fdIsExternal}";
        var fdExternalUrl = document.getElementById('fdExternalUrl_id');
        if(fdIsExternalValue == "true"){
	         if(fdExternalUrl.value==""||fdExternalUrl.value==null){
	              alert(Data_GetResourceString("km-review:kmReviewMain.fdExternalUrl")+" "+Data_GetResourceString("km-review:kmReviewMain.notNull"));
	              return;
	          }
        }
        var fdIsExternal = document.getElementById('fdIsExternal');
        if(fdIsExternal!=null){
	        if(fdIsExternal.checked){
	              if(fdExternalUrl.value==""||fdExternalUrl.value==null){
	                   alert(Data_GetResourceString("km-review:kmReviewMain.fdExternalUrl")+" "+Data_GetResourceString("km-review:kmReviewMain.notNull"));
	                   return;
	              }
	        }
        }
    	Com_Submit(document.kmReviewTemplateForm,method);
    }

</script>
<kmss:windowTitle moduleKey="km-review:table.kmReviewMain"  subjectKey="km-review:table.kmReviewTemplate" subject="${kmReviewTemplateForm.fdName}" />
<html:form action="/km/review/km_review_template/kmReviewTemplate.do" 
	onsubmit="return validateKmReviewTemplateForm(this)&&checkPrefix();">
	<div id="optBarDiv">
		<c:if test="${kmReviewTemplateForm.method_GET=='edit'}">
			<%--更新--%>
			<input type=button value="<bean:message key="button.update"/>"
				onclick="submitForm('update');">
		</c:if>
		 <c:if test="${kmReviewTemplateForm.method_GET=='add' || kmReviewTemplateForm.method_GET=='clone'}">
		 	<%--新增--%>
			<input type=button value="<bean:message key="button.save"/>"
				onclick="submitForm('save');">
			<input type=button value="<bean:message key="button.saveadd"/>"
				onclick="submitForm('saveadd');">
		</c:if> 
			<%--关闭--%>
			<input type="button" value="<bean:message key="button.close"/>" onclick="Com_CloseWindow();">
	</div>

	<p class="txttitle">
		<bean:message bundle="km-review" key="table.kmReviewTemplate" />
	</p>

	<center>
	
	<table id="Label_Tabel" width=95%>
		<tr LKS_LabelName="<bean:message bundle='km-review' key='kmReviewTemplateLableName.templateInfo'/>">
			<td>
				<table class="tb_normal" width=100%>
					<html:hidden property="fdId" />
					<%--模板名称--%>
					<tr>
						<td class="td_normal_title" width=15%>
							<bean:message bundle="km-review" key="kmReviewTemplate.fdName" />
						</td>
						<td width=85% colspan="3">
							<html:text property="fdName" style="width:80%;" /><span class="txtstrong">*</span>
							<%--外部流程--%>
							<c:if test="${kmReviewTemplateForm.method_GET!='edit'}">
							    <xform:checkbox property="fdIsExternal" htmlElementProperties="id=fdIsExternal">
								   	<xform:simpleDataSource value="true"><bean:message bundle="km-review" key="kmReviewMain.fdIsExternal"/></xform:simpleDataSource>
								</xform:checkbox>
							</c:if>
						    <c:if test="${kmReviewTemplateForm.method_GET=='edit'}">
						        <c:if test="${kmReviewTemplateForm.fdIsExternal == 'true'}">	
								    <xform:checkbox property="fdIsExternal" htmlElementProperties="disabled=disabled">
									   	<xform:simpleDataSource value="true"><bean:message bundle="km-review" key="kmReviewMain.fdIsExternal"/></xform:simpleDataSource>
									</xform:checkbox>
								</c:if>
						    </c:if>
						</td>
					</tr>
				    <%--外部URL--%>
				    <c:if test="${kmReviewTemplateForm.fdIsExternal == 'true'}">	
				    	<tr id="fdExternalUrl">
				    </c:if>
				    <c:if test="${kmReviewTemplateForm.fdIsExternal != 'true'}">	
						<tr id="fdExternalUrl" style="display: none">
					</c:if>
						<td class="td_normal_title" width=15%>
							<bean:message bundle="km-review" key="kmReviewMain.fdExternalUrl" />
						</td>
						<td width=85% colspan="3">
							<html:textarea property="fdExternalUrl" styleId="fdExternalUrl_id" style="width:80%;height:40px" /><span class="txtstrong">*</span>
						</td>
					</tr>
					<%--适用类别--%>
					<tr>
						<td class="td_normal_title" width=15%>
							<bean:message bundle="km-review" key="kmReviewMain.fdCatoryName" />
						</td>
						<td width=85% colspan="3">
							<html:hidden property="fdCategoryId" /> 
							<html:text property="fdCategoryName" readonly="true" styleClass="inputsgl" style="width:80%;" /> <span class="txtstrong">*</span>
							&nbsp;&nbsp;&nbsp;
							<a href="#" onclick="Dialog_Category('com.landray.kmss.km.review.model.KmReviewTemplate','fdCategoryId','fdCategoryName');">
								<bean:message key="dialog.selectOther" />
							</a>
							<c:if test="${not empty noAccessCategory}">
								<script language="JavaScript">
									function closeWindows(rtnVal){
										if(rtnVal==null){
											window.close();
										}
									}
									if(!confirm("<bean:message arg0="${noAccessCategory}" key="error.noAccessCreateTemplate.alert" />")){
										window.close();
									}else{
										Dialog_Category('com.landray.kmss.km.review.model.KmReviewTemplate','fdCategoryId','fdCategoryName',null,null,null,null,closeWindows, true);
									}
								</script>
							</c:if>						
						</td>
					</tr>
					<%---辅类别modify by zhouchao--%>
					<tr>
						<td class="td_normal_title" width=15%>
							<bean:message bundle="km-review" key="table.sysCategoryProperty" />
						</td>
						<td width=85% colspan="3">
							<html:hidden property="docPropertyIds" /> 						
						 	<html:text property="docPropertyNames" readonly="true" styleClass="inputsgl" style="width:70%" /> 
						 	<a href="#" onclick="Dialog_property(true, 'docPropertyIds','docPropertyNames', ';',ORG_TYPE_PERSON);"> 
								<bean:message key="dialog.selectOther" /> 
							</a>
						</td> 
					</tr>
					<tr>
					<!-- 前缀 -->
					<% if(!com.landray.kmss.sys.number.util.NumberResourceUtil.isModuleNumberEnable("com.landray.kmss.km.review.model.KmReviewMain")){ %>
					<td class="td_normal_title" width=15%><bean:message
						bundle="km-review" key="kmReviewTemplate.fdNumberPrefix" /></td>
					
					<td width=35%><html:text property="fdNumberPrefix"
						style="width:80%;" /><span class="txtstrong">*</span></td>
					<%} %>
					<!-- 排序号 -->
					<td class="td_normal_title" width=15%><bean:message
						bundle="km-review" key="kmReviewMain.fdOrder" /></td>

					<td width=35% 
						<% if(com.landray.kmss.sys.number.util.NumberResourceUtil.isModuleNumberEnable("com.landray.kmss.km.review.model.KmReviewMain")){ %>
						colspan="3"
						<%} %>
					><html:text property="fdOrder" style="width:80%;" />
						<% if(com.landray.kmss.sys.number.util.NumberResourceUtil.isModuleNumberEnable("com.landray.kmss.km.review.model.KmReviewMain")){ %>
							<html:hidden property="fdNumberPrefix"  value="BH"/>
						<%} %>
					</td>
				</tr>
	  <c:if test="${kmReviewTemplateForm.fdIsExternal != 'true'}">				
				<!-- 实施反馈人 -->
				<tr id="fdFeedbackModify">
					<td class="td_normal_title" width=17%><bean:message
						bundle="km-review" key="table.kmReviewFeedback" /></td>
					<td width=83% colspan="3"><html:hidden property="fdFeedBackIds" /> <html:text
						property="fdFeedbackNames" style="width:50%" readonly="true"
						styleClass="inputsgl" /> <a href="#"
						onclick="Dialog_Address(true, 'fdFeedBackIds','fdFeedbackNames', ';',null);"><bean:message
						key="dialog.selectOther" /></a> &nbsp;&nbsp; <bean:message
						bundle="km-review" key="kmReviewTemplate.fdFeedbackModify" /> <sunbor:enums
						property="fdFeedbackModify" enumsType="common_yesno"
						elementType="radio" /></td>
				</tr>
				<!-- 标题自动生成规则 -->
				<tr id="number">
					<td class="td_normal_title" width=17%><bean:message
						bundle="km-review" key="kmReviewTemplate.titleRegulation" /></td>
					<td width=83% colspan="3">
						<html:hidden property="titleRegulation" />
						<html:text property="titleRegulationName" style="width:50%" readonly="true"
						styleClass="inputsgl" /> <a href="#"
						onclick="genTitleRegByFormula('titleRegulation','titleRegulationName')"><bean:message bundle="km-review" key="kmReviewTemplate.formula" /></a>
						<br/> 
						<bean:message bundle="km-review" key="kmReviewTemplate.titleRegulation.tip" />
					</td>
				</tr>
				<!-- 关键字 -->
				<tr id="fdKeywordIds">
					<td class="td_normal_title" width=17%><bean:message
						bundle="km-review" key="kmReviewKeyword.fdKeyword" /></td>
					<td width=83% colspan="3"><html:hidden property="fdKeywordIds" /> <html:text
						property="fdKeywordNames" style="width:50%;" /></td>
				</tr>
	 </c:if>			
				<%-- 所属场所 --%>
				<c:import url="/sys/authorization/sys_auth_area/sysAuthArea_field.jsp" charEncoding="UTF-8">
                     <c:param name="id" value="${kmReviewTemplateForm.authAreaId}"/>
                </c:import>
				<!-- 可使用者 -->
				<tr>
					<td class="td_normal_title" width=15%><bean:message
						bundle="km-review" key="table.kmReviewTemplateUser" /></td>
					<td  width=85% colspan="3"><html:hidden property="authReaderIds" /> <html:textarea
						property="authReaderNames" style="width:80%" readonly="true" /> <a
						href="#"
						onclick="Dialog_Address(true, 'authReaderIds','authReaderNames', ';',null);"><bean:message
						key="dialog.selectOther" /></a><br>
						<bean:message key="kmReviewTemplate.tepmlateUser" bundle="km-review"/>
				   </td>
				</tr>
				<!-- 可维护者 -->
				<tr id="authEditor">
					<td class="td_normal_title" width=15%><bean:message
						bundle="km-review" key="table.kmReviewTemplateEditor" /></td>
					<td width=85% colspan="3"><html:hidden property="authEditorIds" /> <html:textarea
						property="authEditorNames" style="width:80%" readonly="true" /> <a
						href="#"
						onclick="Dialog_Address(true, 'authEditorIds','authEditorNames', ';',null);"><bean:message
						key="dialog.selectOther" /></a><br>
						<bean:message key="kmReviewTemplate.tepmlateManager" bundle="km-review"/>
					</td>
				</tr>
				<%---新建时，不显示 创建人，创建时间 modify by zhouchao---%>
               <c:if
		         test="${kmReviewTemplateForm.method_GET=='edit'}">
				<tr>
					<!-- 创建人员 -->
					<td class="td_normal_title" width=15%><bean:message
						bundle="km-review" key="kmReviewTemplate.docCreatorId" /></td>
					
					<td width=35%><html:text property="docCreatorName"
						readonly="true" style="width:50%;" /></td>
					<!-- 创建时间 -->
					<td class="td_normal_title" width=15%><bean:message
						bundle="km-review" key="kmReviewTemplate.docCreateTime" /></td>
					<td width=35%><html:text property="docCreateTime"
						readonly="true" style="width:50%;" /></td>
				</tr>
				<c:if test="${not empty kmReviewTemplateForm.docAlterorName}">
				<tr>
					<!-- 修改人 -->
					<td class="td_normal_title" width=15%><bean:message
						bundle="km-review" key="kmReviewTemplate.docAlteror" /></td>
					<td width=35%><bean:write name="kmReviewTemplateForm"
						property="docAlterorName" /></td>
					<!-- 修改时间 -->
					<td class="td_normal_title" width=15%><bean:message
						bundle="km-review" key="kmReviewTemplate.docAlterTime" /></td>
					<td width=35%><bean:write name="kmReviewTemplateForm"
						property="docAlterTime" /></td>
				</tr>
				</c:if>
				</c:if>
			</table>
			</td>
		</tr>
  <c:if test="${kmReviewTemplateForm.fdIsExternal != 'true'}">				
		<!-- 表单 -->
		<tr LKS_LabelName="<kmss:message key="km-review:kmReviewDocumentLableName.reviewContent" />" style="display:none">
			<td>
			<c:import url="/sys/xform/include/sysFormTemplate_edit.jsp"
				charEncoding="UTF-8">
				<c:param name="formName" value="kmReviewTemplateForm" />
				<c:param name="fdKey" value="reviewMainDoc" />
				<c:param name="fdMainModelName" value="com.landray.kmss.km.review.model.KmReviewMain" />
				<c:param name="messageKey" value="km-review:kmReviewDocumentLableName.reviewContent" />
				<c:param name="useLabel" value="false" />
			</c:import>
			<table id="rtfView" class="tb_normal" width=100% style="border-top:0;">
			<tr>
				<td colspan="4" style="border-top:0;">
					<html:hidden property="fdUseForm" />
					<kmss:editor property="docContent" toolbarSet="Default" height="1000" />
				</td>
			</tr>
			</table>
			</td>
		</tr>
		
		<%----编号机制开始--%>
		<% if(com.landray.kmss.sys.number.util.NumberResourceUtil.isModuleNumberEnable("com.landray.kmss.km.review.model.KmReviewMain")){ %>
			<c:import url="/sys/number/include/sysNumberMappTemplate_edit.jsp" charEncoding="UTF-8">
				<c:param name="formName" value="kmReviewTemplateForm" />
				<c:param name="modelName" value="com.landray.kmss.km.review.model.KmReviewMain"/>
			</c:import>
		<%} %>
		<%----编号机制结束--%>
		
		<!-- 流程 -->
		<c:import url="/sys/workflow/include/sysWfTemplate_edit.jsp"
			charEncoding="UTF-8">
			<c:param name="formName" value="kmReviewTemplateForm" />
			<c:param name="fdKey" value="reviewMainDoc" />
		</c:import>

		<!-- 文档关联 -->
		<tr
			LKS_LabelName="<bean:message bundle='km-review' key='kmReviewTemplateLableName.relationInfo'/>">
			<c:set var="mainModelForm" value="${kmReviewTemplateForm}"
				scope="request" />
			<c:set
				var="currModelName"
				value="com.landray.kmss.km.review.model.KmReviewMain"
				scope="request" />
			<td><%@ include
				file="/sys/relation/include/sysRelationMain_edit.jsp"%></td>
		</tr>
		<tr LKS_LabelName="<bean:message bundle="sys-right" key="right.moduleName" />">
			<td>
				<table class="tb_normal" width=100%>
					<c:import url="/sys/right/tmp_right_edit.jsp" charEncoding="UTF-8">
						<c:param
							name="formName"
							value="kmReviewTemplateForm" />
						<c:param
							name="moduleModelName"
							value="com.landray.kmss.km.review.model.KmReviewTemplate" />
					</c:import>
				</table>
			</td>
		</tr>
		
		<%--
		<!--提醒机制(分类) 开始-->
		<tr LKS_LabelName="<bean:message bundle="sys-notify" key="sysNotify.remind.calendar" />">
		  <td>
			  <table class="tb_normal" width=100%>
				 <c:import url="/sys/notify/include/sysNotifyRemindCategory_edit.jsp"	charEncoding="UTF-8">
					<c:param name="formName" value="kmReviewTemplateForm" />
					<c:param name="fdKey" value="reviewMainDoc" />
					<c:param name="fdPrefix" value="sysNotifyRemindCategory_edit" />
				</c:import>
			  </table>
		  </td>
		</tr>
		<!--提醒机制(分类) 结束-->
		--%>
		
		
		<%--日程机制(普通模块) 开始
		<tr LKS_LabelName="<bean:message bundle="sys-agenda" key="module.sys.agenda" />">
		  <td>
			  <table class="tb_normal" width=100%>
				 <c:import url="/sys/agenda/include/sysAgendaCategory_general_edit.jsp"	charEncoding="UTF-8">
					<c:param name="formName" value="kmReviewTemplateForm" />
					<c:param name="fdKey" value="reviewMainDoc" />
					<c:param name="fdPrefix" value="sysAgendaCategory_general_edit" />
				</c:import>
			  </table>
		  </td>
		</tr>--%>
		
		
		<%--日程机制(表单模块) 开始--%>
		<tr LKS_LabelName="<bean:message bundle="sys-agenda" key="module.sys.agenda.syn" />">
		  <td>
		  	<table class="tb_normal" width=100%>
		  		<%--同步时机 --%>
				<tr>
					<td width="15%">
						<bean:message bundle="sys-agenda" key="module.sys.agenda.syn.time" />
					</td>
					<td width="85%" colspan="3">
						<xform:radio property="syncDataToCalendarTime"  showStatus="edit">
							<xform:enumsDataSource enumsType="kmReviewMain_syncDataToCalendarTime" />
						</xform:radio>
					</td>
				</tr>
				<tr>
					<td colspan="4" style="padding: 0px;">
						 <c:import url="/sys/agenda/include/sysAgendaCategory_formula_edit.jsp"	charEncoding="UTF-8">
							<c:param name="formName" value="kmReviewTemplateForm" />
							<c:param name="fdKey" value="reviewMainDoc" />
							<c:param name="fdPrefix" value="sysAgendaCategory_formula_edit" />
							<c:param name="fdMainModelName" value="com.landray.kmss.km.review.model.KmReviewMain" />
							<%--可选字段 1.syncTimeProperty:同步时机字段； 2.noSyncTimeValues:当syncTimeProperty为此值时，隐藏同步机制 --%>
							<c:param name="syncTimeProperty" value="syncDataToCalendarTime" />
							<c:param name="noSyncTimeValues" value="noSync" />
						</c:import>
					</td>
				</tr>
			</table>
		  </td>
		</tr>
		<!--日程机制(表单模块) 结束-->
	</c:if>	
	</table>
	</center>
	<html:hidden property="method_GET" />
</html:form>
<script language="JavaScript">Com_IncludeFile("calendar.js");</script>
<html:javascript formName="kmReviewTemplateForm" cdata="false"
	dynamicJavascript="true" staticJavascript="false" />
<%@ include file="/resource/jsp/edit_down.jsp"%>
