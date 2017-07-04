define(["dojo/_base/declare",
		"dojo/dom-construct",
		"mui/util",
		"mui/device/device",
		"mui/device/adapter",
        "mui/dialog/Tip",
        "dojox/mobile/sniff",
		"sys/attachment/mobile/js/_AttachmentItem" ],
		function(declare, domConstruct, util, device, adapter, Tip, has, AttachmentItem) {
			return declare(
					"sys.attachment.mobile.js.AttachmentOptListItem",
					[AttachmentItem],{
						baseClass : 'muiAttachmentEditItem muiAttachmentEditOptItem',
						buildItem : function() {
							var attItemTop = domConstruct.create("div", {
								className : "muiAttachmentItemT"
							}, this.containerNode);
							
							var attItemIcon = domConstruct.create("div",{
								className: "muiAttachmentItemIcon"}, attItemTop);
							
							this.uploadDom = domConstruct.create("i",{
								className : "mui mui-plus"
							}, attItemIcon);
							
							if(this.getParent().required == true){
								domConstruct.create("div",{'className':'muiFieldRequired',innerHTML:'*'},attItemTop);
							}
							var attItemBottom = domConstruct.create("div", {
								className : "muiAttachmentItemB muiAttachmentMsg",
								innerHTML : "附件上传"
							}, this.containerNode);
							var devType = device.getClientType();
							if(devType>6 && devType<11){ //kk客户端
								this.connect(this.uploadDom, "click", "_onKKppload");
							}else{
								var inputAtt = {
										type: "file",
										capture : "camera",
										className: "muiAttachmentUploadFile"
								};
								if(this.getParent().fdMulti==true){
									//inputAtt.multiple = 'multiple';  TODO 设置为多选时不能使用照相
								}
								if((has("ios") && has("ios")<6)){
									this.connect(this.uploadDom, "click", function(){
										Tip.tip({
											icon : 'mui mui-warn',
											time: 2000,
											text : '不支持附件上传，请升级到IOS6.0以上'
										});
									});
								}else if((has("android") && has("android")<4)){
									this.connect(this.uploadDom, "click", function(){
										Tip.tip({
											icon : 'mui mui-warn',
											time: 2000,
											text : '不支持附件上传，请升级到ANDROID4.0以上'
										});
									});
								}else{
									this.uploadDom = domConstruct.create("input",inputAtt, attItemTop);
									if(has("android")){//处理andriod下弹出两次选择文件对话框的情况
										this.connect(this.uploadDom, "click", function(evt){
											if (evt.stopPropagation)
												evt.stopPropagation();
											if (evt.cancelBubble)
												evt.cancelBubble = true;
											if (evt.preventDefault)
												evt.preventDefault();
											if (evt.returnValue)
												evt.returnValue = false;
										});
									}
									this.connect(this.uploadDom, "change", "_onUpload");
								}
							}
						},
						
						_onKKppload:function(evt){
							this.selectDiv = domConstruct.create("div",{className:'muiAttachmentUploadArea'}, document.body,'last');
							domConstruct.create("div",{className:'muiAttachmentUploadbak'}, this.selectDiv);
							var optDiv = domConstruct.create("div",{className:'muiAttachmentUploadOpt'}, this.selectDiv);
							var choseDiv = domConstruct.create("div",{className:'muiAttachmentUploadSelect'}, optDiv);
							var camera = domConstruct.create("div",{className:'muiAttachmentUploadCamera',innerHTML:'拍照'}, choseDiv);
							this.connect(camera, "click", "_onCamera");
							var files = domConstruct.create("div",{className:'muiAttachmentUploadFiles',innerHTML:'选取现有的'}, choseDiv);
							var cancel = domConstruct.create("div",{className:'muiAttachmentUploadCancel',innerHTML:'取消'}, optDiv);
							this.connect(files, "click", "_onUpload");
							this.connect(cancel, "click", "_onCancel");
						},
						
						_onCancel:function(evt){
							if(this.selectDiv){
								domConstruct.destroy(this.selectDiv);
								this.selectDiv = null;
							}
						},
						
						_onCamera:function(evt){
							adapter.openCamera({options:this.getParent(), evt : evt});
							if(this.selectDiv){
								domConstruct.destroy(this.selectDiv);
								this.selectDiv = null;
							}
						},
						
						_onUpload:function(evt){
							var target = evt.target;
							if(target)
								target.blur();
							adapter.selectFile({options:this.getParent(), evt : evt});
							if(this.selectDiv){
								domConstruct.destroy(this.selectDiv);
								this.selectDiv = null;
							}
						}
					});
		});