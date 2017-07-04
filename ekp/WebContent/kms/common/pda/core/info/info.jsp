<%@page import="java.util.Enumeration"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<c:set var="kmsKnowledgePropertyForm" value="${requestScope[param.formName]}" />
<a data-lui-role="button">
	<script type="text/config">
		{
			currentClass : 'lui-property-icon-view',
			onclick : "propertySelected()",
			group : 'group1',
			text : '信息'
		}
	</script>	
</a>

<section data-lui-role="panel" id="property_panel">
	<header class="lui-header lui-core-header">
		<ul class="clearfloat">
			<li class="lui-back">
				<a  data-lui-role="button">
					<script type="text/config">
						{
							currentClass : 'lui-icon-s lui-back-icon',
						}
					</script>		
				</a>
			</li>
			<li class="lui-docSubject">
				<h2 class="textEllipsis">信息</h2>
			</li>
		</ul>
	</header>
	<div class="lui-property">
		<section class="lui-content lui-collopsible-content">
		
			<section data-lui-role="collapsible" >
				<script type="text/config">
				{
					title : '基本信息',
					expand : true,
					group : 'group_property',
					multi : true
				}
				</script>
				<table class="tb_normal" data-lui-role="component" style="display: none;">
					<tr>
						<td class="td_title">创建者</td>
						<td>${kmsKnowledgePropertyForm.docCreatorName}</td>
					</tr>
					<tr>
						<td class="td_title">创建时间</td>
						<td>${kmsKnowledgePropertyForm.docCreateTime}</td>
					</tr>
					<tr>
						<td class="td_title">文档状态</td>
						<td><sunbor:enumsShow value="${kmsKnowledgePropertyForm.docStatus}" enumsType="kms_doc_status" /></td>
					</tr>
					<tr>
						<td class="td_title">版本</td>
						<td>V ${kmsKnowledgePropertyForm.editionForm.mainVersion}.${kmsKnowledgePropertyForm.editionForm.auxiVersion}</td>
					</tr>
					<tr>
						<td class="td_title">分类信息</td>
						<td>
							<c:out value="${kmsKnowledgePropertyForm.docCategoryName}"/>
						</td>
					</tr>
				</table>
			</section>
			<c:import url="/kms/common/pda/core/attachment/attachment_property.jsp" charEncoding="UTF-8">
				<c:param name="formName"  value="${param.formName }"/>
				<c:param name="attFdKey" value="${param.attFdKey}"/>
			</c:import>
			<section data-lui-role="collapsible" >
				<script type="text/config">
				{
					title : '知识属性',
					expand : false,
					group : 'group_property',
					multi : true
				}
				</script>
				<table class="tb_normal" data-lui-role="component" style="display: none;">
					<script type="text/config">
					{
						lazy : true
					}
					</script>
					<c:import url="/sys/property/include/sysProperty_pda.jsp" charEncoding="UTF-8">
						<c:param name="formName" value="${param.formName}" />
						<c:param name="isPda" value="true" />
					</c:import>
				</table>
			</section>
			
			<section data-lui-role="collapsible">
				<script type="text/config">
				{
					title : '知识标签',
					expand : false,
					group : 'group_property',
					multi : true
				}
				</script>
				<table class="tb_normal" data-lui-role="component" style="display: none;">
					<script type="text/config">
					{
						lazy : true
					}
					</script>
					<c:import url="/sys/tag/import/sysTagMain_view.jsp" charEncoding="UTF-8">
						<c:param name="formName" value="${param.formName }" />
						<c:param name="useTab" value="true"></c:param>
					</c:import>
				</table>
			</section>
			<c:import url="/kms/common/pda/core/lbpm/lbpm_property.jsp" charEncoding="UTF-8">
				<c:param name="formName" value="${param.formName }" />
			</c:import>
		</section>
	</div>
</section>

<script>
	function propertySelected(){
		Pda.Element('property_panel').selected();
		var arr = Pda.Role('collapsible','group_property');
		for(var i = 0, length = arr.length; i < length ; i++) {
			if(arr[i].isloaded == true) {
				return;
			}
		}
		for(i = 0; i < length ; i++) {
			arr[i].selected();
		}
	}
</script>
