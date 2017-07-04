Com_IncludeFile("swfupload.js", Com_Parameter.ContextPath
				+ "sys/attachment/js/", "js", true);
/**
 * [上传词条名片]
 * 
 * @param {JSON}
 *            settings [对外参数]
 */
var UploadCard = function(settings) {
	var self = this;

	this.getHost = function() {
		var host = location.protocol.toLowerCase() + "//" + location.hostname;
		if (location.port != '' && location.port != '80') {
			host = host + ":" + location.port
		}
		return host;
	}

	this.initial = function() {

	};

	this.fileQueued = function() {
		self.swfupload.startUpload();
	};

	this.createXMLDocument = function(string) {
		var doc;
		if (window.ActiveXObject) {
			doc = new ActiveXObject("Microsoft.XMLDOM");
			doc.async = "false";
			doc.loadXML(string);
		} else {
			doc = new DOMParser().parseFromString(string, "text/xml");
		}
		return doc;
	}

	this.fileQueueError = function(file, errorCode, message) {
		try {
			if (errorCode === SWFUpload.QUEUE_ERROR.QUEUE_LIMIT_EXCEEDED) {
				alert(Attachment_MessageInfo["sysAttMain.error.queueError"]);
				return;
			}
			switch (errorCode) {
				case SWFUpload.QUEUE_ERROR.FILE_EXCEEDS_SIZE_LIMIT :
					alert(Attachment_MessageInfo["error.exceedSingleMaxSize"]
							.replace("{0}", file.name).replace("{1}",
									self.swf_settings.file_size_limit));
					break;
				case SWFUpload.QUEUE_ERROR.ZERO_BYTE_FILE :
					alert(Attachment_MessageInfo["error.zeroError"].replace(
							"{0}", file.name).replace("{1}", 0));
					break;
				case SWFUpload.QUEUE_ERROR.INVALID_FILETYPE :
					alert(Attachment_MessageInfo["error.enabledFileType"]
							.replace("{0}", self.swf_settings.file_types));
					break;
				default :
					alert(Attachment_MessageInfo["error.other"].replace("{0}",
							file.name).replace("{1}", message));
					break;
			}
		} catch (ex) {
			alert(Attachment_MessageInfo["error.other"].replace("{0}",
					file.name).replace("{1}", ex.toString()));
		}
	};

	this.fileDialogComplete = function() {

	};

	this.uploadStart = function() {

	};

	this.uploadProgress = function() {

	};

	this.uploadError = function() {
		try {
			alert(Attachment_MessageInfo["error.other"].replace("{0}",
					file.name).replace("{1}", message));
		} catch (ex) {
		}
	};
	this.uploadSuccess = function(file, serverData) {

	};
	this.uploadComplete = function() {
	};

	this.updatePostParams = function(param) {
		if(self.swfupload){
			self.swfupload.setPostParams(param);		
		}
	};

	this.swf_settings = {
		flash_url : Com_Parameter.ContextPath
				+ "sys/attachment/swf/swfupload.swf",
		upload_url : self.getHost() + Com_Parameter.ContextPath
				+ "sys/attachment/sys_att_main/sysAttMain.do?method=save",
		file_upload_limit : 0,
		file_queue_limit : 0,
		debug : false,
		post_params : {},
		file_types : "*.gif;*.jpg;*.jpeg;*.bmp;*.png;*.tif",
		button_window_mode : SWFUpload.WINDOW_MODE.OPAQUE,
		button_cursor : SWFUpload.CURSOR.HAND,
		swfupload_loaded_handler : self.initial,
		file_queued_handler : self.fileQueued,
		file_queue_error_handler : self.fileQueueError,
		file_dialog_complete_handler : self.fileDialogComplete,
		upload_start_handler : self.uploadStart,
		upload_progress_handler : self.uploadProgress,
		upload_error_handler : self.uploadError,
		upload_success_handler : self.uploadSuccess,
		upload_complete_handler : self.uploadComplete
	};
	var options = $.extend(self.swf_settings, settings);
	self.swfupload = new SWFUpload(options);
	self.swfupload.loadFlash();
}