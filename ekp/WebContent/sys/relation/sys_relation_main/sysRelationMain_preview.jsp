<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page errorPage="/resource/jsp/jsperror.jsp" %>
<%@ include file="/resource/jsp/htmlhead.jsp" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<script type="text/javascript">
	Com_IncludeFile("document.js", "style/"+Com_Parameter.Style+"/doc/");
	Com_IncludeFile("data.js|jquery.js", null, "js");
</script>
<script type="text/javascript">
var dialogObject = null;
if(window.showModalDialog){
	dialogObject = window.dialogArguments;
}else{
	dialogObject = opener.Com_Parameter.Dialog;
}
//根据iframe里面内容高度，自动调整iframe窗口高度以及整个弹出窗口的高度
function dyniFrameSize(iframe) {
	var _iframe = iframe || "IF_sysRelation_content";
    var pTar = null;
    if (document.getElementById) {
        if (typeof _iframename == "string") {
			pTar = document.getElementById(_iframe);
        } else {
        	pTar = _iframe;
		}
    } else{
  	  	eval('pTar = ' + _iframe + ';');
    }
	try {
	    if (pTar && !window.opera) {
	        //begin resizing iframe
	        pTar.style.display = "block";
	        if (pTar.contentDocument && pTar.contentDocument.body.offsetHeight) {
	        	//ns6 syntax
				pTar.height = pTar.contentDocument.body.offsetHeight+20;
				//pTar.width = pTar.contentDocument.body.scrollWidth+20;
	        } else if (pTar.Document && pTar.Document.body.scrollHeight){
	       	 	//ie5+ syntax
				pTar.height = pTar.Document.body.scrollHeight;
				//pTar.width = pTar.Document.body.scrollWidth;
				// 调整父Iframe
				if ("${param.frameName}" != "") {
					if (parent.document.getElementById("${param.frameName}")) {
						parent.document.getElementById("${param.frameName}").style.height=document.body.scrollHeight+7;
					}
				}
	        }
	    }
	} catch(e) {
		pTar.width = "100%";
		pTar.height = "100%";
	}
}

var params = "";
//加载结果数据
function loadSysRelationEntiry(loadIndex,_this) {
	var param = params.split("&separator=0");
	param[loadIndex] += "&loadIndex="+loadIndex;
	var url = '<c:url value="/sys/relation/sys_relation_main/sysRelationMain.do" />'+'?method=preview' + param[loadIndex];
	var iframe = document.getElementById("IF_sysRelation_content");
	iframe.src = url;
	setBackground(_this);
}
function preview(){
	var url = Com_Parameter.ContextPath+'sys/relation/sys_relation_main/sysRelationMain.do?method=previewResultCount';
	if(window.dialogObject && window.dialogObject.relationEntry){
		params = window.dialogObject.relationEntry.p;
	}
 	$.ajax({
	 	type: "POST",
	   	url: url,
	    async:true,
	    processData: false,
	    data: params+"&loadIndex=0",
	    dataType:'html',
	    success: function(resHtml){
		 	document.getElementById("count").innerHTML = resHtml;
			var aTagObj = document.getElementById("count").getElementsByTagName("a")[0];
			if(aTagObj)
				aTagObj.style.backgroundColor = "yellow";
	    }
	 });
	loadSysRelationEntiry(0);//默认加载第一项
}
function setBackground(_this){
	var aTagList = document.getElementById("count").getElementsByTagName("a");
	for(var i=0;i<aTagList.length;i++){
		aTagList[i].style.backgroundColor = "";
	}
	if(_this)
		_this.style.backgroundColor = "yellow";
}
Com_AddEventListener(window, "load", preview);
</script>
</head>
<body style="background-color: transparent">
<p class="txttitle"><br><bean:message bundle="sys-relation" key="sysRelationMain.previewResult" /></p>
<table id="tb_normal" width=95% height="80%">
<tr>
	<td width="20%" valign="top" nowrap="nowrap" style="text-align: left;padding-left: 5px;">
		<span id="count" style="line-height: 18px;"></span>
	</td>
	<td style="position: relative;border-left: 1px solid rgb(225, 225, 225);" valign="top">
		<iframe id="IF_sysRelation_content" allowTransparency="true" width="100%" height="100%" marginheight="0" marginwidth="0" scrolling=no frameborder=0 onload="dyniFrameSize(this);"></iframe>
	</td>
</tr>
</table>
</body>
</html>
		
