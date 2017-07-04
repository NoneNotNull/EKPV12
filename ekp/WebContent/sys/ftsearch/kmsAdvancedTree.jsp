<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/view_top.jsp"%>    
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <title>搜索结果页</title>
    <meta http-equiv="content-type" content="text/html; charset=utf-8"/>
    <meta http-equiv="imagetoolbar" content="no"/>
    <meta name="apple-mobile-web-app-capable" content="yes"/>
    <link href="kmsResources/jquery-ui-themes.css" type="text/css" rel="stylesheet">
    <link href="kmsResources/axure_rp_page.css" type="text/css" rel="stylesheet">
    <link href="kmsResources/axurerp_pagespecificstyles.css" type="text/css" rel="stylesheet">
    <script src="kmsResources/sitemap.js"></script>
    <script src="kmsResources/jquery-1.7.1.min.js"></script>
    <script src="kmsResources/axutils.js"></script>
    <script src="kmsResources/jquery-ui-1.8.10.custom.min.js"></script>
    <script src="kmsResources/axurerp_beforepagescript.js"></script>
    <script src="kmsResources/messagecenter.js"></script>
	<script src='kmsResources/data.js'></script>
</head>
<body>
<script type="text/javascript">


	function submitFilterParam(){
		var arr=new Array(); 
		arr[0] = "modelName;category";
		arr[1] = "com.landray.kmss.kms.multidoc.model.KmsMultidocKnowledge,com.landray.kmss.km.doc.model.KmDocKnowledge;x139009384848f0eaae94be84bcc86533x,x133c56cdb4b33d9dc5f36b34f0399686x";
		//	var v_Obj=document.frames("searchFrame");
		//	v_Obj.submitFilterParam(paramKey,paramValue);
		return arr;
	}

	function submitFilterParam22(){

		
		//var queStr = document.frames('searchFrame').document.getElementsByName("queryString")[0];
		//alert(queStr.value);
		var keyField = "test";//document.getElementsByName("Search_Keyword")[0];
		if(keyField.value==""){
			alert('<bean:message key="error.search.keywords.required"/>');
			keyField.focus();
			return;
		}  
		var filterFields = "modelName;category";
		var filterString = "com.landray.kmss.kms.multidoc.model.KmsMultidocKnowledge,com.landray.kmss.km.doc.model.KmDocKnowledge;x139009384848f0eaae94be84bcc86533x";
		if(document.getElementsByName("checkValue")[0].checked){
			filterString = "com.landray.kmss.kms.multidoc.model.KmsMultidocKnowledge,com.landray.kmss.km.doc.model.KmDocKnowledge;x139009384848f0eaae94be84bcc86533x,x133c56cdb4b33d9dc5f36b34f0399686x";
		}
		//var url = "<c:url value='/sys/ftsearch/searchBuilder.do?method=search'/>";
		var url = "http://127.0.0.1:8080/ekp/sys/ftsearch/searchBuilder.do?method=search";
		var seq = parseInt(Com_GetUrlParameter(url, "s_seq"));
		seq = isNaN(seq)?1:seq+1; 
		url = Com_SetUrlParameter(url, "s_seq", seq);
		url = Com_SetUrlParameter(url, "filterFields", filterFields);
		url = Com_SetUrlParameter(url, "filterString", filterString);
		url = Com_SetUrlParameter(url, "queryString", "test");
		url = Com_SetUrlParameter(url, "fwFlag", "true");//标示跳转页面为plugin配置
		document.getElementById("searchFrame").src=url;
		
	}

</script>

<div id="main_container">
</div>
<DIV id="u5" class="treeroot" style="position:absolute; left:4px; top:109px; width:171px; height:485px; overflow:visible;" >


<DIV id="cncu5" style="position:absolute; left:0px; top:0px; width:1px; height:1px; overflow:visible; " >

<DIV id="u6" class="treenode" style="position:absolute; left:0px; top:0px; width:104px; height:20px; overflow:visible;">

<div id="u7" class="u7_container"   >
<div id="u7_img" class="u7_normal detectCanvas"></div>
<div id="u8" class="u8" style="visibility:hidden;"  >
<div id="u8_rtf"></div>
</div>
</div>


<div id="u9" class="u9_container"   >
<div id="u9_img" class="u9_normal detectCanvas"></div>
<div id="u10" class="u10" style="visibility:hidden;"  >
<div id="u10_rtf"></div>
</div>
</div>
<div id="u11" class="u11_container"   >
<div id="u11_img" class="u11_normal detectCanvas"></div>
<div id="u12" class="u12"  >
<div id="u12_rtf"><p style="text-align:left;"><span style="font-family:宋体;font-size:13px;font-weight:bold;font-style:normal;text-decoration:none;color:#333333;">搜索范围</span></p></div>
</div>
</div>


<DIV id="cncu6" style="position:absolute; left:0px; top:0px; width:1px; height:1px; overflow:visible; " >

<DIV id="u13" class="treenode" style="position:absolute; left:20px; top:20px; width:100px; height:20px; overflow:visible;">

<div id="u14" class="u14_container"   >
<div id="u14_img" class="u14_normal detectCanvas"></div>
<div id="u15" class="u15" style="visibility:hidden;"  >
<div id="u15_rtf"></div>
</div>
</div>


<div id="u16" class="u16_container"   >
<div id="u16_img" >
<input id="u141" style="left: -3px; top: -2px; position: absolute;" type="checkbox" CHECKED="" value="checkbox"/>
</div>
<div id="u17" class="u17" style="visibility:hidden;"  >
<div id="u17_rtf"></div>
</div>
</div>
<div id="u18" class="u18_container"   >
<div id="u18_img" class="u18_normal detectCanvas"></div>
<div id="u19" class="u19"  >
<div id="u19_rtf"><p style="text-align:left;"><span style="font-family:Arial;font-size:13px;font-weight:normal;font-style:normal;text-decoration:none;color:#333333;">客服知识</span></p></div>
</div>
</div>


<DIV id="cncu13" style="position:absolute; left:0px; top:0px; width:1px; height:1px; overflow:visible; " >

<DIV id="u20" class="treenode" style="position:absolute; left:20px; top:20px; width:126px; height:20px; overflow:visible;">

<div id="u21" class="u21_container"   >
<div id="u21_img" >
<input id="u141" style="left: -3px; top: -2px; position: absolute;" type="checkbox" CHECKED="" value="checkbox"/>
</div>
<div id="u22" class="u22" style="visibility:hidden;"  >
<div id="u22_rtf"></div>
</div>
</div>
<div id="u23" class="u23_container"   >
<div id="u23_img" class="u23_normal detectCanvas"></div>
<div id="u24" class="u24"  >
<div id="u24_rtf"><p style="text-align:left;"><span style="font-family:Arial;font-size:13px;font-weight:normal;font-style:normal;text-decoration:none;color:#333333;">业务办理咨询</span></p></div>
</div>
</div>

</DIV>
<DIV id="u25" class="treenode" style="position:absolute; left:20px; top:40px; width:126px; height:20px; overflow:visible;">

<div id="u26" class="u26_container"   >
<div id="u26_img" >
<input id="u141" style="left: -3px; top: -2px; position: absolute;" type="checkbox" CHECKED="" value="checkbox"/>
</div>
<div id="u27" class="u27" style="visibility:hidden;"  >
<div id="u27_rtf"></div>
</div>
</div>
<div id="u28" class="u28_container"   >
<div id="u28_img" class="u28_normal detectCanvas"></div>
<div id="u29" class="u29"  >
<div id="u29_rtf"><p style="text-align:left;"><span style="font-family:Arial;font-size:13px;font-weight:normal;font-style:normal;text-decoration:none;color:#333333;">交易规则咨询</span></p></div>
</div>
</div>

</DIV>
<DIV id="u30" class="treenode" style="position:absolute; left:20px; top:60px; width:126px; height:20px; overflow:visible;">

<div id="u31" class="u31_container"   >
<div id="u31_img" >
<input id="u141" style="left: -3px; top: -2px; position: absolute;" type="checkbox" CHECKED="" value="checkbox"/></div>
<div id="u32" class="u32" style="visibility:hidden;"  >
<div id="u32_rtf"></div>
</div>
</div>
<div id="u33" class="u33_container"   >
<div id="u33_img" class="u33_normal detectCanvas"></div>
<div id="u34" class="u34"  >
<div id="u34_rtf"><p style="text-align:left;"><span style="font-family:Arial;font-size:13px;font-weight:normal;font-style:normal;text-decoration:none;color:#333333;">产品信息咨询</span></p></div>
</div>
</div>

</DIV>
<DIV id="u35" class="treenode" style="position:absolute; left:20px; top:80px; width:100px; height:20px; overflow:visible;">

<div id="u36" class="u36_container"   >
<div id="u36_img" >
<input id="u141" name="checkValue" onclick="submitFilterParam22();" style="left: -3px; top: -2px; position: absolute;" type="checkbox" CHECKED="" value="checkbox"/></div>
<div id="u37" class="u37" style="visibility:hidden;"  >
<div id="u37_rtf"></div>
</div>
</div>
<div id="u38" class="u38_container"   >
<div id="u38_img" class="u38_normal detectCanvas"></div>
<div id="u39" class="u39"  >
<div id="u39_rtf"><p style="text-align:left;"><span style="font-family:Arial;font-size:13px;font-weight:normal;font-style:normal;text-decoration:none;color:#333333;">推广活动</span></p></div>
</div>
</div>

</DIV>
<DIV id="u40" class="treenode" style="position:absolute; left:20px; top:100px; width:100px; height:20px; overflow:visible;">

<div id="u41" class="u41_container"   >
<div id="u41_img" >
<input id="u141" style="left: -3px; top: -2px; position: absolute;" type="checkbox" CHECKED="" value="checkbox"/></div>
<div id="u42" class="u42" style="visibility:hidden;"  >
<div id="u42_rtf"></div>
</div>
</div>
<div id="u43" class="u43_container"   >
<div id="u43_img" class="u43_normal detectCanvas"></div>
<div id="u44" class="u44"  >
<div id="u44_rtf"><p style="text-align:left;"><span style="font-family:Arial;font-size:13px;font-weight:normal;font-style:normal;text-decoration:none;color:#333333;">理财课堂</span></p></div>
</div>
</div>

</DIV>
</DIV>
</DIV>
<DIV id="u45" class="treenode" style="position:absolute; left:20px; top:140px; width:100px; height:20px; overflow:visible;">

<div id="u46" class="u46_container"   >
<div id="u46_img" class="u46_normal detectCanvas"></div>
<div id="u47" class="u47" style="visibility:hidden;"  >
<div id="u47_rtf"></div>
</div>
</div>

<div id="u48" class="u48_container"   >
<div id="u48_img" >
<input id="u141" style="left: -3px; top: -2px; position: absolute;" type="checkbox" CHECKED="" value="checkbox"/></div>
<div id="u49" class="u49" style="visibility:hidden;"  >
<div id="u49_rtf"></div>
</div>
</div>
<div id="u50" class="u50_container"   >
<div id="u50_img" class="u50_normal detectCanvas"></div>
<div id="u51" class="u51"  >
<div id="u51_rtf"><p style="text-align:left;"><span style="font-family:Arial;font-size:13px;font-weight:normal;font-style:normal;text-decoration:none;color:#333333;">业务知识</span></p></div>
</div>
</div>

<DIV id="cncu45" style="position:absolute; left:0px; top:0px; width:1px; height:1px; overflow:visible; " >

<DIV id="u52" class="treenode" style="position:absolute; left:20px; top:20px; width:100px; height:20px; overflow:visible;">

<div id="u53" class="u53_container"   >
<div id="u53_img" >
<input id="u141" style="left: -3px; top: -2px; position: absolute;" type="checkbox" CHECKED="" value="checkbox"/></div>
<div id="u54" class="u54" style="visibility:hidden;"  >
<div id="u54_rtf"></div>
</div>
</div>
<div id="u55" class="u55_container"   >
<div id="u55_img" class="u55_normal detectCanvas"></div>
<div id="u56" class="u56"  >
<div id="u56_rtf"><p style="text-align:left;"><span style="font-family:Arial;font-size:13px;font-weight:normal;font-style:normal;text-decoration:none;color:#333333;">信审核查</span></p></div>
</div>
</div>

</DIV>
<DIV id="u57" class="treenode" style="position:absolute; left:20px; top:40px; width:113px; height:20px; overflow:visible;">

<div id="u58" class="u58_container"   >
<div id="u58_img" >
<input id="u141" style="left: -3px; top: -2px; position: absolute;" type="checkbox" CHECKED="" value="checkbox"/></div>
<div id="u59" class="u59" style="visibility:hidden;"  >
<div id="u59_rtf"></div>
</div>
</div>
<div id="u60" class="u60_container"   >
<div id="u60_img" class="u60_normal detectCanvas"></div>
<div id="u61" class="u61"  >
<div id="u61_rtf"><p style="text-align:left;"><span style="font-family:Arial;font-size:13px;font-weight:normal;font-style:normal;text-decoration:none;color:#333333;">反欺诈调查</span></p></div>
</div>
</div>

</DIV>
</DIV>
</DIV>
<DIV id="u62" class="treenode" style="position:absolute; left:20px; top:200px; width:100px; height:20px; overflow:visible;">

<div id="u63" class="u63_container"   >
<div id="u63_img" class="u63_normal detectCanvas"></div>
<div id="u64" class="u64" style="visibility:hidden;"  >
<div id="u64_rtf"></div>
</div>
</div>


<div id="u65" class="u65_container"   >
<div id="u65_img" >
<input id="u141" style="left: -3px; top: -2px; position: absolute;" type="checkbox" CHECKED="" value="checkbox"/></div>
<div id="u66" class="u66" style="visibility:hidden;"  >
<div id="u66_rtf"></div>
</div>
</div>
<div id="u67" class="u67_container"   >
<div id="u67_img" class="u67_normal detectCanvas"></div>
<div id="u68" class="u68"  >
<div id="u68_rtf"><p style="text-align:left;"><span style="font-family:Arial;font-size:13px;font-weight:normal;font-style:normal;text-decoration:none;color:#333333;">管理知识</span></p></div>
</div>
</div>

<DIV id="cncu62" style="position:absolute; left:0px; top:0px; width:1px; height:1px; overflow:visible; " >

<DIV id="u69" class="treenode" style="position:absolute; left:20px; top:20px; width:100px; height:20px; overflow:visible;">

<div id="u70" class="u70_container"   >
<div id="u70_img" >
<input id="u141" style="left: -3px; top: -2px; position: absolute;" type="checkbox" CHECKED="" value="checkbox"/></div>
<div id="u71" class="u71" style="visibility:hidden;"  >
<div id="u71_rtf"></div>
</div>
</div>
<div id="u72" class="u72_container"   >
<div id="u72_img" class="u72_normal detectCanvas"></div>
<div id="u73" class="u73"  >
<div id="u73_rtf"><p style="text-align:left;"><span style="font-family:Arial;font-size:13px;font-weight:normal;font-style:normal;text-decoration:none;color:#333333;">规范制度</span></p></div>
</div>
</div>

</DIV>
<DIV id="u74" class="treenode" style="position:absolute; left:20px; top:40px; width:100px; height:20px; overflow:visible;">

<div id="u75" class="u75_container"   >
<div id="u75_img" >
<input id="u141" style="left: -3px; top: -2px; position: absolute;" type="checkbox" CHECKED="" value="checkbox"/></div>
<div id="u76" class="u76" style="visibility:hidden;"  >
<div id="u76_rtf"></div>
</div>
</div>
<div id="u77" class="u77_container"   >
<div id="u77_img" class="u77_normal detectCanvas"></div>
<div id="u78" class="u78"  >
<div id="u78_rtf"><p style="text-align:left;"><span style="font-family:Arial;font-size:13px;font-weight:normal;font-style:normal;text-decoration:none;color:#333333;">法律法规</span></p></div>
</div>
</div>

</DIV>
</DIV>
</DIV>
<DIV id="u79" class="treenode" style="position:absolute; left:20px; top:260px; width:100px; height:20px; overflow:visible;">

<div id="u80" class="u80_container"   >
<div id="u80_img" class="u80_normal detectCanvas"></div>
<div id="u81" class="u81" style="visibility:hidden;"  >
<div id="u81_rtf"></div>
</div>
</div>


<div id="u82" class="u82_container"   >
<div id="u82_img" >
<input id="u141" style="left: -3px; top: -2px; position: absolute;" type="checkbox" CHECKED="" value="checkbox"/></div>
<div id="u83" class="u83" style="visibility:hidden;"  >
<div id="u83_rtf"></div>
</div>
</div>
<div id="u84" class="u84_container"   >
<div id="u84_img" class="u84_normal detectCanvas"></div>
<div id="u85" class="u85"  >
<div id="u85_rtf"><p style="text-align:left;"><span style="font-family:Arial;font-size:13px;font-weight:normal;font-style:normal;text-decoration:none;color:#333333;">销售渠道</span></p></div>
</div>
</div>

<DIV id="cncu79" style="position:absolute; left:0px; top:0px; width:1px; height:1px; overflow:visible; " >

<DIV id="u86" class="treenode" style="position:absolute; left:20px; top:20px; width:100px; height:20px; overflow:visible;">

<div id="u87" class="u87_container"   >
<div id="u87_img" >
<input id="u141" style="left: -3px; top: -2px; position: absolute;" type="checkbox" CHECKED="" value="checkbox"/></div>
<div id="u88" class="u88" style="visibility:hidden;"  >
<div id="u88_rtf"></div>
</div>
</div>
<div id="u89" class="u89_container"   >
<div id="u89_img" class="u89_normal detectCanvas"></div>
<div id="u90" class="u90"  >
<div id="u90_rtf"><p style="text-align:left;"><span style="font-family:Arial;font-size:13px;font-weight:normal;font-style:normal;text-decoration:none;color:#333333;">网上交易</span></p></div>
</div>
</div>

</DIV>
<DIV id="u91" class="treenode" style="position:absolute; left:20px; top:40px; width:100px; height:20px; overflow:visible;">

<div id="u92" class="u92_container"   >
<div id="u92_img" >
<input id="u141" style="left: -3px; top: -2px; position: absolute;" type="checkbox" CHECKED="" value="checkbox"/></div>
<div id="u93" class="u93" style="visibility:hidden;"  >
<div id="u93_rtf"></div>
</div>
</div>
<div id="u94" class="u94_container"   >
<div id="u94_img" class="u94_normal detectCanvas"></div>
<div id="u95" class="u95"  >
<div id="u95_rtf"><p style="text-align:left;"><span style="font-family:Arial;font-size:13px;font-weight:normal;font-style:normal;text-decoration:none;color:#333333;">理财中心</span></p></div>
</div>
</div>

</DIV>
<DIV id="u96" class="treenode" style="position:absolute; left:20px; top:60px; width:100px; height:20px; overflow:visible;">

<div id="u97" class="u97_container"   >
<div id="u97_img" >
<input id="u141" style="left: -3px; top: -2px; position: absolute;" type="checkbox" CHECKED="" value="checkbox"/></div>
<div id="u98" class="u98" style="visibility:hidden;"  >
<div id="u98_rtf"></div>
</div>
</div>
<div id="u99" class="u99_container"   >
<div id="u99_img" class="u99_normal detectCanvas"></div>
<div id="u100" class="u100"  >
<div id="u100_rtf"><p style="text-align:left;"><span style="font-family:Arial;font-size:13px;font-weight:normal;font-style:normal;text-decoration:none;color:#333333;">代销机构</span></p></div>
</div>
</div>

</DIV>
</DIV>
</DIV>
<DIV id="u101" class="treenode" style="position:absolute; left:20px; top:340px; width:100px; height:20px; overflow:visible;">

<div id="u102" class="u102_container"   >
<div id="u102_img" class="u102_normal detectCanvas"></div>
<div id="u103" class="u103" style="visibility:hidden;"  >
<div id="u103_rtf"></div>
</div>
</div>


<div id="u104" class="u104_container"   >
<div id="u104_img" >
<input id="u141" style="left: -3px; top: -2px; position: absolute;" type="checkbox" CHECKED="" value="checkbox"/></div>
<div id="u105" class="u105" style="visibility:hidden;"  >
<div id="u105_rtf"></div>
</div>
</div>
<div id="u106" class="u106_container"   >
<div id="u106_img" class="u106_normal detectCanvas"></div>
<div id="u107" class="u107"  >
<div id="u107_rtf"><p style="text-align:left;"><span style="font-family:Arial;font-size:13px;font-weight:normal;font-style:normal;text-decoration:none;color:#333333;">服务渠道</span></p></div>
</div>
</div>



<DIV id="cncu101" style="position:absolute; left:0px; top:0px; width:1px; height:1px; overflow:visible; " >

<DIV id="u108" class="treenode" style="position:absolute; left:20px; top:20px; width:100px; height:20px; overflow:visible;">

<div id="u109" class="u109_container"   >
<div id="u109_img" >
<input id="u141" style="left: -3px; top: -2px; position: absolute;" type="checkbox" CHECKED="" value="checkbox"/></div>
<div id="u110" class="u110" style="visibility:hidden;"  >
<div id="u110_rtf"></div>
</div>
</div>
<div id="u111" class="u111_container"   >
<div id="u111_img" class="u111_normal detectCanvas"></div>
<div id="u112" class="u112"  >
<div id="u112_rtf"><p style="text-align:left;"><span style="font-family:Arial;font-size:13px;font-weight:normal;font-style:normal;text-decoration:none;color:#333333;">客服电话</span></p></div>
</div>
</div>

</DIV>
<DIV id="u113" class="treenode" style="position:absolute; left:20px; top:40px; width:100px; height:20px; overflow:visible;">

<div id="u114" class="u114_container"   >
<div id="u114_img" >
<input id="u141" style="left: -3px; top: -2px; position: absolute;" type="checkbox" CHECKED="" value="checkbox"/></div>
<div id="u115" class="u115" style="visibility:hidden;"  >
<div id="u115_rtf"></div>
</div>
</div>
<div id="u116" class="u116_container"   >
<div id="u116_img" class="u116_normal detectCanvas"></div>
<div id="u117" class="u117"  >
<div id="u117_rtf"><p style="text-align:left;"><span style="font-family:Arial;font-size:13px;font-weight:normal;font-style:normal;text-decoration:none;color:#333333;">客服短信</span></p></div>
</div>
</div>

</DIV>
<DIV id="u118" class="treenode" style="position:absolute; left:20px; top:60px; width:100px; height:20px; overflow:visible;">

<div id="u119" class="u119_container"   >
<div id="u119_img" >
<input id="u141" style="left: -3px; top: -2px; position: absolute;" type="checkbox" CHECKED="" value="checkbox"/></div>
<div id="u120" class="u120" style="visibility:hidden;"  >
<div id="u120_rtf"></div>
</div>
</div>
<div id="u121" class="u121_container"   >
<div id="u121_img" class="u121_normal detectCanvas"></div>
<div id="u122" class="u122"  >
<div id="u122_rtf"><p style="text-align:left;"><span style="font-family:Arial;font-size:13px;font-weight:normal;font-style:normal;text-decoration:none;color:#333333;">电子邮件</span></p></div>
</div>
</div>

</DIV>
<DIV id="u123" class="treenode" style="position:absolute; left:20px; top:80px; width:100px; height:20px; overflow:visible;">

<div id="u124" class="u124_container"   >
<div id="u124_img" >
<input id="u141" style="left: -3px; top: -2px; position: absolute;" type="checkbox" CHECKED="" value="checkbox"/></div>
<div id="u125" class="u125" style="visibility:hidden;"  >
<div id="u125_rtf"></div>
</div>
</div>
<div id="u126" class="u126_container"   >
<div id="u126_img" class="u126_normal detectCanvas"></div>
<div id="u127" class="u127"  >
<div id="u127_rtf"><p style="text-align:left;"><span style="font-family:Arial;font-size:13px;font-weight:normal;font-style:normal;text-decoration:none;color:#333333;">在线客服</span></p></div>
</div>
</div>

</DIV>
</DIV>
</DIV>
<DIV id="u128" class="treenode" style="position:absolute; left:20px; top:440px; width:100px; height:20px; overflow:visible;">

<div id="u129" class="u129_container"   >
<div id="u129_img" >
<input id="u141" style="left: -3px; top: -2px; position: absolute;" type="checkbox" CHECKED="" value="checkbox"/></div>
<div id="u130" class="u130" style="visibility:hidden;"  >
<div id="u130_rtf"></div>
</div>
</div>
<div id="u131" class="u131_container"   >
<div id="u131_img" class="u131_normal detectCanvas"></div>
<div id="u132" class="u132"  >
<div id="u132_rtf"><p style="text-align:left;"><span style="font-family:Arial;font-size:13px;font-weight:normal;font-style:normal;text-decoration:none;color:#333333;">知识问答</span></p></div>
</div>
</div>

</DIV>
<DIV id="u133" class="treenode" style="position:absolute; left:20px; top:460px; width:100px; height:20px; overflow:visible;">

<div id="u134" class="u134_container"   >
<div id="u134_img" >
<input id="u141" style="left: -3px; top: -2px; position: absolute;" type="checkbox" CHECKED="" value="checkbox"/></div>
<div id="u135" class="u135" style="visibility:hidden;"  >
<div id="u135_rtf"></div>
</div>
</div>
<div id="u136" class="u136_container"   >
<div id="u136_img" class="u136_normal detectCanvas"></div>
<div id="u137" class="u137"  >
<div id="u137_rtf"><p style="text-align:left;"><span style="font-family:Arial;font-size:13px;font-weight:normal;font-style:normal;text-decoration:none;color:#333333;">专家网络</span></p></div>
</div>
</div>

</DIV>
</DIV>
</DIV>
</DIV>
</DIV>
<SELECT id="u138" class="u138"   >
<OPTION selected value="全部">全部</OPTION>
<OPTION  value="知识">知识</OPTION>
<OPTION  value="专家">专家</OPTION>
</SELECT>

<DIV id="u139" style="border-style:dotted; border-color:red; visibility:hidden; position:absolute; left:4px; top:107px; width:183px; height:482px;;" ></div>
<div id="u153" class="u153_container" style="padding-left:-500px;"  >
<iframe id="searchFrame" src="customResult.jsp" width="900px;" height="100%"></iframe>
</div>
<div id="u159" class="u159"  >
<div id="u159_rtf"><p style="text-align:left;"><span style="font-family:Arial;font-size:13px;font-weight:normal;font-style:normal;text-decoration:none;color:#333333;">（</span><span style="font-family:Arial;font-size:13px;font-weight:normal;font-style:normal;text-decoration:none;color:#FF0000;">1</span><span style="font-family:Arial;font-size:13px;font-weight:normal;font-style:normal;text-decoration:none;color:#FF0000;">0</span><span style="font-family:Arial;font-size:13px;font-weight:normal;font-style:normal;text-decoration:none;color:#333333;">）</span></p></div>
</div>
<div id="u160" class="u160_container"   >
<div id="u160_img" class="u160_normal detectCanvas"></div>
<div id="u161" class="u161" style="visibility:hidden;"  >
<div id="u161_rtf"></div>
</div>
</div>
<div id="u162" class="u162_container"   >
<div id="u162_img" class="u162_normal detectCanvas"></div>
<div id="u163" class="u163" style="visibility:hidden;"  >
<div id="u163_rtf"></div>
</div>
</div><div id="u164" class="u164" >
<DIV id="u164_line" class="u164_line" ></DIV>
</div>
<div id="u165" class="u165"  >
<div id="u165_rtf"><p style="text-align:left;"><span style="font-family:宋体;font-size:36px;font-weight:bold;font-style:normal;text-decoration:none;color:#333333;">高级搜索</span></p></div>
</div>
<DIV id="u166" style="border-style:dotted; border-color:red; visibility:hidden; position:absolute; left:3px; top:5px; width:1096px; height:97px;;" ></div>
<div id="u167" class="u167"  >
</div>
<div class="preload"><img src="kmsResources/u1_normal.png" width="1" height="1"/><img src="kmsResources/u3_normal.png" width="1" height="1"/><img src="kmsResources/u7_selected.png" width="1" height="1"/><img src="kmsResources/u7_normal.png" width="1" height="1"/><img src="kmsResources/u16_normal.JPG" width="1" height="1"/><img src="kmsResources/u151_normal.png" width="1" height="1"/><img src="kmsResources/u153_normal.png" width="1" height="1"/><img src="搜索头部_files/u160_normal.png" width="1" height="1"/><img src="搜索头部_files/u162_normal.png" width="1" height="1"/><img src="搜索头部_files/u164_line.png" width="1" height="1"/></div>
</body>
<script src="kmsResources/axurerp_pagescript.js"></script>
<script src="kmsResources/axurerp_pagespecificscript.js" charset="utf-8"></script>