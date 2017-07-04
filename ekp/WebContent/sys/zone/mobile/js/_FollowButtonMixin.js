define(	["dojo/_base/declare", "dojo/_base/lang", "dojo/request", "mui/util",
				"dojo/dom-class", "mui/dialog/Tip", 
				'dojo/dom-attr', "dojo/dom-construct"
				,'dojo/topic'], function(declare, lang,
				req, util, domClass, Tip, domAttr, domConstruct, topic) {

			return declare("sys.zone.mobile.js._FollowButtonMixin", null, {
				
				followStatusUrl:"/sys/fans/sys_fans_main/sysFansMain.do?method=loadRlation",
				
				addCareUrl : "/sys/fans/sys_fans_main/sysFansMain.do?method=addFollow",
				
				baseClass : "mui_zone_follow_btn_base",
				
				/*******关注需要的字段****/
				userId : "",
				
				attentModelName : "",
				
				fansModelName : "",
				
				isFollowPerson : "",
				/*******关注需要的字段****/
				
				//取消关注class
				followedClass: "mui_zone_followed_btn",
				
				//互相关注class
				followEachClass: "mui_zone_followeach_btn",
				
				//关注class
				followClass: "mui_zone_follow_btn",
				
				locked : false,
				
				followLabel : "<span class='mui_zone_tips'>关注</span>",
				
				followedLabel : '<span class="mui_zone_tips">已关注<em>|</em>取消</span>',
				
				followeachLabel : '<span class="mui_zone_tips">互相关注<em>|</em>取消</span>',
				
				followIcon : "mui-plus",
				
				followedIcon : "mui-right",
				
				followeachIcon : "mui-addTwo",
				
				buildRendering : function() {
					this.inherited(arguments);
					this.icon = domConstruct.create("span" , {
						className:"mui_zone_follow_base"
					}, this.domNode);
					this.iconinner = domConstruct.create('i' , {
						className : "mui mui_zone_follow_icon"
					}, this.icon);
					domClass.add(this.domNode , this.baseClass);
				},
				
				startup : function() {
					if (this._started)
						return;
					this.inherited(arguments);
					req(util.formatUrl(this.followStatusUrl), {
						handleAs : "json",
						method : 'post',
						data : {
							"userId" : this.userId,
							"attentModelName" : this.attentModelName,
							"fansModelName" : this.fansModelName,
							"isFollowPerson" : this.isFollowPerson
						}
					}).then(lang.hitch(this, function(data) {
						this._toggleLabel(data);
					}));
				},
				
				
				followAction : function() {
					this.set('locked', true);
					
					var type = domAttr.get(this.domNode, "data-action-type");
					req(util.formatUrl(this.addCareUrl), {
						handleAs : "json",
						method : 'post',
						data : {
							"fdPersonId" : this.userId,
							"attentModelName" : this.attentModelName,
							"fansModelName" : this.fansModelName,
							"isFollowPerson" : this.isFollowPerson,
							"isFollowed" : type
						}
					}).then(lang.hitch(this, function(data) {
						if(data.result == "success") {
							this._toggleLabel(data, true);
						} else {
							Tip.fail({"text" : "操作失败"});
						}
					}), function(error) {
						Tip.fail({"text" : "操作失败"});
					});
				},
				
				
				onClick: function() {
					if(this.locked)
						return;
					if(this.contactInfo) {
						topic.publish("/sys/zone/list/contact", this, {
									contactInfo : this.contactInfo,
									currentIcon : this.currentIcon ,
									currentText : this.cuurentText,
									followAction : this.followAction
							});
					} else {
						this.followAction();
					}
				},
				
				_toggleLabel : function(data, isTip) {
					var tipText = "", icon ="";
						
					if(data.relation == "2" ||data.relation == "0" ) {
						this.label = this.followLabel;
						domAttr.set(this.domNode, "data-action-type", "unfollowed");
						domClass.remove(this.domNode , this.followedClass);
						
						if(this.iconinner) {
							domClass.remove(this.iconinner, this.followedIcon + " " + this.followeachIcon);
							domClass.add(this.iconinner ,  this.followIcon);
						}
						domClass.remove(this.domNode , this.followedClass);
						domClass.add(this.domNode , this.followClass );
						//当前的icon
						this.currentIcon = this.followIcon;
						this.cuurentText = "关注";
						tipText = '取消关注成功！';
					}else if(data.relation=="3" || data.relation == "1") {
						
						var fIcon = "";
						if(data.relation=="3")  {
							this.label = this.followeachLabel;
							fIcon = this.followeachIcon;
						} else {
							this.label = this.followedLabel;
							fIcon = this.followedIcon;
						}
						if(this.iconinner) {
							domClass.remove(this.iconinner, this.followIcon);
							domClass.add(this.iconinner , fIcon);
						}
						domAttr.set(this.domNode, "data-action-type", "followed");
						domClass.remove(this.domNode , this.followClass);
						domClass.add(this.domNode , this.followedClass);
						//当前的icon
						this.currentIcon = fIcon;
						this.cuurentText = "取消关注";
						tipText = "关注成功！";
					}
					
					if(isTip)
						Tip.tip({
							icon : 'mui mui-success',
							text : tipText
						});
					
					var labelNode = this.containerNode || this.focusNode;
					
					labelNode.innerHTML = this.icon.outerHTML + this.label;
					
					this.set("locked", false);
				}

			});
			
			
});
			