<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ page import="com.landray.kmss.util.UserUtil"%>
<%@ include file="/kms/common/resource/jsp/index_top.jsp" %> 
<%@ include file="../kms_personal_common_js.jsp"%>
<%@ include file="../kms_personal_common_tmpl.jsp"%>
<%@ include file="kms_personal_km_js.jsp"%>
<%@ include file="kms_personal_km_tmpl.jsp"%>
<style>
#reciev-list {
	border: 1px solid #ccc;
	width: 300px;
	position: absolute;
	display: none;
	background-color: #F9F9F9;
}

#reciev-list li {
	padding-left: 8px;
	line-height: 1.8;
}

#reciev-list li.keybtn_on {
	background: #29ADF8;
	color: #ccc;
}
</style>
		<div id="main2">
			<div class="content5 box c">
				<div class="leftbar2">
					<div class="kmsPersonInfo">
					<%-- 加载个人基本信息 --%>
						<kms:portlet title="个人基本信息" id="kmsPersonInfo" dataType="Bean" dataBean="kmsPersonalIntegralInfoPortlet" beanParm="{fdPersonId:\"${param.fdPersonId}\",expert:\"${param.expert }\"}" template="portlet_common_per_tmpl"></kms:portlet>
					</div>
					<div class="submenu_box">
						<ul class="subnav2">
							<c:if test="${isCurUser}">
								<li class='on'><a href="javascript:myPage('method=myKmInfo');" title="我的KM">我的KM</a></li>
							</c:if>
							<li><a href="javascript:myPage('method=personalInfo');" title="基本信息">基本信息</a></li>
							<li><a href="javascript:myPage('method=followSetting');" title="我的订阅">我的订阅</a></li>
							<c:forEach var="kmsPersonal" items="${kmsPersonalList}">
								<li ><a href="javascript:myKmDetails('km_path=${kmsPersonal.modulePath }');" title="">${isCurUser==true ? '我的' : 'TA的' }${kmsPersonal.navMessage }</a></li>
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
					<kms:tabportlet cssClass="con con2 con2_2 m_t10" id="kmsNotifyTodoTabview" template="portlet_todo_list_nav_tmpl" selected="${param.selected }">
						<kms:portlet title="待审" cssClass="tagContent" id="sysNotifyTodoDone" dataType="Bean" dataBean="kmsNotifyTodoService" beanParm="{rowsize:5,s_method:\"sysNotifyTodoManual\",fdPersonId:\"${param.fdPersonId}\"}" template="portlet_todo_list_tmpl" callBack="KMS.listCallBack"></kms:portlet>
						<kms:portlet title="待阅" cssClass="tagContent" id="sysNotifyTodo" dataType="Bean" dataBean="kmsNotifyTodoService" beanParm="{rowsize:5,s_method:\"sysNotifyTodoOnce\",fdPersonId:\"${param.fdPersonId}\"}" template="portlet_todo_list_tmpl" callBack="KMS.listCallBack"></kms:portlet>
						<kms:portlet title="已审" cssClass="tagContent" id="sysNotifyTodo3" dataType="Bean" dataBean="kmsNotifyTodoService" beanParm="{rowsize:5,s_method:\"sysNotifyTodoDoneManual\",fdPersonId:\"${param.fdPersonId}\"}" template="portlet_todo_list_tmpl" callBack="KMS.listCallBack"></kms:portlet>
						<kms:portlet title="已阅" cssClass="tagContent" id="sysNotifyTodo2" dataType="Bean" dataBean="kmsNotifyTodoService" beanParm="{rowsize:5,s_method:\"sysNotifyTodoDoneOnce\",fdPersonId:\"${param.fdPersonId}\"}" template="portlet_todo_list_tmpl" callBack="KMS.listCallBack"></kms:portlet>
					</kms:tabportlet>
					<kms:portlet id="kmCkoPortlet" beanParm="{km_path:\"${param.km_path}\",fdPersonId:\"${param.fdPersonId }\"}" dataBean="kmsMyIntegralPortlet"  dataType="bean" template="portlet_km_cko_tmpl" title="我的总积分" callBack="bindButton"></kms:portlet>
				</div>
			</div>
			<!-- end cont2 -->
		</div>
		<!-- main2 end -->
<%@ include file="/kms/common/resource/jsp/index_down.jsp" %> 