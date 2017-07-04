<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
	<%@ include file="/resource/jsp/htmlhead.jsp" %>
	<%
		String attSerUrl = ResourceUtil.getKmssConfigString("sys.att.attservurl");
	%>
	<style type="text/css">
			body{
			   margin-top: 0px;
			}
			#kFileClientDiv{
				width: 100%;
				height: 90%;
			}
			#optArea{
			    position:absolute;
				width: 100%;
				display: none;
			}
			
			#unInstallDiv{
				font-size:12px;
				display:none;
				width: 100%;
   				height: 30px; 
   				text-align:center; 
   				background:#CCCCCC; line-height:30px;
			}
			
			#unInstallDiv a{
				color: blue;
			}
			.btnopt{
				color: #003048; 
				background: #C4E5FA; 
				height: 18px;
				padding: 0px 1px 0px 1px; 
				border: 1px #0066CC solid;
				letter-spacing: 1px; 
				cursor: pointer;
			}
	</style>
	<script type="text/javascript">
		var S_Att_ParentParam = null;
		var tmpVar = '${param.jsname}';
		if(tmpVar!=null && tmpVar!='' )
			S_Att_ParentParam = window.parent[tmpVar];
		var S_Att_ServerUrl = "";
		var S_Att_LocalUrl = ""; 
		var uploadArr = new Array();

		Com_IncludeFile("xml.js");

		//不同浏览器加载flash差异
		function showFileClient(){
			//获取服务器配置
			S_Att_ServerUrl = '<%=attSerUrl==null?"":attSerUrl%>';
			S_Att_LocalUrl  =	location.protocol + "//" + location.host + Com_Parameter.ContextPath;
			if(S_Att_ServerUrl==null || S_Att_ServerUrl=="")
				S_Att_ServerUrl = S_Att_LocalUrl;
			if(S_Att_ServerUrl.lastIndexOf("/")!=(S_Att_ServerUrl.length-1))
				S_Att_ServerUrl = S_Att_ServerUrl + "/";
			//加载flash控件
			var kFileArea = document.getElementById("kFileClientDiv");
			var htmlVar= new Array();
			if(kFileArea!=null){
				if(Com_Parameter.IE){
					htmlVar.push('<object classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000" width="100%" height="100%" id="kFileClient">');
					htmlVar.push('<param name="movie" value="kFileClient.swf" />');
					htmlVar.push('<param name="quality" value="high" />');
					htmlVar.push('<param name="bgcolor" value="#ffffff" />');
					htmlVar.push('<param name="allowScriptAccess" value="sameDomain" />');
					htmlVar.push('<param name="allowFullScreen" value="true" />');
					htmlVar.push('</object>');
				}else{
					htmlVar.push('<embed id="kFileClient" width="100%" height="100%" src="kFileClient.swf" quality="high" allowFullScreen=true>');
					htmlVar.push('</embed>');
				}
				kFileArea.innerHTML = htmlVar.join('');
			}
			if(S_Att_ParentParam!=null)
				S_Att_ParentParam.fdBigAttUploaded = false;
			var optButon = document.getElementById("optArea");
			optButon.style.display = "block";
			optButon.style.top = (document.body.offsetHeight-20) + "px";
		}
		
		//渲染附件上传效果,在flash加载时调用
		function onFlashReady(){
			var swf = document.getElementById("kFileClient");
			swf.render();
		}
		
		//设置附件上传控件参数信息
		function onFlashLoaded(){
			var swf = document.getElementById("kFileClient");
			var dataArr = new Array();
			dataArr.push("<data>");
			dataArr.push("<uploadConfig>");
			dataArr.push("  <maxFileSize>2</maxFileSize>");//默认2G
			dataArr.push("  <fileFilters>");
			dataArr.push("    <filter name=\"所有文件\"><![CDATA[*]]></filter>");
			dataArr.push("  </fileFilters>");
			dataArr.push("  <serviceURL><![CDATA[" + S_Att_ServerUrl + "sys/attachment/uploaderServlet]]></serviceURL>");
			dataArr.push("  <verifyServiceURL><![CDATA[" + S_Att_LocalUrl + "sys/attachment/sys_att_main/sysAttMain.do?method=handleAttUpload"+
					"&fdKey=" + S_Att_ParentParam.fdKey +"&fdModelName=" + S_Att_ParentParam.fdModelName 
					+ "&fdModelId=" + S_Att_ParentParam.fdModelId+"]]></verifyServiceURL>");
			dataArr.push("</uploadConfig>");
			dataArr.push("</data>");
			swf.setConfig(dataArr.join(''));
		}
		//错误信息显示
		function errorHandler(xmlStr){
			var xml = XML_CreateByContent(xmlStr);
			var ret = xml.getElementsByTagName("return")[0];
			var status = ret.getElementsByTagName("status")[0].firstChild.nodeValue;
			var msg = ret.getElementsByTagName("msg")[0].firstChild.nodeValue;
			if(""+status+"):"!="1):"){
				alert(msg);
			}
		}
		//未安装air或kFileClient客户端时，调用此方法
		function uninstall(){
			var summaryDiv = document.getElementById("unInstallDiv");
			summaryDiv.style.display = "block";
			var plat = navigator.platform;
			var downloadUrl = "";
			if(plat.toLowerCase().indexOf("win")>-1)
				downloadUrl = S_Att_ServerUrl + "sys/attachment/swf/kFileUploader.zip";
			else
				downloadUrl = S_Att_ServerUrl + "sys/attachment/swf/kFileUploader.air";
			summaryDiv.innerHTML = "检测到您当前操作系统未安装附件上传控件，请&nbsp;<a href='" + downloadUrl + "'>下载</a>&nbsp;安装。";
		}
		
		//单附件上传完毕后，调用此方法	
		function fileUploadComplete(xmlStr){
			xmlStr = "&"+xmlStr;
			var attid  =  Com_GetUrlParameter(xmlStr,"filekey");;
			var attname = Com_GetUrlParameter(xmlStr,"filename");
			var attsize = Com_GetUrlParameter(xmlStr,"filesize");
			var atttype = "byte";	
			uploadArr[uploadArr.length] = {"attid":attid,"attname":attname,"attsize":attsize,"atttype":atttype};
		}
		
		function addToDoc(){
			if(S_Att_ParentParam!=null){
				for(var i =0 ;i<uploadArr.length;i++){
					var uploadObj = uploadArr[i];
					S_Att_ParentParam.addDoc(uploadObj["attname"],'SWFUpload_big_'+(i+1),1,uploadObj["atttype"],uploadObj["attsize"],uploadObj["attid"]);
				}
				S_Att_ParentParam.show();
				if(S_Att_ParentParam.bigAttFrameObj!=null)
					S_Att_ParentParam.bigAttFrameObj.close();
			}
		}
		Com_AddEventListener(window, "load",showFileClient);
	</script>
</head>
<body>
	<div id="unInstallDiv"></div>	
	<div id="kFileClientDiv"></div>
	<div id="optArea"><input class="btnopt" style="float:right;margin-right: 15px;" type="button" value='<bean:message key="button.ok"/>' onclick="addToDoc();"/></div>
</body>
</html>