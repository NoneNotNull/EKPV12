define([
    "dojo/_base/declare",
    "dojo/dom-construct",
    "dojo/dom-class",
	"dojo/dom-style",
	"dojo/dom-attr",
	"dojo/date/locale" , 
    "dojox/mobile/_ItemBase",
   	"mui/util",
   	"mui/list/item/_ListLinkItemMixin",
   	"mui/rtf/RtfResizeUtil",
   	"sys/task/mobile/resource/js/_AttachmentItemMixin",
	"mui/i18n/i18n!sys-mobile" 	
	], function(declare, domConstruct,domClass , domStyle , domAttr,locale , ItemBase , util, _ListLinkItemMixin,RtfResizeUtil,_AttachmentItemMixin,msg) {
	
	var item = declare("sys.task.list.item.FeedbackItemMixin", [ItemBase, _ListLinkItemMixin,_AttachmentItemMixin], {
		tag:"li",
		
		baseClass:"taskCommonListItem muiFeedbackListItem",
		
		href : 'javascript:void(0);',
		
		fdModelName:'com.landray.kmss.sys.task.model.SysTaskFeedback',
		formBeanName:'sysTaskFeedbackForm',
		
		buildRendering:function(){
			this.inherited(arguments);
			
			this.domNode = this.containerNode= this.srcNodeRef
				|| domConstruct.create(this.tag,{className:this.baseClass});
			
			//上方信息
			var feedbackInfo=domConstruct.create("div",{className:"info"},this.containerNode);
			domConstruct.create("img", { className: "infoImg",src:this.icon}, feedbackInfo);//反馈人头像
			domConstruct.create("h4", { innerHTML:this.creator}, feedbackInfo);//反馈人名字
			var date=domConstruct.create("p", { className:"infoDate mui mui-time"}, feedbackInfo);
			domConstruct.create("span", { innerHTML:this.created }, date);//反馈日期
			if(this.clientType)
				domConstruct.create("span", { innerHTML:"来自"+msg['mui.comefrom.'+this.clientType] }, date);//来自XX客户端
			var progressContainer=domConstruct.create("div", { className: "progress"}, feedbackInfo);//进度
			this._buildProgress(this.progress,progressContainer);
			
			//下方反馈内容
			if(this.title){
				var feedbackContent=domConstruct.create("div",{className:"content"},feedbackInfo);
				domConstruct.create("p",{innerHTML:this.title},feedbackContent);
			}
			//附件
			if(this.fdId){
				var attContainer=domConstruct.create("div",{className:""},feedbackInfo);
				this.createAtt(attContainer,{
					fdModelId:this.fdId
				});
			}
		},
		
		startup:function(){
			if(this._started){ return; }
			this.inherited(arguments);
			//new RtfResizeUtil({
			//	channel:this.fdId,
			//	containerNode:this.containerNode
			//});
		},
	
		_setLabelAttr: function(text){
			if(text)
				this._set("label", text);
		},
		
		_buildProgress:function(progress,containerNode){
			progress=progress.replace('%','');
			//角度=360度*progress/100
			var deg=(18*parseInt(progress)/5);
			var pie_left=domConstruct.create("div",{className:"pie_left"},containerNode);
			var left=domConstruct.create("div",{className:"left"},pie_left);
			if(deg > 180){
				var _deg=deg-180;
				domStyle.set(left,'transform','rotate('+_deg+'deg)');
				domStyle.set(left,'-webkit-transform','rotate('+_deg+'deg)');
			}
			var pie_right=domConstruct.create("div",{className:"pie_right"},containerNode);
			var right=domConstruct.create("div",{className:"right"},pie_right);
			if(deg < 180){
				domStyle.set(right,'transform','rotate('+deg+'deg)');
				domStyle.set(right,'-webkit-transform','rotate('+deg+'deg)');
			}else{
				domStyle.set(right,'transform','rotate(180deg)');
				domStyle.set(right,'-webkit-transform','rotate(180deg)');
			}
			var mask=domConstruct.create("div",{className:"mask",innerHTML:'%'},containerNode);
			var span=domConstruct.create("span",{innerHTML:progress});
			domConstruct.place(span,mask,'first');
		}
		
		
	});
	return item;
});