<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/common.jsp"%>
<link rel="stylesheet" href="${LUI_ContextPath }/kms/common/pda/core/relation/style/relation.css" />
<c:set var="mainModelForm" value="${requestScope[param.formName]}" scope="request"/>
<c:set var="sysRelationMainForm" value="${mainModelForm.sysRelationMainForm}" scope="request"/>
<c:set var="currModelId" value="${mainModelForm.fdId}" scope="request"/>
<c:set var="currModelName" value="${mainModelForm.modelClass.name}" scope="request"/>
<a data-lui-role="button">
	<script type="text/config">
		{
			currentClass : 'lui-relation-icon-view',
			onclick : "relationSelected()",
			text : '关联'
		}
	</script>	
</a>

<section data-lui-role="panel" id="relation_panel">
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
				<h2 class="textEllipsis">关联</h2>
			</li>
		</ul>
	</header>
	<div style="position: absolute;top: 50px;bottom: 0;width: 100%">
		<section class="lui-content lui-collopsible-content">
			<c:forEach items="${sysRelationMainForm.sysRelationEntryFormList}" 
					   varStatus="vstatus" var="sysRelationEntryForm">
				<c:set var="isExpanded" value="true"/>
				<c:if test="${ vstatus.index > 0}">
					<c:set var="isExpanded" value="false"/>
				</c:if>
			<section data-lui-role="collapsible" >
				<script type="text/config">
				{
					title : '${sysRelationEntryForm.fdModuleName}',
					expand : ${isExpanded},
					group : 'group_relation'
				}
			</script>
				<section data-lui-role="component" >
					<script type="text/config">
				{
					source : {
						type : 'AjaxJson',
						url : '${LUI_ContextPath}/sys/relation/relation.do?method=result&forward=listUi&currModelId=${currModelId}&currModelName=${currModelName}&fdKey=${param.fdKey}&sortType=time&fdType=${sysRelationEntryForm.fdType}&moduleModelId=${sysRelationEntryForm.fdId}&moduleModelName=${sysRelationEntryForm.fdModuleModelName}&showCreateInfo=${param.showCreateInfo}' 
					},
					render : {
						templateId : '#relation_tmpl'
					},
					lazy : true
				}
				</script>
				</section>
			</section>
			</c:forEach>
		</section>
	</div>
</section>

<script>
	function relationSelected(){
		Pda.Element('relation_panel').selected();
		var arr = Pda.Role('collapsible','group_relation');
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

<script id="relation_tmpl" type="text/template">
	{$ <div style="width:100%"> <ul>$}
	for(var i = 0; i < data.length; i++) {
	  {$ 
         <li class="lui-relation-list">
			<a href="${LUI_ContextPath}{% data[i].href%}">
			  <span class="lui-realation-list-tri"></span>
		  	  {% data[i].text%}
			</a>
		 </li>
	  $}
	}
	{$ </ul></div>$}
</script>