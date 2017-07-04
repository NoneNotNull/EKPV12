<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<template:include ref="person.home">
	<template:replace name="title">
		<c:out value="${ lfn:message('km-imissive:kmImissive.tree.title') }"></c:out>
	</template:replace>
	<template:replace name="content">  
	<div style="width:100%">
	  <ui:tabpanel layout="sys.ui.tabpanel.light" >
		 <ui:content title="${ lfn:message('km-imissive:kmImissiveSendMain.Send.my') }" style="padding:0;background-color:#f2f2f2;" >
		  <list:criteria id="sendCriteria" channel="status1" expand="true">
				<list:cri-criterion title="${ lfn:message('km-imissive:kmImissiveSendMain.Send.my') }" key="mysend" multi="false"> 
					<list:box-select>
						<list:item-select cfg-required="true" cfg-defaultValue="create">
							<ui:source type="Static">
								[{text:'${ lfn:message('km-imissive:kmImissive.tree.create.my')}', value:'create'}
								,{text:'${ lfn:message('km-imissive:kmImissive.tree.myapproval')}',value:'approval'}
								,{text:'${ lfn:message('km-imissive:kmImissive.tree.myapproved')}', value: 'approved'}
								,{text:'${ lfn:message('km-imissive:kmImissive.tree.sign.my') }', value: 'sign'}]
							</ui:source>
							<ui:event event="selectedChanged" args="evt">
								var vals = evt.values;
								if (vals.length > 0 && vals[0] != null) {
									var val = vals[0].value;
									if (val == 'create') {
										LUI('mysend1').setEnable(true);
										LUI('mysend2').setEnable(false);
									} else if (val == 'approved'||val == 'sign') {
									    LUI('mysend1').setEnable(false);
										LUI('mysend2').setEnable(true);
									}else {
										LUI('mysend1').setEnable(false);
										LUI('mysend2').setEnable(false);
									}
								}
							</ui:event>
						</list:item-select>
					</list:box-select>
				</list:cri-criterion>
				<list:cri-criterion title="${ lfn:message('km-imissive:kmImissiveSendMain.docStatus')}" key="docStatus"> 
					<list:box-select>
						<list:item-select id="mysend1" cfg-enable="true">
							<ui:source type="Static">
								[{text:'${ lfn:message('status.draft')}', value:'10'}
								,{text:'${ lfn:message('status.examine')}',value:'20'}
								,{text:'${ lfn:message('status.refuse')}',value:'11'}
								,{text:'${ lfn:message('status.discard')}',value:'00'}
								,{text:'${ lfn:message('status.publish')}',value:'30'}]
							</ui:source>
						</list:item-select>
					</list:box-select>
				</list:cri-criterion>
				<list:cri-criterion title="${ lfn:message('km-imissive:kmImissiveSendMain.docStatus')}" key="docStatus"> 
					<list:box-select>
						<list:item-select id="mysend2" cfg-enable="false">
							<ui:source type="Static">
								[{text:'${ lfn:message('status.examine')}',value:'20'}
								,{text:'${ lfn:message('status.refuse')}',value:'11'}
								,{text:'${ lfn:message('status.discard')}',value:'00'}
								,{text:'${ lfn:message('status.publish')}',value:'30'}]
							</ui:source>
						</list:item-select>
					</list:box-select>
				</list:cri-criterion>
			</list:criteria>
			<div class="lui_list_operation" id="lui_list_operation_send">
				<div style='color: #979797;float: left;padding-top:1px;'> 
						${ lfn:message('list.orderType') }：
					</div>
					<div style="float:left">
						<div style="display: inline-block;vertical-align: middle;">
							<ui:toolbar layout="sys.ui.toolbar.sort" style="float:left" >
								<list:sort property="docCreateTime" text="${lfn:message('km-imissive:kmImissiveSendMain.docCreateTime') }" group="sort.list" value="down"></list:sort>
								<list:sort property="docPublishTime" text="${lfn:message('km-imissive:kmImissiveSendMain.docPublishTime') }" group="sort.list"></list:sort>
							    <list:sort property="fdDocNum" text="${ lfn:message('km-imissive:kmImissiveSendMain.fdDocNum') }" group="sort.list"></list:sort>
							</ui:toolbar>
						</div>
					</div>
					<div style="float:left;">	
						<list:paging layout="sys.ui.paging.top" > 		
						</list:paging>
					</div>	
					<div style="float:right">
						<div style="display: inline-block;vertical-align: middle;">
							<ui:toolbar count="3" id="sengBtntoolbar">
								<%-- 收藏 --%>
								<c:import url="/sys/bookmark/import/bookmark_bar_all.jsp" charEncoding="UTF-8">
									<c:param name="fdTitleProName" value="docSubject" />
									<c:param name="fdModelName"	value="com.landray.kmss.km.imissive.model.KmImissiveSendMain" />
								</c:import>
								<kmss:authShow roles="ROLE_KMIMISSIVE_SEND_CREATE">
									<ui:button text="${lfn:message('button.add')}" onclick="addSend()" order="2"></ui:button>	
								</kmss:authShow>
								<kmss:auth requestURL="/km/imissive/km_imissive_send_main/kmImissiveSendMain.do?method=deleteall&categoryId=${param.categoryId}&nodeType=${param.nodeType}" requestMethod="GET">
									<ui:button text="${lfn:message('button.delete')}" onclick="delSend()" order="3"></ui:button> 
								</kmss:auth>
								<%-- 修改权限 --%>
								<c:import url="/sys/right/import/cchange_doc_right_button.jsp" charEncoding="UTF-8">
									<c:param name="modelName" value="com.landray.kmss.km.imissive.model.KmImissiveSendMain" />
									<c:param name="authReaderNoteFlag" value="2" />
								</c:import>	
								<%-- 分类转移 --%>
								<kmss:auth
										requestURL="/km/imissive/km_imissive_send_main/kmImissiveSendMain.do?method=changeTemplate&categoryId=${param.categoryId}&nodeType=${param.nodeType}"
										requestMethod="GET">
									<ui:button id="chgCate" text="${lfn:message('km-imissive:kmImissive.button.translate')}" order="3" onclick="chgSelect();"></ui:button>
								</kmss:auth>
							</ui:toolbar>
					 </div>
			   </div>
			</div>
			<ui:fixed elem="#lui_list_operation_send"></ui:fixed>
			<list:listview id="listview" channel="status1">
				<ui:source type="AjaxJson">
						{url:'/km/imissive/km_imissive_send_main/kmImissiveSendMain.do?method=listChildren'}
				</ui:source>
				<list:colTable isDefault="false" layout="sys.ui.listview.columntable" 
					rowHref="/km/imissive/km_imissive_send_main/kmImissiveSendMain.do?method=view&fdId=!{fdId}"  name="columntable">
					<list:col-checkbox></list:col-checkbox>
					<list:col-serial></list:col-serial>
					<list:col-auto props=""></list:col-auto>
				</list:colTable>
			</list:listview> 
		 	<list:paging channel="status1"></list:paging>	 
		 	<script type="text/javascript">
				seajs.use(['lui/jquery','lui/dialog','lui/topic','lui/toolbar'], function($, dialog , topic,toolbar) {

					// 监听新建更新等成功后刷新
					topic.subscribe('successReloadPage', function() {
						topic.channel('status1').publish('list.refresh');
						topic.channel('status2').publish('list.refresh');
						topic.channel('status3').publish('list.refresh');
					});
					
					//新建
					window.addSend = function() {
						dialog.categoryForNewFile(
								'com.landray.kmss.km.imissive.model.KmImissiveSendTemplate',
								'/km/imissive/km_imissive_send_main/kmImissiveSendMain.do?method=add&fdTemplateId=!{id}',false,null,null,null,null,null,true);
					};
					//删除
					window.delSend = function(){
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
										$.param({"List_Selected":values},true),SdelCallback,'json');
							}
						});
					};
					window.SdelCallback = function(data){
						if(window.del_load!=null)
							window.del_load.hide();
						if(data!=null && data.status==true){
							topic.publish("list.refresh");
							dialog.success('<bean:message key="return.optSuccess" />');
						}else{
							dialog.failure('<bean:message key="return.optFailure" />');
						}
					};
					//归档
					window.filingSend = function(){
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
										$.param({"List_Selected":values},true),SfilingCallback,'json');
							}
						});
					};
					window.SfilingCallback = function(data){
						if(window.del_load!=null)
							window.del_load.hide();
						if(data!=null && data.status==true){
							topic.publish("list.refresh");
							dialog.success('归档成功');
						}else{
							dialog.failure('归档失败');
						}
					};

					window.removeFilingSendBtn = function(){
					  if(LUI('filingAllSend')){
	              	    LUI('sengBtntoolbar').removeButton(LUI('filingAllSend'));
	              	    LUI('filingAllSend').destroy();
	              	   }
					};
					 window.showFilingSendBtn = function(){
	        			 var checkDelUrl ="/km/imissive/km_imissive_send_main/kmImissiveSendMain.do?method=filingall";
						 var data = new Array();
		                 data.push(["filingSendBtn",checkDelUrl]);
		                 $.ajax({
		       			  url: "${LUI_ContextPath}/sys/authorization/SysAuthUrlCheckAction.do?method=checkUrlAuth",
		       			  dataType:"json",
		       			  type:"post",
		       			  data:{"data":LUI.stringify(data)},
		       			  async:false,
		       			  success: function(rtn){
		       				if(rtn.length > 0){
			       				  for(var i=0;i<rtn.length;i++){
			                 		if(rtn[i]['filingSendBtn'] == 'true'){
			                 		 if(!LUI('filingAllSend')){
			                 			 var filingSendBtn = toolbar.buildButton({id:'filingAllSend',order:'2',text:'${lfn:message('km-imissive:button.filingall')}',click:'filingSend()'});
				    					 LUI('sengBtntoolbar').addButton(filingSendBtn);
			                 		 }
			                       }
			       				 }
			       			  }else{
			       				removeFilingSendBtn();
			                 }
			       		  }
		               });
			        };
				      //控制归档按钮的显示
					  topic.channel("status1").subscribe('criteria.changed',function(evt){
						  removeFilingSendBtn();
						  if(evt['criterions'].length>0){
							for(var i=0;i<evt['criterions'].length;i++){
							  if(evt['criterions'][i].key == "docStatus"){
									if(evt['criterions'][i].value[0]=="30"||evt['criterions'][i].value[0]=="00"){
										showFilingSendBtn();
										// var filingSendBtn = toolbar.buildButton({id:'filingAllSend',order:'2',text:'${lfn:message('km-imissive:button.filingall')}',click:'filingSend()'});
				    					// LUI('sengBtntoolbar').addButton(filingSendBtn);
									}
								}
							}
						  }else{
							  removeFilingSendBtn();
						  }
					 });
				});
			</script>	
		  </ui:content>
		  <ui:content title="${ lfn:message('km-imissive:kmImissiveReceiveMain.Receive.my') }" style="padding:0;background-color:#f2f2f2;" >
			  <list:criteria id="receiveCriteria" channel="status2" expand="true">
		      <list:cri-criterion title="${ lfn:message('km-imissive:kmImissiveReceiveMain.Receive.my') }" key="myReceive" multi="false">
					<list:box-select>
						<list:item-select cfg-required="true" cfg-defaultValue="create"> 
							<ui:source type="Static">
								[{text:'${ lfn:message('km-imissive:kmImissive.tree.create.my') }', value:'create'}
								,{text:'${ lfn:message('km-imissive:kmImissive.tree.myapproval') }',value:'approval'}
								, {text:'${ lfn:message('km-imissive:kmImissive.tree.myapproved') }', value: 'approved'}]
							</ui:source>
							<ui:event event="selectedChanged" args="evt">
								var vals = evt.values;
								if (vals.length > 0 && vals[0] != null) {
									var val = vals[0].value;
									if (val == 'create') {
										LUI('myReceive1').setEnable(true);
										LUI('myReceive2').setEnable(false);
									} else if (val == 'approved') {
									    LUI('myReceive1').setEnable(false);
										LUI('myReceive2').setEnable(true);
									}else {
										LUI('myReceive1').setEnable(false);
										LUI('myReceive2').setEnable(false);
									}
								}
							</ui:event>
						</list:item-select>
					</list:box-select>
				</list:cri-criterion>
				<list:cri-criterion title="${ lfn:message('km-imissive:kmImissiveReceiveMain.docStatus')}" key="docStatus"> 
					<list:box-select>
						<list:item-select id="myReceive1" cfg-enable="true">
							<ui:source type="Static">
								[{text:'${ lfn:message('status.draft')}', value:'10'}
								,{text:'${ lfn:message('status.examine')}',value:'20'}
								,{text:'${ lfn:message('status.refuse')}',value:'11'}
								,{text:'${ lfn:message('status.discard')}',value:'00'}
								,{text:'${ lfn:message('status.publish')}',value:'30'}]
							</ui:source>
						</list:item-select>
					</list:box-select>
				</list:cri-criterion>
				<list:cri-criterion title="${ lfn:message('km-imissive:kmImissiveReceiveMain.docStatus')}" key="docStatus"> 
					<list:box-select>
						<list:item-select id="myReceive2" cfg-enable="false">
							<ui:source type="Static">
								[{text:'${ lfn:message('status.examine')}',value:'20'}
								,{text:'${ lfn:message('status.refuse')}',value:'11'}
								,{text:'${ lfn:message('status.discard')}',value:'00'}
								,{text:'${ lfn:message('status.publish')}',value:'30'}]
							</ui:source>
						</list:item-select>
					</list:box-select>
				</list:cri-criterion>
		  </list:criteria>
			<div class="lui_list_operation" id="lui_list_operation_Receive">
				<div style='color: #979797;float: left;padding-top:1px;'> 
						${ lfn:message('list.orderType') }：
					</div>
					<div style="float:left">
						<div style="display: inline-block;vertical-align: middle;">
							<ui:toolbar layout="sys.ui.toolbar.sort" style="float:left" >
								<list:sort property="docCreateTime" text="${lfn:message('km-imissive:kmImissiveReceiveMain.docCreateTime') }" group="sort.list" value="down"></list:sort>
								<list:sort property="docPublishTime" text="${lfn:message('km-imissive:kmImissiveReceiveMain.docPublishTime') }" group="sort.list"></list:sort>
								<list:sort property="fdReceiveNum" text="${lfn:message('km-imissive:kmImissiveReceiveMain.fdReceiveNum') }" group="sort.list"></list:sort>
							</ui:toolbar>
						</div>
					</div>
					<div style="float:left;">	
						<list:paging layout="sys.ui.paging.top" > 		
						</list:paging>
					</div>	
					<div style="float:right">
						<div style="display: inline-block;vertical-align: middle;">
							<ui:toolbar count="3" id="recBtntoolbar">
								<%-- 收藏 --%>
								<c:import url="/sys/bookmark/import/bookmark_bar_all.jsp" charEncoding="UTF-8">
									<c:param name="fdTitleProName" value="docSubject" />
									<c:param name="fdModelName"	value="com.landray.kmss.km.imissive.model.KmImissiveReceiveMain" />
								</c:import>
								<kmss:authShow roles="ROLE_KMIMISSIVE_RECEIVE_CREATE">
									<ui:button text="${lfn:message('button.add')}" onclick="addReceive()" order="2"></ui:button>	
								</kmss:authShow>
								<kmss:auth requestURL="/km/imissive/km_imissive_receive_main/kmImissiveReceiveMain.do?method=deleteall&categoryId=${param.categoryId}&nodeType=${param.nodeType}" requestMethod="GET">
									<ui:button text="${lfn:message('button.delete')}" onclick="delReceive()" order="3"></ui:button>
								</kmss:auth>
							</ui:toolbar>
						</div>
			      </div>
			</div>
			<ui:fixed elem="#lui_list_operation_Receive"></ui:fixed>
			<list:listview id="listview2" channel="status2">
				<ui:source type="AjaxJson">
						{url:'/km/imissive/km_imissive_receive_main/kmImissiveReceiveMain.do?method=listChildren'}
				</ui:source>
				<list:colTable isDefault="false" layout="sys.ui.listview.columntable" 
					rowHref="/km/imissive/km_imissive_receive_main/kmImissiveReceiveMain.do?method=view&fdId=!{fdId}"  name="columntable">
					<list:col-checkbox></list:col-checkbox>
					<list:col-serial></list:col-serial>
					<list:col-auto props=""></list:col-auto>
				</list:colTable>
			</list:listview> 
		 	<list:paging channel="status2"></list:paging>	 
		 	<script type="text/javascript">
				seajs.use(['lui/jquery','lui/dialog','lui/topic','lui/toolbar'], function($, dialog , topic,toolbar) {
					//新建
					window.addReceive = function() {
						dialog.categoryForNewFile(
								'com.landray.kmss.km.imissive.model.KmImissiveReceiveTemplate',
								'/km/imissive/km_imissive_receive_main/kmImissiveReceiveMain.do?method=add&fdTemplateId=!{id}',false,null,null,null,null,null,true);
					};
					//删除
					window.delReceive = function(){
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
								$.post('<c:url value="/km/imissive/km_imissive_receive_main/kmImissiveReceiveMain.do?method=deleteall"/>',
										$.param({"List_Selected":values},true),RdelCallback,'json');
							}
						});
					};
					window.RdelCallback = function(data){
						if(window.del_load!=null)
							window.del_load.hide();
						if(data!=null && data.status==true){
							topic.publish("list.refresh");
							dialog.success('<bean:message key="return.optSuccess" />');
						}else{
							dialog.failure('<bean:message key="return.optFailure" />');
						}
					};
					//归档
					window.filingReceive = function(){
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
								$.post('<c:url value="/km/imissive/km_imissive_receive_main/kmImissiveReceiveMain.do?method=filingall"/>',
										$.param({"List_Selected":values},true),RfilingCallback,'json');
							}
						});
					};
					window.RfilingCallback = function(data){
						if(window.del_load!=null)
							window.del_load.hide();
						if(data!=null && data.status==true){
							topic.publish("list.refresh");
							dialog.success('归档成功');
						}else{
							dialog.failure('归档失败');
						}
					};
					window.removeFilingRecBtn = function(){
						  if(LUI('filingAllRec')){
		              	    LUI('recBtntoolbar').removeButton(LUI('filingAllRec'));
		              	    LUI('filingAllRec').destroy();
		              	   }
					};
					window.showFilingRecBtn = function(){
	        			 var checkDelUrl ="/km/imissive/km_imissive_receive_main/kmImissiveReceiveMain.do?method=filingall";
						 var data = new Array();
		                 data.push(["filingRecBtn",checkDelUrl]);
		                 $.ajax({
		       			  url: "${LUI_ContextPath}/sys/authorization/SysAuthUrlCheckAction.do?method=checkUrlAuth",
		       			  dataType:"json",
		       			  type:"post",
		       			  data:{"data":LUI.stringify(data)},
		       			  async:false,
		       			  success: function(rtn){
		       				if(rtn.length > 0){
			       				  for(var i=0;i<rtn.length;i++){
			                 		if(rtn[i]['filingRecBtn'] == 'true'){
			                 		 if(!LUI('filingAllRec')){
			                 			 var filingRecBtn = toolbar.buildButton({id:'filingAllRec',order:'2',text:'${lfn:message('km-imissive:button.filingall')}',click:'filingReceive()'});
					    				 LUI('recBtntoolbar').addButton(filingRecBtn);}
			                       }
			       				 }
			       			  }else{
			       				removeFilingRecBtn();
			                  }
			       		  }
		               });
			        };
					
				      //控制归档按钮的显示
					  topic.channel("status2").subscribe('criteria.changed',function(evt){
						     removeFilingRecBtn();
							if(evt['criterions'].length>0){
								for(var i=0;i<evt['criterions'].length;i++){
								  if(evt['criterions'][i].key == "docStatus"){
									if(evt['criterions'][i].value[0]=="30"||evt['criterions'][i].value[0]=="00"){
										showFilingRecBtn();
										// var filingRecBtn = toolbar.buildButton({id:'filingAllRec',order:'2',text:'${lfn:message('km-imissive:button.filingall')}',click:'filingReceive()'});
				    					// LUI('recBtntoolbar').addButton(filingRecBtn);
									}
								}
							}
						  }else{
							  removeFilingRecBtn();
						  }
					});
				});
			</script>	 
		  </ui:content>
		  <ui:content title="${ lfn:message('km-imissive:kmImissiveSignMain.Sign.my') }" style="padding:0;background-color:#f2f2f2;" >
		  <list:criteria id="signCriteria" channel="status3" expand="true">
				<list:cri-criterion title="${ lfn:message('km-imissive:kmImissiveSignMain.Sign.my') }" key="mysign" multi="false">
					<list:box-select>
						<list:item-select cfg-required="true" cfg-defaultValue="create">
							<ui:source type="Static">
								[{text:'${ lfn:message('km-imissive:kmImissive.tree.create.my')}', value:'create'}
								,{text:'${ lfn:message('km-imissive:kmImissive.tree.myapproval')}',value:'approval'}
								,{text:'${ lfn:message('km-imissive:kmImissive.tree.myapproved')}', value: 'approved'}]
							</ui:source>
							<ui:event event="selectedChanged" args="evt">
								var vals = evt.values;
								if (vals.length > 0 && vals[0] != null) {
									var val = vals[0].value;
									if (val == 'create') {
										LUI('mysign1').setEnable(true);
										LUI('mysign2').setEnable(false);
									} else if (val == 'approved') {
									    LUI('mysign1').setEnable(false);
										LUI('mysign2').setEnable(true);
									}else {
										LUI('mysign1').setEnable(false);
										LUI('mysign2').setEnable(false);
									}
								}
							</ui:event>
						</list:item-select>
					</list:box-select>
				</list:cri-criterion>
				<list:cri-criterion title="${ lfn:message('km-imissive:kmImissiveSignMain.docStatus')}" key="docStatus"> 
					<list:box-select>
						<list:item-select id="mysign1" cfg-enable="true">
							<ui:source type="Static">
								[{text:'${ lfn:message('status.draft')}', value:'10'}
								,{text:'${ lfn:message('status.examine')}',value:'20'}
								,{text:'${ lfn:message('status.refuse')}',value:'11'}
								,{text:'${ lfn:message('status.discard')}',value:'00'}
								,{text:'${ lfn:message('status.publish')}',value:'30'}]
							</ui:source>
						</list:item-select>
					</list:box-select>
				</list:cri-criterion>
				<list:cri-criterion title="${ lfn:message('km-imissive:kmImissiveSignMain.docStatus')}" key="docStatus"> 
					<list:box-select>
						<list:item-select id="mysign2" cfg-enable="false">
							<ui:source type="Static">
								[{text:'${ lfn:message('status.examine')}',value:'20'}
								,{text:'${ lfn:message('status.refuse')}',value:'11'}
								,{text:'${ lfn:message('status.discard')}',value:'00'}
								,{text:'${ lfn:message('status.publish')}',value:'30'}]
							</ui:source>
						</list:item-select>
					</list:box-select>
				</list:cri-criterion>
			</list:criteria>
			<div class="lui_list_operation" id="lui_list_operation_sign">
				   <div style='color: #979797;float: left;padding-top:1px;'> 
						${ lfn:message('list.orderType') }：
					</div>
					<div style="float:left">
						<div style="display: inline-block;vertical-align: middle;">
							<ui:toolbar layout="sys.ui.toolbar.sort" style="float:left" >
								<list:sort property="docCreateTime" text="${lfn:message('km-imissive:kmImissiveSignMain.docCreateTime') }" group="sort.list" value="down"></list:sort>
								<list:sort property="docPublishTime" text="${lfn:message('km-imissive:kmImissiveSignMain.docPublishTime') }" group="sort.list"></list:sort>
							    <list:sort property="fdDocNum" text="${ lfn:message('km-imissive:kmImissiveSignMain.fdDocNum') }" group="sort.list"></list:sort>
							</ui:toolbar>
						</div>
					</div>
					<div style="float:left;">	
						<list:paging layout="sys.ui.paging.top" > 		
						</list:paging>
					</div>	
					<div style="float:right">
						<div style="display: inline-block;vertical-align: middle;">
							<ui:toolbar count="3" id="signBtntoolbar">
								<%-- 收藏 --%>
								<c:import url="/sys/bookmark/import/bookmark_bar_all.jsp" charEncoding="UTF-8">
									<c:param name="fdTitleProName" value="docSubject" />
									<c:param name="fdModelName"	value="com.landray.kmss.km.imissive.model.KmImissiveSignMain" />
								</c:import>
								<kmss:authShow roles="ROLE_KMIMISSIVE_SIGN_CREATE">
									<ui:button text="${lfn:message('button.add')}" onclick="addSign()" order="2"></ui:button>	
								</kmss:authShow>
								<kmss:auth requestURL="/km/imissive/km_imissive_sign_main/kmImissiveSignMain.do?method=deleteall&categoryId=${param.categoryId}&nodeType=${param.nodeType}" requestMethod="GET">
									<ui:button text="${lfn:message('button.delete')}" onclick="delSign()" order="3"></ui:button> 
								</kmss:auth>
							</ui:toolbar>
						 </div>
			     </div>
			</div>
			<ui:fixed elem="#lui_list_operation_sign"></ui:fixed>
			<list:listview id="listview3" channel="status3">
				<ui:source type="AjaxJson">
						{url:'/km/imissive/km_imissive_sign_main/kmImissiveSignMain.do?method=listChildren'}
				</ui:source>
				<list:colTable isDefault="false" layout="sys.ui.listview.columntable" 
					rowHref="/km/imissive/km_imissive_sign_main/kmImissiveSignMain.do?method=view&fdId=!{fdId}"  name="columntable">
					<list:col-checkbox></list:col-checkbox>
					<list:col-serial></list:col-serial>
					<list:col-auto props=""></list:col-auto>
				</list:colTable>
			</list:listview> 
		 	<list:paging channel="status3"></list:paging>	 
		 	<script type="text/javascript">
				seajs.use(['lui/jquery','lui/dialog','lui/topic','lui/toolbar'], function($, dialog , topic,toolbar) {

					//新建
					window.addSign = function() {
						dialog.categoryForNewFile(
								'com.landray.kmss.km.imissive.model.KmImissiveSignTemplate',
								'/km/imissive/km_imissive_sign_main/kmImissiveSignMain.do?method=add&fdTemplateId=!{id}',false,null,null,null,null,null,true);
					};
					//删除
					window.delSign = function(){
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
								$.post('<c:url value="/km/imissive/km_imissive_sign_main/kmImissiveSignMain.do?method=deleteall"/>',
										$.param({"List_Selected":values},true),SidelCallback,'json');
							}
						});
					};
					window.SidelCallback = function(data){
						if(window.del_load!=null)
							window.del_load.hide();
						if(data!=null && data.status==true){
							topic.publish("list.refresh");
							dialog.success('<bean:message key="return.optSuccess" />');
						}else{
							dialog.failure('<bean:message key="return.optFailure" />');
						}
					};
					//归档
					window.filingSign = function(){
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
								$.post('<c:url value="/km/imissive/km_imissive_sign_main/kmImissiveSignMain.do?method=filingall"/>',
										$.param({"List_Selected":values},true),SifilingCallback,'json');
							}
						});
					};
					window.SifilingCallback = function(data){
						if(window.del_load!=null)
							window.del_load.hide();
						if(data!=null && data.status==true){
							topic.publish("list.refresh");
							dialog.success('归档成功');
						}else{
							dialog.failure('归档失败');
						}
					};

					window.removeFilingSignBtn = function(){
						  if(LUI('filingAllSign')){
		              	    LUI('signBtntoolbar').removeButton(LUI('filingAllSign'));
		              	    LUI('filingAllSign').destroy();
		              	   }
					};
					window.showFilingSignBtn = function(){
	        			 var checkDelUrl ="/km/imissive/km_imissive_receive_main/kmImissiveReceiveMain.do?method=filingall";
						 var data = new Array();
		                 data.push(["filingSignBtn",checkDelUrl]);
		                 $.ajax({
		       			  url: "${LUI_ContextPath}/sys/authorization/SysAuthUrlCheckAction.do?method=checkUrlAuth",
		       			  dataType:"json",
		       			  type:"post",
		       			  data:{"data":LUI.stringify(data)},
		       			  async:false,
		       			  success: function(rtn){
		       				if(rtn.length > 0){
			       				  for(var i=0;i<rtn.length;i++){
			                 		if(rtn[i]['filingSignBtn'] == 'true'){
			                 		 if(!LUI('filingAllSign')){
			                 			var filingSignBtn = toolbar.buildButton({id:'filingAllSign',order:'2',text:'${lfn:message('km-imissive:button.filingall')}',click:'filingSign()'});
				    				    LUI('signBtntoolbar').addButton(filingSignBtn);
				    				    }
			       				 }
			       			   }
					       	 }else{
			       				removeFilingSignBtn();
			                  }
			       		  }
		               });
			        };
				      //控制归档按钮的显示
					  topic.channel("status3").subscribe('criteria.changed',function(evt){
						    removeFilingSignBtn();
							if(evt['criterions'].length>0){
							for(var i=0;i<evt['criterions'].length;i++){
							    if(evt['criterions'][i].key == "docStatus"){
									if(evt['criterions'][i].value[0]=="30"||evt['criterions'][i].value[0]=="00"){
										showFilingSignBtn();
										// var filingSignBtn = toolbar.buildButton({id:'filingAllSign',order:'2',text:'${lfn:message('km-imissive:button.filingall')}',click:'filingSign()'});
				    					// LUI('signBtntoolbar').addButton(filingSignBtn);
									}
								}
							}
						  }else{
							   removeFilingSignBtn();
						  }
					 });
				});
			</script>	
		  </ui:content>
		</ui:tabpanel>
	  </div> 
	</template:replace>
</template:include>
