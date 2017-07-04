<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>  
<%@ include file="/resource/jsp/htmlhead.jsp" %>
<script>
Com_IncludeFile("doclist.js|dialog.js|optbar.js");
Com_IncludeFile("tag_top_cloud.css", "style/"+Com_Parameter.Style+"/tag/");
</script>
</head>
<body>  
<script> 
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
	var height = window.document.body.clientHeight;
	var width = window.document.body.clientWidth; 
	var divflash_ = document.getElementById('divflash');//获取对象  
	divflash.style.width = width-3;
	divflash.style.height = height-8;
}


function Tag_rtnData(rtnData) {
	var itv = setInterval(function() {
		var flash;
		~~function() {
			var agent = navigator.userAgent.toLowerCase();
			if (/msie/.test(agent)) {//IE
				flash = document.getElementById("TagApplication_SWFObjectName");
			} else
				flash = document.getElementById("TagApplication_SWFEmbedName");
		}();

		if (flash) {
			clearInterval(itv);
			var divflash = document.getElementById('divflash'); //获取对象  
			if (rtnData.GetHashMapArray().length >= 1) {
				var obj = rtnData.GetHashMapArray()[0];
				var count = obj['count'];
				var xml = obj['xml'];

				if (count == 0) {
					flash.SphereTag_setTagsDataToAS(xml); //标签名称 
					return;
				} else if (count > 10) { //设置球大小  
					flash.SphereTag_setConfigToAS(Tag_ConfigXml("4F7BA7", "30", "130", "130", "30", "10", "30"));
				} else {
					flash.SphereTag_setConfigToAS(Tag_ConfigXml("4F7BA7", "30", "130", "130", "30", "10", "30"));
				}
				flash.SphereTag_setTagsDataToAS(xml); //标签名称 
			}
		}
	}, 500);
}


//初始化FLASH
function SphereTag_initComplete(){ 
	
}
//点击FLASH
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
</script>
<center>
	<div id='divflash' >
	<div style="width:100%;height:100%;">
	<object 
		id="TagApplication_SWFObjectName"
		name="TagApplication_SWFObjectName" 
		classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000"
	    width="100%" height="100%" >
	    <param name="movie" value="<c:url value="/sys/tag/sys_tag_top/SphereTag.swf?rand=1"/>" />
	    <param name="quality" value="high" />
	    <param name="wmode" value="opaque" />
		<embed  
			id = "TagApplication_SWFEmbedName"
			name="TagApplication_SWFObjectName" 
			src="<c:url value="/sys/tag/sys_tag_top/SphereTag.swf?rand=1"/>" 
			wmode="opaque" 
			quality="high" pluginspage="http://www.macromedia.com/go/getflashplayer" 
			type="application/x-shockwave-flash" style="width: 100%;height: 100%" 
			allowFullScreen=true >
		</embed>
	</object>
	</div>
	</div>
</center>
</body> 
</html>