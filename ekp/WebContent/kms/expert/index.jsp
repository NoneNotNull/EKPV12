<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%> 
<%@ include file="/kms/expert/kms_expert_info_ui/kmsExpertInfo_index.jsp" %>
<%--
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%> 
<%@ include file="/kms/common/resource/jsp/index_top.jsp" %> 
<%@ include file="index_js.jsp" %>
<%@ include file="index_tmpl.jsp" %>

<div id="main" class="box c">
	<div class="leftbar">
		<kms:portlet cssClass="share_box share_box2 box3" title="专家数" id="expertAccount" dataType="Bean" dataBean="kmsHomeExpertService" beanParm="{s_method:\"getCount\"}" template="portlet_expert_count_tmpl" callBack="bindButton"></kms:portlet>
		<kms:portlet cssClass="box1 m_t10" title="专家领域"  id="kmsExpertPre" dataType="Bean" dataBean="kmsHomeExpertService" beanParm="{s_method:\"updateExpertPreview\",fdCategoryId:\"${param.fdCategoryId }\"}" template="portlet_doc_pre_tmpl"></kms:portlet>
	</div><!-- end leftbar -->

	<div class="content2">
		<kms:portlet cssClass="location" title="专家路径" id="location" dataType="Bean" dataBean="kmsHomeExpertService" beanParm="{s_method:\"getSPath\",fdCategoryId:\"${param.fdCategoryId }\"}" template="portlet_expert_location_tmpl" ></kms:portlet>
		<kms:tabportlet cssClass="con con2 con2_2 m_t10" id="expertTabview" template="portlet_expert_list_nav_tmpl">
			<kms:portlet title="所有专家" cssClass="tagContent" id="allExpert" dataType="Bean" dataBean="kmsHomeExpertService" beanParm="{rowsize:10,s_method:\"findExpertList\",s_block:\"all\",ordertype:\"down\",expert:\"true\",fdCategoryId:\"${param.fdCategoryId }\"}" template="portlet_expert_list_tmpl" callBack="KMS.listCallBack"></kms:portlet>
			<kms:portlet title="新进专家" cssClass="tagContent" id="newExpert" dataType="Bean" dataBean="kmsHomeExpertService" beanParm="{rowsize:10,s_method:\"findExpertList\",s_block:\"new\",ordertype:\"down\",expert:\"true\",fdCategoryId:\"${param.fdCategoryId }\"}" template="portlet_expert_list_tmpl" callBack="KMS.listCallBack"></kms:portlet>
		</kms:tabportlet>
	</div>
</div><!-- main end -->
<%@ include file="/kms/common/resource/jsp/index_down.jsp" %>    --%>