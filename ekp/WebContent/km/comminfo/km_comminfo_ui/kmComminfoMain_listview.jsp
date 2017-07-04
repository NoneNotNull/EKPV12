<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
	<div class="lui_list_operation">
			<div style='color: #979797;float: left;padding-top:1px;'>
				${ lfn:message('list.orderType') }：
			</div>
			<div style="float:left">
				<div style="display: inline-block;vertical-align: middle;">
					<ui:toolbar layout="sys.ui.toolbar.sort" style="float:left">
						<list:sort property="docCreateTime" text="${lfn:message('km-comminfo:kmComminfoMain.docCreateTime') }" group="sort.list" value="down"></list:sort>
					</ui:toolbar>
				</div>
			</div>
			<div style="float:left;">	
				<list:paging layout="sys.ui.paging.top" > 		
				</list:paging>
			</div>
			<div style="float:right">
				<div style="display: inline-block;vertical-align: middle;">
					<ui:toolbar count='2' style="float:right" id="Btntoolbar">
						<kmss:authShow roles="ROLE_COMMINFO_MAIN_CREATE">
							<ui:button text="${lfn:message('button.add')}" onclick="addShare()" order="3">
							</ui:button>
						</kmss:authShow>
						<kmss:auth
							requestURL="/km/comminfo/km_comminfo_main/kmComminfoMain.do?method=deleteall&categoryId=${categoryId}"
							requestMethod="GET">								
							<ui:button text="${lfn:message('button.delete')}" onclick="delShare()" order="5" id="delBtn">
							</ui:button>
						</kmss:auth>
					</ui:toolbar>
				</div>
			</div>
		</div>
	<ui:fixed elem=".lui_list_operation"></ui:fixed>
	<%@ include file="/km/comminfo/km_comminfo_ui/kmComminfoMain_listtable.jsp" %>
	
<script type="text/javascript">
	   seajs.use(['lui/jquery','lui/dialog','lui/topic','lui/toolbar'], function($, dialog , topic, toolbar) {

			// 监听新建更新等成功后刷新
			topic.subscribe('successReloadPage', function() {
				topic.publish('list.refresh');
			});
		   
		   window.addShare = function() {
			   Com_OpenWindow('<c:url value="/km/comminfo/km_comminfo_main/kmComminfoMain.do" />?method=add&categoryId=${param.categoryId}');
			};

			window.delShare = function(){
				var values = [];
				var docCategory = getValueByHash("docCategory");
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
						$.post('${LUI_ContextPath}/km/comminfo/km_comminfo_main/kmComminfoMain.do?method=deleteall&categoryId='+docCategory,
								$.param({"List_Selected":values},true),delCallback,'json');
					}
				});
			};

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

                window.showButtons = function(categoryId){
	  				  var checkDelUrl = "/km/comminfo/km_comminfo_main/kmComminfoMain.do?method=deleteall&categoryId="+categoryId;
	  				  var data = new Array();
	  				  data.push(["delBtn",checkDelUrl]);
	
	  	              $.ajax({
	  	       			  url: "${LUI_ContextPath}/sys/authorization/SysAuthUrlCheckAction.do?method=checkUrlAuth",
	  	       			  dataType:"json",
	  	       			  type:"post",
	  	       			  data:{"data":LUI.stringify(data)},
	  	       			  async:false,
	  	       			  success: function(rtn){
	  		       			  for(var i=0;i<rtn.length;i++){
	  			                  if(rtn[i]['delBtn'] == 'true'){
	  			                	    if(LUI('delBtn')){ 
		  			                	    LUI('Btntoolbar').removeButton(LUI('delBtn'));
		  			                	   }
	  			                 		var delBtn = toolbar.buildButton({id:'delBtn',order:'5',text:'${lfn:message("button.delete")}',click:'delShare()'});
	  			    					LUI('Btntoolbar').addButton(delBtn);
	  			                   }
			  		           }
		       			  	}
		       		  	});
           			};
  			//根据筛选器分类异步校验权限
  			topic.subscribe('criteria.changed',function(evt){
  				if(LUI('delBtn')){ LUI('Btntoolbar').removeButton(LUI('delBtn'));}
  				
  				var hasCate = false;
  				for(var i=0;i<evt['criterions'].length;i++){
  				  //获取分类id和类型
              	  if(evt['criterions'][i].key=="docCategory"){
              		 hasCate = true;
                  	 var cateId= evt['criterions'][i].value[0];
  	                 //分类变化或者带有分类刷新
  	                 if(getValueByHash("docCategory")!=cateId || isFreshWithTemplate == true){
  	                	 showButtons(cateId);
  	                 }
              	  }
  				}
                 //清空模板,校验无分类情况
  				if(hasCate == false){
  					showButtons("");
  				}
  				else isFreshWithTemplate = false;
  				
  			});

			window.delCallback = function(data){
				if(window.del_load!=null){
					window.del_load.hide();
					topic.publish("list.refresh");
				}
				dialog.result(data);
			};

			LUI.ready(function(){
				var checkChgCateUrl = "";
				var checkDelUrl = "";
				isFreshWithTemplate = false;
				if(getValueByHash("docCategory")!= null){
					isFreshWithTemplate = true;
				}
			});
	   });
    </script>