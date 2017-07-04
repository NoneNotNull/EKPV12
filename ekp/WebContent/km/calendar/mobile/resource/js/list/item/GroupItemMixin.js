define([
    "dojo/_base/declare",
    "dojo/dom-construct",
    "dojo/dom-class",
	"dojo/dom-style",
	"dojo/dom-attr",
    "dojox/mobile/_ItemBase",
   	"mui/util",
   	"mui/calendar/CalendarUtil",
   	"mui/list/item/_ListLinkItemMixin",
   	"dojo/date",
	"dojo/date/locale" ,
	"mui/i18n/i18n!sys-mobile"
	], function(declare, domConstruct,domClass , domStyle , domAttr , ItemBase , util, cutil,_ListLinkItemMixin,dateUtil,locale,msg) {
	
	var item = declare("km.imeeting.list.item.CalendarItemMixin", [ItemBase, _ListLinkItemMixin], {
		tag:"li",
		
		baseClass:"muiGroupListItem",
		
		href : 'javascript:void(0);',
		
		buildRendering:function(){
			
			this.inherited(arguments);
			
			this.domNode = this.containerNode= this.srcNodeRef
				|| domConstruct.create(this.tag,{className:this.baseClass});
			
			//左侧头像
			var leftBar=domConstruct.create("div",{className:"leftBar"},this.containerNode);
			domConstruct.create("img", { className: "muiProcessImg",src:this.img}, leftBar);
			
			//右侧内容
			var rightContainer=domConstruct.create("div", { className: "rightContainer"}, this.containerNode),
				contentContainer=domConstruct.create("div", { className: "contentContainer"}, rightContainer);
			
			//标题
			if(this.title){
				this.labelNode = domConstruct.create("h4",{className:"muiSubject",innerHTML:this.title},contentContainer);
			}
			
			var groupList=domConstruct.create("ul", { className: "groupList"}, contentContainer);
			var li;
			//所有者
			if(this.owner){
				li=domConstruct.create("li", {className:'muiGroupPersons' }, groupList);
				domConstruct.create("i", { className: "mui mui-person"}, li);
				domConstruct.create("span", { innerHTML: this.owner }, li);
			}
			//时间
			var format=msg['mui.date.format.datetime'];//'yyyy-MM-dd HH:mm'
			if(this.allDay){
				format=msg['mui.date.format.date'];//'yyyy-MM-dd'
			}
			var _start=locale.parse(this.start,{selector : 'time',timePattern : format}),
				_end=locale.parse(this.end,{selector : 'time',timePattern : format}),
				_date='';
				
			if(dateUtil.compare(_start,_end,'date') != 0 ){//跨天,显示MM-dd HH:mm ~ {MM-dd HH:mm}
				var tp=this.allDay?'':msg['mui.date.format.time'];
				tp='MM-dd '+tp;
				_start=locale.format(_start,{selector : 'time',timePattern : tp });
				_end=locale.format(_end,{selector : 'time',timePattern : tp });
				_date=_start+' ~ '+_end;
			}else{//非跨天,显示HH:mm ~ {HH:mm}
				_start=locale.format(_start,{selector : 'time',timePattern : msg['mui.date.format.time'] });
				_end=locale.format(_end,{selector : 'time',timePattern : msg['mui.date.format.time'] });
				_date=_start+' ~ '+_end;
				if(this.allDay){
					_date='全天';
				}
			}
			li=domConstruct.create("li", {className:'muiGroupTime' }, groupList);
			domConstruct.create("i", { className: "mui mui-meeting_date"}, li);
			domConstruct.create("span", { innerHTML:_date }, li);
			
			
		},
		
		startup:function(){
			if(this._started){ return; }
			this.inherited(arguments);
		},
	
		_setLabelAttr: function(text){
			if(text)
				this._set("label", text);
		},
		
		//url加入当前选中日期参数
		makeUrl:function(){
			var url=this.inherited(arguments),
				parent=this.getParent();
			if(parent){
				var _cd=cutil.formatDate(parent.currentDate);
				url=util.setUrlParameter(url,'currentDate',_cd);
			}
			return url;
		}
		
	});
	return item;
});