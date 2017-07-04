<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%> 
<%@ include file="/kms/common/resource/jsp/index_top.jsp" %> 
<%@ include file="/kms/ask/kms_ask_list/kms_ask_list_js.jsp" %>
<%@ include file="/kms/ask/kms_ask_list/kms_ask_list_tmpl.jsp" %>
<div id="main" class="box c">
		<div class="content3">
			<kms:portlet title="当前路径" cssClass="location" id="location" dataType="Bean" dataBean="kmsHomeAskService" beanParm="{s_method:\"getSPath\",fdCategoryId :\"${param.fdCategoryId}\"}" template="portlet_ask_path_tmpl"></kms:portlet>
			<div class="location">
			</div>
			<div class="r_a m_t10">
				<div class="t_l"></div><div class="t_r"></div><div class="b_l"></div><div class="b_r"></div>
				<kms:portlet title="分类筛选框" cssClass="r_con c" id="filterAsk" dataType="Bean" dataBean="kmsHomeAskService" beanParm="{s_method:\"getCategoryFilter\",fdCategoryId :\"${param.fdCategoryId}\"}" template="portlet_ask_filter_tmpl" callBack="hideMore"></kms:portlet>	
			</div><!-- end r_a -->

			<kms:tabportlet cssClass="con con2 con2_2 m_t20" id="askTabview" template="portlet_ask_list_nav_tmpl"  selected="${param.more }">
				<kms:portlet title="待解决" cssClass="tagContent" id="solvingAsk" dataType="Bean" dataBean="kmsHomeAskService" beanParm="{s_method:\"findAskList\",s_block :\"solvingAsk\",fdCategoryId :\"${param.fdCategoryId}\",fdGroupId:\"${param.fdGroupId }\"}" template="portlet_ask_list_tmpl" callBack="KMS.listCallBack"></kms:portlet>
				<kms:portlet title="已解决" cssClass="tagContent" id="solvedAsk" dataType="Bean" dataBean="kmsHomeAskService" beanParm="{s_method:\"findAskList\",s_block :\"solvedAsk\",fdCategoryId :\"${param.fdCategoryId}\",fdGroupId:\"${param.fdGroupId }\"}" template="portlet_ask_list_tmpl" callBack="KMS.listCallBack"></kms:portlet>
				<kms:portlet title="高悬赏" cssClass="tagContent" id="scoreAsk" dataType="Bean" dataBean="kmsHomeAskService" beanParm="{s_method:\"findAskList\",s_block :\"scoreAsk\",fdCategoryId :\"${param.fdCategoryId}\",fdGroupId:\"${param.fdGroupId }\"}" template="portlet_ask_list_tmpl" callBack="KMS.listCallBack"></kms:portlet>
				<kms:portlet title="推荐" cssClass="tagContent" id="introAsk" dataType="Bean" dataBean="kmsHomeAskService" beanParm="{s_method:\"findAskList\",s_block :\"introAsk\",fdCategoryId :\"${param.fdCategoryId}\",fdGroupId:\"${param.fdGroupId }\"}" template="portlet_ask_list_tmpl" callBack="KMS.listCallBack"></kms:portlet>
				<kms:portlet title="全部" cssClass="tagContent" id="allAsk" dataType="Bean" dataBean="kmsHomeAskService" beanParm="{s_method:\"findAskList\",s_block :\"allAsk\",fdCategoryId :\"${param.fdCategoryId}\",fdGroupId:\"${param.fdGroupId }\"}" template="portlet_ask_list_tmpl" callBack="KMS.listCallBack"></kms:portlet>
			</kms:tabportlet>
		</div>
		<div class="rightbar">
			<kms:portlet cssClass="box3 m_t10" title="分类知识专家" id="perOfAsk" dataType="Bean" dataBean="kmsHomeAskService" beanParm="{s_method:\"getPeopleOfAsk\",fdCategoryId:\"${param.fdCategoryId}\",expert:\"true\"}" template="portlet_ask_per_tmpl"></kms:portlet>
			<div class="box3 m_t10">
				<div class="title1 c">
					<h2>爱问积分排行榜</h2>
					<a href="${kmsBasePath}/communitycko/kms_communitycko_per_score_sum/kmsCommunityckoPerScoreSum.do?method=indexList&selectTab=2" target="_blank" class="more">更多&nbsp;&gt;</a>
				</div>
				<div class="box2">
				<kms:tabportlet cssClass="tabview" id="kmsPersonalTabView" template="portlet_nav_tmpl">
					<kms:portlet title="本月排行" id="personalIntegralMonth" dataType="Bean" dataBean="kmsPersonalIntegralMonthPortlet" beanParm="{uuid:\"com.landray.kmss.kms.ask\"}" template="portlet_per_integral_tmpl"></kms:portlet>
					<kms:portlet title="总排行" id="personalIntegral" dataType="Bean" dataBean="kmsPersonalIntegralPortlet" beanParm="{uuid:\"com.landray.kmss.kms.ask\"}" template="portlet_per_integral_tmpl"></kms:portlet>
				</kms:tabportlet>
				</div>
			</div>
		</div><!-- end  rightbar-->
	</div><!-- main end -->
<%@ include file="/kms/common/resource/jsp/index_down.jsp" %> 