<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<%
	 pageContext.setAttribute("_isJGEnabled", new Boolean(
			com.landray.kmss.sys.attachment.util.JgWebOffice
					.isJGEnabled()));
%> 
<template:include ref="default.edit" sidebar="no" >
	<%-- 页签名--%>
	<template:replace name="title">
		<c:choose>
			<c:when test="${ kmImeetingSummaryForm.method_GET == 'add' }">
				<c:out value="新建会议纪要 - ${ lfn:message('km-imeeting:module.km.imeeting') }"></c:out>	
			</c:when>
			<c:otherwise>
				<c:out value="${kmImeetingSummaryForm.fdName} - ${ lfn:message('km-imeeting:module.km.imeeting') }"></c:out>
			</c:otherwise>
		</c:choose>
	</template:replace>
	
	<%-- 按钮栏--%>
	<template:replace name="toolbar">
		<ui:toolbar id="toolbar" layout="sys.ui.toolbar.float"> 
			<c:if test="${kmImeetingSummaryForm.method_GET=='edit'}">
				<c:if test="${kmImeetingSummaryForm.docStatus=='10'}">
				   <ui:button text="${lfn:message('button.savedraft') }" order="2" onclick="commitMethod('update', 'true');">
				   </ui:button>
				</c:if>
				<c:if test="${kmImeetingSummaryForm.docStatus<'20'}">
				   <ui:button text="${lfn:message('button.submit') }" order="2" onclick="commitMethod('update','false');">
				   </ui:button>
				</c:if>
				<c:if test="${kmImeetingSummaryForm.docStatus=='20'}">
				   <ui:button text="${lfn:message('button.submit') }" order="2" onclick="Com_Submit(document.kmImeetingSummaryForm, 'update');">
				   </ui:button>
				</c:if>
				<c:if test="${kmImeetingSummaryForm.docStatus>='30'}">
				    <ui:button text="${lfn:message('button.submit') }" order="2" onclick="Com_Submit(document.kmImeetingSummaryForm, 'update');">
				    </ui:button>
				</c:if>
			</c:if>
			<c:if test="${kmImeetingSummaryForm.method_GET=='add'}">
			        <ui:button text="${lfn:message('button.savedraft') }" order="2" onclick="commitMethod('save', 'true');">
				    </ui:button>
				    <ui:button text="${lfn:message('button.submit') }" order="2" onclick="commitMethod('save', 'false');">
				    </ui:button>
			</c:if> 
			<ui:button text="${ lfn:message('button.close') }" order="5"  onclick="Com_CloseWindow()">
			</ui:button>
		</ui:toolbar>  
	</template:replace>
	
	<%-- 导航路径--%>
	<template:replace name="path">
		<ui:menu layout="sys.ui.menu.nav"  id="categoryId"> 
				<ui:menu-item text="${ lfn:message('home.home') }" icon="lui_icon_s_home">
				</ui:menu-item>
				<ui:menu-item text="${ lfn:message('km-imeeting:module.km.imeeting') }">
				</ui:menu-item>
				<ui:menu-item text="${ lfn:message('km-imeeting:table.kmImeetingSummary') }">
				</ui:menu-item>
				<ui:menu-source autoFetch="false">
					<ui:source type="AjaxJson">
						{"url":"/sys/category/criteria/sysCategoryCriteria.do?method=path&modelName=com.landray.kmss.km.imeeting.model.KmImeetingTemplate&categoryId=${kmImeetingSummaryForm.fdTemplateId}"} 
					</ui:source>
				</ui:menu-source>
		</ui:menu>
	</template:replace>
	
	<template:replace name="content"> 
		<c:if test="${kmImeetingSummaryForm.method_GET=='add'}">
			<script type="text/javascript">
				window.changeDocTemp = function(modelName,url,canClose){
					if(modelName==null || modelName=='' || url==null || url=='')
						return;
			 		seajs.use(['sys/ui/js/dialog'],function(dialog) {
					 	dialog.categoryForNewFile(modelName,url,false,null,
						function(rtn) {
							// 无分类状态下（一般于门户快捷操作）创建文档，取消操作同时关闭当前窗口
							if (!rtn)
								window.close();
						},'${param.categoryId}','_self',canClose);
				 	});
			 	};
				if('${param.meetingId}'==''&&'${param.fdTemplateId}'==''){
					window.changeDocTemp('com.landray.kmss.km.imeeting.model.KmImeetingTemplate','/km/imeeting/km_imeeting_summary/kmImeetingSummary.do?method=add&fdTemplateId=!{id}',true);
				}
			</script>
		</c:if>
		<html:form action="/km/imeeting/km_imeeting_summary/kmImeetingSummary.do" onsubmit="return checkForm();"> 
			<style>
				.tips {
					background: #fff7c6;
					margin-top: 10px;
					line-height: 27px;
					border: 1px #e8e8e8 solid;
					padding-left: 8px;
					width: 450px;
				}
				.tips img {
					position: relative;
					top: 3px;
				}
			</style>
			<div class="lui_form_content_frame" style="padding-top:20px">
				<html:hidden property="fdId" />
				<html:hidden property="docStatus" />
				<html:hidden property="fdMeetingId" />
				<p class="txttitle">
					<bean:message bundle="km-imeeting" key="table.kmImeetingSummary" />
				</p>
				<table class="tb_normal" width=100% id="Table_Main">
					<tr>
						<%-- 会议名称--%>
						<td class="td_normal_title" width=15%>
							<bean:message bundle="km-imeeting" key="kmImeetingSummary.fdName"/>
						</td>
						<td width="35%">
							<xform:text property="fdName" style="width:95%" />
						</td>
						<%-- 会议类型--%>
						<td class="td_normal_title" width=15%>
							<bean:message bundle="km-imeeting" key="kmImeetingSummary.fdTemplate"/>
						</td>
						<td width="35%">
							<html:hidden property="fdTemplateId"/>
							<html:hidden property="fdTemplateName"/>
							<c:out value="${kmImeetingSummaryForm.fdTemplateName}"></c:out>
						</td>
					</tr>
					<tr>
						<%-- 主持人--%>
						<td class="td_normal_title" width=15%>
							<bean:message bundle="km-imeeting" key="kmImeetingSummary.fdHost"/>
						</td>
						<td width="35%">
							<xform:address style="width:46%;float:left" propertyId="fdHostId" propertyName="fdHostName" orgType="ORG_TYPE_PERSON"></xform:address>
					    	&nbsp;&nbsp;&nbsp;&nbsp;
							<xform:text style="width:45%" property="fdOtherHostPerson" className="inputsgl" htmlElementProperties="placeholder='${lfn:message('km-imeeting:kmImeetingSummary.fdOtherHostPerson') }'"/>
						</td>
						<%-- 会议地点--%>
						<td class="td_normal_title" width=15%>
							<bean:message bundle="km-imeeting" key="kmImeetingSummary.fdPlace"/>
						</td>
						<td width="35%">
							<xform:dialog propertyId="fdPlaceId" propertyName="fdPlaceName" style="width:46%;float:left" 
								validators="placenotnull" showStatus="edit">
								selectHoldPlace();
							</xform:dialog>
							&nbsp;&nbsp;&nbsp;&nbsp;
						   <xform:text property="fdOtherPlace" validators="placenotnull"
						   		style="width:45%"  htmlElementProperties="placeholder='${lfn:message('km-imeeting:kmImeetingSummary.fdOtherPlace') }'" />
						   	<span class="txtstrong">*</span>
						</td>
					</tr>
					<tr>
						<%-- 会议时间--%>
						<td class="td_normal_title" width=15%>
							<bean:message bundle="km-imeeting" key="kmImeetingMain.fdDate"/>
						</td>
						<td width="35%">
							<xform:datetime property="fdHoldDate" dateTimeType="datetime" onValueChange="changeDateTime"
								style="width:46%" required="true" validators="compareTime"></xform:datetime>
							<span style="position: relative;top:-5px;">~</span>
							<xform:datetime property="fdFinishDate" dateTimeType="datetime" onValueChange="changeDateTime"
								style="width:46%" required="true" validators="compareTime"></xform:datetime>
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
						<%-- 计划参加人员--%>
						<td class="td_normal_title" width=15%>
					   		<bean:message bundle="km-imeeting" key="kmImeetingSummary.fdPlanAttendPersons" />
						</td>
						<td width=85% colspan="3">
							<c:if test="${kmImeetingSummaryForm.fdMeetingId == null}">
								<xform:dialog icon="orgelement" propertyId="fdPlanAttendPersonIds"  propertyName="fdPlanAttendPersonNames" 
									 style="width:48%;height:80px" textarea="true">
						  			Dialog_Address(true, 'fdPlanAttendPersonIds','fdPlanAttendPersonNames',';',ORG_TYPE_ALL,changeActualAttendPerson);
								</xform:dialog> 
								<xform:textarea property="fdPlanOtherAttendPerson" style="width:48%;height:80px;border:1px solid #b4b4b4" validators="maxLength(1500)"
									htmlElementProperties="onkeyup='changeOtherActualAttend()' placeholder='${lfn:message('km-imeeting:kmImeetingSummary.fdPlanOtherAttendPerson') }'" />
							</c:if>
							<c:if test="${kmImeetingSummaryForm.fdMeetingId != null}">
								<html:hidden property="fdPlanAttendPersonIds" />
								<html:hidden property="fdPlanAttendPersonNames" />
								<html:hidden property="fdPlanOtherAttendPerson" />
								
								<c:if test="${ not empty kmImeetingSummaryForm.fdPlanAttendPersonNames }">
									<img src="${LUI_ContextPath}/km/imeeting/resource/images/inner_person.png" />
									<span style="vertical-align: top;">
										<bean:message bundle="km-imeeting" key="kmImeetingMain.fdInnerPerson"/>：<c:out value="${kmImeetingSummaryForm.fdPlanAttendPersonNames }"></c:out>
									</span>
								</c:if>
								<%--外部计划参与人员--%>
								<c:if test="${ not empty kmImeetingSummaryForm.fdPlanOtherAttendPerson }">
									<br/><br/>
									<img src="${LUI_ContextPath}/km/imeeting/resource/images/other_person.png" />
									<span style="vertical-align: top;">
										<bean:message bundle="km-imeeting" key="kmImeetingMain.fdOtherPerson"/>：<c:out value="${kmImeetingSummaryForm.fdPlanOtherAttendPerson }"></c:out>
									</span>
								</c:if>
								
							</c:if>
						</td>
					</tr>
					<tr>
						<%-- 计划列席人员--%>
						<td class="td_normal_title" width=15%>
					   		<bean:message bundle="km-imeeting" key="kmImeetingSummary.fdPlanParticipantPersons" />
						</td>
						<td width=85% colspan="3">
							<c:if test="${kmImeetingSummaryForm.fdMeetingId == null}">
								<xform:dialog icon="orgelement" propertyId="fdPlanParticipantPersonIds"  propertyName="fdPlanParticipantPersonNames" 
									style="width:48%;height:80px" textarea="true">
						  			Dialog_Address(true, 'fdPlanParticipantPersonIds','fdPlanParticipantPersonNames',';',ORG_TYPE_ALL,changeActualAttendPerson);
								</xform:dialog> 
								<xform:textarea property="fdPlanOtherParticipantPersons" style="width:48%;height:80px;border:1px solid #b4b4b4" validators="maxLength(1500)"
									htmlElementProperties="onkeyup='changeOtherActualAttend()' placeholder='${lfn:message('km-imeeting:kmImeetingSummary.fdPlanOtherParticipantPersons') }'" />
							</c:if>
							<c:if test="${kmImeetingSummaryForm.fdMeetingId != null}">
								<html:hidden property="fdPlanParticipantPersonIds" />
								<html:hidden property="fdPlanParticipantPersonNames" />
								<html:hidden property="fdPlanOtherParticipantPersons" />
								
								<c:if test="${ not empty kmImeetingSummaryForm.fdPlanParticipantPersonNames }">
									<img src="${LUI_ContextPath}/km/imeeting/resource/images/inner_person.png" />
									<span style="vertical-align: top;">
										<bean:message bundle="km-imeeting" key="kmImeetingMain.fdInnerPerson"/>：<c:out value="${kmImeetingSummaryForm.fdPlanParticipantPersonNames }"></c:out>
									</span>
								</c:if>
								<%--外部参加人员--%>
								<c:if test="${ not empty kmImeetingSummaryForm.fdPlanOtherParticipantPersons }">
									<br/><br/>
									<img src="${LUI_ContextPath}/km/imeeting/resource/images/other_person.png" />
									<span style="vertical-align: top;">
										<bean:message bundle="km-imeeting" key="kmImeetingMain.fdOtherPerson"/>：<c:out value="${kmImeetingSummaryForm.fdPlanOtherParticipantPersons }"></c:out>
									</span>
								</c:if>
								
							</c:if>
						</td>
					</tr>
					<tr>
						<!-- 实际与会人员 -->
						<td class="td_normal_title" width=15%>
						   <bean:message bundle="km-imeeting" key="kmImeetingSummary.fdActualAttendPersons" />
						</td>
						<td colspan="3">
						    <xform:dialog icon="orgelement" propertyId="fdActualAttendPersonIds" propertyName="fdActualAttendPersonNames" 
						   		style="width:48%;height:80px" textarea="true"  validators="attendpersonnotnull">
							   Dialog_Address(true, 'fdActualAttendPersonIds','fdActualAttendPersonNames',';',ORG_TYPE_ALL);
							</xform:dialog> 
							<xform:textarea property="fdActualOtherAttendPersons" validators="attendpersonnotnull maxLength(1500)"
								style="width:48%;height:80px;border:1px solid #b4b4b4" htmlElementProperties="placeholder='${lfn:message('km-imeeting:kmImeetingSummary.fdActualOtherAttendPersons') }'"/> 
							<span class="txtstrong">*</span>
						</td>
					</tr>
					<tr>
						<%-- 抄送人员--%>
						<td class="td_normal_title" width=15%>
					   		<bean:message bundle="km-imeeting" key="kmImeetingSummary.fdCopyToPersons" />
						</td>
						<td colspan="3">
							<xform:address propertyName="fdCopyToPersonNames" propertyId="fdCopyToPersonIds" style="width:97%;" textarea="true" mulSelect="true"></xform:address>
						</td>
					</tr>
					<tr>
						<%-- 编辑方式--%>
						<td class="td_normal_title" width=15%>
							<bean:message bundle="km-imeeting" key="kmImeetingSummary.fdContentType" />
						</td>
						<td width=85% colspan="3">
							<xform:radio property="fdContentType" showStatus="edit"   onValueChange="checkEditType">
								<xform:enumsDataSource enumsType="kmImeetingSummary_fdContentType" />
							</xform:radio>	
						</td>
					</tr>
					<tr>
						<%-- 编辑内容--%>
						<td class="td_normal_title" width=15%>
							<bean:message bundle="km-imeeting" key="kmImeetingSummary.docContent" />
						</td>
						<td width=85% colspan="3">
							<html:hidden property="fdHtmlContent" />
							<div id="rtfEdit"  <c:if test="${kmImeetingSummaryForm.fdContentType!='rtf'}">style="display:none"</c:if>>
								<kmss:editor property="docContent" toolbarSet="Default" width="97%"/>
							</div>
							<div id="wordEdit" style="width:0px;height:0px">
								<c:choose>
									<c:when test="${pageScope._isJGEnabled == 'true'}">
										<div id="wordEditWrapper"></div>
										<div id="wordEditFloat" style="position: absolute;width:0px;height:0px;">
											<c:import url="/sys/attachment/sys_att_main/jg_ocx.jsp" charEncoding="UTF-8">
												<c:param name="fdModelId" value="${kmImeetingSummaryForm.fdId}" />
												<c:param name="fdModelName" value="com.landray.kmss.km.imeeting.model.KmImeetingSummary" />
												<c:param name="fdKey" value="editonline" />
												<c:param name="formBeanName" value="kmImeetingSummaryForm" />
												<c:param name="fdAttType" value="${kmImeetingSummaryForm.fdContentType}" />
												<c:param name="fdCopyId" value="" />
												<c:param name="fdTemplateModelId" value="${param.fdTemplateId}" />
												<c:param name="fdTemplateModelName" value="com.landray.kmss.km.imeeting.model.KmImeetingTemplate" />
												<c:param name="fdTemplateKey" value="editonline" />
											</c:import>
										</div>
									</c:when>
									<c:otherwise>
										<c:import url="/sys/attachment/sys_att_main/sysAttMain_edit.jsp" charEncoding="UTF-8">
											<c:param name="fdModelId" value="${kmImeetingSummaryForm.fdId}"/>
											<c:param name="fdModelName" value="com.landray.kmss.km.imeeting.model.KmImeetingSummary"/>
											<c:param name="fdKey" value="editonline"/>
											<c:param name="formBeanName" value="kmImeetingSummaryForm" />
											<c:param name="fdAttType" value="office"/>
											<c:param name="fdTemplateModelId" value="${param.fdTemplateId}" />
											<c:param name="fdTemplateModelName" value="com.landray.kmss.km.imeeting.model.KmImeetingTemplate" />
											<c:param name="fdTemplateKey" value="editonline" />
											<c:param name="templateBeanName" value="kmImeetingTemplateForm" />
										</c:import>
										<div id="pic" style="display:none">
											<c:import url="/sys/attachment/sys_att_main/sysAttMain_edit.jsp" charEncoding="UTF-8">
												<c:param name="fdKey" value="fdAttachmentPic" />
												<c:param name="fdModelName" value="com.landray.kmss.km.imeeting.model.KmImeetingSummary"/>
											</c:import>
										</div>
									</c:otherwise>
								</c:choose>
							</div>
						</td>
					</tr>
					<tr>
				 		<%--相关资料--%>
				 		<td class="td_normal_title" width=15%>
				 			<bean:message bundle="sys-attachment" key="table.sysAttMain"/>
				 		</td>
				 		<td width="85%" colspan="3" >
							<c:import url="/sys/attachment/sys_att_main/sysAttMain_edit.jsp" charEncoding="UTF-8">
								<c:param name="fdKey" value="attachment" />
								<c:param name="fdModelId" value="${param.fdId }" />
								<c:param name="fdModelName" value="com.landray.kmss.km.imeeting.model.KmImeetingSummary" />
							</c:import>
						</td>
				 	</tr>
			 		<tr>
				 		<%--会议组织人--%>
						<td class="td_normal_title" width=15%>
							<bean:message bundle="km-imeeting" key="kmImeetingSummary.fdEmcee"/>
						</td>			
						<td width="35%" >
							<xform:address propertyName="fdEmceeName" propertyId="fdEmceeId" orgType="ORG_TYPE_PERSON" style="width:95%;"></xform:address>
						</td>
						<%--组织部门--%>
						<td class="td_normal_title" width=15%>
							<bean:message bundle="km-imeeting" key="kmImeetingSummary.docDept"/>
						</td>			
						<td width="35%" >
							<xform:address propertyName="docDeptName" propertyId="docDeptId" orgType="ORG_TYPE_DEPT" style="width:95%;"></xform:address>
						</td>
				 	</tr>
					<tr>
						<td class="td_normal_title" width=15%>
							<bean:message bundle="km-imeeting" key="kmImeetingSummary.fdNotifyType" />
						</td>
						<td colspan="3">
								<kmss:editNotifyType property="fdNotifyType"/>
								<div class="tips">
									<img src="${LUI_ContextPath}/km/imeeting/resource/images/tip_bulb.png" />
									<bean:message bundle="km-imeeting" key="kmImeetingSummary.notifyPerson" />
								</div>
						</td>
					</tr>
					<tr>
						<%-- 纪要录入人--%>
						<td class="td_normal_title" width=15%>
							<bean:message bundle="km-imeeting" key="kmImeetingSummary.docCreator"/>
						</td>
						<td width="35%">
							<html:hidden property="docCreatorId"/><html:hidden property="docCreatorName"/>
							<c:out value="${kmImeetingSummaryForm.docCreatorName }"></c:out>
						</td>
						<%-- 录入时间--%>
						<td class="td_normal_title" width=15%>
							<bean:message bundle="km-imeeting" key="kmImeetingSummary.docCreateTime"/>
						</td>
						<td width="35%">
							<html:hidden property="docCreateTime"/>
							<c:out value="${kmImeetingSummaryForm.docCreateTime }"></c:out>
						</td>
					</tr>
				</table>
			</div>
			<ui:tabpage expand="false" > 
				<c:import url="/sys/workflow/import/sysWfProcess_edit.jsp" charEncoding="UTF-8">
					<c:param name="formName" value="kmImeetingSummaryForm" />
					<c:param name="fdKey" value="ImeetingSummary" />
				</c:import>
				<c:import url="/sys/right/import/right_edit.jsp" charEncoding="UTF-8">
					<c:param name="formName" value="kmImeetingSummaryForm" />
					<c:param name="moduleModelName" value="com.landray.kmss.km.imeeting.model.KmImeetingSummary" />
				</c:import>
			</ui:tabpage>
		</html:form>
	</template:replace>
</template:include>
<script language="JavaScript">
	var validation=$KMSSValidation(document.forms['kmImeetingSummaryForm']);
</script>
<script>
	seajs.use(['lui/jquery','lui/dialog','lui/topic','km/imeeting/resource/js/dateUtil'], function($,dialog,topic,dateUtil){
		
		
		//自动带出实际参会人员
		window.changeActualAttendPerson=function(){
			var attendIds=$('[name="fdPlanAttendPersonIds"]').val(),
				attendNames=$('[name="fdPlanAttendPersonNames"]').val(),
				participantIds=$('[name="fdPlanParticipantPersonIds"]').val(),
				participantNames=$('[name="fdPlanParticipantPersonNames"]').val();
			var actualAttendIds=joinPerson(attendIds,participantIds),
				actualAttendNames=joinPerson(attendNames,participantNames);
			$('[name="fdActualAttendPersonIds"]').val(actualAttendIds);
			$('[name="fdActualAttendPersonNames"]').val(actualAttendNames);	
		};
		
		//自动带出实际参会外部人员
		window.changeOtherActualAttend=function(){
			var otherAttend=$('[name="fdPlanOtherAttendPerson"]').val(),
				otherParticipant=$('[name="fdPlanOtherParticipantPersons"]').val();
			$('[name="fdActualOtherAttendPersons"]').val(joinPerson(otherAttend,otherParticipant));
		};
		
		function joinPerson(){
			var slice=Array.prototype.slice,
				args=slice.call(arguments,0),
				arr=[];
			for(var i=0;i<args.length;i++){
				if(args[i]){
					arr.push(args[i]);
				}
			}
			return arr.join(';');
		}

		//选择会议地点
		window.selectHoldPlace=function(){
			var resId=$('[name="fdPlaceId"]').val();//地点ID
			var resName=$('[name="fdPlaceName"]').val();//地点Name
			var url="/km/imeeting/km_imeeting_res/kmImeetingRes_showAllResDialog.jsp?"+"&resId="+resId+"&resName="+resName;
			dialog.iframe(url,'会议室选择',function(arg){
				if(arg){
					$('[name="fdPlaceId"]').val(arg.resId);
					$('[name="fdPlaceName"]').val(arg.resName);
				}
				validation.validateElement($('[name="fdPlaceName"]')[0]);
			},{width:800,height:500});
		};
		
		//计算会议历时时间,返回数组,依次为:总时差、小时时差、分钟时差、……
		var _caculateDuration=function(start,end){
			if( start && end ){
				start=dateUtil.parseDate(start);
				end=dateUtil.parseDate(end);
				if(start.getTime()<end.getTime()){
					var total=end.getTime()-start.getTime();
					var hour=parseInt((end.getTime()-start.getTime() )/(1000*60*60));
					var minute=parseInt((end.getTime()-start.getTime() )%(1000*60*60)/(1000*60));
					return [total,hour,minute];
				}else{
					return [0.0,0,0];
				}
			}
		};
		
		//修改会议时间时，联动修改会议历时
		window.changeDateTime=function(){
			var fdHoldDate=$('[name="fdHoldDate"]').val();//召开时间
			var fdFinishDate=$('[name="fdFinishDate"]').val();//结束时间
			//选择了开始时间后，结束时间默认带出
			if( fdHoldDate && !fdFinishDate ){
				$('[name="fdFinishDate"]').val(fdHoldDate);
				fdFinishDate=fdHoldDate;
			}
			if(fdHoldDate && fdFinishDate){
				//如果结束日期早于召开日期，自动调整结束日期为开始日期
				if(dateUtil.parseDate(fdHoldDate).getTime()>dateUtil.parseDate(fdFinishDate).getTime()){
					$('[name="fdFinishDate"]').val(fdHoldDate);
				}
				var duration=_caculateDuration(fdHoldDate,fdFinishDate);
				//设置会议历时
				$('[name="fdHoldDuration"]').val(duration[0]);
				$('[name="fdHoldDurationHour"]').val(duration[1]);
				$('[name="fdHoldDurationMin"]').val(duration[2]);
			}
		};
		
		//修改会议历时时触发
		window.changeDuration=function(){
			var fdHoldDurationHour=$('[name="fdHoldDurationHour"]').val();
			var fdHoldDurationMin=	$('[name="fdHoldDurationMin"]').val();
			var totalHour=dateUtil.mergeTime({"hour":fdHoldDurationHour, "minute":fdHoldDurationMin},"ms" );
			$('[name="fdHoldDuration"]').val(totalHour);
		};
		
		//初始化会议历时
		if('${kmImeetingSummaryForm.fdHoldDuration}'){
			//将小时分解成时分
			var timeObj=dateUtil.splitTime({"ms":"${kmImeetingSummaryForm.fdHoldDuration}"});
			$('[name="fdHoldDurationHour"]').val(timeObj.hour);
			$('[name="fdHoldDurationMin"]').val(timeObj.minute);
		}
		
		//校验召开时间不能晚于结束时间
		var _compareTime=function(){
			var fdHoldDate=$('[name="fdHoldDate"]');
			var fdFinishedDate=$('[name="fdFinishDate"]');
			var result=true;
			if( fdHoldDate.val() && fdFinishedDate.val() ){
				var start=dateUtil.parseDate(fdHoldDate.val());
				var end=dateUtil.parseDate(fdFinishedDate.val());
				if( start.getTime()>=end.getTime() ){
					result=false;
				}
			}
			return result;
		};
		//自定义校验器:校验召开时间不能晚于结束时间
		validation.addValidator('compareTime','${lfn:message("km-imeeting:kmImeetingMain.fdDate.tip")}',function(v, e, o){
			 var docStartTime=document.getElementsByName('fdHoldDate')[0];
			 var docFinishedTime=document.getElementsByName('fdFinishDate')[0];
			 var result= _compareTime();
			 if(result==false){
				KMSSValidation_HideWarnHint(docStartTime);
				KMSSValidation_HideWarnHint(docFinishedTime);
			}
			return result;
		});
		
		//自定义校验器:校验“实际与会人员”和“实际其他与会人员”不能全为空
		var attendPersonNotNullStr="${lfn:message('errors.required')}".replace('{0}',"${lfn:message('km-imeeting:kmImeetingSummary.fdActualAttendPersons')}");
		validation.addValidator('attendpersonnotnull',attendPersonNotNullStr,function(v, e, o){
			 var fdActualAttendPersonNames=document.getElementsByName('fdActualAttendPersonNames')[0];
			 var fdActualOtherAttendPersons=document.getElementsByName('fdActualOtherAttendPersons')[0];
			 var result= true;
			 if(!fdActualAttendPersonNames.value
					 && !fdActualOtherAttendPersons.value){
				 result=false;
			 }
			 if(result==false){
				KMSSValidation_HideWarnHint(fdActualAttendPersonNames);
				KMSSValidation_HideWarnHint(fdActualOtherAttendPersons);
			}
			return result;
		});
		
		//自定义校验器:校验“地点”和“其他地点”不能全为空
		var placeNotNullStr="${lfn:message('errors.required')}".replace('{0}',"${lfn:message('km-imeeting:kmImeetingMain.fdPlace')}");
		validation.addValidator('placenotnull',placeNotNullStr,function(v, e, o){
			 var fdPlaceName=document.getElementsByName('fdPlaceName')[0];
			 var fdOtherPlace=document.getElementsByName('fdOtherPlace')[0];
			 var result= true;
			 if(!fdPlaceName.value
					 && !fdOtherPlace.value){
				 result=false;
			 }
			 if(result==false){
				KMSSValidation_HideWarnHint(fdPlaceName);
				KMSSValidation_HideWarnHint(fdOtherPlace);
			}
			return result;
		});

		//切换编辑方式
		window.checkEditType=function(value, obj){
			var _rtfEdit = document.getElementById('rtfEdit');
			var _wordEdit = document.getElementById('wordEdit');
			if (_rtfEdit == null || _wordEdit == null) {
				return ;
			}
			if("word" == value){
				//word编辑方式
				_rtfEdit.style.display = "none";
				_wordEdit.style.display = "block";
				_wordEdit.style.width = "100%";
				_wordEdit.style.height = "650px";
				var xw = $("#wordEditWrapper").width();
				document.getElementById('wordEditFloat').style.width = xw + "px";
				document.getElementById('wordEditFloat').style.height = "650px";
				
				//var xw = $("#wordEditWrapper").width();
				//document.getElementById('wordEditFloat').style.width = xw + "px";
				//document.getElementById('wordEditFloat').style.height = "650px";
				if ("${pageScope._isJGEnabled}" == "true") {
					JG_Load();
				}
				topic.subscribe("Sidebar",function(data){
					var xw = $("#wordEditWrapper").width();
					document.getElementById('wordEditFloat').style.width = xw + "px";
					document.getElementById('wordEditFloat').style.height = "650px";
				});
			} else {
				//rtf编辑方式
				_rtfEdit.style.display = "block";
				document.getElementById('wordEditFloat').style.width = "0px";
				document.getElementById('wordEditFloat').style.height = "0px";
				_wordEdit.style.width = "0px";
				_wordEdit.style.height = "0px";
			}
		};

		//提交纪要
		window.commitMethod=function(commitType, saveDraft){
			var formObj = document.kmImeetingSummaryForm;
			var docStatus = document.getElementsByName("docStatus")[0];
			if(saveDraft=="true"){
				_removeRequireValidate();
				docStatus.value="10";
				Com_Submit(formObj, commitType);
			}else{
				validation.resetElementsValidate(formObj);
				docStatus.value="20";
				Com_Submit(formObj, commitType);
			}
			
		};
		
		//移除必填校验
		function _removeRequireValidate(){
			var formObj = document.kmImeetingSummaryForm;
			validation.removeElements(formObj,'required');//不校验单字段必填
			validation.removeElements(formObj,'attendpersonnotnull');//不校验参加人员不全为空
			validation.removeElements(formObj,'placenotnull');//不校验地点不全为空
			validation.addElements($('[name="fdName"]')[0],'required');//标题还是要必填
		}

		//文档提交时调用该方法进行验证
		window.checkForm=function(){
			return true;
		};

		//*******word编辑方式相关JS（开始）****************//
		
		//Com_AddEventListener(window, "load", function() {
			checkEditType("${kmImeetingSummaryForm.fdContentType}", null);
		//});
		
		var hasSetHtmlToContent = false;
		var htmlContent = "";

		Com_Parameter.event["submit"].push(function() {
			var type=$('[name="fdContentType"]:checked').val();
			if ("word" == type) {
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
				document.kmImeetingSummaryForm.fdHtmlContent.value = htmlContent;
			}
			return true;
		});

		var getTempFilePath=function(fdKey){
			Attachment_ObjectInfo[fdKey].getOcxObj();
			var tempFold = Attachment_ObjectInfo[fdKey].ocxObj.GetUniqueFileName();
			tempFold = tempFold.substring(0, tempFold.lastIndexOf('\\'));
			return tempFold;
		};

		//获取图片的id
		var  getImgFdId =function(fdIds,fileName){
			for(var i = 0; i < fdIds.length; i ++) {
				var fdName = fdIds[i].split(":")[1];
				var fdid = fdIds[1].split(":")[0];
				if(fileName.indexOf(fdName,0)>0){
					return fdid;
				}
			}
			return false;
		};

		var formatHTML=function(html){
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
		};

		var updatePicHTML=function(tbody, fdIds){
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
		};
		
		var getHTMLtoContent=function(fdKey, picfdKey){
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
		};
		//*******word编辑方式相关JS（结束）****************//
		
	});
</script>