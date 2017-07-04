define([
    "dojo/_base/declare",
    "dojo/dom-construct",
    "dojo/dom-class",
	"dojo/dom-style",
	"dojo/dom-attr",
    "dojox/mobile/_ItemBase",
   	"mui/util",
   	"mui/list/item/_ListLinkItemMixin",
	"dojo/date/locale" ,
	"dojo/date",
	"mui/i18n/i18n!sys-mobile"
	], function(declare, domConstruct,domClass , domStyle , domAttr , ItemBase , util, _ListLinkItemMixin,locale,dateUtil,msg) {
	
	var item = declare("km.imeeting.list.item.CalendarItemMixin", [ItemBase, _ListLinkItemMixin], {
		tag:"li",
		
		baseClass:"muiListItem muiImeetingItem",
		
		href : '',
		
		
		//主持人
		fdHost:"",
		
		//地点
		fdPlaceId:"",
		fdPlaceName:"",
		
		status:"",
		
		buildRendering:function(){
			this.inherited(arguments);
			
			this.domNode = this.containerNode= this.srcNodeRef
				|| domConstruct.create(this.tag,{className:this.baseClass});
			
			//右侧内容
			var content=domConstruct.create("div",{className:"muiMeetingListContent"},this.containerNode);
			
			//时间轴
			var em=domConstruct.create("em",{className:"arrow_dot"},content);
			domConstruct.create("i",{className:"mui mui-meeting_date"},em);
			
			var _start=locale.parse(this.start,{selector : 'time',timePattern : msg['mui.date.format.datetime'] }),
				_end=locale.parse(this.end,{selector : 'time',timePattern : msg['mui.date.format.datetime'] }),
				_format=msg['mui.date.format.time'];
			if(dateUtil.compare(_start,_end,'date') != 0 ){//跨天,显示MM-dd HH:mm ~ {MM-dd HH:mm}
				_format= 'MM-dd HH:mm' ;
			}
			_start=locale.format(_start,{selector : 'time',timePattern :_format }),
			_end=locale.format(_end,{selector : 'time',timePattern : _format });
			
			var _p=domConstruct.create("p", { className: "date",innerHTML:_start+' ~ '+_end}, content);//时间
			
			var title=domConstruct.create("p", { className: "title"}, content);//标题
			domConstruct.create("a", {innerHTML:this.title}, title);
			
			_p=domConstruct.create("p", { className: "address"}, content);//地点
			domConstruct.create("i", { className:"mui mui-meeting_path" }, _p);
			domConstruct.create("span", { innerHTML:this.fdPlaceName }, _p);
			
			var user=domConstruct.create("div", { className: "user"}, content);//用户
			
			if(this.fdHost){
				var _span=domConstruct.create("div", { className: "figure"}, user);
				domConstruct.create("img", { src: this.hostsrc}, _span);//用户头像
				domConstruct.create("a", { className: "",innerHTML:this.fdHost}, user);//用户名
			}
			
			domConstruct.create("div", { className: "muiMeetingStatus "+this.status,innerHTML:this.statusText}, content);
			
			
			
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