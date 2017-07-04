<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<script> 
Com_IncludeFile("jquery.ui.js", "js/jquery-ui/");
</script> 
<script type="text/javascript">
	LUI.ready(
		function(){
			var preNode;//移动元素的原父节点
			$('#all_logs').sortable({ 
				opacity: 0.6, 
				cursor: 'move', 
				items :"li",
				over:function(event, ui) {
					//对原目录进行重新排序
					preNode = ui.item[0].parentNode;
				},
				update: function(event, ui) {
					var liItem = ui.item[0];
					var divIndex = liItem.parentNode.id.substring('kmtopic_log'.length);//fdCatelogList的序列
			
					//对目的目录进行重新排序
					var parentNode = liItem.parentNode;
					var fields = parentNode.getElementsByTagName("li");
					var contentIndex = -1;
					if(fields.length==2){
						$("#"+parentNode.id+"_defaultLi")[0].style.display = 'none';//将默认li隐藏;添加默认li的目的是为了拉文件进目录下更加流畅
					}
					for(var i=0; i<fields.length; i++){
						if(fields[i].innerHTML!=""){
							contentIndex++;;
							$(fields[i].childNodes).each(function(){
								if(this.name){
									this.name = this.name.replace(/fdCatelogList\[\d+\]/g, "fdCatelogList["+divIndex+"]");
									this.name = this.name.replace(/fdCatelogContentList\[\d+\]/g, "fdCatelogContentList["+contentIndex+"]");
								}
							});
						}
					}
					
					//对原目录进行重新排序
					var preFields = preNode.getElementsByTagName("li");
					var preContentIndex = -1;
					var preDivIndex = preNode.id.substring('kmtopic_log'.length);//fdCatelogList的序列
					if(preFields.length<=1){
						$("#"+preNode.id+"_defaultLi")[0].style.display = 'block';//将默认li显示
					}
					for(var i=0; i<preFields.length; i++){
						if(preFields[i].innerHTML!=""){
							preContentIndex++;;
							$(preFields[i].childNodes).each(function(){
								if(this.name){
									this.name = this.name.replace(/fdCatelogList\[\d+\]/g, "fdCatelogList["+preDivIndex+"]");
									this.name = this.name.replace(/fdCatelogContentList\[\d+\]/g, "fdCatelogContentList["+preContentIndex+"]");
								}
							});
						}
					}
				}
			});
			
			$('#lui_kmtopic_attch_list').sortable({ opacity: 0.6,cursor: 'move', update: function() {}});
	});

	//从系统中选择
	var obj;
	function selctBySys(sysObj){
		obj = sysObj;
		Dialog_TreeList(true, null, null, ';', 'kmsKnowledgeCategoryTreeService&docCateId=!{value}', '<bean:message key="kmsKmtopicMain.docCategory" bundle="kms-kmtopic"/>', 'kmsKnowledgeByCateDatabean&categoryId=!{value}',outPutFileInfo, 'kmsKnowledgeBySearch&key=!{keyword}');
		
	}

	function outPutFileInfo(ext){
		var syslogObj = $(obj).parent().parent();//触发该事件的目录
		var syslogId = $(obj).parent().parent()[0].id;
		var syslogIndex;
		if(syslogId == ''){
			syslogObj = $(".lui_kmtopic_log0");//默认目录
			syslogId = "kmtopic_log0";
			syslogIndex = 0;
		}else{
			syslogIndex = syslogId.substring("kmtopic_log".length);
		}
		if(typeof(ext)!="undefined" && ext != null){
			var fileList = ext.GetHashMapArray();
			var liCount = document.getElementById(syslogId).getElementsByTagName("li").length-2;
			if(liCount<=1){
				$("#"+syslogId+"_defaultLi")[0].style.display = 'none';
			}
			for (var i=0;i<fileList.length;i++){
				liCount = liCount + 1;
				syslogObj.append("<li><span class='icon icon_sys'></span><span class='title'>"+fileList[i].text+"</span>"+
						"<input type='hidden' name='fdCatelogList["+syslogIndex+"].fdOrder' value='0'>"+
						"<input type='hidden' name='fdCatelogList["+syslogIndex+"].fdCatelogContentList["+liCount+"].fdKmDescription' value='"+fileList[i].docDescription+"'>"+
						"<input type='hidden' name='fdCatelogList["+syslogIndex+"].fdCatelogContentList["+liCount+"].kmDocPublishTime' value='"+fileList[i].docPublishTime+"'>"+
						"<input type='hidden' name='fdCatelogList["+syslogIndex+"].fdCatelogContentList["+liCount+"].fdKmId' value='"+fileList[i].docId+"'>"+
						"<input type='hidden' name='fdCatelogList["+syslogIndex+"].fdCatelogContentList["+liCount+"].fdKmAuthor' value='"+fileList[i].docAuthorName+"'>"+
						"<input type='hidden' name='fdCatelogList["+syslogIndex+"].fdCatelogContentList["+liCount+"].fdKmCategory' value='"+fileList[i].docCategoryName+"'>"+
						"<input type='hidden' name='fdCatelogList["+syslogIndex+"].fdCatelogContentList["+liCount+"].kmDocSubject' value='"+fileList[i].docSubject+"'>"+
						"<input type='hidden' name='fdCatelogList["+syslogIndex+"].fdCatelogContentList["+liCount+"].fdKnowledgeType' value='"+fileList[i].fdKnowledgeType+"'>"+
						"<input type='hidden' name='fdCatelogList["+syslogIndex+"].fdCatelogContentList["+liCount+"].fdModelName' value='com.landray.kmss.kms.knowledge.model.KmsKnowledgeBaseDoc'>"+
						"<input type='hidden' name='fdCatelogList["+syslogIndex+"].fdCatelogContentList["+liCount+"].fdContentType' value='0'>"+
						"<input type='hidden' name='fdCatelogList["+syslogIndex+"].fdCatelogContentList["+liCount+"].fdKmLink' value='/kms/knowledge/kms_knowledge_base_doc/kmsKnowledgeBaseDoc.do?method=view&fdId="+fileList[i].docId+"&fdKnowledgeType="+fileList[i].fdKnowledgeType+"'>"+
						
						"<span class='delete' onclick='deleteFile(this)'></span></li>");
			}
		}
	}

	
	//附件批量上传
	function categorySelectDialog(attObj) {
		obj = attObj;
		var fdKey = 'attachment';
		var fdTitle = 'kms-kmtopic:kmsKmtopicMain.multidoc';
		var fdCategoryModelName = 'com.landray.kmss.kms.knowledge.model.KmsKnowledgeCategory';
		var categoryIndicateName = 'fdTemplateId';
		var fdModelName = 'com.landray.kmss.kms.multidoc.model.KmsMultidocKnowledge';
		seajs.use( [ 'lui/dialog' ], function(dialog) {
			dialog.simpleCategory(
					'com.landray.kmss.kms.knowledge.model.KmsKnowledgeCategory',
					'fdCategoryId',
					'fdCategoryName',
					false,
					function(param) {
						//点击取消
						if(idStr==undefined)
						{
					     	//dialog.close();
					     	return;
						}
						var idStr = param.id;
						var nameStr = param.name;
						dialog
								.iframe(
										"/kms/knowledge/kms_knowledge_multiple_upload/kmsMultipleUploadMain.do?method=forwordUploadEdit&title="
												+ fdTitle
												+ "&categoryIndicateName="
												+ categoryIndicateName
												+ "&fdCategoryModelName="
												+ fdCategoryModelName
												+ "&fdModelName="
												+ fdModelName
												+ "&fdKey="
												+ fdKey
												+ "&categoryName="
												+ nameStr
												+"&cateId="
												+ idStr, "${lfn:message('kms-kmtopic:kmsKmtopicMain.button.batchImport') }", null, {
											width : 1000,
											height : 500,
											buttons:[
														{
															name : "${lfn:message('button.ok')}",
															value : true,
															focus : true,
															fn : function(value,_dialog) {
																var inputVals = LUI.$('#dialog_iframe').find('iframe')[0].contentWindow.getAttFileInfo(uploadAtt,_dialog);

															}
														}, {
															name : "${ lfn:message('kms-kmtopic:kmsKmtopicMain.batchExcute') }",
															value : false,
															fn : function(value, _dialog) {
																LUI.$('#dialog_iframe').find('iframe')[0].contentWindow.batchUpdate();
															}
														} 
												]
										});
					}, "${lfn:message('kms-kmtopic:kmsKmtopicMain.selectKnowledgeCategory')}", true,{'fdTemplateType':'1,3'});
		});
	}

	//批量上传附件后，将附件信息补充到页面
	var vIndex=0;
	var uploadKey = 0;
	function uploadAtt(data,_dialog){
		var attlogObj = $(obj).parent().parent();//触发该事件的目录
		var attlogId = $(obj).parent().parent()[0].id;
		var attlogIndex;
		if(attlogId == ''){
			attlogObj = $(".lui_kmtopic_log0");//默认目录
			attlogId = "kmtopic_log0";
			attlogIndex = 0;
		}else{
			attlogIndex = attlogId.substring("kmtopic_log".length);
		}

		var _fileNames = eval($(data).find("input[name='attIdAndAttNameJson']")[0].value);
		var liNum = document.getElementById(attlogId).getElementsByTagName("li").length-2;
		if(liNum<=1){
			$("#"+attlogId+"_defaultLi")[0].style.display = 'none';
		}
		var categoryName = $(data).find("input[name='fdCategoryName']")[0].value;
		var fdCategoryId = $(data).find("input[name='fdCategoryId']")[0].value;
		for (var i=0;i<_fileNames.length;i++){
			var attIdNameJson = _fileNames[i].attId+";"+_fileNames[i].attName;
			liNum = liNum + 1;
			var fdKmId = _fileNames[i].attId+"["+uploadKey+"]";
			attlogObj.append("<li><span class='icon icon_att'></span><span class='title'>"+_fileNames[i].attName+"</span>"+
					"<input type='hidden' name='fdCatelogList["+attlogIndex+"].fdOrder' value='0'>"+
					"<input type='hidden' name='fdCatelogList["+attlogIndex+"].fdCatelogContentList["+liNum+"].fdKmDescription' value=''>"+
					"<input type='hidden' name='fdCatelogList["+attlogIndex+"].fdCatelogContentList["+liNum+"].kmDocPublishTime' value=''>"+
					"<input type='hidden' name='fdCatelogList["+attlogIndex+"].fdCatelogContentList["+liNum+"].fdKmId' value='"+fdKmId+"'>"+
					"<input type='hidden' name='fdCatelogList["+attlogIndex+"].fdCatelogContentList["+liNum+"].fdKmAuthor' value=''>"+
					"<input type='hidden' name='fdCatelogList["+attlogIndex+"].fdCatelogContentList["+liNum+"].fdKmCategory' value='"+categoryName+"'>"+
					"<input type='hidden' name='fdCatelogList["+attlogIndex+"].fdCatelogContentList["+liNum+"].kmDocSubject' value='"+_fileNames[i].attName+"'>"+
					"<input type='hidden' name='fdCatelogList["+attlogIndex+"].fdCatelogContentList["+liNum+"].fdKnowledgeType' value='1'>"+
					"<input type='hidden' name='fdCatelogList["+attlogIndex+"].fdCatelogContentList["+liNum+"].fdModelName' value='com.landray.kmss.kms.knowledge.model.KmsKnowledgeBaseDoc'>"+
					"<input type='hidden' name='fdCatelogList["+attlogIndex+"].fdCatelogContentList["+liNum+"].fdContentType' value='1'>"+
					"<span class='edit' onclick='editUploadAtt("+vIndex+",\""+fdCategoryId+"\",this)' id="+attIdNameJson+"></span>"+
					"<span class='delete' onclick='deleteFile(this)'></span></li>");
		}
		var attForms = $(data).find("input");
		for(var j=0;j<attForms.length;j++){
			if(attForms[j].type=="hidden"){
				$(attForms[j]).each(function(){
					if(this.name){
						this.name = "fdMultipleUploadList["+vIndex+"]."+this.name;
					}
					if(this.id){
						this.id = this.id + "["+vIndex+"]";
					}
				});
				$("#attForm").append(attForms[j]);
			}
		}
		vIndex++;
		uploadKey++;
		_dialog.hide();
	}

	//编辑上传的文档附件
	function editUploadAtt(vIndex,fdCategoryId,obj){
		var fdId="";
		var isBatchColumn='false';
		var attIdAndName=obj.id.split(";");
		//如果被编辑过说明缓存中已经存在数据，需要将数据取出，然后呈现
		var formIdObj=document.getElementById(attIdAndName[0]+'_doc['+vIndex+']');
		//批量修改过的formId
		var batchFormIdObj=document.getElementById(attIdAndName[0]+'_batch['+vIndex+']');
		//如果该列属于批量操作列,用批量操作的form代替自身的文档form信息
        if(batchFormIdObj.value.length>3)
        {
        	fdId=batchFormIdObj.value.split(";")[1];
        	isBatchColumn='true';
        }
        else{
        	fdId=formIdObj.value;
        }
		var attEncodeName=encodeURIComponent(encodeURIComponent(attIdAndName[1]));
		var url='${LUI_ContextPath}/kms/knowledge/kms_knowledge_multiple_upload/kmsMultipleUploadEditDoc.do?'+
				'method=edit&fdModelName=com.landray.kmss.kms.multidoc.model.KmsMultidocKnowledge&cateId='+fdCategoryId+
				'&categoryIndicateName=fdTemplateId&attId='+attIdAndName[0]+'&isBatchColumn='+isBatchColumn+
				'&fdId='+fdId+'&attName='+attEncodeName+'&attIndex='+vIndex;
		window.open("<c:url value='"+url+"'/>");
	}
	//添加目录
	function catelogIframe(ctl,obj){
		var catelogTitle;
		var catelogDesc;
		var iframeUrl;
		if(ctl == 0){
			catelogTitle = $(obj).parent().find("input").eq(0)[0].value;
			catelogDesc = $(obj).parent().find("input").eq(1)[0].value;
			iframeUrl = "/kms/kmtopic/kms_kmtopic_main/kmsKmtopicMain_edit_catelog.jsp?catelogTitle="
						+encodeURIComponent(catelogTitle)+"&catelogDesc="+encodeURIComponent(catelogDesc);
		}else{
			iframeUrl = "/kms/kmtopic/kms_kmtopic_main/kmsKmtopicMain_edit_catelog.jsp";
		}
		
		seajs.use(['lui/dialog'],function(dialog){
			dialog.iframe(iframeUrl, 
							"${ lfn:message('kms-kmtopic:kmsKmtopicMain.addDialog') }",
							 null, 
							 {	
								width:720,
								height:340,
								buttons:[
											{
												name : "${lfn:message('button.ok')}",
												value : true,
												focus : true,
												fn : function(value,_dialog) {
													commitForm(ctl,obj);
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

	}
	function commitForm(ctl,obj){
		var logTitle = LUI.$('#dialog_iframe').find('iframe')[0].contentDocument.getElementsByName('catelog_title')[0].value;
		var logDesc = LUI.$('#dialog_iframe').find('iframe')[0].contentDocument.getElementsByName('catelog_desc')[0].value;

		if(logTitle!=""){
			if(ctl == 1){//新增目录
				var divCount = document.getElementById('all_logs').getElementsByTagName('div').length-1;
				$("#all_logs").append("<div id='kmtopic_log"+divCount+"' class='lui_kmtopic_log'><h3 class='kmtopic_headline'>"+
						"<input type='hidden' name='fdCatelogList["+divCount+"].fdName' value='"+logTitle+"'>"+
						"<input type='hidden' name='fdCatelogList["+divCount+"].fdDescription' value='"+logDesc+"'>"+
						"<input type='hidden' name='fdCatelogList["+divCount+"].fdOrder' value='"+divCount+"'>"+
						"<span>"+logTitle+"</span><span class='log_edit' onclick='catelogIframe(0,this)'></span>"+
						"<span class='logDelete' onclick='deleteCatelog(this)'></span>"+
						"<span class='log_icon_sys' onclick='selctBySys(this);'></span>"+
						"<span class='log_icon_attach' onclick='categorySelectDialog(this)'></span>"+
						"<span class='log_icon_exterLink' onclick='editLink(1,this)'></span>"+
						"</h3><li id='kmtopic_log"+divCount+"_defaultLi'></li></div>");
				LUI.$('#dialog_iframe').find('iframe')[0].contentWindow.$dialog.hide();
			}else if(ctl == 0){//编辑目录
				$(obj).parent().find("input").eq(0).val(logTitle);
				$(obj).parent().find("input").eq(1).val(logDesc);
				$(obj).parent().children('span').eq(0).html(logTitle);
				LUI.$('#dialog_iframe').find('iframe')[0].contentWindow.$dialog.hide();
			}
		}
	}


	//添加外部链接
	function editLink(ext,link){
		var _linkTitle;
		var _linkUrl;
		var iframeUrl;
		obj = link;
		
		if(ext == 0){
			_linkTitle = $(link).parent().find("input").eq(0)[0].value;
			_linkUrl = $(link).parent().find("input").eq(1)[0].value;
			iframeUrl = "/kms/kmtopic/kms_kmtopic_main/kmsKmtopicMain_edit_link.jsp?linkTitle="
						+encodeURIComponent(_linkTitle)+"&linkUrl="+_linkUrl;
		}else{
			iframeUrl = "/kms/kmtopic/kms_kmtopic_main/kmsKmtopicMain_edit_link.jsp";
		}
		seajs.use(['lui/dialog'],function(dialog){
			dialog.iframe(iframeUrl, 
							"${ lfn:message('kms-kmtopic:kmsKmtopicMain.addLink') }",
							 null, 
							 {	
								width:720,
								height:200,
								buttons:[
											{
												name : "${lfn:message('button.ok')}",
												value : true,
												focus : true,
												fn : function(value,_dialog) {
													putLink(ext,link);
													
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
			)['link']=link; 
		});
	}
	
	function putLink(ext,link){
		var linklogObj = $(obj).parent().parent();//触发该事件的目录
		var linklogId = $(obj).parent().parent()[0].id;
		var linklogIndex;
		if(linklogId == ''){
			linklogObj = $(".lui_kmtopic_log0");//默认目录
			linklogId = "kmtopic_log0";
			linklogIndex = 0;
		}else{
			linklogIndex = linklogId.substring("kmtopic_log".length);
		}
		
		var link_title = LUI.$('#dialog_iframe').find('iframe')[0].contentDocument.getElementsByName('link_title')[0].value;
		var link_url = LUI.$('#dialog_iframe').find('iframe')[0].contentDocument.getElementsByName('link_url')[0].value;


		//li个数
		var liCount = document.getElementById(linklogId).getElementsByTagName("li").length-2;
		if(liCount<=1){
			$("#"+linklogId+"_defaultLi")[0].style.display = 'none';
		}
		if(link_title!=""&&link_url!=""){
			if(ext == 1){//新增
				liCount = liCount + 1;
				linklogObj.append("<li><span class='icon icon_link'></span><span class='title'>"+link_title+"<span style='margin-left:15px;'>"+link_url+"</span></span>"+
						"<input type='hidden' id='linkTitle' name='fdCatelogList["+linklogIndex+"].fdCatelogContentList["+liCount+"].kmDocSubject' value='"+link_title+"'>"+
						"<input type='hidden' id='linkUrl' name='fdCatelogList["+linklogIndex+"].fdCatelogContentList["+liCount+"].fdKmLink' value='"+link_url+"'>"+
						"<input type='hidden' name='fdCatelogList["+linklogIndex+"].fdCatelogContentList["+liCount+"].fdKmAuthor' value='${kmsKmtopicMainForm.docAuthorName}'>"+
						"<input type='hidden' name='fdCatelogList["+linklogIndex+"].fdCatelogContentList["+liCount+"].fdContentType' value='2'>"+
						"<span class='edit' onclick='editLink(0,this);'></span><span class='delete' onclick='deleteFile(this)'></span></li>");
				
			}else if(ext == 0){//编辑
				$(link).parent().children('span').eq(1).html(link_title+"<span style='margin-left:15px;'>"+link_url+"</span>");
				$(link).parent().find("input[id='linkTitle']").val(link_title);
				$(link).parent().find("input[id='linkUrl']").val(link_url);
			}
			LUI.$('#dialog_iframe').find('iframe')[0].contentWindow.$dialog.hide();
		}
	}

	/*根据类型提交*/
	function commitMethod(commitType, saveDraft) {
		var formObj = document.kmsKmtopicMainForm;

		var docStatus = document.getElementsByName("docStatus")[0];
		if (saveDraft == "true") {
			docStatus.value = "10";
		} else {
			docStatus.value = "20";
		}
		
		if ('save' == commitType) {
			Com_Submit(formObj, commitType);
		} else {
			Com_Submit(formObj, commitType);
		}
	}

	//删除文件节点
	function deleteFile(file){
		var parent = file.parentNode;
		var hier_parent = file.parentNode.parentNode;
		hier_parent.removeChild(parent);//删除节点
		var fields = hier_parent.getElementsByTagName("li");
		if(fields.length<=1){
			var logId = hier_parent.id;
			$("#"+logId+"_defaultLi")[0].style.display = 'block';
		}
		for(var i=0; i<fields.length; i++){
			if(fields[i].innerHTML!=""){
				$(fields[i].childNodes).each(function(){
					if(this.name){
						this.name = this.name.replace(/fdCatelogContentList\[\d+\]/g, "fdCatelogContentList["+(i-1)+"]");
					}
				});
			}
		}
	}

	//删除目录节点
	function deleteCatelog(catelog){
		seajs.use(['lui/dialog'],function(dialog){
			dialog.confirm("${lfn:message('kms-kmtopic:kmsKmtopicMain.deleteLog.confirm')}",function(flag){
				if(flag){
					var logNode = catelog.parentNode.parentNode;//目录节点
					var nextAllNodes = $(logNode).nextAll();//当前目录后的所有目录节点
					var prevNodesSize = $(logNode).prevAll().length - 2;//当前目录前的所有目录个数
					logNode.parentNode.removeChild(logNode);
					for(var i=0; i<nextAllNodes.length; i++){
						$(nextAllNodes[i]).attr('id',"kmtopic_log"+(i+prevNodesSize));//修改目录所在的div的id
						$(nextAllNodes[i].childNodes).each(function(){
							if($(this).attr('class') == 'kmtopic_headline'){//修改目录order
								$(this.childNodes[2]).attr('value',(i+prevNodesSize));
							}
							
							$(this.childNodes).each(function(){
								if(this.name){
									this.name = this.name.replace(/fdCatelogList\[\d+\]/g, "fdCatelogList["+(i+prevNodesSize)+"]");
								}
							});
						});
					}
				}else{
				}
			});
		});
		
	}
	
	/*修改分类*/
	function modifyCate(unClose, isModify) {
		seajs.use(['lui/dialog', 'lui/util/env'],function(dialog, env) {
			if(isModify) {
				//修改分类，弹出确认框
				dialog.confirm("${lfn:message('kms-kmtopic:kmsKmtopicMain.confirmCategory')}", 
						function(flag) {
							if(flag)
								dialogForNewFile();
						}
			    );
			} else dialogForNewFile();

				
			function dialogForNewFile() {
				dialog
				   .simpleCategoryForNewFile(
					"com.landray.kmss.kms.kmtopic.model.KmsKmtopicCategory",
					"/kms/kmtopic/kms_kmtopic_main/kmsKmtopicMain.do?method=add&categoryId=!{id}",
					false, function(rtn) {
						// 无分类状态下（一般于门户快捷操作）创建文档，取消操作同时关闭当前窗口
						if (!unClose && !rtn)
							window.close();
					}, null, LUI.$('input[name=docCategoryId]').val(), "_self",
					true);
			}

	    });
	}

	/*修改辅类别*/
	function modifySecondCate(canClose) {
		seajs.use(['lui/dialog', 'lui/jquery'], function(dialog, $) {
			dialog.simpleCategory({
				modelName: 'com.landray.kmss.kms.kmtopic.model.KmsKmtopicCategory',
				authType: 2,
				idField: 'docSecondCategoriesIds',
				nameField: 'docSecondCategoriesNames',
				mulSelect: true,
				notNull : false,
				canClose: true
			});
		});
	}

	

	//目录跳转
	function catelogScroll(_id,obj) {
		if(_id=='ctn1'){
			LUI('__step').fireJump(0);
		}else if(_id=='ctn2'){
			LUI('__step').fireJump(1);
		}else if(_id=='ctn3'){
			LUI('__step').fireJump(2);
		}
		
		var top = 0;
		if(_id) {
			top =  LUI.$("#" + _id)[0].offsetTop;
			top = top + 40;
			LUI.$('html,body').animate({
				scrollTop:top
			}, 500);
		}
	}

	var catelogflag = false;
	function catelogScrollWindow() {
		if(document.getElementById("ctn1")) {
			LUI.$(window).scroll( function() { 
				if(LUI.$(document).scrollTop() >= 0) {
					if(catelogflag == false) {
						LUI.$("#catelog_bottom").show();
						catelogflag = true;
					}	
				}else {
					LUI.$("#catelog_bottom").hide();
					catelogflag = false;
				}
			});
		}
	}
	seajs.use(['lui/jquery'],function($) {
		$( function() {
			catelogScrollWindow();
		});
	});

	seajs.use( [ 'lui/topic' ], function(topic) {
		topic.subscribe('JUMP.STEP', function(evt) {
			pre_nextValidate(document.getElementById('validate_ele0'),evt);
		});
	});

	var ___validator;
	//点击上一步下一步的验证
	function pre_nextValidate(obj,_evt) {
		//只验证第一个
		if(!Com_Parameter.event["submit"][0]()) {
				_evt.cancel = true;
				return false;
		}
		return true;
	}
	/*切换作者类型*/
	function changeAuthorType(value) {
		LUI.$('#innerAuthor').hide();
		LUI.$('#outerAuthor').hide();
		if (value == 1) {
			LUI.$('#outerAuthor input').attr('validate', '').val('');
			LUI.$('#innerAuthor input').attr('validate', 'required');
			LUI.$('#innerAuthor').show();
		}
		if (value == 2) {
			LUI.$('#innerAuthor input').attr('validate', '').val('');
			LUI.$('#outerAuthor input').attr('validate', 'required');
			LUI.$('#outerAuthor').show();
			changeAuthodInfo(null);
		}
	}

	/**
	* 将部门和岗位修改为作者的部门和岗位
	*/
	function changeAuthodInfo(value) {
		if(value) {//内部作者
			var authorId = value[0];
			LUI.$.ajax({
				url : "<c:out value='${LUI_ContextPath}/kms/kmtopic/kms_kmtopic_main/kmsKmtopicMain.do?method=loadAuthodInfo'/>",
				type : 'post',
				dataType :'json',
				data: {fdId: authorId},
				success : function(data) {
					if (data) {
							LUI.$('input[name=docDeptId]').val(data.depId);
							LUI.$('input[name=docDeptName]').val(data.depName);
							LUI.$('input[name=docPostsIds]').val(data.postsIds);
							LUI.$('input[name=docPostsNames]').val(data.postsNames);
					} 
				},
				error : function(error) {
				}
			});
		} else {//外部作者
			LUI.$('input[name=docDeptId]').val('${kmsKmtopicMainForm.docDeptId}');
			LUI.$('input[name=docDeptName]').val('${kmsKmtopicMainForm.docDeptName}');
			LUI.$('input[name=docPostsIds]').val('${kmsKmtopicMainForm.docPostsIds}');
			LUI.$('input[name=docPostsNames]').val('${kmsKmtopicMainForm.docPostsNames}');
		}
		
	}
	//右边导航条随滚动条定位
	window.onscroll = function(){
		controlLog($('#ctn1'),1);
		controlLog($('#ctn2'),2);
		controlLog($('#ctn3'),3);
	} 
	function controlLog(obj,idx){
		var ctnTop = obj.offset().top;
		var scrollTop = $(this).scrollTop();
		var length = ctnTop-scrollTop;//div与浏览器顶部距离
		if(length <= 250 && length!=0){
			$("#logScorll1").attr("class", "");
			$("#logScorll2").attr("class", "");
			$("#logScorll3").attr("class", "");
			$("#logScorll"+idx).attr("class", "highlight");
		}
	}
</script>