<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%> 
<%@ include file="/kms/kmaps/kms_kmaps_ui/kmsKmapsMain_index.jsp" %>
<%--@ include file="/kms/common/resource/jsp/index_top.jsp" %> 
<%@ include file="index_js.jsp" %>
<%@ include file="index_tmpl.jsp" %>

<div id="main" class="box c">
		<div class="leftbar">
			<kms:portlet cssClass="share_box share_box2 box3" title="地图知识数" id="kmapsAccount" dataType="Bean" dataBean="kmsKmapsCountPortlet" beanParm="{s_type:\"ekp\"}" template="portlet_kmaps_count_tmpl" callBack="bindButton"></kms:portlet>
			<kms:portlet cssClass="box1 m_t10" title="地图分类" id="kmsKmapsPre" dataType="Bean" dataBean="kmsKmapsPreviewPortlet" beanParm="{s_type:\"ekp\"}" template="portlet_kmaps_pre_tmpl"></kms:portlet>
		</div><!-- end leftbar -->

		<div class="content2">
			<kms:portlet cssClass="location" title="地图路径" id="location" dataType="Bean" dataBean="kmsKmapsPathPortlet" beanParm="{s_type:\"ekp\",fdCategoryId:\"${param.fdCategoryId }\"}" template="portlet_kmaps_location_tmpl" ></kms:portlet>
			<kms:tabportlet cssClass="con con2 con2_2 m_t10" id="kmapsTabview" template="portlet_kmaps_list_nav_tmpl">
				<kms:portlet title="所有地图" cssClass="tagContent" id="allKmaps" dataType="Bean" dataBean="kmsKmapsListPortlet" beanParm="{rowsize:10,orderby:\"docCreateTime\",ordertype:\"down\",fdCategoryId:\"${param.fdCategoryId }\",s_type:\"ekp\"}" template="portlet_kmaps_list_tmpl" callBack="KMS.listCallBack"></kms:portlet>
				<kms:portlet title="最新地图" cssClass="tagContent" id="newKmaps" dataType="Bean" dataBean="kmsKmapsListPortlet" beanParm="{rowsize:10,orderby:\"docCreateTime\",ordertype:\"down\",fdCategoryId:\"${param.fdCategoryId }\",s_type:\"ekp\"}" template="portlet_kmaps_list_tmpl" callBack="KMS.listCallBack"></kms:portlet>
				<kms:portlet title="热门地图" cssClass="tagContent" id="hotKmaps" dataType="Bean" dataBean="kmsKmapsListPortlet" beanParm="{rowsize:10,orderby:\"docReadCount\",ordertype:\"down\",fdCategoryId:\"${param.fdCategoryId }\",s_type:\"ekp\"}" template="portlet_kmaps_list_tmpl" callBack="KMS.listCallBack"></kms:portlet>
				<kms:portlet title="推荐地图" cssClass="tagContent" id="introKmaps" dataType="Bean" dataBean="kmsKmapsListPortlet" beanParm="{rowsize:10,orderby:\"docIntrCount\",ordertype:\"down\",fdCategoryId:\"${param.fdCategoryId }\",s_type:\"ekp\",s_block:\"intro\"}" template="portlet_kmaps_list_tmpl" callBack="KMS.listCallBack"></kms:portlet>
			</kms:tabportlet>
			<div class="con con2 con2_2 m_t10" >
				
			</div>
		</div>
	</div><!-- main end -->

<%@ include file="/kms/common/resource/jsp/index_down.jsp" --%> 
