<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="/WEB-INF/KmssConfig/sys/ui/lfn.tld" prefix="lfn"%>
<%@ taglib uri="/WEB-INF/KmssConfig/sys/ui/ui.tld" prefix="ui"%>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean"%>
<%@ taglib uri="/WEB-INF/kmss.tld" prefix="kmss"%>
<%@ include file="/kms/knowledge/kms_knowledge_ui/kmsKnowledge_common_js.jsp"%>
<kmss:auth requestURL="/kms/wiki/kms_wiki_main/kmsWikiMain.do?method=add" requestMethod="GET">
	<script>
	function addDoc() {
		seajs.use(['kms/wiki/kms_wiki_main_ui/js/create'], function(create) {
			create.addDoc("${param.categoryId}");
		});
	}
	</script>
	<ui:button text="${lfn:message('button.add')}" onclick="addDoc()" order="1"></ui:button>
</kmss:auth>
<kmss:auth requestURL="/kms/wiki/kms_wiki_main/kmsWikiMain.do?method=recycleall&categoryId=${param.categoryId}" requestMethod="GET">
	<ui:button text="${lfn:message('kms-knowledge:kmsKnowledge.button.recycle')}" 
			   onclick="recycleDoc()" 
			   id="recycleall"
			   order="4">
	</ui:button>
	<script>
		function recycleDoc() {
			kms_recycleDoc('/kms/wiki/kms_wiki_main/kmsWikiMain.do?method=recycleall&categoryId=${param.categoryId}');
		}
	</script>
</kmss:auth>
<script type="text/javascript">
	function delDoc(draft) {
		var url = '/kms/wiki/kms_wiki_main/kmsWikiMain.do?method=deleteall&categoryId=${param.categoryId}';
		if(draft === true) 
			url += "&status=10";
		kms_delDoc(url);
	}
</script>
<kmss:auth requestURL="/kms/wiki/kms_wiki_main/kmsWikiMain.do?method=deleteall&status=${param.status}&categoryId=${param.categoryId}&nodeType=${param.nodeType}" 
		   requestMethod="GET">
	<ui:button text="${lfn:message('kms-knowledge:kmsKnowledge.button.delete')}" 
			   onclick="delDoc()" 
			   order="5"
			   id="deleteall"></ui:button>
</kmss:auth>


<kmss:auth requestURL="/kms/knowledge/kms_knowledge_base_doc/kmsKnowledgeBaseDoc.do?method=editPropertys&templateId=${param.categoryId}" 
           requestMethod="GET">	
	<ui:button text="${lfn:message('kms-wiki:kmsWiki.button.editProperty')}" onclick="editProperty()"></ui:button>		 
</kmss:auth>	

<script>
 	var SYS_SEARCH_MODEL_NAME = "com.landray.kmss.kms.wiki.model.KmsWikiMain";
</script>

<kmss:auth
		requestURL="/kms/wiki/kms_wiki_main/kmsWikiMain.do?method=setTop&local=index&categoryId=${param.categoryId}"
		requestMethod="GET">
	<script type="text/javascript">
	function setTopSelection(){
		var values = [];
		var selected;
		var select = document.getElementsByName("List_Selected");
		for (var i = 0; i < select.length; i++) {
			if (select[i].checked) {
				values.push(select[i].value);
				selected = true;
			}
		}
		if (selected) {
				seajs.use(['lui/dialog'],function(dialog){
					dialog.iframe("/kms/wiki/kms_wiki_main_ui/kmsWikiMain_index_setTop.jsp?templateId=${param.categoryId}&docIds="+values, 
									"${lfn:message('kms-wiki:kmsWiki.setTop')}",
									 null, 
									 {	
										width:720,
										height:370,
										buttons:[
													{
														name : "${lfn:message('button.ok')}",
														value : true,
														focus : true,
														fn : function(value,_dialog) {
															commitForm(_dialog,values);
														}
													}, {
														name : "${lfn:message('button.cancel')}",
														styleClass:"lui_toolbar_btn_gray",
														value : false,
														fn : function(value, _dialog) {
															_dialog.hide();
														}
													} 
												]
									}
					); 
				});
			} else {
				seajs.use(['lui/dialog'], function(dialog) {
							dialog.alert("${lfn:message('page.noSelect')}");
						});
			}
	} 

	function commitForm(_dialog,values){
		var fdSetTopReason = LUI.$('#dialog_iframe').find('iframe')[0].contentDocument.getElementsByName('fdSetTopReason')[0].value;
		if (fdSetTopReason == "") {
			seajs.use(['lui/dialog'],function(dialog){
				dialog.alert("${lfn:message('kms-wiki:kmsWiki.setTopReason')}");
			});
	 		return false;
	 	}
		var fdSetTopLevel = LUI.$('#dialog_iframe').find('iframe')[0].contentDocument.getElementsByName('fdSetTopLevel');
		for(var i = 0; i < fdSetTopLevel.length; i++){
			if(fdSetTopLevel[i].checked){
				fdSetTopLevel=fdSetTopLevel[i].value;
				break;
			}
		}
	 	fdSetTopReason = encodeURIComponent(fdSetTopReason);
	 	LUI.$.ajax({
                url: '<c:url value="/kms/wiki/kms_wiki_main_index/kmsWikiMianIndex.do" />?method=setTop&'+
	 						'docIds='+values+'&fdSetTopLevel='+fdSetTopLevel+'&fdSetTopReason='+fdSetTopReason,
                type: 'post',
                success: function(data){
                	if(data["hasRight"]== true){
	                	var topWinHref =  top.location.href; 

	                	seajs.use(['lui/dialog', 'lui/topic'],function(dialog,topic){
	                		var loading = dialog.loading();
	                		_dialog.hide();
	                		loading.hide();
							dialog.success("${lfn:message('kms-wiki:kmsWiki.executeSucc')}",
									'#listview');
							topic.publish('list.refresh');
	        			});
                		
                	}else{
                		setTopFail(_dialog);
                	} 
                }
   		 }); 
	}

	function setTopFail(_dialog){
		_dialog.hide();
		seajs.use(['lui/dialog'],function(dialog){
			dialog.alert("${lfn:message('kms-wiki:kmsWiki.noRight')}");
		});
	}
	</script>
	<ui:button id="setTop" text="${lfn:message('kms-wiki:kmsWiki.setTop')}" onclick="setTopSelection();"></ui:button>
</kmss:auth>