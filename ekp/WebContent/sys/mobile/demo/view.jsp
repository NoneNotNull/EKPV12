<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="/WEB-INF/KmssConfig/sys/ui/template.tld" prefix="template"%>
<template:include ref="mobile.view">
	<template:replace name="title">
		阅读页面样例
	</template:replace>
	<template:replace name="content">
		<div data-dojo-type="mui/view/DocScrollableView">
			<div class="muiDocFrame">
	            <span class="muiDocSubject">我是标题</span>
	            <div class="muiDocInfo">
	                <span>2014-7-30</span>
	                <span>作者：管理员</span>
	                <span>阅读量：999</span>
	            </div>
	            <p class="muiDocSummary">
	            	<span class="muiDocSummarySign">摘要</span>
	            	<span>
	            		周永康，原名周元根，男，汉族，1942年12月生，江苏无锡人，1964年11月入党，1966年9月参加工作，北京石油学院勘探系地球物理勘探专业毕业，大学学历，教授级高级工程师。曾任十七届中央政治局委员、常委。
	            		2014年07月29日，中共中央鉴于周永康涉嫌严重违纪，决定由中共中央纪律检查委员会对其立案审查。 
	            	</span>
				</p>
				<span class="muiDocContent">
					<%@include file="/sys/mobile/demo/viewContent.jsp"%>
					<%-- 内容样例代码 
						<xform:rtf property="docContent" mobile="true"></xform:rtf>
					--%>
				</span>
	        </div>
		</div>
		<ul data-dojo-type="dojox/mobile/TabBar" fixed="bottom" data-dojo-props='fill:"always"'>
			<!-- 返回 -->
			<li data-dojo-type="mui/back/BackButton"
			    data-dojo-props='align:"left"'></li>
			<!-- 点评 -->
			<li data-dojo-type="mui/tabbar/TabBarButton"
			    data-dojo-props='icon1:"fa fa-comment-o",align:"right",badge:12' ></li>
			<!-- 推荐 -->
		   	<li data-dojo-type="mui/tabbar/TabBarButton"
			    data-dojo-props='icon1:"fa fa-share-square-o",badge:8'></li>
		    <!-- 收藏 -->
			<li data-dojo-type="mui/tabbar/TabBarButton"
			    data-dojo-props='icon1:"fa fa-star-o",align:"left"'></li>
			<%-- 收藏样例代码
			<c:import url="/sys/bookmark/mobile/import/view.jsp" charEncoding="UTF-8">
				<c:param name="fdSubject" value="${kmsMultidocKnowledgeForm.docSubject}" />
				<c:param name="fdModelId" value="${kmsMultidocKnowledgeForm.fdId}" />
				<c:param name="fdModelName" value="com.landray.kmss.kms.multidoc.model.KmsMultidocKnowledge" />
			</c:import>
			--%>
			<!-- 更多 -->
			<li data-dojo-type="mui/tabbar/TabBarButtonGroup"
			    data-dojo-props='icon1:"fa fa-ellipsis-h",align:"right"'>
		    	<div data-dojo-type="mui/tabbar/TabBarButton"
		    		data-dojo-props='icon1:"fa fa-ellipsis-h"'>关联</div>
		    	<div data-dojo-type="mui/tabbar/TabBarButton"
		    		data-dojo-props='icon1:"fa fa-font"'>设置</div>
			</li>
		</ul>
	</template:replace>
</template:include>
