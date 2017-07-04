<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="/WEB-INF/kmss-xform.tld" prefix="xform"%>
<%@ include file="/resource/jsp/edit_top.jsp"%>
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
<html:form action="/tib/jdbc/tib_jdbc_data_set/tibJdbcDataSet.do">
<div id="optBarDiv">
	<c:if test="${tibJdbcDataSetForm.method_GET=='edit'}">
		<input type=button value="<bean:message key="button.update"/>"
			onclick="before_submit('update');">
	</c:if>
	<c:if test="${tibJdbcDataSetForm.method_GET=='add'}">
		<input type=button value="<bean:message key="button.save"/>"
			onclick="before_submit('save');">
		<input type=button value="<bean:message key="button.saveadd"/>"
			onclick="before_submit('saveadd');">
	</c:if>
	<input type="button" value="<bean:message key="button.close"/>" onclick="Com_CloseWindow();">
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
		</td><td width="35%">
			<xform:select property="fdDataSource" style="float: left;" showStatus="edit" value="${fdDataSource }">
			 	<xform:beanDataSource serviceBean="compDbcpService"
					selectBlock="fdId,fdName" orderBy="" />
			</xform:select>
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="tib-jdbc" key="tibJdbcDataSet.docCategory"/>
		</td><td width="35%">
			<xform:dialog required="true" subject="${lfn:message('tib-jdbc:tibJdbcDataSet.docCategory') }" propertyId="docCategoryId" style="width:90%"
					propertyName="docCategoryName" dialogJs="Tib_treeDialog()">
			</xform:dialog>
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="tib-jdbc" key="tibJdbcDataSet.fdSqlExpression"/>
		</td><td colspan="3" width="85%">
			<font color="gray">样例：select * from tableName where fd_id=:id and fd_name=:name</font>
			<xform:textarea property="fdSqlExpression" style="width:85%" htmlElementProperties="onchange='fdSqlExpression_change();'"></xform:textarea>
			<input type="button" onclick="sqlPreview();" class="btnopt" value="<bean:message bundle="tib-jdbc" key="tibJdbcDataSet.extractStructure"/>"/>
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" colspan="4" width=100% align="center">
			<bean:message bundle="tib-jdbc" key="tibJdbcDataSet.fdData"/>
			<xform:textarea property="fdData" style="width:85%; display:none;"></xform:textarea>
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
				<input type="checkbox" name="required" value="是否必填" commentName="required" tagName="{{tagName}}"
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
				<select name="disp" nodeKey="{{nodeKey}}" commentName="disp" tagName="{{tagName}}"
					defaultValue="{{disp}}">
				</select>
			</td>
		</tr>
		{{/info.tbody}}
	</tbody>
</table>
</script>


<html:hidden property="fdId" />
<html:hidden property="method_GET" />
<script>
	$KMSSValidation();
	function Tib_treeDialog() {
		Dialog_Tree(false, 'docCategoryId', 'docCategoryName', ',', 
				'tibJdbcDataSetCategoryTreeService&parentId=!{value}', 
				'所属分类', 
				null, null, '${TibJdbcDataSetForm.docCategoryId}', null, null, 
				'所属分类');
	}
</script>
</html:form>
<%@ include file="/resource/jsp/edit_down.jsp"%>