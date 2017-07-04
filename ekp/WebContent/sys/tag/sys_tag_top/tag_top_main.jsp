<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page errorPage="/resource/jsp/jsperror.jsp"%>
<%@ include file="/resource/jsp/htmlhead.jsp"%>
<script language="JavaScript">
 Com_IncludeFile("tag_top_main.css", "style/"+Com_Parameter.Style+"/tag/");
 Com_IncludeFile("data.js");
 Com_IncludeFile("jquery.js");
 Com_SetWindowTitle('<bean:message bundle="sys-tag" key="sysTag.tree.result" />');
</script>
<script>
//设置iframe高度
function SetWinHeight(obj)
{
    var win=obj;
    if (document.getElementById)
    {
        if (win && !window.opera)
        {
            if (win.contentDocument && win.contentDocument.body.offsetHeight) 
                win.height = win.contentDocument.body.offsetHeight ; 
            else if(win.Document && win.Document.body.scrollHeight)
                win.height = win.Document.body.scrollHeight ;
        }
    } 
}
</script> 
<script>
function onClickTag(tagName,obj){
	var href = "<c:url value='/sys/tag/sys_tag_main/sysTagMain.do?method=searchMain'/>";
	//href=href+"&queryString="+encodeURI(tagName)+"&queryType=normal";
	//href=href+"&queryString="+encodeURIComponent(tagName)+"&queryType=normal";
	//window.open(href,"_blank");
	Com_OpenWindow("<c:url value='/sys/ftsearch/searchBuilder.do?method=search&queryString="+encodeURIComponent(tagName)+"&searchFields=tag&isSearchByButton=true&newLUI=true&facetClickPara=false&outModel=&modelGroupChecked='/>,'_blank'");
}

function openRela(e,tagId,obj){
	var kmssData = new KMSSData();
	kmssData.AddBeanData("sysTagTagsAliasService&tagId="+tagId);
	var valueData = kmssData.GetHashMapArray();	
	var aliasDiv_b = document.getElementById("alias_tag_id_b");
	e = e||window.event;
	x = e.clientX; 
	y = e.clientY;
	if(valueData.length > 0){
		aliasDiv_b.innerHTML = "";
		var str = "" 
		for(var i = 0; i < valueData.length; i++){	
		// var li,a,txtNode;
		// li = document.createElement("<li>");
			 var text  = valueData[i]["text"];
			 var text = "'"+text+"'";
		//	 a = document.createElement("<a href=\"#\" onclick=\"onClickTag("+text+",this)>");			 
		//	 txtNode = document.createTextNode(valueData[i]["text"]);
		//	 a.appendChild(txtNode);			
		//	 li.appendChild(a);
		//	 aliasDiv_b.appendChild(li);		
			 str += "<li><a href='#' onclick=\"onClickTag("+text+",this)\">"+valueData[i]['text']+"</a></li>" ;	 
		}
		aliasDiv_b.innerHTML = str ;
	}else{
		aliasDiv_b.innerHTML = "<bean:message bundle='sys-tag' key='sysTagTop.norecord' />";
	}
	var aliasDiv = document.getElementById("alias_tag_id");
	$("#alias_tag_id").css("display","") ;
	$("#alias_tag_id").css("top",e.clientY+document.body.scrollTop-20) ;
	$("#alias_tag_id").css("left",e.clientX+document.body.scrollLeft) ;
//	aliasDiv.style.top=e.clientY+document.body.scrollTop-20;
///	aliasDiv.style.left=e.clientX+document.body.scrollLeft;
//	aliasDiv.style.display="";		
}
function closeRela(){
	var aliasDiv = document.getElementById("alias_tag_id");
	aliasDiv.style.display="none";
}
function test() {
    var outer = document.getElementById("alias_tag_id");
    var e = window.event ? window.event : arguments[0];
    var x = e.clientX;
    var y = e.clientY;
    var x1 = outer.offsetLeft;
    var y1 = outer.offsetTop;
    var x2 = x1 + outer.offsetWidth;
    var y2 = y1 + outer.offsetHeight;
    if (x1 < x && x < x2 && y1 < y && y < y2) return false;
    closeRela();
}
window.onload = function() {
	if(!Com_Parameter.IE){   
		document.getElementById("alias_tag_id").onmouseout = test;  
	}
};
</script>
<script>
function changePage(mode){
	var  rank=document.getElementById("rank");
	var  cloud=document.getElementById("cloud");
	var  searchList=document.getElementById("searchList");
	var  searchCloud=document.getElementById("searchCloud");
	//排行榜
	if(mode=='rank'){
		rank.className="tabs"; 
		cloud.className="tabs_2";
		searchCloud.style.display="none";
		searchList.style.display="";
	}
	else if(mode=='cloud'){//标签云图 
		rank.className="tabs_2"; 
		cloud.className="tabs";
		searchCloud.style.display="";
		searchList.style.display="none";
		var  iframeCloud=document.getElementById("iframeCloud");
		iframeCloud.src="<c:url value='/sys/tag/sys_tag_top_log/sysTagTopLog.do?method=searchCloud'/>";
	}  
}

</script>
<script>
//打开更多分类
var opens=false; 
function openMore(){
	var moreCategory=document.getElementById("moreCategory");
	var moreImg=document.getElementById("moreImg");
	if(!opens){ 
		moreCategory.style.display="";
		moreImg.src='${KMSS_Parameter_StylePath}tag/back.gif';
		opens=true;
  }
	else if(opens){
		moreCategory.style.display="none";
		moreImg.src='${KMSS_Parameter_StylePath}tag/more.gif';
		opens=false;
	}
}

</script>
<style>
.div_top {	
	margin-top:10px;
	padding-left:0.2%;
	*padding-left:5%;
	width: 24.7%;
	/*height: 300px;*/
	float: left;
	/*clear: right ;*/
	 
}

.div_header {
	width: 100%;
	height: 35px;
	float: right;
	/*clear: right;*/
}

.div_a {
	width: 100%;
	/*margin-top: 35px;*/
	height: 300px;
	float: left;
	border-right: #eaebef 1px solid;
	border-left: #eaebef 1px solid;
	border-bottom: #eaebef 1px solid;
	/*clear: right;*/
	
}

.div_table {
	width: 100%;
	height: 100%;
	padding: 0px, 0px, 0px, 0px;
}

td {
	margin: 0;
	color: #858786;
	padding: 0;
}
a {
	text-decoration :none;
	color: #4F7BA7
}
a span {
	font-size:13px;
	color: #4F7BA7
}
span.span-a{
	font-size:13px;
}
#alias_tag_id {
	width:98px;
	height:142px;	
	font-size:12px;
	position:absolute;
	background-image:url('${KMSS_Parameter_StylePath}tag/tag_pop_alias.png')
}
.nbsp{
	float:left;
	clear: right;
	width:5%
}
</style>
</head>
<body>
<center>
<DIV class="frame_size" style="min-height: 820px;"><%--顶部--%>
<DIV>
	<c:import
		url="/sys/tag/sys_tag_top_log/sysTagTopLog.do?method=searchHead"
		charEncoding="UTF-8">
</c:import></DIV>

<%--按钮--%>
<DIV class='bt'
	style="background: #f5f7fc; width: 100%; BORDER-BOTTOM: #BCD4ED 1px solid; border-top: #BCD4ED 1px solid;float:left;">
<DIV id='tabButton' style="float: left; margin-left: -4%">
<ul style="float: left;">
	<li style="float: left; width: 115;">
	<div id="rank" class='tabs'><a href="#" 
		onclick='changePage("rank")'><span><bean:message  bundle="sys-tag" key="sysTagTop.button.rank"/></span></a></div>
	</li>
	<li style="float: left; width: 115">
	<div id="cloud" class='tabs_2' style="float: right"><a href="#"
		 onclick='changePage("cloud")'><span><bean:message  bundle="sys-tag" key="sysTagTop.button.cloud"/></span></a>
	</div>
	</li>
</ul>
</DIV>
</DIV>
<%--排行--%>
<DIV id='searchList' style="width: 100%;">
<DIV style="width: 100%;">
<!-- 最新标签TOP10 -->
<DIV class="div_top">
<DIV class="div_header">
<table class="div_table" cellpaing=0 cellspacing=0>
	<tr>
		<td width="8%" height="35"
			style="text-align: right;background-image: url('${KMSS_Parameter_StylePath}tag/title_center.jpg');background-repeat:no-repeat )">
		<img src='${KMSS_Parameter_StylePath}tag/title_leftdot.jpg'
			width="100%" height="100%" /></td>
		<td width="85%" height="35"
			style="background-image: url('${KMSS_Parameter_StylePath}tag/title_center.jpg')">
		&nbsp;&nbsp;&nbsp;<span
			style="font-size: 15px; font: bold; color: #80A4B0"><bean:message  bundle="sys-tag" key="sysTagTop.new"/></span></td>
		<td width="5%" height="35" style="text-align: right"><img
			src='${KMSS_Parameter_StylePath}tag/title_right.jpg' width="100%"
			height="100%" /></td>
	</tr>
</table>
</DIV>
<DIV class="div_a">
<table cellpadding="0" cellspacing="0" width="100%"
	style="text-align: left; color: #858786">
	<tr>
		<td height="10" width="5%"
			style="background-image: url('${KMSS_Parameter_StylePath}tag/title_rela.gif')"><img
			src='${KMSS_Parameter_StylePath}tag/title_rela.gif' /></td>
		<td width="15%"
			style="background-image: url('${KMSS_Parameter_StylePath}tag/title_rela.gif')"><span
			style="font-size: 13px; vertical-align: bottom"><bean:message  bundle="sys-tag" key="sysTagTop.rank"/></span></td>
		<td height="5%" width="10"
			style="background-image: url('${KMSS_Parameter_StylePath}tag/title_rela.gif')"></td>
		<td width="60%"
			style="background-image: url('${KMSS_Parameter_StylePath}tag/title_rela.gif')"><span
			style="font-size: 13px; vertical-align: bottom"><bean:message  bundle="sys-tag" key="sysTagTop.key"/></span></td>
		<td width="15%"
			style="background-image: url('${KMSS_Parameter_StylePath}tag/title_rela.gif')"><span
			style="font-size: 13px; vertical-align: bottom"><bean:message  bundle="sys-tag" key="sysTagTop.relation"/></span></td>
	</tr>
	<tr>
		<td colspan="5" height="10px"></td>
	</tr>
	<c:forEach items="${topFirstList}" var="sysTagTags" varStatus="vstatus">
		<tr>
		<td height="25"></td>
		<td><span class="span-a">${vstatus.index+1}</span></td>
		<td><kmss:showTagTrend trendValue=""/></td>
		<td><a href="#" onclick="onClickTag('${sysTagTags.fdName}',this);"><span><c:out value="${sysTagTags.fdName}"/></span></a></td>
		<td><kmss:showTagAliasImg aliasStatus="${sysTagTags.fdContainAlias}" htmlElementProperties="onclick=\"openRela(event,'${sysTagTags.fdId}',this)\""/></td>
		</tr>
	</c:forEach>
</table>
</DIV>
</DIV>
<!-- 昨日最热TOP10 -->
<DIV class="div_top">
<DIV class="div_header">
<table class="div_table" cellpaing=0 cellspacing=0>
	<tr>
		<td width="8%" height="35"
			style="text-align: right;background-image: url('${KMSS_Parameter_StylePath}tag/title_center.jpg');background-repeat:no-repeat )">
		<img src='${KMSS_Parameter_StylePath}tag/title_leftdot.jpg'
			width="100%" height="100%" /></td>
		<td width="85%" height="35"
			style="background-image: url('${KMSS_Parameter_StylePath}tag/title_center.jpg')">
		&nbsp;&nbsp;&nbsp;<span
			style="font-size: 15px; font: bold; color: #80A4B0"><bean:message  bundle="sys-tag" key="sysTagTop.hot.yesterday"/>${category}</span></td>
		<td width="5%" height="35" style="text-align: right">
		<img src='${KMSS_Parameter_StylePath}tag/title_right.jpg' width="100%"
			height="100%" /></td>
	</tr>
</table>
</DIV>
<DIV class="div_a">
<table cellpadding="0" cellspacing="0" width="100%"
	style="text-align: left; color: #858786">
	<tr>
		<td height="10" width="5%"
			style="background-image: url('${KMSS_Parameter_StylePath}tag/title_rela.gif')"><img
			src='${KMSS_Parameter_StylePath}tag/title_rela.gif' /></td>
		<td width="15%"
			style="background-image: url('${KMSS_Parameter_StylePath}tag/title_rela.gif')"><span
			style="font-size: 13px; vertical-align: bottom"><bean:message  bundle="sys-tag" key="sysTagTop.rank"/></span></td>
		<td height="5%" width="10"
			style="background-image: url('${KMSS_Parameter_StylePath}tag/title_rela.gif')"></td>
		<td width="60%"
			style="background-image: url('${KMSS_Parameter_StylePath}tag/title_rela.gif')"><span
			style="font-size: 13px; vertical-align: bottom"><bean:message  bundle="sys-tag" key="sysTagTop.key"/></span></td>
		<td width="15%"
			style="background-image: url('${KMSS_Parameter_StylePath}tag/title_rela.gif')"><span
			style="font-size: 13px; vertical-align: bottom"><bean:message  bundle="sys-tag" key="sysTagTop.relation"/></span></td>
	</tr>
	<tr>
		<td colspan="5" height="10px"></td>
	</tr>
	<c:forEach items="${topSecondList}" var="sysTagTopLog" varStatus="vstatus">
		<tr>
		<td height="25"></td>
		<td><span class="span-a">${vstatus.index+1}</span></td>
		<td><kmss:showTagTrend trendValue="${sysTagTopLog.fdTrend}"/></td>
		<td><a onclick="onClickTag('${sysTagTopLog.fdSysTagTags.fdName}',this);" href="#" ><span><c:out value="${sysTagTopLog.fdSysTagTags.fdName}"/></span></a></td>
		<td><kmss:showTagAliasImg aliasStatus="${sysTagTopLog.fdSysTagTags.fdContainAlias}" htmlElementProperties="onclick=\"openRela(event,'${sysTagTopLog.fdSysTagTags.fdId}',this)\""/></td>
		<%--<img src='${KMSS_Parameter_StylePath}tag/title_file.jpg' border="1" style="border-color: #CACCCB" onclick="openRela(event,'${sysTagTopLog.fdSysTagTags.fdId}',this)"/>--%>
		</tr>
	</c:forEach>
</table>
</DIV>
</DIV>
<!-- 7天内最热TOP10 -->
<DIV class="div_top">
<DIV class="div_header">
<table class="div_table" cellpaing=0 cellspacing=0>
	<tr>
		<td width="8%" height="35"
			style="text-align: right;background-image: url('${KMSS_Parameter_StylePath}tag/title_center.jpg');background-repeat:no-repeat )">
		<img src='${KMSS_Parameter_StylePath}tag/title_leftdot.jpg'
			width="100%" height="100%" /></td>
		<td width="85%" height="35"
			style="background-image: url('${KMSS_Parameter_StylePath}tag/title_center.jpg')">
		&nbsp;&nbsp;&nbsp;<span
			style="font-size: 15px; font: bold; color: #80A4B0"><bean:message  bundle="sys-tag" key="sysTagTop.hot.week"/>${category}</span></td>
		<td width="5%" height="35" style="text-align: right"><img
			src='${KMSS_Parameter_StylePath}tag/title_right.jpg' width="100%"
			height="100%" /></td>
	</tr>
</table>
</DIV>
<DIV class="div_a">
<table cellpadding="0" cellspacing="0" width="100%"
	style="text-align: left; color: #858786">
	<tr>
		<td height="10" width="5%"
			style="background-image: url('${KMSS_Parameter_StylePath}tag/title_rela.gif')"><img
			src='${KMSS_Parameter_StylePath}tag/title_rela.gif' /></td>
		<td width="15%"
			style="background-image: url('${KMSS_Parameter_StylePath}tag/title_rela.gif')"><span
			style="font-size: 13px; vertical-align: bottom"><bean:message  bundle="sys-tag" key="sysTagTop.rank"/></span></td>
		<td height="5%" width="10"
			style="background-image: url('${KMSS_Parameter_StylePath}tag/title_rela.gif')"></td>
		<td width="60%"
			style="background-image: url('${KMSS_Parameter_StylePath}tag/title_rela.gif')"><span
			style="font-size: 13px; vertical-align: bottom"><bean:message  bundle="sys-tag" key="sysTagTop.key"/></span></td>
		<td width="15%"
			style="background-image: url('${KMSS_Parameter_StylePath}tag/title_rela.gif')"><span
			style="font-size: 13px; vertical-align: bottom"><bean:message  bundle="sys-tag" key="sysTagTop.relation"/></span></td>
	</tr>
	<tr>
		<td colspan="5" height="10px"></td>
	</tr>
	<c:forEach items="${topThirdList}" var="sysTagTopLog" varStatus="vstatus">
		<tr>
		<td height="25"></td>
		<td><span class="span-a">${vstatus.index+1}</span></td>
		<td><kmss:showTagTrend trendValue="${sysTagTopLog.fdTrend}"/></td>
		<td><a href="#" onclick="onClickTag('${sysTagTopLog.fdSysTagTags.fdName}',this);"><span><c:out value="${sysTagTopLog.fdSysTagTags.fdName}"/></span></a></td>
		<td><kmss:showTagAliasImg aliasStatus="${sysTagTopLog.fdSysTagTags.fdContainAlias}" htmlElementProperties="onclick=\"openRela(event,'${sysTagTopLog.fdSysTagTags.fdId}',this)\""/></td>
		</tr>
	</c:forEach>
</table>
</DIV>
</DIV>

<!-- 热门搜索 -->
<DIV class="div_top">
<DIV class="div_header">
<table class="div_table" cellpaing=0 cellspacing=0>
	<tr>
		<td width="8%" height="35"
			style="text-align: right;background-image: url('${KMSS_Parameter_StylePath}tag/title_center.jpg');background-repeat:no-repeat )">
		<img src='${KMSS_Parameter_StylePath}tag/title_leftdot.jpg'
			width="100%" height="100%" /></td>
		<td width="85%" height="35"
			style="background-image: url('${KMSS_Parameter_StylePath}tag/title_center.jpg')">
		&nbsp;&nbsp;&nbsp;<span
			style="font-size: 15px; font: bold; color: #80A4B0"><bean:message  bundle="sys-tag" key="sysTagTop.hot.search"/>${category}</span></td>
		<td width="5%" height="35" style="text-align: right"><img
			src='${KMSS_Parameter_StylePath}tag/title_right.jpg' width="100%"
			height="100%" /></td>
	</tr>
</table>
</DIV>
<DIV class="div_a">
<table cellpadding="0" cellspacing="0" width="100%"
	style="text-align: left; color: #858786">
	<tr>
		<td height="10" width="5%"
			style="background-image: url('${KMSS_Parameter_StylePath}tag/title_rela.gif')"><img
			src='${KMSS_Parameter_StylePath}tag/title_rela.gif' /></td>
		<td width="15%"
			style="background-image: url('${KMSS_Parameter_StylePath}tag/title_rela.gif')"><span
			style="font-size: 13px; vertical-align: bottom"><bean:message  bundle="sys-tag" key="sysTagTop.rank"/></span></td>
		<td height="5%" width="10"
			style="background-image: url('${KMSS_Parameter_StylePath}tag/title_rela.gif')"></td>
		<td width="60%"
			style="background-image: url('${KMSS_Parameter_StylePath}tag/title_rela.gif')"><span
			style="font-size: 13px; vertical-align: bottom"><bean:message  bundle="sys-tag" key="sysTagTop.key"/></span></td>
		<td width="15%"
			style="background-image: url('${KMSS_Parameter_StylePath}tag/title_rela.gif')"><span
			style="font-size: 13px; vertical-align: bottom"><bean:message  bundle="sys-tag" key="sysTagTop.relation"/></span></td>
	</tr>
	<tr>
		<td colspan="5" height="10px"></td>
	</tr>
	<c:forEach items="${topFourthList}" var="sysTagTopLog" varStatus="vstatus">
		<tr>
		<td height="25"></td>
		<td><span class="span-a">${vstatus.index+1}</span></td>
		<td><kmss:showTagTrend trendValue="${sysTagTopLog.fdTrend}"/></td>
		<td><a href="#" onclick="onClickTag('${sysTagTopLog.fdSysTagTags.fdName}',this);"><span><c:out value="${sysTagTopLog.fdSysTagTags.fdName}"/></span></a></td>
		<td><kmss:showTagAliasImg aliasStatus="${sysTagTopLog.fdSysTagTags.fdContainAlias}" htmlElementProperties="onclick=\"openRela(event,'${sysTagTopLog.fdSysTagTags.fdId}',this)\""/></td>
		</tr>
	</c:forEach>
</table>
</DIV>
<%--右边间隔--%>
<DIV class='nbsp'></DIV>
</DIV>
</DIV>
<!-- 分类排行 -->
<c:forEach var="tempMap" items="${categoryList}" varStatus="vstatus_"> 
<c:forEach var="tempMap_" items="${tempMap}"> 
<c:set var="sysTagCategory" value="${tempMap_.key}"/>
<c:set var="tagTopList" value="${tempMap_.value}"/>
<c:if test="${vstatus_.index < 4}">
<DIV class="div_top">
<DIV class="div_header">
<table class="div_table" cellpaing=0 cellspacing=0>
	<tr>
		<td width="8%" height="35"
			style="text-align: right;background-image: url('${KMSS_Parameter_StylePath}tag/title_center.jpg');background-repeat:no-repeat )">
		<img src='${KMSS_Parameter_StylePath}tag/title_leftdot.jpg'
			width="100%" height="100%" /></td>
		<td width="85%" height="35"
			style="background-image: url('${KMSS_Parameter_StylePath}tag/title_center.jpg')">
		&nbsp;&nbsp;&nbsp;<span	style="font-size: 15px; font: bold; color: #80A4B0">${sysTagCategory.fdName}</span></td>
		<td width="5%" height="35" style="text-align: right"><img
			src='${KMSS_Parameter_StylePath}tag/title_right.jpg' width="100%"
			height="100%" /></td>
	</tr>
</table>
</DIV>
<DIV class="div_a">
<table cellpadding="0" cellspacing="0" width="100%"
	style="text-align: left; color: #858786">
	<tr>
		<td height="10" width="5%"
			style="background-image: url('${KMSS_Parameter_StylePath}tag/title_rela.gif')"><img
			src='${KMSS_Parameter_StylePath}tag/title_rela.gif' /></td>
		<td width="15%"
			style="background-image: url('${KMSS_Parameter_StylePath}tag/title_rela.gif')"><span
			style="font-size: 13px; vertical-align: bottom"><bean:message  bundle="sys-tag" key="sysTagTop.rank"/></span></td>
		<td height="5%" width="10"
			style="background-image: url('${KMSS_Parameter_StylePath}tag/title_rela.gif')"></td>
		<td width="60%"
			style="background-image: url('${KMSS_Parameter_StylePath}tag/title_rela.gif')"><span
			style="font-size: 13px; vertical-align: bottom"><bean:message  bundle="sys-tag" key="sysTagTop.key"/></span></td>
		<td width="15%"
			style="background-image: url('${KMSS_Parameter_StylePath}tag/title_rela.gif')"><span
			style="font-size: 13px; vertical-align: bottom"><bean:message  bundle="sys-tag" key="sysTagTop.relation"/></span></td>
	</tr>
	<tr>
		<td colspan="5" height="10px"></td>
	</tr>
	<c:forEach items="${tagTopList}" var="sysTagTopLog" varStatus="vstatus">
		<tr>
		<td height="25"></td>
		<td><span class="span-a">${vstatus.index+1}</span></td>
		<td><kmss:showTagTrend trendValue="${sysTagTopLog.fdTrend}"/></td>
		<td><a href="#" onclick="onClickTag('${sysTagTopLog.fdSysTagTags.fdName}',this);"><span><c:out value="${sysTagTopLog.fdSysTagTags.fdName}"/></span></a></td>
		<td><kmss:showTagAliasImg aliasStatus="${sysTagTopLog.fdSysTagTags.fdContainAlias}" htmlElementProperties="onclick=\"openRela(event,'${sysTagTopLog.fdSysTagTags.fdId}',this)\""/></td>
		</tr>
	</c:forEach>
	
</table>
</DIV> 
</DIV>
</c:if>
<c:if test ="${vstatus_.index == 4}">
<%--更多--%>
<DIV  style="width: 100%;margin-top: 5px;margin-bottom: 3px;margin-right: 10px;text-align: right;">
<img id='moreImg' src='${KMSS_Parameter_StylePath}tag/more.gif' style="cursor: hand;"  onclick="openMore()"/>
</DIV>
</c:if>
<c:if test="${vstatus_.index >= 4}">
<DIV id="moreCategory" style="width: 100%;height: 15;margin-top: 8px;margin-bottom: 10px;margin-right: 5px;text-align: right;display:none">
<DIV class="div_top">
<DIV class="div_header">
<table class="div_table" cellpaing=0 cellspacing=0>
	<tr>
		<td width="8%" height="35"
			style="text-align: right;background-image: url('${KMSS_Parameter_StylePath}tag/title_center.jpg');background-repeat:no-repeat )">
		<img src='${KMSS_Parameter_StylePath}tag/title_leftdot.jpg'
			width="100%" height="100%" /></td>
		<td width="85%" height="35"
			style="background-image: url('${KMSS_Parameter_StylePath}tag/title_center.jpg')">
		&nbsp;&nbsp;&nbsp;<span	style="font-size: 15px; font: bold; color: #80A4B0">${sysTagCategory.fdName}</span></td>
		<td width="5%" height="35" style="text-align: right"><img
			src='${KMSS_Parameter_StylePath}tag/title_right.jpg' width="100%"
			height="100%" /></td>
	</tr>
</table>
</DIV>
<DIV class="div_a">
<table cellpadding="0" cellspacing="0" width="100%"
	style="text-align: left; color: #858786">
	<tr>
		<td height="10" width="5%"
			style="background-image: url('${KMSS_Parameter_StylePath}tag/title_rela.gif')"><img
			src='${KMSS_Parameter_StylePath}tag/title_rela.gif' /></td>
		<td width="15%"
			style="background-image: url('${KMSS_Parameter_StylePath}tag/title_rela.gif')"><span
			style="font-size: 13px; vertical-align: bottom"><bean:message  bundle="sys-tag" key="sysTagTop.rank"/></span></td>
		<td height="5%" width="10"
			style="background-image: url('${KMSS_Parameter_StylePath}tag/title_rela.gif')"></td>
		<td width="60%"
			style="background-image: url('${KMSS_Parameter_StylePath}tag/title_rela.gif')"><span
			style="font-size: 13px; vertical-align: bottom"><bean:message  bundle="sys-tag" key="sysTagTop.key"/></span></td>
		<td width="15%"
			style="background-image: url('${KMSS_Parameter_StylePath}tag/title_rela.gif')"><span
			style="font-size: 13px; vertical-align: bottom"><bean:message  bundle="sys-tag" key="sysTagTop.relation"/></span></td>
	</tr>
	<tr>
		<td colspan="5" height="10px"></td>
	</tr>
	<c:forEach items="${tagTopList}" var="sysTagTopLog" varStatus="vstatus">
		<tr>
		<td height="25"></td>
		<td><span class="span-a">${vstatus.index+1}</span></td>
		<td><kmss:showTagTrend trendValue="${sysTagTopLog.fdTrend}"/></td>
		<td><a href="#" onclick="onClickTag('${sysTagTopLog.fdSysTagTags.fdName}',this);"><span><c:out value="${sysTagTopLog.fdSysTagTags.fdName}"/></span></a></td>
		<td><kmss:showTagAliasImg aliasStatus="${sysTagTopLog.fdSysTagTags.fdContainAlias}" htmlElementProperties="onclick=\"openRela(event,'${sysTagTopLog.fdSysTagTags.fdId}',this)\""/></td>
		</tr>
	</c:forEach>
</table>
</DIV>
</DIV>
</DIV>
</c:if>
</c:forEach>
</c:forEach>  
</DIV>
<%--云图--%>
<DIV id='searchCloud' style="width:100%; display: none">
<iframe  id='iframeCloud'  width="100%" height="100%"  frameborder=4 scrolling="no" marginheight="0"  onload="Javascript:SetWinHeight(this)"   >
</iframe> 
</DIV>
</DIV>
</DIV>
<!-- 别名标签 -->
<DIV id="alias_tag_id" style="display:none" onmouseleave="closeRela()">
<DIV id="alias_tag_id_a" style="width:100%;height: 4px;"><span style="width:90%;text-align:right;float:right;padding-right:5px;" ><font size="3px"><span onmouseover="this.style.cursor='hand'" onclick="closeRela()">×</span></font></span></DIV>
<DIV id="alias_tag_id_b" style="padding-left:10px;text-align:left;">
</DIV>
</DIV>
</center>
</body>
</html>

