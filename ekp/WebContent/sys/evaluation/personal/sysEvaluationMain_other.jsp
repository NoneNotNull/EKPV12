<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
	<list:criteria id="sysEvaluationCriteria" expand="true">
		<c:if test="${empty TA}">
			<c:set value="ta" var="TA"/>
		</c:if>		
		<!-- 全文点评（搜索范围） --> 
		<list:cri-criterion title="${lfn:message('sys-evaluation:sysEvaluation.search.range')}" key="modelName" multi="false" >
			<list:box-select>
				<list:item-select id="main">
					<ui:source type="AjaxJson">
						{"url":"/sys/evaluation/personal/sysEvaluationMain_other_area_main.jsp"} 
					</ui:source>
				</list:item-select>
			</list:box-select>
		</list:cri-criterion>
		<!-- 段落点评（搜索范围） --> 
		<list:cri-criterion title="${lfn:message('sys-evaluation:sysEvaluation.search.range')}" key="modelName" multi="false" >
			<list:box-select>
				<list:item-select  cfg-enable="false" id="notes">
					<ui:source type="AjaxJson">
						{"url":"/sys/evaluation/personal/sysEvaluationMain_other_area_notes.jsp"} 
					</ui:source>
				</list:item-select>
			</list:box-select>
		</list:cri-criterion>
		<!-- 点评对象 -->
		<list:cri-criterion title="${lfn:message('sys-evaluation:sysEvaluationNotes.docSubject')}" key="_evalType" multi="false">
			<list:box-select>
				<list:item-select cfg-defaultValue="all" cfg-required="true">
					<ui:source type="Static">
						[{text:"${lfn:message('sys-evaluation:table.sysEvaluationMain.all')}", value:'all'},
						{text:"${lfn:message('sys-evaluation:table.sysEvaluationNotes')}", value:'notes'}]
					</ui:source>
				</list:item-select>
			</list:box-select>
		</list:cri-criterion>
	</list:criteria>
    <div class="lui_list_operation">
		<table width="100%">
			<tr>
				<td style='color: #979797;width: 45px;text-align: center'>
					${lfn:message('sys-evaluation:sysEvaluation.order')}：
				</td>
				<%--排序按钮  --%>
				<td>
					<ui:toolbar layout="sys.ui.toolbar.sort" style="float:left" count="4">	
						<list:sort property="fdEvaluationTime" text="${lfn:message('sys-evaluation:sysEvaluationMain.fdEvaluationTime')}" group="sort.list" ></list:sort>
						<list:sort property="fdEvaluationScore" text="${lfn:message('sys-evaluation:sysEvaluationMain.fdEvaluationScore')}" group="sort.list" id="evalScore" channel="main"></list:sort>
					</ui:toolbar>
				</td>
			</tr>
		</table>
	</div>
	<ui:fixed elem=".lui_list_operation"></ui:fixed>
	<!-- 列表 -->
	<%@ include file="/sys/evaluation/import/sysEvaluationMain_col_view.jsp"  %>
	
<script type="text/javascript">

	seajs.use(['lui/topic'], function(topic) {
		topic.subscribe('criteria.changed',function(evt){
			var modelName = "";
			var evalType = "";
			var crit = evt.criterions;
			for(var i=0;i<crit.length;i++){
				var key = crit[i].key;
				var val = crit[i].value;
				if(key=='modelName'){
					modelName = val;
				}
				if(key=='_evalType'){
					evalType = val;
				}
			}
			
			if(evalType=='all'){
				topic.channel('main').publish('criteria.changed',
						{'criterions':[{'key':'modelName','value':[modelName]}]});
			}else{
				topic.channel('notes').publish('criteria.changed',
						{'criterions':[{'key':'modelName','value':[modelName]}]});
			}
			//列表选择
			for(var i=0;i<evt['criterions'].length;i++){
				if(evt['criterions'][i].key=="_evalType"){
					//全文点评
					if((evt['criterions'][i].value[0]=='all'||evt['criterions'][i].value[1]=='all')){
						$("#notesView").css("display","none");
						$("#mainView").css("display","block");
						LUI('notes').setEnable(false);
						LUI('main').setEnable(true);
						$("#evalScore").css("display","block");
					}else{//段落点评
						$("#notesView").css("display","block");
						$("#mainView").css("display","none");
						LUI('notes').setEnable(true);
						LUI('main').setEnable(false);
						$("#evalScore").css("display","none");//排序：评分
					}
				}
			}
			
		});
	});

	//查看被点评的文档
	function viewDoc(fdModelId,fdModelName){
		LUI.$.ajax({
			url: Com_Parameter.ContextPath + 'sys/evaluation/sys_evaluation_main/sysEvaluationMain.do?method=getEvalDocUrl',
			type: 'POST',
			dataType: 'json',
			async : false,
			data: {'fdModelId':fdModelId,
					'fdModelName':fdModelName},
			success: function(data) {
				window.open(data['docUrl'], "_blank");
			},
			error: function() {
			}
		});
	}
</script>