var self = this;
var _reads = File_EXT_READ.split(";");
var _videos = File_EXT_VIDEO.split(";");
var _mp3s = File_EXT_MP3.split(";");
var _edits = File_EXT_EDIT.split(";");

if(this.fdViewType=="simple") { 
	var xtable = $("<table border='0' id='att_xtable_"+this.fdKey+"'></table>");
	if(this.editMode=='view'){
		//查看视图
		if(this.fileList.length > 0){
			for (var i=0;i<this.fileList.length;i++){
				xtable.append(createViewFileTr(this.fileList[i]));
			}
		}
	}else{
		//编辑视图
		for (var i=0;i<this.fileList.length;i++){
			xtable.append(createEditFileTr(this.fileList[i]));
		}
	}
	done(xtable);
}
/** 查看视图 开始 **/ 
function createViewFileTr(file){
	var fileIcon = window.GetIconNameByFileName(file.fileName);
	var fileExt = file.fileName.substring(file.fileName.lastIndexOf("."));
	var xtr = $("<tr id='"+file.fdId+"' class='upload_list_tr'></tr>"); 
	xtr.append("<td class='upload_list_icon'><img src='"+Com_Parameter.ResPath+"style/common/fileIcon/"+fileIcon+"' height='16' width='16' border='0' align='absmiddle' style='margin-right:3px;' /></td>");
	xtr.append($("<td class='upload_list_filename_s'>"+file.fileName+"</td>").click(function() {
		if (self.canRead) {
			readDoc(file);
			return;
		}
		if (self.canDownload) {
			self.downDoc(file.fdId);
			return;
		}
		if (self.canEdit) {
			if ($.inArray(fileExt.toLowerCase(),_edits) > -1) {
				self.editDoc(file.fdId);
				return;
			}
		}
		if (self.canPrint) {
			self.printDoc(file.fdId);
			return;
		}
	}));
	//加入操作列
	xtr.append(createFileOpers(file)); 
	return xtr;
}
function readDoc(file) {
	var fileExt = file.fileName.substring(file.fileName.lastIndexOf("."));
	if ($.inArray(fileExt.toLowerCase(),_reads) > -1) {
		self.readDoc(file.fdId);
	} else if($.inArray(fileExt.toLowerCase(),_videos) > -1) {
		if (self.editMode == 'view' && self.fdModelName == 'kmsMultimediaMain') {
			self.startVideo(file.fdId);
		}
	} else if ($.inArray(fileExt.toLowerCase(),_mp3s) > -1) {
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
		if ($.inArray(fileExt.toLowerCase(),_reads) > -1){
			text = (Attachment_MessageInfo["button.read"]);
		}else if($.inArray(fileExt.toLowerCase(),_videos) > -1){
			if(self.editMode=='view' && self.fdModelName=='kmsMultimediaMain'){
				text = ""+Attachment_MessageInfo["button.play"]+"";
			} 
		}else if($.inArray(fileExt.toLowerCase(),_mp3s) > -1){
			if(self.editMode=='view' && self.fdModelName=='kmsMultimediaMain'){
				text = ""+Attachment_MessageInfo["button.play"]+"";
			}
		}else{
			text = (Attachment_MessageInfo["button.open"]);
		}
		xtd.append($("<div class='upload_opt_view' title='"+text+"'></div>").click(function(){
			if ($.inArray(fileExt.toLowerCase(),_reads) > -1){
				self.readDoc(file.fdId);
			}else if($.inArray(fileExt.toLowerCase(),_videos) > -1){
				if(self.editMode=='view' && self.fdModelName=='kmsMultimediaMain'){
					self.startVideo(file.fdId);
				} 
			}else if($.inArray(fileExt.toLowerCase(),_mp3s) > -1){
				if(self.editMode=='view' && self.fdModelName=='kmsMultimediaMain'){
					self.startMp3(file.fdId);
				}
			}else{
				self.openDoc(file.fdId);
			}
		}));
	}
	if (self.canDownload) {
		xtd.append($("<div class='upload_opt_down' title='"+Attachment_MessageInfo["button.download"]+"'></div>").click(function(){
			self.downDoc(file.fdId);
		}));
	}
	if (self.canEdit) {
		if ($.inArray(fileExt.toLowerCase(),_edits) > -1){
			xtd.append($("<div class='upload_opt_edit' title='"+Attachment_MessageInfo["button.edit"]+"'></div>").click(function(){
				self.editDoc(file.fdId);
			}));
		}
	}
	if (self.canPrint) {
		if ($.inArray(fileExt.toLowerCase(),_reads) > -1){
			xtd.append($("<div class='upload_opt_print' title='"+Attachment_MessageInfo["button.print"]+"'></div>").click(function(){
				self.printDoc(file.fdId);
			}));
		}
	}
	return xtd;
}
/** 查看视图 结束 **/



/** 编辑视图 开始 **/
function createEditFileTr(file){
	var fileExt = file.fileName.substring(file.fileName.lastIndexOf("."));
	var fileIcon = window.GetIconNameByFileName(file.fileName);
	var xtr = $("<tr id='"+file.fdId+"' class='upload_list_tr'></tr>");
	xtr.append("<td class='upload_list_icon'><img src='"+Com_Parameter.ResPath+"style/common/fileIcon/"+fileIcon+"' height='16' width='16' border='0' align='absmiddle' style='margin-right:3px;' /></td>");
	xtr.append("<td class='upload_list_filename'>"+file.fileName+"</td>");  
	xtr.append("<td class='upload_list_progress_img' style='display:none'></td>");
	xtr.append("<td class='upload_list_progress_text' style='display:none'></td>");
	xtr.append("<td class='upload_list_size'>"+self.formatSize(file.fileSize)+"</td>");
	//加入操作列
	xtr.append(createFileOpers(file));
	xtr.append($("<td class='upload_list_status'></td>").append(getStatus(file)));
	return xtr;
}
function getStatus(file){
	if(file.fileStatus == 0){
		return $("<div class='com_btn_link'>"+Attachment_MessageInfo["button.cancelAll"]+"</div>").click(function(){
				self.swfupload.cancelUpload(file.fdId);
		});
	}else if(file.fileStatus == 1){
		return $("<div class='com_btn_link'>"+Attachment_MessageInfo["button.delete"]+"</div>").click(function(){
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
		$("#"+file.fdId).find(".upload_list_progress_img,.upload_list_progress_text").hide();
		$("#"+file.fdId).find(".upload_list_size,.upload_list_operation").show();
		$("#"+file.fdId).find(".upload_list_operation").empty();
		$("#"+file.fdId).find(".upload_list_operation").html(Attachment_MessageInfo["msg.uploadSucess"]);
		$("#"+file.fdId).find(".com_btn_link").html(
			$("<div>"+Attachment_MessageInfo["button.delete"]+"</div>").click(function(){
				if(confirm(""+Attachment_MessageInfo["button.confimdelte"]+"")){
					file.fileStatus = -1;
					$("#"+file.fdId).remove();
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
		$("#"+file.fdId).find(".com_btn_link").html(
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
		$("#"+file.fdId).find(".com_btn_link").html(
			$("<div>"+Attachment_MessageInfo["button.delete"]+"</div>").click(function(){
				file.fileStatus = -1;
				$("#"+file.fdId).remove();
			})
		);
		file.fileStatus = -1;
		alert(message);
	});
}