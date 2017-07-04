<%@page import="java.util.List"%>
<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<template:include ref="default.simple">
	<template:replace name="body">
		<br>
		<form method="post" action="${LUI_ContextPath }/sys/admin/commontools/sqlview.do?method=genSql">
			<table class="tb_normal" width=95%>
				<tr>
					<td class="td_normal_title" width=15%>
						当前数据类型
					</td>
					<td>
						${ dbtype }
					</td>
				</tr>
				<c:if test="${ not dbtype eq 'Mysql' }">
				<tr>
					<td class="td_normal_title" width=15%>
						数据库DBLINK
					</td>
					<td>
						<input name="dblink" value="${dblink}" type="text" style="width: 200px;" />
					</td>
				</tr>
				</c:if>
				<tr>
					<td class="td_normal_title" width=15%>
						数据库Schema
					</td>
					<td>
						<input name="schema" value="${schema}" type="text" style="width: 200px;" />
					</td>
				</tr>
				<tr>
					<td class="td_normal_title" width=15%>
						需要生成的模块
					</td>
					<td>
						<select name="modules" multiple="multiple" size="10" style="width: 200px;">
						<%
							List modules = (List)request.getAttribute("modules");
							for(int i=0;i<modules.size();i++){
								String[] vals = (String[])modules.get(i);
								if(vals[1].equalsIgnoreCase("true")){
									out.print("<option selected>"+vals[0]+"</option>");
								}else{
									out.print("<option>"+vals[0]+"</option>");
								}
							}
						%>
						</select>
					</td>
				</tr>
				<tr>
					<td class="td_normal_title" width=15%>
						SQL选项
					</td>
					<td>
						<label><input type="checkbox" name="s_data" value="true" ${ not empty s_data and s_data eq 'true' ? 'checked' : '' } />是否生成数据迁移语句</label>
						&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
						<label><input type="checkbox" name="s_drop" value="true" ${ not empty s_drop and s_drop eq 'true' ? 'checked' : '' } />是否生成删除表的语句</label>
					</td>
				</tr>
				<tr>
					<td colspan="2" style="text-align: center;">
						<input type="submit" value="&nbsp;&nbsp;视图&nbsp;SQL&nbsp;&nbsp;" />
					</td>
				</tr>
				<c:if test="${ not empty genSql }">
				<tr>
					<td class="td_normal_title" width=15%>
						创建视图SQl
					</td>
					<td>
						<textarea style="width: 100%;height: 300px;">${ genSql }</textarea>
					</td>
				</tr>
				</c:if>
			</table>
		</form>
		<br>
	</template:replace>
</template:include>

