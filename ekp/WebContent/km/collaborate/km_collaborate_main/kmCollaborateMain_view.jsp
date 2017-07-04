<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%@ taglib uri="/WEB-INF/kmss-xform.tld" prefix="xform"%>
<%@ include file="/resource/jsp/view_top.jsp"%>
<%@ page import="com.sunbor.web.tag.Page"%>
<%@page import="com.landray.kmss.km.collaborate.model.KmCollaborateConfig"%>
<style>
<!--
 .notNull{display:none;padding-left:10px;border:solid #DFA387 1px;padding-top:8px;padding-bottom:8px;background:#FFF6D9;color:#C30409;margin-top:3px;}
-->
</style>
<script type="text/javascript">
   Com_IncludeFile("jquery.js|dialog.js");
 
</script>
<script type="text/javascript" src="../js/collaborate4main.js"></script>
<script>
	function confirmDelete(msg){
		var del = confirm("<bean:message key='kmCollaborate.jsp.jsgt' bundle="km-collaborate"/>");
		return del;
    }	
	$(document).ready(function(){
		$(window).scroll(function(){							
			$("#fixed_zm").css("top",(150+$(this).scrollTop())+"px");
			$("#tc").css("top",(280+$(this).scrollTop())+"px");
			$("#zone-bar-main").hide();
		});
		$("#fixed_zm").find(".left").click(function(){
			if($(this).parent().find('.right').is(":hidden")){
				$(this).parent().find('.right').animate({width: "130px"},"slow",function(){
					$(this).show();
					$("#fixed_zm > .left img").attr("src","../img/go_right.png");
				});
			}else{
				$(this).parent().find('.right').animate({width: "0px"},"slow",function(){
					$(this).hide();				
					$("#fixed_zm > .left img").attr("src","../img/go_left.png");
				});
			}
		});
		$("#signTo").click(function(){
			$("#zone-bar-main").css("top",($(this).offset().top-$("#zone-bar-main").height()/2+$(this).height()/2)+"px");
			$("#zone-bar-main").css("left",($(this).offset().left-112)+"px");
			$("#zone-bar-main").toggle();			
		}).blur(function(){
			setTimeout(function(){$("#zone-bar-main").hide();},500);
		});
		$("#zone-bar-main > ul a").click(function(){
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
			$.get("<c:url value='/km/collaborate/km_collaborate_partner_info/kmCollaboratePartnerInfo.do'/>?method=isRead&"+"flag="+$(this).attr("name")+"&docid=${kmCollaborateMainForm.fdId}",function(json){
				if(json['value']==true){
					   alert(message);
			       }else{
					  alert(message_false);
			       }
			},"json");
		});
	    var url="../km_collaborate_main_reply/kmCollaborateMainReply.do?method=replyList&mainId=${param.fdId}&pageno=1&rowsize=4&orderby=";
		$("#xgjl").click(function(){
			window['$Click']="xgjl";
			$("#cyqk").attr("class","");
			$("#xgjl").attr("class","tabs_on");
		
			$("#win").attr("src","<c:url value="/km/collaborate/km_collaborate_main_reply/kmCollaborateMainReply.do" />?method=replyList&mainId=${param.fdId}&pageno=1&rowsize=10");
		});
		$("#cyqk").click(function(){
			window['$Click']="cyqk";
			$("#xgjl").attr("class","");
			$("#cyqk").attr("class","tabs_on");
			$("#win").attr("src","<c:url value="/km/collaborate/km_collaborate_partner_info/kmCollaboratePartnerInfo.do" />?method=condition&fdId=${kmCollaborateMainForm.fdId}");
			
		});
		$("input[type='checkbox']").focus(function(){
			
			$("#fdNotifyType").hide();
			
		}); 
		/* 处理图片代码
		*/
		$("#kmCollaContent").find("img").each(function (){
			var width= $(this).width();
			var height=$(this).height();
			if(height>100) { $(this).height(100);}
			if(width>100) {$(this).width(Math.round(width*100/height));}
		}).click(function(){
			$(this).hide();
			$(this).width("");
			$(this).height("");
			var width= $(this).width();
			var height=$(this).height();
			if(height>600) 
			   {
				  $(this).height(600);
			      $(this).width(Math.round(width*600/height));
			   }
			$(this).show();
			SetWinHeight(window.parent.document.getElementById("win"));
		}).dblclick( function(){
			$(this).hide();
			var width= $(this).width();
			var height=$(this).height();
			if(height>100) 
			   {
				  $(this).height(100);
			      $(this).width(Math.round(width*100/height));
			   }
			$(this).show();
			
		});
		/*  处理表格*/
		
		$("#kcContent_p").find("table").each(function(){
			var width=$(this).width();
			var height=$(this).height();
			if(width>900){
			   $(this).width(900);			  
			   $(this).height(Math.round(height*900/width));
			   }		
		});
		
		
		$("#goTOP").mouseover(function(){
			$(this).css("background-color","#86B1FF");
		}).mouseout(function (){
			$(this).css("background-color","");
	    });
		$("#closeWin").mouseover(function(){
			$(this).css("background-color","#86B1FF");
		}).mouseout(function (){
			$(this).css("background-color","");
	    });
		window['$FIRST_LOAD']=false;
		window['$Click']="";
		$("#win").load(function(){
		
			if(!$FIRST_LOAD){
		 	  window.scroll(0, 0);
		 	  window['$FIRST_LOAD']=true;
			}else{
				window.scroll(0, $("#win").offset().top-40);
			}
			
			if($Click=='cyqk'){
				$("#fixed_zm").css("top",($(document).height()/2-50)+"px");
			}
		
		});
	});
	
	function SetWinHeight(obj) {
		var win=obj;
		if (document.getElementById){
			if (win && !window.opera) { 
				if (win.contentDocument && win.contentDocument.body.offsetHeight)    
					win.height = win.contentDocument.body.offsetHeight;     
				else if(win.Document && win.Document.body.scrollHeight)   
					win.height = win.Document.body.scrollHeight;
			}
		}
	}
	// 编辑内容与附件
	function edit(){
		Com_OpenWindow('kmCollaborateMain.do?method=editContent&fdId=${param.fdId}','_self');
	}
	function formSubmit() {
		var v=FCKeditorAPI.GetInstance("fdContent").GetXHTML();
	//	v=v.replace(/<\/?.+?>/g,"");
		if(v==null ||v=="") {
			alert('<bean:message  bundle="km-collaborate" key="kmCollaborate.fdContent.notNull"/>');
			return;
		}
		
		if($("input[name='fdNotifyType']").val()=="" || $("input[name='fdNotifyType']").val()==null)
		{
			 $("#fdNotifyType").show();
			 return;
		}
		for(var i=0; i<Com_Parameter.event["confirm"].length; i++){
			if(!Com_Parameter.event["confirm"][i]()){
				return false;
			}
		}
		document.kmCollaborateMainReplyForm.submit();
		 //5秒后才能再次使用
		var submitVar=document.getElementById("btn_submit_com");
		submitVar.disabled=true;
		setTimeout("document.getElementById('btn_submit_com').disabled=false;", 5000);	
	}
	function reSetAbsolutePosition(){
		
		$("#fixed_zm").css("top",(150+$(this).scrollTop())+"px");
		
	}

</script>
<style>
a { text-decoration: none; outline: none;color: #335588;}
a:hover {text-decoration: none;}
.readReply {background: #f0f0f0;padding: 3px 3px 3px 3px;}
div#nifty {margin: 0 0%;background: #f0f0f0}
b.rtop,b.rbottom {display: block;background: #FFF}
b.rtop b,b.rbottom b {display: block;height: 1px;overflow: hidden;background: #f0f0f0}
b.r1 {margin: 0 5px}
b.r2 {margin: 0 3px}
b.r3 {margin: 0 2px}
b.rtop b.r4,b.rbottom b.r4 {margin: 0 1px;height: 2px}
.fixed_zm{position:absolute; right:10px; top:150px; text-align:center; border:solid 0px #CCCCCC; font-family:Arial,sans-serif;width:180px}
.fixed_zm input{cursor:pointer;}
.fixed_zm .left{cursor:pointer;width:25px;height:80px; margin:80px 0 0 0 ;padding:10px 0 5px 0; float:right; text-align:center; background:#666666; color:#FFFFFF; }
.fixed_zm .right{width:120px;height:auto; float:right; background: #F6F6F6; border:1px #CCCCCC solid; }
.fixed_zm .bottom{ height:20px; width:100px; padding:5px 0 0 0; border-top:1px #999999  solid; margin: 1px 0 0 0 ;}
.fixed_zm .bottom .go_top{ background:url(../img/top_2.png) 0 0 no-repeat; cursor:pointer;}
.fixed_zm .bottom .close{ background:url(../img/Close_2.png) 0 0 no-repeat; cursor:pointer;}
.fixed_zm .left span{ display:block; height:20px; width:25px; margin-top:5px;; }
.fixed_zm #tag{ width:120px; height:210px;  }
.fixed_zm #tag .input {font-weight:bold;color:#006FCC;display:block;width:100px;background:url(../img/button_t.png) 0 0 no-repeat;margin:10px  auto  auto auto ; padding:0px 0 0 0 ;border:0px;height: 30px;line-height: 30px;}
.fixed_zm #tag input {font-weight:bold;color:#ccc;display:block;width:100px;background:url(../img/button_n.png) 0 0 no-repeat;margin:10px  auto  auto auto ; padding:0px 0 0 0 ;border:0px;height: 30px;line-height: 30px;}


#zone-bar-main{display:none;position:absolute;width:116px;}
#zone-bar-main img{position: absolute;left:98px;top:50%;margin-top:-8px;}
#zone-bar {width:100px;border: 1px solid #CCCCCC;background: white;text-align:center;float: left;padding:0;margin:0;}
#zone-bar li {float: none;height: 100%; list-style-type:none}
#zone-bar li:hover {background: none;}
#zone-bar li a {display: block;float: none;padding: 10px 0 10px 0;width: 100px;}
#zone-bar li a:hover {background: #d9f0b7;}
.none{display: none;}
.xgjl_cyqk{
text-align:center; font-size:14px; color:white;border:0px solid #ccc;display:block;float:left; height:31px; background:#33A1C9;margin: 0px 10px 0px 0px;
font-weight:bold; cursor:pointer;
}
.xgjl_cyqk_w{
text-align:center; font-size:14px; color:#000;border:0px solid #ccc;display:block;float:left; height:31px; margin: 0px 10px 0px 0px;
font-weight:bold;cursor:pointer;
}
 .tabs{ height:30px; line-height:30px; border-bottom:1px solid #cdcdcd;padding:0px 0px 0px 15px;}
 .tabs li{ float:left; list-style:none; height:29px; line-height:29px; margin-right:3px; background-color:#e5edf2; font-size:12px; color:#333; padding:0px 5px; border:1px solid #cdcdcd}
 .tabs .tabs_on{ border:1px solid #cdcdcd; border-bottom:1px solid #fff; background-color:#fff; font-weight:bold}


</style>
		<% 
		   KmCollaborateConfig kmCollaborateConfig=new KmCollaborateConfig();
		   String fdcontent=kmCollaborateConfig.getDefaultReply();
		   request.setAttribute("fdcontent",fdcontent);	
		   request.setAttribute("fdIsEdit",kmCollaborateConfig.getFdIsEdit());
		   request.setAttribute("userId",UserUtil.getUser().getFdId());
		   request.setAttribute("replyNotifyType", kmCollaborateConfig.getDefaultNotifyType());
		%>
<div class="fixed_zm" id="fixed_zm"  >
	<div class="right">
		<div id="tag" > 
			<input type="button" 
			
				<kmss:auth requestURL="/km/collaborate/km_collaborate_main/kmCollaborateMain.do?method=partners&fdId=${param.fdId }">
				   <c:if test="${kmCollaborateMainForm.docStatus eq '30' }">	class="input" onclick="focuOnTarget('xEditingArea',false)" </c:if>
				</kmss:auth>
			value="<bean:message key='kmCollaborate.jsp.reply' bundle='km-collaborate' />">
			<input type="button"
				<kmss:auth requestURL="/km/collaborate/km_collaborate_main/kmCollaborateMain.do?method=partners&fdId=${param.fdId }">
				  <c:if test="${kmCollaborateMainForm.docStatus eq '30' }">	class="input" onclick="focuOnTarget('xEditingArea',true)" </c:if>
				 </kmss:auth>
			value="<bean:message key='kmCollaborate.jsp.replyAll' bundle='km-collaborate' />">
			<input type="button" 
				<kmss:auth requestURL="/km/collaborate/km_collaborate_main/kmCollaborateMain.do?method=add&showForward=true&showid=${param.fdId }">
				 	class="input" onclick="Com_OpenWindow('kmCollaborateMain.do?method=add&showForward=true&showid=${param.fdId}','_self');" 
				</kmss:auth>
			    value="<bean:message key='kmCollaborate.jsp.forward' bundle='km-collaborate' />">			 
			<input type="button"
				<kmss:auth requestURL="/km/collaborate/km_collaborate_main/kmCollaborateMain.do?method=mark&fdId=${param.fdId }">
					<c:if test="${ !isAdminOnly}" >
					   class="input" id="signTo" 
					  </c:if>
				
				</kmss:auth>
			value="<bean:message key='kmCollaborate.jsp.signTo' bundle='km-collaborate' />...">
			<input type="button"
				<kmss:auth requestURL="/km/collaborate/km_collaborate_main/kmCollaborateMain.do?method=conclude&fdId=${param.fdId }">
				 	 
				 	<c:if test="${kmCollaborateMainForm.docStatus eq '30' }">
				 	   class="input" onclick="if(!confirmDelete()) return;Com_OpenWindow('kmCollaborateMain.do?method=conclude&fdId=${param.fdId}','_self');"
				    </c:if>
				</kmss:auth>
			value="<bean:message key='kmCollaborate.jsp.endMain' bundle='km-collaborate' />">
		</div>
		<div class="bottom" id="goTOP">
			<div  class="go_top" onclick="goTop()"  ><bean:message key='kmCollaborate.jsp.goTop' bundle='km-collaborate' /></div>
		</div>
		<div id="closeWin" class="bottom" >
			<div  class="close" onclick="closeWindow()"  ><bean:message key='kmCollaborate.jsp.closeWin' bundle='km-collaborate' /></div>
		</div>
	</div>
	    <div class="left">
		<span><bean:message key="kmCollaborate.jsp.xuan" bundle="km-collaborate"/></span>
		<span><bean:message key="kmCollaborate.jsp.xiang" bundle="km-collaborate"/></span>
		<span><img src="../img/go_right.png"/></span>	  
	</div>
</div>
<div id="zone-bar-main">
<ul id="zone-bar">
    <c:if test="${kmCollaborateMainForm.docCreatorId ne current_user_id}">
		<li><a ref="sign" href="#" name="readed" id="readed"><bean:message key='kmCollaborate.jsp.yudu' bundle='km-collaborate' /></a></li>
		<li><a ref="sign" href="#" name="notRead" id="notRead"><bean:message key='kmCollaborate.jsp.weidu' bundle='km-collaborate' /></a></li>
	</c:if>
	<li><a ref="sign" href="#" name="attention" id="attention"><bean:message key='kmCollaborate.jsp.attention' bundle='km-collaborate' /></a></li>
	<li><a ref="sign" href="#" name="cancleAttention" id="cancleAttention"><bean:message key='kmCollaborate.jsp.calcelAtt' bundle='km-collaborate' /></a></li>
</ul>
<img src="../img/from_right.png"/>
</div>
<center>

	<div   
		style=" overflow-x:hidden;overflow-y:hidden;  padding:0;width:90%; margin: 0px 150px 0px 0px;">
	
		<div id="fdCategory" style="float:left; margin-left:60px" >
			<bean:message bundle="km-collaborate"
					key="kmCollaborateMain.fdCategory" />：${kmCollaborateMainForm.fdCategoryName}
		</div>
		<br>
		<br>
		<div id="docSubject" style="margin:0px 50px 0px 60px" >
			<p class="txttitle">
				<c:if test="${kmCollaborateMainForm.docStatus==40 }">
					<img src="../img/end.gif" style="vertical-align: middle;">
				</c:if>
				<c:if test="${kmCollaborateMainForm.fdIsPriority eq 'true'}">
					<img src="../img/gt_zy.png" style="vertical-align: middle;">
				</c:if>
				${kmCollaborateMainForm.docSubject}<br> <font size="2"
					class="readReply"><bean:message key='kmCollaborate.jsp.yuedu' bundle='km-collaborate' />：<font color="red">${kmCollaborateMainForm.docReadCount+1 }</font></font>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<font
					size="2" class="readReply"><bean:message key='kmCollaborate.jsp.reply' bundle='km-collaborate' />：<font color="red">${kmCollaborateMainForm.docReplyCount }</font></font>
			</p>
		</div>
		<div id="nifty" style="margin-top:10px;min-height:300px;width: 90%;">
			<b class="rtop"><b class="r1"></b><b class="r2"></b><b class="r3"></b><b
				class="r4"></b></b>
			<!-- 下面是内容区域 -->
			<div id="communication" style="padding: 10px 5px 5px 20px; text-align: left;margin-top:2px;width:90%">
			<div>
				 <bean:message bundle="km-collaborate"
						key="kmCollaborateMain.docCreator" />：${kmCollaborateMainForm.docCreatorName}
					&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <bean:message
						bundle="km-collaborate" key="kmCollaborateMain.docCreateTime" />：${kmCollaborateMainForm.docCreateTime}
				</div>
				<div style="width:auto; cursor:pointer; margin-top:-28px;float:right; border:0px solid #ccc"  
				      onclick="edit();"  >
						  <c:if test="${kmCollaborateMainForm.docStatus eq '30' }">
						  <!-- 参数设置中，false为允许编辑，true为不允许编辑 -->
						  <c:if test="${fdIsEdit=='0'}">
						  <kmss:auth requestURL="/km/collaborate/km_collaborate_main/kmCollaborateMain.do?method=editContent&fdId=${param.fdId}" requestMethod="GET">					  
						   <img alt='<bean:message bundle="km-collaborate" key="kmCollaborate.jsp.bianji" />'  style="float:left;align:right" src="../img/edit_background.png" style="vertical-align: middle; "  />
					        <span style="margin:6px auto auto -35px;width:30px;height 20px;display:block; float:left; border:0px solid #ccc" ><bean:message bundle="km-collaborate" key="kmCollaborate.jsp.bianji" /></span>
					      </kmss:auth>
					       </c:if>
					       </c:if>
				</div>
			<hr style="border: 1px dashed #000000; height: 1px">
			<c:if test="${not empty  kmCollaborateMainForm.docAlterorName}">
				<center>
				<div
					style="height: 25px; line-height: 25px; background: #ffffcc; width: 45%;"><bean:message key='kmCollaborate.jsp.mainView.str' bundle='km-collaborate' />&nbsp;${kmCollaborateMainForm.docAlterorName}&nbsp;
					<bean:message key='kmCollaborate.jsp.yu' bundle='km-collaborate' />&nbsp;${kmCollaborateMainForm.docAlterTime}
					&nbsp;<bean:message key='kmCollaborate.jsp.bianji' bundle='km-collaborate' /></div>
				</center>
			</c:if>
			<div id="kmCollaContent" style="padding: 5px 5px 5px 0px; text-align: left;" >
				<p id="kcContent_p" style="overflow:hidden;">${kmCollaborateMainForm.fdContent}</p><br>
				<c:import url="/sys/attachment/sys_att_main/sysAttMain_view.jsp"
					charEncoding="UTF-8">
					<c:param name="fdKey" value="attachment" />
					<c:param name="fdModelId" value="${param.fdId}" />
					<c:param name="formBeanName" value="kmCollaborateMainForm" />
				</c:import><br>
				<!-- 附件权限设置开始 -->
				
				  <c:if test="${kmCollaborateMainForm.fdEditAtt=='false'&&userId != kmCollaborateMainForm.docCreatorId}">
				   <script>
				      attachmentObject_attachment_${param.fdId}.canEdit=false;
				   </script>
				  </c:if>
				  <c:if test="${fdIsEdit=='1'&& userId == kmCollaborateMainForm.docCreatorId}">
				  <script>
				      attachmentObject_attachment_${param.fdId}.canEdit=false;
				   </script>
				  </c:if>
				  <!-- 附件权限设置结束-->
				<c:if test="${not empty kmCollaborateMainForm.fdSourceUrl}">
				<bean:message bundle="km-collaborate" key="kmCollaborateMain.fdSource"/>:
					<a href="<c:url value="${kmCollaborateMainForm.fdSourceUrl}"/>" target="_blank">${kmCollaborateMainForm.fdSourceSubject}</a>
				</c:if>
			</div>
			
			<!-- 上面是内容区域 -->
			<b class="rbottom"><b class="r4"></b><b class="r3"></b><b
				class="r2"></b><b class="r1"></b></b>
		</div>
		 <b class="rtop">
		     <b class="r4"></b>
		     <b class="r3"></b>
		     <b class="r2"></b>
		     <b class="r1"></b>
		 </b>
      </div>		
	
	<!-- 回复区域开始 -->
	<kmss:authShow roles="ROLE_KMCOLLABORATEMAIN_EDIT|ROLE_KMCOLLABORATEMAIN_END">
	<div id="showSaveReply" style="display:none ;border:0px solid #CCC;"></div>
	</kmss:authShow>
	<kmss:auth requestURL="/km/collaborate/km_collaborate_main/kmCollaborateMain.do?method=saveReply&fdId=${kmCollaborateMainForm.fdId}">
	<kmss:auth requestURL="/km/collaborate/km_collaborate_main/kmCollaborateMain.do?method=partners&fdId=${kmCollaborateMainForm.fdId}">
	<script>
		$("#showSaveReply").show();
	</script>
	</kmss:auth>
	<c:if test="${kmCollaborateMainForm.docStatus eq '30' }">
	<div style="width:90%">
	<html:form  
		action="/km/collaborate/km_collaborate_main_reply/kmCollaborateMainReply.do?method=saveReply">
		<input type="hidden" name="fdCommunicationMainId"  value="${param.fdId }" />
		<input type="hidden" id="fdParentId"  name="fdParentId"  value="" />
		<input type="hidden" id="fdId"  name="fdId"  value="" />
		<table class="tb_normal" width=100% style="margin: 10px 0 0 0;" >
			<tr>
				<td class="td_normal_title" width="150px"><bean:message bundle="km-collaborate" key="kmCollaborateMainReply.fdReplyType" /></td>
				<td>
					<input type="radio" name="fdReplyType" value="1" checked><bean:message key='kmCollaborate.jsp.creator' bundle='km-collaborate' />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					<input type="radio" name="fdReplyType" value="2"><bean:message key='kmCollaborate.jsp.allPerson' bundle='km-collaborate' />
				</td>
			</tr>
			<tr>
				<td class="td_normal_title" width="150px"><bean:message bundle="km-collaborate" key="kmCollaborateMainReply.fdContent" /></td>
				<td>
					<script>
						function RTF_SetContent(prop,content){
							var cframeName = prop + "___Frame";
							var cframe = document.getElementsByName(cframeName)[0];
							var cdocument = cframe.contentWindow.document;
							document.getElementsByName(prop)[0].value=content;
							cframe.contentWindow.document.frames[0].document.body.innerHTML=content;
						}
					</script>
					<div>
						<input type="hidden" id="fdContent" name="fdContent" value="${fdcontent}">
						<input type="hidden" id="fdContent___Config" value="ToolbarStartExpanded=false">
						<iframe id="fdContent___Frame"
							src="${KMSS_Parameter_ContextPath}resource/fckeditor/editor/fckeditor.html?InstanceName=fdContent&Toolbar=Default"
							width="100%" height="180" frameborder="no" scrolling="no"></iframe>
					</div> 
					<script>Com_IncludeFile('fckfilter.js', 'fckeditor/');</script> 
					<script>FCKFilter.addReplaceFilter('fdContent');</script>
				</td>
			</tr>
			<tr>
				<td class="td_normal_title" width="150px"><bean:message key='kmCollaborate.jsp.attachment' bundle='km-collaborate' /></td>
				<td>
				    <c:import
						url="/sys/attachment/sys_att_main/sysAttMain_edit.jsp"
						charEncoding="UTF-8">
						<c:param name="fdKey" value="replyAttachment" />
						<c:param name="fdModelName" value="com.landray.kmss.km.collaborate.model.KmCollaborateMainReply" />
					</c:import>
			   </td>
			</tr>
			<tr>
				<td class="td_normal_title" width="150px"><bean:message bundle="km-collaborate" key="kmCollaborateMain.fdNotifyType" /></td>
				<td><kmss:editNotifyType property="fdNotifyType" value="${replyNotifyType}"/>
				    <div class="notNull" id="fdNotifyType">×&nbsp;&nbsp;&nbsp;<bean:message bundle="km-collaborate" key="kmCollaborateMain.choose.notifytype"/></div>
				</td>
			</tr>
		</table>
		<div style=" cursor:pointer;float:right;margin:10px 10px 0 0">
		           <input type="button" id="btn_submit_com" style="background:url(../img/submit2.png); display:block; width:54px ;height:34px;font-weight: bold;border:1px solid #CCC;" onclick="formSubmit();" value="<bean:message key="button.submit" />"> 
		</div>
	</html:form>
	</div>
	</c:if>
<%-- 	<kmss:authShow roles="ROLE_KMCOLLABORATEMAIN_EDIT|ROLE_KMCOLLABORATEMAIN_END">
	
	</kmss:authShow> --%>
	</kmss:auth>
		<!-- 回复区域结束 --> 
		<br><br><br>	
	<div style="width:90%">				
    <ul class="tabs">
        <li id="xgjl" class="tabs_on" style="cursor:pointer"><bean:message bundle="km-collaborate" key ="kmCollaborate.jsp.xgjl" /></li>
        <li id="cyqk" class="" style="cursor:pointer"><bean:message bundle="km-collaborate" key ="kmCollaborate.jsp.cyqk" /></li>
    </ul>
    </div>
		<div id="common" style="width:90%">
			<iframe name="win" id="win"
					src="../km_collaborate_main_reply/kmCollaborateMainReply.do?method=replyList&mainId=${param.fdId}&pageno=1&rowsize=10&sortType=asc" 
					width="100%" height="100%" frameborder=0 scrolling=no >
			</iframe>
		</div>
		
	</div>	
	</center>


<%@ include file="/resource/jsp/view_down.jsp"%>