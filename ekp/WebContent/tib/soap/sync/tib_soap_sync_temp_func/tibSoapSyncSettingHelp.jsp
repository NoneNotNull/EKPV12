<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="/WEB-INF/kmss-xform.tld" prefix="xform"%>
<%@ page import="com.sunbor.web.tag.Page" %>
<%@ include file="/resource/jsp/view_top.jsp"%>
<script type="text/javascript">
Com_IncludeFile("optbar.js|list.js");
</script>
<script>
 function expandMethod(imgSrc,divSrc) {
	var imgSrcObj = document.getElementById(imgSrc);
	var divSrcObj = document.getElementById(divSrc);
	if(divSrcObj.style.display!=null && divSrcObj.style.display!="") {
		divSrcObj.style.display = "";
		imgSrcObj.src = "${KMSS_Parameter_StylePath}icons/collapse.gif";
	}else{
		divSrcObj.style.display = "none";
		imgSrcObj.src = "${KMSS_Parameter_StylePath}icons/expand.gif";		
	}
 }

 List_TBInfo = new Array(
			{TBID:"List_ViewTable1"},{TBID:"List_ViewTable2"},{TBID:"List_ViewTable3"}
		);
</script>

<div id="optBarDiv"><input type="button"
	value="<bean:message key="button.close"/>" onclick="Com_CloseWindow();">
</div>
<style type="text/css">
<!-- 
.first{
 text-indent: 0em; 
 hover:background-color:yellow;
}
.second{
 text-indent: 4em;
}
.third{
 text-indent: 6em;
}
-->
</style>
<p class="txttitle">【配置定时任务帮助】</p>
<center>
<table class="tb_normal" width=95%>
	<tr>
		<td class="td_normal_title" width=15%>一般性步骤</td>
		<td width="85%"><img id="viewSrc1"
			src="${KMSS_Parameter_StylePath}icons/expand.gif" border="0"
			onclick="expandMethod('viewSrc1','paramDiv1')" style="cursor: hand"><br>
		<div id="paramDiv1">
		<table id="List_ViewTable1" class="tb_noborder">
			<tr>
				<sunbor:columnHead htmlTag="td">
					<td colspan="2" align="center">【配置定时任务的一般性步骤】</td>
				</sunbor:columnHead>
			</tr>
			<tr>
				<td  width="7%" align="center">1</td>
				<td align="left">配置系统的RDB数据源</td>
			</tr>
			<tr>
				<td align="center">2</td>
				<td align="left">在函数管理中配置抽取需要的SOAP函数</td>
			</tr>
			<tr>
				<td align="center">3</td>
				<td align="left">在当前页面配置定时任务：<br>
				  a)选择函数<br>
				   b)选择数据源<br>
				    c)若SOAP中的数据和RDB有关联，则需要先选择数据库表，<br>再在映射字段中选择数据库表的列名
				</td>
			</tr>
			
			
			</table>
			</div>
			</td>
			</tr>
			
			<tr>
		<td class="td_normal_title" width=15%>名词解释</td>
		<td width="85%"><img id="viewSrc2"
			src="${KMSS_Parameter_StylePath}icons/expand.gif" border="0"
			onclick="expandMethod('viewSrc2','paramDiv2')" style="cursor: hand"><br>
		<div id="paramDiv2">
		<table id="List_ViewTable2" class="tb_noborder">
			<tr>
				<sunbor:columnHead htmlTag="td">
					<td colspan="3" align="center">【名词解释】</td>
				</sunbor:columnHead>
			</tr>
			<tr>
				<td  width="7%" align="center">1</td>
				<td align="left">传入参数</td>
				<td  align="left">指执行定时任务时，传递到SOAP中的数据</td>
			</tr>
			<tr>
				<td align="center">2</td>
				<td align="left">传出参数</td>
				<td  align="left">指执行定时任务时，从SOAP返回的数据</td>
			</tr>
			<tr>
				<td align="center">3</td>
				<td align="left">映射字段</td>
				<td  align="left">可以选择数据库表列、固定值、最后更新时间、当前执行时间。</td>
			</tr>
			<tr>
				<td align="center">4</td>
				<td align="left">数据库表列</td>
				<td  align="left">在所选的数据库表中列名，与SOAP字段对应</td>
			</tr>
			<tr>
				<td align="center">5</td>
				<td align="left">固定值</td>
				<td  align="left">仅在传入参数或者传入表格中存在，可将配置的固定值传输到SOAP中</td>
			</tr>
			<tr>
				<td align="center">6</td>
				<td align="left">最后执行时间</td>
				<td  align="left">仅在传入参数或者传入表格中存在，将当前定时任务上次执行的时间传输到SOAP中，若是第一次执行则传空值</td>
			</tr>
			<tr>
				<td align="center">7</td>
				<td align="left">最后更新时间</td>
				<td  align="left">将定时任务执行时的当前服务器时间传输到SOAP中。</td>
			</tr>
			<tr>
				<td align="center">8</td>
				<td align="left">映射备注</td>
				<td  align="left">无业务意义。仅为了对配置的字段进行说明。</td>
			</tr>
			</table>
			</div>
			</td>
			</tr>
			
			<tr>
		<td class="td_normal_title" width=15%>同步方式&主键&KEY</td>
		<td width="85%"><img id="viewSrc3"
			src="${KMSS_Parameter_StylePath}icons/expand.gif" border="0"
			onclick="expandMethod('viewSrc3','paramDiv3')" style="cursor: hand"><br>
		<div id="paramDiv3">
		<table id="List_ViewTable3" class="tb_noborder">
			<tr>
				<sunbor:columnHead htmlTag="td">
					<td colspan="3" align="center">【同步方式&主键&KEY】</td>
				</sunbor:columnHead>
			</tr>
			<tr>
				<td width="7%" align="center">1</td>
				<td align="left">【全量】</td>
				<td align="left">不需要选择主键或者KEY。每次同步时，会将RDB中的数据全部删除，再将SOAP的数据全部插入</td>
			</tr>
			<tr>
				<td align="center">2</td>
				<td align="left">【增量】</td>
				<td align="left">需要选择至少一个主键。每次同步时，系统根据主键将SOAP和RDB的数据进行比对，若RDB中无数据，则插入，有则更新。</td>
			</tr>
			<tr>
				<td align="center">3</td>
				<td align="left">【增量（插入前删除）】</td>
				<td align="left">需要至少选择一个KEY。每次同步时，系统会遍历SOAP传输过来的数据，以KEY去RDB中寻找对应数据，并全部删除。<br>系统再将SOAP传入过来的数据全部插入到RDB中。</td>
			</tr>
			<tr>
				<td align="center">4</td>
				<td align="left">【增量（时间戳）】</td>
				<td align="left">需要选择时间戳列（来自SOAP字段）和至少一个主键。每次同步时，系统会将时间戳列于定时任务最后执行时间作比对，<br>如该数据的时间戳列>定时任务最后执行时间，则将数据按照【增量】的方式同步到RDB中。</td>
			</tr>
			<tr>
				<td align="center">5</td>
				<td align="left">【增量（条件删除】</td>
				<td align="left">需要配置条件公式和选择至少一个KEY。每次同步时，系统根据配置的条件公式去判断SOAP传输出来的数据，若满足，<br>则该数据为需要删除的数据。系统用该数据的KEY去RDB中寻找并删除。然后再将SOAP中传输出来的不<br>满足条件的数据，以【增量】的方式同步到RDB中。</td>
			</tr>
			<tr>
				<td align="center">6</td>
				<td align="left">【<img alt="" src="${KMSS_Parameter_StylePath}calendar/finish.gif"> 一键匹配】</td>
				<td align="left">一种便捷配置方式。系统将SOAP的字段名称和数据库表列名作比对，若相等，则帮助用户自动选择右边的数据库表列。</td>
			</tr>
			
			</table>
			</div>
			</td>
			</tr>
			
			
			
			
			
</table>
</center>


<%@ include file="/resource/jsp/view_down.jsp"%>