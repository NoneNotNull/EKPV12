define(
		[ "dojo/_base/declare", "dojo/dom-construct", "dojo/dom-class",
				"dojo/dom-style", "dijit/_WidgetBase", "dojo/_base/lang",
				"dojo/dom-geometry","mui/device/device" ],
		function(declare, domConstruct, domClass, domStyle, widgetBase, lang,
				domGeometry,device) {

			return declare(
					'sys.lbpmservice.audit.note.LbpmserviceAuditNodeItem',
					[ widgetBase ],
					{

						baseClass : 'muiLbpmserviceAuditNodeItem',
						// 是否有左侧时间轴
						hasBorder : false,
						fdIsHide : '2',
						store : '',

						_setStoreAttr : function(store) {
							for ( var key in store) {
								this.set(key, store[key]);
							}
							if (store['fdAuditNote'] == undefined)
								this.set('fdAuditNote', '');
						},

						_setFdAuditNoteAttr : function(fdAuditNote) {
							// 起草节点默认处理意见
							// if (this.fdActionKey == 'drafter_submit')
							// this.fdAuditNote = '提交文档';
							// else {
							switch (this.fdIsHide) {
							case '1':
								this.fdAuditNote = '<span class="muiLbpmserviceAuditNodeHide">[隐藏]</span>';
								break;
							case '3':
								this.fdAuditNote = '此审批意见所属节点已删除';
								break;
							default:
								this.fdAuditNote = fdAuditNote;
							}
							// }
						},

						buildRendering : function() {

							this.domNode = this.srcNodeRef
									|| domConstruct
											.create(
													'div',
													{
														className : 'muiLbpmserviceAuditNodeItem'
													});
							this.containerNode = domConstruct
									.create(
											'div',
											{
												className : 'muiLbpmserviceAuditNodeItemContainer'
											}, this.domNode);

							this.inherited(arguments);
						},

						startup : function() {
							this.inherited(arguments);

							this.contentNode = domConstruct.create('div', {
								className : 'muiLbpmserviceAuditNodeContent'
							});

							this.reparent();

							this.noteNode = domConstruct.create('p', {
								className : 'muiLbpmserviceAuditNodeNode',
								innerHTML : this.fdAuditNote
							}, this.contentNode, 'first');

							this.infoNode = domConstruct.create('div', {
								className : 'muiLbpmserviceAuditNodeInfo'
							}, this.containerNode);

							domConstruct
									.create(
											'a',
											{
												innerHTML : '<img class="muiLbpmserviceAuditNodeImage" src="'
														+ this.fdHandlerImage
														+ '" alt="">',
												href : 'javascript:;'
											}, this.infoNode);
							domConstruct.create('h4', {
								innerHTML : this.fdHandlerName
							}, this.infoNode);

							domConstruct
									.create(
											'p',
											{
												innerHTML : '<span>'
														+ this.fdCreateTime
														+ '</span>',
												className : 'muiLbpmserviceAuditNodeDate mui mui-time'
											}, this.infoNode);

							if (this.fdAuditNoteFrom) {
								domConstruct.create('i', {
									innerHTML : '来自' + device.getClientTypeStr(this.fdAuditNoteFrom),
									className : 'muiLbpmserviceAuditNodeFrom'
								}, this.infoNode);
							}

							domConstruct.place(this.contentNode,
									this.containerNode);

							domConstruct
									.create(
											'p',
											{
												className : 'muiLbpmserviceAuditNodeActionName',
												innerHTML : '<em>操作：</em>'
														+ this.fdActionInfo
											}, this.contentNode);

							if (this.hasBorder)
								domClass.add(this.domNode,
										'muiLbpmserviceAuditNodeItemBorder');

							this.subscribe('/mui/lbpmservice/branch_toggle',
									lang.hitch(this, this.branch_toggle));
						},

						branch_toggle : function(obj, evt) {
							if (!evt)
								return;
							if (evt.fdExecutionId == this.fdExecutionId)
								this[evt.methodPrex + 'Item'](evt);
						},

						// 初始化高度，用于动画
						initHeight : function() {
							if (!this.height) {
								var box = domGeometry
										.getContentBox(this.domNode);
								this.height = box.h;
								domStyle.set(this.domNode, {
									'height' : this.height + 'px'
								});
							}
						},

						showItem : function(evt) {

							this.initHeight();

							domStyle.set(this.domNode, {
								'display' : 'block'
							});
							domStyle.set(this.domNode, {
								'height' : this.height + 'px'
							});
						},

						hideItem : function() {

							this.initHeight();

							domStyle.set(this.domNode, {
								'height' : 0
							});
							this.defer(function() {
								domStyle.set(this.domNode, {
									'display' : 'none'
								});
							}, 200);
						},

						reparent : function() {
							var i, idx, len, c;
							for (i = 0, idx = 0,
									len = this.domNode.childNodes.length; i < len; i++) {
								c = this.domNode.childNodes[idx];
								if (c === this.containerNode) {
									idx++;
									continue;
								}
								this.contentNode.appendChild(this.domNode
										.removeChild(c));
							}
						}
					})
		});