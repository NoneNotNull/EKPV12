<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%> 
<%@ include file="/kms/wiki/kms_wiki_main_ui/kmsWikiMain_index.jsp" %>
<%-- 
<%@ include file="/kms/common/resource/jsp/index_top.jsp" %> 
<%@ include file="/kms/wiki/index_tmpl.jsp" %>
<%@ include file="/kms/wiki/index_js.jsp" %>
<div id="main" class="box c">  
		<div class="content3">
			<kms:portlet title="当前路径" cssClass="location" id="location" dataType="Bean" dataBean="kmsHomeWikiService" beanParm="{s_method:\"getSPath\",fdCategoryId :\"${param.fdCategoryId}\"}" template="portlet_wiki_path_tmpl"></kms:portlet>
			<div class="r_a m_t10">
				<div class="t_l"></div><div class="t_r"></div><div class="b_l"></div><div class="b_r"></div>
				<kms:portlet title="分类筛选框" cssClass="r_con c" id="filterWiki" dataType="Bean" dataBean="kmsHomeWikiService" beanParm="{s_method:\"getCategoryFilter\",fdCategoryId :\"${param.fdCategoryId}\"}" template="portlet_wiki_filter_tmpl" ></kms:portlet>	
			</div><!-- end r_a -->
			
			<c:if test="${not empty param.fdCategoryId}">
			<div id="propFilter"></div>
			</c:if>
			
			<kms:tabportlet cssClass="con con2 con2_2 m_t20" id="wikiTabview" template="portlet_wiki_list_nav_tmpl" >
				<kms:portlet title="最新词条" cssClass="tagContent" id="newWiki" dataType="Bean" dataBean="kmsHomeWikiService" beanParm="{rowsize:15,s_method:\"findWikiList\",orderby:\"fdLastModifiedTime\",ordertype:\"down\",fdCategoryId :\"${param.fdCategoryId}\"}" template="portlet_wiki_list_tmpl" callBack="KMS.listCallBack"></kms:portlet>
				<kms:portlet title="最热词条" cssClass="tagContent" id="hotWiki" dataType="Bean" dataBean="kmsHomeWikiService" beanParm="{rowsize:15,s_method:\"findWikiList\",orderby :\"docReadCount\",ordertype:\"down\",fdCategoryId :\"${param.fdCategoryId}\"}" template="portlet_wiki_list_tmpl" callBack="KMS.listCallBack"></kms:portlet>
			</kms:tabportlet>
		</div>
		<div class="rightbar">
			<kms:portlet cssClass="share_box box3" title="维基库知识数" id="wikiAccount" dataType="Bean" dataBean="kmsHomeWikiService" beanParm="{s_method:\"getCount\"}" template="portlet_wiki_count_tmpl" callBack="bindButton"></kms:portlet>
			<kms:portlet cssClass="box3 m_t10" title="最新推荐词条" id="introWiki" dataType="Bean" dataBean="kmsHomeWikiService" beanParm="{s_method:\"getIntroduceWiki\",rowsize:8,fdCategoryId :\"${param.fdCategoryId}\"}" template="portlet_wiki_intro_tmpl" callBack="bindButton"></kms:portlet>
			<div class="box3 m_t10">
					<div class="title1">
						<h2> 维基库积分排行榜</h2>
						<a href="${kmsBasePath}/communitycko/kms_communitycko_per_score_sum/kmsCommunityckoPerScoreSum.do?method=indexList&selectTab=3" target="_blank" class="more">更多&nbsp;&gt;</a>	
					</div>
					<div class="box2">
					<kms:portlet cssClass="personal_box c" title="推荐之星" id="introStar" dataType="Bean" dataBean="kmsHomeIntroStarCommonService" beanParm="{s_method:\"getIntroStar\",fdModelId:\"${param.fdId}\"}" template="portlet_intro_star_tmpl"></kms:portlet>	
					<kms:tabportlet cssClass="tabview" id="kmsPersonalTabView" template="portlet_nav_tmpl">
						<kms:portlet title="本月排行" id="personalIntegralMonth" dataType="Bean" dataBean="kmsPersonalIntegralMonthPortlet" beanParm="{uuid:\"${param.fdId}\"}" template="portlet_per_integral_tmpl"></kms:portlet>
						<kms:portlet title="总排行" id="personalIntegral" dataType="Bean" dataBean="kmsPersonalIntegralPortlet" beanParm="{uuid:\"${param.fdId}\"}" template="portlet_per_integral_tmpl"></kms:portlet>
					</kms:tabportlet>
				</div>
			</div>
		</div><!-- end  rightbar-->
	</div><!-- main end -->
<%@ include file="/kms/common/resource/jsp/index_down.jsp" %> --%>