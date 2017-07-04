<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/view_top.jsp"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<script type="text/javascript">
   Com_IncludeFile("jquery.js");
</script>
<script type="text/javascript" src="../js/collaborate4main.js"></script>
<style>
<!--
html { overflow-y: none; }
.iframe{wdith:100%}
.tc{}
.tc a{}
.tc a:link{}
.tc a:visited{}
.tc a:hover{ color:#f00;background:#E6E6E6}
a { text-decoration: none; outline: none;color: #335588;}
a:hover {text-decoration: none;}
#zone-bar-main{display:none;position:absolute;width:100px;text-align:center;top:30px;z-index:1000}
#zone-bar-main img{position:absolute;top:-12px;margin-left:-6px;}
#zone-bar {width:100px;border: 1px solid #CCCCCC;background: white;padding:0;margin:0;}
#zone-bar li {float: none;height: 100%; list-style-type:none }
#zone-bar li:hover {background: none;}
#zone-bar li a {display: block;float: none;padding: 10px 0 10px 0;width: 100px;}
#zone-bar li a:hover {background: #d9f0b7;}
.tb_search{
	border-collapse:collapse;
	border: 1px #C0C0C0 solid;
	background-color: #F3F3F3;
}
.td_search, .tb_search td{
	border-collapse:collapse;
	border: 0px;
	padding:1px;
}
.input_search{
	color: #0066FF;
	border: 1px solid #C0C0C0;
}
.btn_search{
	height:20px;
	background-color:#f3f3f3;
	border:1 solid #909090;
}
-->
</style>
<script>
Com_IncludeFile("dialog.js");
<c:choose>
   <c:when test="${ param.pageType eq 'myDoc'}">
       var $viewList_Target_Const=["all","atten"];
   </c:when>
   <c:when test="${ param.pageType eq 'myFollow'}">
       var $viewList_Target_Const=["all","wd"];
   </c:when>
   <c:otherwise>
        var $viewList_Target_Const=["all","wd","atten"];
   </c:otherwise>
</c:choose>
var $viewList_Target_zm="all";
/*
 *  覆写公司 的切换标签 代码 
 */
  function Doc_SetCurrentLabel(tableName, index, noEvent)
 {
 	var tbObj = document.getElementById(tableName);
 	var curLabel = tbObj.getAttribute("LKS_CurrentLabel");
 	var imagePath = Com_Parameter.StylePath+"doc/";
 	var imgId = tableName + "_Label_Img_";
 	var btnId = tableName + "_Label_Btn_";
 	document.getElementById(btnId+index).blur();
 	/* 添加的代码  ,用于标识当前所在标签页 */
 	   $viewList_Target_zm=$viewList_Target_Const[index-1];
 	  document.getElementById($viewList_Target_zm).contentWindow.document.location.reload();
 	/******/
 	if(curLabel==index)
 		return;
 	var switchFunc = tbObj.getAttribute("LKS_OnLabelSwitch");
 	if(!noEvent && switchFunc!=null){
 		var switchFuncArr = switchFunc.split(";");
 		for(var i=0; i<switchFuncArr.length; i++){
 			if(window[switchFuncArr[i]]!=null && window[switchFuncArr[i]](tableName, index)==false)
 				return;
 		}
 	}
 	var btnObj;
 	if(curLabel!=null){
 		document.getElementById(imgId+curLabel+"_1").src = imagePath + "graylabbg1.gif";
 		btnObj = document.getElementById(btnId+curLabel);
 		btnObj.style.backgroundImage = "url(" + imagePath + "graylabbg2.gif)";
 		btnObj.className = "btnlabel2";
 		document.getElementById(imgId+curLabel+"_2").src = imagePath + "graylabbg3.gif";
 	}
 	document.getElementById(imgId+index+"_1").src = imagePath + "curlabbg1.gif";
 	btnObj = document.getElementById(btnId+index);
 
 	btnObj.style.backgroundImage = "url(" + imagePath + "curlabbg2.gif)";
 	btnObj.className = "btnlabel1";
 	document.getElementById(imgId+index+"_2").src = imagePath + "curlabbg3.gif";
 	for(var i=1; i<tbObj.rows.length; i++){
 		tbObj.rows[i].style.display = i==index?"":"none";
 	}
 	tbObj.setAttribute("LKS_CurrentLabel", index);
 }  

 $(document).ready(function(){
	  	$("iframe").load(function(){		  
		 /*	$(this).height($(window).height()-100);	*/
		 	var win=this;
			if (document.getElementById){
				if (win && !window.opera) { 
					if (win.contentDocument && win.contentDocument.body.offsetHeight)    
						win.height = win.contentDocument.body.offsetHeight;     
					else if(win.Document && win.Document.body.scrollHeight)   
						win.height = win.Document.body.scrollHeight;
				}
			}
		 	
		 	
		 	
	  	});
	  	$("#signTo").click(function(){
			$("#zone-bar-main").css("left",$(".innerTdBtn2").eq(0).offset().left-20+"px");
			$("#zone-bar-main").css("top",$(".innerTdBtn2").eq(0).offset().top+30+"px");
			$("#zone-bar-main").toggle();
		}).blur(function(){
			$("#zone-bar-main").hide();
	  	});
	  	$(window).scroll(function(){
	  	         $("#zone-bar-main").hide();	
	  	 });
	  	$("#zone-bar-main > ul a").click(function(){
	  		$("#zone-bar-main").hide();
	  		var docIds = $("#"+$viewList_Target_zm).contents().find(":checked[name='List_Selected']");
	  		if(docIds.length==0){
	  			alert("<bean:message key='kmCollaborate.jsp.confirm.select' bundle='km-collaborate'/>");
	  			return;
	  		}else if(docIds.length==1){
	  			docIds=docIds.val();
	  		}else{
	  			var t="";
	  			docIds.each(function(){
	  				t+=$(this).val()+";";
	  			});
	  			docIds=t;
	  		}
	  		var name=$(this).attr("name");
	  		var message="";
	  		var message_false="";
	  		if(name=="readed"){
	  			 message="<bean:message bundle='km-collaborate' key='kmCollaborate.jsp.readed.success' />";
	  			 message_false="<bean:message bundle='km-collaborate' key='kmCollaborate.jsp.readed.failure' />";
	  		}else if(name=="notRead"){
	  			 message="<bean:message bundle='km-collaborate' key='kmCollaborate.jsp.unRead.success' />";
	  			 message_false="<bean:message bundle='km-collaborate' key='kmCollaborate.jsp.unRead.failure' />";
	  			
	  		}else if(name=="attention"){
	  			 message="<bean:message bundle='km-collaborate' key='kmCollaborate.jsp.attention.success' />";
	  			 message_false="<bean:message bundle='km-collaborate' key='kmCollaborate.jsp.attention.failure' />";
	  		}else if(name=="cancleAttention"){
	  			 message="<bean:message bundle='km-collaborate' key='kmCollaborate.jsp.calcelAtt.success' />";
	  			 message_false="<bean:message bundle='km-collaborate' key='kmCollaborate.jsp.calcelAtt.failure' />";
	  			
	  		}
			$.get("<c:url value='/km/collaborate/km_collaborate_partner_info/kmCollaboratePartnerInfo.do'/>?method=isReadList&flag="+$(this).attr("name")+"&docIds="+docIds,function(json){
				 if(json['value']==true){					 					  
					   alert(message);
					   document.getElementById($viewList_Target_zm).contentWindow.document.location.reload();
			       }else{
			    	   alert(message_false);
					  
			       }
			},"json");			
		});
	  	$("#del_button").click(function(){  	  
		 document.getElementById($viewList_Target_zm).contentWindow.Km_DeleteAll();
				    		 
	  });	 	 
 });
</script>
	<c:import url="/resource/jsp/search_bar.jsp" charEncoding="UTF-8">
		<c:param name="fdModelName" value="com.landray.kmss.km.collaborate.model.KmCollaborateMain" />
	</c:import>
<div id="optBarDiv">
	<div><input id="signTo" type="button" value="<bean:message key='kmCollaborate.jsp.signTo' bundle='km-collaborate'/>...">	</div>
	<kmss:auth requestURL="/km/collaborate/km_collaborate_main/kmCollaborateMain.do?method=add">
		<input type="button" value="<bean:message key="button.add"/>"
			onclick="Com_OpenWindow('<c:url value="/km/collaborate/km_collaborate_main/kmCollaborateMain.do" />?method=add');">
	</kmss:auth>
	<!-- 删除权限 -->
	<kmss:authShow roles="ROLE_KMCOLLABORATEMAIN_DELETE">
		  <input id="del_button" type="button" value="<bean:message key="button.delete"/>"/>
	</kmss:authShow>
		<input  type="button" value="<bean:message key="button.search"/>" onclick="Search_Show();" />
</div>
<div id="zone-bar-main">
<img src="../img/from_top.png"/>
<ul id="zone-bar">
    <c:if  test="${param.pageType ne 'myDoc' }">
	<li><a ref="sign" href="#" name="readed"><bean:message key='kmCollaborate.jsp.yudu' bundle='km-collaborate'/></a></li>
	<li><a ref="sign" href="#" name="notRead"><bean:message key='kmCollaborate.jsp.weidu' bundle='km-collaborate'/></a></li>
	</c:if>
	<li><a ref="sign" href="#" name="attention"><bean:message key='kmCollaborate.jsp.attention' bundle='km-collaborate'/></a></li>
	<li><a ref="sign" href="#" name="cancleAttention"><bean:message key='kmCollaborate.jsp.calcelAtt' bundle='km-collaborate'/></a></li>
</ul>
</div>

<center>
<table style="display:none" id="Label_Tabel" width=100%>
	<tr name="sign_tr" LKS_LabelName="<bean:message key='kmCollaborate.jsp.all' bundle='km-collaborate'/>" ref="all">
		<td name="all" style="height:auto;" >
	         <iframe  id="all" frameborder=0 scrolling=no style="border:0;"  width="100%"  name="all" src="kmCollaboratePartnerInfo.do?method=list&pageType=${param.pageType}"></iframe>	         
		</td>
	</tr>
	<c:if test="${ param.pageType != 'myDoc'}" >
	<tr name="sign_tr" LKS_LabelName="<bean:message key='kmCollaborate.jsp.weidu' bundle='km-collaborate'/>" ref="wd">		
	    <td style="height:auto;" >
	         <iframe   id="wd" frameborder=0 scrolling=no style="border:0;"  width="100%" name="notRead" src="kmCollaboratePartnerInfo.do?method=list&pageType=${param.pageType}&sType=wd"></iframe>
		</td>
	</tr>
	</c:if>
	<c:if test="${ param.pageType ne 'myFollow'}" >
	<tr name="sign_tr" LKS_LabelName="<bean:message key='kmCollaborate.jsp.attention' bundle='km-collaborate'/>" ref="atten">		
	          <td style="height:auto;" >
	         <iframe  id="atten" frameborder=0 scrolling=no style="border:0;"  width="100%" name="atten" src="kmCollaboratePartnerInfo.do?method=list&pageType=${param.pageType}&sType=atten"></iframe>
		</td>
	</tr>
	</c:if>
	
</table>

</center>

<%@ include file="/resource/jsp/view_down.jsp"%>

