/*******************************************************************************
 * 处理用js
 ******************************************************************************/
define(function(require, exports, module) {
	var topic = require('lui/topic');
	var dialog = require('lui/dialog');
	var lang = require('lang!sys-handover:sysHandoverConfigMain');
    var toogleSpan = "<span class='toogle'>"+lang['sysHandoverConfigMain.show']+"<span>";
    
	var hand = {
			/*查询时全选框*/
		    searchCheckAll:function(){
				  var isChecked = $('#_searchSelectAll').is(":checked"); 
			      $("[name = searchModuleCheckBox]:checkbox").each(function () {
					if (isChecked) {
					      $(this).prop("checked",'checked');
					    } else {
						  $(this).removeAttr("checked");
					    }
			     });
	 		},
	 		/*处理时全选框*/
		    executeCheckAll:function(id){
				  var isChecked = $('#_executeSelectAll').is(":checked"); 
				  $("#"+id).find(":checkbox").each(function () {
					if (isChecked) {
					      $(this).prop("checked",'checked');
					    } else{
					    	if($(this).attr("disabled")!="disabled"){
					    		$(this).removeAttr("checked");
					    	}
					    }
			     });
	 		}, 
	 		/*查询操作*/
	 		searchOperation:function(){
	 			 $("#resultContent").html('');
	 			 var fdFromId = $("input[name='fdFromId']")[0].value;
	 			 if(fdFromId == null||fdFromId ==""){
	 				 dialog.alert(lang['sysHandoverConfigMain.fdFromNameNotNull']);
	 				 return;
	 			 }
	 			 //获取待查询模块
	 			 var keyArr = new Array();
	 			 $("[name = searchModuleCheckBox]:checkbox").each(function () {
		    		 var fdKey ="";
			    	 if($(this).is(":checked")){
			    		checkFdKeys = true;
		    		 	fdKey = $(this).val();
		    		 	keyArr.push(fdKey);
			    	 }
		    	  });
	 			  if(keyArr.length == 0){
			    	  dialog.alert(lang['sysHandoverConfigMain.searchKeysNotNull']);
			    	  return;
			      }
	 			 
	 			 window._hand = this;
	 			 var checkFdKeys = false;
	 			 
	 			 //隐藏搜索区域
 		    	 $("#from_edit").hide();
 		 		 $("#from_view").show();
 		         $("#searchDiv").css("display","none"); 
 		 		 //显示结果区域
 		         $("#resultDiv").slideDown(1,function(){
 		        	_hand.search(keyArr,0,fdFromId);
 		         });
	 		},
	 		//查询异步请求
	 		search:function(keyArr,n,fdFromId){
	 			 if(n>=keyArr.length){
	 				 return;
	 			 }
	 			 var fdKey = keyArr[n];
	 			 var url = Com_SetUrlParameter(location.href, "method", "search");
		    	 var data ={fdKey:fdKey,fdFromId:fdFromId};
		    	 //加载图标
	    		 window.del_load = dialog.loading();
	    		 
		    	 LUI.$.ajax({
						url: url,
						type: 'get',
						dataType: 'json',
						async: true,
						data: data,
						success: function(data, textStatus, xhr) {
				    		 //隐藏loading图标
			    		     if(window.del_load!=null){
							    window.del_load.hide();
							 }
			    		     if(data == false){
			    		    	dialog.failure(lang['sysHandoverConfigMain.searchFailture']); 
			    		     }else{
			    		    	  if(data.total > 0){
			    		    		  _hand.showData(data,"resultContent");
			    		    	  }else{
			    		    		  _hand.showData(data,"noResultContent");
			    		    	  }
			    		     }
			    		     n++;
			    		     _hand.search(keyArr,n,fdFromId);
						}
				  });
	 		},
	 		/*处理操作*/
	 		executeOperation:function(){
	 			//清空主日志ID
	 			$("#mainId").val("");
	 			
	 			var fdToId = $("input[name='fdToId']")[0].value;
	 			//接收人为空确认
	 		    if(fdToId == null||fdToId ==""){
		 		    	dialog.confirm(lang['sysHandoverConfigMain.fdToNameNotNullConfirm'],function(value){
						if(value==true){
							_hand.initExecute();
						}
					 });
	 			 }else{
	 				_hand.initExecute(fdToId);
	 			 }
	 		 },
	 		 /*初始化处理内容*/
	 		 initExecute:function(fdToId){
	 			//获取交接内容
		 			var checkRecoIds = false;
		 			var moduleRecoIds = {};
		 			var moduleArr = new Array();
		 			$("table[name='moduleTable']").each(function () {
		 				var moduleTable = this;
		 				var recordIds = "";
		 				//获取所有listTable下的checkBox
		 				$(this).find(":checkbox").each(function () {
		 					if($(this).attr("ref")=="list"){
			 					if($(this).is(":checked")&&$(this).attr("disabled")!="disabled"){
			 						if(moduleArr.indexOf(moduleTable.id)<0){
			 							  moduleArr.push(moduleTable.id);
			 						}
			 						recordIds += $(this).attr("name")+",";
			 						checkRecoIds = true;
			 					}
		 					}
		 				});
		 				if(moduleArr.indexOf(moduleTable.id)>-1){
		 					moduleRecoIds[moduleTable.id] = recordIds;
		 				}
		 			});
		 			//交接内容为空校验
		 			if(!checkRecoIds){
		 				 dialog.alert(lang['sysHandoverConfigMain.executeContentNotNull']);
		 			}
		 			//交接人和接收人相同
		 		    var fdFromId = $("input[name='fdFromId']")[0].value;
		 			if(fdFromId == fdToId){
		 				 dialog.alert(lang['sysHandoverConfigMain.notEq']);
		 				 return;
		 			}
		 			//生成主日志
		 			var url_c = Com_SetUrlParameter(location.href, "method", "getMainLogId");
					var data_c ={fdFromId:fdFromId,fdToId:fdToId};
					LUI.$.ajax({
						url: url_c,
						type: 'post',
						dataType: 'text',
						async: false,
						data: data_c,
						success: function(data, textStatus, xhr) {
						     if(data!=""){
						    	 $("#mainId").val(data);
						     }
						}
				    });
		 			//异步链式处理
	 				var mainId = $("#mainId").val();
		 			_hand.execute(moduleArr,0,moduleRecoIds,fdFromId,fdToId,mainId);
	 		 },
	 		 execute:function(moduleArr,n,moduleRecoIds,fdFromId,fdToId,mainId){
	 			if(n>=moduleArr.length){
	 				 return;
	 			}
	 		    var module = moduleArr[n];
	 			var recordIds = moduleRecoIds[module];
 				if(recordIds==""){
 					 n++;
				     _hand.execute(moduleArr,n,moduleRecoIds,fdFromId,fdToId,mainId);
				     return;
 				}
 				//每个模块请求一次
 				var url = Com_SetUrlParameter(location.href, "method", "perform");
				var data ={ids:recordIds,fdFromId:fdFromId,fdToId:fdToId,mainId:mainId};
				//加载图标
	    		window.del_load2 = dialog.loading();
				LUI.$.ajax({
					url: url,
					type: 'post',
					dataType: 'json',
					async: true,
					data: data,
					success: function(data, textStatus, xhr) {
						//隐藏loading图标
				    	 if(window.del_load2!=null){
					           window.del_load2.hide();
					     }
					     if(data != ""){
					    	 module = module.replace(/\./g,"\\\.");
						     _hand.afterExecute($("#"+module),data,module);
					     }else{
					    	 dialog.failure(lang['sysHandoverConfigMain.executeFailture']); 
					     }
					     n++;
					     _hand.execute(moduleArr,n,moduleRecoIds,fdFromId,fdToId,mainId);
					 	 if(n == moduleArr.length){
					 		dialog.success(lang['sysHandoverConfigMain.executeEnd']);
					 		 //列表刷新
						     try{
									if(window.opener!=null) {
										try {
											if (window.opener.LUI) {
												window.opener.LUI.fire({ type: "topic", name: "successReloadPage" });
												return;
											}
										} catch(e) {}
										if (window.LUI) {
											LUI.fire({ type: "topic", name: "successReloadPage" }, window.opener);
										}
									}
								}catch(e){
								}
						     
			 			 }
					}
			    });
	 		 },
	 		 showData:function(data,contentId,showCheckBox){
	 			   window.showCheckBox = showCheckBox;
	 			   window._hand = this;
                   var moduleDate = data;
                   var moduleDateArr = moduleDate.item;
                	//三层
                   if(moduleDateArr instanceof Array){
                	  //需要再加一个table
                	  var dataTable = $('<table class="tb_simple table_module" name="moduleTable" id="'+moduleDate.module+'_table"/>');
                	  var dataTr = $('<tr class="module_title" index="'+1+'"/>');
                	  var dataTd = $('<td colspan="2"/>');
                	  if(showCheckBox!=false){
                		  $('<input />',_hand.getCheckBoxConfig(moduleDate,moduleDate.module,"moduleCheckBox")).appendTo(dataTd);
                	  }
                	  //记录数
  	 				  dataTd.append(_hand.getTableTitleMessage(moduleDate.module,moduleDate,"module",false));
                	  dataTd.appendTo(dataTr);
                	  dataTr.appendTo(dataTable);
                	  //无记录不显示二级表格
                	  if(moduleDate.total > 0){
	                	  for(var j=0;j<moduleDateArr.length;j++){
	                		  moduleDate = moduleDateArr[j];
	                		  dataTr = $('<tr class="list"/>');
	      	 			   	  $('<td class="td_left" />').appendTo(dataTr);
	      	 			      dataTd = $('<td/>');
	      	 				  dataTd.append(_hand.getModuleTable(moduleDate));
	      	 				  dataTd.appendTo(dataTr);
	      	 				  dataTr.appendTo(dataTable);
	                	  }
                	  }
                	  $("#"+contentId).append(dataTable);
                   }else{
                	  var dataTable = _hand.getModuleTable(moduleDate);
                	  $("#"+contentId).append(dataTable);
                   }
	 		 },
	 		 afterExecute:function(table,resultJson,module){
	 			 table.find(":checkbox").each(function () {
	 				if($(this).is(":checked")){
	 					if($(this).attr("ref")=="list"){
	 						//失效
	 						$(this).attr('disabled', 'disabled');
	 						if(resultJson.info!=""){
	 							var desc = resultJson.info[$(this).attr("name")];
	 							if(desc!=null){
	 								//显示警告图标
	 								var spanSuccess = $('<span class="span_info" title="'+desc+'"></span>');
	 								$(this).parent().next().append(spanSuccess);
	 							}else{
	 								//添加完成图标
			 						var spanSuccess = $('<span class="span_success"></span>');
			 						$(this).parent().next().append(spanSuccess);
	 							}
	 						}else if(resultJson.err!=""){
	 							//添加错误图标
	 							var desc = resultJson.err[$(this).attr("name")];
	 							if(desc!=null){
	 								//显示错误图标
	 								var spanSuccess = $('<span class="span_err" title="'+desc+'"></span>');
	 								$(this).parent().next().append(spanSuccess);
	 							}else{
	 								//添加完成图标
			 						var spanSuccess = $('<span class="span_success"></span>');
			 						$(this).parent().next().append(spanSuccess);
	 							}
	 						}else{
	 							//添加完成图标
		 						var spanSuccess = $('<span class="span_success"></span>');
		 						$(this).parent().next().append(spanSuccess);
	 						}
	 					}
 					}
	 			 });
	 		 },
	 		 /******************************************
			  * 显示二级表格 
			  * param：
			  *       moduleDate 二级表格数据
			  *****************************************/
	 		 getModuleTable:function(moduleDate){
	 		    var dataTable;
	 		    var checkIdValue ="";
	 			if(moduleDate.item==""){	
	 				dataTable = $('<table class="tb_simple table_module" name="moduleTable" id="'+moduleDate.module+'_table"/>');
	 				checkIdValue = moduleDate.module;
	 			}else{
	 				dataTable = $('<table class="tb_simple table_module" name="itemTable" id="'+moduleDate.item+'_table"/>');
	 				checkIdValue = moduleDate.item;
	 			}
	 			 var dataTr = $('<tr class="tab_data" index="'+1+'"/>');
	 			 var dataTd = $('<td colspan="3"/>');
	 	    if(showCheckBox!=false){	 
		 		    $('<input />',_hand.getCheckBoxConfig(moduleDate,checkIdValue,"moduleCheckBox")).appendTo(dataTd);
	 	    	}
	 	    if(moduleDate.item==""){	 
	 	    	 dataTd.html(dataTd.html()+_hand.getTableTitleMessage(checkIdValue,moduleDate,"module"));
	 		  }else{
	 			 dataTd.html(dataTd.html()+_hand.getTableTitleMessage(checkIdValue,moduleDate,"item"));
	 		  }	
	     		 dataTd.appendTo(dataTr);
	     		 //dataTd2.appendTo(dataTr);
	 			 dataTr.appendTo(dataTable);
	 			 if(moduleDate.total>0){
	 				var dataListTr;
	 				if(moduleDate.item==""){	 
	 					dataListTr = $('<tr class="list" style="display:none" id="'+moduleDate.module+'_list"/>');
	 				}else{
	 					//item列表默认隐藏
	 					dataListTr = $('<tr class="list" style="display:none" id="'+moduleDate.module+'_'+moduleDate.item+'_list"/>');
	 				}
	 				$('<td class="td_left" />').appendTo(dataListTr);
	 				dataTd = $('<td colspan="2"/>');
	 				dataTd.append(_hand.getListTable(moduleDate.handoverRecords));
	 				dataTd.appendTo(dataListTr);
	 				dataListTr.appendTo(dataTable);
	 			 }
	 			 return dataTable;
	 		 },
	 		 /******************************************
			  * 显示明细表 
			  * param：
			  *       handoverRecords 明细表数据
			  *****************************************/
	 		 getListTable:function(handoverRecords){
  	 			 var dataTable = $('<table class="tb_simple table_list" name="listTable"/>');
	 			 var dataTr = $('<tr class="tab_data" index="'+1+'"/>');
	 			 dataTr.appendTo(dataTable);
	 			 for(var i=0;i<handoverRecords.length;i++){
	 				var dataListTr =  $('<tr class="tab_data" index="'+1+'"/>');
	 				var dataTd1 = $('<td class="td_left" />');
	 				var checkBoxName = "";
	 				//构建明细列表
	 			if(showCheckBox!=false){	 
	 			    $('<input />',{type:"checkbox",ref:"list",name:handoverRecords[i].id,val:"1", checked:"checked"}).appendTo(dataTd1);
	 			    dataTd1.appendTo(dataListTr);
	 			    var dataTd2 = $('<td><a href="javascript:openUrl(\''+handoverRecords[i].url+'\');">'+handoverRecords[i].datas+'</a></td>');
	 		        dataTd2.appendTo(dataListTr);
	 			}else{
	 				var index = i+1;
	 				$('<span>'+index+'</span>').appendTo(dataTd1);
		 			dataTd1.appendTo(dataListTr);
	 				var dataTd2 = $('<td colspan="3"><a href="javascript:openUrl(\''+handoverRecords[i].url+'\');">'+handoverRecords[i].datas+'</a></td>');
		 		    dataTd2.appendTo(dataListTr);
	 			}
	 		      
	 		        dataListTr.appendTo(dataTable);
	 			 }
	 			 return dataTable;
	 		 },
	 		//折叠/展开
			 toggleOperation:function(obj){
	 			    var id = $(obj).attr("name");
	 			    id = id.replace(/\./g,"\\\.");
	 			    if($("#"+id+"_list").is(":hidden")){
	 			    	$("#"+id+"_list").slideDown(1,function(){
	 			    		 $(obj).text(lang['sysHandoverConfigMain.hide']);
	 			    		 $(obj).removeClass("a_spead").addClass("a_retract");
	 			    	});
	 			    }else{
	 			    	$("#"+id+"_list").slideUp(1,function(){
	 			    		$(obj).text(lang['sysHandoverConfigMain.show']);
	 			    		$(obj).removeClass("a_retract").addClass("a_spead");
	 			    	});
		 			 }
	 			// });		
			 },
			 //获取表头
			 getTableTitleMessage:function(labelFor,moduleDate,type,showToggle){
				 var recodeMessage ='<label for="'+labelFor+'">';
				 var spanId = "";
				 if(moduleDate.total==0){
					 recodeMessage +=  '<span class="no_recode_message">';
				 }
				 if(type=="module"){
					 recodeMessage +=  moduleDate.moduleMessageKey;
					 spanId = moduleDate.module;
				 }else if(type="item"){
					 recodeMessage +=  moduleDate.itemMessageKey;
					 spanId = moduleDate.module+"_"+moduleDate.item;
				 }
				 if(moduleDate.total==0){
					 recodeMessage += '<span class="count_recode">('+lang['sysHandoverConfigMain.noRecodes']+')</span></span>';
				 }else{
					 recodeMessage += '<span class="count_recode">(<span class="number">'+moduleDate.total+'</span>'+lang['sysHandoverConfigMain.recodes']+')</span>';
				 }
				 recodeMessage += '</label>';
				 
				 if(moduleDate.total!=0 && showToggle!= false) {
					recodeMessage += '<span class="a_spead" name="'+spanId+'" onclick="_hand.toggleOperation(this);">'+lang["sysHandoverConfigMain.show"]+'</span>';
				 }
				 return recodeMessage;
			 },
			 //获取checkBox配置
			 getCheckBoxConfig:function(moduleDate,id,name){
				 var config = {
						 	type : "checkbox",
						 	id : id,
						 	name : name,
						 	onclick : "moduleCheckOperation(this)",
						 	val : "1"
				 };
				 if(moduleDate.total == 0 ){
					 config.disabled = "disabled";
				 }else{
					 config.checked = "checked";
				 }
				 return config;
			 },
			 //一键展开/折叠
			 oneKeySpead:function(isSpead){
				 if(isSpead==true){
					 $(".a_spead").each(function(){
						_hand.toggleOperation(this);
					 });
				 }else{
					 $(".a_retract").each(function(){
							_hand.toggleOperation(this);
					 });
				 }
			 }
	  };
	 /*****************************************
	  *  对外使用
	 *****************************************/
	 module.exports = hand;
});
