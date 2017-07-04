define(	["dojo/_base/declare", "dojo/dom-class",
				"dojo/dom-style", 
				"mui/util",
				"dojo/_base/lang",
				"dojo/dom-construct",
				"mui/person/PersonDetailMixin"], function(declare, domClass,
				domStyle, util, lang,domConstruct, PersonDetailMixin) {

			return declare("sys.fans.FansButtonMixin", [ PersonDetailMixin], {

						fdId : "",
				
						url : "/sys/fans/sys_fans_main/sysFansMain.do?method=dataFollow&q.type=!{type}&fdId=!{fdId}&fansModelName=!{fansModelName}&attentModelName=!{attentModelName}&rowsize=8",
						
						baseClass : "",
						
						muiIcon : "",
						
						muiLabel : "",
						
						fdMemberNum : "",
						
						startup : function() {
							if (this._started)
								return;
							this.inherited(arguments);
						},
						
						buildRendering : function() {
							this.inherited(arguments);
							this.domNode.innerHTML = "<i class='mui " + this.muiIcon+"'></i>" + 
								(this.muiLabel?this.muiLabel:"") 
								+ (this.fdMemberNum ? this.fdMemberNum : "0") ;
							domClass.add(this.domNode , this.baseClass);
						},
						
						onClick : function() {
							if (this.url) {
								this.detailUrl = util.urlResolver(this.url, {
									"fdId" : this.fdId,
									"fansModelName" : this.fansModelName,
									"attentModelName" : this.attentModelName,
									"type":this.type
								});
								this.openDeatailView();
							}
							this.inherited(arguments);
						}

					});
		});