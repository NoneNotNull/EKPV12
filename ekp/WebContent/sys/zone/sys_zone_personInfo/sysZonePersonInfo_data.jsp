<%@ page language="java" contentType="text/json; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<%@page import="net.sf.json.JSONObject"%>
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
	<list:data-columns var="json" list="${queryPage.list}" varIndex="status">
		<list:data-column property="fdId">
		</list:data-column>
		<list:data-column col="index">
		  ${status+1}
		</list:data-column>
		<list:data-column property="fdName" title="${ lfn:message('sys-zone:sysZonePerson.fdSignature') }">
		</list:data-column>
		<list:data-column col="tags" escape="false">
				<%
					Object basedocObj = pageContext.getAttribute("json");
					if(basedocObj != null) {
						JSONObject json = (JSONObject)basedocObj;
						String personTags= json.get("personTags").toString();
						if(StringUtil.isNotNull(personTags)) {
							out.print(personTags.trim().replaceAll("\\s+", ";"));
						}
					}
				%>
		</list:data-column>	
		<list:data-column col="isAtt" title="${ lfn:message('sys-zone:sysZonePerson.isCared') }" escape="false">
	 		${1 == atts[json.fdId] ? 1 : 0 }
		</list:data-column>
		<list:data-column col="isFans" title="${ lfn:message('sys-zone:sysZonePerson.isCared') }"  escape="false">
	 		${1 == fans[json.fdId] ? 1 : 0 }
		</list:data-column>
		<list:data-column property="isLoad">
		</list:data-column>		
		<list:data-column property="fdAttentionNum" title="${ lfn:message('sys-zone:sysZonePerson.fdAttentionNum') }">
		</list:data-column>
		<list:data-column property="fdFansNum" title="${ lfn:message('sys-zone:sysZonePerson.fdFansNum') }">
		</list:data-column>
	</list:data-columns>
	<list:data-paging currentPage="${queryPage.pageno }"
		pageSize="${queryPage.rowsize }" totalSize="${queryPage.totalrows }">
	</list:data-paging>
</list:data>