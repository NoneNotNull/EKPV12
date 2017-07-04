<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="java.util.Map"%>
<%@page import="com.sunbor.web.tag.Page"%>
<%@page import="com.landray.kmss.km.collaborate.model.KmCollaborateMainReply" %>
<%@page import="com.landray.kmss.third.pda.model.PdaRowsPerPageConfig"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@include file="/third/pda/htmlhead.jsp"%>
<script src='${ KMSS_Parameter_ContextPath }sys/mobile/js/mui/device/device.js'></script>
<%@page import="com.landray.kmss.km.collaborate.model.KmCollaborateConfig" %> 
<html>
<head>
<title><bean:message bundle="km-collaborate" key="kmCollaborateMainReply.pda.replylist.title"/></title>
<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="stylesheet" href="${KMSS_Parameter_ContextPath}km/collaborate/pda/js/jquery.mobile-1.3.1.min.css" />  
<script src="${KMSS_Parameter_ContextPath}km/collaborate/pda/js/jquery-1.9.1.min.js"></script>
<script src="${KMSS_Parameter_ContextPath}km/collaborate/pda/js/jquery.mobile-1.3.1.min.js"></script>
<script src="${KMSS_Parameter_ContextPath}third/pda/resource/script/address.js" type="text/javascript"></script>
	 <%  
        //获取默认回复内容
    	KmCollaborateConfig collConfig = new KmCollaborateConfig();
    	request.setAttribute("kmCollaborateConfig", collConfig);
	    String defaultReply = collConfig.getDefaultReply();
	    
	    //获取third/pda下默认条数
	    PdaRowsPerPageConfig pdaRow=new PdaRowsPerPageConfig();
	    String rowsize=pdaRow.getFdRowsNumber();
    %> 
<script>
$(document).ready(function(){
	var fdPdaType = device.getClientType();
	document.getElementsByName("fdPdaType")[0].value=fdPdaType;
	//缩小图片
	doZipImg(); 
	$(window.parent.document.getElementById("win")).height($("#page-listview").height());
  });		
/*
 *  编写图片处理函数,在页面加载完之后对大图片进行压缩
 */
 function doZipImg(){
	$("div[ref='fdContent']").find("img").each(function (){
		$(this).css("cursor","crosshair");
		var width= $(this).width();
		var height=$(this).height();		
		if(height>60) { $(this).height(60);}
		if(width>60) {$(this).width(Math.round(width*60/height));}
		//在img标签外面加上a标签。
		$("img").wrap("<a data-theme='b' data-position-to='origin' data-rel='popup' href='#popupPhotoLandscape' aria-haspopup='true' aria-owns='#popupPhotoLandscape'></a>");
	}).click(function (event){	
		//开始点击图片是，将img中的src赋给popup中的src
		$("#popupImgId").attr("src", $(this).attr("src"));
	});
}
  //用于弹出的回复的回复的对话框，动态生成提交按钮的超链接。
  function dynamicHtmlForSubmit(parentId){  
	  //隐藏view页面的回复和回复所有人两个按钮，及上面的导航条
	  window.parent.document.getElementById("replyOne").style.visibility = "hidden"; 
	  window.parent.document.getElementById("replyAll").style.visibility = "hidden"; 
	  window.parent.document.getElementById("narBarId").style.visibility = "hidden"; 
	  $("#tipContentIsNull").hide();
	  $("#fdNotifyType").hide();
	  document.getElementById("fdParentId").value = parentId;
	  $("#submitReplyId").html("<a class='ui-btn ui-shadow ui-btn-corner-all ui-btn-up-a' data-theme='a' type='button' href='javascript:void(0)' onclick='submitReplyOfReply()' data-corners='true' data-shadow='true' data-iconshadow='true' data-wrapperels='span'><span class='ui-btn-inner'><span class='ui-btn-text'><bean:message bundle='km-collaborate' key='kmCollaborateMain.pda.submit'/></span></span></a>");
	  //恢复默认通知方式
	  var type = "${kmCollaborateConfig.defaultNotifyType}";
 	  $("#replyPopUp input[type='checkbox']").each(function(){
		  if(type.indexOf($(this).attr('mark')) != -1)
			  $(this).prop({checked:true});
		  else
			  $(this).prop({checked:false});
	  }); 
 	  var height = $("#replyPopUp")[0].offsetHeight;
 	  var win = window.parent.document.getElementById("win");
 	  //alert(win.offsetHeight);
 	  var scroll = win.offsetHeight<height?height:win.offsetHeight;
 	  win.style.height = scroll+'px';
	  document.getElementsByName('fdNotifyType')[0].value = type;
  }
</script>
<script type="text/javascript"> 
//执行完图片弹窗后，将弹窗关闭
  $( document ).on( "pageinit", function() {
     $( ".photopopup" ).on({
         popupafterclose: function(event, ui) {
     		$( "#popupPhotoLandscape" ).popup( "close" );
     	}
     });
 });  
</script>
<!--图片表单自适应屏幕大小-->
<style type="text/css">
.notNull {
	padding-left: 10px;
	border: solid #DFA387 1px;
	padding-top: 8px;
	padding-bottom: 8px;
	background: #FFF6D9;
	color: #C30409;
	margin-top: 3px;
	font-size: 12px;
}

.ui-mobile img {
	max-width: 100%;
	height: 50%;
}

.ui-mobile table {
	max-width: 100%;
	max-height: 50%;
	vertical-align: center;
}

/*覆盖回复内容换行样式 */
#page-listview li p {
	overflow: auto !important;
	white-space: normal !important;
	word-break: break-all;
	font: 13px Arial, Verdana, Helvetica, sans-serif, STHeitiSC-Light
		! important;
}

.greenComma {
	font: bold 20px Arial, Verdana, Helvetica, sans-serif, STHeitiSC-Light;
	color: #81bc26;
}

/*覆盖回复内容字体大小 */
.ui-li-desc {
	font-size: 13px !important;
}

.ui-body-c .ui-link {
	font-weight: normal;
}

.attach_link {
	white-space: normal;
	display: block;
	line-height: 20px;
	padding-top: 2px;
}
</style>
</head>
<body>
	<ul id="page-listview" data-role="listview">
		<li data-role="list-divider"><bean:message bundle="km-collaborate" key="kmCollaborate.jsp.xgjl"/><span class="ui-li-count">${queryPage.totalrows}</span></li>
		<!-- omit something -->
		<div id='butt' class='div_page' align='center' onclick='viewMore();' style='display: block;'> 
			<bean:message bundle="km-collaborate" key="kmCollaborate.jsp.viewMore"/>
		</div>	
		<div id="msg" style="text-align: center;padding:6px 0;"> </div>
	</ul>
	
	<!-- 弹出的回复的回复对话框 -->
	<div data-role="popup" id="replyPopUp" data-theme="a" data-overlay-theme="a">
	    <form name="kmCollaborateMainReplyForm"
	          action="${KMSS_Parameter_ContextPath}km/collaborate/km_collaborate_main_reply/kmCollaborateMainReply.do?method=saveReplyOfReply&pda=true&fdIsOnlyView=${fdIsOnlyView}&docCreatorId=${docCreatorId}"  
	          method="post" 
	          style="padding:10px 20px;">
	       <h3><bean:message bundle="km-collaborate" key="table.kmCollaborateMainReply"/></h3>     
	       <textarea style="max-width:250px;max-height:50px;min-width:250px;min-height:50px;" cols="30" style="height: 100px;" rows="10" name="fdContent" id="fdContent" 
	                 placeholder="<bean:message bundle='km-collaborate'  key='kmCollaborateMainReply.fdContent'/>" ><%=defaultReply==null?"":defaultReply %></textarea>      
		   <div class="notNull" id="tipContentIsNull"><span class="validation-advice-img" valign="top">×</span>&nbsp;<bean:message bundle="km-collaborate" key="kmCollaborate.fdContent.notNull"/></div>
		   <kmss:editNotifyType property="fdNotifyType" value="${kmCollaborateConfig.defaultNotifyType }" />
	       <div class="notNull" id="fdNotifyType"><span class="validation-advice-img" valign="top">×</span>&nbsp;<bean:message bundle="km-collaborate" key="kmCollaborateMain.choose.notifytype"/></div>
	       <input name="fdParentId" type="hidden" id="fdParentId" value="" >   
	       <input type="hidden" name="fdCommunicationMainId" value="${mainId}"/>   
	       <input type="hidden" name="fdReplyType" value="0">
	       <input type="hidden" name="fdPdaType">
	       <div class="ui-grid-a">
				<div class="ui-block-a">
					<a href="#" data-role="button" data-theme="d" data-rel="back" 
	                   onclick="cancel()"><bean:message bundle="km-collaborate" key="kmCollaborateMain.pda.cancel"/></a>
				</div>
				<div class="ui-block-b" id="submitReplyId">
				</div>
		   </div>
	   </form>
    </div>
    <!-- 弹出回复内容中的图片 -->
    <div data-role="popup" id="popupPhotoLandscape" class="photopopup" data-overlay-theme="a" data-corners="false" data-tolerance="30,15"> 
		<a href="#" data-rel="back" data-role="button" data-theme="a" data-icon="delete" data-iconpos="notext" class="ui-btn-right"> 
			Close
		</a> 
		<img id="popupImgId" src="" alt="photo">  
	</div>  
</body>
<script>
		/*去增强效果，标记通知方式checkbox*/
		$("input[type='checkbox']").attr("data-role","none");
		$("input[type='checkbox']").each( function(){
			$(this).attr("mark",$(this).val());
		});
     //首次加载判断记录数量默认为6条
     //判断是否弹出对话框
     var dialogOpen=false;
 		/* var num = $("ul>li").not(":first").length;
 		if(num == 0){
 			$("#butt").hide();
 			$("#msg").html("<i><bean:message bundle='km-collaborate' key='kmCollaborateMain.pda.error.sorry'/>！</i>");
 		}else if("${length}" <= 6 && "${pageFlag}" == 'false'){
 			$("#butt").hide();
 			$("#msg").html("<i><bean:message bundle='km-collaborate' key='kmCollaborateMain.pda.endweek'/>！</i>");
 			document.parent.documentElement.scrollTop=parseInt(document.parent.body.offsetHeight)-parseInt(document.parent.documentElement.offsetHeight)+500;
 			} */
      //根据记录数，调整滚动条显示的长度，避免数据被覆盖
      //获取div的高度
	  var height=$("#page-listview").height()+$("#butt").height()+$("#msg").height();
	  $(window.parent.document.getElementById("win")).height(height);
      //查看更多出发事件 	  
	  var pageFlag= ${pageFlag};
	   $("input[type='checkbox']").attr("data-role","none");
      if(window.parent.replyOfReply!=null){
		  window.parent.scrollTo(0,9999);
		  window.parent.replyOfReply=null;
       };
	  //附件相关方法
	  function att_formatSize(filesize){
			var result = "";
			var index;
			if(filesize!=null && filesize!="") {
				if((index=filesize.indexOf("E"))>0) {			
					var size = parseFloat(filesize.substring(0,index))*Math.pow(10,parseInt(filesize.substring(index+1)));
				}else
					var size = parseInt(filesize);
				if(size<1024) 
					result = size + "B";
				else{
					var size = Math.round(size*100/1024)/100;
					if(size<1024)
						result = size + "KB";
					else{
						var size = Math.round(size*100/1024)/100;
						if(size<1024)
							result = size + "M";
						else {
							var size = Math.round(size*100/1024)/100;
							result = size + "G";
						}
					}
				}
			}
			return result;
		}
	  //附件相关方法
	  function att_Type(fileName){
		var  attSuffixLower =  fileName.split(".")[fileName.split(".").length -1].toLowerCase();
		var classVar = "div_otherAtt";
		if(attSuffixLower=='ppt' || attSuffixLower=='pptx' )
			classVar = "div_pptAtt";
		if(attSuffixLower=='doc' || attSuffixLower=='docx' )
			classVar = "div_docAtt";
		if(attSuffixLower=='xls' || attSuffixLower=='xlsx')
			classVar = "div_xlsAtt";
		if(attSuffixLower=='pdf')
			classVar = "div_pdfAtt";
		if(attSuffixLower=='vsd')
			classVar = "div_vsdAtt";
		if(attSuffixLower=='txt')
			classVar = "div_txtAtt";
		if(attSuffixLower=='png'||attSuffixLower=='jpg'||attSuffixLower=='gif'||attSuffixLower=='bmp')
			classVar = "div_imgAtt";
		return classVar;
	  }
	  var pageNo = 0;
      function viewMore(){
		//获取已经显示的回复数量
		var total=$("ul>li").not(":first").length;
		var S_RowSize="<%=rowsize==null?"":rowsize%>";
		pageNo = pageNo+1;
		$("#msg").html('<div style="text-align: center;padding:6px 0;"><img height="32px" width="32px" style="vertical-align:middle;width:32px;height:32px" src="${KMSS_Parameter_ContextPath}km/collaborate/pda/js/images/ajax-loader.gif">正在加载....</div>');
		$("#butt").hide();
		$("#msg").show();
		$.ajax({
			 url:"${KMSS_Parameter_ContextPath}km/collaborate/km_collaborate_main_reply/kmCollaborateMainReply.do?method=viewMore&mainId=${mainId}&total="+total+"&pageNo="+pageNo+"&S_RowSize="+S_RowSize+"&fdIsOnlyView=${fdIsOnlyView}&docCreatorId=${docCreatorId}&flag=pda",
			 type:'POST',
	  		 success:function(data){
	  			 var arr=eval(data);
	  			 var html="";
	  			 //结贴时候不能再进行回复
	  			 var ahref="";
	  			 //var li="<li class='ui-li ui-li-static ui-btn-up-c ui-last-child'>";
				   var li="<li class='ui-btn ui-li ui-last-child ui-btn-up-c' >";

	  			 //用来显示回复_楼，发表人：_
	  			 var rep;
	  			 //回复所有人
	  			 var repto;
	  			 for(var i=0;i<arr.length;i++){
	  				rep="";
	  				repto="";
	  				if(arr[i].repType == 2){
	  					 repto="<bean:message bundle='km-collaborate' key='kmCollaborate.jsp.replyAll'/>";
	  				}
	  				else
	  				{
	  					repto="<bean:message bundle='km-collaborate' key='kmCollaborate.jsp.at'/>";
	  				}
	  				if(arr[i].parentId != null){
	  					 rep="<div align='left' style='font-size:13px;background: #d5d7d2;' class='div_overflowArea' ref='fdContent'> <div class='greenComma'>\"</div>&nbsp;"+arr[i].replyFloor+"&nbsp;<bean:message bundle='km-collaborate' key='kmCollaborate.jsp.lou'/>&nbsp;&nbsp;"
	  					 +arr[i].replyFloorName+" <bean:message bundle='km-collaborate' key='kmCollaborate.jsp.at'/>:"+arr[i].repTime.substring(0,16)
	  					 +"<br/>"+arr[i].repContent
	  					 +"<div align='right' class='greenComma'>\"</div>	 </div>";
	  				}
	  				//可阅读所有文档且不是参与者和创建者的回复权限控制
	  				if(arr[i].canRep == 'canRep'){
	  					if(arr[i].docStatus == '30'){
	  					ahref="<a class='ui-link-inherit' data-position-to='origin' data-rel='popup' onclick='dynamicHtmlForSubmit(\""+arr[i].fdId+"\")' href='#replyPopUp'>";		
	  					li="<li class='ui-btn ui-btn-icon-right ui-li-has-arrow ui-li ui-last-child ui-btn-up-c' data-corners='false' data-shadow='false' data-iconshadow='true' data-wrapperels='div' data-icon='arrow-r' data-iconpos='right' data-theme='c'>";
	  					}
	  				}
	  				//附件显示
	  				var sample = "<div><div class='div_otherAtt'> </div><span class='attach_link'><a class='ui-link' target='_blank' href='<c:url value="/sys/attachment/sys_att_main/sysAttMain.do" />?method=download&fdId=attachmentId' > attachmentFileName </a> <span class='list_summary'>(size)</span> </span></div>";
	  				var att = "<br><br><p><table width=100% ><tr><td class='td_common' width=80% ><div class='div_attGroup' >";
	  				for( var a=0; a <arr[i].attachment.length ; a++ ){
	  					var tempone = sample.replace("attachmentId",arr[i].attachment[a].fdId);
	  					tempone = tempone.replace("attachmentFileName",arr[i].attachment[a].fileName);
	  					tempone = tempone.replace("size",att_formatSize(arr[i].attachment[a].filesize));
	  					tempone = tempone.replace("div_otherAtt",att_Type(arr[i].attachment[a].fileName ));
	  					att += tempone;
	  				}
	  				att += "</div></td></tr></table></p>";
	  				if(arr[i].attachment.length == 0){
	  					att ="";
	  				}
					html+=li+"<div class='ui-btn-inner ui-li'><div class='ui-btn-text'>"
					+ahref+
					"<p class='ui-li-heading ui-li-desc' style='margin-top:0px;overflow:visible!important;word-break: keep-all; '>"+
					"<strong>"+arr[i].docReplyFloor+"&nbsp<bean:message bundle='km-collaborate' key='kmCollaborate.jsp.lou'/>:&nbsp;&nbsp;&nbsp;&nbsp"
					+arr[i].docFloorName
					+"&nbsp;&nbsp;&nbsp;"+repto+":&nbsp;&nbsp;&nbsp;"
					+arr[i].docReplyTime.substring(0,16)+"&nbsp;&nbsp;"+"</strong></p>"+
					"<p class='ui-li-desc' align='right' style='font-size: 13px'>"
					+
					rep//"回复1楼  发表人:管理员 "
					+
					"</p><br>"                             
                    +"<strong><div class='div_overflowArea' ref='fdContent'><p class='ui-li-desc'>"+arr[i].replyContent+"</p></div></strong>"+
					"</a>"
					+"</div>"
					+att
					+"<span class='ui-icon ui-icon-arrow-r ui-icon-shadow'></span></div></li>";
					pageFlag = arr[i].pageFlag;
	  			 }
	  			 $("#butt").before(html);
	  			 //判断是否到达最后记录
	  			 if(pageFlag){
	  				 $("#butt").show();
	  			     $("#msg").hide();
	  			 }else{
	  			   		if(arr.length != 0){
			  				 $("#butt").hide();
			  			     $("#msg").html("<i><bean:message bundle='km-collaborate' key='kmCollaborateMain.pda.endweek'/></i>");
			  			     $("#msg").show();
		  				 }
		  				 if(arr.length == 0){
			  				 $("#butt").hide();
			  			     $("#msg").html("<i><bean:message bundle='km-collaborate' key='kmCollaborateMain.pda.error.sorry'/></i>");
			  			     $("#msg").show();
			  			 }
	   			 }
	  			//对点击更多后加载的回复内容，若内容中有图片进行图片压缩  		
	  			doZipImg();
	  			//调整滚动条的长度，避免数据显示不出来
	  			height=$("#page-listview").height();
	  			$(window.parent.document.getElementById("win")).height(height);
	  		}
	  });
	}
	$(window.parent.document).scroll(function(){
		//滚动条高度
		var scrollHeight=$(window.parent.document).scrollTop();
		//文件高度
		var documentHeight=$(window.parent.document).height();
		//页面高度
		var windowHeight=$(window.parent).height();
		if( (documentHeight-windowHeight)-scrollHeight <= 50){
			if(pageFlag){
				pageFlag=false;
				viewMore();
			}
		}
	});
	viewMore();
	//取消回复的回复
	function cancel(){
		$(window.parent.document.getElementById("win")).height(height);
		document.getElementById("fdContent").value = "${lfn:escapeJs(kmCollaborateConfig.defaultReply)}";
		window.parent.document.getElementById("replyOne").style.visibility = "visible"; 
		window.parent.document.getElementById("replyAll").style.visibility = "visible"; 
		window.parent.document.getElementById("narBarId").style.visibility = "visible"; 
	}
	function submitReplyOfReply(){	
		$("#fdNotifyType").hide();
		$("#tipContentIsNull").hide();
		var txtObj = document.getElementById("fdContent");
	    html=changeBr(txtObj);
		txtObj=$.trim(txtObj.value);
		if( null != txtObj && txtObj == ''){
			$("#tipContentIsNull").show();
			return false;		
		}else{
			$("#tipContentIsNull").hide();
		}
		var fdNotifyType = document.getElementsByName("fdNotifyType")[0].value;
		if(null == fdNotifyType || fdNotifyType==""){
			$("#fdNotifyType").show();
			$("#notifyType input[type='checkbox']").focus();
			return false;
		}else{
			$("#fdNotifyType").hide();
		}		
 		kmCollaborateMainReplyForm.style.display = "none";
		document.getElementById("fdContent").value = html;
	    document.kmCollaborateMainReplyForm.submit();
	    //回复成功，默认跳到最顶层
	    window.parent.scrollTo(0,0);		
		//显示view页面的回复和回复所有人两个按钮，及上面的导航条
		window.parent.document.getElementById("replyOne").style.visibility = "visible"; 
		window.parent.document.getElementById("replyAll").style.visibility = "visible"; 
		window.parent.document.getElementById("narBarId").style.visibility = "visible"; 
 	}
 	 //保存带有换行格式的内容
 	 function changeBr(txtObj){
		 var textArray = txtObj.value.split("\n"); //对文本进行分行处理
	        var html = "";
	        for (var i = 0; i < textArray.length; i++) {
	            html += "<p>"+textArray[i] + "<p/>";//加上html换行符
	        }
	        return html;
	}
</script>
</html>