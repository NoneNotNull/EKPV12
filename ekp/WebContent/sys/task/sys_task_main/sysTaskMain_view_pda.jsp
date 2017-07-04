<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/third/pda/htmlhead.jsp"%>
<link type="text/css" rel="stylesheet" href="<c:url value="/sys/task/css/common.css"/>" />
<link type="text/css" rel="stylesheet" href="<c:url value="/sys/task/css/icon/font-mui.css"/>" />
<script>Com_IncludeFile("jquery.js");</script>
<script>
//显示、隐藏更多设置
function showMoreSet(obj){
	var show=$(obj).attr("data-status")!='1';
	$(obj).attr('data-status', show?'1':'0');
	if(show){
		$(".moreSet").show();//隐藏更多设置
		$("#showMoreSet")
			.html("<bean:message bundle='sys-task' key='sysTaskMain.more.set.slideUp' />")
			.attr("class","task_slideUp");
	}else{
		$(".moreSet").hide();//显示更多设置
		$("#showMoreSet")
			.html("<bean:message bundle='sys-task' key='sysTaskMain.more.set.slideDown' />")
			.attr("class","task_slideDown");
	}
}
</script>
</head>
<body>
	<html:form action="/sys/task/sys_task_main/sysTaskMain.do">
			<div id="div_banner" class="div_banner">
			<script type="text/javascript">
					function gotoList(){
						var hrefUrl="${KMSS_Parameter_ContextPath}sys/task/pda/sysTaskMain_pda_index.jsp";
						if("${ischild}" == "true"){
							hrefUrl = "${KMSS_Parameter_ContextPath}sys/task/sys_task_main/sysTaskMain.do?method=listChildTask&fdTaskId=${sysTaskMainForm.fdParentId}&rowsize=10";
						}
						location=hrefUrl;
					}
				</script>
				<div class="div_return" onclick="gotoList();">
					<div>
						<bean:message bundle="third-pda" key="phone.view.back" />
					</div>
					<div></div>
				</div>
			</div>
		<table class="taskTable" width="100%" id="tbObj">
			<%--标题--%>
			<tr>
				<td   width=30%>
				<div>
					<span class="mui mui-subject mui-1x titleSpan fontColor"></span>
					<div class="titleName"><p><bean:message bundle="sys-task" key="sysTaskMain.docSubject" /></p></div>
				</div>
				</td>
				<td class="td_common title" width=82%>
					<c:out value="${sysTaskMainForm.docSubject}" />
			    </td>
			</tr>
			<%--接收人--%>
			<tr>
				<td   width=30%>
					<div>
						<span class="mui mui-receive mui-1x titleSpan fontColor"></span>
						<div class="titleName"><p><bean:message bundle="sys-task" key="sysTaskMainPerform.fdPerformId" /></p></div>
					</div>
				</td>
				<td class="td_common" width=82%>
					<c:out value="${sysTaskMainForm.fdPerformName}" />
				</td>
			</tr>
			<%--要求完成时间--%>
			<tr>
				<td   width=30%>
				    <div>
				    	<span class="mui mui-cal mui-1x titleSpan fontColor"></span>
						<div class="titleName"><p><bean:message bundle="sys-task" key="sysTaskMain.fdPlanCompleteTime" /></p></div>
					</div>
				</td>
				<td class="td_common" width=82%>
					<c:out value="${sysTaskMainForm.fdPlanCompleteDate}" />&nbsp;<c:out value="${sysTaskMainForm.fdPlanCompleteTime}" />
				</td>
			</tr>
			<%--内容--%>
			<tr>
				<td   width=30%>
				    <div>
				    	<span class="mui mui-content mui-1x titleSpan fontColor"></span>
						<div class="titleName"><p><bean:message bundle="sys-task" key="sysTaskMain.docContent" /></p></div>
					</div>
				</td>
				<td class="td_common" width=82%>
					<c:out value="${sysTaskMainForm.docContent}"   escapeXml="false"/>
				</td>
			</tr>
			<c:if test="${fn:length(sysTaskMainForm.attachmentForms['attachment'].attachments)>0}">
				 <tr>
					<td   width=30% colspan="2">
					  	<bean:message bundle="sys-task" key="sysTaskMain.attachment"/>：<img src="${KMSS_Parameter_ContextPath}third/pda/resource/images/attachment.png"> ${fn:length(sysTaskMainForm.attachmentForms['attachment'].attachments)}<bean:message key="sysAttMain.msg.num" bundle="sys-attachment"/>
					</td>
				</tr>
				<tr>
					<td   width=30% colspan="2">
					   <c:import url="/sys/attachment/pda/sysAttMain_view.jsp" charEncoding="UTF-8">
							<c:param name="fdKey" value="attachment" />
							<c:param name="formBeanName" value="sysTaskMainForm"/>
					   </c:import>
					</td>
				</tr>
			</c:if>
			<tr onclick="Com_OpenWindow('${KMSS_Parameter_ContextPath}sys/task/sys_task_main/sysTaskMain.do?method=childCanvas&fdTaskId=${param.fdId}','_self')">
				<td  colspan="2">
				    <div  class="cateItemData" style="color: #3eb2e6;">
						查看任务分解图
					</div>
				</td>
			</tr>
			<%--指派人--%>
			 <tr style="display:none" class="moreSet">
				<td width=30%>
				    <div>
				    	<span class="mui mui-appoint mui-1x titleSpan fontColor"></span>
						<div class="titleName"><p><bean:message bundle="sys-task" key="sysTaskMain.fdAppoint" /></p></div>
					</div>
				</td>
				<td class="td_common" width=82%>
					<c:out value="${sysTaskMainForm.fdAppointName}" />
				</td>
			</tr>
			<c:if test="${not empty sysTaskMainForm.fdCcNames}">
			<%--抄送人--%>
			 <tr style="display:none" class="moreSet">
				<td   width=30%>
				    <div>
				    	<span class="mui mui-copy mui-1x titleSpan fontColor"></span>
						<div class="titleName"><p><bean:message bundle="sys-task" key="sysTaskMainCc.fdCcId" /></p></div>
					</div>
				</td>
				<td class="td_common" width=82%>
					<c:out value="${sysTaskMainForm.fdCcNames}"  />
				</td>
			</tr>
			</c:if>
			<%--状态--%>
			 <tr style="display:none" class="moreSet">
				<td   width=30%>
				    <div>
				    	<span class="mui mui-status mui-1x titleSpan fontColor"></span>
						<div class="titleName"><p><bean:message bundle="sys-task" key="sysTaskMain.fdStatus" /></p></div>
					</div>
				</td>
				<td class="td_common" width=82%>
					<sunbor:enumsShow value="${sysTaskMainForm.fdStatus}" enumsType="sysTaskMain_fdStatue" />(<c:out value="${sysTaskMainForm.fdProgress}" />%)
				</td>
			</tr>
			<tr style="display:none" class="moreSet" onclick="Com_OpenWindow('${KMSS_Parameter_ContextPath}sys/task/sys_task_main/sysTaskMain.do?method=listChildTask&fdTaskId=${param.fdId}&rowsize=10','_self')">
				<td colspan="2">
					<div  class="cateItemData">
						<bean:message key="tag.childtasks" bundle="sys-task"/><font color="#F19703">(${childTaskcount})</font>
					</div>
				</td>
			</tr>
			<tr style="display:none" class="moreSet" onclick="Com_OpenWindow('${KMSS_Parameter_ContextPath}sys/task/sys_task_feedback/sysTaskFeedback.do?method=list&fdTaskId=${param.fdId}&rowsize=10','_self')">
				<td colspan="2">
					<div  class="cateItemData">
						<bean:message key="tag.feedback" bundle="sys-task"/><font color="#F19703">(${feedbackcount})</font>
					</div>
				</td>
			</tr>
			<tr style="display:none" class="moreSet" onclick="Com_OpenWindow('${KMSS_Parameter_ContextPath}sys/task/sys_task_evaluate/sysTaskEvaluate.do?method=list&fdTaskId=${param.fdId}&rowsize=10','_self')">
				<td colspan="2">
					<div  class="cateItemData">
						<bean:message key="tag.evaluate" bundle="sys-task"/><font color="#F19703">(${evaluatecount})</font>
					</div>
				</td>
			</tr>
			</table>
			<%--展开更多设置--%>
			<center>
				<div class="com_btnBox" style="margin: 10px 0px;">
		    		<a href="javascript:void(0);" onclick="showMoreSet(this);" id="showMoreSet" data-status="0" class="task_slideDown">
						<bean:message bundle="sys-task" key="sysTaskMain.more.set.slideDown" />
					</a>
	    		</div>
			</center>
	</html:form>
	<%--操作按钮：分解子任务、任务评价、任务反馈--%>
	<center>
		<c:import url="/sys/task/pda/extends.jsp" charEncoding="UTF-8">
			<c:param name="isAppflag" value="${KMSS_PDA_ISAPP}" />
			<c:param name="formName" value="sysTaskMainForm" />
		</c:import>
	</center>
	<br/>
</body>
</html>