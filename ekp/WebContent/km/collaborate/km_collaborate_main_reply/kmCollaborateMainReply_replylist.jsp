<%@page import="com.sunbor.web.tag.Page"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="/WEB-INF/kmss-xform.tld" prefix="xform"%>
<%@ include file="/resource/jsp/view_top.jsp"%>
<%@page import="com.landray.kmss.km.collaborate.model.KmCollaborateConfig"%>
<style type="text/css">
<!--
body{ 
	background:white;
	font-size:12px;
}

div{border:0px solid #ccc;}
.replyContent {
	border-bottom: 1px #BEC3C9 solid;
	padding-top:10px;
}
.replyPic {
	width:500px;
}

.replyPic2 {
	text-align:left;
	margin-left:25px;
}

.replyWenzi {
	margin-top:-50px;
	margin-left:100px;
	margin-bottom:10px;
}
.replyHead {
 border:0px solid #ccc;
  height:30px;
	border-bottom:2px dotted #999999;
	
}
.replyHead2 {
    height:30px;
    width:300px;
    float:left;
    border:0px solid #ccc;
    margin-top:7px;
	text-align:left;
}

.replyEdit {
	cursor:pointer;
	width:60px;
	float:right;
	left:10px;
	align:right;
	background-repeat: no-repeat;
	height: 30px;
	background-image:url(../img/edit_background.png);
	
}

.replyReply {
    cursor:pointer;
	background-image:url(../img/reply_background.png);
	width:60px;
	align:right;
	float:right;
	margin-right:7px;
	background-repeat: no-repeat;
	height: 30px;
}
.picture {
	margin-left:0;
	margin-right:0;
	width:50px;
	height:50px;
}
.replyMain {
	padding-top:10px;
	padding-bottom:10px;
	text-align:left;
}
.changPage {
	width:20px;
	height:20px;
	border:#999999 1px solid;
	text-align:center;
	margin-top:0px;
	margin-bottom:0px;
	margin-left:auto;
	margin-right:auto;
}
.tdPage{
	text-align:center;
	width:20px;
	height:20px;
	border:#999999 1px solid;
}
.quote img{display:none}



.pages {
	float: right;
	margin: 3px;
}
.postPages {
	padding-top: 2px;
	padding-bottom: 2px;
	padding-left: 0px;
	padding-right: 0px;
	float: right;
}
.postPages a {
	border-top: 1px solid;
	border-bottom: 1px solid;
	border-left: 1px solid;
	border-right: 1px solid;
	padding-top: 0px;
	padding-bottom: 0px;
	padding-left: 6px;
	padding-right: 6px;
	float: left;
	overflow: hidden;
	line-height: 20px;
	margin-right: 2px;
	height: 20px;
}

.postPages a {
	border-top-color: #e6e7e1;
	border-bottom-color: #e6e7e1;
	border-left-color: #e6e7e1;
	border-right-color: #e6e7e1;
	color: #09c;
	background-color: #fff
}

.postPages a:hover {
	border-top-color: #09c;
	border-bottom-color: #09c;
	border-left-color: #09c;
	border-right-color: #09c;
	text-decoration: none;
}

.postPages b {
	padding-top: 0px;
	padding-bottom: 0px;
	padding-left: 6px;
	padding-right: 6px;
	float: left;
	overflow: hidden;
	line-height: 20px;
	margin-right: 2px;
	height: 20px;
}

.postPages b {
	border-top-color: #09c;
	border-bottom-color: #09c;
	border-left-color: #09c;
	border-right-color: #09c;
	font-weight: bold;
	color: #fff;
	background-color: #09c;
}

.postPages a b {
	float: left;
	margin-left: -6px;
	margin-right: -6px;
	margin-top: -1px;
	cursor: pointer;
}

.postPages a b {
	border-top-color: #09c;
	border-bottom-color: #09c;
	border-left-color: #09c;
	border-right-color: #09c;
	font-weight: normal;
	color: #09c;
	background-color: #fff;
}

.postPages strong {
	border-top: 1px solid;
	border-bottom: 1px solid;
	border-left: 1px solid;
	border-right: 1px solid;
	padding-top: 0px;
	padding-bottom: 0px;
	padding-left: 6px;
	padding-right: 6px;
	float: left;
	overflow: hidden;
	line-height: 20px;
	margin-right: 2px;
	height: 20px;
}

.postPages strong {
	border-top-color: #09c;
	border-bottom-color: #09c;
	border-left-color: #09c;
	border-right-color: #09c;
	font-weight: bold;
	color: #fff;
	background-color: #09c;
}

-->
</style>
<script type="text/javascript">
   Com_IncludeFile("jquery.js|dialog.js");
   Com_IncludeFile("list.js");
</script>
<script>
	$(document).ready(function(){
		dyniFrameSize();
		doZipImg();
		doZipTable();
		$("#closeReply").click(function(){
			$("#fdContent_hidden").hide();
			//SetWinHeight(window.parent.document.getElementById("win"));
	    	//	dyniFrameSize();
			
		});
		$("div[ref='parentContent']").each(function(){
			var value=$(this).html();
			value=value.replace(/<\/?.+?>/g,"&nbsp;");
		
			$(this).html(value);
			
		});
	//	parent.window.scroll(0, ($("#win",window.parent.document).offset().top)/2);
	   
	});

	/*
	 *  编写图片处理函数,在页面加载完之后对大图片进行压缩
	 */
	 function doZipImg(){
		 
		$("div[ref='fdContent']").find("img").each(function (){
			$(this).css("cursor","pointer");
			var width= $(this).width();
			var height=$(this).height();
			if(height>100) { $(this).height(100);}
			if(width>100) {$(this).width(Math.round(width*100/height));}
		}).click(function (){
			MaxImg(this);
		});
	    parent.window.scroll(0, ($("#win",window.parent.document).offset().top)/2+$(obj).offset().top);
	}

	 function MaxImg(obj){
				$(obj).hide();
				$(obj).width("");
				$(obj).height("");
				var width= $(obj).width();
				var height=$(obj).height();
				if(height>600) 
				   {
					  $(obj).height(600);
				      $(obj).width(Math.round(width*600/height));
				   }
				$(obj).show();
				dyniFrameSize();
				$(obj).click(function(){
					MinImg(this);
				});
			    parent.window.scroll(0, ($("#win",window.parent.document).offset().top)/2+$(obj).offset().top);
	}
	 function MinImg(obj){
				$(obj).hide();
				var width= $(obj).width();
				var height=$(obj).height();
				if(height>100) 
				   {
					  $(obj).height(100);
				      $(obj).width(Math.round(width*100/height));
				   }
				$(obj).show();
				dyniFrameSize();
			    parent.window.scroll(0, ($("#win",window.parent.document).offset().top)/2+$(obj).offset().top);
			    parent.window.reSetAbsolutePosition();	
			    $(obj).click(function(){
			    	MaxImg(this);
				});	    							
	}
		
	 function doZipTable(){
	 $("div[ref='fdContent']").find("table").each(function(){
			var width=$(this).width();
			var height=$(this).height();
			if(width>900){
			 //  alert(width);
			   $(this).width(900);			  
			   $(this).height(Math.round(height*900/width));
			   }		
		});
	 }
	 function formSubmit() {
			
			for(var i=0; i<Com_Parameter.event["confirm"].length; i++){
				if(!Com_Parameter.event["confirm"][i]()){
					return false;
				}
			}
			document.kmCollaborateMainReplyForm.submit();
		}
	 function dyniFrameSize() {
			try {
				// 调整高度
				var arguObj = document.getElementById("content");
				if(window.frameElement!=null && window.frameElement.tagName=="IFRAME"){
					window.frameElement.style.height = (arguObj.offsetHeight + 180) + "px";
				}
			} catch(e) {
		  }
		}
	/*	
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
	 */

	function focuOnTargetToReply(id,paramReplyId,paramName,paramTime,paramLou){
		window['$CURRENT_STATUS']= window['$CURRENT_STATUS'] ||"";
		window['$CURRENT_ID']=window['$CURRENT_ID'] || "";
	    var id="#edit_zone_"+paramReplyId;
	    try{
	    	$(id).append($("#fdContent_hidden")[0]);
	 	}catch(e){}
	    var url="../km_collaborate_main_reply/kmCollaborateMainReply.do?method=add&mainId=${param.mainId}&fdParentId="+paramReplyId;
	    
	    if($CURRENT_STATUS=="REPLY"){
	   	  if($CURRENT_ID==id){ 
	   		   $("#fdContent_hidden").hide();
	   	       $CURRENT_STATUS="";
	   	  }else{
			  $("#fdContent_hidden_iframe").attr("src",url);
		      $("#fdContent_hidden").show();
		      $CURRENT_STATUS="REPLY";
	   	  }
	   }else{
		  $("#fdContent_hidden_iframe").attr("src",url);
	      $("#fdContent_hidden").show();
	      $CURRENT_STATUS="REPLY";
	   }
	    $CURRENT_ID=id;
	    dyniFrameSize();
	    //SetWinHeight(window.parent.document.getElementById("win")); 
	    location.href="#reply_"+paramReplyId;
	   
	}
	function editReplyToUpdate(id,fdIdValue){
	   window['$CURRENT_STATUS']= window['$CURRENT_STATUS'] ||"";
	   window['$CURRENT_ID']=window['$CURRENT_ID'] || "";
	 	var fid="#edit_zone_"+fdIdValue;
	 	try{
	   		$(fid).append($("#fdContent_hidden")[0]);
	 	}catch(e){}
	    if($CURRENT_STATUS=="EDIT"){
	    	 if($CURRENT_ID==fdIdValue){ 
	    		      $("#fdContent_hidden").hide();
	   	              $CURRENT_STATUS="";
	    	 }else{
	    		 var url="${KMSS_Parameter_ContextPath}km/collaborate/km_collaborate_main_reply/kmCollaborateMainReply.do?method=edit&mainId=${param.mainId}&fdId="+fdIdValue;
	   			  $("#fdContent_hidden_iframe").attr("src",url);
	   	    	  $("#fdContent_hidden").show();
	   	   		   $CURRENT_STATUS="EDIT";
	    	 }
	   }else{
		  var url="${KMSS_Parameter_ContextPath}km/collaborate/km_collaborate_main_reply/kmCollaborateMainReply.do?method=edit&mainId=${param.mainId}&fdId="+fdIdValue;
		  $("#fdContent_hidden_iframe").attr("src",url);
	      $("#fdContent_hidden").show();
	      $CURRENT_STATUS="EDIT";
	   }
	    $CURRENT_ID=fdIdValue;
	    dyniFrameSize();
	   // SetWinHeight(window.parent.document.getElementById("win")); 
	   
	    
	    
	}
	function sort(type) {
		window.open("${KMSS_Parameter_ContextPath}km/collaborate/km_collaborate_main_reply/kmCollaborateMainReply.do?method=replyList&mainId=${param.mainId}&rowsize=${param.rowsize}&pageno=1"+"&sortType="+type,"_self");
	 	
	}
	function fdTime(fdTime){
		var x = fdTime.lastIndexOf(':');
		var value = fdTime.substring(0, x);
		return value;
	}


</script>
		<% 
		   KmCollaborateConfig kmCollaborateConfig=new KmCollaborateConfig();
		   String fdcontent=kmCollaborateConfig.getDefaultReply();
		   request.setAttribute("fdcontent",fdcontent);	
		   request.setAttribute("fdIsEdit",kmCollaborateConfig.getFdIsEdit());
		%>


<c:if test="${queryPage.totalrows==0}">
	<%@ include file="/resource/jsp/list_norecord.jsp"%>
</c:if>
<c:if test="${queryPage.totalrows>0}">
<div id="content" style="height:auto;">
      <!-- 正序/倒序列 -->
	<div style="width:100% ;height:20px;border:0px solid #ccc;">
	   <div style="float:right;margin-right:10px;">
			<input type="hidden" id="sort" value="asc">
			<c:if test="${param.sortType eq 'desc'}">
		 	    <a href="javascript:void(0)" onclick="sort('asc')" id="sortasc">>><bean:message key='kmCollaborate.jsp.zhengxu' bundle='km-collaborate' /></a>
			</c:if>
			<c:if test="${!(param.sortType eq 'desc')}">
			    <a href="javascript:void(0)" onclick="sort('desc')" id="sortdesc">>><bean:message key='kmCollaborate.jsp.nixu' bundle='km-collaborate' /></a>
			</c:if>
		</div>
    </div>
    
    <!-- 列表 -->
  	<c:forEach items="${queryPage.list}" var="reply" varStatus="varS">
	<div class="replyContent">
		<div class="replyPic">
		   <!-- 人头图片 -->
		  <div class="replyPic2"><img class="picture" src="../img/user2.gif" width="100" height="100" /></div>
		</div>
		<div class="replyWenzi">
		 	<div class="replyHead">
			    <div class="replyHead2">
			        <strong>
			        <!-- 几楼、创建者 -->
			        ${reply.docReplyFloor }
			        <bean:message key='kmCollaborate.jsp.lou' bundle='km-collaborate' />&nbsp;：&nbsp;${reply.docCreator.fdName }
			       </strong>&nbsp;&nbsp;&nbsp;&nbsp;
			        <!--创建时间 -->
			       <bean:message key='kmCollaborate.jsp.at' bundle='km-collaborate' /><strong>&nbsp;:&nbsp;</strong>&nbsp;<script>document.write(fdTime('${reply.docCreateTime }')); </script></div>	
			    <!-- 回复和编辑权限 -->
			    <c:if test="${ reply.fdCommunicationMain.docStatus== '30' }">
			    <c:if test="${fdIsEdit=='0'}">
			    <kmss:auth requestURL="/km/collaborate/km_collaborate_main_reply/kmCollaborateMainReply.do?method=updateReply&fdId=${reply.fdId }&fdCommunicationMainId=${reply.fdCommunicationMain.fdId}">		    
				    <!-- 编辑按钮 -->
				    <div class="replyEdit" onclick="editReplyToUpdate('replyMain${varS.count}','${reply.fdId }')">
				       <input type="hidden" id="fdParentId_${reply.fdId}" value="${reply.fdParentId}" />
				       <span style="display:block; width:40px; height:16px; margin:6px 0 0 30px;" ><bean:message  bundle ="km-collaborate" key="kmCollaborate.jsp.bianji"/></span>
				    </div>
			     </kmss:auth>
			     </c:if>
			    </c:if>
			      <!-- 回复按钮 -->
			    <kmss:auth requestURL="/km/collaborate/km_collaborate_main_reply/kmCollaborateMainReply.do?method=saveReply&fdId=${reply.fdId }&fdCommunicationMainId=${reply.fdCommunicationMain.fdId}">
			    	<c:if test="${ reply.fdCommunicationMain.docStatus== '30' }">
			    	<div class="replyReply" onclick="focuOnTargetToReply('replyMain${varS.count}','${reply.fdId}','${reply.docCreator.fdName }','${reply.docCreateTime }','${num+varS.count}楼')">
			    	     <span style="display:block; width:40px; height:16px; margin:6px 0 0 30px;" ><bean:message  bundle ="km-collaborate" key="kmCollaborate.jsp.reply"/></span>
			    	</div>
			        </c:if>
			    </kmss:auth>
		  	</div>
		  	<c:if test="${reply.docAlterTime != null }">
		  	   <!-- 修改时间 -->
			  	<center>
					<div style="height: 25px; line-height: 25px; background: #ffffcc; width: 45%;"><bean:message key='kmCollaborate.jsp.reply.str' bundle='km-collaborate' />&nbsp;${reply.docAlteror.fdName }&nbsp;<bean:message key='kmCollaborate.jsp.yu' bundle='km-collaborate' />&nbsp;<script>document.write(fdTime('${reply.docAlterTime}')); </script>&nbsp;编辑</div>
				</center>
				</c:if>
			<div class="replyMain" >
			 <!-- 回复楼层显示 -->
					<c:if test="${reply.fdParentId != null }">
						<div style="background: #C2D8FF;">
							<table >
								<tr>
									<td width="30px" style="padding-left:10px;padding-right:10px;">&nbsp;&nbsp;<img src="../img/quotation.png"></td>
									<td>${map[reply.fdParentId].docReplyFloor}<bean:message key='kmCollaborate.jsp.lou' bundle='km-collaborate' />：${map[reply.fdParentId].docCreator.fdName }   <bean:message key='kmCollaborate.jsp.at' bundle='km-collaborate' />&nbsp;&nbsp;<script>document.write(fdTime('${map[reply.fdParentId].docCreateTime }')); </script></td>
									<td colspan="2"></td>
								</tr>
								<tr>
									<td></td>
									<td >
										 <!-- <div  ref="parentContent" id="rfc${reply.fdId}" class="quote" style=" border:0px solid #ccc; width:100%;height:20px;" >
										      ${map[reply.fdParentId].fdContent }
										  </div> -->
										  <!-- 在pc端展现回复内容时显示和输入回复时的格式一致  lihuiyong -->
										   <div id="rfc${reply.fdId}" style=" border:0px solid #ccc; width:100%;height:20px;" >
										      ${map[reply.fdParentId].fdContent }
										  </div>
										 
									 </td>
									<td style="vertical-align: bottom;">&nbsp;&nbsp;&nbsp;&nbsp;<img src="../img/quotation2.png"></td>
									<td></td>
								</tr>
							</table>
						</div>
					</c:if>
				          <div ref="fdContent"   style="padding-top:10px;padding-bottom:10px;white-space:normal; word-break:break-all;" id="replyMain${varS.count}">
				          ${contentMap[reply.fdId] }
				          </div>				          				           
			          <div>
			          <span id="reply_${varS.count }" style="display:block; width:auto;height:auto;">
			              <table><tr><td>
				          <c:set var="replyForm" value="${reply}" scope="request"/>     
				          <c:import url="/sys/attachment/sys_att_main/sysAttMain_view.jsp" charEncoding="UTF-8">
								<c:param name="fdKey" value="replyAttachment"/>
								<c:param name="fdAttType" value="byte"/>
								<c:param name="fdModelId" value="${reply.fdId }"/>
								<c:param name="formBeanName" value="replyForm"/>
								<c:param name="fdModelName" value="com.landray.kmss.km.collaborate.model.KmCollaborateMainReply"/>
						  </c:import>
						<c:if test="${fdIsEdit=='1'}"> 
						  <script type="text/javascript">
						     attachmentObject_replyAttachment_${reply.fdId}.canEdit=false;
						  </script>	
			            </c:if>
						  </td></tr></table>
					 </span>
					 </div>
					 <a name="reply_${reply.fdId}" ></a>
					  <div id="edit_zone_${reply.fdId}" style="width:auto;height:auto;">
				           
				      </div>				      			           
			</div>
		</div>
	</div>
  	</c:forEach>	
   	
</div>
  <div class="pages">
<table width="100%">
	<tr>
	<td align="right"><span class="postPages"> 
	     <sunbor:page name="queryPage" pagenoText="pagenoText2" pageListSize="10"pageListSplit="">
				<sunbor:leftPaging>
					<b>&lt;<bean:message key="page.thePrev" /></b>
				</sunbor:leftPaging>
								{11}
				<sunbor:rightPaging>
					<b><bean:message key="page.theNext" />&gt;</b>
				</sunbor:rightPaging>
				<%
					if (((Page) request.getAttribute("queryPage"))
										.getTotal() > 1) {
				%>
				<span>{9}</span>
				<img src="${KMSS_Parameter_StylePath}icons/go.gif" border=0
					title="<bean:message key="page.changeTo"/>" onclick="{10}"
					style="cursor: pointer">
				<%
					}
				%>
			</sunbor:page> 
		</span> 		
		</td>
	</tr>
</table>
</div>
</c:if>

<div  id="fdContent_hidden" style=" border:0px solid #ccc;  margin:2px auto 0 100px; width:auto; height:auto;display:none;">
   <iframe style="margin:0 0  20px 0" name="fdContent_hidden_iframe" id="fdContent_hidden_iframe" frameborder="no" scrolling="no"  width="70%" height="500" src="" > 
   </iframe>
</div>


<%@ include file="/resource/jsp/view_down.jsp"%>