<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page
	import="com.landray.kmss.tib.jdbc.forms.TibJdbcTaskManageForm,
	com.landray.kmss.sys.quartz.scheduler.CronExpression,
	java.util.Date,
	com.landray.kmss.util.DateUtil"%>
<%@ taglib uri="/WEB-INF/kmss-xform.tld" prefix="xform"%>
<%@ include file="/resource/jsp/view_top.jsp"%>
<%
TibJdbcTaskManageForm tibJdbcTaskManageForm = (TibJdbcTaskManageForm)request.getAttribute("tibJdbcTaskManageForm");
%>
<script>
Com_IncludeFile("doclist.js|jquery.js|json2.js|dialog.js");
	function confirmDelete(msg){
	var del = confirm("<bean:message key="page.comfirmDelete"/>");
	return del;
}
</script>
<div id="optBarDiv"><c:if
	test="${not empty tibJdbcTaskManageForm.fdQuartzEkp}">
	<input type="button"
		value="<bean:message bundle="tib-jdbc" key="tibJdbcTaskManage.button.run"/>"
		onClick="Com_OpenWindow('<c:url value="/tib/jdbc/tib_jdbc_task_manage/tibJdbcTaskManage.do"/>?method=run&fdId=${tibJdbcTaskManageForm.fdQuartzEkp}','_self');">
</c:if>
 
<input type="button"
		value="转运数据"
		onClick="Com_OpenWindow('<c:url value="/tib/jdbc/tib_jdbc_task_manage/tibJdbcTaskManage.do"/>?method=transData&fdId=${param.fdId}','_self');">

 <kmss:auth
	requestURL="/tib/jdbc/tib_jdbc_task_manage/tibJdbcTaskManage.do?method=edit&fdId=${param.fdId}"
	requestMethod="GET">
	<input type="button" value="<bean:message key="button.edit"/>"
		onclick="Com_OpenWindow('tibJdbcTaskManage.do?method=edit&fdId=${param.fdId}','_self');">
</kmss:auth> <kmss:auth
	requestURL="/tib/jdbc/tib_jdbc_task_manage/tibJdbcTaskManage.do?method=delete&fdId=${param.fdId}"
	requestMethod="GET">
	<input type="button" value="<bean:message key="button.delete"/>"
		onclick="if(!confirmDelete())return;Com_OpenWindow('tibJdbcTaskManage.do?method=delete&fdId=${param.fdId}','_self');">
</kmss:auth> <input type="button" value="<bean:message key="button.close"/>"
	onclick="Com_CloseWindow();"></div>
<html:messages id="messages" message="true">
	<table style="margin:0 auto" align="center">
		<tr>
			<td>
				<img src='${KMSS_Parameter_ContextPath}resource/style/default/msg/dot.gif'>&nbsp;&nbsp;
				<font color='red'><bean:write name="messages" /></font>
			</td>
		</tr>
	</table><hr />
</html:messages> 
<p class="txttitle"><bean:message bundle="tib-jdbc" key="table.tibJdbcTaskManage" /></p>
<center>
<table id="Label_Tabel" width=95%>
	<tr LKS_LabelName="定时任务信息">
		<td>
		<table class="tb_normal" width=100% id="TB_MainTable">
			<tr>
				<td class="td_normal_title" width=15%><bean:message
					bundle="tib-jdbc" key="tibJdbcTaskManage.fdSubject" /></td>
				<td width="35%">
				    <!-- 是否系统任务  -->
					<c:if test="${tibJdbcTaskManageForm.fdIsSysJob=='true'}">
						<kmss:message key="${tibJdbcTaskManageForm.fdSubject}" />
					</c:if>
	                <c:if test="${tibJdbcTaskManageForm.fdIsSysJob!='true'}">
							  ${tibJdbcTaskManageForm.fdSubject} 
					</c:if>
				</td>
				<td class="td_normal_title" width=15%><bean:message
					bundle="tib-jdbc" key="tibJdbcTaskManage.docCategory" /></td>
				<td width="35%"><c:out
					value="${tibJdbcTaskManageForm.docCategoryName}" /></td>
			</tr>

			<tr>
				<!-- 触发时间 -->
				<td width=15% class="td_normal_title"><bean:message
					bundle="tib-jdbc" key="tibJdbcTaskManage.fdCronExpression" /></td>
				<td width=35%>
					<c:import url="/tib/jdbc/tib_jdbc_task_manage/tibJdbcTaskManage_showCronExpression.jsp" charEncoding="UTF-8">
						<c:param name="value" value="${tibJdbcTaskManageForm.fdCronExpression}" />
					</c:import>
				</td>
				<td width=15% class="td_normal_title">
				<bean:message bundle="tib-jdbc" key="tibJdbcMappManage.nextTime"/>
			</td><td width=35%>
				<%
				if("1".equals(tibJdbcTaskManageForm.getFdIsEnabled())){
					CronExpression expression = new CronExpression(tibJdbcTaskManageForm.getFdTempCronExpression());
					Date nxtTime = expression.getNextValidTimeAfter(new Date());
					if(nxtTime!=null)
						out.write(DateUtil.convertDateToString(nxtTime,DateUtil.TYPE_DATETIME, request.getLocale()));
				}
				%>
			</td>
				
			</tr>


			<tr>
				<!-- 运行类型 -->
				<td class="td_normal_title" width=15%><bean:message
					bundle="tib-jdbc" key="tibJdbcTaskManage.fdRunType" /></td>
				<td width="35%"><sunbor:enumsShow
					value="${tibJdbcTaskManageForm.fdRunType}"
					enumsType="sysQuartzJob_fdRunType" /></td>
					
				<!-- 单次任务 -->
				<td class="td_normal_title"><bean:message bundle="tib-jdbc"
					key="tibJdbcTaskManage.fdJobType" /></td>
				<td>
				<!-- 根据预期运行时间判读是单次运行还是多次 -->
				<sunbor:enumsShow value="${(empty tibJdbcTaskManageForm.fdRunTime)?'false':'true'}" enumsType="common_yesno" /></td>
			</tr>

			<tr>
				<!-- 是否启用 (是否激活)-->
				<td class="td_normal_title"><bean:message bundle="tib-jdbc"
					key="tibJdbcTaskManage.fdIsEnabled" /></td>
				<td><sunbor:enumsShow
					value="${tibJdbcTaskManageForm.fdIsEnabled}"
					enumsType="common_yesno" /></td>

				<!-- 是否系统任务/普通任务 -->
				<td class="td_normal_title"><bean:message bundle="tib-jdbc"
					key="tibJdbcTaskManage.fdIsSysJob" /></td>
				<td><sunbor:enumsShow
					value="${tibJdbcTaskManageForm.fdIsSysJob}"
					enumsType="common_yesno" /></td>
			</tr>

                                               <!-- 预期运行时间 -->
			<c:if test="${not empty tibJdbcTaskManage.fdRunTime}">
				<tr>
					<!-- 是否必须 -->
					<td class="td_normal_title"><bean:message bundle="tib-jdbc"
						key="tibJdbcTaskManage.fdIsRequired" /></td>
					<td><sunbor:enumsShow
						value="${tibJdbcTaskManageForm.fdIsRequired}"
						enumsType="common_yesno" /></td>
					<!-- 是否触发 -->
					<td class="td_normal_title"><bean:message bundle="tib-jdbc"
						key="tibJdbcTaskManage.fdIsTriggered" /></td>
					<td><sunbor:enumsShow
						value="${tibJdbcTaskManageForm.fdIsTriggered}"
						enumsType="common_yesno" /></td>
				</tr>
			</c:if>

			<tr>
				<!-- 任务代码 -->
				<td class="td_normal_title"><bean:message bundle="tib-jdbc"
					key="tibJdbcTaskManage.fdJob" /></td>
				<td colspan="3">
				${tibJdbcTaskManageForm.fdJobService}.${tibJdbcTaskManageForm.fdJobMethod}(${tibJdbcTaskManageForm.fdParameter})
				</td>
			</tr>

			
			<tr>
			<td class="td_normal_title" width=15%>
				<bean:message bundle="tib-jdbc" key="tibJdbcTaskManage.fdLink"/></td>
			 <td colspan="3" id="_fdLink"></td>
		   </tr>

			<tr>
				<td class="td_normal_title"><bean:message bundle="tib-jdbc"
					key="tibJdbcMappManage.fdUseExplain" /></td>
				<td colspan="3">${tibJdbcTaskManageForm.fdUseExplain}</td>
			</tr>
		</table>
		</td>
	</tr>
	<%@ include
		file="/tib/jdbc/tib_jdbc_task_manage/tibJdbcTaskManage_relation_view.jsp"%>
</table>
</center>
<script type="text/javascript">
$(document).ready(function(){
  var fdLink='${tibJdbcTaskManageForm.fdLink}';
  
	if(fdLink!=null && fdLink.length>0){
	  var temp=fdLink.toLocaleLowerCase();
	  var indexNum=temp.indexOf("http://");
	  var hrefValue="";
	  //如果url没有加http://开头,则添加头部
	  if(indexNum==-1){
		  hrefValue="http://"+fdLink;
		}else{
			hrefValue=fdLink;
		}
      var htmlInfor="<a href='"+hrefValue+"' target='_blank' >"+ fdLink+"</a>";
      $("#_fdLink").html(htmlInfor);
   }
});

</script>
<%@ include file="/resource/jsp/view_down.jsp"%>