<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<link rel="stylesheet" href='${KMSS_Parameter_ContextPath}km/collaborate/pda/js/jquery.mobile-1.3.1.min.css' />
<link rel="stylesheet" href='${KMSS_Parameter_ContextPath}km/collaborate/pda/js/collaborate.css' />
<script src="${KMSS_Parameter_ContextPath}km/collaborate/pda/js/jquery-1.9.1.min.js"></script>
<script src="${KMSS_Parameter_ContextPath}km/collaborate/pda/js/jquery.mobile-1.3.1.min.js"></script>
<script src="${KMSS_Parameter_ContextPath}km/collaborate/pda/js/jquery.endless-scroll.js"></script>
<script src="${KMSS_Parameter_ContextPath}km/collaborate/pda/js/jquery.tipsy.js"></script>
<script src="${KMSS_Parameter_ContextPath}km/collaborate/pda/js/trunk8.js"></script>
<script type="text/javascript">

//拼装长按记录按钮
function tipsy_setHtml(fdId,json){
	if( !json ){
		var url='${KMSS_Parameter_ContextPath}km/collaborate/km_collaborate_main/kmCollaborateMain.do?method=setHtml&fdId='+fdId;
		$.ajax({
			type:"GET",
			url:url,
			async:false,
			success:function(msg){
				json = eval("("+msg+")");
			}
		});
	}else{
		json = eval("("+json+")");
	}
	var html='' ;
	
	//可阅读所有文档，但不是参与者和创建者不能进行关注操作
	if(json.hasAtt != "hasAtt"){
		//关注按钮判断
		html += '<a data-role="button" data-mini="true" data-theme="a" class=" noButton ';
		if(json.attententFlag){
			html +=' " data-icon="star" onclick="kmCollaborateMainUtil.follow(\''+fdId+'\',\'attention\')"> <bean:message bundle="km-collaborate" key="kmCollaborate.pda.attention"/>';
		}else{
			html += ' " onclick="kmCollaborateMainUtil.follow(\''+fdId+'\',\'cancleAttention\')"> <bean:message bundle="km-collaborate" key="kmCollaborate.jsp.calcelAtt"/>';
		}
		html += '</a>';
	}
	
	//转发按钮判断
	if(json.showForward){
		html += '<a onclick="kmCollaborateMainUtil.reAdd(\''+fdId+'\')" data-role="button" data-mini="true" data-theme="a" class=" noButton ';
		html +='"> <bean:message bundle="km-collaborate" key="kmCollaborate.pda.readd"/></a>';

	}
	
	//编辑按钮判断
	if(json.editFlag){
		html += '<a onclick="kmCollaborateMainUtil.edit(\''+fdId+'\')" data-role="button" data-mini="true" data-theme="a" class=" noButton ';
		html +=' "> <bean:message  key="button.edit"/></a>';
	}
	
	//结贴按钮判断
	html += '<a data-role="button" data-mini="true" data-theme="a" class=" noButton ';
	if(json.concludeFinish){
		if(json.conclude){
			html +='" onclick="kmCollaborateMainUtil.endIng(\''+fdId+'\')" > <bean:message bundle="km-collaborate" key="kmCollaborate.pda.ending"/></a>';
		}
	}else{
		html +=' ui-disabled " style="color: #00FF00"> <bean:message bundle="km-collaborate" key="kmCollaborate.pda.alreadyEnding"/></a>';
	}
	//移除前一条记录中拼装按钮
	$('.noButton').remove()
	$('#loadButton').before(html);
	$("#page_controlgroup").trigger("create");
	return $("#page_controlgroup").html();
} 

//index.jsp页面数据初始化
$(function(){
	$.mobile.ajaxLinksEnabled = false;
	var pageno=1;
	var type="all";
	//滚动条拖到最后执行加载数据
	var canLoading=true;
	var scrollEventEnable=false; 
	//默认显示15条
	var S_RowSize= 15;
	//滚动事件，去除遮罩
	$(document).bind("scrollstart",function(){
	    setTimeout("$('#header_navbar').popup('close');", 5000);
		setTimeout("$('.tipsy').remove();", 1000);
	});
	//取日期以前的沟通
	function getPdaLastList(){
		if($('#listview_loader').is(":visible") && canLoading){
			canLoading=false;
			$.getJSON("${KMSS_Parameter_ContextPath}km/collaborate/km_collaborate_main/kmCollaborateMain.do?method=pdalastList&S_RowSize="+S_RowSize,{"pageno":pageno,"type":type} ,function(data){
				if(data.list){
					//第一行标题样式处理
					if(pageno==1 && data.list.length>0){
						$('#listview_loader').before("<li data-role='list-divider' data-theme='b'><span id='beforeWeek' class='ui_li_icon ui_li_minus' onclick='hideChild(\"beforeWeek\",event)'></span> "+data.date+"&nbsp;&nbsp;<bean:message bundle='km-collaborate' key='kmCollaborateMain.pda.yiqian'/><span class='ui-li-count'>"+data.count+"</span></li>");
					}
					$(data.list).each(function(){
						var html="<li class='beforeWeek' id='"+this.fdId+"' name = '"+this.json+"'><a onclick='open_currentEdit(\""+this.fdId+"\")' href='javascript:void(0);'>"
								 +"<div data-role='none' class='txt'><p class='ui-li-heading uu-li-heading'>"+this.docSubject+"</p></div>" 
								 +"<p style='margin-bottom: 5px;'>"+this.fdContent+"</p>"
								 +"<span><p style='margin-top: 5px; color: #A1A1A1;'>"+this.docCreator+"&nbsp;&nbsp;"+this.docCreateTime+"</p>"
								 +"<p class='ui-li-aside' style=' margin-top: 1px; color: #A1A1A1;'>"+this.count+"</p></span></a>";
								$('#listview_loader').before(html);
					});
					
					$("#page_listview").listview("refresh");
					
					//listview 数据加长按事件
					$("#page_listview li:not([data-role])").each(function(){
						var fdId=$(this).attr('id');
						var json=$(this).attr('name');
						if(fdId!=null && fdId.length >= 32){
							//拼装长按list列表数据按钮展现
							$(this).tipsy({gravity: 'n',html:true,trigger: 'manual',fallback:tipsy_setHtml(fdId,json)});
						}
						$(this).taphold(function(){
							$(".tipsy").remove();
							//开启遮罩
							$(".tipsy-cover").show();
							$(this).tipsy("show");
						});
					});
				}
				//小于规定条数不再加载
				if(data.list.length < parseInt(S_RowSize)){
					$('#listview_loader').hide();
					if($("#page_listview li").not("#listview_loader").length>0){
						$('#listview_loader').before("<li data-icon='false'><div style='text-align: center;padding:6px 0;'><i><bean:message bundle='km-collaborate' key='kmCollaborateMain.pda.endweek'/></i></li>");
					}else{
						$('#listview_loader').before("<li data-icon='false'><div style='text-align: center;padding:6px 0;'><i><img style='vertical-align:middle;width:32px;hight:32px' src='${KMSS_Parameter_ContextPath}km/collaborate/pda/js/images/prompt_error.gif'><bean:message bundle='km-collaborate' key='kmCollaborateMain.pda.error.sorry'/></i></div></li>");
					}
				}
				pageno++;
				canLoading=true;
				$(".txt p").trunk8({lines: 2});
			});
		}
	}
	//获取本周和上周数据
	function getPdaFirstList(){
		pageno=1;
		$.getJSON("${KMSS_Parameter_ContextPath}km/collaborate/km_collaborate_main/kmCollaborateMain.do?method=pdaFirstList",{"type":type},function(data){
			var recount=0;
			var json;
			if(data.thisWeek){
				recount += data.thisWeek.length;
				//本周沟通
				$('#listview_loader').before("<li data-role='list-divider' data-theme='b'><span id='thisWeek' class='ui_li_icon ui_li_minus' onclick='hideChild(\"thisWeek\",event)'></span><span style='line-height:20px;'><bean:message bundle='km-collaborate' key='kmCollaborateMain.pda.currentweek'/></span><span class='ui-li-count' >"+data.thisWeek.length+"</span></li>");
				$(data.thisWeek).each(function(){
					var html="<li class='thisWeek' id='"+this.fdId+"'><a onclick='open_currentEdit(\""+this.fdId+"\")' href='javascript:void(0);'>" 
							 +"<div data-role='none' class='txt' ><p class='ui-li-heading uu-li-heading'>"+this.docSubject+"</p></div>" 
							 +"<p style='margin-bottom: 5px;'>"+this.fdContent+"</p>"
							 +"<span><p style='margin-top: 5px; color: #A1A1A1;'>"+this.docCreator+"&nbsp;&nbsp;"+this.docCreateTime+"</p>"
							 +"<p class='ui-li-aside' style=' margin-top: 1px; color: #A1A1A1;'>"+this.count+"</p></span></a>";
					$('#listview_loader').before(html);
					json = this.json;
				});
			}
			if(data.lastWeek){
				recount += data.lastWeek.length;
				//上周沟通
				$('#listview_loader').before("<li data-role='list-divider' data-theme='b'><span id='lastWeek' class='ui_li_icon ui_li_minus' onclick='hideChild(\"lastWeek\",event)'></span><bean:message bundle='km-collaborate' key='kmCollaborateMain.pda.prevweek'/><span class='ui-li-count'>"+data.lastWeek.length+"</span></li>");
				$(data.lastWeek).each(function(){
					var html="<li class='lastWeek' id='"+this.fdId+"' name = '"+this.json+"'><a onclick='open_currentEdit(\""+this.fdId+"\")' href='javascript:void(0);'>"
							 +"<div data-role='none' class='txt' ><p class='ui-li-heading uu-li-heading'>"+this.docSubject+"</p></div>" 
							 +"<p style='margin-bottom: 5px;'>"+this.fdContent+"</p>"
							 +"<span><p style='margin-top: 5px; color: #A1A1A1;'>"+this.docCreator+"&nbsp;&nbsp;"+this.docCreateTime+"</p>"
							 +"<p class='ui-li-aside' style=' margin-top: 1px; color: #A1A1A1;'>"+this.count+"</p></span></a>";
					$('#listview_loader').before(html);
				});
			}
			$("#page_listview").listview("refresh");
			$("#page_listview li:not([data-role])").each(function(){
				var fdId=$(this).attr('id');
				var json = $(this).attr('name');
				if(fdId!=null && fdId.length >= 32){
					//拼装长按list列表数据按钮展现
					$(this).tipsy({gravity: 'n',html:true,trigger: 'manual',fallback:tipsy_setHtml(fdId,json)});
				}
				$(this).taphold(function(){
					$(".tipsy").remove();
					$(this).tipsy("show");
				});
			});
			if(recount < parseInt(S_RowSize)){
				getPdaLastList();
			}
			//防止滚动事件未加载完再请求一次
			if(scrollEventEnable==false){
				$(document).endlessScroll({fireOnce: false,fireDelay: false,
					loader: "<div class=\"loading\"><div>",
					bottomPixels: 100,
					fireDelay: 10,
					callback: function(){
						getPdaLastList();
					}
				});
				scrollEventEnable=true;
			}
		});
	}
	// 给底部按钮添加事件
	$("#header_navbar ul li a").click(function(){
		$("#header_navbar ul li a").removeClass("uu-li-a-selected");
		$(this).addClass("uu-li-a-selected");
		type= $(this).attr("type");
		$("#page_listview li").not("#listview_loader").remove();
		$("#listview_loader").show();
    	getPdaFirstList();
    	$("#header_navbar").popup( "close" );
		//关闭弹出的popup菜单.
	  //  setTimeout(function setElQsdsVal(){
	//			$("#header_navbar").popup( "close" );
	 //  },5000);
		 
		//将Id为menuTipId的div里面的内容换成鼠标点中的内容
		var CollaborateType = $(this).attr("type");
		if("all"==CollaborateType){
		       document.getElementById("menuTipId").innerHTML="<bean:message bundle='km-collaborate' key='kmCollaborateMain.allWorkc'/>";
	   	} 
		if("myCreate"==CollaborateType){
	    		document.getElementById("menuTipId").innerHTML="<bean:message bundle='km-collaborate' key='kmCollaborateMain.myLaunch'/><bean:message bundle='km-collaborate' key='table.kmCollaborateMainTitle'/>";
	    	}
		if("myReader"==CollaborateType){
	    		document.getElementById("menuTipId").innerHTML="<bean:message bundle='km-collaborate' key='kmCollaborateMain.myParticipate'/><bean:message bundle='km-collaborate' key='table.kmCollaborateMainTitle'/>";
	    	}
		if("myFollow"==CollaborateType){
	    		document.getElementById("menuTipId").innerHTML="<bean:message bundle='km-collaborate' key='kmCollaborateMain.myAttention'/><bean:message bundle='km-collaborate' key='table.kmCollaborateMainTitle'/>";
	    	}
	});
	//新建按钮添加shij
	$("#div_otherBtn").click(function(){
		window.open('<c:url value="/km/collaborate/km_collaborate_main/kmCollaborateMain.do" />?method=add&flag=pda','_self');
	});
	getPdaFirstList();
    setTimeout('$(".txt p").trunk8({lines: 2})', 800);
});


var kmCollaborateMainUtil={};
kmCollaborateMainUtil.webRoot='${KMSS_Parameter_ContextPath}';
kmCollaborateMainUtil.reAdd=function(fdId){
	if(fdId!=null||fdId!=''){
		var url='${KMSS_Parameter_ContextPath}km/collaborate/km_collaborate_main/kmCollaborateMain.do?method=add&flag=pda'
				+'&pda=true'
				+'&showForward=true'
				+'&showid='+fdId;
		window.open(url,"_self");
	}else{
		return;
	}
}
//结束
kmCollaborateMainUtil.endIng=function(fdId){
	if(fdId!=null||fdId!=''){
		 var url='${KMSS_Parameter_ContextPath}km/collaborate/km_collaborate_main/kmCollaborateMain.do?method=conclude'
		 	+'&fdId='+fdId;
	}else{
		return; 
	}
	$.ajax({
		type:"GET",
		url:url,
		success:function(msg){
			document.getElementById("alertId").innerHTML="<bean:message bundle='km-collaborate' key='kmCollaborateMain.pda.endingsuccess'/>!";
			$("#popupAlert").popup( "open", {theme: "a",shadow: true,overlayTheme: "a" ,tolerance:"30,15,30,15"});
			setTimeout(function setElQsdsVal(){
				$("#popupAlert").popup( "close" );
			   },2000);
			//动态刷新该工具条
			$("#"+fdId).tipsy(true).options.fallback=tipsy_setHtml(fdId);
			$(".tipsy").remove();
		}
	});
}

//attention关注
kmCollaborateMainUtil.follow=function(fdId,flag){
	//关注是标识，用来判断当前内容是否被关注 flag=='cancleAttention'取消关注 flag=='attention'关注
	if(fdId!=null||fdId!=''){
		var url='${KMSS_Parameter_ContextPath}km/collaborate/km_collaborate_partner_info/kmCollaboratePartnerInfo.do?method=isRead'
			+'&docid='+fdId
			+'&flag='+flag;
	}else{
		return; 
	}
	$.ajax({
		type:"GET",
		url:url,
		success:function(msg){
			//kmCollaborateMain.pda.guanzhusuccess = 关注成功
			if(flag == 'attention'){
				document.getElementById("alertId").innerHTML="<bean:message bundle='km-collaborate' key='kmCollaborate.jsp.attention.success'/>!";
				$("#popupAlert").popup( "open",{theme: "a",shadow: true,overlayTheme: "a",tolerance:"30,15,30,15" });
				setTimeout(function setElQsdsVal(){
					$("#popupAlert").popup( "close" );
				   },2000);
			}else{
			    document.getElementById("alertId").innerHTML="<bean:message bundle='km-collaborate' key='kmCollaborate.jsp.calcelAtt.success'/>!";
				$("#popupAlert").popup( "open", {theme: "a",shadow: true,overlayTheme: "a" ,tolerance:"30,15,30,15"});
				setTimeout(function setElQsdsVal(){
					$("#popupAlert").popup( "close" );
				   },2000);
			}
			//动态刷新该工具条
			$("#"+fdId).tipsy(true).options.fallback=tipsy_setHtml(fdId);
			$(".tipsy").remove();
		}
	});
}

//编辑
kmCollaborateMainUtil.edit=function(fdId){
	if(fdId!=null||fdId!=''){
		 var url='${KMSS_Parameter_ContextPath}km/collaborate/km_collaborate_main/kmCollaborateMain.do?method=edit&flag=pda'
			 	+'&fdId='+fdId;
		 window.open(url,"_self");
		 $(".tipsy").remove();
	}else{
		return;
	}
}

//list列表点击事件
function open_currentEdit(fdId){
	//当出现长按钮时，则不调用的编辑事件
	if($('.tipsy').length>0){
		return;
	}
	var url="${KMSS_Parameter_ContextPath}km/collaborate/km_collaborate_main/kmCollaborateMain.do?method=view&flag=pda&s_css=default&pda=true&fdId="+fdId;
	window.open(url,"_self");
};
//工作台事件
function gotoUrl(url){
	if(window.stopBubble)
		window.stopBubble();
	location=url;
}
//收缩事件
function hideChild( week, e) {
	if($("."+week).is(":hidden")){        
		$("."+week).show(); 
		$("#"+week).removeClass();
		$("#"+week).addClass("ui_li_icon ui_li_minus");
	
	}else{      
		$("."+week).hide();
		$("#"+week).removeClass();
		$("#"+week).addClass("ui_li_icon ui_li_plus");
	}
	if(e){     
		e.cancelBubble = true;     // ie下阻止冒泡        
	}else{  
		e.stopPropagation();     // 其它浏览器下阻止冒泡       
	}
}
</script>