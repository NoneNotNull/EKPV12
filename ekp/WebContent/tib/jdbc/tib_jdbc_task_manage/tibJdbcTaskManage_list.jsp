<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
	
<%@ page import="
	java.util.Date,
	com.landray.kmss.util.DateUtil,
	com.landray.kmss.util.ResourceUtil" %>
<%@page import="com.landray.kmss.tib.jdbc.model.TibJdbcTaskManage"%>
<%@page import="com.landray.kmss.sys.quartz.scheduler.CronExpression"%>

	
<%@ include file="/resource/jsp/list_top.jsp"%>

<html:form action="/tib/jdbc/tib_jdbc_task_manage/tibJdbcTaskManage.do">
	<div id="optBarDiv">
		<kmss:auth requestURL="/tib/jdbc/tib_jdbc_task_manage/tibJdbcTaskManage.do?method=add">
			<input type="button" value="<bean:message key="button.add"/>"
				onclick="Com_OpenWindow('<c:url value="/tib/jdbc/tib_jdbc_task_manage/tibJdbcTaskManage.do" />?method=add&fdtemplatId=${param.categoryId}');">
		</kmss:auth>
		
		<kmss:auth requestURL="/tib/jdbc/tib_jdbc_task_manage/tibJdbcTaskManage.do?method=chgenabled">
			<input type="button" value="<bean:message bundle="tib-jdbc" key="tibJdbcTaskManage.button.enable"/>"
				onclick="if(confirmEnable('<bean:message bundle="tib-jdbc" key="tibJdbcTaskManage.dialog.comfirmEnable"/>')){
				document.getElementsByName('fdIsEnabled')[0].value=true;
				Com_Submit(document.tibJdbcTaskManageForm, 'chgenabled')
			}"/>
		</kmss:auth>
		
		<kmss:auth requestURL="/tib/jdbc/tib_jdbc_task_manage/tibJdbcTaskManage.do?method=chgenabled">
			<input type="button" value="<bean:message bundle="tib-jdbc" key="tibJdbcTaskManage.button.disable"/>"
				onclick="if(confirmEnable('<bean:message bundle="tib-jdbc" key="tibJdbcTaskManage.dialog.comfirmDisable"/>')){
				document.getElementsByName('fdIsEnabled')[0].value=false;
				Com_Submit(document.tibJdbcTaskManageForm, 'chgenabled')
			}"/>
		</kmss:auth>
		
		<kmss:auth requestURL="/tib/jdbc/tib_jdbc_task_manage/tibJdbcTaskManage.do?method=deleteall">
			<input type="button" value="<bean:message key="button.delete"/>"
				onclick="if(!List_ConfirmDel())return;Com_Submit(document.tibJdbcTaskManageForm, 'deleteall');">
		</kmss:auth>
	</div>
	
<input type="hidden" name="fdIsEnabled">
<c:if test="${queryPage.totalrows==0}">
	<%@ include file="/resource/jsp/list_norecord.jsp"%>
</c:if>
<c:if test="${queryPage.totalrows>0}">
	<%@ include file="/resource/jsp/list_pagenav_top.jsp"%>
	<table id="List_ViewTable">
		<tr>
			<sunbor:columnHead htmlTag="td">
				<td width="10pt">
					<input type="checkbox" name="List_Tongle">
				</td>
				
				<c:if test="${param.sysJob=='0'}">
					<sunbor:column property="tibJdbcTaskManage.fdSubject">
							<bean:message bundle="tib-jdbc" key="tibJdbcTaskManage.fdSubject"/>
					</sunbor:column>
				</c:if>
				<c:if test="${param.sysJob!='0'}">
					<td>
						<bean:message bundle="tib-jdbc" key="tibJdbcTaskManage.fdSubject"/>
					</td>
				</c:if>
				
				<td>
					<bean:message bundle="tib-jdbc" key="tibJdbcTaskManage.fdCronExpression"/>
				</td>
				
				<td>
					<bean:message bundle="tib-jdbc" key="tibJdbcMappManage.nextTime"/>
				</td>
				
				 <td>
					<bean:message bundle="sys-quartz" key="sysQuartzJob.fdRunType"/>
				</td>
				
				<td>
					<bean:message bundle="tib-jdbc" key="tibJdbcTaskManage.button.enable"/>
				</td>
			</sunbor:columnHead>
		</tr>
		
		<logic:iterate id="tibJdbcTaskManage" name="queryPage" property="list" indexId="index" >
			<tr 
				kmss_href="<c:url value="/tib/jdbc/tib_jdbc_task_manage/tibJdbcTaskManage.do?method=view&fdId=${tibJdbcTaskManage.fdId}"/>">
				<td>
					<input type="checkbox" name="List_Selected" value="<bean:write name="tibJdbcTaskManage" property="fdId"/>">
				</td>
				
				<td>
					<%
					TibJdbcTaskManage jobModel = (TibJdbcTaskManage)tibJdbcTaskManage;
						if(jobModel.getFdIsSysJob().booleanValue()){
						    System.out.println("ssss");
							out.print(ResourceUtil.getString(jobModel.getFdSubject(), request.getLocale()));
						}else{
					%>
						<bean:write name="tibJdbcTaskManage" property="fdSubject"/> 
					<%
						}
					%>
				</td>
				
				<!-- 触发时间-->
				<td>
					<c:import url="/tib/jdbc/tib_jdbc_task_manage/tibJdbcTaskManage_showCronExpression.jsp" charEncoding="UTF-8">
						<c:param name="value" value="${tibJdbcTaskManage.fdCronExpression}" />
					</c:import>
				</td>
				
				<!-- 下次运行时间 -->
				<td>
					<%
						if(jobModel.getFdIsEnabled().booleanValue()){
							CronExpression expression = new CronExpression(jobModel.getFdCronExpression());
							Date nxtTime = expression.getNextValidTimeAfter(new Date());
							if(nxtTime!=null)
								out.write(DateUtil.convertDateToString(nxtTime,DateUtil.TYPE_DATETIME, request.getLocale()));
						}
					%>
				</td>
				
				<!-- 运行类型 -->
				<td>
					<sunbor:enumsShow value="${tibJdbcTaskManage.fdRunType}" enumsType="sysQuartzJob_fdRunType" />
				</td>
				
				<!--是否启用 -->
				<td>
				      <sunbor:enumsShow value="${tibJdbcTaskManage.fdIsEnabled}" enumsType="common_yesno" />
				</td>
				
				
			</tr>
		</logic:iterate>
	</table>
	<%@ include file="/resource/jsp/list_pagenav_down.jsp" %>
</c:if>
</html:form>
<script>
function confirmEnable(info){
	return List_CheckSelect() && confirm(info);
}
</script>
<%@ include file="/resource/jsp/list_down.jsp"%>