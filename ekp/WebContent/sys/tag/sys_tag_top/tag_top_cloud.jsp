<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>  
<%@ include file="/resource/jsp/htmlhead.jsp" %>
<script>
Com_IncludeFile("doclist.js|dialog.js|optbar.js");
Com_IncludeFile("tag_top_cloud.css", "style/"+Com_Parameter.Style+"/tag/");
</script>
<script> 
//<config tagColor="000000" colorDepth="30" userDistaice="300" sphereRadius="250" frameSpeed="30" baseSpeed="10" centerAreaRadius="30"/>
function Tag_ConfigXml(tagColor,colorDepth,userDistaice,sphereRadius,frameSpeed,baseSpeed,centerAreaRadius){
	var configXml="<config"
	+" tagColor='"+tagColor+"'"
	+" colorDepth='"+colorDepth+"'"
	+" userDistaice='"+userDistaice+"'"
	+" sphereRadius='"+sphereRadius +"'"
	+" frameSpeed='"+frameSpeed+"'"
	+" baseSpeed='"+baseSpeed+"'"
	+" centerAreaRadius='"+centerAreaRadius+"'/>";   
    return configXml;
}
//页面加载
window.onload=function(){  
	var data = new KMSSData();
	var url="sysTagSphereXMLService&type=top"; 
	data.SendToBean(url,Tag_rtnData); 
}
//切换分类
function switchFlash(categoryId){ 
	var data = new KMSSData(); 	 
	var url="sysTagSphereXMLService&type=top&categoryId="+categoryId; 
	data.SendToBean(url,Tag_rtnData); 
} 

function Tag_rtnData(rtnData){
	var itv = setInterval(function() {
		var flash;
		~~function(obj,name){
			var arr = document.getElementsByName(name);
			flash = arr.length >= 2 ? arr[1] : arr[0];
		}(flash,'TagApplication_SWFObjectName'); 
		var divflash = document.getElementById('divflash');//获取对象  
		if (flash) {
			clearInterval(itv);
			if(rtnData.GetHashMapArray().length >= 1){ 
	     		var obj = rtnData.GetHashMapArray()[0]; 
	     		var count=obj['count'];
	     		var xml=obj['xml'];   
	     	
	     		if(count==0){
	     			flash.SphereTag_setTagsDataToAS(xml);//标签名称(JS -> AS) 
	     			return;  
	     	    } 
	     		else if(count>10){//设置球大小  
	     			divflash.style.width = 450 + "px";
	 			    divflash.style.height =450 + "px"; 
	 			    flash.SphereTag_setConfigToAS(Tag_ConfigXml("4F7BA7","30","300","250","30","10","30"));
	         	} 
	     		else {         		
	     		  divflash.style.width = 450 + "px";
	 			  divflash.style.height = 450 + "px";
	 			  flash.SphereTag_setConfigToAS(Tag_ConfigXml("4F7BA7","30","300","250","30","10","30"));
	         	}  
	     		flash.SphereTag_setTagsDataToAS(xml);//标签名称 
	     } 
		}
	}, 500);
}


//初始化FLASH(AS -> JS)
function SphereTag_initComplete(){ 
	
}
//点击FLASH(AS -> JS)
function SphereTag_TagClick(tag)
{
	onClickTag(tag);
}
//跳转搜索结果
function onClickTag(tagName){
	var href = "<c:url value='/sys/tag/sys_tag_main/sysTagMain.do?method=searchMain'/>";
	href=href+"&queryString="+encodeURI(tagName)+"&queryType=normal";
	window.open(href,"_blank");
}
function openMoreCategory(){
	var moreCategoryObj = document.getElementById("moreCategory_id");
	if(moreCategoryObj.style.display == ''){
		moreCategoryObj.style.display = "none";
	}else{
		moreCategoryObj.style.display = "";
	}
}
function changePath(param1){
var obj = param1;
if(param1 == ''){
	document.getElementById("div_path_id").innerHTML="<bean:message bundle="sys-tag" key="sysTagMain.cloud.path"/>"+"<bean:message bundle="sys-tag" key="sysTagMain.cloud.path.message.0"/>";	
}else{
document.getElementById("div_path_id").innerHTML="<bean:message bundle="sys-tag" key="sysTagMain.cloud.path"/>"+param1;
}
}
</script>
</head>
<body>  
<div class="main">
<div id="div_path_id" style="color:#4F7BA7;font-size:13px;margin-top:-0px;margin-left:21%;margin-top:5px;margin-bottom:5px;"><bean:message bundle="sys-tag" key="sysTagMain.cloud.path"/><bean:message bundle="sys-tag" key="sysTagMain.cloud.path.message.0"/></div>
<div class="ccategory">
<%--全部分类--%>
<span  class='spanCl'  onclick="changePath('');switchFlash('')"><bean:message bundle="sys-tag" key="sysTagTop.allCategory" /></span>
<div>
<c:forEach items="${listCategoryShow}" var="tagCategory"  varStatus="vstatus" >
<li style="list-style-type:none;;" ><span class='spanCl' onclick="changePath('${tagCategory.fdName}');switchFlash('${tagCategory.fdId}')" >${tagCategory.fdName}</span></li>
</c:forEach>
</div>
<c:if test="${categorySize > 8 }">
<div>
<img id='moreImg' src='${KMSS_Parameter_StylePath}tag/more.gif' style="cursor: pointer;"  onclick="openMoreCategory()"/>
</div>
<div id="moreCategory_id" style="display:none;margin-top:10px;">
<c:forEach items="${listCategoryShowMore}" var="tagCategory"  varStatus="vstatus" >
<li style="list-style-type:none"><span class='spanCl' onclick="changePath('${tagCategory.fdName}');switchFlash('${tagCategory.fdId}')" >${tagCategory.fdName}</span></li>
</c:forEach>
</div>
</c:if>
</div>
<div id='divflash' class='cflash'>
<div style="BORDER-BOTTOM: #BCD4ED 1px solid;border-top: #BCD4ED 1px solid;border-left: #BCD4ED 1px solid;border-right: #BCD4ED 1px solid;text-align: center">
<object 
	id="TagApplication_SWFObjectName"
	name="TagApplication_SWFObjectName" 
	classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000"
    width="100%" height="100%" >
    <param name="movie" value="<c:url value="/sys/tag/sys_tag_top/SphereTag.swf"/>" />
    <param name="quality" value="high" />
    <param name="wmode" value="opaque" />
	<embed 
		name="TagApplication_SWFObjectName" 
		src="<c:url value="/sys/tag/sys_tag_top/SphereTag.swf"/>" 
		wmode="opaque" 
		quality="high" pluginspage="http://www.macromedia.com/go/getflashplayer" 
		type="application/x-shockwave-flash" style="width: 100%;height: 100%" 
		allowFullScreen=true >
	</embed>
</object>
</div>
</div> 
</div>
</body> 