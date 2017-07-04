<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/third/pda/htmlhead.jsp"%>
<%@ include file="/km/collaborate/pda/js/index_js.jsp" %>
<meta name="apple-mobile-web-app-status-bar-style" content="black">
<kmss:auth requestURL="/km/collaborate/km_collaborate_main/kmCollaborateMain.do?method=add">
	<script type="text/javascript" >
		$(document).ready( function (){
			$("#div_otherBtn").css('display','block');
		});
	</script>
</kmss:auth>
<title><bean:message bundle="km-collaborate" key="module.km.collaborate"/></title>
</head>
<body>
 <c:if test="${KMSS_PDA_ISAPP !='1'}">
	<div class="div_banner">
		<div id="returnDiv" class="div_return" onclick="gotoUrl('<c:url value="/third/pda/index.jsp"/>');">
			<div>
				<bean:message key="phone.banner.homepage" bundle="third-pda"/>
			</div>
			<div></div>
		</div>
		<div id="div_otherBtn" class="div_otherBtn" style="display: none;"> </div>
	</div>
</c:if>
<div data-role="page" id="menu" data-fullscreen="true">
	<div id="page_content" data-role="content" style="margin: 0px;padding:0px;">
	<c:if test="${KMSS_PDA_ISAPP !='1'}">
		<br><br>
	</c:if>
		<ul id="page_listview" data-role="listview" data-inset="true" style="margin:6px 0 12px;">
   			<li id="listview_loader" data-icon="false">
	   			<a href="javascript:void(0);">
		   			<div style="text-align: center;padding:6px 0;">
			   			<img style="vertical-align:middle;width:32px;hight:32px" 
			   			     src="${KMSS_Parameter_ContextPath}km/collaborate/pda/js/images/ajax-loader.gif">正在加载....
		   			</div>
	   			</a>
   			</li>
		</ul>
		<br><br><br>
	</div>
    <c:if test="${KMSS_PDA_ISAPP !='1'}">
		<div data-role="footer" data-position="fixed" data-tap-toggle="false">
			<div id="header_navbar" data-role="navbar"  >
	           	<ul>
	               	<li><a href="javascript:void(0);" data-icon="grid" type="all" data-transition="fade" data-theme="a"><bean:message bundle="km-collaborate" key="kmCollaborate.pda.all"/></a></li>
	               	<li><a href="javascript:void(0);" data-icon="bars" type="myReader" data-transition="fade"><bean:message bundle="km-collaborate" key="kmCollaborateMain.myParticipate"/></a></li>
	                <li><a href="javascript:void(0);" data-icon="edit" type="myCreate" data-transition="fade"><bean:message bundle="km-collaborate" key="kmCollaborateMain.myLaunch"/></a></li>
	               	<li><a href="javascript:void(0);" data-icon="star" type="myFollow" data-transition="fade"><bean:message bundle="km-collaborate" key="kmCollaborateMain.myAttention"/></a></li>
	           	</ul>
	       	</div>
	     </div>
    </c:if>
    <c:if test="${KMSS_PDA_ISAPP =='1'}"> 
		 <div data-role="footer" data-position="fixed" data-theme="a" data-tap-toggle="false" id="narbarId"> 
    		<div data-role="navbar" > 
    			<ul>
    				 <li>
    					<a href="#header_navbar" onclick="clickOneTime()" id="menuId" data-rel="popup" data-theme="a" data-transition="slideup" data-icon="grid">
    			        <div id="menuTipId" style="font-weight:bold;"><bean:message bundle="km-collaborate" key="kmCollaborateMain.pda.menu"/></div>
    				    <input type="hidden" name="counter" id="counter" value="0" >
    				    </a>
    			     </li> 
			    	 <li>
			    		<a href="#" id="add" data-icon="plus" data-theme="a" class="ui-disabled" onclick="window.open('<c:url value="/km/collaborate/km_collaborate_main/kmCollaborateMain.do" />?method=add&flag=pda','_self');">
			    			<bean:message bundle="km-collaborate" key="kmCollaborate.pda.add"/>
			    		</a>
			    		<kmss:auth requestURL="/km/collaborate/km_collaborate_main/kmCollaborateMain.do?method=add" >
			    		<script>
			    		$("#add").attr("class","");
			    		</script>
			    		</kmss:auth>
			    	</li> 
    			</ul>
    		</div><!-- /navbar --> 
    		 <div data-role="popup" id="header_navbar" data-theme="b" data-shadow="false" data-tolerance="0,0" class="header_popup_navbar" style="margin-top:-1.5cm">
            	<ul data-role="listview" data-inset="true">
            	    <li data-role="divider" data-theme="b"><bean:message bundle="km-collaborate" key="kmCollaborateMain.pda.menu"/></li>
                	<li><a href="javascript:void(0);" type="all" data-transition="fade" ><bean:message bundle="km-collaborate" key="kmCollaborate.pda.all"/></a></li>
                	<li><a href="javascript:void(0);" type="myCreate" data-transition="fade"><bean:message bundle="km-collaborate" key="kmCollaborateMain.myLaunch"/></a></li>
                	<li><a href="javascript:void(0);" type="myReader" data-transition="fade"><bean:message bundle="km-collaborate" key="kmCollaborateMain.myParticipate"/></a></li>
                	<li><a href="javascript:void(0);" type="myFollow" data-transition="fade"><bean:message bundle="km-collaborate" key="kmCollaborateMain.myAttention"/></a></li>
            	</ul>
            </div>   
        </div><!-- /footer -->   
      </c:if>  
      <!--弹出的警告框  -->
     <div data-role="popup" id="popupAlert" >     
  	 		  <p id="alertId" style="background-color:#FFFF; font-size: 15px;font-weight:bold;"></p>
  	 </div>
      
     <div id="page_controlgroup" style="display: none;width:100%;text-align: center;">
			<div data-role="controlgroup"  data-type="horizontal">
	  			<a id = "loadButton"> </a>
			</div>
	 </div>
</div>
<script type="text/javascript"> 
		var aaflag=0;
		//保证第二次点击菜单让菜单消失
 		function clickOneTime(){
 			if(aaflag==0){
 				aaflag=1;
 			}else if(aaflag==1){
 				$("#header_navbar").popup("close");
 				aaflag=0;
 			}
   	    } 
</script> 
<script type="text/javascript">
$( document ).on( "pageinit", function() {
    $( ".header_popup_navbar" ).on({
        popupbeforeposition: function() {
            var maxWidth = $( window ).width()/2 + "px";
            $( ".header_popup_navbar" ).css( "width", maxWidth );           
            var maxMarginTop = $("#narbarId").height() + "px";
            $( "#header_navbar-popup" ).css( "margin-top", maxMarginTop );
        }
    });
}); 
</script>
</body>
</html>