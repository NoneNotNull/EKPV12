<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>	
<%@ include file="/kms/common/resource/jsp/index_top.jsp" %> 
<%@ include file="../kms_personal_common_js.jsp" %>
<%@ include file="../kms_personal_common_tmpl.jsp" %>
<%@ include file="kms_personal_info_js.jsp" %>
<%
	if(request.getAttribute("isCurUser")!=null){
		Boolean isCurUser =Boolean.valueOf(request.getAttribute("isCurUser").toString()) ; 
		pageContext.setAttribute("userDirect", isCurUser ? "我" : "TA");
	}
%>
<div id="main2">
<div class="content5 box c">
<div class="leftbar2">
<%-- 加载个人基本信息 --%>
<div class="kmsPersonInfo">
	<kms:portlet title="个人基本信息" id="kmsPersonInfo" dataType="Bean" dataBean="kmsPersonalIntegralInfoPortlet" beanParm="{fdPersonId:\"${param.fdPersonId}\"}" template="portlet_common_per_tmpl"></kms:portlet>
</div>
<div class="submenu_box">
<ul class="subnav2">
	<c:if test="${isCurUser}">
		<li><a href="javascript:myPage('method=myKmInfo');" title="我的KM">我的KM</a></li>
	</c:if>
	<li class="on"><a href="javascript:myPage('method=personalInfo');" title="基本信息">基本信息</a></li>
	<li><a href="javascript:myPage('method=followSetting');" title="我的订阅">我的订阅</a></li>
	<c:forEach var="kmsPersonal" items="${kmsPersonalList}">
		<li><a href="javascript:myKmDetails('km_path=${kmsPersonal.modulePath }');" title="">${isCurUser eq true ? '我的' : 'TA的' }${kmsPersonal.navMessage }</a></li>
	</c:forEach>
	<c:if test="${isCurUser}">
	<li><a href="javascript:myKmDetails('km_path=/km/bookmark');" class="sc" title="我的收藏">我的收藏<span class="sc_icon" onclick="setBookmarkCategory();"></span></a>
		<c:if test="${fn:length(bookmarkCategoryList) > 0 }">
		<ul class="subnav3">
			<c:forEach var="bookmarkCategory" items="${bookmarkCategoryList }">
			<li><a href="javascript:myKmDetails('km_path=/km/bookmark', '${bookmarkCategory.fdId }');" title="${bookmarkCategory.fdName }">${bookmarkCategory.fdName }</a></li>
			</c:forEach>
		</ul>
		</c:if>
	</li>
	</c:if>
</ul>
</div>
<!-- end submenu_box -->
</div>
<!-- end leftbar2 -->

<div class="cont2">
<kmss:authShow roles="ROLE_KMSCOMMON_PERSONINFO_EDIT">
	<div class="btns_box" style="float: right;">
		<div class="btn_a"><a title="<bean:message key="button.edit"/>" href="javascript:void(0)" id="editButton"><span><bean:message key="button.edit"/></span></a></div>
	</div>
</kmss:authShow>
<h3 class="h3_2"><span>基本信息</span></h3>
<table width="100%" border="0" cellspacing="1" cellpadding="0"
	class="t_e2 m_t10">
	<thead>
		<tr>
			<th width="15%">姓名：</th>
			<td width="35%"><c:out value="${kmsPersonInfoForm.fdPerson.fdName }" /></td>
			<th width="15%">英文名：</th>
			<td width="35%"><c:out value="${kmsPersonInfoForm.fdEnName }" /></td>
		</tr>
	</thead>
	<tbody>
		<tr>
			<th>性别：</th>
			<td><c:if test="${kmsPersonInfoForm.fdSex==1 }">男</c:if><c:if test="${kmsPersonInfoForm.fdSex==0 }">女</c:if></td>
			<th>单位Email：</th>
			<td><c:out value="${kmsPersonInfoForm.fdPerson.fdEmail }" /></td>
		</tr>
		<tr>
			<th>手机：</th>
			<td><c:out value="${kmsPersonInfoForm.fdPerson.fdMobileNo }" /></td>
			<th>单位电话：</th>
			<td><c:out value="${kmsPersonInfoForm.fdPerson.fdWorkPhone }" /></td>
		</tr>
		<tr>
			<th>隶属部门：</th>
			<td colspan="3"><c:out value="${kmsPersonInfoForm.fdPerson.fdParentName }" /></td>
		</tr>
		<tr>
			<th>所属岗位：</th>
			<td colspan="3"><c:out value="${kmsPersonInfoForm.fdPerson.fdPostNames }" /></td>
		</tr>
		<tr>
			<th>自我介绍：</th>
			<td colspan="3"><c:out value="${kmsPersonInfoForm.fdBackground }" /></td>
		</tr>
	</tbody>
</table>
</div>
<!-- end cont2 --></div>
</div>
<%@ include file="/kms/common/resource/jsp/index_down.jsp" %> 