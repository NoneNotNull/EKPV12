<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/common.jsp"%>
<script>
Com_IncludeFile("doclist.js|dialog.js|jquery.js");
function config_att_jg_pdfurl(){
	var isJGPDFEnabled = document.getElementsByName("value(sys.att.isJGPDFEnabled)")[0];	
	var jgpdfurl = document.getElementsByName("value(sys.att.jg.pdfurl)")[0];
	var jgpdfversion = document.getElementsByName("value(sys.att.jg.pdfversion)")[0];
	jgpdfurl.disabled = !isJGPDFEnabled.checked;
	jgpdfversion.disabled = !isJGPDFEnabled.checked;
	if (jgpdfurl.disabled) {
		KMSSValidation_HideWarnHint(jgpdfurl);
		document.getElementById("JGPDFConfig").style.display = "none";
	}else{
		document.getElementById("JGPDFConfig").style.display = "block";
	}
	if (jgpdfversion.disabled) {
		KMSSValidation_HideWarnHint(jgpdfversion);
	}		
}
function config_att_jg_mulurl(){
	var isJGMULEnabled = document.getElementsByName("value(sys.att.isJGMULEnabled)")[0];	
	var jgmulurl = document.getElementsByName("value(sys.att.jg.mulurl)")[0];
	var jgmulversion = document.getElementsByName("value(sys.att.jg.mulversion)")[0];
	jgmulurl.disabled = !isJGMULEnabled.checked;
	jgmulversion.disabled = !isJGMULEnabled.checked;
	if (jgmulurl.disabled) {
		document.getElementById("JGMULConfig").style.display = "none";
	}else{
		document.getElementById("JGMULConfig").style.display = "block";
	}
}

function config_img_size(thisObj){
	if(thisObj==null){
		var imageSizeObj=document.getElementsByName("value(sys.att.imageCompressSize)")[0];
		if(imageSizeObj.value=='')
			imageSizeObj.value = '1024';
	}
}

function config_bigatt(thisObj){
	if(thisObj==null){
		thisObj=document.getElementsByName("value(sys.att.useBigAtt)")[0];
		var maxSizeObj=document.getElementsByName("value(sys.att.smallMaxSize)")[0];
		if(maxSizeObj.value=='')
			maxSizeObj.value = '100';
	}else{
		if(thisObj.checked==true){
			document.getElementById("bigAttMsg").style.display = "block";
		}else{
			document.getElementById("bigAttMsg").style.display = "none";
	    }
	}
	var cfgAttServer=document.getElementById('lab_bigatt');
	if(thisObj.checked==true){
		cfgAttServer.style.display="";
	}else{
		cfgAttServer.style.display="none";
	}
}

function config_img_maxSize(){
	var obj = document.getElementsByName("value(sys.att.imageMaxSize)")[0];
	if(obj.value == '')
		obj.value = '5';
}

config_addOnloadFuncList(config_att_jg_pdfurl);
config_addOnloadFuncList(config_att_jg_mulurl);
config_addOnloadFuncList(config_bigatt);
config_addOnloadFuncList(config_img_size);
config_addOnloadFuncList(config_img_maxSize);
</script>
<table class="tb_normal" width=100%>
	<tr>
		<td class="td_normal_title" colspan=2><b>附件配置</b></td>
	</tr>
	<tr>
		<td class="td_normal_title" width="15%">附件存放位置</td>
		<td>
			<xform:text property="value(kmss.resource.path)" subject="文件路径" required="true" style="width:85%" showStatus="edit"/><br>
			<span class="message">
				文件（包括其他资源、临时文件、附件等）保存路径，例：windows环境为“c:/landray/kmss/resource”,linux和unix为“/usr/landray/kmss/resource”<br>
				如附件保存方式选择为文件方式，请保证该目录有足够的存储空间，集群环境下该目录请使用序列化共享存储设备
			</span>
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width="15%">普通附件大小限制</td>
		<td>
			<xform:text property="value(sys.att.smallMaxSize)" subject="普通附件大小限制" validators="number" required="false" style="width:150px" showStatus="edit"/><br>
			<span class="message">单个附件上传大小限制，例：100，单位：M &nbsp;&nbsp;&nbsp;</span>
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width="15%">图片附件大小限制</td>
		<td>
			<xform:text property="value(sys.att.imageMaxSize)" subject="图片附件大小限制" validators="number" style="width:150px" showStatus="edit"/><br>
			<span class="message">图片附件上传大小限制，例：5，单位：M &nbsp;&nbsp;&nbsp;</span>
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width="15%">RTF图片压缩大小</td>
		<td>
			<xform:text property="value(sys.att.imageCompressSize)" subject="RTF图片压缩大小" required="true" style="width:150px" showStatus="edit"/><br>
			<span class="message">例：1024,默认设置为1024，如果上传图片宽度大于设定值，那么图片按照原图的宽度和该设定值的比例进行压缩；设置为0表示不压缩</span>
		</td>
	</tr>
	<tr style="display: none;">
		<td class="td_normal_title" width="15%">附件保存方式</td>
		<td>
			<xform:select property="value(sys.att.dao)" showStatus="edit" required="true">
				<xform:simpleDataSource value="fileAttMainDao">文件</xform:simpleDataSource>
				<xform:simpleDataSource value="dbAttMainDao">数据库</xform:simpleDataSource>
			</xform:select>
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width="15%">是否启用大附件上传</td>
		<td>
			<label style="float: left;">
				<html:checkbox property="value(sys.att.useBigAtt)" value="true" onclick="config_bigatt(this);"/>
					启用
			</label>
			<label style="color:red;display: none;float: left;padding-top: 3px"id="bigAttMsg">
			（注意：启用大附件上传功能需要客户端能够连接外网）
			</label><br><div style="clear: both;"></div>			
			<label id='lab_bigatt'>
				附件服务器地址：
				<xform:text property="value(sys.att.attservurl)" subject="附件服务器地址" style="width:85%" showStatus="edit"/><br/>
				<span class="message">
					为空表示为本服务器，配置样例：http://java.landray.com.cn:8080/ekp
				</span>
			</label>
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width="15%">是否启用加密附件</td>
		<td>
			<xform:radio property="value(sys.att.encryption.mode)" showStatus="edit" required="true">
				<xform:simpleDataSource value="0">不加密（不兼容加密附件）</xform:simpleDataSource>
				<xform:simpleDataSource value="1">加密（兼容不加密附件，稍微影响性能）</xform:simpleDataSource>
				<xform:simpleDataSource value="2">不加密（兼容加密附件，稍微影响性能）</xform:simpleDataSource>
			</xform:radio>
		</td>
	</tr>
	   
	<tr>
		<td class="td_normal_title" width="15%">是否启用金格控件</td>
		<td>
			<div id="JGConfig">
			<span style="font-weight:bold;">金格iWebOffice2009控件：支持在IE内核浏览器中在线打开、在线编辑和批注文档，支持对MS Office/WPS文档强制痕迹保留，支持OFFICE与WPS混用编辑
			</span><br>
			控件地址：
			<xform:text property="value(sys.att.jg.ocxurl)" subject="金格控件地址" style="width:85%" showStatus="edit" /><br>
			<span class="message">
				当您第一次启用金格控件以及控件版本更新，客户端IE访问时会提醒用户下载控件，同时访问人数过多将会造成系统阻塞，建议将控件放到其他能访问的服务器，等高峰期过后更改回来即可<br>
				控件地址为空将读取系统默认路径：/sys/attachment/plusin/iWebOffice2009.cab<br>
				控件地址格式：http://*******/iWebOffice2009.cab
			</span><br>
			控件版本号：
			<xform:text property="value(sys.att.jg.ocxversion)" subject="金格控件版本" style="width:35%" showStatus="edit" /><br>
			<span class="message">
				用于金格控件版本更新，输入的版本号高于当前安装的版本号，客户端IE会提示用户下载并更新控件。<br>
				例如：10,5,0,0
			</span>			
			<br></br>
			</div>
			
			<label style="float: left;">
				<html:checkbox property="value(sys.att.isJGPDFEnabled)" value="true" onclick="config_att_jg_pdfurl()"/>
				<span style="font-weight:bold;">启用金格iWebPDF控件：支持在IE内核浏览器中直接浏览PDF文档，提供对文档的打印、下载权限控制
				</span>
			</label><br><div style="clear: both;"></div>
			<div id="JGPDFConfig" style="display: none;">
			控件地址：
			<xform:text property="value(sys.att.jg.pdfurl)" subject="金格PDF控件地址" style="width:85%" showStatus="edit" htmlElementProperties="disabled='true'"/><br>
			<span class="message">
				当您第一次启用金格控件以及控件版本更新，客户端IE访问时会提醒用户下载控件，同时访问人数过多将会造成系统阻塞，建议将控件放到其他能访问的服务器，等高峰期过后更改回来即可<br>
				控件地址为空将读取系统默认路径：/sys/attachment/plusin/iWebPDF.cab<br>
				控件地址格式：http://*******/iWebPDF.cab
			</span><br>
			控件版本号：
			<xform:text property="value(sys.att.jg.pdfversion)" subject="金格PDF控件版本" style="width:35%" showStatus="edit" htmlElementProperties="disabled='true'"/><br>
			<span class="message">
				用于金格控件版本更新，输入的版本号高于当前安装的版本号，客户端IE会提示用户下载并更新控件。<br>
				例如：8,0,0,538
			</span><br></br>
			</div>	
			
			<label style="float: left;">
				<html:checkbox property="value(sys.att.isJGMULEnabled)" value="true" onclick="config_att_jg_mulurl()"/>
				<span style="font-weight:bold;">启用金格iWebPlugin多浏览器插件：支持在WIN平台上运行的Chrome、FireFox、Safari等主流浏览器中使用，必须结合iWebOffice或iWebPDF控件使用，如果独立使用则无任何功能效果。不支持Mac OS
				</span>
			</label><br><div style="clear: both;"></div>
			<div id="JGMULConfig" style="display: none;">
			控件地址：
			<xform:text property="value(sys.att.jg.mulurl)" subject="金格多浏览器控件地址" style="width:85%" showStatus="edit" htmlElementProperties="disabled='true'"/><br>
			<span class="message">
				金格多浏览器控件下载地址，注意由于是多浏览器，此控件无法自动升级.当您第一次启用金格多浏览器控件时，客户端访问时会提醒用户下载控件，访问人数过多将会造成系统阻塞，建议将控件放到其他能访问的服务器，等高峰期过后更改回来即可<br>
				控件地址为空将读取系统默认路径：/sys/attachment/plusin/iWebPlugin.zip<br>
				控件地址格式：http://*******/iWebPlugin.zip
			</span><br>
			版权支持信息：
			<xform:text property="value(sys.att.jg.mulversion)" subject="金格多浏览器控件版权信息" style="width:35%" showStatus="edit" htmlElementProperties="disabled='true'"/><br>
			<span class="message">
				金格多浏览器控件能否使用的授权信息，只有经过授权后方能使用，为空则默认的授权信息为：www.landray.com.cn。
			</span>
			</div>	
							
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width="15%">附件转换服务监听端口</td>
		<td>
			<xform:text property="value(sys.att.convert.listenport)" subject="附件转换服务监听端口" required="false" style="width:150px" showStatus="edit"/><br>
			<span class="message">例：5665,不是必须，没有设置时是默认为5665，一台机器部署多个系统的时候必须设置，并且各个系统不能相同，上下这两个也不能相同，此端口对应转换客户端中的kmss.converter.port设置的端口，两者必须一致</span>
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width="15%">附件转换服务处理客户端请求端口</td>
		<td>
			<xform:text property="value(sys.att.convert.processport)" subject="附件转换服务监听端口" required="false" style="width:150px" showStatus="edit"/><br>
			<span class="message">例：5656,不是必须，没有设置时是默认为5656，一台机器部署多个系统的时候必须设置，并且各个系统不能相同，上下这两个也不能相同，此端口对应转换客户端中的kmss.converter.processport设置的端口，两者必须一致</span>
		</td>
	</tr>
	<tr  style="display: none;">
		<td class="td_normal_title" width="15%">单个附件的最大长度</td>
		<td>
			<xform:text property="value(sys.att.singMaxSize)" subject="单个附件的最大长度" required="true" style="width:150px" showStatus="edit"/><br>
			<span class="message">例：100M，单位：M</span>
		</td>
	</tr>
	<tr style="display: none;">
		<td class="td_normal_title" width="15%">单个文档所有附件的最大长度</td>
		<td>
			<xform:text property="value(sys.att.totalMaxSize)" subject="单个文档所有附件的最大长度" required="true" style="width:150px" showStatus="edit"/><br>
			<span class="message">例：1000M，单位：M</span>
		</td>
	</tr>
</table>
 