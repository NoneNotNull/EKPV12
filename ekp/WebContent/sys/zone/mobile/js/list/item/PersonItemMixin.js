define(	["dojo/_base/declare", "dojo/dom-construct", "dojo/dom-class",
				"dojo/dom-style", "dojo/dom-attr", "dojox/mobile/_ItemBase",
				"dojox/mobile/iconUtils", "mui/util", "mui/list/item/_ListLinkItemMixin"],
		//横向布局
		function(declare, domConstruct, domClass, domStyle, domAttr, ItemBase,
				iconUtils, util, _ListLinkItemMixin) {
			var item = declare("sys.zone.mobile.js.list.item.PersonItemMixin", [ItemBase,
							_ListLinkItemMixin], {

						fdId : "",
						
						fdName : '',
						
						imgUrl : '/sys/person/sys_person_zone/sysPersonZone.do?size=m&method=img&fdId=',
						
						personUrl : '/sys/person/sys_person_zone/sysPersonZone.do?size=m&method=view&fdId=',
						
						buildRendering : function() {
							this.inherited(arguments);
							this._templated = !!this.templateString;
							if (!this._templated) {
								this.domNode = this.containerNode = this.srcNodeRef
										|| domConstruct.create("li");
								this.contentNode = domConstruct.create(
										'a', {
											className : 'mui_fans_zone_item muiSubject',
											'innerHTML' : '<img src="' + util.formatUrl(this.imgUrl + this.fdId)  +'"/>'
										}, this.domNode);
								
								domConstruct.create('div' , {
									className : "mui_fans_zone_item_name",
									'innerHTML' : util.formatUrl(this.fdName)
								}, this.contentNode);
								
								if (!this.href) {
									this.href = '/sys/person/sys_person_zone/sysPersonZone.do?size=m&method=view&fdId=' + this.fdId;
								}
								this.makeLinkNode(this.contentNode);
							}
						},


						startup : function() {
							if (this._started) {
								return;
							}
							this.inherited(arguments);
						},
						
						_setLabelAttr : function(text) {
							if (text)
								this._set("label", text);
						}
					});
			return item;
		});