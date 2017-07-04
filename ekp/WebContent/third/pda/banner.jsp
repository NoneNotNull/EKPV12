<%@ include file="/resource/jsp/common.jsp"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@page import="com.landray.kmss.util.UserUtil"%>
<%@page import="com.landray.kmss.third.pda.service.IPdaDataShowService"%>
<%@page import="com.landray.kmss.util.ResourceUtil"%>
<%@page import="com.landray.kmss.third.pda.model.PdaModuleConfigMain"%>
<%@page import="java.util.List"%>
<%@page import="com.landray.kmss.util.SpringBeanUtil"%>
<%
	List moduleList = null;
	if ("true".equalsIgnoreCase(request.getParameter("fdNeedNav"))) {
		IPdaDataShowService showService=(IPdaDataShowService)SpringBeanUtil.getBean("pdaDataShowService");
		moduleList = showService.getPdaModuleList();
	}
%>
<%--
	url传参
	fdNeedLogo:			位于左上角 ,是否需要logo
	fdNeedHome:   		位于左上角,是否需要工作台
	fdNeedReturn:		位于左上角,是否返回该模块
	fdNeedUser:   		位于中间,当前人信息
	fdNeedOtherInfo:  	位于中间,  其他信息展示 
	fdNeedNav:			位于右上角,导航
	fdNeedLoginout:     位于右上角,注销按钮
--%>

<%@page import="java.util.Map"%>
<script type="text/javascript">
	function opt_logout(isConfirm){
		var redirect = '<c:url value="/third/pda/login.jsp?para_pda_redirectFlag=1"/>';
		redirect = encodeURI(redirect);
		if(isConfirm){
			if(confirm('<bean:message key="phone.banner.logoutconfirm" bundle="third-pda"/>')){
				location='<c:url value="/logout.jsp"/>?logoutUrl='+ redirect;
			}
		}else{
			location='<c:url value="/logout.jsp"/>?logoutUrl='+ redirect;
		}
	}
	function gotoUrl(url){
		if(window.stopBubble)
			window.stopBubble();
		location=url;
	}
	function showNav(){
		if(window.expandNav)
			window.expandNav();
	}
	function strlen(str) {		
        var len = 0;
       // var wordflag = false;
       // var flag = 0;
        for (var i = 0; i < str.length; i++) {
            var c = str.charCodeAt(i);
            if (c < 299) {
                len++;
            }
            else {
                len += 2;
               // wordflag = true;
            }
        }
        /*
        if(len > 8){
	        if (wordflag){
				flag = 4;
	        }else{
	        	flag = 8;
	        }
        }*/
		return len;
    }
</script>

<%--上层导航 --%>
<c:if test="${param.fdNeedNav==true}"> 
	<div id="div_selectinfo" class="div_navinfo">
		<div class="div_hideLeft" id="div_expandLeft" onclick="turnToLeft();"></div>
		<div id="div_navIcons" class="div_navIcon">
			<c:if test="<%=moduleList!=null && moduleList.size()>0%>">
				<c:forEach var="module" items="<%=moduleList%>">
					<%String iconUrl=(String)((Map)pageContext.getAttribute("module")).get("fdIconUrl");
						iconUrl=iconUrl.replace("module_","ico_"); %>
					<div onclick="gotoNavUrl('<c:url value="/third/pda/pda_module_config_main/pdaModuleConfigMain.do"/>?method=open&fdId=${module.fdId}');">
						<center>
							<img src="<c:url value="<%=iconUrl%>"/>"/>
						</center>
						<label>
							<c:choose>
								<c:when test="${fn:length(module.fdName)>4}">${fn:substring(module.fdName,0,3)}..</c:when>
								<c:otherwise>${module.fdName}</c:otherwise>
							</c:choose>
						</label>
					</div>
				</c:forEach>
			</c:if>
			<div onclick="opt_logout();"> 
				<center>
					<img src="<c:url value="/third/pda/resource/images/ico_logout.png"/>"/>
				</center> 
				<label><bean:message key="phone.banner.logout" bundle="third-pda"/></label>
			</div>
		</div>
		<div class="div_hideRight" id="div_expandRight" onclick="turnToRight();"></div>
	</div>
</c:if>

<%-- banner部分--%>
<div id="div_banner" class="div_banner" onclick="showNav();">

<%-- logo 信息--%>
<c:if test="${param.fdNeedLogo==true}">
	<div class="div_logo"></div>
</c:if>

<%-- 模块返回工作台--%>
<c:if test="${param.fdNeedHome==true}">
	<div class="div_return" onclick="gotoUrl('<c:url value="/third/pda/index.jsp"/>');">
		<div>
			<bean:message key="phone.banner.homepage" bundle="third-pda"/>
		</div>
		<div></div>
	</div>
</c:if>

<%-- view返回list界面--%>
<c:if test="${param.fdNeedReturn==true && param.fdModuleId!=null}">
	<script type="text/javascript">
		function gotoList(){
			var fdId='${param.fdModuleId}';
			var mobile = '${param._mobile}';
			if (mobile == '1' || mobile == 'true') {
				if(window.stopBubble)
					window.stopBubble();
				history.back();
				return;
			}
			if(fdId!=''){
				var hrefUrl='<c:url value="/third/pda/pda_module_config_main/pdaModuleConfigMain.do?method=open&fdId=${param.fdModuleId}"/>';
				gotoUrl(hrefUrl);
			}else{
				if(window.stopBubble)
					window.stopBubble();
				history.back();
			}
		}
	</script>
	<div class="div_return" onclick="gotoList();">
		<div id = "moduleDiv" style="overflow:hidden;white-space:nowrap;text-overflow:ellipsis">
		  ${param.fdModuleName}
		</div>
		<script language="JavaScript">
		    var fdModuleName = "${param.fdModuleName}";
		    var length = strlen(fdModuleName);
			 if(length>=8){
				 document.getElementById("moduleDiv").style.width = "65px";
			}
		</script>
		<div></div>
	</div>
</c:if>

<%-- 用户信息部分  --%>
<c:if test="${param.fdNeedUser==true}">
	<c:if test="<%=!UserUtil.getKMSSUser(request).isAnonymous()%>">
		<div class="div_user">&nbsp;&nbsp;<%=UserUtil.getUserName(request)%></div>
	</c:if> 
</c:if>

<%-- 其他显示信息 --%>
<c:if test="${param.fdNeedOtherInfo==true}">
	<div class="div_otherBtn" id="div_otherBtn">&nbsp;</div>
</c:if>

<%-- 导航部分  --%>
<c:if test="${param.fdNeedNav==true}">
	<script type="text/javascript">
		var S_IsExpanded=false;
		function expandNav(isButton){
			if(isButton==1)
				stopBubble();
			S_IsExpanded=!S_IsExpanded;
			document.getElementById("div_unselect").style.display=(S_IsExpanded?"none":"block");
			document.getElementById("div_select").style.display=(S_IsExpanded?"block":"none");
			document.getElementById("div_selectinfo").style.display=(S_IsExpanded?"block":"none");
		}
		function stopBubble(){
			var e= null;
			if(document.all){
				window.event.cancelBubble = true;
			}else{
				var func=stopBubble.caller;
				while(func!=null){
					var arg0=func.arguments[0];
					if(arg0){
						if((arg0.constructor==Event||arg0.constructor ==MouseEvent)
								&&(typeof(arg0)=="object" && arg0.preventDefault && arg0.stopPropagation)){
							e=arg0;
							e.stopPropagation();
						}
					}
					func=func.caller;
				}
			}
		}
		
		function loadingNav(){
			var iconWidth=60;
			var divNavInfo=document.getElementById("div_selectinfo");
			var navDiv=document.getElementById("div_navIcons");
			var banner=document.getElementById("div_banner");
			if(navDiv!=null){
				var width=banner.offsetWidth;
				if(width==null || width==0)
					width=banner.clientWidth?banner.clientWidth:width;
				window.S_Width=width;
				var icons=	navDiv.getElementsByTagName("div");
				if(icons.length*iconWidth > width){
					var limit=parseInt(width/iconWidth);
					window.S_Limit=limit;
					window.S_ShowRightIndex=limit-1;
					for(var i=0;i<limit;i++){
						icons[i].style.display="block";
					}
					var rightDiv=document.getElementById("div_expandRight");
					rightDiv.style.display = "block";
					Com_AddEventListener(divNavInfo,"touchstart",touchstart);
					Com_AddEventListener(divNavInfo,"touchmove",touchmove);
					//Com_AddEventListener(divNavInfo,"touchend",touchend);
				}else{
					for(var i = 0;i < icons.length; i++){
						icons[i].style.display="block";
					}
				}
			}
		}
		/*****滑动效果仅适用于safari/chrome浏览器******/
		/*滑动开始*/	
		function touchstart(e){
			window.S_IsClicked=true;
			window.S_CurrentX = e.changedTouches[0].clientX;
		}
		
		/*滑动结束*/
		function touchmove(e){
			if(window.S_IsClicked==true){
				if(window.S_CurrentX!=-1){
					var pointX=e.changedTouches[0].clientX;
					if(pointX>window.S_CurrentX)
						turnToLeft();
					else if(pointX < window.S_CurrentX)
						turnToRight();
				}
			}
			window.S_CurrentX=-1;
			window.S_IsClicked=false;
		}
		
		function gotoNavUrl(url){
			if(window.S_IsMoved!=true || window.S_IsClicked!=true)
				gotoUrl(url);
		}
		
		function turnToRight(){
			var navDiv = document.getElementById("div_navIcons");
			var rightDiv=document.getElementById("div_expandRight");
			var leftDiv=document.getElementById("div_expandLeft");
			if(navDiv!=null){
				var icons = navDiv.getElementsByTagName("div");
				if(window.S_ShowRightIndex<icons.length-1){
					for(var i=0;i<icons.length;i++){
						if(i<=window.S_ShowRightIndex){
							icons[i].style.display="none";
						}else if(i<=window.S_ShowRightIndex+window.S_Limit){
							icons[i].style.display="block";
						}else{
							icons[i].style.display="none";
						}
					}
					if(window.S_ShowRightIndex+window.S_Limit+1>icons.length)
						window.S_ShowRightIndex=i-1;
					else
						window.S_ShowRightIndex=window.S_ShowRightIndex + window.S_Limit;
					leftDiv.style.display="block";
					if(window.S_ShowRightIndex>=icons.length-1) rightDiv.style.display="none";
				}
			}
		}
		
		function turnToLeft(){
			var navDiv = document.getElementById("div_navIcons");
			var rightDiv=document.getElementById("div_expandRight");
			var leftDiv=document.getElementById("div_expandLeft");
			if(navDiv!=null){
				var icons = navDiv.getElementsByTagName("div");
				if(window.S_ShowRightIndex-window.S_Limit+1>0){
					var devInt=(window.S_ShowRightIndex+1) % window.S_Limit;
					var deveVar=parseInt((window.S_ShowRightIndex+1) / window.S_Limit);
					var endIndex= window.S_Limit-1;
					if(devInt==0)
						endIndex = window.S_ShowRightIndex-window.S_Limit;
					else
						endIndex = window.S_ShowRightIndex-devInt;
					var startIndex=endIndex-window.S_Limit+1;
					startIndex= startIndex<0?0:startIndex;
					for(var i=0;i<icons.length;i++){
						if(i>=startIndex && i<=endIndex)
							icons[i].style.display="block";
						else
							icons[i].style.display="none";
					}
					window.S_ShowRightIndex=endIndex;
					rightDiv.style.display="block";
					if(window.S_ShowRightIndex-window.S_Limit<0) leftDiv.style.display="none";
				}
			}
		}
		Com_AddEventListener(window,"load",loadingNav);
	</script>
	<!-- 
	<div id="div_unselect" class="div_nav" onclick="expandNav(1);">&nbsp;</div>
	<div id="div_select" class="div_nav_select" onclick="expandNav(1);">&nbsp;</div>
	-->
</c:if> 

<%-- 注销部分  --%>
<c:if test="${param.fdNeedLoginout==true}">
	<div class="div_logout" onclick="opt_logout(true);">&nbsp;</div>
</c:if>
</div>