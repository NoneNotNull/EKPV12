define([
    "dojo/_base/declare",
    "dojo/topic",
    'dojo/when',
    "dojox/mobile/EdgeToEdgeStoreList",
    'dojox/mobile/_StoreListMixin', 
    'mui/list/_ListNoDataMixin',
	"dojo/date",
	"mui/util",
	'dojo/_base/lang',
	"dojo/request",
	"./CalendarUtil"
	], function(declare,topic,when,EdgeToEdgeStoreList,_StoreListMixin,ListNoDataMixin,dateClz,util,lang,request,cutil) {
	
	return declare("mui.calendar.CalendarJsonStoreList", [EdgeToEdgeStoreList,_StoreListMixin,ListNoDataMixin], {
		
		// 支持URL
		url: '',
		
		busy: false,
				
		__caches:{},//缓存数据
		
		_setUrlAttr: function(url){
			this.url = util.formatUrl(url);
		},
		
		postMixInProperties:function(){
			this.subscribe("/mui/calendar/dataChange","handleDataChange");
			this.subscribe("/mui/calendar/valueChange","handleValueChange");
		},
		
		startup : function() {
			if(this._started){ return; }
			this.inherited(arguments);
		},
		
		formatData:function(datas){
			return datas.data;
		},
		
		handleDataChange:function(widget,args){
			if(args.startDate && args.endDate){
				var _startDate=cutil.formatDate(args.startDate);
				var _endDate=cutil.formatDate(args.endDate);
				this.url=util.setUrlParameter(this.url,"fdStart",_startDate);
				this.url=util.setUrlParameter(this.url,"fdEnd",_endDate);
			}
			var self=this;
			var promise = request
						.post(this.url, {handleAs : 'json'})
						.response
						.then(function(datas) {
							
							
							var __caches=self.__caches={},
								__datas=self.formatData(datas);
							
							self._processDatas(__datas);
							var currentKey=cutil.formatDate(args.currentDate);
							if(!__caches[currentKey]){
								__caches[currentKey]=[];
							}
							
							self._sortDatas(__caches[currentKey]);//排序
							self.generateList(__caches[currentKey]);
							self.totalSize=__caches[currentKey].length;
							
							//var items=self.FilterItems(datas.data,args.currentDate);
							//self.generateList(items);
							topic.publish('/mui/list/loaded', self, __caches[currentKey]);
							
							//self._caches=datas.data;
							//返回一个月中哪天有日程
							var result=self._hasCalendar(args);
							topic.publish('/mui/calendar/notify', result);
						});
		},
		
		handleValueChange:function(widget,args){
			//var items=this.FilterItems(this._caches,args.currentDate);
			var __caches=this.__caches,
				currentKey=cutil.formatDate(args.currentDate);
			if(!__caches[currentKey]){
				__caches[currentKey]=[];
			}
			this.generateList(__caches[currentKey]);
			this.totalSize=__caches[currentKey].length;
			topic.publish('/mui/list/loaded', this, __caches[currentKey]);
		},
		
		//数据缓存
		_processDatas:function(datas){
			var __caches=this.__caches;
			for(var i=0 ;i<datas.length;i++){
				//var tmpDate=stamp.fromISOString(datas[i].start),
				//endDate=stamp.fromISOString(datas[i].end);
				var tmpDate=cutil.parseDate(datas[i].start),
					endDate=cutil.parseDate(datas[i].end);
				tmpDate.setHours(0,0,0,0);
				while(dateClz.compare(tmpDate,endDate) <= 0 ){
					var key=cutil.formatDate(tmpDate);
					if(!__caches[key]){
						__caches[key]=[];
					}
					__caches[key].push(datas[i]);
					tmpDate=dateClz.add(tmpDate,"day",1);
				}
			}
			return __caches;
		},
		
		//数据排序
		_sortDatas:function(datas){
			
		},
		
		_hasCalendar:function(args){
			args.startDate.setHours(0,0,0,0);
			args.endDate.setHours(0,0,0,0);
			var result={},
				tmpDate=args.startDate,
				__caches=this.__caches;
			while(dateClz.compare(tmpDate,args.endDate) <= 0){
				var key=cutil.formatDate(tmpDate);
				if(__caches[key] && __caches[key].length >0 ){
					result[key] = true;
				}
				tmpDate=dateClz.add(tmpDate,"day",1);
			}
			return result;
		}
		
		
	});
});