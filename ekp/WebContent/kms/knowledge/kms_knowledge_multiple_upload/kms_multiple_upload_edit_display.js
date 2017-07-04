var self = this;
if(this.fdViewType=="byte") { 
	var xtable = $("<table border='0' id='att_xtable_"+this.fdKey+"' width='100%'></table>");
		//编辑视图
		for (var i=0;i<this.fileList.length;i++){
			//xtable.append(createCheckOperation(this.fileList[i]));
			xtable.append(createEditFileTr(this.fileList[i]));
		}
	done(xtable);
}

function readDoc(file) {
	var fileExt = file.fileName.substring(file.fileName.lastIndexOf("."));
	if (File_EXT_READ.indexOf(fileExt.toLowerCase()) > -1) {
		self.readDoc(file.fdId);
	} else if (File_EXT_VIDEO.indexOf(fileExt.toLowerCase()) > -1) {
		if (self.editMode == 'view' && self.fdModelName == 'kmsMultimediaMain') {
			self.startVideo(file.fdId);
		}
	} else if (File_EXT_MP3.indexOf(fileExt.toLowerCase()) > -1) {
		if (self.editMode == 'view' && self.fdModelName == 'kmsMultimediaMain') {
			self.startMp3(file.fdId);
		}
	} else {
		self.openDoc(file.fdId);
	}
}

function createFileOpers(file){
	var fileExt = file.fileName.substring(file.fileName.lastIndexOf("."));
	var xtd = $("<td class='upload_list_operation'></td>");
	if (self.canRead) {
		var text = "";
		if (File_EXT_READ.indexOf(fileExt.toLowerCase()) > -1){
			text = (Attachment_MessageInfo["button.read"]);
		}else if(File_EXT_VIDEO.indexOf(fileExt.toLowerCase()) > -1){
			if(self.editMode=='view' && self.fdModelName=='kmsMultimediaMain'){
				text = ""+Attachment_MessageInfo["button.play"]+"";
			} 
		}else if(File_EXT_MP3.indexOf(fileExt.toLowerCase()) > -1){
			if(self.editMode=='view' && self.fdModelName=='kmsMultimediaMain'){
				text = ""+Attachment_MessageInfo["button.play"]+"";
			}
		}else{
			text = (Attachment_MessageInfo["button.open"]);
		}
		xtd.append($("<div class='upload_opt_view' title='"+text+"'></div>").click(function(){
			readDoc(file);
		}));
	}
	if (self.canDownload) {
		xtd.append($("<div class='upload_opt_down' title='"+Attachment_MessageInfo["button.download"]+"'></div>").click(function(){
			self.downDoc(file.fdId);
		}));
	}
	if (self.canEdit) {
		if (File_EXT_EDIT.indexOf(fileExt.toLowerCase()) > -1){
			xtd.append($("<div class='upload_opt_edit' title='"+Attachment_MessageInfo["button.edit"]+"'></div>").click(function(){
				self.editDoc(file.fdId);
			}));
		}
	}
	if (self.canPrint) {
		if (File_EXT_READ.indexOf(fileExt.toLowerCase()) > -1){
			xtd.append($("<div class='upload_opt_print' title='"+Attachment_MessageInfo["button.print"]+"'></div>").click(function(){
				self.printDoc(file.fdId);
			}));
		}
	}
	return xtd;
}
/** 查看视图 结束 **/
function createCheckOperation(){
	var checkText=$('.upload_opt_select');
	if(checkText==undefined||checkText.text()=='')
	{	
		var xtr = $("<tr ></tr>"); 
		var xtd = $("<td colspan='5' class='upload_opt_td'></td>");
		xtd.append($("<div class='upload_opt_checkbox' name='upload_opt_checkbox'style='width:100px'></div>").append($("<LABEL><input type='checkbox' /><span class='upload_opt_select'>"+Attachment_MessageInfo["button.selectAll"]+"</span></LABEL>").click(function(){
			if($(this).find(":checkbox").is(":checked")){
				$(this).find("span").html(Attachment_MessageInfo["button.cancelAll"]);
				$('#att_xtable_'+self.fdKey+'').find(".upload_list_checkbox :checkbox").prop("checked",true);
			}else{			
				$(this).find("span").html(Attachment_MessageInfo["button.selectAll"]);
				$('#att_xtable_'+self.fdKey+'').find(".upload_list_checkbox :checkbox").prop("checked",false);
			}
		})));
		return xtr.append(xtd);
	}
}


/** 编辑视图 开始 **/
function createEditFileTr(file){
	var fileExt = file.fileName.substring(file.fileName.lastIndexOf("."));
	var fileIcon = window.GetIconNameByFileName(file.fileName);
	var maxLenght=file.fileName.lastIndexOf('.')>199?199:file.fileName.lastIndexOf('.');
	var attFileName=file.fileName.substring(0,maxLenght);
	var eachAttIdAndNameJson=file.fdId+';'+attFileName;
	var xtr = $("<tr id='"+file.fdId+"' class='upload_list_tr' value='"+file.fdId+"'></tr>");
	var xtd = $("<td colspan='5' class='upload_opt_td'></td>");
	xtr.append("<td class='upload_list_checkbox'><input type='checkbox' value='"+file.fdId+"'/></td>");
	xtr.append("<td class='upload_list_icon'><img src='"+Com_Parameter.ResPath+"style/common/fileIcon/"+fileIcon+"' height='16' width='16' border='0' align='absmiddle' style='margin-right:3px;' /></td>");
	xtr.append("<td class='upload_list_filename_edit'>"+file.fileName+"</td>");  
	xtr.append("<td class='upload_list_progress_img' style='display:none'></td>");
	xtr.append("<td class='upload_list_progress_text' style='display:none'></td>");
	xtr.append("<td class='upload_list_size'>("+self.formatSize(file.fileSize)+")</td>");
	xtr.append("<td><input type='hidden' id='"+file.fdId+"_idAndName' name='attIdNameJson' value='"+eachAttIdAndNameJson+"'></td>");
	xtr.append("<td><input type='hidden' name='realFileId' value='"+file.fdId+"'></td>");
	//保存编辑后产生的缓存formID,方便提交后去缓存查找对应的文档详细信息
	xtr.append("<td><input type='hidden' id='"+file.fdId+"_doc' name='mainDocId' value=''></td>");
	xtr.append("<td><input type='hidden' id='"+file.fdId+"_partDoc' name='partDoc' value=''></td>");
	//标示那些附件是属于批量操作的，如果为空则说明不是批量
	xtr.append("<td><input type='hidden' id='"+file.fdId+"_batch' name='bachOperate' value=''></td>");
	xtr.append($("<td class='upload_list_status'></td>").append(getStatus(file)));
	//加入操作列
	xtr.append(createFileOpers(file));
	xtr.append("<td style='width:55px;text-align:center'><span style='font-size:12px'>"+Attachment_MessageInfo["sysAttMain.fdFileName"]+":</span></td>");
	xtr.append($("<td>").append($("<input type='text' id='"+file.fdId+"_fileName' name='inputFileName' style='width:150px'  value='"+attFileName+"'>").change(function(){
		var idAndNameColumn=$('#'+file.fdId+'_idAndName');
		var editColumn=$("a[name='"+file.fdId+"_edit']");
		if($(this).val().length<1||$(this).val().length>200){
			$(this).val(attFileName);
			idAndNameColumn.val(file.fdId+';'+attFileName);
			editColumn.attr('id',file.fdId+';'+attFileName);
		}
		if($(this).val()!=attFileName)
		{
			var newAttIdAndNameJson=eachAttIdAndNameJson.substring(0,eachAttIdAndNameJson.indexOf(";")+1)+$(this).val();
			idAndNameColumn.val(newAttIdAndNameJson);
			editColumn.attr('id',newAttIdAndNameJson);
		}
	}))).append("</td>");
	xtr.append("<td style='width:50px;text-align:center'><a href='#' name='"+file.fdId+"_edit' id='"+eachAttIdAndNameJson+"' onclick='redirectEditPage(this)'>"+Attachment_MessageInfo['button.edit']+"</a></td>");
	return xtr;
}
function getStatus(file){
	if(file.fileStatus == 0){//未上传完
		return $("<div class='upload_status com_btn_link'>"+Attachment_MessageInfo["button.cancelAll"]+"</div>").click(function(){
				self.swfupload.cancelUpload(file.fdId);
		});
	}else if(file.fileStatus == 1){//上传成功
		return $("<div class='upload_status com_btn_link'>"+Attachment_MessageInfo["button.delete"]+"</div>").click(function(){
			if(confirm(""+Attachment_MessageInfo["button.confimdelte"]+"")){
				file.fileStatus = -1;
				$("#"+file.fdId).remove();
			}
		});
	}
}
if(this.editMode=='view'){
	
	
	//查看时不需要绑定上传时间
}else{
	//this.off();
	this.on("uploadCreate",function(data){
		var file = data.file;
		$('#att_xtable_'+self.fdKey+'').append(createCheckOperation(file));
		$('#att_xtable_'+self.fdKey+'').append(createEditFileTr(file));
	});
	this.on("uploadStart", function(data){
		var file = data.file; 
		$("#"+file.fdId).find(".upload_list_progress_img,.upload_list_progress_text").show();
		$("#"+file.fdId).find(".upload_list_size,.upload_list_operation").hide();
		$("#"+file.fdId).find(".upload_list_progress_img").append("<div class='upload_progress_border'><div class='upload_progress_val'></div></div>");
		$("#"+file.fdId).find(".upload_list_progress_text").append("<div class='upload_progress_text'>"+Attachment_MessageInfo["button.progress"]+"0%</div>");

	});
	this.on("uploadProgress", function(data){
		var file = data.file;
		var bytesLoaded = data.bytesLoaded;
		var bytesTotal = data.bytesTotal;
		var percent = Math.ceil((bytesLoaded / bytesTotal) * 100);
		$("#"+file.fdId).find(".upload_progress_val").css("width",percent+"%");
		$("#"+file.fdId).find(".upload_progress_text").html(""+Attachment_MessageInfo["button.progress"]+""+percent+"%");
	});
	this.on("uploadSuccess", function(data){
		var file = data.file;
		var serverData = data.serverData; 
		if(file.id != file.fdId){
			$("#"+file.id).attr("id",file.fdId);
		}		
		$("#"+file.fdId).find(".upload_list_progress_img,.upload_list_progress_text").hide();
		$("#"+file.fdId).find(".upload_list_size,.upload_list_operation").show();
		$("#"+file.fdId).find(".upload_list_operation").empty();
		$("#"+file.fdId).find(".upload_list_operation").html(Attachment_MessageInfo["msg.uploadSucess"]);
		$("#"+file.fdId).find(".upload_status").html(
				$("<div>"+Attachment_MessageInfo["button.delete"]+"</div>").click(function(){
					if(confirm(""+Attachment_MessageInfo["button.confimdelte"]+"")){
						file.fileStatus = -1;
						$("#"+file.fdId).remove();
						// 编辑状态下删除发送事件
						self.emit('editDelete',{"file":file});
					}
				})
			);
	});
	this.on("uploadFaied", function(data){
		var file = data.file;
		var serverData = data.serverData;	
		$("#"+file.fdId).find(".upload_list_progress_img,.upload_list_progress_text").hide();
		$("#"+file.fdId).find(".upload_list_size,.upload_list_operation").show();
		$("#"+file.fdId).find(".upload_list_operation").empty();
		$("#"+file.fdId).find(".upload_list_operation").html(Attachment_MessageInfo["msg.uploadFail"]);
		$("#"+file.fdId).find(".upload_status").html(
			$("<div>"+Attachment_MessageInfo["button.delete"]+"</div>").click(function(){
				file.fileStatus = -1;
				$("#"+file.fdId).remove();
			})
		);
		file.fileStatus = -1;
		alert(serverData);
	});
	this.on("uploadError", function(data){
		var file = data.file;
		var errorCode = data.errorCode;
		var message = data.message;
		$("#"+file.fdId).find(".upload_list_progress_img,.upload_list_progress_text").hide();
		$("#"+file.fdId).find(".upload_list_size,.upload_list_operation").show();
		$("#"+file.fdId).find(".upload_list_operation").empty();
		if(errorCode == -280){
			$("#"+file.fdId).find(".upload_list_operation").html(Attachment_MessageInfo["button.cancelupload"]);
		}else{
			$("#"+file.fdId).find(".upload_list_operation").html(Attachment_MessageInfo["msg.uploadFail"]);
		}
		$("#"+file.fdId).find(".upload_status").html(
			$("<div>"+Attachment_MessageInfo["button.delete"]+"</div>").click(function(){
				file.fileStatus = -1;
				$("#"+file.fdId).remove();
			})
		);
		file.fileStatus = -1;
		alert(message);
	});
}