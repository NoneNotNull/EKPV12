/**
 * 酒钢定制_公文view页面附件区域局部刷新    ， caojing 后台添加了附件对象，前台局部刷新
 *	tableObj 附件列表对象所属table对象
 *	jgObj_ 后台返回的附件对象(保存了新增附件信息)
 *	fileType 附件类型(目前只支持word和pdf) true为pdf图标; false为word图标
 *	fdKey 附件fdKey
 */
function _createTrView(tableObj, jgObj_, fileType, fdKey){
	if(tableObj != null && tableObj != undefined && jgObj_){
		/*
		 * 转Pdf功能第一次生成需要局部刷新，后续不需要任何操作
		 * 生成底稿每次都需要局部刷新
		 */
		var fdId = jgObj_.WebGetMsgByName("fd_attMainId");
		if(fdId !=""){
			var attTr = tableObj.insertRow(tableObj.rows.length);
			attTr.className = "upload_list_tr";
			//添加第一行 多选框
			var attTd0 = attTr.insertCell(0);
			attTd0.className = "upload_list_checkbox";
			attTd0.innerHTML = "<INPUT value="+fdId+" type=checkbox name=attach_"+fdKey+"_checkbox>";
			//添加第二行 附件图片
			var attTd1 = attTr.insertCell(1);
			attTd1.className = "upload_list_icon";
			if(fileType){
				attTd1.innerHTML = '<IMG style="MARGIN-RIGHT: 3px" border=0 align=absMiddle src="'+Com_Parameter.ContextPath+'resource/style/common/fileIcon/pdf.png" width=16 height=16>';
			}else{
				attTd1.innerHTML = '<IMG style="MARGIN-RIGHT: 3px" border=0 align=absMiddle src="'+Com_Parameter.ContextPath+'resource/style/common/fileIcon/word.png" width=16 height=16>';
			}
			//添加第三行 附件名称
			var attTd2 = attTr.insertCell(2);
			attTd2.className = "upload_list_filename_view";
			var tdStyle2 = document.createAttribute("style");
			tdStyle2.nodeValue = "cursor:pointer";
			attTd2.setAttributeNode(tdStyle2);
			attTd2.innerHTML = jgObj_.WebGetMsgByName("fd_attMainName");
			//添加第四行 附件大小
			var attTd3 = attTr.insertCell(3);
			attTd3.className = "upload_list_size";
			attTd3.innerHTML = jgObj_.WebGetMsgByName("fd_attMainSize");
			//添加第五行 附件权限
			var attTd4 = attTr.insertCell(4);
			attTd4.className = "upload_list_operation";
			attTd4.innerHTML = "<div title=阅读  class=upload_opt_view></div>";
		}
	}
}


/**
 * 酒钢定制_公文view页面附件区域局部刷新    ， caojing 后台添加了附件对象，前台局部刷新
 *	tableObj 附件列表对象所属table对象
 *	jgObj_ 后台返回的附件对象(保存了新增附件信息)
 *	fileType 附件类型(目前只支持word和pdf) true为pdf图标; false为word图标
 *	fdKey 附件fdKey
 */
function _createTrEdit(tableObj, jgObj_, fileType, fdKey){
	if(tableObj != null && tableObj != undefined && jgObj_){
		/*
		 * 转Pdf功能第一次生成需要局部刷新，后续不需要任何操作
		 * 生成底稿每次都需要局部刷新
		 */
		var fdId = jgObj_.WebGetMsgByName("fd_attMainId");
		if(fdId !=""){
			var attTr = tableObj.insertRow(tableObj.rows.length);
			attTr.className = "upload_list_tr";
			attTr.id = fdId;
			//添加第一行 附件图片
			var attTd0 = attTr.insertCell(0);
			attTd0.className = "upload_list_icon";
			if(fileType){
				attTd0.innerHTML = '<IMG style="MARGIN-RIGHT: 3px" border=0 align=absMiddle src="'+Com_Parameter.ContextPath+'resource/style/common/fileIcon/pdf.png" width=16 height=16>';
			}else{
				attTd0.innerHTML = '<IMG style="MARGIN-RIGHT: 3px" border=0 align=absMiddle src="'+Com_Parameter.ContextPath+'resource/style/common/fileIcon/word.png" width=16 height=16>';
			}
			//添加第二行 附件名称
			var attTd1 = attTr.insertCell(1);
			attTd1.className = "upload_list_filename_edit";
			attTd1.innerHTML = jgObj_.WebGetMsgByName("fd_attMainName");
			
			//添加第三行 上传进度条 (空的)
			var attTd2 = attTr.insertCell(2);
			attTd2.className = "upload_list_progress_img";
			var tdStyle2 = document.createAttribute("style");
			tdStyle2.nodeValue = "display:none";
			attTd2.setAttributeNode(tdStyle2);
			
			//添加第四行 上传附件完成后text说明
			var attTd3 = attTr.insertCell(3);
			attTd3.className = "upload_list_progress_text";
			var tdStyle3 = document.createAttribute("style");
			tdStyle3.nodeValue = "display:none";
			attTd3.setAttributeNode(tdStyle3);
			
			//添加第四行 附件大小
			var attTd4 = attTr.insertCell(4);
			attTd4.className = "upload_list_size";
			attTd4.innerHTML = jgObj_.WebGetMsgByName("fd_attMainSize");
			//添加第五行 附件权限
			var attTd5 = attTr.insertCell(5);
			attTd5.className = "upload_list_operation";
			attTd5.innerHTML = "<div title=阅读  class=upload_opt_view></div>";
			//添加第六行 附件删除权限
			var attTd6 = attTr.insertCell(6);
			attTd6.className = "upload_list_status";
		}
	}
}


/*caojing 公文正文清稿功能
 * 清稿所在附件区域默认为页面
 * */
function qingdraft(){
	var obj_ = document.getElementById("JGWebOffice_editonline");
	var att = document.getElementById("att_xtable_draftAtt");
	var flag = false;
	try {
		if(obj_){
			//标识A，表示保存底稿，否则为保存正文
			obj_.WebSetMsgByName("COMMAND","YES_DRAFT");
			flag=obj_.WebSave(true);
			if(flag){
				alert("清稿成功！");
				//alert('<bean:message bundle="km-missive" key="kmMissiveSendMain.clearDraft.succeed"/>');
			}else{
				alert("清稿失败！");
				//alert('<bean:message bundle="km-missive" key="kmMissiveSendMain.clearDraft.failed"/>');
			}
		}else{
			alert("请先切换阅读模式！");
		}
	} catch (e) {
		alert("清稿失败，抛异常！");
	}finally{
		if(obj_){
			obj_.WebSetMsgByName("COMMAND","NO_DRAFT");
		}
		//清稿成功，刷新页面
		if(flag){
			//删除正文痕迹
			obj_.ClearRevisions();
			
			//清稿成功后需要保存正文
			var saveA = document.getElementsByName("editonline_saveDraft")[0];
			if(saveA != null && saveA != undefined){
				saveA.click();
			}
			
			//根据view或者edit页面局部刷新页面底稿附件区域
			_createTrView(att, obj_,false, "draftAtt");
			/*
			location.reload();
			alert(obj_.WebGetMsgByName("_fdAttMainName"));
			attachmentObject_draftAtt.addDoc(obj_.WebGetMsgByName("fd_attMainName"),obj_.WebGetMsgByName("fd_attMainId"),true,
					obj_.WebGetMsgByName("fd_attMainContentype"),obj_.WebGetMsgByName("fd_attMainSize"),obj_.WebGetMsgByName("fd_attMainFileId"));
			attachmentObject_draftAtt.show();*/
		}
	}
}

/**
 * 正文转pdf
 */
function WebOpenWebSavePDF(flag_type, editonlineFileName){
	var zpdfFlag = false;
	var obj_ = document.getElementById("JGWebOffice_editonline");
	var att = document.getElementById("att_xtable_attachment");
	try{
		if(obj_){
			obj_.WebSetMsgByName("FILE_NAME",editonlineFileName);
			zpdfFlag = obj_.WebSavePDF();
			//StatusMsg(obj_.Status);
			if(zpdfFlag){
				//清稿成功后需要保存正文
				var saveA = document.getElementsByName("editonline_saveDraft")[0];
				if(saveA != null && saveA != undefined){
					saveA.click();
				}
				//根据view或者edit页面局部刷新页面附件区域
				if(flag_type){
					_createTrEdit(att, obj_,true, "attachment");
				}else{
					_createTrView(att, obj_,true, "attachment");
				}
				alert("PDF转换成功！！！ ");
				//location.reload();
			}else{
				alert("PDF转换失败！！！ ");
			}
		}else{
			alert("请先切换阅读模式！");
//			alert("${lfn:message('km-missive:kmissive.button.change.view.first') }");
		}
	}catch(e){
		e.description;
	}
}

/**
 * 盖章
 */
function WebOpenSignature(){
	try{
		var obj_ = document.getElementById("JGWebOffice_editonline");
		obj_.WebOpenSignature(4);
		StatusMsg(obj_.Status);
	}catch(e)
	{
		e.description;
	}
}
/*
 * 下载正文
 */

function DownloadText(){
	var obj_ = document.getElementById("JGWebOffice_editonline");
	obj_.fileName = decodeURIComponent(obj_.fileName);
	if (obj_.WebSaveLocal()){
		alert("下载成功！！！");
	}
}