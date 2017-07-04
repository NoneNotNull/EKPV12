<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<template:include ref="default.edit" sidebar="no" >
	<template:replace name="title">
		<c:choose>
			<c:when test="${ kmImeetingMainForm.method_GET == 'add' }">
				<c:out value="${ lfn:message('km-imeeting:kmImeetingMain.opt.change') } - ${ lfn:message('km-imeeting:module.km.imeeting') }"></c:out>	
			</c:when>
			<c:otherwise>
				<c:out value="${kmImeetingMainForm.fdName} - ${ lfn:message('km-imeeting:module.km.imeeting') }"></c:out>
			</c:otherwise>
		</c:choose>
	</template:replace>
	
	<template:replace name="toolbar">
		<ui:toolbar id="toolbar" layout="sys.ui.toolbar.float"> 
			<c:if test="${kmImeetingMainForm.fdChangeMeetingFlag=='true'}">
			    <ui:button text="提交变更" order="2" onclick="commitMethod('update', 'false','true');">
				</ui:button> 
			</c:if>
			<c:if test="${kmImeetingMainForm.fdChangeMeetingFlag=='false'}">
				<c:if test="${kmImeetingMainForm.docStatus=='10'}">
					 <ui:button text="${lfn:message('button.savedraft') }" order="2" onclick="commitMethod('update', 'true');">
					 </ui:button>
					 <ui:button text="${lfn:message('button.submit') }" order="2" onclick="commitMethod('update', 'false');">
					 </ui:button>
				</c:if>
				<c:if test="${kmImeetingMainForm.docStatus=='11'}">
				 	<ui:button text="${lfn:message('button.submit') }" order="2" onclick="commitMethod('update', 'false');">
					 </ui:button>
				</c:if>
				<c:if test="${kmImeetingMainForm.docStatus=='20'}">
					<ui:button text="${lfn:message('button.submit') }" order="2" onclick="commitMethod('update', 'false');">
				 	</ui:button>
				</c:if>
				<c:if test="${kmImeetingMainForm.docStatus>='30'}">
					<ui:button text="${lfn:message('button.submit') }" order="2" onclick="commitMethod('update', 'false');">
				 	</ui:button>
				</c:if>				
			</c:if> 
			<ui:button text="${ lfn:message('button.close') }" order="5"  onclick="Com_CloseWindow()">
			</ui:button>
		</ui:toolbar>
	</template:replace>
	
	<template:replace name="path">
		<ui:menu layout="sys.ui.menu.nav"  id="categoryId"> 
			<ui:menu-item text="${ lfn:message('home.home') }" icon="lui_icon_s_home"></ui:menu-item>
			<ui:menu-item text="${ lfn:message('km-imeeting:module.km.imeeting') }" ></ui:menu-item>
			<ui:menu-item text="${ lfn:message('km-imeeting:table.kmImeetingMain') }"></ui:menu-item>
			<ui:menu-source autoFetch="false">
				<ui:source type="AjaxJson">
					{"url":"/sys/category/criteria/sysCategoryCriteria.do?method=path&modelName=com.landray.kmss.km.imeeting.model.KmImeetingTemplate&categoryId=${kmImeetingMainForm.fdTemplateId}"} 
				</ui:source>
			</ui:menu-source>
		</ui:menu>
	</template:replace>
	
	<template:replace name="content"> 
		<html:form action="/km/imeeting/km_imeeting_main/kmImeetingMain.do">
			<html:hidden property="fdId" />
			<html:hidden property="docStatus" />
			<html:hidden property="docCreatorId" />
			<html:hidden property="docCreateTime" />
			<html:hidden property="fdNotifyerId" />
			<html:hidden property="fdChangeMeetingFlag" />
			<html:hidden property="fdSummaryFlag" />
			<div class="lui_form_content_frame" style="padding-top:20px"> 
				 <table class="tb_normal" width=100% id="Table_Main"> 
				 	<%--会议变更原因--%>
					<c:if test="${kmImeetingMainForm.fdChangeMeetingFlag=='true' }">
					<tr>
						<td class="td_normal_title" width=15%>
							<bean:message bundle="km-imeeting" key="kmImeetingMain.changeMeetingReason"/>
						</td>
						<td colspan="3">
							<xform:textarea property="changeMeetingReason" style="width:98%;" required="true" showStatus="edit" validators="maxLength(1500)"></xform:textarea>
							<html:hidden property="beforeChangeContent"/>
						</td>
					</tr>
					</c:if>
				 	<tr>
				 		<td colspan="4" class="com_subject" style="font-size: 110%;font-weight: bold;">
				 			<bean:message bundle="km-imeeting" key="kmImeetingMain.createStep.base"/>
				 		</td>
				 	</tr>
				 	<tr>
				 		<%--会议名称--%>
						<td class="td_normal_title" width=15%>
							<bean:message bundle="km-imeeting" key="kmImeetingMain.fdName"/>
						</td>			
						<td width="85%" colspan="3">
							<xform:text property="fdName" style="width:98%" showStatus="edit"/>		 	
						</td>
				 	</tr>
				 	<tr>
				 		<%--召开时间--%>
						<td class="td_normal_title" width=15%>
							<bean:message bundle="km-imeeting" key="kmImeetingMain.fdDate"/>
						</td>			
						<td width="35%" >
							<xform:datetime property="fdHoldDate" dateTimeType="datetime" showStatus="edit" 
								onValueChange="changeDateTime"  required="true" validators="after compareTime"></xform:datetime>
							<span style="position: relative;top:-5px;">~</span>
							<xform:datetime property="fdFinishDate" dateTimeType="datetime" showStatus="edit" 
								onValueChange="changeDateTime" required="true" validators="after compareTime"></xform:datetime>
							<%--隐藏域,保存改变前的时间，用于回退--%>
							<input type="hidden" name="fdHoldDateTmp" value="${kmImeetingMainForm.fdHoldDate}">
							<input type="hidden" name="fdFinishDateTmp" value="${kmImeetingMainForm.fdFinishDate}">
						</td>
						<%--会议历时--%>
						<td class="td_normal_title" width=15%>
							<bean:message bundle="km-imeeting" key="kmImeetingMain.fdHoldDuration"/>
						</td>			
						<td width="35%" >
							<input type="text" name="fdHoldDurationHour" validate="digits maxLength(4)" class="inputsgl" style="width:50px;text-align: center;"  onchange="changeDuration();"/><bean:message key="date.interval.hour"/>
							<input type="text" name="fdHoldDurationMin" validate="digits maxLength(4)" class="inputsgl" style="width:50px;text-align: center;"  onchange="changeDuration();"/><bean:message key="date.interval.minute"/>
							<xform:text property="fdHoldDuration" showStatus="noShow"/>
						</td>
				 	</tr>
				 	<tr>
				 		<%--会议目的--%>
						<td class="td_normal_title" width=15%>
							<bean:message bundle="km-imeeting" key="kmImeetingMain.fdMeetingAim"/>
						</td>			
						<td width="85%" colspan="3" >
							<xform:textarea property="fdMeetingAim" style="width:98%;" showStatus="edit"/>
						</td>
				 	</tr>
				 	<tr>
				 		<%--会议类型--%>
						<td class="td_normal_title" width=15%>
							<bean:message bundle="km-imeeting" key="kmImeetingMain.fdTemplate"/>
						</td>			
						<td width="35%" >
							<html:hidden property="fdTemplateId"/>
							<c:out value="${kmImeetingMainForm.fdTemplateName }"></c:out>
						</td>
						<%--会议编号--%>
						<td class="td_normal_title" width=15%>
							<bean:message bundle="km-imeeting" key="kmImeetingMain.fdMeetingNum"/>
						</td>			
						<td width="35%" >
							<c:out value="${kmImeetingMainForm.fdMeetingNum }"></c:out>
							<html:hidden property="fdMeetingNum"/>
						</td>
				 	</tr>
				 	<tr>
				 		<%--会议组织人--%>
						<td class="td_normal_title" width=15%>
							<bean:message bundle="km-imeeting" key="kmImeetingTemplate.fdEmcee"/>
						</td>			
						<td width="35%" >
							<xform:address propertyName="fdEmceeName" propertyId="fdEmceeId" orgType="ORG_TYPE_PERSON" style="width:50%;" showStatus="edit"></xform:address>
						</td>
						<%--组织部门--%>
						<td class="td_normal_title" width=15%>
							<bean:message bundle="km-imeeting" key="kmImeetingMain.docDept"/>
						</td>			
						<td width="35%" >
							<xform:address propertyName="docDeptName" propertyId="docDeptId" subject="${lfn:message('km-imeeting:kmImeetingMain.docDept') }"
								orgType="ORG_TYPE_DEPT" style="width:50%;" showStatus="edit" required="true"></xform:address>
						</td>
				 	</tr>
				 	<tr>
				 		<%--会议发起人--%>
						<td class="td_normal_title" width=15%>
							<bean:message bundle="km-imeeting" key="kmImeetingMain.docCreator"/>
						</td>			
						<td width="85%" colspan="3" >
							<html:hidden property="docCreatorId"/>
							<c:out value="${kmImeetingMainForm.docCreatorName }"></c:out>
						</td>
				 	</tr>
				 	<tr>
				 		<td colspan="4" style="font-size: 110%;font-weight: bold;">
				 			<span class="com_subject"  style="width: 15%;display: inline-block;">
				 				<bean:message bundle="km-imeeting" key="kmImeetingMain.createStep.base.fdAttendPersons"/>
				 			</span>
				 			<span style="float: right;margin-right: 2%;">
				 				<ui:button text="${lfn:message('km-imeeting:kmImeetingMain.checkFree.text') }"  onclick="checkFree();" href="javascript:void(0);"
					 					title="${lfn:message('km-imeeting:kmImeetingMain.checkFree.title') }"/>
				 				预计<xform:text property="fdAttendNum" style="width:40px;text-align:center;" showStatus="edit"/>人参与
				 			</span>
				 		</td>
				 	</tr>
				 	<tr>
				 		<%--主持人--%>
						<td class="td_normal_title" width=15%>
							<bean:message bundle="km-imeeting" key="kmImeetingMain.fdHost"/>
						</td>			
						<td width="85%" colspan="3" >
							<xform:address propertyName="fdHostName" propertyId="fdHostId" orgType="ORG_TYPE_PERSON" style="width:150px;" onValueChange="caculateAttendNum" showStatus="edit"></xform:address>&nbsp;
							<xform:text property="fdOtherHostPerson" htmlElementProperties="placeholder='${lfn:message('km-imeeting:kmImeetingMain.fdOtherHostPerson') }'" style="width:150px;position: relative;top:-8px;" showStatus="edit"/>
						</td>
				 	</tr>
				 	<tr>
						<td class="td_normal_title" width=15%>
							<bean:message bundle="km-imeeting" key="kmImeetingMain.fdAttendPersons"/>
						</td>			
						<td width="85%" colspan="3" >
							<%--与会人员--%>
							<xform:address  style="width:47%;height:80px;" textarea="true" showStatus="edit"  propertyId="fdAttendPersonIds" propertyName="fdAttendPersonNames" 
								orgType="ORG_TYPE_ALL" mulSelect="true" onValueChange="caculateAttendNum" validators="validateattend"></xform:address>
					  		&nbsp;&nbsp;&nbsp;&nbsp;
					  		<%--外部与会人员--%>
					  		<xform:textarea style="width:47%;border:1px solid #b4b4b4" property="fdOtherAttendPerson" showStatus="edit"  
					  			htmlElementProperties="placeholder='${lfn:message('km-imeeting:kmImeetingMain.fdOtherAttendPerson') }'"  validators="validateattend maxLength(1500)" />
					  		<span class="txtstrong">*</span>
						</td>
				 	</tr>
				 	<tr>
				 		<%--列席人员--%>
						<td class="td_normal_title" width=15%>
							<bean:message bundle="km-imeeting" key="kmImeetingMain.fdParticipantPersons"/>
						</td>			
						<td width="85%" colspan="3" >
							<xform:address style="width:47%;height:80px" textarea="true" showStatus="edit"  propertyId="fdParticipantPersonIds" propertyName="fdParticipantPersonNames" orgType="ORG_TYPE_ALL" mulSelect="true" onValueChange="caculateAttendNum"></xform:address>
					  		&nbsp;&nbsp;&nbsp;&nbsp;
					  		<xform:textarea style="width:47%;border:1px solid #b4b4b4" property="fdOtherParticipantPerson" showStatus="edit"  validators="maxLength(1500)"
					  			htmlElementProperties="placeholder='${lfn:message('km-imeeting:kmImeetingMain.fdOtherParticipantPerson') }'"/>
						</td>
				 	</tr>
				 	<tr>
				 		<%--抄送人员--%>
						<td class="td_normal_title" width=15%>
							<bean:message bundle="km-imeeting" key="kmImeetingMain.fdCopyToPersons"/>
						</td>			
						<td width="85%" colspan="3" >
							<xform:address style="width:47%;height:80px" textarea="true" showStatus="edit"  propertyId="fdCopyToPersonIds" propertyName="fdCopyToPersonNames" orgType="ORG_TYPE_ALL" mulSelect="true"></xform:address>
					  		&nbsp;&nbsp;&nbsp;&nbsp;
					  		<xform:textarea style="width:47%;border:1px solid #b4b4b4" property="fdOtherCopyToPerson" showStatus="edit"  validators="maxLength(1500)"
					  			htmlElementProperties="placeholder='${lfn:message('km-imeeting:kmImeetingMain.fdOtherCopyToPerson') }'"/>
						</td>
				 	</tr>
				 	<tr>
				 		<%--纪要录入人--%>
						<td class="td_normal_title" width=15%>
							<bean:message bundle="km-imeeting" key="kmImeetingMain.fdSummaryInputPerson"/>
						</td>
						<td width="35%" >
							<xform:address style="width:150px;" propertyId="fdSummaryInputPersonId" propertyName="fdSummaryInputPersonName" showStatus="edit"
								orgType="ORG_TYPE_PERSON" onValueChange="caculateAttendNum"  validators="validateSummaryInputPerson"></xform:address>
						</td>
						<%--纪要完成时间--%>
						<td class="td_normal_title" width=15%>
							<bean:message bundle="km-imeeting" key="kmImeetingMain.fdSummaryCompleteTime"/>
						</td>			
						<td width="35%" >
							<xform:datetime property="fdSummaryCompleteTime" showStatus="edit"  dateTimeType="date"  validators="validateSummaryCompleteTime validateWithHoldDate"></xform:datetime>
							<%--是否催办纪要--%>
							<span>
					 			<input type="checkbox" style="margin-left:10px" name="fdIsHurrySummary" value="true" onclick="showHurryDayDiv();" 
									<c:if test="${kmImeetingMainForm.fdIsHurrySummary == 'true'}">checked</c:if>> 
									<bean:message bundle="km-imeeting" key="kmImeetingMain.fdIsHurrySummary" />
							</span>
							<span id="HurryDayDiv" style="display:none">
							&nbsp;<bean:message bundle="km-imeeting" key="kmImeetingMain.fdHurrySummaryDay.0" />
								<xform:text property="fdHurryDate" style="width:30px" showStatus="edit"/> 
								<bean:message bundle="km-imeeting" key="kmImeetingMain.fdHurrySummaryDay.1" /> 
							</span> 
						</td>
				 	</tr>
				 	 <tr>
				 		<td colspan="4" class="com_subject" style="font-size: 110%;font-weight: bold;">
				 			<bean:message bundle="km-imeeting" key="kmImeetingMain.createStep.base.agenda"/>
				 		</td>
				 	</tr>
				 	<tr>
				 		<%--会议议程信息--%>
				 		<td colspan="4">
				 			<%@include file="/km/imeeting/km_imeeting_agenda/kmImeetingAgenda_edit.jsp"%>
				 		</td>
				 	</tr>
				 	<tr>
				 		<%--相关资料--%>
				 		<td class="td_normal_title" width=15%>
				 			<bean:message bundle="km-imeeting" key="kmImeetingMain.attachment"/>
				 		</td>
				 		<td width="85%" colspan="3" >
							<c:import url="/sys/attachment/sys_att_main/sysAttMain_edit.jsp" charEncoding="UTF-8">
								<c:param name="fdKey" value="attachment" />
								<c:param name="fdModelId" value="${param.fdId }" />
								<c:param name="fdModelName" value="com.landray.kmss.km.imeeting.model.KmImeetingMain" />
							</c:import>
						</td>
				 	</tr>
				 	<tr>
				 		<%--备注--%>
				 		<td class="td_normal_title" width=15%>
				 			<bean:message bundle="km-imeeting" key="kmImeetingMain.fdRemark"/>
				 		</td>
				 		<td width="85%" colspan="3" >
							<xform:textarea property="fdRemark" style="width:98%;" showStatus="edit"></xform:textarea>
						</td>
				 	</tr>
				 </table>
			</div>
			
			<ui:tabpage expand="false">    
				<%-- 会议资源预定 --%>
				<ui:content title="${lfn:message('km-imeeting:kmImeetingMain.createStep.resource') }" expand="true">
					 <table class="tb_normal" width=100% id="Table_Res"> 
						
					 	<tr>
					 		<%--选择会议室--%>
					 		<td class="td_normal_title" width=15%>
					 			<bean:message bundle="km-imeeting" key="kmImeetingMain.fdPlace"/>
					 		</td>
					 		<td width="85%" colspan="3" >
					 			<xform:dialog propertyId="fdPlaceId" propertyName="fdPlaceName" showStatus="edit" validators="validateplace"
					 				className="inputsgl" style="width:44%;float:left">
							  	 	selectHoldPlace();
								</xform:dialog>
								&nbsp;	&nbsp;	&nbsp;
					 			<bean:message bundle="km-imeeting" key="kmImeetingMain.fdOtherPlace"/>
								<xform:text property="fdOtherPlace" style="width:43%;" validators="validateplace"></xform:text>
								<span class="txtstrong">*</span>
							</td>
					 	</tr>
					 	
					 	<tr>
					 		<%--会议室辅助设备--%>
					 		<td class="td_normal_title" width=15%>
					 			<bean:message bundle="km-imeeting" key="kmImeetingMain.kmImeetingDevices"/>
					 		</td>
					 		<td width="85%" colspan="3" >
								<ui:dataview>
									<ui:source type="AjaxJson">
										{url:'/km/imeeting/km_imeeting_device/kmImeetingDevice.do?method=listDevices'}
									</ui:source>
									<ui:render type="Template">
										<c:import url="/km/imeeting/resource/tmpl/devices.jsp" charEncoding="UTF-8"></c:import>
									</ui:render>
								</ui:dataview>
							</td>
					 	</tr>
					 	<tr>
					 		<%--会场布置要求--%>
					 		<td class="td_normal_title" width=15%>
					 			<bean:message bundle="km-imeeting" key="kmImeetingMain.fdArrange"/>
					 		</td>
					 		<td width="85%" colspan="3" >
								<xform:textarea property="fdArrange" style="width:98%;" showStatus="edit"></xform:textarea>
							</td>
					 	</tr>
					 	 <tr>
					 		<%--会议协助人--%>
					 		<td class="td_normal_title" width=15%>
					 			<bean:message bundle="km-imeeting" key="kmImeetingMain.fdAssistPersons"/>
					 		</td>
					 		<td width="85%" colspan="3" >
					 			<xform:address style="width:47%;height:80px" textarea="true" showStatus="edit"  propertyId="fdAssistPersonIds" propertyName="fdAssistPersonNames" orgType="ORG_TYPE_ALL" mulSelect="true"></xform:address>
						  		&nbsp;&nbsp;&nbsp;&nbsp;
						  		<xform:textarea style="width:47%;border:1px solid #b4b4b4" property="fdOtherAssistPersons" validators="maxLength(1500)"
						  			htmlElementProperties="placeholder='${lfn:message('km-imeeting:kmImeetingMain.fdOtherAssistPersons') }'" showStatus="edit"/>
							</td>
					 	</tr>
					</table>
				</ui:content>
				
				<%-- 权限及流程处理 --%>
				<ui:content title="${lfn:message('km-imeeting:kmImeetingMain.createStep.rightAndWorkflow') }" >
					<c:import url="/km/imeeting/km_imeeting_main/kmImeetingMain_rightAndWorkflow_add.jsp" charEncoding="UTF-8">
						<c:param name="formName" value="kmImeetingMainForm" />
						<c:param name="moduleModelName" value="com.landray.kmss.km.imeeting.model.KmImeetingMain" />
						<c:param name="fdKey" value="ImeetingMain" />
					</c:import>
				</ui:content>
				
				<%-- 发送会议通知单 --%>
				<ui:content title="${lfn:message('km-imeeting:kmImeetingMain.createStep.sendNotify') }" >
					<div id="notifyDiv">
						<table class="tb_normal" width=100%>
							<%-- 会议通知选项 --%>
							<tr>
								<td class="td_normal_title" width=15%>
									<bean:message bundle="km-imeeting" key="kmImeetingMain.fdNotifyType"/>
								</td>
								<td width="85%" colspan="3">
									<xform:radio property="fdNotifyType" showStatus="edit">
		       							<xform:enumsDataSource enumsType="km_imeeting_main_fd_notify_type" />
									</xform:radio>
								</td>
							</tr>
							<%-- 会议通知方式 --%>
							<tr>
								<td class="td_normal_title" width=15%>
									<bean:message bundle="km-imeeting" key="kmImeetingMain.fdNotifyType"/>
								</td>
								<td width="85%" colspan="3">
									 <kmss:editNotifyType property="fdNotifyWay" />
								</td>
							</tr>
						</table>
					</div>
					<ui:event event="show">
						if($('[name="fdChangeMeetingFlag"]').val()=='true'){
							$('[name="fdNotifyType"]').prop("disabled","disabled");
							$('input[type=checkbox]',$('#notifyDiv')[0]).each(function(){
								this.disabled="disabled";
							});
						}
					</ui:event>
				</ui:content>
			</ui:tabpage>
			
			<%-- 会议历史操作信息 --%>
			<div style="display: none;">
				<c:forEach items="${kmImeetingMainForm.kmImeetingMainHistoryForms}"  var="kmImeetingMainHistoryItem" varStatus="vstatus">
					<input type="hidden" name="kmImeetingMainHistoryForms[${vstatus.index}].fdId" value="${kmImeetingMainHistoryItem.fdId}" /> 
				</c:forEach>
			</div>
			
		</html:form>
	</template:replace>

</template:include>
<%@include file="/km/imeeting/km_imeeting_main/kmImeetingMain_edit_js.jsp"%>