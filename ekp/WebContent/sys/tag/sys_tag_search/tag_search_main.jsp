<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%> 
<%@ page errorPage="/resource/jsp/jsperror.jsp" %>
<%@ include file="/resource/jsp/htmlhead.jsp" %>
<% response.addHeader("X-UA-Compatible", "IE=5"); %>
<script type="text/javascript">Com_IncludeFile("treeview.js");</script>
<script language="JavaScript">  
Com_IncludeFile("docutil.js|doclist.js|dialog.js|optbar.js|data.js"); 
Com_IncludeFile("tag_search_main.css", "style/"+Com_Parameter.Style+"/tag/"); 
Com_SetWindowTitle('<bean:message bundle="sys-tag" key="sysTag.tree.result" />');
</script>  
<script> 
//打开帮助
function openHelp(){
	 Com_OpenWindow('<c:url value="/sys/tag/sys_tag_search/tag_search_help.jsp"/>',"");
} 
//设置iframe高度
function SetWinHeight(obj)
{
    var win=obj;
    if (document.getElementById)
    {
        if (win && !window.opera)
        {
            if (win.contentDocument && win.contentDocument.body.offsetHeight){ 

                win.height = win.contentDocument.body.offsetHeight; 
                      if(win.height<300){
                    	  win.height =300;
                          }
                  
                }
            else if(win.Document && win.Document.body.scrollHeight)
                win.height = win.Document.body.scrollHeight ;
          
        }
    } 
}

var LKSTree;
Tree_IncludeCSSFile(); 
function generateTree()
{   //生成树
	LKSTree = new TreeView("LKSTree", "<bean:message  bundle="sys-tag" key="sysTagResult.result"/>", document.getElementById("treeDiv"));//搜索结果
	var n1, n2, n3;
	n1 = LKSTree.treeRoot; 
	//按时间
	n2 =n1.AppendChild("<bean:message  bundle="sys-tag" key="sysTagResult.byTime"/>"
	);
	//一天内
	n2.AppendChild(
		"<bean:message key="sysTagResult.day" bundle="sys-tag" />","day",searchByTime,null,null,'CUBECHILD'
	);
	//一周内
	n2.AppendChild(
		"<bean:message key="sysTagResult.week" bundle="sys-tag" />","week",searchByTime,null,null,'CUBECHILD'
	);
	//一年内
	n2.AppendChild(
		"<bean:message key="sysTagResult.year" bundle="sys-tag" />","year",searchByTime,null,null,'CUBECHILD'
	);
	n2.isExpanded = true;
	//按展现	
	n2=n1.AppendChild("<bean:message  bundle="sys-tag" key="sysTagResult.byMode"/>"); 
	//普通视图
	n2.AppendChild(
		"<bean:message  bundle="sys-tag" key="sysTagResult.normal"/>","normal",switchView,null,null,'CUBECHILD'
	);	 
	//立方图
	n2.AppendChild(
			"<bean:message  bundle="sys-tag" key="sysTagResult.cube"/>","cube",switchView,null,null,'CUBECHILD'
	); 
	n2.isExpanded = true;
	n1.CheckFetchChildrenNode();	
	LKSTree.Show();
}
</script>  
<script>
//检测输入内容不许为空
function checkQueryString(obj)
{
 if(obj.value==""){//请输入内容
	alert("<bean:message bundle='sys-tag' key='sysTag.inputContent' />");
	obj.focus();
	return false;
 }
    return true;
}

window.onload=function(){
	var queryType=document.getElementsByName("queryType")[0].value;
	if(queryType==""){
		queryType="normal";
	} 
	var queryString=document.getElementsByName("queryString")[0].value;//搜索内容
	document.getElementById("divNormal").style.display="";//打开普通 
	var  iframeObj=document.getElementById("iframeNormal");//搜索结果页面
	iframeObj.src="<c:url value='/sys/tag/sys_tag_main/sysTagMain.do?method=search&queryType=' />"+queryType+"&queryString="+encodeURIComponent(queryString);
    document.getElementsByName("queryType")[0].value=queryType; 
	 
} 
//切换视图 按时间
function searchByTime(){ 
	var queryType=document.getElementsByName("queryType")[0].value;//搜索类型 
	var queryString=document.getElementsByName("queryString")[0];//搜索内容  
 	if(!checkQueryString(queryString)){//如果搜索内容为空 则不进行搜索
	       return;
 	} 
 	queryString=encodeURIComponent(queryString.value);//中文处理
 	closeFlash("cube");//关闭立方图
	if(this.parameter=="day"){//一天内 
		queryType='day';
	}
	else if(this.parameter=="week"){//一周内 
		queryType='week';
	}
	else if(this.parameter=="year"){//一年内 
		queryType='year';
	}
	document.getElementsByName("queryType")[0].value=queryType;//设置hidden为搜索按钮提交 
	document.getElementById("divCube").style.display="none";//关闭立方
	document.getElementById("divNormal").style.display="";//打开普通
	var  iframeObj=document.getElementById("iframeNormal");//搜索结果页面
	iframeObj.src="<c:url value='/sys/tag/sys_tag_main/sysTagMain.do?method=search&queryType=' />"+queryType+"&queryString="+queryString;
}
 
//切换视图
function switchView(){ 
	var queryType=document.getElementsByName("queryType")[0].value;//搜索类型 
	var queryString=document.getElementsByName("queryString")[0];//搜索内容 
 	if(!checkQueryString(queryString)){//如果搜索内容为空 则不进行搜索
	       return;
 	} 
 	queryString=encodeURIComponent(queryString.value);//中文处理 
	if(this.parameter=="normal"){ //普通视图
	 	queryType='normal';  
	 	closeFlash("cube");//关闭立方图
	 	document.getElementById("divNormal").style.display="";//打开普通
	 	document.getElementById("divCube").style.display="none";//关闭立方
	 	var  iframeObj=document.getElementById("iframeNormal");//搜索结果页面
		iframeObj.src="<c:url value='/sys/tag/sys_tag_main/sysTagMain.do?method=search&queryType=' />"+queryType+"&queryString="+queryString ;  
	}
	else if(this.parameter=="cube") {//标签立方 		
		queryType='cube';
		document.getElementsByName("queryType")[0].value=queryType;//设置hidden为搜索按钮提交 
		openFlash();//打开立方图 
 } 
	document.getElementsByName("queryType")[0].value=queryType;//设置hidden为搜索按钮提交 
}   

//搜索按钮提交
function CommitSearch(){
	var queryType=document.getElementsByName("queryType")[0].value;//搜索类型 
	var queryString=document.getElementsByName("queryString")[0];//搜索内容 
 	if(!checkQueryString(queryString)){//如果搜索内容为空 则不进行搜索
	       return;
 	} 
 	queryString=encodeURIComponent(queryString.value);//中文处理
 	if(queryType=="day"||queryType=="week"||queryType=="year"||queryType=="normal"){ 
	 	var  iframeObj=document.getElementById("iframeNormal");//搜索结果页面
		iframeObj.src="<c:url value='/sys/tag/sys_tag_main/sysTagMain.do?method=searchByCube&queryType=' />"+queryType+"&queryString="+queryString ; 
 	}
 	else if(queryType=="cube"){ 
		var url="sysTagCubXMLService&queryString="+queryString+"&queryType=cube";  
		var data = new KMSSData();
		data.SendToBean(url,Tag_rtnData_a); 	
 	}
 	
}

//初始化FLASH对象
function Tag_GetFlashHtml2(){ 
	var rand = getRand();
	var obj="<object id='TagApplication_SWFObjectName'";
  	obj+="name='TagApplication_SWFObjectName' " ;
  	obj+="classid='clsid:D27CDB6E-AE6D-11cf-96B8-444553540000'";
  	obj+="width='100%' height='100%' >";
  	obj+="<param name='movie' value='<c:url value='/sys/tag/sys_tag_search/TagCubeApp.swf" + "?rand=" + rand +"'/>";
  	obj+="<param name='quality' value='high' />";
  	obj+="<param name='wmode' value='opaque' /></object>";  
  	return obj;  
} 

//获取随机数
function getRand(){
	var Num=Math.floor(Math.random()*1000000);
	return Num;
}

function isIE(){ //ie?
		   if (window.navigator.userAgent.toLowerCase().indexOf("msie")>=1)
		    return true;
		   else
		    return false;
		}

function Tag_GetFlashHtml(){ 
	var obj = "";
	var rand = getRand();
	if(isIE()){
		obj="<object id='TagApplication_SWFObjectName'";
	  	obj+="name='TagApplication_SWFObjectName' " ;
	  	obj+="classid='clsid:D27CDB6E-AE6D-11cf-96B8-444553540000'";
	  	obj+="width='100%' height='100%' >";
	  	obj+="<param name='movie' value='<c:url value='/sys/tag/sys_tag_search/TagCubeApp.swf" + "?rand=" + rand +"'/>";
	  	obj+="<param name='quality' value='high' />";
	  	obj+="<param name='wmode' value='opaque' /></object>";  
	}else {
		obj="<object ";
	  	obj+="name='TagApplication_SWFObjectName' " ;
	  	obj+="classid='clsid:D27CDB6E-AE6D-11cf-96B8-444553540000'";
	  	obj+="width='100%' height='100%' >";
	  	obj+="<param name='movie' value='<c:url value='/sys/tag/sys_tag_search/TagCubeApp.swf" + "?rand=" + rand +"'/>";
	  	obj+="<param name='quality' value='high' />";
	  	obj+="<param name='wmode' value='opaque' />";
	  	obj+="<embed"; 
	  	obj+=" id=\"TagApplication_SWFObjectName\" ";
	  		obj+="	name=\"TagApplication_SWFObjectName\" ";
	  		obj+="		src=\"<c:url value='/sys/tag/sys_tag_search/TagCubeApp.swf?rand="+rand+"'/>\" ";
	  		obj+="		wmode=\"opaque\" ";
	  		obj+="		quality=\"high\"  ";
	  		obj+="		pluginspage=\"http://www.macromedia.com/go/getflashplayer\"  ";
	  		obj+="		type=\"application/x-shockwave-flash\"  ";
	  		obj+="		style=\"width: 100%; height: 100%\"> ";
	  		obj+="	</embed> ";
	  			obj+="  	</object>";  
	}
  	return obj;  
} 



//初始化FLASH
function TagCube_initComplete() {  
	var flash = document.getElementById('TagApplication_SWFObjectName');//获取对象 	
	flash.TagCube_setBaseRadiusToAS(500,500);//设置大小   
	flash.TagCube_setTagDataToAS(xml); 
	 
} 

//FLASH放大
function TagCube_bigSize(){
	$("cube").style.height ="80%";
	$("cube").style.width ="86%";
}
//FLASH缩小
function TagCube_smallSize(){ 
	    var newDivWidth = 300;
	    var  newDivHeight = 300;
	    $("cube").style.width = newDivWidth + "px";
	    $("cube").style.height = newDivHeight + "px"; 
	    var leftTree=document.getElementById("leftTree");
		var lfTrWh=0+"px";
		var lfTrHt=0+"px"; 
		lfTrWh=leftTree.offsetWidth;
		lfTrHt=leftTree.offsetHeight; 
		$("cube").style.top = document.body.clientHeight/2 +lfTrHt+5;
		$("cube").style.left = "6.8%";
} 

//判断对象是否存在
var docEle = function() {
    return $(arguments[0]) || false;
}
//返回对象
function $(id){
	return document.getElementById(id);
}
//关闭层
function closeFlash(_id){ 
	 if(docEle(_id)){
		 document.getElementById("cube").style.display="none"; 
	} 
} 

//创建层
function Tag_createNewDIV(){ 
		
		var objFlash=Tag_GetFlashHtml();    
	    var newDiv = document.createElement("div");
	    newDiv.id = "cube";
	    newDiv.style.position = "absolute";
	    newDiv.style.zIndex = "9999";
	    var newDivWidth = 300;
	    var  newDivHeight = 300;
	    newDiv.style.width = newDivWidth + "px";
	    newDiv.style.height = newDivHeight + "px"; 
	    var leftTree=document.getElementById("leftTree");
		var lfTrWh=0+"px";
		var lfTrHt=0+"px"; 
		lfTrWh=leftTree.offsetWidth;
		lfTrHt=leftTree.offsetHeight; 
	    newDiv.style.top =(document.body.scrollTop + document.body.clientHeight/2 +lfTrHt+5);
	    newDiv.style.left = "6.8%";
	    newDiv.style.background = "#EBF2F8";
	    newDiv.style.border = "1px solid #D3E8F2";
	    newDiv.style.padding = "5px";
	    newDiv.style.overflow = "auto"; 
	    document.body.appendChild(newDiv); 
	    newDiv.innerHTML = objFlash; 
	
}

//点击FLASH搜索
function TagCube_requestDataByID(_queryString) {
	Com_SetWindowTitle('<bean:message bundle="sys-tag" key="sysTag.tree.result" />');
	xml = "";
	var queryString=_queryString; 
	document.getElementsByName("queryString")[0].value=_queryString;//搜索内容 
	var url="sysTagCubXMLService&queryString="+encodeURI(queryString)+"&queryType=cube";  
	var data = new KMSSData();
	data.SendToBean(url,Tag_rtnData_a); 	
	var queryType=document.getElementsByName("queryType")[0].value
	//var  iframeObj=document.getElementById("iframeCube");//搜索结果页面
	//iframeObj.src="<c:url value='/sys/tag/sys_tag_main/sysTagMain.do?method=search&queryType=' />"+queryType+"&queryString="+encodeURI(queryString) ;	 
}

//弹出层
function openFlash() { 
	 xml="";
	 var data = new KMSSData();
	 var queryString=document.getElementsByName("queryString")[0];//搜索内容 
	 var url="sysTagCubXMLService&queryString="+encodeURIComponent(queryString.value)+"&queryType=cube";
	 if(!docEle("cube")){//判断是否已经含有层 
		 data.SendToBean(url,Tag_rtnData); 
	 }
	 else {//如果有则打开重新发送
		 document.getElementById("cube").style.display="";
		 data.SendToBean(url,Tag_rtnData_a);  
	 } 
} 

var tagName="";
var xml=""; 
function Tag_rtnData(rtnData){  
	if(rtnData.GetHashMapArray().length >= 1){ 
     		var obj = rtnData.GetHashMapArray()[0]; 
     		tagName=obj['tagName'];
     		xml=obj['xml'];  
     		if(tagName==null||tagName==""){
     			Tag_resultNormal("normal");
     			 return;
     	    }  
     	    
     		Tag_resultCube("cube");
     		Tag_createNewDIV(); 
     		//中间部分加载8个关联 
       		Tag_rtnRelaTag(tagName); 
     }  
}  

//点击flash重新获取xml
function Tag_rtnData_a(rtnData){  
	if(rtnData.GetHashMapArray().length >= 1){ 
     		var obj = rtnData.GetHashMapArray()[0]; 
     		tagName=obj['tagName'];
     		xml=obj['xml']; 
   			if(!docEle("TagApplication_SWFObjectName")){
   				Tag_createNewDIV();
   	   	    }
   			else {
     			TagCube_initComplete();
   			}
   			if(tagName==null||tagName==""){
   				Tag_resultNormal("normal");
   	   		}
   			else {
   				Tag_resultCubeRepet("cube");
   	   		} 
    		
   		    //中间部分更新8个关联     		    
   		     Tag_rtnRelaTag(tagName);
   	   	   	 
   		    		 
     }  
}  

//加载8个关联 
function Tag_rtnRelaTag(tagName){
	var htmlContent=""; 
	if(tagName==null||tagName==""){
	 htmlContent="";
	 document.getElementById("divCubeRela").innerHTML=htmlContent;
	  return ;
	}
	var tag=tagName.split(";");
	var len=tag.length;
	if(len>=9){
		len=8;
	}
	htmlContent="<table width='80%'  id='relaTable' class='font_blue' style='margin-top:15px'>";
	for(var i=0;i<len;i++){ 
		var tagValue=tag[i];
		htmlContent+="<tr>";
		htmlContent+="<td width='90%' height='20' >";
		htmlContent+="<a href=#   onclick=searchTag('"+tagValue+"') >"; 
		htmlContent+=tagValue;
		htmlContent+="</a>";
		htmlContent+="</td>";
		htmlContent+="<td width='10%' height='20'>";
		htmlContent+="<IMG  src=' ${KMSS_Parameter_StylePath}tag/cube_openTag.gif ' ";
		htmlContent+=" alt='<bean:message key='sysTagResult.add' bundle='sys-tag' />' "; 
	    htmlContent+=" onclick=addSearch('"+tagValue+"') />";  
		htmlContent+="</td>";
		htmlContent+="</tr>"; 
	}
	htmlContent+="</table>";
	document.getElementById("divCubeRela").innerHTML=htmlContent;
	
}
</script> 
<script language="JavaScript"> 
    //添加选项
	function addSearch(tag){
		var queryString=document.getElementsByName('queryString')[0].value;
		var queryStrings= queryString.split(" ");
		var flag=false;
		for(var i=0;i<queryStrings.length;i++){
			if(queryStrings[i]==tag){
				flag=true;//避免多次添加
			}
		}
		
		if(!flag){
			document.getElementsByName('queryString')[0].value=queryString+" "+tag;
			queryString=document.getElementsByName('queryString')[0].value;
			TagCube_requestDataByID(queryString);//立方改变
			var iframeObj=document.getElementById("iframeCube");
			var queryType="cube";//类型为立方
			queryString=encodeURIComponent(queryString);//中文处理 
			iframeObj.src="<c:url value='/sys/tag/sys_tag_main/sysTagMain.do?method=searchByCube&queryType=' />"+queryType+"&queryString="+queryString ;
		}
		
		
	}
	//搜索
	function searchTag(tag){  
		var queryString=tag;
		document.getElementsByName('queryString')[0].value=tag;
		var iframeObj=document.getElementById("iframeCube");
		var queryType="cube";//类型为立方
		TagCube_requestDataByID(queryString);//立方改变
	}

	//跳转到立方视图页面
	function Tag_resultCube(queryType){
	    var queryString=document.getElementsByName('queryString')[0].value;
		queryString=encodeURIComponent(queryString);//中文处理
		queryType="cube";
		document.getElementById("divNormal").style.display="none";//关闭普通
		document.getElementById("divCube").style.display="";//打开立方		
		var  iframeObj=document.getElementById("iframeCube");//搜索结果页面		
		iframeObj.src="<c:url value='/sys/tag/sys_tag_main/sysTagMain.do?method=search&queryType=' />"+queryType+"&queryString="+queryString ;
	}
	
	function Tag_resultCubeRepet(queryType){
	    var queryString=document.getElementsByName('queryString')[0].value;
		queryString=encodeURIComponent(queryString);//中文处理
		queryType="cube";
		document.getElementById("divNormal").style.display="none";//关闭普通
		document.getElementById("divCube").style.display="";//打开立方		
		var  iframeObj=document.getElementById("iframeCube");//搜索结果页面		
		iframeObj.src="<c:url value='/sys/tag/sys_tag_main/sysTagMain.do?method=searchByCube&queryType=' />"+queryType+"&queryString="+queryString ;
	}
	
	//跳转到普通视图
	function Tag_resultNormal(queryType){
		var queryString=document.getElementsByName('queryString')[0].value;
		queryString=encodeURIComponent(queryString);//中文处理
		queryType="normal";
	 	document.getElementById("divNormal").style.display="";//打开普通
	 	document.getElementById("divCube").style.display="none";//关闭立方
	 	var  iframeObj=document.getElementById("iframeNormal");//搜索结果页面
		iframeObj.src="<c:url value='/sys/tag/sys_tag_main/sysTagMain.do?method=search&queryType=' />"+queryType+"&queryString="+queryString ;

	}
</script>
<body style="margin:0;padding:0;"> 
<center>
<DIV class="frame_size" style="min-height: 750px;">
<%--顶部--%>
<DIV style="width:100%">
<DIV  style="FILTER: progid:DXImageTransform.Microsoft.Gradient(gradientType=0,startColorStr=#DBE8FA,endColorStr=#ffffff);width: 100%;margin-top: -22px;">
<DIV  class="mtop">  
<table  width="95%"  border=0  style="text-align: right">
		<tr>
			<td style="width: 19%" ><img src='${KMSS_Parameter_StylePath}tag/glass.gif'> &nbsp;&nbsp;</td>
			<td align="center" style="width: 62%"> 
			    <input type='hidden' name="queryType"  /> 
				<input type='text' name="queryString" style="width:100%" id="q5" class="searchInput inputsgl" value="${param.queryString}"
				 onkeydown="if (event.keyCode == 13 && this.value !='') CommitSearch();"/>			 
			 </td>
			<%--搜索--%> 
			<td style="width:80px;" > 			
			<DIV  class="tab"> 
	 				<a href="javascript:void(0);" title="<bean:message bundle="sys-tag" key="sysTagResult.search" />" onclick="CommitSearch()" >
	 				<span>
	 				<bean:message bundle="sys-tag" key="sysTagResult.search" /></span>
	 				</a>  
	 			</DIV>
	 		</td>
			<td style="width:100px;" >
		 	<%--帮助--%> 
				<DIV  class="tab"> 
	 				<a href="javascript:void(0);" title="<bean:message bundle="sys-tag" key="sysTagResult.help" />" onclick="openHelp()" >
	 				<span>
	 				<img src="${KMSS_Parameter_StylePath}tag/help.gif" style="float: left;margin-right: 3px;" />
	 				<bean:message bundle="sys-tag" key="sysTagResult.help" />
	 				</span>
	 				</a>  
	 			</DIV> 
			</td>
			<td width="*"></td>
		</tr> 
</table> 
</DIV> 
</DIV>  
</DIV><%------顶部结束----%>  

<DIV style="width:100%">
<%----搜索开始---%>
<%--树开始--%>
<DIV   style="width: 18%;float: left;">
<%--蓝条--%>
<DIV class='strip' >
</DIV>
<DIV>
<%--左边树--%> 
<table class="mt15" width="100%"  >
<tr>
	<td>
		<div id=treeDiv></div>
	</td>
</tr>
</table> 
<script>generateTree();</script>
</DIV>
<DIV id='leftTree'>&nbsp;</DIV>
</DIV> 
<%--树结束--%>

<%--搜索开始---%>
<DIV style="width: 82%;float: left;clear:right;">
<%--普通搜索结果--%>
<DIV   id='divNormal' style="display: none">
<iframe  id='iframeNormal'  style="margin:0;padding:0;" width=100% height=100%  frameborder=0 scrolling=no marginheight="0"  onload="Javascript:SetWinHeight(this)"   >
</iframe> 
</DIV> 

<%---立方开始--%> 
<DIV  id='divCube' style="display: none"> 
<DIV style="width: 20%;float: left"> 
<%--背景蓝条开始--%>
<DIV style="background:#f5f7fc;BORDER-BOTTOM: #BCD4ED 1px solid;border-top: #BCD4ED 1px solid;height: 40">
</DIV>
<%--背景蓝条结束--%>
<%---background:blue;
立方关联 --%>
<DIV id='divCubeRela' style="BORDER-LEFT: #BCD4ED 1px solid;height: 210;text-align: center;VERTICAL-ALIGN:middle;text-align: center">
</DIV>   
</DIV> 

<%---立方搜索结果--%>
<DIV style="width: 80%;float: right;">
<iframe  id='iframeCube'  width=100% height=100%  frameborder=0 scrolling=no marginheight="0"  onload="Javascript:SetWinHeight(this)"   >
</iframe>  
</DIV>
</DIV><%---立方结束--%> 
</DIV><%--搜索结束---%>
</DIV>
</DIV>
<%---最外框---%>
</center> 
</body>  
 