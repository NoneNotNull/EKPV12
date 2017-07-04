define(["dojo/_base/declare",
				"dojo/dom-construct",
				"mui/util",
				"dojo/topic",
				"dojo/_base/lang",
				"dojo/dom-style",
				"dojox/mobile/ProgressBar",
				"sys/attachment/mobile/js/_AttachmentItem",
				"sys/attachment/mobile/js/_AttachmentLinkItem",
				"mui/device/adapter",
				"sys/attachment/mobile/js/_AttachmentViewOnlineMixin"],
		function(declare, domConstruct, util, topic, lang, domStyle,
				ProgressBar, AttachmentItem, AttachmentLinkItem, adapter, _AttachmentViewOnlineMixin) {
			//普通附件项展示类
			return declare(
					"sys.attachment.mobile.js.AttachmentViewListItem",
					[ AttachmentItem, AttachmentLinkItem, _AttachmentViewOnlineMixin],{
						//-1准备上传,	0上传出错,	1上传中,		2上传成功 ,  3 表示阅读状态
						status : 3,
						buildItem : function() {
							if(!this.justDiaplayName){
								var itemL = domConstruct.create("div", {
									className : "muiAttachmentItemL " +
									this.getAttContainerType()
								}, this.containerNode);
								this.attItemIcon = domConstruct.create("div",{
									className: "muiAttachmentItemIcon"}, itemL);
								if(this.getType() == 'img'){
									domConstruct.create("img",{
										align:"middle",
										src: util.formatUrl(this.href)}, this.attItemIcon);
								}else{
									var iconClass = this.getAttTypeClass();
									if (this.icon != null && this.icon != '') {
										iconClass = this.icon;
									}
									domConstruct.create("i", {
										className :  iconClass
									}, this.attItemIcon);
								}
							}
							var itemC = domConstruct.create("div", {
								className : "muiAttachmentItemC"
							}, this.containerNode);
							domConstruct.create("span", {
								className : "muiAttachmentItemName",
								innerHTML : this.name
							}, itemC);
							if (this.size != null && this.size != '') {
								domConstruct.create("span", {
									className : "muiAttachmentItemSize",
									innerHTML : this.formatFileSize()
								}, itemC);
							}
							if (this.status != 3) {
								var progress = domConstruct.create("div", {
									className : "muiAttachmentItemProgress"
								}, itemC);
								this.progressBar = new ProgressBar({
									maximum : 100,
									value : "0%",
									label : '0%'
								});
								progress.appendChild(this.progressBar.domNode);
								this.progressBar.startup();
							}
							if (this.href && this.edit == false) {
								this.connect(this.containerNode, "click",lang.hitch(this._onItemClick));
							}

							this.itemR = domConstruct.create("div", {
								className : "muiAttachmentItemR"
							}, this.containerNode);
							if (this.edit == false) {
								domConstruct.create(
												"i",{
													className : "muiAttachmentItemExpand mui mui-forward"
												}, this.itemR);
							} else {
								var prop = {
									className : "muiAttachmentItemDel",
									innerHTML : "删除",
									style : {
										display : 'none'
									}
								};
								if (this.status == 3 || this.status == 2) {
									prop.style.display = 'block';
								}
								this.delDom = domConstruct.create("i", prop,
										this.itemR);
								
								this.connect(this.delDom, 'click', lang.hitch(
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
							}
						},
						
						_downLoad : function() {
							adapter.download({
								fdId : this.fdId,
								name : this.name,
								type : this.type,
								href : this.href
							});
						},
						
						_onItemClick : function() {
							this._onClick(arguments);
							if(this.inherited(arguments))
								return;
							this._downLoad();
						},

						changeProgress : function(val) {
							if (this.progressBar) {
								var percent = '';
								if (typeof (val) == 'string') {
									percent = val.indexOf("%") != -1 ? (''
											+ (parseFloat(val) * 100 / this.size) + '%')
											: val;
								} else {
									percent = '' + (val * 100 / this.size)
											+ '%';
								}
								this.progressBar.set('value', percent);
								this.progressBar.set('label', percent);
							}
						},

						uploadError : function(msg) {
							if (this.progressBar) {
								this.progressBar.set('value', "0%");
								this.progressBar.set('label', msg);
							}
							if (this.delDom) {
								domStyle.set(this.delDom, {
									display : 'block'
								});
							}
						},

						uploaded : function() {
							if (this.progressBar) {
								this.progressBar.set('value', "100%");
								this.progressBar.set('label', '上传成功');
								this.defer(function() {
									// this.progressBar.destroy();
								}, 200);
							}
							if (this.delDom) {
								domStyle.set(this.delDom, {
									'display' : 'block'
								});
							}
						}

					});
		});