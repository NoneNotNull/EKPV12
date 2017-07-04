<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/view_top.jsp"%>
<script>
	function confirmDelete(msg){
	var del = confirm("<bean:message key="page.comfirmDelete"/>");
	return del;

}
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
		if(isIE()){
			var flashHtml = "<object id=\"TagApplication_SWFObjectName\" name=\"TagApplication_SWFObjectName\" 	classid=\"clsid:D27CDB6E-AE6D-11cf-96B8-444553540000\" "+
				    "width=\"100%\" height=\"100%\" > " +
				    "<param name=\"movie\" value=\"<c:url value='/sys/tag/sys_tag_top/SphereTag.swf'/>\" /> "+
				    "<param name=\"quality\" value=\"high\" /> "+
				    "<param name=\"wmode\" value=\"opaque\" />";
			document.getElementById("flashDiv").innerHTML = flashHtml;
		}	
		
		var data = new KMSSData();
		var url="sysTagSphereXMLService&type=top"; 
		data.SendToBean(url,Tag_rtnData); 
	}

	function Tag_rtnData(rtnData){
		var itv = setInterval(function() {
			var flash = document.getElementById('TagApplication_SWFObjectName');//获取对象  
			var flashDiv = document.getElementById('flashDiv');
			if (flash) {
				clearInterval(itv);
				var flashDiv = document.getElementById('flashDiv');
				if(rtnData.GetHashMapArray().length >= 1){ 
		     		var obj = rtnData.GetHashMapArray()[0]; 
		     		var count=obj['count'];
		     		var xml=obj['xml']; 
		     		//flashDiv.style.width = 450;
		     		//flashDiv.style.height = 450;  
		     		
		     		if(count==0){   
		     			flashDiv.style.background = "#EBF2F8";
		     			flashDiv.style.border = "1px solid #D3E8F2";
			     		flashDiv.style.width = 450 + "px";
			     		flashDiv.style.height =450 + "px";
		     			flash.SphereTag_setConfigToAS(Tag_ConfigXml("4F7BA7","30","15","250","30","10","30"));
		         		flash.SphereTag_setTagsDataToAS(xml);//标签名称 
		     			return;
		     	    } 
		     		else if(count>10){//设置球大小 
		     			flashDiv.style.background = "#EBF2F8";
		     			flashDiv.style.border = "1px solid #D3E8F2";
			     		flashDiv.style.width = 450 + "px";
			     		flashDiv.style.height =450 + "px";
		     			flash.SphereTag_setConfigToAS(Tag_ConfigXml("4F7BA7","30","350","250","30","10","30"));
		         	} 
		     		else {
		     			flashDiv.style.background = "#EBF2F8";
			     		flashDiv.style.border = "1px solid #D3E8F2";
			     		flashDiv.style.width = 450 + "px";
			     		flashDiv.style.height =450 + "px";
		     			flash.SphereTag_setConfigToAS(Tag_ConfigXml("4F7BA7","30","350","250","30","10","30"));
		         	}
		     		
		     		//<config tagColor="000000" colorDepth="30" userDistaice="300" sphereRadius="250" frameSpeed="30" baseSpeed="10" centerAreaRadius="30"/>
		     		flash.SphereTag_setTagsDataToAS(xml);//标签名称 
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
	
	function isIE(){ //ie?
			   if (window.navigator.userAgent.toLowerCase().indexOf("msie")>=1)
			    return true;
			   else
			    return false;
			}

</script>
<c:import
	url="/sys/tag/sys_tag_category/sysTagCategory_addTags_button.jsp"
	charEncoding="UTF-8">
</c:import>
<c:import
	url="/sys/tag/sys_tag_category/sysTagCategory_removeTags_button.jsp"
	charEncoding="UTF-8">
</c:import>
<div id="optBarDiv">
		<kmss:auth requestURL="/sys/tag/sys_tag_category/sysTagCategory.do?method=edit&fdId=${param.fdId}" requestMethod="GET">
			<input type="button"
				value="<bean:message key="button.edit"/>"
				onclick="Com_OpenWindow('sysTagCategory.do?method=edit&fdId=${param.fdId}','_self');">
		</kmss:auth>
		<kmss:auth requestURL="/sys/tag/sys_tag_category/sysTagCategory.do?method=delete&fdId=${param.fdId}" requestMethod="GET">
			<input type="button"
				value="<bean:message key="button.delete"/>"
				onclick="if(!confirmDelete())return;Com_OpenWindow('sysTagCategory.do?method=delete&fdId=${param.fdId}','_self');">
		</kmss:auth>
	<input type="button"
		value="<bean:message key="button.close"/>"
		onclick="Com_CloseWindow();">
</div>
<p class="txttitle"><bean:message  bundle="sys-tag" key="table.sysTagCategory"/></p>
<center>
<table class="tb_normal" width=95%>
		<html:hidden name="sysTagCategoryForm" property="fdId"/>
	<tr>

		<td class="td_normal_title" width=15%>
			<bean:message  bundle="sys-tag" key="sysTagCategory.fdName"/>
		</td><td width=35%>
			<c:out value="${sysTagCategoryForm.fdName}" />
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-tag" key="sysTagCategory.fdManagerId"/>
		</td><td width=35%>
			<c:out value="${sysTagCategoryForm.fdManagerName}" />
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="sys-tag" key="sysTagCategory.fdTagQuoteTimes"/>
		</td><td width=35%>
			${sysTagCategoryForm.fdTagQuoteTimes}
			<span class="txtstrong">(<bean:message  bundle="sys-tag" key="sysTagCategory.fdTagQuoteTimes.describe"/>)</span>
		</td>	
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="sys-tag" key="sysTagCategory.fdOrder"/>
		</td><td width=35%>
			<c:out value="${sysTagCategoryForm.fdOrder}" />
		</td>
	</tr>
	<%---标签云图---%>
	<tr>
		<td class="td_normal_title"><bean:message  bundle="sys-tag" key="sysTagCategory.alltags"/></td>
		<td colspan="3" style="text-align: left" >		
		<div id='flashDiv' > 
		<object 
			classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000"
		    width="100%" height="100%" >
		    <param name="movie" value="<c:url value="/sys/tag/sys_tag_top/SphereTag.swf"/>" />
		    <param name="quality" value="high" />
		    <param name="wmode" value="opaque" />
		    <embed 
		    	id="TagApplication_SWFObjectName"
				src="<c:url value='/sys/tag/sys_tag_top/SphereTag.swf'/>" 
				wmode="opaque"
				quality="high" 
				pluginspage="http://www.macromedia.com/go/getflashplayer" 
				type="application/x-shockwave-flash" 
				style="width: 100%; height: 100%">
			</embed>
		</object>
			
		</div>
		 <div style="margin-top: 10px">&nbsp;</div>
		</td>
	</tr>
</table>
</center>
<%@ include file="/resource/jsp/view_down.jsp"%>