<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="/WEB-INF/kmss-xform.tld" prefix="xform"%>
<%@ include file="/resource/jsp/view_top.jsp"%>
<script>
	function confirmDelete(msg){
	var del = confirm("<bean:message key="page.comfirmDelete"/>");
	return del;
}
</script>
<script type="text/javascript">
Com_IncludeFile("jquery.js|data.js|json2.js");
</script>
<script type="text/javascript">
Com_IncludeFile("mustache.js", "${KMSS_Parameter_ContextPath}tib/common/resource/js/", "js", true);
Com_IncludeFile("jquery.treeTable.css", "${KMSS_Parameter_ContextPath}tib/common/resource/css/", "css", true);
Com_IncludeFile("jquery.treeTable.js", "${KMSS_Parameter_ContextPath}tib/common/resource/js/", "js", true);
Com_IncludeFile("jdbcDataSet.js", "${KMSS_Parameter_ContextPath}tib/jdbc/resource/js/", "js", true);
Com_IncludeFile("tools.js","${KMSS_Parameter_ContextPath}tib/common/resource/js/","js",true);
Com_IncludeFile("jquery.blockUI.js","${KMSS_Parameter_ContextPath}tib/common/resource/js/","js",true);
</script>
<div id="optBarDiv">
	<kmss:auth requestURL="/tib/jdbc/tib_jdbc_data_set/tibJdbcDataSet.do?method=edit&fdId=${param.fdId}" requestMethod="GET">
		<input type="button"
			value="<bean:message key="button.edit"/>"
			onclick="Com_OpenWindow('tibJdbcDataSet.do?method=edit&fdId=${param.fdId}','_self');">
	</kmss:auth>
	<kmss:auth requestURL="/tib/jdbc/tib_jdbc_data_set/tibJdbcDataSet.do?method=delete&fdId=${param.fdId}" requestMethod="GET">
		<input type="button"
			value="<bean:message key="button.delete"/>"
			onclick="if(!confirmDelete())return;Com_OpenWindow('tibJdbcDataSet.do?method=delete&fdId=${param.fdId}','_self');">
	</kmss:auth>
	<input type="button"
		value="<bean:message key="button.close"/>"
		onclick="Com_CloseWindow();">
</div>

<p class="txttitle"><bean:message bundle="tib-jdbc" key="table.tibJdbcDataSet"/></p>

<center>
<table class="tb_normal" width=95%>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="tib-jdbc" key="tibJdbcDataSet.docSubject"/>
		</td><td colspan="3" width="85%">
			<xform:text property="docSubject" style="width:85%" />
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="tib-jdbc" key="tibJdbcDataSet.fdDataSource"/>
		</td>
		<td width="35%">
			<xform:select property="fdDataSource" style="float: left;" showStatus="view">
			 	<xform:beanDataSource serviceBean="compDbcpService"
					selectBlock="fdId,fdName" orderBy="" />
			</xform:select>
			<select name="fdDataSource" style="display:none;">
				<option value="${tibJdbcDataSetForm.fdDataSource }" selected="selected">${tibJdbcDataSetForm.fdDataSource }</option>
			</select>
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="tib-jdbc" key="tibJdbcDataSet.docCategory"/>
		</td>
		<td width="35%">
			<c:out value="${tibJdbcDataSetForm.docCategoryName}" />
		</td>
		
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="tib-jdbc" key="tibJdbcDataSet.fdSqlExpression"/>
		</td><td colspan="3" width="85%">
			<xform:text property="fdSqlExpression" style="width:85%" />
			<textarea name="fdSqlExpression" style="display:none;" rows="" cols="">${tibJdbcDataSetForm.fdSqlExpression }</textarea>
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" colspan="4" width=100% align="center">
			<bean:message bundle="tib-jdbc" key="tibJdbcDataSet.fdData"/>
			<textarea name="fdData" style="width:85%; display:none;">${tibJdbcDataSetForm.fdData }</textarea>
		</td>
	</tr>
	<tr>
		<td width="50%" colspan="2" valign="top">
	       <div id="jdbc_data_set_in"></div>
	    </td>
		<td width="50%" colspan="2" valign="top">
	       <div id="jdbc_data_set_out"></div>
	    </td>
	</tr>
</table>
</center>

<!-- js input脚本模板 -->
<script id="jdbc_data_set_template_in" type="text/mustache">
<table class="erp_template" style="table-layout:fixed;width:100%" >
<col style="width: 40%" />
<col style="width: 40%" />
<col style="width: 20%" />
	<caption>{{info.caption}}</caption>
	<thead>
		<tr>
		{{#info.thead}}
			<td style='font-size:13px; text-align:center;' nowrap >{{{th}}}</td>
		{{/info.thead}}
		</tr>
	</thead>
	<tbody>
		{{#info.tbody}}
		<tr  id="{{nodeKey}}">
			<td>{{tagName}}</td>
			<td>
				{{ctype}}
			</td>
			<td>
				<input type="checkbox" name="required" disabled="true" value="是否必填" commentName="required" tagName="{{tagName}}"
					{{required}} nodeKey="{{nodeKey}}"/>
			</td>
		</tr>
		{{/info.tbody}}
	</tbody>
</table>
</script>
<!-- js output脚本模板 -->
<script id="jdbc_data_set_template_out" type="text/mustache">
<table class="erp_template" style="table-layout:fixed;width:100%" >
<col style="width: 40%" />
<col style="width: 40%" />
<col style="width: 20%" />
	<caption>{{info.caption}}</caption>
	<thead>
		<tr>
		{{#info.thead}}
			<td style='font-size:13px; text-align:center;' nowrap >{{{th}}}</td>
		{{/info.thead}}
		</tr>
	</thead>
	<tbody>
		{{#info.tbody}}
		<tr  id="{{nodeKey}}">
			<td>{{tagName}}</td>
			<td>
				{{ctype}}
			</td>
			<td>
				<select name="disp" nodeKey="{{nodeKey}}" disabled="true" commentName="disp" tagName="{{tagName}}"
					defaultValue="{{disp}}">
				</select>
			</td>
		</tr>
		{{/info.tbody}}
	</tbody>
</table>
</script>
<%@ include file="/resource/jsp/view_down.jsp"%>