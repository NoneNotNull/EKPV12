<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="com.landray.kmss.sys.search.web.SearchConditionEntry" %>
<%@ include file="/resource/jsp/edit_top.jsp"%>
<center>
<p class="txttitle"><c:out value="${searchConditionInfo.title}" /></p>
<form name="searchConditionForm" onsubmit="return false;">
<table width=95% class="tb_normal" id="TB_Condition">
	
	<tr>
		<tr kmss_type="string">
			<td width="15%">
				原词
			</td>
			<td>
				<input name="v0_0" style="width:90%" class="inputSgl" value="">
			</td>
			<td style="display:none">
			</td>
			<td width="100px">
				<input name="vv_0" type="checkbox" onclick="refreshReadonlyDisplay(this);" >搜索空值
			</td>
		</tr>
		
		<tr kmss_type="string">
			<td width="15%">
				同义词
			</td>
			<td>
				<input name="v0_3" style="width:90%" class="inputSgl" value="">
			</td>
			<td style="display:none">
			</td>
			<td width="100px">
				<input name="vv_3" type="checkbox" onclick="refreshReadonlyDisplay(this);" >搜索空值
			</td>
		</tr>
	</tr>
	
	<%@ include file="/sys/search/search_condition_entry.jsp"  %>
	<c:if test="${searchConditionInfo.conditionUrl!=null}">
		<c:import url="${searchConditionInfo.conditionUrl}" charEncoding="UTF-8"/>
	</c:if>
	
</table>
<br>


<input type="button" value="<bean:message key="button.search"/>" onclick="CommitSearch();" />
&nbsp;&nbsp;&nbsp;&nbsp;
<input type="reset" value="<bean:message key="button.reset" />" onclick="resetDisplay()" />
</form>
</center>
<%@ include file="/resource/jsp/edit_down.jsp"%>