<%@page import="com.landray.kmss.framework.hibernate.extend.SqlPartitionConfig"%>
<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<%@ page import="com.landray.kmss.util.UserUtil"%>
<template:include ref="default.list">
	<template:replace name="title">${ lfn:message('km-review:table.kmReviewMain') }</template:replace>
	<template:replace name="path">
		<ui:combin ref="menu.path.category">
			<ui:varParams 
				id="categoryId"
				moduleTitle="${ lfn:message('km-review:table.kmReviewMain') }" 
				href="/km/review/"
				modelName="com.landray.kmss.km.review.model.KmReviewTemplate" 
				categoryId="${param.categoryId }"
				extHash ="cri.q=fdTemplate:!{value}" />
		</ui:combin>
	</template:replace>
	<template:replace name="nav">
		<ui:combin ref="menu.nav.create">
			<ui:varParam name="title" value="${ lfn:message('km-review:table.kmReviewMain') }"></ui:varParam>
			<ui:varParam name="button">
				[
					<kmss:authShow roles="ROLE_KMREVIEW_CREATE">
						{
							"text": "${ lfn:message('km-review:kmReviewMain.opt.create') }",
							"href":"javascript:addDoc()",
							"icon": "lui_icon_l_icon_4"
						}
					</kmss:authShow>
				]
			</ui:varParam>
		</ui:combin>
		
		<div class="lui_list_nav_frame">
			<ui:accordionpanel>
				<ui:content title="${ lfn:message('list.search') }">
				<ul class='lui_list_nav_list'>
					<li><a href="javascript:void(0)" onclick="openQuery();LUI('criteria1').setValue('mydoc','create');">${ lfn:message('km-review:kmReviewMain.create.my') }</a></li>
					<li><a href="javascript:void(0)" onclick="openQuery();LUI('criteria1').setValue('mydoc','approval');">${ lfn:message('km-review:kmReviewMain.approval.my') }</a></li>
					<li><a href="javascript:void(0)" onclick="openQuery();LUI('criteria1').setValue('mydoc','approved');">${ lfn:message('km-review:kmReviewMain.approved.my') }</a></li>
					<li><a href="javascript:void(0)" onclick="clearAllValue();">${ lfn:message('km-review:kmReviewMain.portlet.myFlow.all') }</a></li>
				</ul>
				  <ui:operation href="javascript:openPage('${LUI_ContextPath }/km/review/km_review_main/kmReviewMain_preview.jsp')" name="${lfn:message('sys-category:menu.sysCategory.overview') }" target="_self" />
				</ui:content>
				<ui:combin ref="menu.nav.search">
					<ui:varParams modelName="com.landray.kmss.km.review.model.KmReviewMain"/>
				</ui:combin>
				<ui:combin ref="menu.nav.favorite.category">
					<ui:varParams 
						modelName="com.landray.kmss.km.review.model.KmReviewTemplate"
						onClick="LUI('criteria1').setValue('fdTemplate','!{value}');"/>
				</ui:combin>
				<ui:content title="${ lfn:message('list.otherOpt') }" expand="false">
					<ul class='lui_list_nav_list'>
						<li><a href="${LUI_ContextPath }/sys/?module=km/review" target="_blank">${ lfn:message('list.manager') }</a></li>
					</ul>
				</ui:content>
			</ui:accordionpanel>
		</div>
	</template:replace>
	<template:replace name="content"> 
		<list:criteria id="criteria1">
			<list:cri-ref key="docSubject" ref="criterion.sys.docSubject">
			</list:cri-ref>
			<%
				if(SqlPartitionConfig.getInstance().isEnabled("com.landray.kmss.km.review.model.KmReviewMain")){
			%>
			<list:cri-ref title="${ lfn:message('km-review:kmReviewMain.docCreateTime') }" key="partition" ref="criterion.sys.partition" modelName="com.landray.kmss.km.review.model.KmReviewMain" />
			<%
				}
			%>
			<list:cri-ref ref="criterion.sys.category" key="fdTemplate" multi="false" title="分类导航" expand="true">
			  <list:varParams modelName="com.landray.kmss.km.review.model.KmReviewTemplate"/>
			</list:cri-ref>
			<list:cri-criterion title="${ lfn:message('km-review:kmReviewMain.my') }" key="mydoc" multi="false">
				<list:box-select>
					<list:item-select>
						<ui:source type="Static">
							[{text:'${ lfn:message('km-review:kmReviewMain.create.my') }', value:'create'},{text:'${ lfn:message('km-review:kmReviewMain.approval.my') }',value:'approval'}, {text:'${ lfn:message('km-review:kmReviewMain.approved.my') }', value: 'approved'}]
						</ui:source>
					</list:item-select>
				</list:box-select>
			</list:cri-criterion>
			<list:cri-auto modelName="com.landray.kmss.km.review.model.KmReviewMain" property="docStatus"/>
			<list:cri-auto modelName="com.landray.kmss.km.review.model.KmReviewMain" 
				property="fdNumber;docCreator;fdDepartment" />
			<%
				if(SqlPartitionConfig.getInstance().isEnabled("com.landray.kmss.km.review.model.KmReviewMain") == false){
			%>
			<list:cri-auto modelName="com.landray.kmss.km.review.model.KmReviewMain" property="docCreateTime"/>
			<%
				}
			%>
			<list:cri-auto modelName="com.landray.kmss.km.review.model.KmReviewMain" property="docProperties"/>
		</list:criteria>
		
		<div class="lui_list_operation">
			<div style='color: #979797;float: left;padding-top:1px;'>
				${ lfn:message('list.orderType') }：
			</div>
			<div style="float:left">
				<div style="display: inline-block;vertical-align: middle;">
					<ui:toolbar layout="sys.ui.toolbar.sort" style="float:left" >
						<list:sort property="docCreateTime" text="${lfn:message('km-review:kmReviewMain.docCreateTime') }" group="sort.list" value="down"></list:sort>
						<list:sort property="docPublishTime" text="${lfn:message('km-review:kmReviewMain.docPublishTime') }" group="sort.list"></list:sort>
					</ui:toolbar>
				</div>
			</div>
			<div style="float:left;">	
				<list:paging layout="sys.ui.paging.top" > 		
				</list:paging>
			</div>
			<div style="float:right">
				<div style="display: inline-block;vertical-align: middle;">
					<ui:toolbar id="Btntoolbar">
					  	<kmss:authShow roles="ROLE_KMREVIEW_CREATE">
						 	<ui:button text="${lfn:message('button.add')}" id="add" onclick="addDoc()" order="2" ></ui:button>
						</kmss:authShow>
						<kmss:auth
							requestURL="/km/review/km_review_main/kmReviewMain.do?method=deleteall&categoryId=${param.categoryId}&nodeType=${param.nodeType}"
							requestMethod="GET">
						<ui:button id="del" text="${lfn:message('button.delete')}" order="3" onclick="delDoc()"></ui:button>
						</kmss:auth>
						<%-- 收藏 --%>
						<c:import url="/sys/bookmark/import/bookmark_bar_all.jsp" charEncoding="UTF-8">
							<c:param name="fdTitleProName" value="docSubject" />
							<c:param name="fdModelName"	value="com.landray.kmss.km.review.model.KmReviewMain" />
						</c:import>
						<%-- 修改权限 --%>
						<c:import url="/sys/right/import/cchange_doc_right_button.jsp" charEncoding="UTF-8">
							<c:param name="modelName" value="com.landray.kmss.km.review.model.KmReviewMain" />
							<c:param name="authReaderNoteFlag" value="2" />
						</c:import>							
						<%-- 分类转移 --%>
						<kmss:auth
								requestURL="/km/review/km_review_main/kmReviewMain.do?method=changeTemplate&categoryId=${param.categoryId}&nodeType=${param.nodeType}"
								requestMethod="GET">
							<ui:button id="chgCate" text="${lfn:message('km-review:button.translate')}" order="5" onclick="chgSelect();"></ui:button>
						</kmss:auth>	
					</ui:toolbar>
				</div>
			</div>
		</div>
		<ui:fixed elem=".lui_list_operation"></ui:fixed>
		<list:listview cfg-criteriaInit="${empty param.categoryId?'false':'true'}">
			<ui:source type="AjaxJson">
					{url:'/km/review/km_review_index/kmReviewIndex.do?method=list'}
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
	 	});
	 	</script>
	</template:replace>
</template:include>