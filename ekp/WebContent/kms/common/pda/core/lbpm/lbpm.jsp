<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<link rel="stylesheet" href="${LUI_ContextPath }/kms/common/pda/core/lbpm/style/lbpm.css" />
<c:set var="lbpmForm" value="${requestScope[param.formName]}" />

<c:if test="${(lbpmForm.docStatus>='20' && lbpmForm.docStatus<'30') || lbpmForm.docStatus == '11'}">
	<script type="text/javascript" src="${LUI_ContextPath}/resource/js/common.js?s_cache=${ LUI_Cache }"></script>
	<a data-lui-role="button">
		<script type="text/config">
		{
			currentClass : 'lui-flow-icon-view',
			onclick : "flowSelected()",
			group : 'group1',
			text : '流程'
		}
		</script>	
	</a>
	<section data-lui-role="panel" id="flow_panel">
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
					<h2 class="textEllipsis">流程</h2>
				</li>
			</ul>
		</header>
		<div class="lui-property">
			<section class="lui-content lui-collopsible-content">
				<section data-lui-role="collapsible" >
					<script type="text/config">
					{
						title : '流程审批',
						expand : true ,
						group : 'group_property'
					}
					</script>
					<div data-lui-role="component" style="display: none;">
						<script type="text/config">
						{
							lazy : false
						}
						</script>
						<c:import url="/kms/common/pda/core/lbpm/lbpm_view.jsp" charEncoding="UTF-8">
						</c:import>
					</div>
				</section>
		
				<section data-lui-role="collapsible" >
					<script type="text/config">
					{
						title : '流程日志',
						expand : false,
						group : 'group_property'
					}
					</script>
					<div data-lui-role="component" style="display: none;">
						<script type="text/config">
						{
							lazy : true
						}
						</script>
						<%@ include file="/sys/lbpmservice/pda/sysLbpmProcess_log.jsp" %>
					</div>
				</section>
			</section>
		</div>
	</section>
	
	<script>
		function flowSelected(){
			Pda.Element('flow_panel').selected();
		}
	</script>
</c:if>