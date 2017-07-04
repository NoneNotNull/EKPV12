<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ page import="com.landray.kmss.util.UserUtil"%>
<%@ include file="/kms/common/resource/jsp/index_top.jsp" %> 
<%@ include file="../kms_personal_common_js.jsp"%>
<%@ include file="../kms_personal_common_tmpl.jsp"%>
<%@ include file="kms_personal_follow_tmpl.jsp"%>
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
.header_box{
	margin-top:10px;
	margin-bottom:10px;
}
.header_box .header-context{
	float:left;
	width:520px;
	margin-top:-2px;
	margin-bottom:10px;
	vertical-align:top;
}
.header_box .header-btn{
	float:right;
	width:70px;
	vertical-align:top;
	font-size: 14px;
}
.header_box .header-btn a:link {
	color: #0000cc;
}
.header_box .header-btn a:VISITED {
	color: #0000cc;
}
.header_box .header-btn a:hover  {
	color: red;
}

.header-title{
	float:left;
	margin-right:15px;
	font-weight: bold;
}
.header-text{
	margin-right:15px;
	line-height:25px;
	color: #FF0033;
	white-space: nowrap;
}

</style>
<script>

	function setting(e){
		var url = "../kms_person_follow/kmsPersonFollow.do?method=view";
		var args = {portletId:e.id};
		var isRefresh = window.showModalDialog(url,args,"dialogwidth:760px;dialogheight:564px;resizable:1","scroll:0");
		if(isRefresh){
			$(e).attr("load",false); 
			KMS_PORTLET(e.id);
		}
	}

	function changeByModel(value,e){
		var param = {
				param:value,
				pageno:1
			};
		KMS.page.listExpand(param);
	}

</script>
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
						<li><a href="javascript:myPage('method=myKmInfo');" title="我的KM">我的KM</a></li>
					</c:if>
					<li><a href="javascript:myPage('method=personalInfo');" title="基本信息">基本信息</a></li>
					<li class='on'><a href="javascript:myPage('method=followSetting');" title="我的订阅">我的订阅</a></li>
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
			<kms:tabportlet cssClass="con con2 con2_2 m_t10" id="kmsFollowTabview" template="portlet_todo_list_nav_tmpl" selected="${param.selected }">
				<kms:portlet title="最新订阅" cssClass="tagContent" id="followCategory" dataType="Bean" dataBean="kmsPersonFollowPortlet" beanParm="{rowsize:5,s_method:\"personAllFollowList\",fdPersonId:\"${param.fdPersonId}\"}" template="portlet_follow_list_tmpl" callBack="KMS.listCallBack"></kms:portlet>
				<kms:portlet title="历史订阅" cssClass="tagContent" id="followHistory" dataType="Bean" dataBean="kmsPersonFollowPortlet" beanParm="{rowsize:5,s_method:\"personHistoryFollowList\",fdPersonId:\"${param.fdPersonId}\"}" template="portlet_history_follow_list_tmpl" callBack="KMS.listCallBack"></kms:portlet>
			</kms:tabportlet>
		</div>
		<!--<iframe src="../kms_person_follow/kmsPersonFollow.do?method=view" style="width:765px;height:600px;"  frameborder="no" border="0" marginwidth="0" marginheight="0" scrolling="no" allowtransparency="yes"></iframe>
	--></div>
	<!-- end cont2 -->
</div>
<!-- main2 end -->
<%@ include file="/kms/common/resource/jsp/index_down.jsp" %> 