define(	["dojo/_base/declare", "dojo/_base/lang", "dojo/request", "mui/util",
				"dojo/dom-class", "mui/dialog/Tip", 'dojo/dom-attr', 
				"dojo/dom-style",
				"sys/zone/mobile/js/_FollowButtonMixin",
				"dojo/dom-construct",
				"dojo/dom-geometry"], function(declare, lang,
				req, util, domClass, Tip, domAttr,domStyle, 
				_FollowButtonMixin,domConstruct,domGeometry) {

			return declare("sys.zone._FollowListButtonMixin", null, {
				
				postCreate : function() {
					this.inherited(arguments);
					this.subscribe("/sys/zone/list/contact", "_handleOnContact");
				},
				
				personUrl : "/sys/zone/index.do?userid=!{personId}",
				
				//#E7507B  #F26C60 #FDA106 #34B87F #66CDCC
				// 显示遮罩
				showMask : function() {
					if (this.lock == true)
						return;
					this.set('lock', true);
					this.defer(function() {
						this.buildMask();
					}, 350);
				},

				// 隐藏遮罩
				hideMask : function(fire) {
					this.defer(function() {
						this._hideMask();
						this.set('lock', false);
					}, 350);
				},

				
				_showMask : function() {
					domStyle.set(this._container, {
						'display' : 'block',
						'opacity' : 1
					});
					if(!this.handleHide){
						this.handleHide = this.connect(this._container, "onclick", 'hideClick');
					}
					this.defer( function() {
						for ( var i = 0; i < this.iconObjs.length; i++) {
							domStyle.set(this.iconObjs[i], {
								'-webkit-transform' : 'translate3d(0px, 0px, 0px)',
								'opacity' : 1
							});
						}
					},200);
					
				},
				
				hideClick : function() {
					this._hideMask();
				},
				
				_hideMask : function() {
					this.contactInfo = null;
					this.followAction = null;
					this.followObject = null;
					for (var i = 0; i < this.iconObjs.length; i++) {
						domStyle.set(this.iconObjs[i],{
								'-webkit-transform' : 'translate3d(0px, 500px, 0px)',
								'opacity' : 0
							});
					}
					
					this.defer(function() {
						domStyle.set(this._container, {
							'opacity' : 0
						});
					}, 500);
					this.defer(function() {
						domStyle.set(this._container, {
							'display' : 'none'
						});
					}, 700);
				},
				
				buildMask : function(initAttIcon, initText) {
					if (this._container) {
						this._showMask();
						return;
					}
					
					this._container = domConstruct.create('div', {
						'className' : 'muiZoneContactMask'
					}, document.body, 'last');
					this._containerUl = domConstruct.create('div', {
						'className' : 'muiZoneContactUl'
					},  this._container);
					//var containerHeight = domGeometry.position(this.titleDom).h;
					var contacts = this._getContacts();
					if(!this.iconObjs) {
						this.iconObjs = [];
					}
					for(var i = 0; i < contacts.length; i ++) {
						var colorClass = "muiZoneDetailItemBgColor" + (i % 6);
						var item = domConstruct.create("div", {
							'className' : 'muiZoneContact'
						}, this._containerUl);
						var citem  = domConstruct.create("span", {
							'className' : 'muiZoneDetailItem' + " " + colorClass,
							'data-index' : i
						}, item);
						var attText  = domConstruct.create("span", {
							'className' : 'muiZoneDetailItemText',
							'innerHTML' : contacts[i].text ? contacts[i].text : ""
						},item);
						var itemIcon = domConstruct.create("i", {
							'className' : 'mui ' +  contacts[i].icon
						}, citem);
						if("attBtn" == contacts[i].id) {
							this.attIcon = itemIcon;
							this.attText = attText;
							if(initAttIcon)
								domClass.add(this.attIcon, initAttIcon);
							if(initText)
								this.attText.innerHTML = initText;
						}
						this.connect(item, "onclick", 'onContactClick');
						this.iconObjs.push(item);
					}
					this._showMask();
				},
				
				//变更关注按钮的样式和方法
				changeAttIcon : function(clsName, text) {
					if(this.attIcon ) {
						domClass.remove(this.attIcon);
						if(this.attText) {
							this.attText.innerHTML = text;
						}
						domClass.add(this.attIcon, "mui" + " " +  clsName);
					}
				},
				
				_handleOnContact : function(obj, evt) {
					if(evt) {
						this.contactInfo = evt.contactInfo;
						this.followAction = evt.followAction;
						this.followObject = obj;
						this.changeAttIcon(evt.currentIcon, evt.currentText);
					}
					this.buildMask(evt.currentIcon, evt.currentText);
				},
				
				_getContacts : function() {
					if(!this.contacts) {
						
						this.contacts = [ 
						        {	
						        	"id" : "attBtn",
						        	"order" : -3,
						        	"icon" : ""
						        },
						        {
									"id" : "mui-tel",
									"icon" : "mui-tel",
									"href" : "tel:!{tel}",
									"order" : -2,
									"replace" : "tel",
									"text" : "电话"
								}, {
									"id" : "mui-mail",
									"icon" : "mui-mail",
									"href" : "mailto:!{email}",
									"order" : -1,
									"replace" : "email",
									"text" : "邮件"
								},
								{
									"id" : "mui-msg",
									"icon" : "mui-msg",
									"href" : "sms:!{tel}",
									"order" : 9,
									"replace" : "tel",
									"text" : "短信"
								}, {
									"id" : "mui-infomation",
									"icon" : "mui-infomation",
									"href" : util.formatUrl(this.personUrl),
									"order" : 10,
									"replace" : "personId",
									"text" : "个人信息"
								} ];
						this.contacts = this.contacts.concat(window.extendContact);
						this.contacts.sort(function(a, b){
							return a.order - b.order ;
						});
					}
					return this.contacts;
				},
				
				onContactClick : function(evt){
					if(evt){
						if (evt.stopPropagation)
							evt.stopPropagation();
						if (evt.cancelBubble)
							evt.cancelBubble = true;
						if (evt.preventDefault)
							evt.preventDefault();
						if (evt.returnValue)
							evt.returnValue = false;
					}
					
					var target = evt.target;
					while (target && !domClass.contains(target, "muiZoneContact")) { 
						var index = domAttr.get(target, "data-index");
						if (index !== null && index != "undefined"  && index>= 0) {
							this.handleIndex(index, evt);
							break;
						}
						target = target.parentNode;
					}
					
				},
				
				handleIndex :function (index, evt) {
					var conIndex = this._getContacts()[index];
					if(conIndex) {
						if(conIndex.id== "attBtn") {
							this.followAction.apply(this.followObject);
							this._hideMask();
						}
						if(conIndex.href && this.contactInfo) {
							if(!this.contactInfo[conIndex.replace])
								return;
							var href = util.urlResolver(conIndex.href, this.contactInfo);
							window.open(href, "_self");
						}
					}
				}
			});
});