<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<template:include ref="default.view" sidebar="no">
	<%--页签名--%>
	<template:replace name="title">
		<c:out value="${lfn:message('km-imeeting:kmImeeting.tree.uploadAtt') } - ${ lfn:message('km-imeeting:module.km.imeeting') }"></c:out>
	</template:replace>
	
	<template:replace name="toolbar">
		<ui:toolbar id="toolbar" layout="sys.ui.toolbar.float"> 
			<%--编辑--%>
			<c:if test="${canUpload==true }">
				<ui:button text="${lfn:message('button.edit')}"  
					onclick="Com_OpenWindow('kmImeetingMain.do?method=editUpdateAtt&fdId=${param.fdId}','_self');" order="2">
				</ui:button>
			</c:if>
			<%--关闭--%>
			<ui:button text="${lfn:message('button.close')}" order="5" onclick="Com_CloseWindow();">
			</ui:button>
		</ui:toolbar>
	</template:replace>
	
	<template:replace name="path">
		<ui:menu layout="sys.ui.menu.nav"  id="categoryId"> 
			<ui:menu-item text="${ lfn:message('home.home') }" icon="lui_icon_s_home"></ui:menu-item>
			<ui:menu-item text="${ lfn:message('km-imeeting:module.km.imeeting') }" href="/km/imeeting/index.jsp" target="_self"></ui:menu-item>
			<ui:menu-item text="${lfn:message('km-imeeting:kmImeeting.tree.uploadAtt') }" href="/km/imeeting/km_imeeting_uploadAtt/index.jsp" target="_self"></ui:menu-item>
		</ui:menu>
	</template:replace>
	
	
	<template:replace name="content"> 
		<style>
			#TABLE_DocList .upload_list_filename_view{
				width: 150px!important;
			}
		</style>
		<html:form action="/km/imeeting/km_imeeting_main/kmImeetingMain.do">
			<html:hidden property="fdId" />
			<div class="lui_form_content_frame" >
				<%--上会材料--%>
				<p class="lui_form_subject">
					<bean:message bundle="km-imeeting" key="kmImeeting.tree.uploadAtt" />
				</p>
				<table class="tb_normal" width=100%>
					<tr>
						<%--会议名称--%>
						<td class="td_normal_title" width=15%>
							<bean:message  bundle="km-imeeting" key="kmImeetingMain.fdName"/>
						</td>
						<td width=85% colspan="3"> 
							<c:out value="${kmImeetingMainForm.fdName}"/>
						</td>
					</tr>
					<tr>
						<%--召开时间--%>
						<td class="td_normal_title" width=15%>
							<bean:message  bundle="km-imeeting" key="kmImeetingMain.fdDate"/>
						</td>
						<td width=85% colspan="3"> 
							<xform:datetime property="fdHoldDate" dateTimeType="datetime"></xform:datetime>~
							<xform:datetime property="fdFinishDate" dateTimeType="datetime"></xform:datetime>
						</td>
					</tr>
					<tr>
						<%--地点--%>
						<td class="td_normal_title" width=15%>
							<bean:message  bundle="km-imeeting" key="kmImeetingMain.fdPlace"/>
						</td>
						<td width=85% colspan="3"> 
							<c:out value="${kmImeetingMainForm.fdPlaceName}"/>
						</td>
					</tr>
					<tr>
						<%--主持人--%>
						<td class="td_normal_title" width=15%>
							<bean:message  bundle="km-imeeting" key="kmImeetingMain.fdHost"/>
						</td>
						<td width=85% colspan="3"> 
							<c:out value="${kmImeetingMainForm.fdHostName}"/>
						</td>
					</tr>
					<tr>
						<%--明细--%>
						<td colspan="4">
							<script>Com_IncludeFile("doclist.js");</script>
							<table class="tb_normal" width=100% id="TABLE_DocList" align="center">
								<tr align="center">
									<%--序号--%> 
									<td class="td_normal_title" style="width: 3%">
										<bean:message key="page.serial"/>
									</td>
									<%--会议议题--%> 
									<td class="td_normal_title" style="width: 11%">
										<bean:message bundle="km-imeeting" key="kmImeetingAgenda.docSubject"/>
									</td>
									<%--汇报人--%> 
									<td class="td_normal_title" style="width: 5%">
										<bean:message bundle="km-imeeting" key="kmImeetingAgenda.docReporter"/>
									</td>
									<%--汇报时间（分钟）--%> 
									<td class="td_normal_title" style="width: 6%">
										<bean:message bundle="km-imeeting" key="kmImeetingAgenda.docReporterTime"/>
									</td>
									<%--上会所需材料--%> 
									<td class="td_normal_title" style="width: 12%">
										<bean:message bundle="km-imeeting" key="kmImeetingAgenda.attachmentName"/>
									</td>
									<%--材料负责人--%> 
									<td class="td_normal_title" style="width: 7%">
										<bean:message bundle="km-imeeting" key="kmImeetingAgenda.docRespons"/>
									</td>
									<%--上会所需材料--%> 
									<td class="td_normal_title" style="width: 38%">
										<bean:message bundle="km-imeeting" key="kmImeetingAgenda.attachment.submit"/>
									</td>
								</tr>
								<c:forEach items="${kmImeetingMainForm.kmImeetingAgendaForms}"  var="kmImeetingAgendaItem" varStatus="vstatus">
									<c:if test="${kmImeetingAgendaItem.docResponsId==currentUser.fdId  or isAdmin==true}">
									<tr KMSS_IsContentRow="1" align="center">
										<td width="3%">
											${vstatus.index+1}
										</td>
										<td width=12%>
											<xform:text property="kmImeetingAgendaForms[${vstatus.index}].docSubject" />
										</td>
										<td width=6%>
											<xform:text property="kmImeetingAgendaForms[${vstatus.index}].docReporterName" />
										</td>
										<td width=5%>
											<xform:text property="kmImeetingAgendaForms[${vstatus.index}].docReporterTime" />
											<c:if test="${not empty kmImeetingMainForm.kmImeetingAgendaForms[vstatus.index].docReporterTime }">
												<bean:message key="date.interval.minute"/>
											</c:if>
										</td>
										<td width=12%>
											<xform:text property="kmImeetingAgendaForms[${vstatus.index}].attachmentName" />
										</td>
										<td width=6%>
											<xform:text property="kmImeetingAgendaForms[${vstatus.index}].docResponsName" />
										</td>
										<%--上会所需材料--%> 
										<td style="width: 38%" align="left">
											<c:import url="/sys/attachment/sys_att_main/sysAttMain_view.jsp" charEncoding="UTF-8">
												<c:param name="fdKey" value="ImeetingUploadAtt_${kmImeetingAgendaItem.fdId }" />
												<c:param name="fdModelName" value="com.landray.kmss.km.imeeting.model.KmImeetingMain" />
												<c:param name="fdModelId" value="${param.fdId }" />
											</c:import>
										</td>
									</tr>
									</c:if>
								</c:forEach>
							</table>
						</td>
					</tr>
				</table>
			</div>
		</html:form>
	</template:replace>
</template:include>