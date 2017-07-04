<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<%@ include file="/sys/ui/jsp/jshead.jsp"%>
	
		<div class="lui_list_operation">
			<div style="float:right">
				<div style="display: inline-block;vertical-align: middle;">
					<ui:toolbar count="3" >
						<%-- 发帖 --%>
						 <kmss:auth requestURL="/km/forum/km_forum/kmForumPost.do?method=add&owner=true" requestMethod="GET">	
							<ui:button id="add" text="${lfn:message('km-forum:kmForum.button.publish')}" onclick="addDoc()" order="2"></ui:button>	
						 </kmss:auth>	
					</ui:toolbar>
				</div>
			</div>
		</div>
		<ui:fixed elem=".lui_list_operation"></ui:fixed>
     	<list:listview id="listview">
			<ui:source type="AjaxJson">
				{url:'/km/forum/km_forum/kmForumTopicIndex.do?method=showKeydataUsed&keydataId=${param.keydataId}'}
			</ui:source>
			<list:colTable isDefault="true" layout="sys.ui.listview.columntable" 
				rowHref="/km/forum/km_forum/kmForumPost.do?method=!{method}&fdForumId=!{kmForumCategory.fdId}&fdTopicId=!{fdId}"  name="columntable">
				<list:col-checkbox></list:col-checkbox>
				<list:col-serial></list:col-serial>
				<list:col-auto props=""></list:col-auto>
			</list:colTable>
		</list:listview> 
		<list:paging></list:paging>	 
		<br>
        <script type="text/javascript"><!--
	    var SYS_SEARCH_MODEL_NAME ="com.landray.kmss.km.forum.model.KmForumTopic";
	    var hasCategory = true;
	    var canAdd = true;
	 	    
			seajs.use(['lui/jquery','lui/dialog','lui/topic'], function($, dialog , topic) {

				// 监听新建更新等成功后刷新
				topic.subscribe('successReloadPage', function() {
					topic.publish('list.refresh');
				});
				
				//根据地址获取板块
                window.getCategoryIdByHash = function(){
                	var hash = window.location.hash;
                	if(hash.indexOf("categoryId")<0){
                        return "";
                      }
                	var url = hash.split("cri.q=")[1];
				    var reg = new RegExp("(^|;)"+ "categoryId" +":([^;]*)(;|$)");
				    var r=url.match(reg);
					    if(r!=null){
					    	 return unescape(r[2]);
					    }
					    return "";
                    };
				
				//新建
				window.addDoc = function() {
				    var fdForumId = getCategoryIdByHash();
				    if(fdForumId!="" && canAdd){
				    	Com_OpenWindow('<c:url value="/km/forum/km_forum/kmForumPost.do" />?method=add&fdForumId='+fdForumId);
				    }else{
				    	Com_OpenWindow('<c:url value="/km/forum/km_forum/kmForumPost.do" />?method=add');
				     
				    }
				};
				//删除
				window.delDoc = function(){
					var values = [];
					$("input[name='List_Selected']:checked").each(function(){
							values.push($(this).val());
						});
					if(values.length==0){
						dialog.alert('<bean:message key="page.noSelect"/>');
						return;
					}
					dialog.confirm('<bean:message key="page.comfirmDelete"/>',function(value){
						if(value==true){
							window.del_load = dialog.loading();
							$.post('${LUI_ContextPath}/km/forum/km_forum/kmForumTopic.do?method=deleteall&fdForumId='+getCategoryIdByHash(),
									$.param({"List_Selected":values},true),delCallback,'json');
						}
					});
				};
                //板块转移
				window.showMove = function() {
					var values = [];
					$("input[name='List_Selected']:checked").each(function(){
							values.push($(this).val());
						});
					if(values.length==0){
						dialog.alert('<bean:message key="page.noSelect"/>');
						return;
					}
	                dialog.iframe("/km/forum/km_forum/kmForumTopic.do?method=showMove&fdId="+values+"&fdForumId="+getCategoryIdByHash()+"&type=moveAll",
											"${lfn:message('km-forum:kmForumCategory.button.changeDirectory')}",
										function(value){
											    if(value==""||value==null){
										    		   return;
										    	 }
												window.location.reload();}, {
												width : 600,
												height : 300
									});
			      };


			      //检验删除按钮权限
				  window.showButtons = function(forumId) {
					    var url = "${LUI_ContextPath}/km/forum/km_forum/kmForumTopicIndex.do?method=checkAuth";
						var data ={forumId:forumId};
						LUI.$.ajax({
							url: url,
							type: 'get',
							dataType: 'json',
							async: false,
							data: data,
							success: function(data, textStatus, xhr) {
								if(data.canDelete==true){
									 if(LUI('delete')){LUI('delete').setVisible(true);	}
								}else{
									 if(LUI('delete')){LUI('delete').setVisible(false);	}
								}

								if(data.canMove==true){
									 if(LUI('move')){LUI('move').setVisible(true);	}
								}else{
									 if(LUI('move')){LUI('move').setVisible(false);	}
								}
								//该板块无添加权限
								if(data.canAdd ==true){
									 canAdd = true;
							        $("#forumPost").attr("src","${LUI_ContextPath}/km/forum/km_forum/kmForumPost.do?method=add&forward=quickPostEdit&fdForumId="+forumId);
							     }else{
							    	 canAdd = false;
							        $("#forumPost").attr("src","${LUI_ContextPath}/km/forum/km_forum/kmForumPost.do?method=add&forward=quickPostEdit");
							     }
							}
						});
					};
								      
			      
			  	LUI.ready(function(){
			  		 if(LUI('delete')){LUI('delete').setVisible(true);}
			  		 var forumId = '${param.categoryId}';
			  		 showButtons(forumId);
			  		 //初始化进入
			  		 if(forumId!=""){
			  			 window.location.hash="#cri.q=categoryId:"+forumId;
				  		}
				});
				
				topic.subscribe('criteria.changed',function(evt) {
					var hasCategory = false; 
				    if (evt['criterions'].length > 0) {
					   for ( var i = 0; i < evt['criterions'].length; i++) {
						   //板块
                           if(evt['criterions'][i].key=="categoryId"){
                                  //由于要加载路径信息和删除按钮
                        	      hasCategory = true;
     							  var categoryId = evt['criterions'][i].value[0];
     							  //检查按钮权限
     							  showButtons(categoryId);
     							  //刷新板块信息
     							  if( $("#forumCategory").is(":hidden")){
     							      $("#forumCategory").show();
     							  }
     							  $("#forumCategory").attr("src","${LUI_ContextPath}/km/forum/km_forum_cate/kmForumCategory.do?method=main&type=criteria&categoryId="+categoryId);
     	     				 }
					     }
				     }
				    //筛选器去掉板块选择
				    if(hasCategory == false){
					      //检查按钮权限
					      showButtons("");
				         // $("#forumCategory").attr("src","${LUI_ContextPath}/km/forum/km_forum_cate/kmForumCategory.do?method=main&type=criteria");
				         //隐藏
						  if($("#forumCategory").is(":visible")){
						       $("#forumCategory").hide();
						  }
				    }
				  });

				window.delCallback = function(data) {
					if (window.del_load != null)
						window.del_load.hide();
					if (data != null && data.status == true) {
						topic.publish("list.refresh");
						dialog.success('<bean:message key="return.optSuccess" />');
						} else {
						dialog.failure('<bean:message key="return.optFailure" />');
						}
					  };
					});
    </script>	 
