<%@ page language="java" contentType="text/json; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<%@page import="net.sf.json.JSONObject"%>
<%@page import="com.landray.kmss.util.StringUtil"%>
<%@page
	import="com.landray.kmss.sys.zone.model.SysZonePersonInfo"%>
<%@page import="com.sunbor.web.tag.Page"%>
<%@page import="java.util.List"%>
<%@page import="java.util.Map"%>
<%@page import="com.landray.kmss.common.dao.IBaseDao"%>
<%@page import="com.landray.kmss.util.SpringBeanUtil"%>
<%@page import="org.hibernate.SQLQuery"%>
<%@page import="com.landray.kmss.util.ResourceUtil"%> 
<%@page import="com.landray.kmss.util.UserUtil"%> 
<%
	String userId = UserUtil.getUser().getFdId();
	Page p = (Page) request.getAttribute("queryPage");
	String fdIds = "";
	List<Map> list = p.getList();
	for(int i = 0 ; i < list.size(); i++) {
		fdIds = StringUtil.linkString(fdIds , "," , "'" + list.get(i).get("fdId").toString() + "'");
	}
	//关注的
	JSONObject atts = new JSONObject();
	//粉丝
	JSONObject fans = new JSONObject();
	if (StringUtil.isNotNull(fdIds)) {
		IBaseDao baseDao = (IBaseDao) SpringBeanUtil
				.getBean("KmssBaseDao");
		String _sql = "select e.fd_to_element_id  from sys_zone_person_atten_fan e  where e.fd_from_element_id=:userId and e.fd_to_element_id in ("
			+ fdIds + ")";
		SQLQuery _query = baseDao.getHibernateSession().createSQLQuery(
				_sql);
		for (Object obj : _query.setParameter("userId", userId).list()) {
			String key = (String) obj;
			atts.element(key, 1);
		}
		_sql = "select e.fd_from_element_id  from sys_zone_person_atten_fan e  where e.fd_to_element_id=:userId and e.fd_from_element_id in ("
			+ fdIds + ")";
		_query = baseDao.getHibernateSession().createSQLQuery(
				_sql);
		for (Object obj : _query.setParameter("userId", userId).list()) {
			String key = (String) obj;
			fans.element(key, 1);
		}
	}
	request.setAttribute("atts", atts);
	request.setAttribute("fans", fans);
%>
<list:data>
	<list:data-columns var="item" list="${queryPage.list }">
		<list:data-column col="fdId" title="fdId" >
	 		${item.fdId}
		</list:data-column>
		<list:data-column col="fdLoginName" title="用户名" >
	 		${item.fdLoginName}
		</list:data-column>
		<list:data-column col="fdEmail" title="邮箱" >
	 		${item.fdEmail}
		</list:data-column>
		<list:data-column col="fdMobileNo" title="手机号码" >
	 		${item.fdMobileNo}
		</list:data-column>
		<list:data-column col="fdName" title="${ lfn:message('sys-zone:sysZonePerson.name') }" >
	 		${item.fdName}
		</list:data-column>
		<list:data-column col="fdDept" title="${ lfn:message('sys-zone:sysZonePerson.dept') }" >
	 		${item.fdDept}
		</list:data-column>
		<list:data-column col="fdSex" title="${ lfn:message('sys-zone:sysZonePerson.sex') }" >
	 		${item.fdSex}
		</list:data-column>
		<list:data-column col="fdSignature" title="${ lfn:message('sys-zone:sysZonePerson.fdSignature') }" >
	 		${item.fdSignature}
		</list:data-column>
		<list:data-column col="fdFansNum" title="${ lfn:message('sys-zone:sysZonePerson.fdFansNum') }" >
	 		${item.fdFansNum}
		</list:data-column>
		<list:data-column col="fdAttentionNum" title="${ lfn:message('sys-zone:sysZonePerson.fdAttentionNum') }" >
	 		${item.fdAttentionNum}
		</list:data-column>
		<%-- 
		<list:data-column col="hasAtten" title="${ lfn:message('sys-zone:sysZonePerson.isCared') }" >
	 		${item.hasAtten}
		</list:data-column>
		 --%>
		<list:data-column col="isAtt" title="${ lfn:message('sys-zone:sysZonePerson.isCared') }" escape="false">
	 		${1 == atts[item.fdId] ? 1 : 0 }
		</list:data-column>
		<list:data-column col="isFans" title="${ lfn:message('sys-zone:sysZonePerson.isCared') }"  escape="false">
	 		${1 == fans[item.fdId] ? 1 : 0 }
		</list:data-column>
		<list:data-column col="isSelf" title="${ lfn:message('sys-zone:sysZonePerson.isSelf') }" escape="false">
	 		${item.isSelf}
		</list:data-column>
		<list:data-column col="fdTags" title="${ lfn:message('sys-zone:sysZonePerson.fdTags') }"  escape="false">
			<%-- <c:if test="${fn:length(item.fdTags)>0}"> --%>
			${lfn:message('sys-zone:sysZonePerson.fdTags') }：
			<c:set var="tags" value="${fn:split(item.fdTags,' ')}"/>
			 	<c:forEach items="${tags}" var="tag" varStatus="vstatus">
				 	<c:choose>
							<c:when test="${fn:contains(tagNames,tag)}">
							 <span class="bgColr_blue"><a href='#' onclick='tagSearch("${tag}",true)' title='${tag}'>${tag}</a></span>
							</c:when>
							<c:otherwise> 
								 <span><a href='#' onclick='tagSearch("${tag}",true)' title='${tag}'>${tag}</a></span>
							 </c:otherwise>
					</c:choose>	 
			 	 </c:forEach> 
			<%-- </c:if> --%>
		</list:data-column>
		<%--移动端数据 --%>
		<list:data-column col="icon" title="头像" escape="false">
			${LUI_ContextPath}/sys/person/sys_person_zone/sysPersonZone.do?method=img&fdId=${item.fdId}&size=b
		</list:data-column>
		<list:data-column col="summary" title="摘要">
			${item.fdSignature}
		</list:data-column>
		<list:data-column col="label" title="名字">
			${item.fdName}
		</list:data-column>
		<list:data-column col="href" title="链接" escape="false">
			/sys/person/sys_person_zone/sysPersonZone.do?method=view&fdId=${item.fdId}
		</list:data-column>
		
		
	</list:data-columns>
	<list:data-paging page="${queryPage }" >
	</list:data-paging>
</list:data>