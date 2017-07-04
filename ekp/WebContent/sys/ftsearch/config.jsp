<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/common.jsp"%>

<%@page import="com.landray.kmss.framework.plugin.core.config.IExtension"%>
<%@page import="com.landray.kmss.framework.service.plugin.Plugin"%>
<script type="text/javascript"> 
	function config_aloneSearch(){
		var isNotDisplayIdsEnabled = document.getElementsByName("value(kmss.ftsearch.aloneSearch.enabled)")[0];	
		if(isNotDisplayIdsEnabled.checked){
			document.getElementById("serverURL").style.display = "";
			document.getElementsByName("value(kmss.ftsearch.notLocalSearch)")[0].value = true;
		}else{
			document.getElementById("serverURL").style.display = 'none';
			document.getElementsByName("value(kmss.ftsearch.notLocalSearch)")[0].value = false;
		}
		var notDisplayServerURL = document.getElementsByName("value(kmss.ftsearch.aloneSearch.url)")[0];
		notDisplayServerURL.disabled = !isNotDisplayIdsEnabled.checked;
	}

	function config_engineType(){
		var engineType = document.getElementsByName("value(sys.ftsearch.config.engineType)")[0];	
		if(engineType.value == "lucene"||engineType.value == ""){
			document.getElementById("autonomyId").style.display = 'none';
			document.getElementById("elasticSearchId").style.display = 'none';
		}
		else if(engineType.value == "elasticsearch"){
			document.getElementById("autonomyId").style.display = 'none';
			document.getElementById("elasticSearchId").style.display = "";
		}
		else if(engineType.value == "autonomy"){
			document.getElementById("autonomyId").style.display = "";
			document.getElementById("elasticSearchId").style.display = 'none';
		}
	}

	function config_autonomy_openDialog(){
			var sheight = screen.availHeight;
			var swidth = screen.width;
			var style = "dialogWidth:"+swidth+"px; dialogHeight:"+sheight+"px; status:1; help:0; resizable:1";
			var url = "<c:url value="/resource/jsp/frame.jsp"/>";
				url = Com_SetUrlParameter(url, "url","<c:url value='/third/autonomy/autonomyServerConfig.do?method=load'/>");
			var rtnVal = window.showModalDialog(url, null, style);
	}

	function config_onesearch_openDialog(){
		var sheight = screen.availHeight;
		var swidth = screen.width;
		var style = "dialogWidth:"+swidth+"px; dialogHeight:"+sheight+"px; status:1; help:0; resizable:1";
		var url = "<c:url value="/resource/jsp/frame.jsp"/>";
			url = Com_SetUrlParameter(url, "url","<c:url value='/third/ftsearch/onesearchConfig.do?method=load'/>");
		var rtnVal = window.showModalDialog(url, null, style);
	}

	function init(){
		config_aloneSearch();
		config_engineType();
	}

	config_addOnloadFuncList(init);
</script>
<table class="tb_normal" width=100% id="config_ftsearch">
	<tr>
		<td class="td_normal_title" colspan=2>
			<b>
				全文索引配置选项
			</b>
		</td>
	</tr>
	 
	<tr>
		<td class="td_normal_title" width="15%">全文索引定时任务最长运行时间</td>
		<td>
			<xform:text property="value(kmss.ftsearch.maxruntime)" subject="全文索引定时任务最长运行时间" validators="required number" required="true"  style="width:150px" showStatus="edit" /><br>
			<span class="message">全文索引定时任务最长运行时间，单位为秒。一般设置为8小时(28800)。</span>
		</td>
	</tr>
	
	<tr>
		<td class="td_normal_title" width="15%">全文索引定时任务线程数</td>
		<td>
			<xform:text property="value(kmss.ftsearch.indexthreadnum)" subject="全文索引定时任务线程数" validators="required number" required="true"  style="width:150px" showStatus="edit" /><br>
			<span class="message">全文索引定时任务线程数，默认为1，不要设置太多，以免影响其他业务。</span>
		</td>
	</tr>
	
	
	<tr> 
		<td class="td_normal_title" width="15%">全文检索服务引擎</td>
		<td> 
			<xform:select property="value(sys.ftsearch.config.engineType)" showStatus="edit" onValueChange="config_engineType" showPleaseSelect="false">
					<%
						IExtension[] extensions = Plugin.getExtensions("com.landray.kmss.sys.ftsearch.engineType","*","ftsearch");
						if(extensions != null){
							for(IExtension extension : extensions){
								String serviceName = Plugin.getParamValueString(extension,"serviceName");
								String serviceDesc = Plugin.getParamValueString(extension,"serviceDesc");
								request.setAttribute("name",serviceName);
								request.setAttribute("value",serviceDesc);
						%>
								
					<xform:simpleDataSource value="${name}">${value}</xform:simpleDataSource>		
				<%}}%>
			</xform:select>
		</td>
	</tr>
	
	<tr id="autonomyId" style="display:none">
		<td colSpan="2" align="center">
			<input type="button" class="btnopt" value="配置autonomy相关参数" onclick="config_autonomy_openDialog()"/>
		</td>
	</tr>
	
	<tr id="elasticSearchId" style="display:block">
		<td colSpan="2" align="center">
			<input type="button" class="btnopt" value="配置蓝凌统一搜索相关参数" onclick="config_onesearch_openDialog()"/>
		</td>
	</tr>
	
	<tr>
		<td class="td_normal_title" width="15%">搜索热词显示数量</td>
		<td>
			<xform:text property="value(kmss.ftsearch.hotwordNum)" subject="热词数量"  required="false"  style="width:150px" showStatus="edit" /><br>
			<span class="message">搜索热词显示数量，设置5-10个左右。默认5。</span>
		</td>
	</tr>
	
	<tr>
		<td class="td_normal_title" width="15%">相关搜索词显示数量</td>
		<td>
			<xform:text property="value(kmss.ftsearch.relevantWordNum)" subject="相关搜索词数量"  required="false"  style="width:150px" showStatus="edit" /><br>
			<span class="message">相关搜索词显示数量，设置5-15个左右。默认10。</span>
		</td>
	</tr>
	
	<tr>
		<td class="td_normal_title" width="15%">热词时间范围</td>
		<td>
			<xform:text property="value(kmss.ftsearch.hotword.timeframe)" subject="热词时间范围"  required="false"  style="width:150px" showStatus="edit" /><br>
			<span class="message">热词时间范围，7-90天左右,默认30，单位为天</span>
		</td>
	</tr>
	 
	<tr>
		<td class="td_normal_title" width="15%">是否禁用同义词搜索</td>
		<td>
			<xform:checkbox  property="value(kmss.ftsearch.synonyms.enabled)" dataType="boolean" 
				subject="禁用" htmlElementProperties="id=\"value(kmss.ftsearch.synonyms.enabled)\""  showStatus="edit">
				<xform:simpleDataSource value="true">禁用</xform:simpleDataSource>
			</xform:checkbox>
		</td>
	</tr>

	<tr id="aloneSearch" >
		<td class="td_normal_title" width="15%">是否启用独立搜索</td>
		<td>
			<html:checkbox property="value(kmss.ftsearch.aloneSearch.enabled)" value="true" onclick="config_aloneSearch()"/>启用(单独部署一应用作为搜索用或kms自定义的搜索才需要启用独立搜索，与统一搜索或其他搜索引擎均无关)
		</td>
	</tr>
	<tr id="serverURL" style="display:none">
		<td class="td_normal_title" width="15%">搜索服务地址</td>
		<td>
			<xform:text property="value(kmss.ftsearch.aloneSearch.url)" subject="搜索服务地址"  required="true"  style="width:400px" showStatus="edit" htmlElementProperties="disabled='true'"/><br>
			<span class="message">填写独立部署的搜索入口全路径url(默认填入如http://127.0.0.1:8080/ekp/sys/ftsearch/searchBuilder.do?method=search)。http还是https，ip，端口，项目上下文根据项目实施信息填写</span>
			<html:hidden property="value(kmss.ftsearch.notLocalSearch)"/>
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width="15%">autoCAD文件索引webservice服务地址</td>
		<td>
			<xform:text property="value(kmss.ftsearch.dwg.url)" subject="dwg文件索引webservice地址"  required="false"  style="width:300px" showStatus="edit"/><br>
			<span class="message">autoCAD附件提取需要第三方应用此项只在需要索引autoCAD附件时配置，dwg文件提取第三方webservice地址url(如http://192.168.5.196:16816/)。http还是https，ip，端口.</span>
		</td>
	</tr>
</table>
