<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>	
<%@ include file="/kms/common/resource/jsp/index_top.jsp" %>
<%@ include file="/kms/common/kms_personal/kms_personal_common_js.jsp"%>
<%@ include file="/kms/common/kms_personal/kms_personal_common_tmpl.jsp"%>
<%@ include file="kms_personal_bm_js.jsp"%>
<%@ include file="kms_personal_bm_tmpl.jsp"%>
<%
	if(request.getAttribute("isCurUser")!=null){
		Boolean isCurUser =Boolean.valueOf(request.getAttribute("isCurUser").toString()) ; 
		pageContext.setAttribute("userDirect", isCurUser ? "我" : "TA");
	}
%>
<div id="main2">
<div class="content5 box c">
<div class="leftbar2"><%-- 加载个人基本信息 --%>
<div class="kmsPersonInfo">
	<kms:portlet title="个人基本信息" id="kmsPersonInfo" dataType="Bean" dataBean="kmsPersonalIntegralInfoPortlet" beanParm="{fdPersonId:\"${param.fdPersonId}\",expert:\"${param.expert }\"}" template="portlet_common_per_tmpl"></kms:portlet>
</div>
<div class="submenu_box">
<ul class="subnav2">
	<c:if test="${isCurUser}">
		<li><a href="javascript:myPage('method=myKmInfo');" title="我的KM">我的KM</a></li>
	</c:if>
	<li><a href="javascript:myPage('method=personalInfo');" title="基本信息">基本信息</a></li>
	<li><a href="javascript:myPage('method=followSetting');" title="我的订阅">我的订阅</a></li>
	<c:forEach var="kmsPersonal" items="${kmsPersonalList}">
		<li ><a href="javascript:myKmDetails('km_path=${kmsPersonal.modulePath }');" title="">${isCurUser eq true ? '我的' : 'TA的' }${kmsPersonal.navMessage }</a></li>
	</c:forEach>
	<c:if test="${isCurUser}">
	<li class="on"><a href="javascript:myKmDetails('km_path=/km/bookmark');" class="sc" title="我的收藏">我的收藏<span class="sc_icon" onclick="setBookmarkCategory();"></span></a>
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
				<kms:tabportlet cssClass="con con2 con2_2 m_t10" id="myKmBookmarkTabview" template="portlet_bm_list_nav_tmpl">
					<kms:portlet title="所有收藏" cssClass="tagContent" id="myBookmark" dataType="Bean" dataBean="kmsBookmarkPersonalPortlet" beanParm="{rowsize:15,s_method:\"getBookmarkPersonal\",fdPersonId:\"${param.fdPersonId}\",fdCategoryId:\"${param.fdCategoryId}\"}" template="portlet_bm_list_tmpl" callBack="KMS.listCallBack"></kms:portlet>
				</kms:tabportlet>
			</div><!-- end cont2 -->
</div>
</div>
<%@ include file="/kms/common/resource/jsp/index_down.jsp" %> 