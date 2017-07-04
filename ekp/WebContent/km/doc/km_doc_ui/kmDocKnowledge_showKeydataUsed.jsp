<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<%@ include file="/sys/ui/jsp/jshead.jsp"%>
<body>
			
		<div class="lui_list_operation">
			
			<div style="float:right">
				<div style="display: inline-block;vertical-align: middle;">
					<ui:toolbar count="3">
							
							<kmss:authShow roles="ROLE_KMDOC_CREATE">
								<ui:button text="${lfn:message('button.add')}" onclick="addDoc()" order="2"></ui:button>	
							</kmss:authShow>
							
						</ui:toolbar>
				</div>
			</div>
		</div>
		<div height="height:50px;width:100%;">
		&nbsp;
		</div>
		
		<list:listview id="listview">
			<ui:source type="AjaxJson">
					{url:'/km/doc/km_doc_knowledge/kmDocKnowledgeIndex.do?method=showKeydataUsed&keydataId=${param.keydataId}'}
			</ui:source>
			  <!-- 列表视图 -->	
			<list:colTable isDefault="false" layout="sys.ui.listview.columntable" 
				rowHref="/km/doc/km_doc_knowledge/kmDocKnowledge.do?method=view&fdId=!{fdId}"  name="columntable">
				<list:col-checkbox></list:col-checkbox>
				<list:col-serial></list:col-serial> 
				<list:col-html   title="${ lfn:message('sys-doc:sysDocBaseInfo.docSubject') }" style="text-align:left">
				{$ <span class="com_subject">{%row['docSubject']%}</span> $}
				</list:col-html>
				<list:col-auto props="docAuthor.fdName;docDept.fdName;docPublishTime;docStatus;docReadCount"></list:col-auto>
			</list:colTable>
			  <!-- 摘要视图 -->	
			<list:rowTable isDefault="true"
				rowHref="/km/doc/km_doc_knowledge/kmDocKnowledge.do?method=view&fdId=!{fdId}" name="rowtable" >
					<list:row-template>
				  {$
				  <div class="clearfloat lui_listview_rowtable_summary_content_box">
					<dl>
						<dt>
							<input type="checkbox" data-lui-mark="table.content.checkbox" value="{%row.fdId%}" name="List_Selected"/>
							<span class="lui_listview_rowtable_summary_content_serial">{%row.index%}</span>
						</dt>
					</dl>
			         <dl>		
			            <dt>
							<a href="${KMSS_Parameter_ContextPath}km/doc/km_doc_knowledge/kmDocKnowledge.do?method=view&fdId={%row.fdId%}" class="textEllipsis com_subject" target="_blank" data-lui-mark-id="{%row.rowId%}">{%row.row_docSubject%}</a>
						</dt>		
						<dd>
						    <span>{%str.textEllipsis(row['fdDescription_row'],150)%}</span>
						</dd>
						<dd class="lui_listview_rowtable_summary_content_box_foot_info">
							<span> ${ lfn:message('sys-doc:sysDocBaseInfo.docAuthor') }：{%row['docAuthor.fdName']%}</span>
							<span>${ lfn:message('sys-doc:sysDocBaseInfo.docDept') }：{%row['docDept.fdName']%}</span>
							<span>{%row['docPublishTime_row']%}</span>
							<span>{%row['kmDocTemplateName_row']%}</span>
							<span>${ lfn:message('km-doc:kmDoc.kmDocKnowledge.read') }：{%row['docReadCount']%}</span>
							<span>{%row['sysTagMain_row']%}</span>
						</dd>
					</dl>
				 </div>
				    $}		      
				</list:row-template>
			</list:rowTable>
		</list:listview> 
		 
	 	<list:paging></list:paging>	 
	</body> 	
 
<script type="text/javascript">

	 	var SYS_SEARCH_MODEL_NAME ="com.landray.kmss.km.doc.model.KmDocKnowledge";
	 	
			seajs.use(['lui/jquery','lui/dialog','lui/topic'], function($, dialog , topic) {


				
				// 监听新建更新等成功后刷新
				topic.subscribe('successReloadPage', function() {
					topic.publish('list.refresh');
				});
				
				//新建
				window.addDoc = function() {
						dialog.simpleCategoryForNewFile(
								'com.landray.kmss.km.doc.model.KmDocTemplate',
								'/km/doc/km_doc_knowledge/kmDocKnowledge.do?method=add&fdTemplateId=!{id}',false,null,null,'${param.categoryId}');
				};

				topic.subscribe('list.loaded',function(evt){
					if(window.frameElement!=null && window.frameElement.tagName=="IFRAME"){
						window.frameElement.style.height =  ($(document.body).height()+30) + "px";
					}
					//window.parent.setHeight(window.location.pathname+window.location.search,$(document).height());
					
				});

				
			});
		</script>
