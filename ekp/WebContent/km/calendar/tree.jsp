<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/tree_top.jsp" %>
//Com_Parameter.XMLDebug = true;
function generateTree(){
    
    <%-- 时间管理 --%>
	LKSTree = new TreeView("LKSTree", "<bean:message key="module.km.calendar" bundle="km-calendar"/>", document.getElementById("treeDiv"));
	var n1, n2, n3;
	n1 = LKSTree.treeRoot;
		
		<kmss:authShow roles="ROLE_KMCALENDAR_BASE_CONFIG">
		    <%-- 模块设置 --%>
			n2 = n1.AppendURLChild("<bean:message  bundle="km-calendar" key="km.calendar.tree.module.set"/>");
			<%-- 保存期限 、默认时间设置--%>
			n3 = n2.AppendURLChild(
				"<bean:message  bundle="km-calendar" key="km.calendar.tree.delete.calendar.set"/>"
				,"<c:url value="/km/calendar/km_calendar_base_config/kmCalendarBaseConfig.do?method=view&type=day" />"
			);
			<%--
			n3 = n2.AppendURLChild(
				"<bean:message  bundle="km-calendar" key="km.calendar.tree.default.time.set"/>"
				,"<c:url value="/km/calendar/km_calendar_base_config/kmCalendarBaseConfig.do?method=view&type=time" />"
			);--%>	
			<%-- 导入时间机制标签
			n2.AppendURLChild(
				"导入时间机制标签"
				,"<c:url value="/km/calendar/km_calendar_agenda_label/kmCalendarAgendaLabel.do?method=importAgendaLabel" />"
			);
			 --%>
			<%-- 管理机制标签 --%>
			n2.AppendURLChild(
				"<bean:message  bundle="km-calendar" key="km.calendar.tree.calendar.label.config"/>"
				,"<c:url value="/km/calendar/km_calendar_agenda_label/kmCalendarAgendaLabel.do?method=list" />"
			);
			
			
			
		</kmss:authShow>
	
	LKSTree.EnableRightMenu();
	LKSTree.Show();
}
<%@ include file="/resource/jsp/tree_down.jsp" %>
