define([
    "dojo/_base/declare",
    "dojo/dom-construct",
    "dojo/dom-class",
	"dojo/dom-style",
	"dojo/dom-attr",
    "dojox/mobile/_ItemBase",
   	"mui/util",
   	"mui/i18n/i18n",
   	"mui/list/item/_ListLinkItemMixin",
	"dojo/date/locale"   	
	], function(declare, domConstruct,domClass , domStyle , domAttr , ItemBase , util,i18n, _ListLinkItemMixin,locale) {
	
	var item = declare("sys.task.list.item.CalendarItemMixin", [ItemBase, _ListLinkItemMixin], {
		tag:"li",
		
		baseClass:"muiTaskListItem",
		
		href : 'javascript:void(0);',
		
		buildRendering:function(){
			this.inherited(arguments);
			
			this.domNode = this.containerNode= this.srcNodeRef
				|| domConstruct.create(this.tag,{className:this.baseClass});
			
			//左侧头像(取第一个人负责人的头像...)
			var leftBar=domConstruct.create("div",{className:"leftBar"},this.containerNode);
			domConstruct.create("img", { className: "muiProcessImg",src:this.performSrc}, leftBar);
			if(this.personCount > 1){
				var muiTaskMore=domConstruct.create("div", { className: "muiTaskMore"}, leftBar);
				domConstruct.create('i',{className:'mui mui-more'},muiTaskMore);
			}
			
			//右侧内容
			var rightContainer=domConstruct.create("div", { className: "rightContainer"}, this.containerNode),
				contentContainer=domConstruct.create("div", { className: "contentContainer"}, rightContainer),
				progressContainer=domConstruct.create("div", { className: "progress"}, rightContainer);
			
			//标题
			if(this.title){
				this.labelNode = domConstruct.create("h4",{className:"muiSubject",innerHTML:this.title},contentContainer);
			}
			var taskIcoList=domConstruct.create("ul", { className: "taskIcoList"}, contentContainer);
			var li;
			//状态
			if(this.fdStatus){
				var _statusInfo=this._getStatusInfo(this.fdStatus);
				li=domConstruct.create("li", { }, taskIcoList);
				domConstruct.create("div", { className:"muiTaskStatusTag "+_statusInfo.className,innerHTML:this.fdStatusText }, li);
			}
			//超期
			if(this.overDay){
				li=domConstruct.create("li", { }, taskIcoList);
				domConstruct.create("span", { className:"overday", innerHTML:"超期"+ this.overDay+"天" }, li);
			}
			//负责人
			li=domConstruct.create("li", {className:'muiTaskPersons' }, taskIcoList);
			domConstruct.create("i", { className: "mui mui-person"}, li);
			domConstruct.create("span", { innerHTML: this.performs }, li);
			
			//进度
			this._buildProgress(this.progress,progressContainer);
			
		},
		
		startup:function(){
			if(this._started){ return; }
			this.inherited(arguments);
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
			if(this.fdStatus=='3'){
				var mask=domConstruct.create("div",{className:"mask"},containerNode);
				var span=domConstruct.create("i",{className:'mui mui-taskComplete'});
			}else if(this.fdStatus=='6'){
				var mask=domConstruct.create("div",{className:"mask"},containerNode);
				var span=domConstruct.create("i",{className:'mui mui-taskClose'});
			}else{
				var mask=domConstruct.create("div",{className:"mask",innerHTML:'%'},containerNode);
				var span=domConstruct.create("span",{innerHTML:progress});
			}
			
			domConstruct.place(span,mask,'first');
			
		},
		
		_getStatusInfo:function(value){
			var statusInfo={
				'1':{
					className:'muiTaskInactive'
				},
				'2':{
					className:'muiTaskProgress'
				},
				'3':{
					className:'muiTaskComplete'
				},
				'4':{
					className:'muiTaskTerminate'
				},
				'5':{
					className:'muiTaskOverrule'
				},
				'6':{
					className:'muiTaskClose'
				}
			}
			return statusInfo[value];
		}
		
		
	});
	return item;
});