<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<%@ include file="/sys/ui/jsp/jshead.jsp"%>
	
		
		
		<div class="lui_list_operation">
			
			<div style="float:right">
				<div style="display: inline-block;vertical-align: middle;">
					<ui:toolbar id="Btntoolbar">
					  	<kmss:authShow roles="ROLE_KMREVIEW_CREATE">
						 	<ui:button text="${lfn:message('button.add')}" id="add" onclick="addDoc()" order="2" ></ui:button>
						</kmss:authShow>
						
						
					</ui:toolbar>
				</div>
			</div>
		</div>
		<ui:fixed elem=".lui_list_operation"></ui:fixed>
		<list:listview cfg-criteriaInit="${empty param.categoryId?'false':'true'}">
			<ui:source type="AjaxJson">
					{url:'/km/review/km_review_index/kmReviewIndex.do?method=showKeydataUsed&keydataId=${param.keydataId}'}
			</ui:source>
			<list:colTable isDefault="true" layout="sys.ui.listview.columntable" rowHref="/km/review/km_review_main/kmReviewMain.do?method=view&fdId=!{fdId}">
				<list:col-checkbox></list:col-checkbox>
				<list:col-serial></list:col-serial>
				<list:col-auto props="docSubject;fdNumber;docCreator.fdName;docCreateTime;docStatus;nodeName;handlerName"></list:col-auto> 
			</list:colTable>
		</list:listview> 
		<br>
	 	<list:paging></list:paging>
	 	<% 
	    request.setAttribute("isAdmin",UserUtil.getKMSSUser().isAdmin());
        %>
	 	<script type="text/javascript">
	 	var SYS_SEARCH_MODEL_NAME ="com.landray.kmss.km.review.model.KmReviewMain";
	 	seajs.use(['lui/jquery', 'lui/util/str', 'lui/dialog','lui/topic','lui/toolbar'], function($, strutil, dialog , topic,toolbar) {
		 	var isFreshWithTemplate = false;
		 	LUI.ready(function(){
              if(getValueByHash("fdTemplate")!=""){
            	  isFreshWithTemplate  = true;
                 }else{
                     //初始化门户传递的category
                     var categoryId = "${param.categoryId}";
                     if(categoryId == ""){
                         return;
                     }
                     var hash = window.location.hash;
                     if(hash == ""){
                   	   window.location.hash = "cri.q=fdTemplate:"+categoryId;
                     }else{
                   	   window.location.hash = hash + ";fdTemplate:"+categoryId;
                     }
                  }
			});
	 		//根据地址获取key对应的筛选值
            window.getValueByHash = function(key){
                var hash = window.location.hash;
                if(hash.indexOf(key)<0){
                    return "";
                 }
            	var url = hash.split("cri.q=")[1];
  			    var reg = new RegExp("(^|;)"+ key +":([^;]*)(;|$)");
			    var r=url.match(reg);
				    if(r!=null){
				    	 return unescape(r[2]);
				    }
				    return "";
                };
		 	//新建
	 		window.addDoc = function() {
					dialog.categoryForNewFile(
							'com.landray.kmss.km.review.model.KmReviewTemplate',
							'/km/review/km_review_main/kmReviewMain.do?method=add&fdTemplateId=!{id}',false,null,null,getValueByHash("fdTemplate"),null,null,true);
		 	};

		 	window.clearAllValue = function() {
		 		
			 	this.location = "${LUI_ContextPath}/km/review";
			};
		 	//删除
	 		window.delDoc = function(draft){
	 			var values = [];
				$("input[name='List_Selected']:checked").each(function(){
						values.push($(this).val());
					});
				if(values.length==0){
					dialog.alert('<bean:message key="page.noSelect"/>');
					return;
				}
				var url  = '<c:url value="/km/review/km_review_main/kmReviewMain.do?method=deleteall"/>';
				if(draft == '0'){
					url = '<c:url value="/km/review/km_review_main/kmReviewMain.do?method=deleteall&status=10"/>';
				}
				dialog.confirm('<bean:message key="page.comfirmDelete"/>',function(value){
					if(value==true){
						window.del_load = dialog.loading();

						$.ajax({
							url: url,
							type: 'POST',
							data:$.param({"List_Selected":values},true),
							dataType: 'json',
							error: function(data){
								if(window.del_load!=null){
									window.del_load.hide(); 
								}
								dialog.result(data.responseJSON);
							},
							success: delCallback
							});
					}
				});
			};
			window.delCallback = function(data){
				if(window.del_load!=null){
					window.del_load.hide(); 
					topic.publish("list.refresh");
				}
				dialog.result(data);
			};
			//分类转移
			window.chgSelect = function() {
				var values = "";
				$("input[name='List_Selected']:checked").each(function(){
					 values += "," + $(this).val();
					});
				if(values==''){
					dialog.alert('<bean:message bundle="km-review" key="message.trans_doc_select"/>');
					return;
				}
				values = values.substring(1);
				Com_OpenWindow('<c:url value="/km/review/km_review_main/kmReviewChangeTemplate.jsp" />?values='+values+'&categoryId=${param.categoryId}');
				return ;
			};
			/******************************************
			  * 验证权限并显示按钮 
			  * param：
			  *       categoryId 模板id
			  *       nodeType 模板类型
			  *****************************************/
			window.showButtons = function(categoryId,nodeType){
				  var checkChgCateUrl = "/km/review/km_review_main/kmReviewMain.do?method=changeTemplate&categoryId="+categoryId+"&nodeType="+nodeType;
				  var checkDelUrl = "/km/review/km_review_main/kmReviewMain.do?method=deleteall&categoryId="+categoryId+"&nodeType="+nodeType;
				  var data = new Array();
				  data.push(["delBtn",checkDelUrl]);
	              data.push(["chgcateBtn",checkChgCateUrl]);

	              $.ajax({
	       			  url: "${LUI_ContextPath}/sys/authorization/SysAuthUrlCheckAction.do?method=checkUrlAuth",
	       			  dataType:"json",
	       			  type:"post",
	       			  data:{"data":LUI.stringify(data)},
	       			  async:false,
	       			  success: function(rtn){
		       			  for(var i=0;i<rtn.length;i++){
			                  if(rtn[i]['delBtn'] == 'true'){
			                	    if(LUI('del')){ LUI('Btntoolbar').removeButton(LUI('del'));}
			                 		var delBtn = toolbar.buildButton({id:'del',order:'3',text:'${lfn:message("button.delete")}',click:'delDoc()'});
			    					LUI('Btntoolbar').addButton(delBtn);
			                   }
			                  if(rtn[i]['chgcateBtn'] == 'true'){
				                 	var chgcateBtn = toolbar.buildButton({id:'chgCate',order:'5',text:'${lfn:message("km-review:button.translate")}',click:'chgSelect()'});
				    				LUI('Btntoolbar').addButton(chgcateBtn);
				               }
		  		            }
	       			  }
	       		  });
            };
			//根据筛选器分类异步校验权限
			topic.subscribe('criteria.changed',function(evt){
				if(LUI('del')){ LUI('Btntoolbar').removeButton(LUI('del'));}
				if(LUI('chgCate')){LUI('Btntoolbar').removeButton(LUI('chgCate'));}
				
				var hasCate = false;
				for(var i=0;i<evt['criterions'].length;i++){
				  //获取分类id和类型
             	  if(evt['criterions'][i].key=="fdTemplate"){
             		 hasCate = true;
                 	 var cateId= evt['criterions'][i].value[0];
	                 var nodeType = evt['criterions'][i].nodeType;
	                 //分类变化或者带有分类刷新
	                 if(getValueByHash("fdTemplate")!=cateId || isFreshWithTemplate == true){
	                	 showButtons(cateId,nodeType);
	                 }
             	  }
             	  if(evt['criterions'][i].key=="docStatus" && evt['criterions'][i].value.length==1) {
						if(evt['criterions'][i].value[0]=='10') {
							if(LUI('del')){ LUI('Btntoolbar').removeButton(LUI('del'));}
							var delBtn = toolbar.buildButton({id:'del',order:'3',text:'${lfn:message("button.delete")}',click:'delDoc()'});
	    					LUI('Btntoolbar').addButton(delBtn);
						}
				  }
				}
                //清空模板,校验无分类情况
				if(hasCate == false){
					showButtons("","");
				}
                isFreshWithTemplate = false;
				
			});
			
			// 监听新建更新等成功后刷新
			topic.subscribe('successReloadPage', function() {
				topic.publish('list.refresh');
			});

			topic.subscribe('list.loaded',function(evt){
				if(window.frameElement!=null && window.frameElement.tagName=="IFRAME"){
					window.frameElement.style.height =  ($(document.body).height()+30) + "px";
				}
				
			});
	 	});
	 	</script>
