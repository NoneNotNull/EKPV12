<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="/WEB-INF/kmss-xform.tld" prefix="xform"%>
<%@ include file="/resource/jsp/edit_top.jsp"%>
<script>Com_IncludeFile("dialog.js|doclist.js|calendar.js|jquery.js");</script>
<html:form action="/km/imeeting/km_imeeting_template/kmImeetingTemplate.do">
<div id="optBarDiv">
	<c:if test="${kmImeetingTemplateForm.method_GET=='edit'}">
		<input type=button value="<bean:message key="button.update"/>"
			onclick="commitMethod(document.kmImeetingTemplateForm, 'update');">
	</c:if>
	<c:if test="${kmImeetingTemplateForm.method_GET=='add'}">
		<input type=button value="<bean:message key="button.save"/>"
			onclick="commitMethod(document.kmImeetingTemplateForm, 'save');">
		<input type=button value="<bean:message key="button.saveadd"/>"
			onclick="commitMethod(document.kmImeetingTemplateForm, 'saveadd');">
	</c:if>
	<input type="button" value="<bean:message key="button.close"/>" onclick="Com_CloseWindow();">
</div>

<p class="txttitle"><bean:message bundle="km-imeeting" key="table.kmImeetingTemplate.card"/></p>

<center>
<html:hidden property="fdId" />
<table id="Label_Tabel" width=95%>
	<%--会务安排--%>
	<tr LKS_LabelName="<bean:message  bundle="km-imeeting" key="kmImeetingTemplate.infoTitle"/>">
		<td>
			<table class="tb_normal" width=100%>
				<tr>
					<%--模板名称--%>
					<td class="td_normal_title" width=15%>
						<bean:message bundle="km-imeeting" key="kmImeetingTemplate.fdName"/>
					</td>
					<td width="85%" colspan="3">
						<xform:text property="fdName" style="width:85%" />
					</td>
				</tr>
				<tr>
					<%--类别--%>
					<td class="td_normal_title" width=15%>
						<bean:message bundle="km-imeeting" key="kmImeetingTemplate.docCategoryId"/>
					</td>
					<td colspan="3">
						<html:hidden property="docCategoryId" /> 
						<html:text property="docCategoryName" readonly="true" styleClass="inputsgl" style="width:85%" /> 
						<a href="#" onclick="Dialog_Category('com.landray.kmss.km.imeeting.model.KmImeetingTemplate','docCategoryId','docCategoryName');">
							<span class="txtstrong">*</span><bean:message key="dialog.selectOther" />
						</a>
						<c:if test="${not empty noAccessCategory}">
							<script language="Javascript">
								function closeWindows(rtnVal){
									if(rtnVal==null){
										window.close();
									}
								}
								if(!confirm("<bean:message arg0='${noAccessCategory}' key='error.noAccessCreateTemplate.alert' />")){
									window.close();
								}else{
									Dialog_Category('com.landray.kmss.km.imeeting.model.KmImeetingTemplate','docCategoryId','docCategoryName',null,null,null,null,closeWindows, true);
								}
							</script>
						</c:if>
					</td>
				</tr>
				<tr>
					<%--排序号--%>
					<td class="td_normal_title" width=15%>
						<bean:message bundle="km-imeeting" key="kmImeetingTemplate.fdOrder"/>
					</td>
					<td width="85%" colspan="3">
						<xform:text property="fdOrder" style="width:100px" />
					</td>
				</tr>
				<tr>
					<%--可使用者--%>
					<td class="td_normal_title" width=15%>
						<bean:message bundle="km-imeeting" key="kmImeetingTemplate.authReaders"/>
					</td>
					<td width="85%" colspan="3">
						<xform:address textarea="true"  propertyId="authReaderIds" propertyName="authReaderNames" orgType="ORG_TYPE_ALL" style="width:85%" mulSelect="true"/>
						<br><bean:message bundle="km-imeeting" key="kmImeetingTemplate.authReaders.tip" />
					</td>
				</tr>
				<tr>
					<%--可维护者--%>
					<td class="td_normal_title" width=15%>
						<bean:message bundle="km-imeeting" key="kmImeetingTemplate.authEditors"/>
					</td>
					<td width="85%" colspan="3">
						<xform:address textarea="true"  propertyId="authEditorIds" propertyName="authEditorNames" orgType="ORG_TYPE_ALL" style="width:85%" mulSelect="true"/>
						<br><bean:message bundle="km-imeeting" key="kmImeetingTemplate.authEditors.tip" />
					</td>
				</tr>
				<tr><td colspan="4">&nbsp;</td></tr>
				<tr>
					<%--会议主题--%>
					<td class="td_normal_title" width=15%>
						<bean:message bundle="km-imeeting" key="kmImeetingTemplate.docSubject"/>
					</td>
					<td width="85%" colspan="3">
						<xform:text property="docSubject" style="width:85%" />
					</td>
				</tr>
				<tr>
					<%--召开时间--%>
					<td class="td_normal_title" width=15%>
						<bean:message bundle="km-imeeting" key="kmImeetingTemplate.fdPeriodType"/>
					</td>
					<td width="85%" colspan="3">
						<input type="hidden" name="fdHoldTime" id="fdHoldTime" value="${kmImeetingTemplateForm.fdHoldTime}" />
						<table cellpadding="1" cellspacing="0" style="border: none;">
							<tr>
								<td style="border: none;">
								<xform:radio property="fdPeriodType" alignment="V" showStatus="edit" onValueChange="PeriodTypeChick" style="height: 22px;vertical-align: middle;">
									<xform:simpleDataSource value="1" textKey="calendar.perYear" />
									<xform:simpleDataSource value="2" textKey="calendar.perQuarter" />
									<xform:simpleDataSource value="3" textKey="calendar.perMonth" />
									<xform:simpleDataSource value="4" textKey="calendar.perWeek" />
									<xform:simpleDataSource value="5" textKey="calendar.irregular" />
								</xform:radio>
								</td>
								<td style="border: none;">
									<!-- 每年 -->
									<div style="height: 22px;vertical-align: middle;">
										<select id="periodTypeYear_Month" onChange="MonthOrDaySelectChange('1', 'periodTypeYear_Month', 'periodTypeYear_Day', true);"></select><bean:message key="resource.period.type.month.name" />
										<select id="periodTypeYear_Day" onChange="MonthOrDaySelectChange('1','periodTypeYear_Month', 'periodTypeYear_Day', false);"></select><bean:message key="resource.period.type.day.name" />
									</div>
									<!-- 每季 -->
									<div style="height: 22px;vertical-align: middle;">
										<select id="periodTypeQuarter_Month" onChange="MonthOrDaySelectChange('2', 'periodTypeQuarter_Month', 'periodTypeQuarter_Day');"></select>
										<select id="periodTypeQuarter_Day" onChange="MonthOrDaySelectChange('2', 'periodTypeQuarter_Month', 'periodTypeQuarter_Day');"></select><bean:message key="resource.period.type.day.name" />
									</div>
									<!-- 每月 -->
									<div style="height: 22px;vertical-align: middle;">
										<select id="periodTypeMonth_Day" onChange="DaySelectChange('3', this.value)"></select><bean:message key="resource.period.type.day.name" />
									</div>
									<!-- 每周 -->
									<div style="height: 22px;vertical-align: middle;">
										<select id="periodTypeWeek_Day" onChange="DaySelectChange('4', this.value)"></select>
									</div>
									<!-- 不定期 -->
									<div style="height: 18px;vertical-align: middle;">
										&nbsp;
									</div>
									<script src="holdtime.js"></script>
									<script>
										// 初始化下拉列表
										function InitSelect() {
											var sPeriodType = "${kmImeetingTemplateForm.fdPeriodType}";
											var aHoldTime = "${kmImeetingTemplateForm.fdHoldTime}".split("-");
											// 每年
											SetSelect(document.getElementById("periodTypeYear_Month"), 12);
											SetDaySelect(document.getElementById("periodTypeYear_Day"), document.getElementById("periodTypeYear_Month").value);
											// 每季
											SetQuarterMonthSelect(document.getElementById("periodTypeQuarter_Month"));
											SetSelect(document.getElementById("periodTypeQuarter_Day"), 31);
											// 每月
											SetSelect(document.getElementById("periodTypeMonth_Day"), 31);
											// 每周
											SetWeekSelect(document.getElementById("periodTypeWeek_Day"));
											// 设置选择项
											switch(sPeriodType) {
												case "1":
													SetSelected(document.getElementById("periodTypeYear_Month"), aHoldTime[0]);
													SetSelected(document.getElementById("periodTypeYear_Day"), aHoldTime[1]);
													$("#notifyDayDiv").show();
													break;
												case "2":
													SetSelected(document.getElementById("periodTypeQuarter_Month"), aHoldTime[0]);
													SetSelected(document.getElementById("periodTypeQuarter_Day"), aHoldTime[1]);
													$("#notifyDayDiv").show();
													break;
												case "3":
													// aHoldTime[0]为“00”
													SetSelected(document.getElementById("periodTypeMonth_Day"), aHoldTime[1]);
													$("#notifyDayDiv").show();
													break;
												case "4":
													// aHoldTime[0]为“00”
													SetSelected(document.getElementById("periodTypeWeek_Day"), aHoldTime[1]);
													$("#notifyDayDiv").show();
													break;
												case "5":
													// 不定期不显示提前通知天数
													$("#notifyDayDiv").hide();
													break;
												default:
											}
										}
										Com_AddEventListener(window, "load", InitSelect);
									</script>
								</td>
							</tr>
						</table>
						<!-- 催办 -->
						<div id="notifyDayDiv" class="description_txt" style="display: none;">
							<br />
							<bean:message bundle="km-imeeting" key="kmImeetingTemplate.fdNotifyDay.tip1" />
							<xform:text property="fdNotifyDay" showStatus="edit" style="width:30px" />
							<bean:message bundle="km-imeeting" key="kmImeetingTemplate.fdNotifyDay.tip2" />
						</div>
					</td>
				</tr>
				<tr>
					<%--组织人--%>
					<td class="td_normal_title" width=15%>
						<bean:message bundle="km-imeeting" key="kmImeetingTemplate.fdEmcee"/>
					</td>
					<td width="35%">
						<xform:address propertyId="fdEmceeId" propertyName="fdEmceeName" orgType="ORG_TYPE_PERSON" style="width:85%" validators="validateFdEmcee"/>
					</td>
					<%--组织部门--%>
					<td class="td_normal_title" width=15%>
						<bean:message bundle="km-imeeting" key="kmImeetingTemplate.docDept"/>
					</td>
					<td width="35%">
						<xform:address propertyId="docDeptId" propertyName="docDeptName" orgType="ORG_TYPE_DEPT" style="width:85%" />
					</td>
				</tr>
				<tr>
					<%--纪要录入人--%>
					<td class="td_normal_title" width=15%>
						<bean:message bundle="km-imeeting" key="kmImeetingTemplate.fdSummaryInputPerson"/>
					</td>
					<td width="85%" colspan="3">
						<xform:address propertyId="fdSummaryInputPersonId" propertyName="fdSummaryInputPersonName" orgType="ORG_TYPE_PERSON" style="width:34%" />
					</td>
				</tr>
			</table>
		</td>
	</tr>
	<%-- 会议主文档流程 --%>
	<c:import url="/sys/workflow/include/sysWfTemplate_edit.jsp"
		charEncoding="UTF-8">
		<c:param name="formName" value="kmImeetingTemplateForm" />
		<c:param name="fdKey" value="ImeetingMain" />
		<c:param name="messageKey" value="km-imeeting:kmImeetingTemplate.mainflow" />
	</c:import>
	<%-- 纪要模板 --%>	
	<tr LKS_LabelName="<bean:message  bundle="km-imeeting" key="kmImeetingTemplate.fdSummaryContent"/>">
		<td>
			<table class="tb_normal" width=100%>
				<tr>
					<td class="td_normal_title" width=15%>
						<bean:message bundle="km-imeeting" key="kmImeetingTemplate.fdSummaryContent" /></td>
					<td colspan="3">
						<kmss:editor property="fdSummaryContent" height="300" width="100%" />
					</td>
				</tr>
			</table>
		</td>
	</tr>
	<%-- 会议纪要流程 --%>
	<c:import url="/sys/workflow/include/sysWfTemplate_edit.jsp"
		charEncoding="UTF-8">
		<c:param name="formName" value="kmImeetingTemplateForm" />
		<c:param name="fdKey" value="ImeetingSummary" />
		<c:param name="messageKey" value="km-imeeting:kmImeetingTemplate.summaryTemplate" />
	</c:import>
	<%--发布 --%>
	<c:import url="/sys/news/include/sysNewsPublishCategory_edit.jsp"	charEncoding="UTF-8">
			<c:param name="formName" value="kmImeetingTemplateForm" />
			<c:param name="fdKey" value="ImeetingMain" />
	</c:import>
	<%--权限 --%>
	<tr LKS_LabelName="<bean:message bundle="sys-right" key="right.moduleName" />">
		<td>
			<table class="tb_normal" width=100%>
				<c:import url="/sys/right/tmp_right_edit.jsp" charEncoding="UTF-8">
					<c:param name="formName" value="kmImeetingTemplateForm" />
					<c:param name="moduleModelName" value="com.landray.kmss.km.imeeting.model.KmImeetingTemplate" />
				</c:import>
			</table>
		</td>
	</tr>
	<%--编号机制 --%>
	<c:import url="/sys/number/include/sysNumberMappTemplate_edit.jsp" charEncoding="UTF-8">
    	<c:param name="formName" value="kmImeetingTemplateForm" />
   		<c:param name="modelName" value="com.landray.kmss.km.imeeting.model.KmImeetingMain"/>
    </c:import>
    <%--日程机制(普通模块) 开始--%>
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
						<xform:enumsDataSource enumsType="kmImeetingMain_syncDataToCalendarTime" />
					</xform:radio>
				</td>
			</tr>
			<tr>
				<td colspan="4" style="padding: 0px;">
					 <c:import url="/sys/agenda/include/sysAgendaCategory_general_edit.jsp"	charEncoding="UTF-8">
						<c:param name="formName" value="kmImeetingTemplateForm" />
						<c:param name="fdKey" value="ImeetingMain" />
						<c:param name="fdPrefix" value="sysAgendaCategory_formula_edit" />
						<c:param name="fdMainModelName" value="com.landray.kmss.km.imeeting.model.KmImeetingMain" />
						<%--可选字段 1.syncTimeProperty:同步时机字段； 2.noSyncTimeValues:当syncTimeProperty为此值时，隐藏同步机制 --%>
						<c:param name="syncTimeProperty" value="syncDataToCalendarTime" />
						<c:param name="noSyncTimeValues" value="noSync" />
					</c:import>
				</td>
			</tr>
		</table>
	  </td>
	</tr>
</table>
</center>
<html:hidden property="fdId" />
<html:hidden property="method_GET" />
<script>
	Com_IncludeFile("dialog.js|jquery.js");
	var validation=$KMSSValidation();
</script>
<script>
	//判断是否为整数
	function isInteger(str) {
		var type= "^\s*[+]?[0-9]+\s*$";
		var re = new RegExp(type);
		if(str.match(re) != null) {
			return true;
		}
		return false;
	}
	
	//#9205自定义校验器:当模板中召开周期选择 非不定期时，要求会议组织人必填
	validation.addValidator('validateFdEmcee','<bean:message bundle="km-imeeting" key="kmImeetingTemplate.validate.fdEmcee" />',function(v, e, o){
		if(!document.getElementsByName("fdPeriodType")[4].checked && (v==null || v=="")){
			return false;
		}
		return true;
	});
	
	$('[name="fdPeriodType"]').bind("change",function(){
		validation.validate(document.getElementsByName("fdEmceeName")[0]);
	});
	
	//提交表单
	function commitMethod(form,method){
		var msg = '';
		// 不定期不验证
		if (!document.getElementsByName("fdPeriodType")[4].checked) {
			var notifyDay = document.getElementsByName("fdNotifyDay")[0].value;
			if(notifyDay == '') {
				// 催办时间不能为空
				msg += '<bean:message key="errors.required" argKey0="km-imeeting:kmImeetingTemplate.fdNotifyDay" />' + '\r\n';
			} else {
				if (!isInteger(notifyDay)) {
					// 催办时间必须为正整数
					msg += '<bean:message bundle="km-imeeting" key="kmImeetingTemplate.errors.positive.integer" argKey0="kmImeetingTemplate.fdNotifyDay" />' + '\r\n';
				}
			}
		}
		if (msg != '') {
			alert(msg);
		}else{
			Com_Submit(form, method);
		}
	}
</script>
	
</html:form>
<%@ include file="/resource/jsp/edit_down.jsp"%>