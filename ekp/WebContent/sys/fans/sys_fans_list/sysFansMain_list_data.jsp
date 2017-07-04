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
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.HashSet"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.Iterator"%>
<%@page import="java.util.Set"%>
<%@page import="com.landray.kmss.util.ModelUtil"%>
<%@page import="org.apache.commons.beanutils.PropertyUtils"%>
<%@page import="com.landray.kmss.sys.organization.model.SysOrgPerson"%>
<%@page import="com.landray.kmss.sys.fans.constant.SysFansConstant"%>
<%@page import="com.landray.kmss.common.model.IBaseModel"%>

<%
	String userId = UserUtil.getUser().getFdId();
	Page p = (Page) request.getAttribute("queryPage");
	String fdIds = "";
	List<Map> list = p.getList();
	List<String> personIds = new ArrayList<String>();
	List<String> otherIds = new ArrayList<String>();
	String fansModelName = "";//人员表名
	Map<String,String> modelNameMap = new HashMap<String,String>();
	Integer personType = SysFansConstant.RELATION_USER_TYPE_PERSON;
	Integer otherType = SysFansConstant.RELATION_USER_TYPE_OTHER;
	for(int i = 0 ; i < list.size(); i++) {
		String fdModelName = (String)list.get(i).get("fdModelName");
		String orginName = (String)list.get(i).get("fansModelName");
		if(StringUtil.isNotNull(orginName) && StringUtil.isNull(fansModelName)){
			fansModelName = orginName;
		}
		Integer fdUserType = (Integer)list.get(i).get("fdUserType");
		String fdModelId = (String)list.get(i).get("fdModelId");
		
		if(modelNameMap.size()<=0){
			modelNameMap.put(fdModelName,Integer.toString(fdUserType));
		}
		Set<String> set1 =modelNameMap.keySet();
        Iterator<String> it = set1.iterator();
        while(it.hasNext()){
        	 String obj = it.next();
             if(StringUtil.isNotNull(fdModelName) && !fdModelName.equals(obj)){
            	 modelNameMap.put(fdModelName,Integer.toString(fdUserType));
             }
        }
		
		if(fdUserType != null ){
			//人
			if(fdUserType.equals(personType)){
				personIds.add(fdModelId);
			}else if(fdUserType.equals(otherType)){//其他
				otherIds.add(fdModelId);
			}
		}
		if(StringUtil.isNotNull(fdModelId)){
			fdIds = StringUtil.linkString(fdIds , "," , "'" + fdModelId + "'");
		}
	}
	
	JSONObject fdNames = new JSONObject();
	JSONObject fdSexs = new JSONObject();
	JSONObject fdDepts = new JSONObject();
	JSONObject fdAttentionNums = new JSONObject();
	JSONObject fdFansNums = new JSONObject();
	JSONObject fdSignatures = new JSONObject();
	JSONObject attentModelNames = new JSONObject();
	JSONObject fansModelNames = new JSONObject();
	if(modelNameMap.size()>0){
		Set<String> modelSet =modelNameMap.keySet();
	    Iterator<String> iter = modelSet.iterator();
	    while(iter.hasNext()){
	    	String modelName = iter.next();
	    	String userType = modelNameMap.get(modelName);
	    	if(StringUtil.isNotNull(modelName)){
	    		if(personType.equals(Integer.parseInt(userType)) && personIds.size()>0){
		    		String tableName = ModelUtil.getModelTableName(modelName);
		    		String personSql = " from "+ modelName + " " + tableName + " where "+tableName+".fdId in(:fdIds)";
		    		IBaseDao baseDao = (IBaseDao) SpringBeanUtil.getBean("KmssBaseDao");
		    		List<IBaseModel> modelList = baseDao.getHibernateSession().createQuery(
		    				personSql).setParameterList("fdIds", personIds).list();
		    		for(int i=0;i<modelList.size();i++){
		    			IBaseModel modelObj = modelList.get(i);
		    			if(PropertyUtils.isReadable(modelObj, "person")){
			    			SysOrgPerson person = 
			    				(SysOrgPerson)PropertyUtils.getProperty(modelObj,"person");
			    			String fdSex = person.getFdSex();
			    			String fdName = person.getFdName();
			    			String fdDept = "";
			    			if (person.getFdParent() != null) {
			    				fdDept = person.getFdParent().getFdName();
			    			}
			    			String fdSignature = "";
			    			if(PropertyUtils.isReadable(modelObj, "fdSignature")){
			    				fdSignature = (String)PropertyUtils.
			    						getProperty(modelObj,"fdSignature");
			    			}
			    			Integer fdAttentionNum = 0;
			    			if(PropertyUtils.isReadable(modelObj, "fdAttentionNum")){
			    				fdAttentionNum = (Integer)PropertyUtils.
			    						getProperty(modelObj,"fdAttentionNum");
			    			}
			    			Integer fdFansNum = 0;
			    			if(PropertyUtils.isReadable(modelObj, "fdFansNum")){
			    				fdFansNum = (Integer)PropertyUtils.
			    						getProperty(modelObj,"fdFansNum");
			    			}
			    			
			    			fdNames.element(modelObj.getFdId(), fdName);
			    			fdSexs.element(modelObj.getFdId(), fdSex);
			    			fdDepts.element(modelObj.getFdId(), fdDept);
			    			fdAttentionNums.element(modelObj.getFdId(), fdAttentionNum);
			    			fdFansNums.element(modelObj.getFdId(), fdFansNum);
			    			fdSignatures.element(modelObj.getFdId(), fdSignature);
			    			attentModelNames.element(modelObj.getFdId(), modelName);
			    			fansModelNames.element(modelObj.getFdId(), fansModelName);
			    		}
		    		}
		    		
		    	}else if(otherType.equals(Integer.parseInt(userType)) && otherIds.size()>0){
		    		String tableName = ModelUtil.getModelTableName(modelName);
		    		String personSql = " from "+ modelName + " " + tableName + " where "+tableName+".fdId in(:fdIds)";
		    		IBaseDao baseDao = (IBaseDao) SpringBeanUtil.getBean("KmssBaseDao");
		    		List<IBaseModel> modelList = baseDao.getHibernateSession().createQuery(
		    				personSql).setParameterList("fdIds", otherIds).list();
		    		for(int i=0;i<modelList.size();i++){
		    			IBaseModel obj = modelList.get(i);
		    			if(PropertyUtils.isReadable(obj, "docSubject")){
			    			String docSubject = 
			    				(String)PropertyUtils.getProperty(obj,"docSubject");
			    			fdNames.element(obj.getFdId(), docSubject);
			    		}
		    			Integer fdFansNum = 0;
		    			if(PropertyUtils.isReadable(obj, "fdFansNum")){
		    				fdFansNum = (Integer)PropertyUtils.
		    						getProperty(obj,"fdFansNum");
		    			}
		    			fdFansNums.element(obj.getFdId(), fdFansNum);
		    			attentModelNames.element(obj.getFdId(), modelName);
		    			fansModelNames.element(obj.getFdId(), fansModelName);
		    		}
		    	}
	    	}
	    }
	}
	request.setAttribute("fdNames", fdNames);
	request.setAttribute("fdSexs", fdSexs);
	request.setAttribute("fdDepts", fdDepts);
	request.setAttribute("fdAttentionNums", fdAttentionNums);
	request.setAttribute("fdFansNums", fdFansNums);
	request.setAttribute("fdSignatures", fdSignatures);
	request.setAttribute("attentModelNames", attentModelNames);
	request.setAttribute("fansModelNames", fansModelNames);
	
	//关注的
	JSONObject atts = new JSONObject();
	//粉丝
	JSONObject fans = new JSONObject();
	if (StringUtil.isNotNull(fdIds)) {
		IBaseDao baseDao = (IBaseDao) SpringBeanUtil
				.getBean("KmssBaseDao");
		String _sql = "select main.fd_fans_id  from sys_fans_main main  where main.fd_user_id=:userId and main.fd_fans_id in ("
			+ fdIds + ")";
		SQLQuery _query = baseDao.getHibernateSession().createSQLQuery(
				_sql);
		for (Object obj : _query.setParameter("userId", userId).list()) {
			String key = (String) obj;
			fans.element(key, 1);
		}
		_sql = "select main.fd_user_id  from sys_fans_main main  where main.fd_fans_id=:userId and main.fd_user_id in ("
			+ fdIds + ")";
		_query = baseDao.getHibernateSession().createSQLQuery(
				_sql);
		for (Object obj : _query.setParameter("userId", userId).list()) {
			String key = (String) obj;
			atts.element(key, 1);
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
		<list:data-column col="fdModelId" >
	 		${item.fdModelId}
		</list:data-column>
		<list:data-column col="isFollowPerson">
	 		<c:choose>
				<c:when test="${'fans' == item.followType}">
					true
				</c:when>
				<c:otherwise>
					${1 == item.fdUserType ? true:false}
				</c:otherwise>
			</c:choose>
		</list:data-column>
		<list:data-column col="attentModelName" title="${ lfn:message('sys-zone:sysZonePerson.name') }" >
	 		${attentModelNames[item.fdModelId]}
		</list:data-column>
		<list:data-column col="fansModelName" title="${ lfn:message('sys-zone:sysZonePerson.name') }" >
	 		${fansModelNames[item.fdModelId]}
		</list:data-column>
		<list:data-column col="fdName" title="${ lfn:message('sys-zone:sysZonePerson.name') }" >
	 		${fdNames[item.fdModelId]}
		</list:data-column>
		<list:data-column col="fdDept" title="${ lfn:message('sys-zone:sysZonePerson.dept') }" >
	 		${fdDepts[item.fdModelId]}
		</list:data-column>
		<list:data-column col="fdSex" title="${ lfn:message('sys-zone:sysZonePerson.sex') }" >
	 		${fdSexs[item.fdModelId]}
		</list:data-column>
		<list:data-column col="fdSignature" title="${ lfn:message('sys-zone:sysZonePerson.fdSignature') }" >
	 		${fdSignatures[item.fdModelId]}
		</list:data-column>
		<list:data-column col="fdFansNum" title="${ lfn:message('sys-zone:sysZonePerson.fdFansNum') }" >
	 		${fdFansNums[item.fdModelId]}
		</list:data-column>
		<list:data-column col="fdAttentionNum" title="${ lfn:message('sys-zone:sysZonePerson.fdAttentionNum') }" >
	 		${fdAttentionNums[item.fdModelId]}
		</list:data-column>
		<list:data-column col="isAtt" title="${ lfn:message('sys-zone:sysZonePerson.isCared') }" escape="false">
	 		${1 == atts[item.fdModelId] ? 1 : 0 }
		</list:data-column>
		<list:data-column col="isFans" title="${ lfn:message('sys-zone:sysZonePerson.isCared') }"  escape="false">
	 		${1 == fans[item.fdModelId] ? 1 : 0 }
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
		<list:data-column col="src" title="头像" escape="false">
			${LUI_ContextPath}/sys/person/sys_person_zone/sysPersonZone.do?method=img&fdId=${item.fdModelId}&size=b
		</list:data-column>
		<list:data-column col="name" title="名字">
			${fdNames[item.fdModelId]}
		</list:data-column>
		<list:data-column col="href" title="链接" escape="false">
			/sys/person/sys_person_zone/sysPersonZone.do?method=view&fdId=${item.fdModelId}
		</list:data-column>
		<%--移动端数据结束 --%>
		
	</list:data-columns>
	<list:data-paging page="${queryPage }" >
	</list:data-paging>
</list:data>