<%@page import="com.landray.kmss.util.UserUtil"%>
<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib uri="/WEB-INF/KmssConfig/sys/ui/ui.tld" prefix="ui"%>
<%@ taglib uri="/WEB-INF/KmssConfig/sys/ui/lfn.tld" prefix="lfn"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="/WEB-INF/KmssConfig/sys/person/person.tld" prefix="person"%>
<div style="text-align: center; background-color: #fff;">
    <div style="padding-top: 15px;">
     <div id="sys_person_userpic" style="width: 120px;height: 120px;background-repeat: no-repeat;margin: 0 auto;background-position-y: center;
background-position-x: center;
background-image: url('<person:headimageUrl personId="${KMSS_Parameter_CurrentUserId}" size="120" />');" ></div>
    </div>
    <div style="text-align: left;padding: 5px 10px;">
    <span class="com_author"><c:out value="<%= UserUtil.getKMSSUser().getUserName() %>" /></span>
    <c:if test="${empty noShowSettingOption }">
    <a class="lui_portlet_operation" href="${ LUI_ContextPath }/sys/person/setting.do?setting=sys_person_mynav" target="_blank" style="float:right;padding-top: 0;">${lfn:message('sys-person:person.setting.btn') }</a>
    </c:if>
    </div>
    <div style="text-align: left;padding: 0 10px 5px 10px;">
    <span><c:out value="<%=UserUtil.getKMSSUser().getDeptName()%>" /></span>
    </div>
    <div class="clr">
    </div>
</div>
	