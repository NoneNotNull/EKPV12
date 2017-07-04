define([
    "dojo/_base/declare",
    "dojo/dom-construct",
    "dojo/dom-class",
	"dojo/dom-style",
	"dojo/dom-attr",
    "dojox/mobile/_ItemBase",
   	"mui/util",
   	"mui/i18n/i18n",
   	"mui/list/item/_ListLinkItemMixin"
	], function(declare, domConstruct,domClass , domStyle , domAttr , ItemBase , util,i18n, _ListLinkItemMixin) {
	
	var item = declare("km.imeeting.list.item.FeedbackItemMixin", [ItemBase, _ListLinkItemMixin], {
		tag:"li",
		
		baseClass:"muiMeetingListItem",
		
		href : 'javascript:;',
		
		//发布时间
		created:"",
		
		//参与人
		creator:"",
		
		//实际参与人
		attend:"",
		
		//参与人头像
		icon:"",
		
		//
		opt:"",
		
		buildRendering:function(){
			this.inherited(arguments);
			
			//左侧头像
			var figure=domConstruct.create("div",{className:"figure"},this.containerNode);
			var _a=domConstruct.create("a", { }, figure);
			domConstruct.create("img", { className: "muiFeedbackImg",src:this.icon}, _a);
			var optClassName="",
				optName="",
				optIcon="";
			switch(this.opt){
				case "01":
					optClassName="attend";
					optName="参加";
					optIcon="mui-meeting_attend";
					break;
				case "02":
					optClassName="unAttend";
					optName="不参加";
					optIcon="mui-meeting_unAttend";
					break;
				case "03":
					optClassName="proxy";
					optName="代理";
					optIcon="mui-meeting_proxy";
					break;
				default:
					optClassName="noOpt";
					optName="未回执";
					optIcon="mui-meeting_noOpt";
			}
			var _span=domConstruct.create("span", { className: "figureTag "+optClassName}, _a);
			domConstruct.create("i", { className: "mui "+optIcon}, _span);
			
			//右侧内容
			var content=domConstruct.create("div",{className:"muiFeedBackContent"},this.containerNode);
			_a=domConstruct.create("a", {className:"name"}, content);
			if(this.opt=='03' && this.attend){
				domConstruct.create("em", {className:"agent",innerHTML:this.attend}, _a);//实际参与人
				domConstruct.create("i", {className:"agenIcon",innerHTML:"代"}, _a);
			}
			domConstruct.create("span", {innerHTML:this.creator}, _a);//参与人
			
			if(this.fdReason){
				domConstruct.create("p", {className:"info",innerHTML:this.fdReason }, content);//回执留言
			}
			var _p=domConstruct.create("p", {innerHTML:this.dept }, content);//部门
			domConstruct.create("i",{className:"mui mui-depart"},_p,"first");
			domConstruct.create("a", {className:"feedBackBtn "+optClassName,innerHTML:optName }, content);//回执类型
			
		},
		
		startup:function(){
			if(this._started){ return; }
			this.inherited(arguments);
		},
	
		_setLabelAttr: function(text){
			if(text)
				this._set("label", text);
		}
	});
	return item;
});