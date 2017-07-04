define(["dojo/_base/declare",
				"dojo/dom-construct",
				"mui/util",
				"dojo/topic",
				"dojo/_base/lang",
				"dojo/dom-style",
				"dojox/mobile/ProgressBar",
				"sys/attachment/mobile/js/_AttachmentItem",
				"mui/device/adapter"],
		function(declare, domConstruct, util, topic, lang, domStyle,
				ProgressBar, AttachmentItem, AttachmentLinkItem, adapter) {
			//普通附件项展示类
			return declare(
					"sys.attachment.mobile.js.AttachmentEditListItem",
					[ AttachmentItem],{
						baseClass : 'muiAttachmentEditItem',
						
						//-1准备上传,	0上传出错,	1上传中,		2上传成功 ,  3 表示阅读状态
						status : 3,
						
						buildItem : function() {
							var attItemTop = domConstruct.create("div", {
									className : "muiAttachmentItemT " + this.getAttContainerType()
								}, this.containerNode);
							
							this.attItemIcon = domConstruct.create("div",{
								className: "muiAttachmentItemIcon"}, attItemTop);
							if(this.getType() == 'img' && this.status == 3){
								 domConstruct.create("img",{
										align:"middle",
										src: util.formatUrl(this.href)}, this.attItemIcon);
							}else{
								domConstruct.create("i",{
										className : "mui " + this.getAttTypeClass()
									}, this.attItemIcon);
							}
							var delProp = {
									className: "muiAttachmentItemDel", style: {
										display: 'block'
									}
								};
							if(this.status != 3){
								this.statusDiv = domConstruct.create("div",{
									className: "muiAttachmentItemStatus"}, attItemTop);
								 domConstruct.create("i",{
										className: "mui mui-spin mui-loading2"}, this.statusDiv );
								delProp.style.display = 'none';
							}
							this.attItemDel = domConstruct.create("div", delProp , attItemTop);
							domConstruct.create("i",{
									className : "mui mui-close"
								}, this.attItemDel);

							this.connect(this.attItemDel, 'click', lang.hitch(
									this, function(evt) {
										topic.publish('attachmentObject_'
												+ this.key + '_del', this,{
													widget : this
												});
										if (evt.stopPropagation)
											evt.stopPropagation();
										if (evt.cancelBubble)
											evt.cancelBubble = true;
										if (evt.preventDefault)
											evt.preventDefault();
										if (evt.returnValue)
											evt.returnValue = false;
									}));
							var attItemBottom = domConstruct.create("div", {
									className : "muiAttachmentItemB"
								}, this.containerNode);
							var attItemName = domConstruct.create("div", {
									className : "muiAttachmentItemName",
									innerHTML : this.name
								}, attItemBottom);
							if (this.size != null && this.size != '') {
								domConstruct.create("div", {
									className : "muiAttachmentItemSize",
									innerHTML : this.formatFileSize()
								}, attItemBottom);
							}
						},
						
						changeProgress : function(val) {
							//上传进度处理
						},

						uploadError : function(msg) {
							if (this.statusDiv) {
								domConstruct.empty(this.statusDiv);
								this.statusDiv.innerHTML ="上传失败!";
							}
							if (this.delDom) {
								domStyle.set(this.delDom, {
									display : 'block'
								});
							}
						},

						uploaded : function() {//成功处理
							if(this.attItemIcon && this.getType() == 'img' && this.href){
								domConstruct.empty(this.attItemIcon);
								domConstruct.create("img",{
										align:"middle",
										src: util.formatUrl(this.href)}, this.attItemIcon);
							}else{
								domConstruct.create("i",{
									className : "mui " + this.getAttTypeClass()
								}, this.attItemIcon);
							}
							
							if (this.statusDiv ) {
								domConstruct.destroy(this.statusDiv);
								this.statusDiv=null;
							}
							if (this.attItemDel) {
								domStyle.set(this.attItemDel, {
									'display' : 'block'
								});
							}
						}
					});
		});