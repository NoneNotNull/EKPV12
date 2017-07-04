<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<%@ taglib uri="/WEB-INF/KmssConfig/sys/portal/portal.tld"
	prefix="portal"%>
<!doctype html>
<html>
<head>
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<%@ include file="/sys/ui/jsp/jshead.jsp"%>
<script type="text/javascript">
	seajs.use([ 'lui/jquery','theme!list', 'theme!portal' ],function($, strutil, dialog){
		 window.setTab = function(cursel,src) {
			 //alert(src);
			 $('#tabHeader').find('li').each(function(i,n){
			     var obj = $(n);
			     if(cursel == i){
			    	 //obj.className = "selected";
			    	 obj.addClass("selected");
			     }else{
			    	 //obj.className = "";
			    	 obj.removeClass("selected");
			     }
			  });

			 $('.custom_mainContainer').find('>div').each(function(i,n){
			     var obj = $(n);
			     if(cursel == i){
				     //obj.css('height',320);
				     obj.css('min-height',320);
				     obj.show();
				     var curIframe = obj.find('iframe');
				     if(curIframe.attr('src')){
					     
				     }else{
				    	 curIframe.attr('src',src);
				     }
				     
			     }else{
				     obj.hide();
			     }
			  });

	     };

	     $(window).load(function() {
	    	 //setTab(0,${keydataPluginShowDatas[0].actionUrl});
	    	 //alert();
	    	 //alert(2);
	     });

	    
/*
	     $("iframe").each(function(){
	    	    $(this).load(function(){
	    	    	var mainheight = $(this).contents().find("body").height()+400;
	    	    	$(this).height(mainheight);
	    	    });
	     });
*/
	     window.setHeight = function(src, height){
		     //alert(height);
		     //$("iframe[src='"+src+"']").height(height+30);
	    	 //var main = $(window.parent.document).find("#iframe");
	    	// var thisheight = $(document).height()+30;
	    	// main.height(thisheight);
	     }
		
	});

	 window.onload = function(){
		 //alert();
		 //setTimeout("initTab()",50);
    	 
     };

     window.initTab = function(){
    	 var tabObj = document.getElementById('tabhead_0');
    	 if(tabObj){
    		 tabObj.click();
    	 }else{
    		 setTimeout("initTab()",200);
    	 }
    	 
     }
	
	
</script>

<title><template:block name="title" /></title>

<template:block name="head" >
		<link rel="stylesheet" type="text/css" href="${ LUI_ContextPath}/km/keydata/resources/css/keydata.css">
</template:block>
</head>
<body>
	<!-- 头部 Starts-->
    <div class="custom_headerWrapper">
        <div class="custom_headerWrapperImg">
            <div class="custom_headerInner">
                <div class="custom_headerTitle">
                    <h2><template:block name="title" /></h2>
                    <ul class="custom_headerBtnGroup">
                    	<template:block name="headerBtnGroup" >
                        	<li><a href="#" title="">编辑</a></li>
                        	<li><a href="#" title="">关闭</a></li>
                        </template:block>
                    </ul>
                </div>
                <div class="custom_headerInfoBoard">
                	<ul class="custom_headerInfoList">
                	<template:block name="dataAttrs" />
                	<!-- 
                    
                        <li>
                            <span class="title">客户名称：</span>
                            <span class="txt">客户22</span>
                        </li>
                        <li>
                            <span class="title">客户编号：</span>
                            <span class="txt">0000000002</span>
                        </li>
                        <li>
                            <span class="title">创建时间：</span>
                            <span class="txt">2015-01-05 14:11</span>
                        </li>
                        <li>
                            <span class="title">最后修改时间：</span>
                            <span class="txt">2015-01-05 14:11</span>
                        </li>
                        <li>
                            <span class="title">公司电话：</span>
                            <span class="txt">0755-26012345-8414</span>
                        </li>
                        <li>
                            <span class="title">创建者：</span>
                            <span class="txt">管理员</span>
                        </li>
						 <li>
                            <span class="title">最后修改时间：</span>
                            <span class="txt">2015-01-05 14:11</span>
                        </li>
                        <li>
                            <span class="title">公司电话：</span>
                            <span class="txt">0755-26012345-8414</span>
                        </li>
                        <li>
                            <span class="title">创建者：</span>
                            <span class="txt">管理员</span>
                        </li>
                    
                    <div class="custom_headerBtnMoreBar">
                        <span class="custom_btnSlideMore">展开更多</span>
                    </div>
                     -->
                     </ul>
                </div>
            </div>
        </div>
    </div>
    <!-- 头部 Ends -->
	<!-- 主体内容 Starts-->
    <div class="custom_mainContainer">
        <!-- 选项卡头部 Starts-->
        <template:block name="dataUsedBody" >
        
		
        <ul class="custom_tabHeader" id="tabHeader">
        	 <c:forEach items="${keydataPluginShowDatas}" var="keydataPluginShowData" varStatus="vstatus">
					<li id="tabhead_${vstatus.index}" onclick="setTab(${vstatus.index},'${keydataPluginShowData.actionUrl }')"
					<c:if test="${vstatus.index==0}"> class="selected" </c:if> >
		                <div class="iconBox"><i class="icon iconContract"></i></div>
		                <p class="txt">${keydataPluginShowData.name }</p>
		                <div class="bgLine"></div>
            		</li>
			</c:forEach>
        </ul>
        
        <c:forEach items="${keydataPluginShowDatas}" var="keydataPluginShowData" varStatus="vstatus">
					
            		<div class="custom_tabContent" id="con_tabhead_${vstatus.index}" 
            		<c:if test="${vstatus.index!=0}"> style="display:none;" </c:if>
            		height="350px;">
            			<iframe width="100%" height="300px;" <c:if test="${vstatus.index==0}"> src="${keydataPluginShowData.actionUrl }" </c:if>
            			 style="min-height: 300px;"></iframe>
        			</div>
		</c:forEach>
        
       
        <!-- 选项卡内容 Ends -->
		</template:block>
    </div>
    <!-- 主体内容 Ends -->
</body>
</html>
