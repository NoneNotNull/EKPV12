define(
		[ "dojo/_base/declare", "dojo/dom-class", "mui/iconUtils",
				"dojo/_base/lang", "dojox/mobile/Button",
				"sys/zone/mobile/js/_FollowButtonMixin",
				"mui/category/CategoryItemMixin", "mui/util",
				"dojo/dom-construct", "dojo/dom-attr" ,"dojo/topic",'dojox/mobile/viewRegistry'],
		function(declare, domClass, iconUtils, lang, button,
				_FollowButtonMixin, CategoryItemMixin, util, domConstruct, domAttr, topic,viewRegistry) {
			var item = declare(
					"sys.zone.mobile.js.address.AddressZoneItemMixin",
					[ CategoryItemMixin ],{
				
				extendContact : [],
				
				
				personUrl : "/sys/zone/index.do?userid=!{personId}",
				
				postCreate:function() {
					this.inherited(arguments);
				},
				
				//获取分组标题信息
				getTitle:function(){
					if( this.label=='2' ){
						return "组织";
					}
					if(this.label=='4'){
						return "岗位";
					}
					return this.label;
				},
				
				//是否显示往下一级
				showMore : function(){
					if((this.type | window.ORG_TYPE_ORGORDEPT) ==  window.ORG_TYPE_ORGORDEPT){
						return true;
					}
					return false;
				},
				
				//是否显示选择框
				showSelect:function(){
					var pWeiget = this.getParent();
					if(pWeiget && ((pWeiget.selType & this.type) ==  this.type)){
						return true;
					}
					return false;
				},
				
				//是否选中
				isSelected:function(){
					var pWeiget = this.getParent();
					if(pWeiget && pWeiget.curIds && (pWeiget.curIds.indexOf(this.fdId)>-1)){
						return true;
					}
					return false;
				},
				
				buildIcon:function(iconNode){
					
					if(this.icon){
						iconUtils.setIcon(util.formatUrl(this.icon), null,
								this._headerIcon, null, iconNode);
					}else{
						if((this.type | window.ORG_TYPE_ORGORDEPT) ==  window.ORG_TYPE_ORGORDEPT){
							this.icon = "mui mui-group muiAddressDept"; 
						}
						if((this.type | window.ORG_TYPE_POST) ==  window.ORG_TYPE_POST){
							this.icon = "mui mui-post muiAddressPost"; 
						}
						iconUtils.setIcon(this.icon, null,
								this._headerIcon, null, iconNode);
					}
				},
				
				startup : function() {
					this.inherited(arguments);
					//构建关注按钮
					if(this.moreArea && this._isPerson() && !this._isSelf()) {
						var followBtn = new declare( [button,
								_FollowButtonMixin])( {
									"userId" : this.fdId,
									"attentModelName" : "com.landray.kmss.sys.zone.model.SysZonePersonInfo",
									"fansModelName" : "com.landray.kmss.sys.zone.model.SysZonePersonInfo",
									"isFollowPerson" : "true",
									"srcNodeRef" : domConstruct.create("span"),
									"followedLabel" : "",
									"followeachLabel" : "",
									"followLabel" : "",
									"followIcon" : "mui-add_person",
									"followedIcon" : "mui-right_person",
									"followeachIcon" : "mui-each_person",
									"contactInfo" :  {
										email : this.email,
										tel : this.phone,
										personId : this.fdId
									}
								});
						this.moreArea.appendChild(followBtn.domNode);
						followBtn.startup();
					}
				},
				
				_isPerson :function() {
					return this.type && 
						(this.type | window.ORG_TYPE_PERSON) ==  window.ORG_TYPE_PERSON;
				},
				
				_isSelf : function() {
					return this.fdId && (this.fdId == window.currrtPersonId);
				},
				
				buildRendering : function() {
					this.inherited(arguments);
					if(this._isPerson() && this.domNode) {
						//显示更多信息
						domClass.add(this.domNode, "mui_zone_person_cateInfo");
					}
				},
				_buildItemBase : function() {
					this.cateContainer = domConstruct.create("div",
								{className:"muiCateContainer"},this.contentNode);
					
					if(this.header != 'true' ) {
						this.iconNode = domConstruct.create('div', {
										'className' : 'muiCateIcon mui_zone_cate_icon'
									}, this.cateContainer);
						this.buildIcon(this.iconNode);
						this.infoNode = domConstruct.create('div', {
										'className' : 'muiCateInfo'
									}, this.cateContainer);
						this.titleNode = domConstruct.create('div', {
										'className' : 'muiCateName' + (this._isPerson() ? 
												" mui_zone_cate_person_name" : ""),
										'innerHTML' : this.label 
									}, this.infoNode);
						if(this.post) {
							var post = domConstruct.create('div', {
								'className' : 'muiCateName mui_zone_cate_post',
								'innerHTML' : this.post 
							}, this.infoNode);
							domConstruct.create("span",{
								"className" : "mui mui-post"
							},post, "first");
						}
						if(this.phone) {
							var phone = domConstruct.create('div', {
								'className' : 'muiCateName mui_zone_cate_phone',
								'innerHTML' : this.phone 
							}, this.infoNode);
							domConstruct.create("span",{
								"className" : "mui mui-tel"
							},phone, "first");
						}
						if(this._isPerson()) {
							var href = util.urlResolver(this.personUrl, {"personId": this.fdId});
							this.href = util.formatUrl(href);
						}
						this.connect(this.iconNode,"click","_selectCate");
						this.connect(this.infoNode,"click","_selectCate");
					} else {//头部 显示ABCD...
						this.titleNode = domConstruct.create('div', {
							'className' : 'muiCateName muiCateTitle',
							'innerHTML' : this.getTitle()
						}, this.cateContainer);
					}
					this.moreArea = domConstruct.create("div",{className:"muiCateMore"},this.cateContainer);
				},
				_selectCate : function(evt) {
					
					this.inherited(arguments);
					this.set("entered", true);
					this.defer(function(){
						this.set("entered", false);
					},200);
					var self = this;
					if(this.href) {
						this.defer(function(){
							window.open(self.href, "_self");
						}, 250);
					}
				}
				
				
			});
			return item;
		});