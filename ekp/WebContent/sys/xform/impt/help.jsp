<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<%@page import="com.landray.kmss.framework.plugin.core.config.IExtension"%>
<%@page import="com.landray.kmss.sys.xform.impt.SysFormImportPlugin"%>
<%@page import="com.landray.kmss.framework.service.plugin.Plugin"%>
<template:include ref="default.dialog">
	<template:replace name="head">
		<script type="text/javascript">
			Com_IncludeFile("jquery.js");
		</script>
		<script type="text/javascript">
			$(document).ready(function(){
				var maxHeight = $(document.body).height();
				var windowHeight = $(window).height();
				$(".help_content img").click(function(evt){
						var imgvar = $("#_imgShow");
						if(imgvar.length == 0){
							imgvar = $("<div id='_imgShow' class='imgShow'></div>");
							imgvar.appendTo($(document.body));
							imgvar.click(function(){
								imgvar.hide();
							});
						}
						imgvar.empty();
						var imgtmp = $('<img src="' + $(this).attr("src") + '"/>');
						imgvar.append(imgtmp);
						imgvar.show();
						imgvar.css({"height":maxHeight + 'px'});
						imgtmp.css({"top":($(document).scrollTop() + ($(window).height()-imgtmp.height())/2) + 'px',
							"left":($(document).scrollLeft() + ($(window).width()-imgtmp.width())/2 ) + 'px'});
					});
			});
		
		</script>
		<style type="text/css">
			body{margin: 0px 15px;}
			.help_title{font-weight: bold;}
			.help_content{}
			.help_content img{
				border: 1px solid #c6c6c6;
				max-width: 300px;
			}
			.imgShow{
				position: absolute;
				top:0px;
				left:0px;
				height: 100%;
				width: 100%;
				background-color:rgba(108,108,108,0.8);
				z-index: 10;
				text-align: center;
				vertical-align: middle;
			}
			.imgShow img{
				position: absolute;
			}
		</style>
	</template:replace>
	<template:replace name="content"> 
			<center><h2>excel导入模板格式说明</h2></center>
			
			<p> &nbsp;&nbsp; 使用excel导入xform控件，需要定义控件标识，以下为所有已支持导入功能的控件，在excel中的内容填充说明
			(<a href="<c:url value='/sys/xform/import.do?method=modelExport'/>" style="color: red;">样例下载</a>)。</p>
			<div class="help_content">
				<%
					IExtension[] exts = SysFormImportPlugin.getParserExtensions();
					for (int i = 0; i < exts.length; i++) {
						IExtension extension = exts[i];
						String extName = (String)Plugin.getParamValue(extension,SysFormImportPlugin.IMPORT_ITEM_NAME);
						String extFilePath = (String)Plugin.getParamValue(extension,SysFormImportPlugin.IMPORT_ITEM_HELP);
						String extType = (String)Plugin.getParamValue(extension,SysFormImportPlugin.IMPORT_ITEM_TYPE);
						pageContext.setAttribute("extFilePath",extFilePath);
						pageContext.setAttribute("extType",extType);
						pageContext.setAttribute("extName",extName);
				%>
					<br/><div id='help_${extType}' class='help_title'>${extName}控件</div>
					<div id='help_${extType}_content' class='help_content'>
						<table class="tb_normal" style="width: 100%;table-layout:fixed;">
							<tr  class="tr_normal_title" style="width:100%">
								<td style="width:25%;min-width:25%">
									规则说明
								</td>
								<td style="width:37.5%;min-width:37.5%">
									excel控件定义样例
								</td>
								<td style="width:37.5%;min-width:37.5%">
									效果概览
								</td>
							</tr>
							<c:import url="${extFilePath}" charEncoding="UTF-8"></c:import>
						</table>
					</div>
				<%
					}
				%>
			</div>
			<br/>
	</template:replace>
</template:include>
