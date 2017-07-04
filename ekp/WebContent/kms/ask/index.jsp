<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%> 
<%@ include file="/kms/ask/kms_ask_ui/kmsAskTopic_index.jsp" %>
<%--@ include file="/kms/common/resource/jsp/index_top.jsp" %> 
<%@ include file="index_js.jsp" %>
<%@ include file="index_tmpl.jsp" %>
 
<div id="main" class="box c">
		<div class="leftbar">
			<div class="box1">
				<kms:portlet title="爱问分类" id="kmsAskPre" dataType="Bean" dataBean="kmsHomeAskService" beanParm="{s_method:\"updateAskPreview\",fdCategoryId :\"${param.fdCategoryId}\"}" template="portlet_doc_pre_tmpl"></kms:portlet>
			</div>
		</div><!-- end leftbar -->

		<div class="content">
			<kms:portlet title="推荐问题" cssClass="box3 c" id="introduceAsk" dataType="Bean" dataBean="kmsHomeAskService" beanParm="{s_method:\"getIntroduceAsk\",fdId:\"${param.fdId }\",fdCategoryId :\"${param.fdCategoryId}\"}" template="portlet_ask_intro_tmpl"></kms:portlet>
			<kms:portlet title="进行中的问题 " cssClass="box3 m_t10 c" id="unsolveAsk" dataType="Bean" dataBean="kmsHomeAskService" beanParm="{s_method:\"getUnsolvedAsk\",fdId:\"${param.fdId }\",fdCategoryId :\"${param.fdCategoryId}\"}" template="portlet_ask_unsolve_tmpl"></kms:portlet>
			<kms:portlet title="最新解决问题" cssClass="box3 m_t10 c" id="newestEndAsk" dataType="Bean" dataBean="kmsHomeAskService" beanParm="{s_method:\"getNewestEndAsk\",fdId:\"${param.fdId }\",fdCategoryId :\"${param.fdCategoryId}\"}" template="portlet_ask_end_tmpl"></kms:portlet>
		</div><!-- end content -->

		<div class="rightbar">
			<kms:portlet cssClass="share_box box3" title="爱问知识数" id="askAccount" dataType="Bean" dataBean="kmsHomeAskService" beanParm="{s_method:\"getCount\"}" template="portlet_ask_count_tmpl" callBack="bindButton"></kms:portlet>
			<kms:portlet cssClass="box3 m_t10" title="知识达人" id="perOfAsk" dataType="Bean" dataBean="kmsHomeAskService" beanParm="{s_method:\"getPeopleOfAsk\",expert:\"true\",fdCategoryId :\"${param.fdCategoryId}\"}" template="portlet_ask_per_tmpl"></kms:portlet>

			<div class="box3 m_t10" >
				<div class="title1 c">
					<h2>爱问积分排行榜</h2>
					<a href="${kmsBasePath}/communitycko/kms_communitycko_per_score_sum/kmsCommunityckoPerScoreSum.do?method=indexList&selectTab=2" target="_blank" class="more">更多&nbsp;&gt;</a>
				</div>
				<div class="box2">
					<kms:portlet cssClass="personal_box c" title="推荐之星" id="introStar" dataType="Bean" dataBean="kmsHomeIntroStarCommonService" beanParm="{s_method:\"getIntroStar\",fdModelId:\"${param.fdId}\"}" template="portlet_intro_star_tmpl"></kms:portlet>	
					<kms:tabportlet cssClass="tabview integral" id="kmsPersonalTabView" template="portlet_nav_tmpl">
						<kms:portlet title="本月排行" id="personalIntegralMonth" dataType="Bean" dataBean="kmsPersonalIntegralMonthPortlet" beanParm="{uuid:\"${param.fdId}\"}" template="portlet_per_integral_tmpl"></kms:portlet>
						<kms:portlet title="总排行" id="personalIntegral" dataType="Bean" dataBean="kmsPersonalIntegralPortlet" beanParm="{uuid:\"${param.fdId}\"}" template="portlet_per_integral_tmpl"></kms:portlet>
					</kms:tabportlet>
				</div>
			</div><!-- end box3 -->
		</div><!-- end  rightbar-->
	</div><!-- main end -->

<%@ include file="/kms/common/resource/jsp/index_down.jsp" --%> 