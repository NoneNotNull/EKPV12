<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/common.jsp"%>
<%@ include file="/resource/jsp/view_top.jsp"%>
<script>
function confirmDelete(msg){
	var del = confirm("<bean:message key="page.comfirmDelete"/>");
	return del;
}
</script>
<kmss:windowTitle
	subjectKey="sys-xform:table.sysFormDbColumn.create.title"
	subject="${sysFormDbTableForm.fdName}"
	moduleKey="sys-xform:table.sysFormDbTable" />
	
	<div id="optBarDiv">
	<c:if test="${not empty reToFormUrl}">
		<input type=button value="<kmss:message key="sys-xform:sysFormDbTable.btn.reToForm" />" onclick="Com_OpenWindow('${reToFormUrl}', '_blank');"/>
	</c:if>
	<%-- 编辑 --%>
	<kmss:auth
	requestURL="/sys/xform/base/sys_form_db_table/sysFormDbTable.do?method=edit&fdModelName=${param.fdModelName}&fdTemplateModel=${param.fdTemplateModel}&fdFormType=${param.fdFormType}&fdModelId=${param.fdModelId}"
	requestMethod="GET">
	<input type=button value="<bean:message key="button.edit"/>"
		onclick="Com_OpenWindow('<c:url value="/sys/xform/base/sys_form_db_table/sysFormDbTable.do">
			<c:param name="method" value="edit"/>
			<c:param name="fdId" value="${param.fdId}"/>
			<c:param name="fdFormId" value="${empty param.fdTemplateId ? param.fdFormId : param.fdTemplateId}"/>
			<c:param name="fdKey" value="${param.fdKey}"/>
			<c:param name="fdModelName" value="${param.fdModelName}"/>
			<c:param name="fdTemplateModel" value="${param.fdTemplateModel}"/>
			<c:param name="fdFormType" value="${param.fdFormType}"/>
			<c:param name="fdModelId" value="${param.fdModelId}"/>
		</c:url>', '_self');">
	</kmss:auth>
	<%-- 删除 --%>
	<kmss:auth
	requestURL="/sys/xform/base/sys_form_db_table/sysFormDbTable.do?method=delete&fdModelName=${param.fdModelName}&fdTemplateModel=${param.fdTemplateModel}&fdFormType=${param.fdFormType}&fdModelId=${param.fdModelId}"
	requestMethod="GET">
	<input type=button value="<bean:message key="button.delete"/>"
		onclick="if(!confirmDelete())return;Com_OpenWindow('<c:url value="/sys/xform/base/sys_form_db_table/sysFormDbTable.do">
			<c:param name="method" value="delete"/>
			<c:param name="fdId" value="${param.fdId}"/>
			<c:param name="fdFormId" value="${empty param.fdTemplateId ? param.fdFormId : param.fdTemplateId}"/>
			<c:param name="fdKey" value="${param.fdKey}"/>
			<c:param name="fdModelName" value="${param.fdModelName}"/>
			<c:param name="fdTemplateModel" value="${param.fdTemplateModel}"/>
			<c:param name="fdFormType" value="${param.fdFormType}"/>
			<c:param name="fdModelId" value="${param.fdModelId}"/>
		</c:url>', '_self');">
	</kmss:auth>
	<%-- 关闭 --%>
	<input type="button" value="<bean:message key="button.close"/>"
		onclick="Com_CloseWindow();">
	</div>
	
	<%-- 显示标题 --%>
	<p class="txttitle">
		<bean:message bundle="sys-xform" key="sysFormTemplate.view.title" />
	</p>
	
	<center>
	<table class="tb_normal" width="95%" id="db_table">
	<tbody>
		<tr>
			<td class="td_normal_title" width=15%><kmss:message key="sys-xform:sysFormDbTable.fdName" /></td>
			<td colspan="3">${sysFormDbTableForm.fdName}</td>
		</tr>
		<tr>
			<td class="td_normal_title" width=15%><kmss:message key="sys-xform:sysFormDbTable.fdFormName" /></td>
			<td width=35%>
				${sysFormDbTableForm.fdFormName}
			</td>
			<td class="td_normal_title" width=15%><kmss:message key="sys-xform:sysFormDbTable.fdTable" /></td>
			<td width=35%>
				${sysFormDbTableForm.fdTable}
			</td>
		</tr>
		<c:if test="${not empty sysFormDbTableForm.fdColumns}">
		<tr>
			<td colspan="4">
			<table id="columnTable" class="tb_normal" width="100%">
				<tr class="tr_normal_title">
					<td width="20px" rowspan="2"><kmss:message key="sys-xform:sysFormDbTable.No" /></td>
					<td width="20%" rowspan="2"><kmss:message key="sys-xform:sysFormDbColumn.fdName" /></td>
					<td width="20%" rowspan="2"><kmss:message key="sys-xform:sysFormDbColumn.fdColumn" /></td>
					<td width="5%" rowspan="2"><kmss:message key="sys-xform:sysFormDbColumn.fdLength" /></td>
					<td width="25%" colspan="2"><kmss:message key="sys-xform:sysFormDbColumn.type" /></td>
					<td width="30%" rowspan="2"><kmss:message key="sys-xform:sysFormDbColumn.info" /></td>
				</tr>
				<tr class="tr_normal_title">
					<td width=""><kmss:message key="sys-xform:sysFormDbColumn.type.db" /></td>
					<td width=""><kmss:message key="sys-xform:sysFormDbColumn.type.java" /></td>
				</tr>
				<c:forEach items="${sysFormDbTableForm.fdColumns}" var="column" varStatus="vstatus">
				<c:if test="${column.fdIsEnable == 'true'}">
				<tr>
					<td>${vstatus.index + 1}</td>
					<td>
						<c:if test="${column.fdName == 'fdId'}">
						ID
						</c:if>
						${dictNames[column.fdName]}
					</td>
					<td>
						<c:if test="${empty column.fdColumn}">
						${column.fdTableName}
						</c:if>
						<c:if test="${not empty column.fdColumn}">
						${column.fdColumn}
						</c:if>
					</td>
					<td>
						<c:if test="${column.fdLength != '0'}">
						${column.fdLength}  
						</c:if>
						
					</td>
					<td>
						<c:if test="${empty column.fdDataType}">
						<kmss:message key="sys-xform:sysFormDbColumn.fdRelType.table" />
						</c:if>
						<c:if test="${not empty column.fdDataType}">
						${column.fdDataType}
						</c:if>
					</td>
					<td>
						${column.fdType}
					</td>
					<td>
						<c:if test="${column.fdIsPk == 'true'}">
						<kmss:message key="sys-xform:sysFormDbColumn.fdIsPk" />
						</c:if>
						<c:if test="${column.fdRelation == 'oneToMany'}">
						<kmss:message key="sys-xform:sysFormDbColumn.relation.oneToMany" arg0="${column.fdTableName}" />
						</c:if>
						<c:if test="${column.fdRelation == 'manyToMany'}">
						<kmss:message key="sys-xform:sysFormDbColumn.relation.manyToMany" arg0="${column.fdTableName}" />
						</c:if>
						<c:if test="${column.fdRelation == 'manyToOne'}">
							<c:if test="${not empty column.fdModelName}">
							<kmss:message key="sys-xform:sysFormDbColumn.relation.manyToOne_sys" arg0="${column.fdModelText}" />
							</c:if>
							<c:if test="${empty column.fdModelName}">
							<kmss:message key="sys-xform:sysFormDbColumn.relation.manyToOne_table" arg0="${column.fdTableName}" />
							</c:if>
						</c:if>
					</td>
				</tr>
				</c:if>
				</c:forEach>
			</table>
			</td>
		</tr>
		</c:if> 
		</tbody>
		<tbody id="subTable">
		<c:forEach items="${sysFormDbTableForm.fdTables}" var="table">
		<!-- 子表 -->
		<tr class="templateTitle">
			<td class="td_normal_title" width=15%>
				<kmss:message key="sys-xform:sysFormDbTable.subFormName" />
			</td>
			<td width=35%>
				${dictNames[table.fdName]}
			</td>
			<td class="td_normal_title" width=15%><kmss:message key="sys-xform:sysFormDbTable.fdTable" /></td>
			<td width=35%>
				${table.fdTable}
			</td>
		</tr>
		<c:if test="${not empty table.fdColumns}">
		<tr>
			<td colspan="4">
			<table class="tb_normal" width="100%">
				<tr class="tr_normal_title">
					<td width="20px" rowspan="2"><kmss:message key="sys-xform:sysFormDbTable.No" /></td>
					<td width="20%" rowspan="2"><kmss:message key="sys-xform:sysFormDbColumn.fdName" /></td>
					<td width="20%" rowspan="2"><kmss:message key="sys-xform:sysFormDbColumn.fdColumn" /></td>
					<td width="5%" rowspan="2"><kmss:message key="sys-xform:sysFormDbColumn.fdLength" /></td>
					<td width="25%" colspan="2"><kmss:message key="sys-xform:sysFormDbColumn.type" /></td>
					<td width="30%" rowspan="2"><kmss:message key="sys-xform:sysFormDbColumn.info" /></td>
				</tr>
				<tr class="tr_normal_title">
					<td width=""><kmss:message key="sys-xform:sysFormDbColumn.type.db" /></td>
					<td width=""><kmss:message key="sys-xform:sysFormDbColumn.type.java" /></td>
				</tr>
				<c:forEach items="${table.fdColumns}" var="column" varStatus="vstatus">
				<c:if test="${column.fdIsEnable == 'true'}">
				<tr>
					<td>${vstatus.index + 1}</td>
					<td>
						<c:if test="${column.fdName == 'fdId'}">
						ID
						</c:if>
						${dictNames[column.fdName]}
					</td>
					<td>
						<c:if test="${empty column.fdColumn}">
						${column.fdTableName}
						</c:if>
						<c:if test="${not empty column.fdColumn}">
						${column.fdColumn}
						</c:if>
					</td>
					<td>
						<c:if test="${column.fdLength != '0'}">
						${column.fdLength}  
						</c:if>
					</td>
					<td>
						<c:if test="${empty column.fdDataType}">
						<kmss:message key="sys-xform:sysFormDbColumn.fdRelType.table" />
						</c:if>
						<c:if test="${not empty column.fdDataType}">
						${column.fdDataType}
						</c:if>
					</td>
					<td>
						${column.fdType}
					</td>
					<td>
						<c:if test="${column.fdIsPk == 'true'}">
						<kmss:message key="sys-xform:sysFormDbColumn.fdIsPk" />
						</c:if>
						<c:if test="${column.fdRelation == 'oneToMany'}">
						<kmss:message key="sys-xform:sysFormDbColumn.relation.oneToMany" arg0="${column.fdTableName}" />
						</c:if>
						<c:if test="${column.fdRelation == 'manyToMany'}">
						<kmss:message key="sys-xform:sysFormDbColumn.relation.manyToMany" arg0="${column.fdTableName}" />
						</c:if>
						<c:if test="${column.fdRelation == 'manyToOne'}">
							<c:if test="${not empty column.fdModelName}">
							<kmss:message key="sys-xform:sysFormDbColumn.relation.manyToOne_sys" arg0="${column.fdModelText}" />
							</c:if>
							<c:if test="${empty column.fdModelName}">
							<kmss:message key="sys-xform:sysFormDbColumn.relation.manyToOne_table" arg0="${column.fdTableName}" />
							</c:if>
						</c:if>
					</td>
				</tr>
				</c:if>
				</c:forEach>
			</table>
			</td>
		</tr>
		</c:if>
		</c:forEach>
		</tbody>
	</table>
	</center>

<%@ include file="/resource/jsp/view_down.jsp"%>