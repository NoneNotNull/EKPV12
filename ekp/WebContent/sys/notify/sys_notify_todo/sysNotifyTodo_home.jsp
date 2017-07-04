<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/common.jsp"%>	
<%@ include file="/resource/jsp/htmlhead.jsp" %>
<html>
<head>
	<META HTTP-EQUIV="pragma" CONTENT="no-cache">
	<META HTTP-EQUIV="Cache-Control" CONTENT="no-cache">
<link type="text/css" rel="stylesheet" href="${KMSS_Parameter_ContextPath}sys/ui/extend/theme/default/style/portal.css"/>
<script src="${KMSS_Parameter_ResPath}js/domain.js"></script>
<script type="text/javascript">
Com_IncludeFile("document.js", "style/"+Com_Parameter.Style+"/doc/");
Com_IncludeFile("jquery.js");
</script>
</head>
<body style='margin-top:2px;overflow-x:hidden;'>
<c:set var="totalrows" value="${queryPage.totalrows}" />
<c:if test="${param.isShowBtLable!=0}">
<div id='buttonDiv'>
	<nobr>
		<%-- “待审”和“暂挂” --%>
		<input type="button" value='<bean:message bundle="sys-notify" key="sysNotifyTodo.type.toDo" />(${toDoCount})'
			class='<c:choose><c:when test="${param.fdType == 1 || empty param.fdType && empty param.finish}">labelbg1</c:when><c:otherwise>labelbg2</c:otherwise></c:choose>'
			onclick='window.open("<c:url value="/sys/notify/sys_notify_todo/sysNotifyTodo.do?method=list&home=1&rowsize=10&forKK=${param.forKK}" />","_self");'>
		<input type="button" id="notifyBtn2" value='<bean:message bundle="sys-notify" key="sysNotifyTodo.type.toView" />(${toViewCount})'
			class='<c:if test="${param.fdType == 2}">labelbg1</c:if><c:if test="${param.fdType != 2}">labelbg2</c:if>'
			onclick='window.open("<c:url value="/sys/notify/sys_notify_todo/sysNotifyTodo.do?method=list&fdType=2&rowsize=10&home=1&forKK=${param.forKK}" />","_self");'>
		<c:if test='${empty param.forKK }'>
		<input type="button" value='<bean:message bundle="sys-notify" key="sysNotifyTodo.type.done" />'
			class='<c:if test="${param.finish == 1}">labelbg1</c:if><c:if test="${param.finish != 1}">labelbg2</c:if>'
			onclick='window.open("<c:url value="/sys/notify/sys_notify_todo/sysNotifyTodo.do?method=list&finish=1&rowsize=10&home=1" />","_self");'>
		</c:if>
	</nobr>
<div style='font-size:8px'>&nbsp;</div>
</div>
</c:if>
	<div id="contentDiv"  >
<table id='tagContent'>
	<!-- 如果是被KK集成，则显示最后登录时间和IP 苏轶 2010年6月28日 -->
	<c:if test="${param.forKK == 'true' }">
	<tr><td>
	<bean:message bundle="sys-notify" key="sysNotifyTodo.last.login.time" />
	<span style='color:#ff3300'>
	<kmss:showDate value="${lastLoginInfo.fdCreateTime }" type="datetime"></kmss:showDate>
	</span>
	<br>
	<bean:message bundle="sys-notify" key="sysNotifyTodo.last.login.IP" />
	<span style='color:#ff3300'>
	${lastLoginInfo.fdIp }
	</span>
	</td>
	</tr>
	<tr><td style='font-size:8px'>&nbsp;</td></tr>
	</c:if>
	<!-- 如果是被KK集成，则显示最后登录时间和IP 苏轶 2010年6月28日 END -->
	<!-- 如果没有查到数据则提示没有代办，提示文字区分代审和待阅。 苏轶 2010年7月30日-->
	<c:if test="${totalrows==0}">
	<tr><td>
		<bean:message bundle="sys-notify" key="sysNotifyTodo.home.you" />&nbsp;<font style="color:#FF6600;"><b>
		<bean:message bundle="sys-notify" key="sysNotifyTodo.home.notHave" /></b></font>&nbsp;
		<c:if test="${param.fdType == 1 || empty param.fdType && empty param.finish}">
			<bean:message bundle="sys-notify" key="sysNotifyTodo.toDo.info" />
		</c:if>
		<c:if test="${param.fdType == 2}">
			<bean:message bundle="sys-notify" key="sysNotifyTodo.toView.info" />
		</c:if>
		<c:if test="${param.fdType == 3}">
			<bean:message bundle="sys-notify" key="sysNotifyTodo.suspend.info" />
		</c:if>
		<c:if test="${param.finish == 1}">
			<bean:message bundle="sys-notify" key="sysNotifyTodo.done.label.2" />
		</c:if>
	</td></tr>
	</c:if>
	<!-- 如果没有查到数据则提示没有代办，提示文字区分代审和待阅。 苏轶 2010年7月30日 END-->
	<c:if test="${totalrows > 0}">
	<tr>
		<td>
		<c:if test="${param.fdType == 1 || empty param.fdType && empty param.finish}">
			<a target="_blank"
				href='<c:url value="/moduleindex.jsp?nav=/sys/notify/tree.jsp&main=%2Fsys%2Fnotify%2Fsys_notify_todo%2FsysNotifyTodo.do%3Fmethod%3DmngList%26oprType%3Ddoing%26fdType%3D13%26s_path%3D!{message(sys-notify:sysNotify.todo)}"/>'>
			
			<span class="trspan1"><bean:message bundle="sys-notify" key="sysMail.home.youHave" />
			<b>${totalrows}</b>
			<bean:message bundle="sys-notify" key="sysMail.home.pcs" />
			</span>
			<span class="trspan2"><bean:message bundle="sys-notify" key="sysNotifyTodo.toDo.count.info" /></span>
			</a>
		</c:if>
		<c:if test="${param.fdType == 2}">
			<a target='_blank'
				href='<c:url value="/moduleindex.jsp?nav=/sys/notify/tree.jsp&main=%2Fsys%2Fnotify%2Fsys_notify_todo%2FsysNotifyTodo.do%3Fmethod%3DmngList%26oprType%3Ddoing%26fdType%3D2%26s_path%3D!{message(sys-notify:sysNotify.todo)}"/>'>
			<span class="trspan1"><bean:message bundle="sys-notify" key="sysMail.home.youHave" />
			<b id="notifyCount2">${totalrows}</b>
			<bean:message bundle="sys-notify" key="sysMail.home.pcs" />
			</span>
			<span class="trspan2"><bean:message bundle="sys-notify" key="sysNotifyTodo.toView.count.info" /></span>
			</a>
		</c:if>
		<c:if test="${param.finish == 1}">
			<a target='_blank' style='font-weight:bold;color:#0066CC'
				href='<c:url value="/moduleindex.jsp?nav=/sys/notify/tree.jsp&main=%2Fsys%2Fnotify%2Fsys_notify_todo%2FsysNotifyTodo.do%3Fmethod%3DmngList%26oprType%3Ddone%26s_path%3D!{message(sys-notify:sysNotifyTodo.done.item)}" />'>
			<bean:message bundle="sys-notify" key="sysNotifyTodo.done.label.1" />
			</a>
			<bean:message bundle="sys-notify" key="sysNotifyTodo.done.label.2" />
		</c:if>
		</td>
	</tr>
	</c:if>	
	<!-- 显示 邮件数量 -->
	<tr><td><c:import url="/sys/notify/sys_notify_todo/sysMail_home_mid.jsp" charEncoding="UTF-8"/></td></tr>
	<c:forEach var="model" items="${queryPage.list}">
	<tr>
		<td>
		<c:choose>
		<c:when test="${param.finish == 1}">
		<a target="_blank"<c:if test="${not empty model.todo.fdLink}"> href="<c:url value="${model.todo.fdLink}"/>"</c:if>>
			<span id="notify_content_${model.todo.fdType}"></span>
			<c:if test="${showAppHome==1}">
				<c:set var="appName" value="${model.todo.fdAppName}"/>
				<c:if test="${appName!=null && appName!='' }">
					<bean:message bundle="sys-notify" key="sysNotifyTodo.todo.appTitle.left" /><c:out value="${appName}"/><bean:message bundle="sys-notify" key="sysNotifyTodo.todo.appTitle.right" />
				</c:if>
			</c:if>
			<c:out value="${model.todo.subject4View}" escapeXml="false"/> 
	 	</a>
		</c:when>
		<c:otherwise>
		<a target="_blank" onclick="onNotifyClick(this,'${param.fdType}')"
			<c:if test="${not empty model.fdLink}"> href="<c:url value="/sys/notify/sys_notify_todo/sysNotifyTodo.do?method=view&fdId=${model.fdId}" />"</c:if>>
			<span id="notify_content_${model.fdType}"></span>
			<c:if test="${showAppHome==1}">
				<c:set var="appName" value="${model.fdAppName}"/>
				<c:if test="${appName!=null && appName!='' }">
					<bean:message bundle="sys-notify" key="sysNotifyTodo.todo.appTitle.left" /><c:out value="${appName}"/><bean:message bundle="sys-notify" key="sysNotifyTodo.todo.appTitle.right" />
				</c:if>
			</c:if>
			<c:out value="${model.subject4View}" escapeXml="false"/> 
	 	</a>
		</c:otherwise>
		</c:choose>
		</td>
	</tr>
	</c:forEach>
</table>	
	</div>
	<script type="text/javascript">
	domain.autoResize();
	</script>
</body>
<script language='javascript'>
	function onNotifyClick(hrefObj,notifyType){
		//待阅点击后及时消失
		if(notifyType=='2'){
			//当前行顶级节点
			var p = $(hrefObj)[0].parentNode.parentNode;
			p.style.display="none";
			var countObj=document.getElementById("notifyCount2");
			var btnObj=document.getElementById("notifyBtn2");
			if(countObj!=null){
				if(!isNaN(countObj.innerText)){
					var countInt=parseInt(countObj.innerText,10);
					if(countInt>0)
						$(countObj).text(countInt-1);
				}
			}
			if(btnObj!=null){
				var oldBtnVal=btnObj.value;
				if(oldBtnVal.indexOf("(")>-1){
					var labelName=oldBtnVal.substring(0,oldBtnVal.indexOf("("));
					var countVar=oldBtnVal.substring(oldBtnVal.indexOf("(")+1,oldBtnVal.length-1);
					if(!isNaN(countVar)){
						var count=parseInt(countVar,10);
						if(count>0){
							btnObj.value=labelName+"("+(count-1)+")";
						}
					}
				}
			}	
		}	
	}	
</script>
</html>
