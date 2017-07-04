define(
		[ "dojo/_base/declare", "dojo/dom-construct", "dojo/dom-class",
				"dojo/dom-style", "dojo/dom-attr", "dojox/mobile/_ItemBase",
				"dojox/mobile/iconUtils", "mui/util",
				"mui/list/item/_ListLinkItemMixin" ],
		//纵向布局
		function(declare, domConstruct, domClass, domStyle, domAttr, ItemBase,
				iconUtils, util, _ListLinkItemMixin) {
			var item = declare(
					"sys.zone.mobile.js.list.item.PersonItemVerMixin",
					[ ItemBase, _ListLinkItemMixin ],
					{

						fdId : "",

						fdName : '',

						imgUrl : '/sys/person/sys_person_zone/sysPersonZone.do?size=m&method=img&fdId=',

						personUrl : '/sys/person/sys_person_zone/sysPersonZone.do?size=m&method=view&fdId=',

						tag : "li",

						baseClass : "muiListItem",

						buildRendering : function() {
							this.inherited(arguments);

							this.domNode = this.containerNode = this.srcNodeRef
									|| domConstruct.create(this.tag, {
										className : this.baseClass
									});

							// 左侧头像
							var leftBar = domConstruct.create("div", {
								className : "sys_zone_person_icon"
							}, this.containerNode);
							domConstruct.create("img", {
								className : "sys_zone_person_icon_img",
								src : util.formatUrl(this.imgUrl + this.fdId)
							}, leftBar);

							// 右侧内容
							var rightContent = domConstruct.create("div", {
								className : "sys_zone_person_info"
							}, this.containerNode);
							domConstruct.create("div", {
								className : "sys_zone_person_name",
								innerHTML : this.fdName
							}, rightContent);
							
							if (!this.href) {
								this.href = '/sys/person/sys_person_zone/sysPersonZone.do?size=m&method=view&fdId=' + this.fdId;
							}
							this.makeLinkNode(this.domNode);
							
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