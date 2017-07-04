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
		
		baseClass:"muiCalendarListItem",
		
		href : '',
		
		buildRendering:function(){
			
			this.inherited(arguments);
			
			this.domNode = this.containerNode= this.srcNodeRef
				|| domConstruct.create(this.tag,{className:this.baseClass});
			
			var content=domConstruct.create("div",{className:"muiCalendarListContent"},this.containerNode);
			
			//时间轴
			var em=domConstruct.create("em",{className:"arrow_dot"},content);
			domConstruct.create("i",{className:"mui mui-meeting_date"},em);
			
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
			
			
			var _p=domConstruct.create("p", { className: "date",innerHTML : _date }, content);//时间
			
			var title=domConstruct.create("p", { className: "title"}, content);//标题
			domConstruct.create("a", {innerHTML:this.title}, title);
			
			//标签
			if(this.labelId){
				var labelDom=domConstruct.create("div", { className: "muiCalendarLabel ",innerHTML:this.labelName}, content);
				domStyle.set(labelDom,'background-color',this.color);
			}else{
				domConstruct.create("div", { className: "muiCalendarLabel muiCalendarDefaultLabel",innerHTML:'我的日历'}, content);
			}
			
			
			this.href='/km/calendar/km_calendar_main/kmCalendarMain.do?method=view&fdId='+this.id;
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