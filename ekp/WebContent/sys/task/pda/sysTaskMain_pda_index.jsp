<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
	<%@ include file="/third/pda/htmlhead.jsp"%>
    <link rel="stylesheet" type="text/css" href="<c:url value="/sys/task/css/common.css"/>"/>
    <link type="text/css" rel="stylesheet" href="<c:url value="/sys/task/css/icon/font-mui.css"/>" />
    <script type="text/javascript">
     Com_IncludeFile("jquery.js|json2.js|kms_tmpl.js");
		//工作台事件
		function gotoUrl(url){
			if(window.stopBubble)
				window.stopBubble();
			location=url;
		}
var requestUrl = "";
		/******************************
		 * JavaScript Page对象
		 *******************************/
	function Page(pageCount,pageno,nextPageStart){
		this.pageCount=pageCount;
		this.pageno=pageno;
		this.nextPageStart=nextPageStart;
		this.toString=function(){
			return "pageno="+this.pageno+",pageCount="+this.pageCount+",nextPageStart="+this.nextPageStart;
		};
	}

    function setTab(name, cursel, n) {
    	var viewDiv= document.getElementById("tab_content");
    	viewDiv.innerHTML = ""; 
    	var url = "";
	    if(cursel=="1"){
	    	url = "${KMSS_Parameter_ContextPath}sys/task/sys_task_main/sysTaskMain.do?method=list";
	    	requestUrl = "${KMSS_Parameter_ContextPath}sys/task/sys_task_main/sysTaskMain.do?method=list";
	    }
        if(cursel=="2"){
        	url = "${KMSS_Parameter_ContextPath}sys/task/sys_task_main/sysTaskMain.do?method=list&flag=0";
        	requestUrl = "${KMSS_Parameter_ContextPath}sys/task/sys_task_main/sysTaskMain.do?method=list&flag=0";
	    }
        if(cursel=="3"){
        	url = "${KMSS_Parameter_ContextPath}sys/task/sys_task_main/sysTaskMain.do?method=list&flag=2&fdStatus=3;6";
        	requestUrl = "${KMSS_Parameter_ContextPath}sys/task/sys_task_main/sysTaskMain.do?method=list&flag=2&fdStatus=3";
   	    }
        if(cursel=="4"){
        	url = "${KMSS_Parameter_ContextPath}sys/task/sys_task_main/sysTaskMain.do?method=list&flag=1";
        	requestUrl = "${KMSS_Parameter_ContextPath}sys/task/sys_task_main/sysTaskMain.do?method=list&flag=1";
   	    }
   	    getDataList(url,1);
    	for (var i = 1; i <= n; i++) {
            var menu = document.getElementById(name + i);
            menu.className = i == cursel ? "on" : "";
        }
	};
	function _afterListpage(page,hasData){
		var loadingDiv  = document.getElementById("div_loading");
		var viewDiv = document.getElementById("tab_content");
		var pageDiv = document.getElementById("div_page");
		if(hasData){
			viewDiv.style.display="block";
			loadingDiv.style.display="none";
			if(parseInt(page.pageno)<parseInt(page.pageCount))
				pageDiv.style.display="block";
			else
				pageDiv.style.display="none";
		}else{
			viewDiv.style.display="block";
			pageDiv.style.display="none";
			loadingDiv.style.display="none";
		}
	}
	function getDataList(url,pageno){
		if(pageno==null || parseInt(pageno) < 0) 
			 pageno=1;
		if(window.S_RowSize==""||window.S_RowSize==null)
			window.S_RowSize=6;
		 $.ajax({     
		     type:"post",     
		     url:url,     
		     data:{pageno:pageno,rowsize:window.S_RowSize},    
		     async:true,     
		     success:function(data){
			        var listObj = JSON.parse(data);
		    		var contentDiv= $("#tab_content");
		    		var html = KmsTmpl($("#list_tmpl").html())
							.render( {
								"data" : listObj
							});
					  if(contentDiv.innerHTML==""){
						  contentDiv.html(html);
						}else{
							contentDiv.append(html);
					  }
		    	var page=new Page(listObj["pageCount"],listObj["pageno"],listObj["nextPageStart"]);
		    	window.S_CurPageInfo = page;
		    	_afterListpage(page,true);
		     }
	      });	

    }
	function gotoPage(flag){
		var page=window.S_CurPageInfo;
		var requestPageno=0;
		if(flag=="first")
			requestPageno = 1;
		else if(flag=="prev")
			requestPageno = parseInt(page.pageno)-1;
		else if(flag=="next")
			requestPageno = parseInt(page.pageno)+1;
		else if(flag=="last")
			requestPageno = page.pageCount;
		getDataList(requestUrl,requestPageno);
	}
    </script>
    <script type="text/javascript">
    function successAlert(successStr,type){
    	var _id = "_top_layer_div_success";
    	var domObj = document.getElementById(_id);
    	if(domObj!=null){
    		document.body.removeChild(domObj);
    	}else{
    		domObj = document.createElement("DIV");
    		domObj.id = _id ;
    		domObj.className = "topLayer";
    		var getWidth = function(obj){
    			var widthTmp = obj.offsetWidth;
    			if(widthTmp==null || widthTmp==0)
    				widthTmp = obj.clientWidth?obj.clientWidth:widthTmp;
    			return (widthTmp-domObj.offsetWidth)/2;
    		};

        	if(type == 'finish'){
    		  domObj.innerHTML = "<div class='mui mui-title-finished mui-2x fontFinishedColor innerDiv'></div>"+(successStr==null?"":successStr);
        	}
        	if(type == 'unfinish'){
      		  domObj.innerHTML = "<div class='mui mui-title-finished mui-2x fontOthersColor innerDiv'></div>"+(successStr==null?"":successStr);
          	}
        	if(type == 'att'){
      		  domObj.innerHTML = "<div class='mui mui-title-att mui-2x fontStarOnColor innerDiv'></div>"+(successStr==null?"":successStr);
          	}
        	if(type == 'disAtt'){
      		  domObj.innerHTML = "<div class='mui mui-title-att mui-2x fontOthersColor innerDiv'></div>"+(successStr==null?"":successStr);
          	}

    		document.body.appendChild(domObj);
    		domObj.style.top = (document.body.scrollTop + 150) + "px";
    		domObj.style.left = getWidth(document.body)+"px";
    		setTimeout("successAlert();", 1000);
    	}
    }

       function setStar(obj){
    	   if ($(obj).hasClass('mui-star-on')) {
          	 disAttention(obj);
          } else {
          	 attention(obj);
          	
          }
       }
       function setProgress(obj){
    	   if ($(obj).hasClass('mui-unfinished')) {
    		   progress(obj);
          	   
          } else {
        	  disProgress(obj);
          	
          }
       }
        $(document).ready(function () {
        	setTab('one', 1, 4);
          //新建按钮添加shij
    		$("#div_otherBtn").click(function(){
    			window.open('<c:url value="/sys/task/sys_task_main/sysTaskMain.do" />?method=add','_self');
    		});
        });

        var attLock = false;
      //设为关注
		function attention(obj){
			if(!attLock){
			  attLock = true;
			  $.post('${KMSS_Parameter_ContextPath}sys/task/sys_task_main/sysTaskMain.do?method=updateAttention&fdTaskId='+obj.id,null,
				function(data){
					successAlert("任务已关注","att");
					obj.className = "mui mui-star-on mui-1x fontStarOnColor";
					attLock = false;
				});
			}
		};
		var disAttLock = false;
		//取消关注
		function disAttention(obj){
			if(!disAttLock){
				disAttLock = true;
				$.post('${KMSS_Parameter_ContextPath}sys/task/sys_task_main/sysTaskMain.do?method=updateAttention&isAttention=true&fdTaskId='+obj.id,null,
					function(data){
						successAlert("取消关注","disAtt");
						obj.className = "mui mui-star-off mui-1x fontOthersColor";
						disAttLock = false;
					});
			}
		};

		 var proLock = false;
		//设为已完成
		function progress(obj){
			if(!proLock){
				proLock = true;
				$.post('${KMSS_Parameter_ContextPath}sys/task/sys_task_main/sysTaskMain.do?method=updateFinish&fdTaskId='+obj.id,null,
					function(data){
						successAlert("任务完成","finish");
						obj.className = "mui mui-finished round_1 mui-1x fontFinishedColor";
						document.getElementById(obj.id).innerHTML = "<p style='font-size:12px;text-align: center;color: #4fa041; height: 15px;width: 25px;border: 1px solid;border-radius:3px;display: inline-block;'>完成</p>";
						proLock = false;
				 });
			}
		};

		var disProLock = false;
		//取消完成
		function disProgress(obj){
			if(!disProLock){
				disProLock = true;
				$.post('${KMSS_Parameter_ContextPath}sys/task/sys_task_main/sysTaskMain.do?method=updateUnFinish&fdTaskId='+obj.id,null,
					function(data){
						successAlert("取消完成","unfinish");
						obj.className = "mui mui-unfinished round_1 mui-1x fontOthersColor";
						document.getElementById(obj.id).innerHTML = "<p style='font-size:12px;text-align: center;color: #4fa041; height: 15px;width: 25px;border: 1px solid;border-radius:3px;display: inline-block;'>进行</p>";
						disProLock = false;
				});
			}
		};
    </script>
</head>
<body>
    <div class="contain">
        <c:if test="${KMSS_PDA_ISAPP !='1'}">
			<div class="div_banner">
				<div id="returnDiv" class="div_return" onclick="gotoUrl('<c:url value="/third/pda/index.jsp"/>');">
					<div>
						<bean:message key="phone.banner.homepage" bundle="third-pda"/>
					</div>
					<div></div>
				</div>
			</div>
		</c:if>
        <article style="bottom:0; background-color: #bbbec8;">
           <div class="tab_iframe">
	                <%-- 视图数据部分 --%>
	                <div class="tab_body" id = "tab_body">
	                 <ul id = "tab_content"></ul>
	                </div>
	                 <div id="div_loading" class="div_loading"><bean:message key="phone.list.loading" bundle="third-pda"/></div>
						<%-- 分页显示部分 --%>
						<div id="div_page" class="div_morepage" onclick="gotoPage('next');">
							<bean:message key="phone.list.more" bundle="third-pda"/>
						</div>
                </div>
                <ul class="tab_header">
                    <li class="on" id="one1" onclick="setTab('one', 1, 4)"><p style="font-size:16px;font-weight:bold">All</p></li>
                    <li id="one2" onclick="setTab('one', 2, 4)"><p><i class="mui mui-title-att mui-3x fontlistColor"></i></p></li>
                    <li id="one3" onclick="setTab('one', 3, 4)"><p><i class="mui mui-title-finished mui-3x fontlistColor"></i></p></li>
                    <li id="one4" onclick="setTab('one', 4, 4)"><p><i class="mui mui-title-create mui-3x fontlistColor"></i></p></li>
                </ul>
                <kmss:authShow roles="ROLE_SYSTASK_CREATE">
	                <div class = "mui mui-add mui-4x fontBtnAddColor btn_add" onclick="window.open('<c:url value="/sys/task/sys_task_main/sysTaskMain.do" />?method=add','_self');">
	                </div>
                </kmss:authShow>
           </div>
            
        </article>
    </div>
<script id="list_tmpl" type="text/template">
var docs = data.docs;
if(docs.length>0){
for(var i=0;i<docs.length;i++){
var doc = docs[i];
{$
   <li>
     <div>
$}
if(doc.fdHasAuth=="true"&&doc.fdStatus != '4'&&doc.fdStatus != '5'&&doc.fdStatus != '6'){
if(doc.fdProgress == '0'){
  {$
    <span class="round_2 "><p style="font-size:12px;text-align: center;color: #fdc82e; height: 15px;width: 25px;border: 1px solid;border-radius:3px;display: inline-block;">待启</p></span>
  $}
   }else if(doc.fdProgress == '100'){
{$
    <span class="round_2" id="{%doc.fdId%}"><p style="font-size:12px;text-align: center;color: #4fa041; height: 15px;width: 25px;border: 1px solid;border-radius:3px;display: inline-block;">完成</p></span>
    <span class="mui mui-finished round_1 mui-1x fontFinishedColor" id="{%doc.fdId%}" onclick="setProgress(this);"></span>
$}
   }else{
{$
    <span class="round_2" id="{%doc.fdId%}"><p style="font-size:12px;text-align: center;color: #4fa041; height: 15px;width: 25px;border: 1px solid;border-radius:3px;display: inline-block;">进行</p></span>
    <span class="mui mui-unfinished round_1 mui-1x fontOthersColor" id="{%doc.fdId%}" onclick="setProgress(this);"></span>
$}
  }
}else{
  if(doc.fdStatus == '1'){
{$
   <span class="round_2 "><p style="font-size:12px;text-align: center;color: #fdc82e; height: 15px;width: 25px;border: 1px solid;border-radius:3px;display: inline-block;">待启</p></span>
$}
  }
  if(doc.fdStatus == '2'){
{$
   <span class="round_2"><p style="font-size:12px;text-align: center;color: #4fa041; height: 15px;width: 25px;border: 1px solid;border-radius:3px;display: inline-block;">进行</p></span>
$}
  }
  if(doc.fdStatus == '3'){
{$
   <span class="round_2"><p style="font-size:12px;text-align: center;color: #4fa041; height: 15px;width: 25px;border: 1px solid;border-radius:3px;display: inline-block;">完成</p></span>
$}
  }
  if(doc.fdStatus == '4'){
{$
   <span class="round_2"><p style="font-size:12px;text-align: center;color: #ff8339; height: 15px;width: 25px;border: 1px solid;border-radius:3px;display: inline-block;">暂停</p></span>
$}
  }
  if(doc.fdStatus == '5'){
{$
   <span class="round_2"><p style="font-size:12px;text-align: center;color: #ff8339; height: 15px;width: 25px;border: 1px solid;border-radius:3px;display: inline-block;">驳回</p></span>
$}
  }
  if(doc.fdStatus == '6'){
{$
   <span class="round_2"><p style="font-size:12px;text-align: center;color: #ff8339; height: 15px;width: 25px;border: 1px solid;border-radius:3px;display: inline-block;">结项</p></span>
$}
  }
}
{$
<div onclick="Com_OpenWindow('<c:url value="/sys/task/sys_task_main/sysTaskMain.do" />?method=view&fdId={%doc.fdId%}','_self');">
          <p class="title">{%doc.subject%}
          </p>
          <p class="time">
           {%doc.fdAppointName%}  {%doc.fdPlanCompleteDateTime%}
          </p>
</div>
$}
     if(doc.fdIsAtt){
{$
         <i class="mui mui-star-on mui-1x fontStarOnColor" id="{%doc.fdId%}" onclick="setStar(this);"></i>
$}
      }else{
{$
         <i class="mui mui-star-off mui-1x fontOthersColor" id="{%doc.fdId%}" onclick="setStar(this);"></i> 
$}
    }
{$
      </div>
   </li>
$}
}
}else{
{$ <div style="text-align: center;margin-top: 10px;">暂无数据</div>$}
}
</script>
</body>
</html>
