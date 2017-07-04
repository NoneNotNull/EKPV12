<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="/WEB-INF/kmss-xform.tld" prefix="xform"%>
<%@ include file="/resource/jsp/view_top.jsp"%>
<script>Com_IncludeFile("data.js");</script>
<script>
	function confirmDelete(msg){
	var del = confirm('<bean:message key="page.comfirmDelete"/>');
	return del;
}
</script>
<div id="optBarDiv">
	<kmss:auth requestURL="/km/imeeting/km_imeeting_template/kmImeetingTemplate.do?method=edit&fdId=${param.fdId}" requestMethod="GET">
		<input type="button"
			value="<bean:message key="button.edit"/>"
			onclick="Com_OpenWindow('kmImeetingTemplate.do?method=edit&fdId=${param.fdId}','_self');">
	</kmss:auth>
	<kmss:auth requestURL="/km/imeeting/km_imeeting_template/kmImeetingTemplate.do?method=delete&fdId=${param.fdId}" requestMethod="GET">
		<input type="button"
			value="<bean:message key="button.delete"/>"
			onclick="if(!confirmDelete())return;Com_OpenWindow('kmImeetingTemplate.do?method=delete&fdId=${param.fdId}','_self');">
	</kmss:auth>
	<input type="button"
		value="<bean:message key="button.close"/>"
		onclick="Com_CloseWindow();">
</div>

<p class="txttitle"><bean:message bundle="km-imeeting" key="table.kmImeetingTemplate.card"/></p>

<center>
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
					<c:out value="${kmImeetingTemplateForm.docCategoryName}" />
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
					<xform:address textarea="true"  propertyId="authReaderIds" propertyName="authReaderNames" orgType="ORG_TYPE_ALL" style="width:85%" />
				</td>
			</tr>
			<tr>
				<%--可维护者--%>
				<td class="td_normal_title" width=15%>
					<bean:message bundle="km-imeeting" key="kmImeetingTemplate.authEditors"/>
				</td>
				<td width="85%" colspan="3">
					<xform:address textarea="true"  propertyId="authEditorIds" propertyName="authEditorNames" orgType="ORG_TYPE_ALL" style="width:85%" />
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
							<xform:radio property="fdPeriodType" alignment="V" showStatus="readOnly" onValueChange="PeriodTypeChick" style="height: 22px;vertical-align: middle;">
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
									<select id="periodTypeYear_Month" onChange="MonthOrDaySelectChange('1', 'periodTypeYear_Month', 'periodTypeYear_Day', true);" disabled="disabled"></select><bean:message key="resource.period.type.month.name" />
									<select id="periodTypeYear_Day" onChange="MonthOrDaySelectChange('1','periodTypeYear_Month', 'periodTypeYear_Day', false);" disabled="disabled"></select><bean:message key="resource.period.type.day.name" />
								</div>
								<!-- 每季 -->
								<div style="height: 22px;vertical-align: middle;">
									<select id="periodTypeQuarter_Month" onChange="MonthOrDaySelectChange('2', 'periodTypeQuarter_Month', 'periodTypeQuarter_Day');" disabled="disabled"></select>
									<select id="periodTypeQuarter_Day" onChange="MonthOrDaySelectChange('2', 'periodTypeQuarter_Month', 'periodTypeQuarter_Day');" disabled="disabled"></select><bean:message key="resource.period.type.day.name" />
								</div>
								<!-- 每月 -->
								<div style="height: 22px;vertical-align: middle;">
									<select id="periodTypeMonth_Day" onChange="DaySelectChange('3', this.value)" disabled="disabled"></select><bean:message key="resource.period.type.day.name" />
								</div>
								<!-- 每周 -->
								<div style="height: 22px;vertical-align: middle;">
									<select id="periodTypeWeek_Day" onChange="DaySelectChange('4', this.value)" disabled="disabled"></select>
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
												document.getElementById("notifyDayDiv").style.display = "";
												break;
											case "2":
												SetSelected(document.getElementById("periodTypeQuarter_Month"), aHoldTime[0]);
												SetSelected(document.getElementById("periodTypeQuarter_Day"), aHoldTime[1]);
												document.getElementById("notifyDayDiv").style.display = "";
												break;
											case "3":
												// aHoldTime[0]为“00”
												SetSelected(document.getElementById("periodTypeMonth_Day"), aHoldTime[1]);
												document.getElementById("notifyDayDiv").style.display = "";
												break;
											case "4":
												// aHoldTime[0]为“00”
												SetSelected(document.getElementById("periodTypeWeek_Day"), aHoldTime[1]);
												document.getElementById("notifyDayDiv").style.display = "";
												break;
											case "5":
												// 不定期不显示提前通知天数
												document.getElementById("notifyDayDiv").style.display = "none";
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
					<xform:address propertyId="fdEmceeId" propertyName="fdEmceeName" orgType="ORG_TYPE_PERSON" style="width:85%" />
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
					<xform:address propertyId="fdSummaryInputPersonId" propertyName="fdSummaryInputPersonName" orgType="ORG_TYPE_PERSON" style="width:85%" />
				</td>
			</tr>
			<tr><td colspan="4">&nbsp;</td></tr>
			<tr>
				<%--创建者--%>
				<td class="td_normal_title" width=15%>
					<bean:message bundle="km-imeeting" key="kmImeetingTemplate.docCreatorId"/>
				</td>
				<td width="35%">
					<c:out value="${kmImeetingTemplateForm.docCreatorName }" />
				</td>
				<%--创建时间--%>
				<td class="td_normal_title" width=15%>
					<bean:message bundle="km-imeeting" key="kmImeetingTemplate.docCreateTime"/>
				</td>
				<td width="35%">
					<c:out value="${kmImeetingTemplateForm.docCreateTime }" />
				</td>
			</tr>
			<tr>
				<%--修改者--%>
				<td class="td_normal_title" width=15%>
					<bean:message bundle="km-imeeting" key="kmImeetingTemplate.docAlterId"/>
				</td>
				<td width="35%">
					<c:out value="${kmImeetingTemplateForm.docAlterorName }" />
				</td>
				<%--修改时间--%>
				<td class="td_normal_title" width=15%>
					<bean:message bundle="km-imeeting" key="kmImeetingTemplate.docAlterTime"/>
				</td>
				<td width="35%">
					<c:out value="${kmImeetingTemplateForm.docAlterTime }" />
				</td>
			</tr>
		</table>
		</td>
	</tr>
	<%-- 会议主文档--%>
	<c:import url="/sys/workflow/include/sysWfTemplate_view.jsp" charEncoding="UTF-8">
		<c:param name="formName" value="kmImeetingTemplateForm" />
		<c:param name="fdKey" value="ImeetingMain" />
		<c:param name="messageKey" value="km-imeeting:kmImeetingTemplate.mainflow" />
	</c:import>
	<%-- 纪要模板--%>	
	<tr LKS_LabelName="<bean:message  bundle="km-imeeting" key="kmImeetingTemplate.fdSummaryContent"/>">
		<td>
		<table class="tb_normal" width=100%>
			<tr>
				<td class="td_normal_title" width=15%>
					<bean:message  bundle="km-imeeting" key="kmImeetingTemplate.fdSummaryContent"/>
				</td>
				<td colspan="3">
					<c:out value="${kmImeetingTemplateForm.fdSummaryContent}" />
				</td>
			</tr>
		</table>
		</td>
	</tr>
	<%-- 纪要流程--%>	
	<c:import url="/sys/workflow/include/sysWfTemplate_view.jsp" charEncoding="UTF-8">
		<c:param name="formName" value="kmImeetingTemplateForm" />
		<c:param name="fdKey" value="ImeetingSummary" />
		<c:param name="messageKey" value="km-imeeting:kmImeetingTemplate.summaryTemplate" />
	</c:import>
	<!--发布机制-->
	<c:import url="/sys/news/include/sysNewsPublishCategory_view.jsp" charEncoding="UTF-8">
		<c:param name="formName" value="kmImeetingTemplateForm" />
		<c:param name="fdKey" value="ImeetingMain" />
	</c:import>
	<%-- 权限--%>	
	<tr LKS_LabelName="<bean:message bundle="sys-right" key="right.moduleName" />">
		<td>
			<table class="tb_normal" width=100%>
				<c:import  url="/sys/right/tmp_right_view.jsp" charEncoding="UTF-8">
					<c:param name="formName" value="kmImeetingTemplateForm" />
					<c:param name="moduleModelName" value="com.landray.kmss.km.imeeting.model.KmImeetingTemplate" />
				</c:import>
			</table>
		</td>
	</tr>
	<c:import url="/sys/number/include/sysNumberMappTemplate_view.jsp" charEncoding="UTF-8">
		<c:param name="formName" value="kmImeetingTemplateForm" />
	    <c:param name="modelName" value="com.landray.kmss.km.imeeting.model.KmImeetingMain"/>
	 </c:import>
	 <!--日程机制(普通模块) 开始-->
	<tr LKS_LabelName="<bean:message bundle="sys-agenda" key="module.sys.agenda.syn" />">
	  <td>
		  <table class="tb_normal" width=100%>
		  	<tr>
				<td class="td_normal_title" width=15%>
			       <bean:message bundle="sys-agenda" key="module.sys.agenda.syn.time" />
				</td>
			    <td>
			    	<xform:radio property="syncDataToCalendarTime" >
						<xform:enumsDataSource enumsType="kmImeetingMain_syncDataToCalendarTime" />
					</xform:radio>
			    </td>
			</tr>
			<tr>
				<td colspan="4" style="padding: 0px;">
					 <c:import url="/sys/agenda/include/sysAgendaCategory_general_view.jsp"	charEncoding="UTF-8">
						<c:param name="formName" value="kmImeetingTemplateForm" />
						<c:param name="fdKey" value="ImeetingMain" />
						<c:param name="fdPrefix" value="sysAgendaCategory_formula_view" />
						<%--可选字段 1.syncTimeProperty:同步时机字段； 2.noSyncTimeValues:当syncTimeProperty为此值时，隐藏同步机制 --%>
						<c:param name="syncTimeProperty" value="syncDataToCalendarTime" />
						<c:param name="noSyncTimeValues" value="noSync" />
					</c:import>
				</td>
			</tr>
		  </table>
	  </td>
	</tr>
	<!--日程机制(普通模块)  结束-->
</table>
</center>
<%@ include file="/resource/jsp/view_down.jsp"%>