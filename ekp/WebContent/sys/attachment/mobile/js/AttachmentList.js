define(["dojo/_base/declare", "dojo/dom-construct", "dojo/dom-class", "dojo/_base/array",
		"dojo/topic", "dojo/request", "dijit/_WidgetBase", "dijit/_Contained", "dijit/_Container", 
		'mui/dialog/Tip', "mui/util", "mui/device/adapter"],
		function(declare, domConstruct,domClass, array, topic, request, 
				WidgetBase, Contained, Container, Tip, util, adapter) {
			//附件列表
			return declare("sys.attachment.mobile.js.AttachmentList",
					[ WidgetBase, Contained, Container],{
						baseClass:'muiAttachmentList',
				
						eventPrefix : 'attachmentObject_',

						fdKey : '',

						fdModelName : '',

						fdModelId : '',

						fdMulti : true,

						//附件类型 office,pic,byte
						fdAttType : 'byte',

						//附件处理状态
						editMode : 'view',

						delAtts:[],
						
						addAtts:[],
						
						filekeys:[],
						
						required : false,
						
						buildRendering:function(){
							this.inherited(arguments);
							this.eventPrefix = this.eventPrefix + this.fdKey + "_";
							var hiddenPrefix = "attachmentForms." + this.fdKey + "."; 
							if(this.editMode=="edit"){
								domConstruct.create("input",{
									type : 'hidden',
									name : hiddenPrefix + 'fdModelName',
									value: this.fdModelName
								},this.domNode);
								domConstruct.create("input",{
									type : 'hidden',
									name : hiddenPrefix + 'fdModelId',
									value: this.fdModelId
								},this.domNode);
								domConstruct.create("input",{
									type : 'hidden',
									name : hiddenPrefix + 'fdKey',
									value: this.fdKey
								},this.domNode);
								domConstruct.create("input",{
									type : 'hidden',
									name : hiddenPrefix + 'fdAttType',
									value: this.fdAttType
								},this.domNode);
								domConstruct.create("input",{
									type : 'hidden',
									name : hiddenPrefix + 'fdMulti',
									value: this.fdMulti
								},this.domNode);
								this.delAttNode = domConstruct.create("input",{
									type : 'hidden',
									name : hiddenPrefix + 'deletedAttachmentIds'
								},this.domNode);
								this.addAttNode = domConstruct.create("input",{
									type : 'hidden',
									name : hiddenPrefix + 'attachmentIds'
								},this.domNode);
								if(this.extParam)
									domConstruct.create("input",{
										type : 'hidden',
										name : hiddenPrefix + 'extParam',
										value : this.extParam
									},this.domNode);
							}
						},
						
						postCreate : function() {
							this.inherited(arguments);
							if(this.editMode=="edit"){
								this.subscribe(this.eventPrefix + 'start' , "_start");
								this.subscribe(this.eventPrefix + 'success' , "_success");
								this.subscribe(this.eventPrefix + 'fail' , "_fail");
								this.subscribe(this.eventPrefix + 'process' , "_process");
								this.subscribe(this.eventPrefix + 'del' , "_del");
							}
						},
						
						startup:function(){
							this.inherited(arguments);
							this.addAtts = [];
							this.delAtts = [];
							this.filekeys = [];
							var childen = this.getChildren();
							for(var i=0; i<childen.length; i++){
								if(childen[i].fdId){
									this.addAtts.push(childen[i].fdId);
								}
							}
							this.fillAttInfo();
							if(window.Com_Parameter && this.editMode=='edit'){
								var _self = this;
								window.Com_Parameter.event["confirm"].unshift(function() {
									return _self.checkAttRules();
								});
							}
						},
						
						checkAttRules:function(){
							var childArr = this.getChildren();
							if(this.required){
								if(childArr==null || childArr.length<=1){//含操作item
									Tip.tip({
										text : '请上传至少一个附件!'
									});
									return false;
								}
							}
							for(var i=0; i < childArr.length; i++) {
								if(childArr[i].status && childArr[i].status<2){
									Tip.tip({
										text : '附件上传中..'
									});
									return false;
								}
							}
							if (this.filekeys.length > 0) {
								var attachmentObj = window.AttachmentList[this.fdKey];
								if(attachmentObj!=null){
									array.forEach(this.filekeys, function(file) {
										var fdid = attachmentObj.registFile({'filekey':file.filekey,
											'name':file.name});
										if(fdid){
											this.addAtts.push(fdid);
										}
									},this);
								}
							}
							this.fillAttInfo();
							return true;
						},
						
						getChildByFdId:function(_fdId){
							var childArr = this.getChildren();
							for ( var i = 0; i < childArr.length; i++) {
								if(_fdId!=null && childArr[i]._fdId == _fdId){
									return childArr[i];
								}
							}
						},
						
						_start:function(srcObj , evt){
							topic.publish(this.eventPrefix + 'addItem' , this, evt);
						},
						
						_success:function(srcObj , evt){
							var widget = this.getChildByFdId(evt.file._fdId);
							if(widget){
								if(evt.file){
									widget.filekey = evt.file.filekey;
									widget.status = evt.file.status;
									widget.href = evt.file.href;
									this.filekeys.push(evt.file);
								}
								if(widget.uploaded){
									widget.uploaded();
								}
							}
						},
						
						_fail:function(srcObj , evt){
							if(evt.file!=null){
								var widget = this.getChildByFdId(evt.file._fdId);
								widget.status = evt.file.status;
								if(widget && widget.uploadError){
									widget.uploadError(evt.rtn.msg);
								}
							}else{
								Tip.tip({
									icon : 'mui .mui-fail',
									text : evt.rtn.msg
								});
							}
						},
						
						_process:function(srcObj , evt){
							var widget = this.getChildByFdId(evt.file._fdId);
							widget.status = evt.file.status;
							if(widget && widget.changeProgress){
								widget.changeProgress(evt.loaded);
							}
						},
						
						_del:function(srcObj , evt){
							if(evt){
								var widget = evt.widget;
								var filekey = widget.filekey;
								var fdId = widget.fdId;
								if(filekey!=null){
									this.filekeys = array.filter(this.filekeys, function(file) {
										return file.filekey != filekey;
									});
								}
								if(fdId!=null){
									 this.addAtts = array.filter(this.addAtts, function(delId) {
											return delId != fdId;
										});
									 this.delAtts.push(fdId);
								}
								this.removeChild(widget);
								widget.destroy();
								topic.publish("/mui/list/resize",this);
							}
						},
						
						fillAttInfo:function(){
							if(this.addAttNode){
								this.addAttNode.value = this.addAtts.join(";");
							}
							if(this.delAttNode){
								this.delAttNode.value = this.delAtts.join(";");
							}
						}
					});
});