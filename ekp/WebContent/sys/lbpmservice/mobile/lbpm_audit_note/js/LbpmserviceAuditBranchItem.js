define(
		[ "dojo/_base/declare", "dojo/dom-construct", "dojo/dom-class",
				"dojo/dom-style", "dijit/_WidgetBase", "dojo/_base/lang",
				"dojo/topic" ],
		function(declare, domConstruct, domClass, domStyle, widgetBase, lang,
				topic) {

			return declare(
					'sys.lbpmservice.audit.note.LbpmserviceAuditBranchItem',
					[ widgetBase ],
					{

						baseClass : 'muiLbpmserviceAuditBranchItem',
						// 操作id
						fdExecutionId : '',
						// 父操作id
						fdParentExecutionId : '',
						// 节点名称
						fdFactNodeName : '',

						store : null,

						// 根据数据对象初始化具体属性
						setStoreAttr : function() {
							if (!this.params || !this.params.store)
								return;
							var store = this.params.store;
							for ( var key in store) {
								if (typeof (this[key]) != 'undefined')
									this.set(key, store[key]);
							}
						},

						buildRendering : function() {

							this.setStoreAttr();
							this.domNode = this.containerNode = this.srcNodeRef;

							var contentNode = domConstruct.create('div', {
								className : 'muiLbpmserviceAuditBranchContent'
							}, this.domNode);

							this.titleNode = domConstruct.create('span', {
								className : 'muiLbpmserviceAuditBranchTitle',
								innerHTML : this.fdFactNodeName + '<i></i>'
							}, contentNode);

							this.inherited(arguments);
						},

						methodPrex : 'show',

						getMehtodPrex : function() {
							return this.methodPrex == 'show' ? 'hide' : 'show';
						},

						startup : function() {
							this.inherited(arguments);
							this.connect(this.domNode, "onclick", '_onClick');
							this.subscribe('/mui/lbpmservice/branch_toggle',
									lang.hitch(this, this.branch_toggle));
							this.subscribe('/mui/lbpmservice/label_toggle',
									lang.hitch(this, this.label_toggle));
						},

						_setMethodPrexAttr : function(type) {
							var hide = 'hide';
							type == 'hide' ? domClass.add(this.titleNode, hide)
									: domClass.remove(this.titleNode, hide);
							this.methodPrex = type;
						},

						_onClick : function(evt) {
							this._branch_toggle();
						},

						_branch_toggle : function(type) {
							var methodPrex = type ? type : this.getMehtodPrex();
							topic
									.publish(
											'/mui/lbpmservice/branch_toggle',
											this,
											{
												fdExecutionId : this.fdExecutionId,
												fdParentExecutionId : this.fdParentExecutionId,
												methodPrex : methodPrex
											});
							this.set('methodPrex', methodPrex);
						},

						branch_toggle : function(obj, evt) {
							if (!evt || obj == this)
								return;
							if (evt.fdExecutionId == this.fdParentExecutionId)
								this[evt.methodPrex + 'Item'](evt);
						},

						label_toggle : function(obj, evt) {

							if (!evt || obj == this)
								return;
							if (evt.fdExecutionId == this.fdParentExecutionId)
								this[evt.methodPrex + 'Item'](evt);
						},

						showItem : function(evt) {
							domStyle.set(this.domNode, {
								'height' : 'auto'
							});
							this.defer(function() {
								domStyle.set(this.domNode, {
									'display' : 'block'
								});
							}, 1);
						},

						hideItem : function() {
							domStyle.set(this.domNode, {
								'height' : 0
							});
							this.defer(function() {
								domStyle.set(this.domNode, {
									'display' : 'none'
								});
							}, 1);
							this._branch_toggle('hide');
						}
					})
		});