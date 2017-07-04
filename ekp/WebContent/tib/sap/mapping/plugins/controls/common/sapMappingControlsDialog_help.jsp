<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="/WEB-INF/kmss-xform.tld" prefix="xform"%>
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

<p class="txttitle">使用说明</p>
<center>
<table class="tb_normal" width=95%>
	<tr>
		<td class="td_normal_title" width=15%>说明</td>
		<td width="85%"><img id="viewSrc1"
			src="${KMSS_Parameter_StylePath}icons/expand.gif" border="0"
			onclick="expandMethod('viewSrc1','paramDiv1')" style="cursor: hand"><br>
		<div id="paramDiv1">
		<table id="List_ViewTable1" class="tb_noborder">
			<tr>
				<sunbor:columnHead htmlTag="td">
					<td width="30pt">序号</td>
				    <td width="20%">关键符号</td>
				    <td width="70%">说明</td>
				</sunbor:columnHead>
			</tr>
			<tr>
				<td align="center">1</td>
				<td>$xx$</td>
				<td>
				  $$ 2个美元符号包裹住的属于SAP BAPI函数字段名称，区分大小写<br>
				  如$PERNR$ 属于PERNR 字段值,后端会把这样形式字符串解析成定时任务跑动时候的该字段的值
				</td>
			</tr>
			<tr>
				<td align="center">2</td>
				<td>a.equals(b)</td>
				<td>
				  字符串比较函数,用来判断a,b的字符值是否相等
				</td>
			</tr>
			<tr>
			<td colspan="3">
			   因为后台目前只支持转化成字符串String类型,所以$PERNR$ 会强制转化成字符类型来比对,过滤相关信息<br>
			  不可待全角半角符号：；“《》。，／？－＝、！
			</td>
			
			</tr>
			<tr>
			<td colspan="1">
			  增量(条件删除)
			</td>
			<td colspan="2">
			   增量(条件删除)描述：定时任务会先把SAP导入的批量数据,翻查数据库中是否存在  根据前端配置的key 的数据先进行删除<br>
			  然后再把这批 SAP数据进行条件过滤，再导入数据库<br>
			  例如：<br>
			  数据库中存在<br>
             pernr：001, begda：2011-12-12 ,endda:2011-12-15<br>
             pernr：002, begda：2011-12-12 ,endda:2011-12-15<br>
             pernr：003, begda：2011-12-15 ,endda:2011-12-18<br>
			 导入数据中存在：<br>
			 pernr：001, begda：2011-12-12 ,endda:2011-12-14<br>
             pernr：002, begda：2011-12-12 ,endda:2011-12-15<br>
             pernr：003, begda：2011-12-15 ,endda:2011-12-20<br>
			 过滤条件：<br>
			 begda.equals("2011-12-12")<br>
			 最后数据库中拥有的数据：<br>
			   pernr：003, begda：2011-12-15 ,endda:2011-12-20<br>
			</td>
			
			</tr>
			
			
			
		</table></div>
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>样例</td>
		<td width="85%"><img id="viewSrc2"
			src="${KMSS_Parameter_StylePath}icons/expand.gif" border="0"
			onclick="expandMethod('viewSrc2','paramDiv2')" style="cursor: hand"><br>
		<div id="paramDiv2">
		<table id="List_ViewTable2" class="tb_noborder">
			<tr>
				<sunbor:columnHead htmlTag="td">
					<td width="30pt">序号</td>
				    <td width="30%">样例代码</td>
				    <td width="50%">样例说明</td>
				</sunbor:columnHead>
			</tr>
			<tr>
				<td align="center">1</td>
				<td>$PERNR$.equals("0001")</td>
				<td>
				 判断这个BAPI函数PERNR字段的字符串值是否等于0001,如果true 的话进行过滤,不导入数据库中
				</td>
			</tr>
			<tr>
				<td align="center">2</td>
				<td>!$PERNR$.equals("0001")</td>
				<td>
				 判断这个BAPI函数PERNR字段的字符串值不等于0001,如果true 的话进行过滤,不导入数据库中
				</td>
			</tr>
			<tr>
				<td align="center">3</td>
				<td>$PERNR$.equals($PERNR1$)</td>
				<td>
				 判断这个BAPI函数PERNR字段的字符串值是否等于PERNR1,如果true 的话进行过滤,不导入数据库中
				</td>
			</tr>
			<tr>
				<td align="center">4</td>
				<td>$PERNR$.equals($PERNR1$)&&($BEGDA$.equals("2011-12-14")||$ENDA$.equals("2012-12-14"))</td>
				<td>
				 判断这个BAPI函数PERNR字段的字符串值是否等于PERNR1,并且  <br>
				( 判断  BEGDA字段是否等于2011-12-14或者ENDA字段是否等于2012-12-14) 
				</td>
			</tr>
			
			
			<tr>
			<td colspan="3">
			后端先回对这段java 片段的美元符号进行解析,在对解析出来的片段进行java解析,把结果放到if(result){}<br>
			去进行一个过滤操作,语句过于复杂会导致导入时候缓慢,慎用
			</td>
			</tr>
		</table></div>
		</td>
	</tr>
</table>
</center>


<%@ include file="/resource/jsp/view_down.jsp"%>