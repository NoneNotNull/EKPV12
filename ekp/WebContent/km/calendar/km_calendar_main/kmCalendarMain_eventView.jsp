<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<template:include ref="default.view" sidebar="auto">
	<%--页签--%>
	<template:replace name="title">
		<c:out value="${kmCalendarMainForm.docSubject}-${ lfn:message('km-calendar:module.km.calendar')}"></c:out>
	</template:replace>
	<%--导航路径--%>	
	<template:replace name="path"> 
		<ui:menu layout="sys.ui.menu.nav"> 
			<ui:menu-item text="${ lfn:message('home.home') }" icon="lui_icon_s_home" href="/" target="_self">
			</ui:menu-item>
			<ui:menu-item text="${ lfn:message('km-calendar:module.km.calendar') }" href="/km/calendar/" target="_self">
			</ui:menu-item>
		</ui:menu>
	</template:replace>
	<%--内容--%>	
	<template:replace name="content">
		<html:form action="/km/calendar/km_calendar_main/kmCalendarMain.do" styleId="eventform">
		<div class="lui_form_content_frame">
			<p class="lui_form_subject">
				<bean:message bundle="km-calendar" key="table.kmCalendarMain" />
			</p>
			<table id="event_base_tb" class="tb_normal" width="100%">
				<tr>
	     		<%--日历--%>
	              <td width="15%" class="td_normal_title" >
	              		日历
	              </td>
	           	  <td width="35%" >
	              		<c:out value="${kmCalendarMainForm.labelName}"></c:out>
	              </td>
	              <%--所有者--%>
	              <td width="15%" class="td_normal_title" >
	              		<bean:message bundle="km-calendar" key="kmCalendarMain.docOwner"/>
	              </td>
	              <td width="35%" >
	              		<c:out value="${kmCalendarMainForm.docOwnerName}"></c:out>
						<c:if test="${creatorName!=null}">
							<bean:message bundle="km-calendar" key="kmCalendarMain.docCreator"/>：
							<span style="font-weight:bold;">${creatorName}</span>
						</c:if>
	              	</td>
	         	</tr>
	         	<tr>
	     			<%--内容--%>
	             	<td width="15%" class="td_normal_title" valign="top">
	             		<bean:message bundle="km-calendar" key="kmCalendarMain.docContent" />
	              	</td>
	               	<td width="85%" colspan="3">
	                 	<xform:textarea property="docSubject"  style="width:90%"/>
	              	</td>
	         	</tr>
	         	<tr>
	         		<%--是否全天--%>
	            	<td width="15%" class="td_normal_title" >
	               		是否全天
	           		</td>
	            	<td width="35%" >
	            		<c:if test="${kmCalendarMainForm.fdIsAlldayevent =='true' }">
	            			<bean:message key="message.yes" />
	            		</c:if>
	            		<c:if test="${kmCalendarMainForm.fdIsAlldayevent =='false' }">
	            			<bean:message key="message.no" />
	            		</c:if>
	            	</td>
	            	<%--是否农历--%>
	            	<td width="15%" class="td_normal_title" >
	               		<bean:message bundle="km-calendar" key="kmCalendarMain.fdIsLunar"/>
	           		</td>
	            	<td width="35%" >
	            		<c:if test="${kmCalendarMainForm.fdIsLunar =='true' }">
	            			<bean:message key="message.yes" />
	            		</c:if>
	            		<c:if test="${kmCalendarMainForm.fdIsLunar =='false' }">
	            			<bean:message key="message.no" />
	            		</c:if>
	            	</td>
	            </tr>
	            <tr>
	     			<%--时间--%>
	             	<td width="15%" class="td_normal_title" valign="top">
	             		<bean:message bundle="km-calendar" key="kmCalendarMain.docContent" />
	              	</td>
	               	<td width="85%" colspan="3">
	               		<c:if test="${kmCalendarMainForm.fdIsAlldayevent =='true' }">
	               			<xform:datetime property="docStartTime" dateTimeType="date"></xform:datetime>至<xform:datetime property="docFinishTime" dateTimeType="date"></xform:datetime>
	               		</c:if>
	               		<c:if test="${kmCalendarMainForm.fdIsAlldayevent =='false' }">
	               			<xform:datetime property="docStartTime" dateTimeType="datetime"></xform:datetime>至<xform:datetime property="docFinishTime" dateTimeType="datetime"></xform:datetime>
	               		</c:if>
	              	</td>
	         	</tr>
	         	<tr id="tr_recurrence" >
					<%--重复类型--%>
	            	<td width="15%" class="td_normal_title" >
	            		重复类型
	            	</td>
	            	<td colspan="3">
	            		<xform:select property="RECURRENCE_FREQ">
							<xform:enumsDataSource enumsType="km_calendar_recurrence_freq" />
						</xform:select>
	            	</td>
	            </tr>
	            <c:if test="${kmCalendarMainForm.RECURRENCE_FREQ_LUNAR !='NO'||kmCalendarMainForm.RECURRENCE_FREQ!='NO' }">
	            	<%--重复频率--%>
            		<tr>
            			<td width="15%" class="td_normal_title" >重复信息</td>
		             	<td colspan="3">
		             		<c:out value="${kmCalendarMainForm.RECURRENCE_SUMMARY}" />
		             	</td>
            		</tr>
	            </c:if>
	         	<tr>
	           		<%--提醒设置--%>
	           	   <td width="15%" class="td_normal_title"  valign="top">提醒设置</td>
		           <td colspan="3"  style="padding: 0px;">
						<c:import url="/sys/notify/import/sysNotifyRemindMain_view.jsp" charEncoding="UTF-8">
						    <c:param name="formName" value="kmCalendarMainForm" />
					         <c:param name="fdKey" value="kmCalenarMainDoc" />
					         <c:param name="fdPrefix" value="event" />
					    </c:import>
					</td>
	           	</tr>
	          	<tr>
	            	<%--关联URL--%>
	            	<td width="15%" class="td_normal_title">关联URL</td>
	            	<td colspan="3">
	            		<xform:text property="fdRelationUrl" style="width:90%"/>
	            	</td>
	            </tr>
	            <tr>
	            	<%--地点--%>
	            	<td width="15%" class="td_normal_title" >地点</td>
	            	<td colspan="3">
	            		<xform:text property="fdLocation" style="width:90%"/>
	            	</td>
	            </tr>
	            <tr>
	            	<%--活动性质--%>
	            	<td width="15%" class="td_normal_title" >活动性质</td>
	            	<td>
	            		<xform:radio property="fdAuthorityType">
							<xform:enumsDataSource enumsType="km_calendar_fd_authority_type" />
						</xform:radio>
	            	</td>
	            </tr>
	           <tr>
	            	<%--可阅读者--%>
					<td width="15%" class="td_normal_title">
						可阅读者
					</td>
					<td width="85%" colspan="3">
						<xform:address propertyId="authReaderIds" propertyName="authReaderNames" orgType="ORG_TYPE_ALL" mulSelect="true"  textarea="true"  style="width:90%" ></xform:address>
						<br>
					</td>
				</tr>
				 <tr>
				 	<%--可编辑者--%>
				 	<td width="15%" class="td_normal_title">
						可编辑者
					</td>
					<td width="85%" colspan="3">
						<xform:address propertyId="authEditorIds" propertyName="authEditorNames" orgType="ORG_TYPE_ALL" mulSelect="true"  textarea="true"  style="width:90%" ></xform:address>
						<br>
					</td>
				 </tr>
			</table>
		</div>
		</html:form>
	</template:replace>
</template:include>
<script>
	seajs.use(['lui/jquery'], function($) {
		$(":input").attr("disabled",true);
	});
</script>