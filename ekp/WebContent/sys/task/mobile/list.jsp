<%@page import="com.landray.kmss.sys.person.interfaces.PersonInfoServiceGetter"%>
<%@page import="com.landray.kmss.util.ResourceUtil"%>
<%@page import="com.landray.kmss.util.DateUtil"%>
<%@ page language="java" contentType="text/json; charset=UTF-8"
    import="com.landray.kmss.sys.task.model.SysTaskMain,com.landray.kmss.sys.organization.model.SysOrgElement,java.util.*,com.landray.kmss.util.*"
	pageEncoding="UTF-8"%>
<%@ taglib uri="/WEB-INF/KmssConfig/sys/person/person.tld" prefix="person"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<list:data>
	<list:data-columns var="sysTaskMain" list="${queryPage.list }">
		<%--ID--%> 
		<list:data-column property="fdId"></list:data-column>
		<%--任务名称--%>
		<list:data-column col="title" title="${ lfn:message('sys-task:sysTaskMain.docSubject') }">
			<c:out value="${sysTaskMain.docSubject}" />
		</list:data-column>
		<list:data-column  col="fdStatus" title="${ lfn:message('sys-task:sysTaskMain.fdStatus') }">
			<c:out value="${sysTaskMain.fdStatus }"></c:out>
		</list:data-column>
		<%--任务状态Text--%>
		<list:data-column  col="fdStatusText" title="${ lfn:message('sys-task:sysTaskMain.fdStatus') }">
			<sunbor:enumsShow value="${sysTaskMain.fdStatus}"	enumsType="sysTaskMain_fdStatue" />
		</list:data-column>
		<%--任务进度--%>
		<list:data-column col="progress" title="${ lfn:message('sys-task:sysTaskMain.fdProgress') }" escape="false"  style="width:60px;">
			<c:out value="${sysTaskMain.fdProgress }"></c:out>
		</list:data-column>
		<%
			if(pageContext.getAttribute("sysTaskMain")!=null){
		    	List toSysOrgPerform=((SysTaskMain)pageContext.getAttribute("sysTaskMain")).getToSysOrgPerform();
				String personsName="",performId="";
				for(int i=0;i<toSysOrgPerform.size();i++){
					if(i==0){
						performId=((SysOrgElement)toSysOrgPerform.get(i)).getFdId();
					}
					if(i==toSysOrgPerform.size()-1){
					 	personsName+=((SysOrgElement)toSysOrgPerform.get(i)).getFdName();	
					}else{
	                  	personsName+=((SysOrgElement)toSysOrgPerform.get(i)).getFdName()+"，";	
					}
				 }
				request.setAttribute("personsName",personsName);
				request.setAttribute("performId", performId);
				request.setAttribute("personCount", toSysOrgPerform.size());
			}
		%>
		<%-- 负责人 --%>
		<list:data-column col="performs" escape="false" title="${ lfn:message('sys-task:table.sysTaskMainPerform') }" >
			<c:out value="${personsName }"></c:out>
		</list:data-column>
		<%-- 负责人人数 --%>
		<list:data-column col="personCount" escape="false" title="${ lfn:message('sys-task:table.sysTaskMainPerform') }" >
			<c:out value="${personCount }"></c:out>
		</list:data-column>
		<%-- 第一个负责人头像 --%>
		<list:data-column col="performSrc" escape="false" title="${ lfn:message('sys-task:table.sysTaskMainPerform') }" >
			 <person:headimageUrl personId="${performId}" size="90" />
		</list:data-column>
		<list:data-column col="href" escape="false">
			/sys/task/sys_task_main/sysTaskMain.do?method=view&fdId=${sysTaskMain.fdId}
		</list:data-column>
		<%--  超期 --%>
		<list:data-column headerStyle="width:120px;" col="overDay" escape="false">
			<%
				if(pageContext.getAttribute("sysTaskMain")!=null){
					SysTaskMain sysTaskMain=(SysTaskMain)pageContext.getAttribute("sysTaskMain");
					String dateStr=DateUtil.convertDateToString(sysTaskMain.getFdPlanCompleteDateTime(), DateUtil.PATTERN_DATETIME);
					request.setAttribute("dateStr", dateStr);
					if("1".equals(sysTaskMain.getFdPastDue())){
						int overDay=(int)((new Date().getTime()-sysTaskMain.getFdPlanCompleteDateTime().getTime())/(1000*60*60*24));
						if(overDay==0){
							overDay=1;
						}
						request.setAttribute("overDay", overDay);
					}
				}
			%>
			<c:if test="${sysTaskMain.fdPastDue=='1' and sysTaskMain.fdStatus!='3'  and sysTaskMain.fdStatus!='6'}">
				<c:out value="${overDay}"></c:out>
			</c:if>
			
		</list:data-column>
		
		
	</list:data-columns>

	<list:data-paging currentPage="${queryPage.pageno }"
		pageSize="${queryPage.rowsize }" totalSize="${queryPage.totalrows }">
	</list:data-paging>
</list:data>