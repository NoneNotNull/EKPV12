<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>	
<%@ include file="/kms/common/resource/jsp/index_top.jsp" %> 
<%@ include file="/kms/common/kms_personal/kms_personal_common_js.jsp" %>
<%@ include file="/kms/common/kms_personal/kms_personal_common_tmpl.jsp" %>
<%@ include file="kmsExpertInfo_view_js.jsp" %>
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
	<kms:portlet title="个人基本信息" id="kmsPersonInfo" dataType="Bean" dataBean="kmsPersonalIntegralInfoPortlet" beanParm="{fdPersonId:\"${param.fdPersonId}\",expert:\"${param.expert}\"}" template="portlet_common_per_tmpl"></kms:portlet>
</div>
<div class="submenu_box">
<ul class="subnav2">
	<c:if test="${isCurUser}">
		<li><a href="javascript:myPage('method=myKmInfo');" title="我的KM">我的KM</a></li>
	</c:if>
	<li class="on"><a href="javascript:myPage('method=personalInfo');" title="基本信息">基本信息</a></li>
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
<form action="<c:url value='/kms/expert/kms_expert_info/kmsExpertInfo.do' />" method="post" id="kmsExpertInfoForm">
<div class="cont2">
<kmss:authShow roles="ROLE_KMSEXPERTTYPE_ADMIN">
<div class="btns_box" style="float: right;">
	<div class="btn_a"><a title="<bean:message key="button.edit"/>" href="javascript:void(0)" id="editButton"><span><bean:message key="button.edit"/></span></a></div>
</div>
</kmss:authShow>
<h3 class="h3_2">
	<span>专家信息</span>
</h3>

<table width="100%" border="0" cellspacing="1" cellpadding="0"
	class="t_e2 m_t10">
	<thead>
		<tr>
			<th><bean:message bundle="kms-expert" key="kmsExpert.expertInfo.person.name" /></th>
			<td>${kmsExpertInfoForm.fdName}</td>
			<th><bean:message bundle="kms-expert" key="kmsExpert.expertInfo.person.sex" /></th>
			<td >
				<c:if test="${kmsExpertInfoForm.fdSex!=null&&kmsExpertInfoForm.fdSex!='' }">
		        	<sunbor:enumsShow value="${kmsExpertInfoForm.fdSex}" enumsType="kmsExpert_personInfo_sex" />
		        </c:if>
			</td>
		</tr>
	</thead>
	<tbody>
		<tr>
			<th><bean:message bundle="kms-expert" key="kmsExpert.expertInfo.person.post" /></th>
			<td><% 
			  		List postList = (List)request.getAttribute("posts");
				    if(postList.size()!=0){
			  	%>     	 	
				<c:forEach items="${posts}" var="post"  varStatus="status">
		        	<c:out value="${post}" /><br>
		        </c:forEach>
		        <%
				    }
				%>
			</td>
			<th><bean:message bundle="kms-expert" key="kmsExpert.expertInfo.person.department" /></th>
			<td>${kmsExpertInfoForm.fdDeptName}</td>
		</tr>
		<tr>
			<th width="15%"><bean:message bundle="kms-expert" key="table.kmsExpertInfo.fdMobile" /></th>
			<td width="35%">${kmsExpertInfoForm.fdMobileNo }</td>
			<th width="15%"><bean:message bundle="kms-expert" key="kmsExpert.comtele" /></th>
			<td width="35%">${kmsExpertInfoForm.fdWorkPhone}</td>
		</tr>
		<tr>
			<th width="15%"><bean:message bundle="kms-expert" key="table.kmsExpertInfo.fdEmail" /></th>
			<td width="35%">${kmsExpertInfoForm.fdEmail}</td>
			<th width="15%"><bean:message bundle="kms-expert" key="kmsExpert.rtx" /></th>
			<td width="35%">${kmsExpertInfoForm.fdRtxNo}</td>
		</tr>
		
		<tr>
			<th width="15%"><bean:message bundle="kms-expert" key="kmsExpert.qq" /></th>
			<td width="35%">${kmsExpertInfoForm.fdQqNumber}</td>
			<th width="15%"><bean:message bundle="kms-expert" key="kmsExpert.msn" /></th>
			<td width="35%">${kmsExpertInfoForm.fdMsnNumber}</td>
		</tr>
		<tr>
			<th width="15%"><bean:message bundle="kms-expert" key="table.kmsExpertInfo.fdOrder" />：</th>
			<td width="35%">${kmsExpertInfoForm.fdOrder }</td>
			<th width="15%"><bean:message bundle="kms-expert" key="table.kmsExpertInfo.fdAreaName" />：</th>
			<td width="35%">${kmsExpertInfoForm.kmsExpertTypeName }</td>
		</tr>
		
		<c:forEach items="${kmsExpertAreas}" var="kmsExpertArea" varStatus="vstatus">
			<c:import url="/kms/expert/kms_expert_area/kmsExpertArea_view.jsp"
				charEncoding="UTF-8">
				<c:param name="areaMessage" value="${kmsExpertArea.areaMessageKey}" />
				<c:param name="index" value="${vstatus.index}" />
			</c:import>
		</c:forEach>
		
		<tr>
			<th><bean:message bundle="kms-expert" key="table.kmsExpertInfo.fdBackground" />：</th>
			<td colspan="4">${kmsExpertInfoForm.fdBackground }</td>
		</tr>
		
	</tbody>
</table>
</div>
</form>
<!-- end cont2 --></div>
</div>
<%@ include file="/kms/common/resource/jsp/index_down.jsp" %> 