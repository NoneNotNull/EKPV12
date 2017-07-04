<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%> 
<%@ include file="/kms/multidoc/kms_multidoc_ui/kmsMultidocKnowledge_index.jsp" %>

<%--@ include file="/kms/common/resource/jsp/index_top.jsp" %> 
<%@ include file="index_js.jsp" %>
<%@ include file="index_tmpl.jsp" %>

	<div id="main" class="box c">
		<div class="leftbar">
			<div class="box1">
				<kms:portlet title="知识分类" id="kmsMultidocPre" dataType="Bean" dataBean="kmsHomeMultidocService" beanParm="{s_method:\"updateMultidocPreview\",fdCategoryId:\"${ param.fdCategoryId}\"}" template="portlet_doc_pre_tmpl"></kms:portlet>
			</div>
			
			<kms:portlet title="知识查询方式" cssClass="box3 m_t10" id="filterList" dataType="Bean" dataBean="kmsHomeFilterXMLService" template="portlet_doc_filterList_tmpl"></kms:portlet>				
			
		</div><!-- end leftbar -->

		<div class="content">
			<kms:portlet cssClass="box3 c" title="推荐知识" id="kmsDocIntroPortlet" dataType="Bean" dataBean="kmsKnowledgeIntroService" beanParm="{fdModelId:\"${param.fdId}\"}" template="portlet_intro_doc_tmpl"></kms:portlet>
			<kms:portlet cssClass="box3 m_t10" title="最新知识" id="kmsLatestDocPortlet" dataType="Bean" dataBean="kmsDocKnowledgePortlet" beanParm="{rowsize:6,fdCategoryId:\"${ param.fdCategoryId}\",ordertype:\"down\",orderby:\"docCreateTime\"}" template="portlet_doc_tmpl"></kms:portlet>
			<kms:portlet cssClass="box3 m_t10" title="知识阅读排行" id="kmsReadCountMultidoc" dataType="Bean" dataBean="kmsHomeMultidocService" beanParm="{rowsize:6,s_method:\"findKnowledgeSortByReadCount\",fdCategoryId:\"${ param.fdCategoryId}\",ordertype:\"down\",orderby:\"docReadCount\"}" template="portlet_doc_read_tmpl"></kms:portlet>
			<kms:portlet cssClass="box3 m_t10" title="知识点评排行" id="kmsEvaluationMultidoc" dataType="Bean" dataBean="kmsHomeMultidocService" beanParm="{rowsize:6,s_method:\"findKnowledgeSortByEvaluation\",fdCategoryId:\"${ param.fdCategoryId}\",ordertype:\"down\",orderby:\"docEvalCount\"}" template="portlet_doc_star_tmpl"></kms:portlet>
			<kms:portlet cssClass="box3 m_t10" title="知识推荐排行" id="kmsIntroduceMultidoc" dataType="Bean" dataBean="kmsHomeMultidocService" beanParm="{rowsize:6,s_method:\"findKnowledgeSortByIntroduce\",fdCategoryId:\"${ param.fdCategoryId}\",ordertype:\"down\",orderby:\"docIntrCount\"}" template="portlet_doc_intro_tmpl"></kms:portlet>
		</div><!-- end content -->

		<div class="rightbar">
		
			<kms:portlet cssClass="share_box box3" title="多维库知识数" id="multidocAccount" dataType="Bean" dataBean="kmsHomeMultidocService" beanParm="{s_method:\"getCount\"}" template="portlet_multidoc_count_tmpl" callBack="bindButton"></kms:portlet>

			<div class="box3 m_t10">
				<div class="title1 c">
					<h2>知识积分排行榜</h2>
					<a href="${kmsBasePath}/communitycko/kms_communitycko_per_score_sum/kmsCommunityckoPerScoreSum.do?method=indexList&selectTab=1" target="_blank" class="more">更多&nbsp;&gt;</a>
				</div>
				<div class="box2">
					<kms:portlet cssClass="personal_box c" title="推荐之星" id="introStar" dataType="Bean" dataBean="kmsHomeIntroStarCommonService" beanParm="{s_method:\"getIntroStar\",fdModelId:\"${param.fdId}\"}" template="portlet_intro_star_tmpl"></kms:portlet>	
					<kms:tabportlet cssClass="tabview" id="kmsPersonalTabView" template="portlet_nav_tmpl">
						<kms:portlet title="本月排行" id="personalIntegralMonth" dataType="Bean" dataBean="kmsPersonalIntegralMonthPortlet" beanParm="{uuid:\"${param.fdId}\"}" template="portlet_per_integral_tmpl"></kms:portlet>
						<kms:portlet title="总排行" id="personalIntegral" dataType="Bean" dataBean="kmsPersonalIntegralPortlet" beanParm="{uuid:\"${param.fdId}\"}" template="portlet_per_integral_tmpl"></kms:portlet>
					</kms:tabportlet>
				</div>
			</div><!-- end box3 -->
			
		</div><!-- end  rightbar-->
	</div><!-- main end -->
 
<%@ include file="/kms/common/resource/jsp/index_down.jsp" --%> 