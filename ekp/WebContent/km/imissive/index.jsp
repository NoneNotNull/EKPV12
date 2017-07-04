<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<%@ page import="com.landray.kmss.util.UserUtil"%>
<template:include ref="default.list">
	<template:replace name="title">
		<c:out value="${ lfn:message('km-imissive:kmImissive.tree.title') }"></c:out>
	</template:replace>
	<%-- 导航路径 --%>
	<template:replace name="path">
		<ui:menu layout="sys.ui.menu.nav"  id="categoryId"> 
			<ui:menu-item text="${ lfn:message('home.home') }" icon="lui_icon_s_home" href="/" target="_self"></ui:menu-item>
			<ui:menu-item text="${ lfn:message('km-imissive:module.km.imissive') }" href="/km/imissive/" target="_self"></ui:menu-item>
			<ui:menu-item text="发文管理" href="/km/imissive/index.jsp" target="_self">
				<ui:menu-item text="收文管理" href="/km/imissive/km_imissive_receive_main/index.jsp" target="_self"></ui:menu-item>
				<ui:menu-item text="签报" href="/km/imissive/km_imissive_sign_main/index.jsp" target="_self"></ui:menu-item>
			   	<ui:menu-item text="公文交换" href="/km/imissive/km_imissive_reg/index.jsp" target="_self"></ui:menu-item>
			</ui:menu-item>
		</ui:menu>
	</template:replace>
	<template:replace name="nav">
		<ui:combin ref="menu.nav.create">
			<ui:varParam name="title" value="${ lfn:message('km-imissive:kmImissive.tree.title') }" />
			<ui:varParam name="button">
				[
					<kmss:authShow roles="ROLE_KMIMISSIVE_SEND_CREATE">
					{
						"text": "新建发文",
						"href": "javascript:addDoc();",
						"icon": "lui_icon_l_icon_12"
					}
					</kmss:authShow>
				]
			</ui:varParam>			
		</ui:combin>
	<div class="lui_list_nav_frame">
	  <ui:accordionpanel>
	        <ui:combin ref="menu.nav.favorite.category">
					<ui:varParams 
						modelName="com.landray.kmss.km.imissive.model.KmImissiveSendTemplate"
						onClick="LUI('sendCriteria').setValue('fdTemplate','!{value}');"/>
			</ui:combin>
			<c:import url="/km/imissive/import/nav.jsp" charEncoding="UTF-8">
			   <c:param name="key" value="kmImissiveSend"></c:param>
			    <c:param name="criteria" value="sendCriteria"></c:param>
			</c:import>
		</ui:accordionpanel>
	</div>
	</template:replace>
	<template:replace name="content">
	  <list:criteria id="sendCriteria">
	        <list:cri-ref key="docSubject" ref="criterion.sys.docSubject"> 
			</list:cri-ref>
			<list:cri-ref ref="criterion.sys.category" key="fdTemplate" multi="false" title="分类导航" expand="true">
			  <list:varParams modelName="com.landray.kmss.km.imissive.model.KmImissiveSendTemplate"/>
			</list:cri-ref>
			<list:cri-criterion title="${ lfn:message('km-imissive:kmImissiveSendMain.Send.my') }" key="mydoc" multi="false">
				<list:box-select>
					<list:item-select>
						<ui:source type="Static">
							[{text:'${ lfn:message('km-imissive:kmImissive.tree.create.my') }', value:'create'},{text:'${ lfn:message('km-imissive:kmImissive.tree.myapproval') }',value:'approval'}, {text:'${ lfn:message('km-imissive:kmImissive.tree.myapproved') }', value: 'approved'}]
						</ui:source>
					</list:item-select>
				</list:box-select>
			</list:cri-criterion>
			<list:cri-criterion title="${ lfn:message('km-imissive:kmImissiveSendMain.docStatus')}" key="docStatus"> 
				<list:box-select>
					<list:item-select>
						<ui:source type="Static">
							[{text:'${ lfn:message('status.draft')}', value:'10'},{text:'${ lfn:message('status.examine')}',value:'20'},{text:'${ lfn:message('status.refuse')}',value:'11'},{text:'${ lfn:message('status.discard')}',value:'00'},{text:'${ lfn:message('status.publish')}',value:'30'}]
						</ui:source>
					</list:item-select>
				</list:box-select>
			</list:cri-criterion>
			<list:cri-criterion title="${ lfn:message('km-imissive:kmImissiveSendMain.fdSendtoDept')}" key="SendtoUnit">
		      <list:box-select> 
		        <list:item-select type="lui/criteria/criterion_input!TextInput"> 
		        <ui:source type="Static">
		           [{placeholder:'${ lfn:message('km-imissive:kmImissiveSendMain.fdSendtoDept')}'}]
		        </ui:source>
		        </list:item-select>
		      </list:box-select>
		    </list:cri-criterion>
			<list:cri-auto modelName="com.landray.kmss.km.imissive.model.KmImissiveSendMain" property="fdDocNum;fdDrafter;fdDraftTime;docPublishTime;fdIsFiling" />
		</list:criteria>
		<div class="lui_list_operation">
			<div style='color: #979797;float: left;padding-top:1px;'> 
						${ lfn:message('list.orderType') }：
					</div>
					<div style="float:left">
						<div style="display: inline-block;vertical-align: middle;">
						<ui:toolbar layout="sys.ui.toolbar.sort" style="float:left" >
							<list:sort property="docCreateTime" text="拟稿时间" group="sort.list" value="down"></list:sort>
							<list:sort property="docPublishTime" text="发布时间" group="sort.list"></list:sort>
						    <list:sort property="fdDocNum" text="文号" group="sort.list"></list:sort>
						</ui:toolbar>
						</div>
					</div>
					<div style="float:left;">	
						<list:paging layout="sys.ui.paging.top" > 		
						</list:paging>
					</div>	
					<div style="float:right">
						<div style="display: inline-block;vertical-align: middle;">
						<ui:toolbar count="3" id="Btntoolbar">
							<%-- 收藏 --%>
							<c:import url="/sys/bookmark/import/bookmark_bar_all.jsp" charEncoding="UTF-8">
								<c:param name="fdTitleProName" value="docSubject" />
								<c:param name="fdModelName"	value="com.landray.kmss.km.imissive.model.KmImissiveSendMain" />
							</c:import>
							<kmss:authShow roles="ROLE_KMIMISSIVE_SEND_CREATE">
								<ui:button text="${lfn:message('button.add')}" onclick="addDoc()" order="2"></ui:button>	
							</kmss:authShow>
							<kmss:auth
								requestURL="/km/imissive/km_imissive_send_main/kmImissiveSendMain.do?method=deleteall&categoryId=${param.categoryId}&nodeType=${param.nodeType}"
								requestMethod="GET">
							   <ui:button id="del" text="${lfn:message('button.delete')}" order="2" onclick="delDoc()"></ui:button>
							</kmss:auth>
							<%-- 分类转移 --%>
							<kmss:auth
									requestURL="/km/imissive/km_imissive_send_main/kmImissiveSendMain.do?method=changeTemplate&categoryId=${param.categoryId}&nodeType=${param.nodeType}"
									requestMethod="GET">
								<ui:button id="chgCate" text="${lfn:message('km-imissive:kmImissive.button.translate')}" order="2" onclick="chgSelect();"></ui:button>
							</kmss:auth>
							<%-- 修改权限 --%>
							<c:import url="/sys/right/import/cchange_doc_right_button.jsp" charEncoding="UTF-8">
								<c:param name="modelName" value="com.landray.kmss.km.imissive.model.KmImissiveSendMain" />
								<c:param name="authReaderNoteFlag" value="2" />
							</c:import>		
						</ui:toolbar>
				  </div>
			</div>
		</div>
		<ui:fixed elem=".lui_list_operation"></ui:fixed>
		<list:listview id="listview">
			<ui:source type="AjaxJson">
					{url:'/km/imissive/km_imissive_send_main/kmImissiveSendMain.do?method=listChildren&categoryId=${param.categoryId}'}
			</ui:source>
			<list:colTable isDefault="false" layout="sys.ui.listview.columntable" 
				rowHref="/km/imissive/km_imissive_send_main/kmImissiveSendMain.do?method=view&fdId=!{fdId}"  name="columntable">
				<list:col-checkbox></list:col-checkbox>
				<list:col-serial></list:col-serial>
				<list:col-auto props=""></list:col-auto>
			</list:colTable>
		</list:listview> 
	 	<list:paging></list:paging>	 
	 	<script type="text/javascript">

	 	var SYS_SEARCH_MODEL_NAME ="com.landray.kmss.km.imissive.model.KmImissiveSendMain";
	 	
			seajs.use(['lui/jquery','lui/dialog','lui/topic','lui/toolbar'], function($, dialog , topic,toolbar) {

				// 监听新建更新等成功后刷新
				topic.subscribe('successReloadPage', function() {
					topic.publish('list.refresh');
				});
				//根据地址获取key对应的筛选值
				var getValueByHash=function(key){
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
				
				window.addDoc = function() {
					dialog.categoryForNewFile(
							'com.landray.kmss.km.imissive.model.KmImissiveSendTemplate',
							'/km/imissive/km_imissive_send_main/kmImissiveSendMain.do?method=add&fdTemplateId=!{id}',false,null,null,getValueByHash("fdTemplate"),null,null,true);
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
							$.post('<c:url value="/km/imissive/km_imissive_send_main/kmImissiveSendMain.do?method=deleteall"/>',
									$.param({"List_Selected":values},true),delCallback,'json');
						}
					});
				};
				window.delCallback = function(data){
					if(window.del_load!=null)
						window.del_load.hide();
					if(data!=null && data.status==true){
						topic.publish("list.refresh");
						dialog.success('<bean:message key="return.optSuccess" />');
					}else{
						dialog.failure('<bean:message key="return.optFailure" />');
					}
				};
				//分类转移
				window.chgSelect = function(){
					var values = "";
					$("input[name='List_Selected']:checked").each(function(){
						 values += "," + $(this).val();
					});
					if(values==''){
						dialog.alert('<bean:message key="page.noSelect"/>');
						return;
					}
					values = values.substring(1);
					Com_OpenWindow('<c:url value="/km/imissive/km_imissive_send_main/kmImissiveChangeTemplate.jsp" />?values='+values+'&categoryId=${param.categoryId}');
				};
				window.serializeParams=function(params) {
					//alert(params);
					var array = [];
					for (var i = 0; i < params.length; i++) {
						var p = params[i];
						if (p.nodeType) {
							array.push('nodeType=' + p.nodeType);
						}
						for (var j = 0; j < p.value.length; j++) {
							array.push("q." + encodeURIComponent(p.key) + '='
									+ encodeURIComponent(p.value[j]));
						}
						if (p.op) {
							array.push(encodeURIComponent(p.key) + '-op='
									+ encodeURIComponent(p.op));
						}
						for (var k in p) {
							if (k == 'key' || k == 'op' || k == 'value' || k == 'nodeType') {
								continue;
							}
							array.push(encodeURIComponent(p.key + '-' + k) + "="
									+ encodeURIComponent(p[k] || ""));
						}
					}
					var str = array.join('&');
					return str;
				};
				window.exportResult=function (){
					var url = '<c:url value="/km/imissive/km_imissive_send_main/kmImissiveSendMain.do" />?method=exportResult';
					var criterions = LUI('sendCriteria')._buildCriteriaSelectedValues();
					//alert(criterions);
					var urlParam = serializeParams(criterions);
					//alert(urlParam);
					if (urlParam) {
							if (url.indexOf('?') > 0) {
								url += "&" + urlParam;
							} else {
								url += "?" + urlParam;
							}
						}
					url +='&fdNum=5000&fdColumns=docSubject;fdDocNum;fdSendtoUnit.fdName;fdDrafter.fdName;fdDraftTime;docStatus'
					   +'&fdModelName=com.landray.kmss.km.imissive.model.KmImissiveSendMain';
					  // alert(url);
					window.location.href = url;
				};
				
				//归档
				window.filingDoc = function(){
					var values = [];
					$("input[name='List_Selected']:checked").each(function(){
							values.push($(this).val());
					});
					if(values.length==0){
						dialog.alert('<bean:message key="page.noSelect"/>');
						return;
					}
					dialog.confirm('<bean:message bundle="km-imissive" key="alert.msg"/>',function(value){
						if(value==true){
							window.del_load = dialog.loading();
							$.post('<c:url value="/km/imissive/km_imissive_send_main/kmImissiveSendMain.do?method=filingall"/>',
									$.param({"List_Selected":values},true),filingCallback,'json');
						}
					});
				};
				window.filingCallback = function(data){
					if(window.del_load!=null)
						window.del_load.hide();
					if(data!=null && data.status==true){
						topic.publish("list.refresh");
						dialog.success('归档成功');
					}else{
						dialog.failure('归档失败');
					}
				};
				 window.removeDelBtn = function(){
						if(LUI('del')){
	              	    LUI('Btntoolbar').removeButton(LUI('del'));
	              	    LUI('del').destroy();
	              	   }
					};
					 window.removeChgCateBtn = function(){
							if(LUI('chgCate')){
		              	    LUI('Btntoolbar').removeButton(LUI('chgCate'));
		              	    LUI('chgCate').destroy();
		              	   }
						};
		            window.removeFilingBtn = function(){
						 if(LUI('filingAll')){
	               	    LUI('Btntoolbar').removeButton(LUI('filingAll'));
	               	    LUI('filingAll').destroy();
	               	   }
					};
				/******************************************
				  * 验证权限并显示按钮 
				  * param：
				  *       categoryId 模板id
				  *       nodeType 模板类型
				  *****************************************/
				var AuthCache = {};
				window.showButtons = function(cateId,nodeType){
				 if(AuthCache[cateId]){
		             if(AuthCache[cateId].delBtn){
		            	 if(!LUI('del')){ 
			            	 var delBtn = toolbar.buildButton({id:'del',order:'2',text:'${lfn:message("button.delete")}',click:'delDoc()'});
	    					 LUI('Btntoolbar').addButton(delBtn);
		            	 }
		             }else{
		            	 if(LUI('del')){ 
		            	   LUI('Btntoolbar').removeButton(LUI('del'));
		            	   LUI('del').destroy();
		            	 }
			         }
		             if(AuthCache[cateId].chgCateBtn){
		            	 if(!LUI('chgCate')){ 
			            	 var chgCateBtn = toolbar.buildButton({id:'chgCate',order:'2',text:'${lfn:message("km-imissive:kmImissive.button.translate")}',click:'chgSelect()'});
	    					 LUI('Btntoolbar').addButton(chgCateBtn);
		            	 }
		             }else{
		            	 if(LUI('chgCate')){ 
		            	   LUI('Btntoolbar').removeButton(LUI('chgCate'));
		            	   LUI('chgCate').destroy();
		            	 }
			         }
	             }
	             if(AuthCache[cateId]==null){
					     var checkChgCateUrl = "/km/imissive/km_imissive_send_main/kmImissiveSendMain.do?method=changeTemplate&categoryId="+cateId+"&nodeType="+nodeType;
		                 var checkDelUrl = "/km/imissive/km_imissive_send_main/kmImissiveSendMain.do?method=deleteall&categoryId="+cateId+"&nodeType="+nodeType;
		                 var data = new Array();
		                 data.push(["delBtn",checkDelUrl]);
		                 data.push(["chgCateBtn",checkChgCateUrl]);
		                 $.ajax({
		       			  url: "${LUI_ContextPath}/sys/authorization/SysAuthUrlCheckAction.do?method=checkUrlAuth",
		       			  dataType:"json",
		       			  type:"post",
		       			  data:{"data":LUI.stringify(data)},
		       			  async:false,
		       			  success: function(rtn){
			       			var btnInfo = {};
			       			if(rtn.length > 0){
		       				  for(var i=0;i<rtn.length;i++){
		                 		if(rtn[i]['delBtn'] == 'true'){
		                 		 btnInfo.delBtn = true;
		                 		 if(!LUI('del')){ 
			                 		 var delBtn = toolbar.buildButton({id:'del',order:'2',text:'${lfn:message("button.delete")}',click:'delDoc()'});
			    					 LUI('Btntoolbar').addButton(delBtn);
		                 		 }
		                       }
		                 		if(rtn[i]['chgCateBtn'] == 'true'){
			                 		btnInfo.chgCateBtn = true;
			                 		 if(!LUI('chgCate')){ 
			                 			 var chgCateBtn = toolbar.buildButton({id:'chgCate',order:'2',text:'${lfn:message("km-imissive:kmImissive.button.translate")}',click:'chgSelect()'});
				    					 LUI('Btntoolbar').addButton(chgCateBtn);
			                 		 }
			                       }
		       				  }
			       			}else{
	                    	   btnInfo.delBtn = false;
	                    	   btnInfo.chgCateBtn = false;
	                    	  if(LUI('del')){ 
	                    	    LUI('Btntoolbar').removeButton(LUI('del'));
	                    	    LUI('del').destroy();
	                    	  }
	                    	  if(LUI('chgCate')){ 
		                    	    LUI('Btntoolbar').removeButton(LUI('chgCate'));
		                    	    LUI('chgCate').destroy();
		                      }
			                }
		                 	 AuthCache[cateId] = btnInfo;
		  		          }
	                  });
	               }
	            };
	            window.showFilingBtn = function(cateId,nodeType){
        			 var checkDelUrl ="/km/imissive/km_imissive_send_main/kmImissiveSendMain.do?method=filingall";
					 var data = new Array();
	                 data.push(["filingAllBtn",checkDelUrl]);
	                 $.ajax({
	       			  url: "${LUI_ContextPath}/sys/authorization/SysAuthUrlCheckAction.do?method=checkUrlAuth",
	       			  dataType:"json",
	       			  type:"post",
	       			  data:{"data":LUI.stringify(data)},
	       			  async:false,
	       			  success: function(rtn){
	       				if(rtn.length > 0){
		       				  for(var i=0;i<rtn.length;i++){
		                 		if(rtn[i]['filingAllBtn'] == 'true'){
		                 		if(!LUI('filingAll')){
			                 		 var filingAllBtn = toolbar.buildButton({id:'filingAll',order:'2',text:'${lfn:message("km-imissive:button.filingall")}',click:'filingDoc()'});
			    					 LUI('Btntoolbar').addButton(filingAllBtn);
		                 		}
		                       }
		       				 }
		       			  }else{
		       				removeFilingBtn();
		                  }
		       		  }
	               });
		        };
				<%
				   request.setAttribute("admin",UserUtil.getKMSSUser().isAdmin());
				%>

				//根据筛选器分类异步校验权限
				topic.subscribe('criteria.changed',function(evt){
					if("${admin}"=="false"){
					 removeDelBtn();
					 removeChgCateBtn();
					}
					removeFilingBtn();
					for(var i=0;i<evt['criterions'].length;i++){
					  //获取分类id和类型
	             	  if(evt['criterions'][i].key=="fdTemplate"){
	                 	 var cateId= evt['criterions'][i].value[0];
		                 var nodeType = evt['criterions'][i].nodeType;
		                 //分类变化或者带有分类刷新
		                 showButtons(cateId,nodeType);
	             	  }
	             	  if(evt['criterions'][i].key=="docStatus" && evt['criterions'][i].value.length==1) {
							if(evt['criterions'][i].value[0]=='10') {
								removeDelBtn();
								var delBtn = toolbar.buildButton({id:'del',order:'3',text:'${lfn:message("button.delete")}',click:'delDoc()'});
		    					LUI('Btntoolbar').addButton(delBtn);
							}
							if(evt['criterions'][i].value[0]=="30"){
								showFilingBtn();
		             		}else{
			             		removeFilingBtn();
			             	}
					    }
					}
					//筛选器全部清空的情况
					if(evt['criterions'].length==0){
						 showButtons("","");
					}
				});
			});
		</script>	 
	</template:replace>
</template:include>
