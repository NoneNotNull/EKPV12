<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%> 
<%@page import="com.landray.kmss.kms.common.util.PortalUtil"%>
<%
	KmsPortalForm kmsPortalForm = PortalUtil.getKmsPortal(request, "com.landray.kmss.kms.multidoc");
	request.setAttribute("model", kmsPortalForm);
	request.setAttribute("user", UserUtil.getUser());
%>
<%@ include file="/kms/common/resource/jsp/index_top.jsp" %> 
<%@ include file="index_js_extend.jsp" %>
<%@ include file="index_tmpl_extend.jsp" %>



<div class="wrap980 fix" style="margin-top: 10px;">
	<div style="width: 780px;float: right;padding-bottom: 10px">
		<div class="searchD">
			<b class="searL">&nbsp;</b>
			<input type="button" class="btn" id="searchBtn"/>
			<input type="text" class="inp" id="queryString" value="请输入关键字" onfocus="if(value=='请输入关键字'){value=''}" onblur="if(value==''){value='请输入关键字'}"/>
		</div>
		
		<div class="release">
			<a href="javascript:void(0)" id="btn_share"></a>
		</div>
	</div>
	
	<div class="iMenu">
		<div class="menuTit"><h2><a href="javascript:docListPage('');">知识分类</a></h2></div>
		<div >
			<div id="accordian" s_bean="kmsDocknowledgeCategoryExtendPortlet">
			</div>	
		</div>
	</div>
	
  <div class="iMain" >
	<kms:portlet id="kmsKnowledgeIntro" dataType="Bean" dataBean="kmsKnowledgeIntroService" beanParm="{fdModelId:\"${param.fdId}\"}" template="portlet_intro_pic_tmpl" callBack="sliderDocIntro"></kms:portlet>
	
	<div class="mt10 newBook">
      <h2 class="modTit" style="text-align: left;">最新发布<a href="javascript:docListPage('');" class="more">更多</a></h2>
      <kms:portlet cssClass="slideWrap fixs" id="newDoc" dataType="Bean" dataBean="kmsDocKnowledgePortlet" beanParm="{rowsize:10,ordertype:\"down\",orderby:\"docCreateTime\"}" template="portlet_new_pic_tmpl" callBack="move"></kms:portlet>
    </div>
    
    <div class="mt10 hotTop">
    	<h2 class="modTit" style="text-align: left;">热门排行<a href="javascript:docListPage('');" class="more">更多</a></h2>
    	<kms:portlet cssClass="slideWrap fixs" id="hotDoc" dataType="Bean" dataBean="kmsDocKnowledgePortlet" beanParm="{rowsize:10,ordertype:\"down\",orderby:\"docReadCount\"}" template="portlet_new_pic_tmpl" callBack="move"></kms:portlet>
    </div>
    
    
  </div>
</div>
 
<%@ include file="/kms/common/resource/jsp/index_down.jsp" %> 