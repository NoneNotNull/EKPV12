define( [ "dojo/_base/declare", 
          "dojo/dom-class","dijit/_WidgetBase","dojo/dom-style",
      	"dojo/dom-construct",'dojo/topic','dojo/request', "mui/util", 
      	'dojo/_base/array','dojo/dom-geometry', "mui/rating/Rating",
      	"dojox/mobile/viewRegistry"], 
      	function(declare,  domClass,
      			_WidgetBase, domStyle,domConstruct,topic,request, util, array,
      			domGeometry, Rating, viewRegistry) {

	return declare("sys.evaluation.EvaluationHeader", [ _WidgetBase ], {
		
		fdModelId: "",
		
		fdModelName : "",
		
		scoreDetail : [],
		
		evalCount : 0,
		
		url:"/sys/evaluation/sys_evaluation_main/sysEvaluationMain.do?method=dataScore&fdModelId=!{fdModelId}&fdModelName=!{fdModelName}",
		
		
		_setScoreDetailAttr : function() {
							var arr = new Array();
							for ( var i = 0; i < 5; i++) {
								arr.push( {
									"score" : i,
									"times" : 0,
									"star" : 5 - i
								});
							}
							this.scoreDetail = arr;
						},
		
		startup : function() {
			this.inherited(arguments);
			this._request();
		},
		
		
		_request : function() {
			var url = util.urlResolver(this.url, {
				"fdModelId" : this.fdModelId,
				"fdModelName" : this.fdModelName
			});
			request.get(util.formatUrl(url), {
				handleAs : "json"
			}).then(
					function(response) {
						this.evaData = response;
						topic.publish(
								"/sys/evaluation/header/data",
								this,  response
								);
					},
					function(err) {
						topic.publish(
								"/sys/evaluation/header/data",
								this, {
									"error" : true,
									"msg" : err
								});
					});
		},
		
		postCreate: function(){
			this.subscribe("/sys/evaluation/header/data" , "_onCompleted");
			this.subscribe('/mui/list/onPull', 'handleOnReload');
			this.subscribe('/mui/list/onReload', 'handleOnReload');
		},
		
		buildRendering : function() {
			this.inherited(arguments);
			this.container = domConstruct.create("div", {className : 'muiEvaluationHeaderContainer'}, this.domNode);
		},
		
		_onCompleted : function(obj, data) {
			if(data.error) {
				this.container.innerHTML = "请求数据出错";
				return;
			}
			if(this.content) {
				this._initData();
				domConstruct.empty(this.container);
			}
			
			this.content = domConstruct.create("div", {className : 'muiEvaluationHeaderContent'}, this.container);
			this.buildLeftContent(data);
			this.buildRightContent(data);
		},
		
		buildLeftContent :  function(data) {
			array.forEach(data.detail, function(item) {
				var times = parseInt(item.times);
			    this.scoreDetail[parseInt(item.score)].times = times;
				//计算总数
				this.evalCount += times;
			}, this); 
			var leftDom =  domConstruct.create("div", {className: 'muiEvaluationHeaderLeft'}, this.content);
			var average = data.average;
			var scoreHtml = "";
			var leftClassName = "muiEvaluationHeaderScore";
			if(this.evalCount <= 0) {
				leftClassName = "muiEvaluationHeaderNone";
				scoreHtml = "暂无评分";
			} else {
				scoreHtml = average +  "<span class='muiEvaluationScoreUnit'>分</span>"; 
			}
			domConstruct.create("div" ,{className:leftClassName, innerHTML:scoreHtml }, leftDom);
			var widget = new Rating({
				value :  average
			});
			leftDom.appendChild(widget.domNode);
			domConstruct.create("div" ,{className:'muiEvaluationHeadeCount', innerHTML:(this.evalCount + "人评价") }, leftDom);
		},
		
		buildRightContent :  function(data) {
			this.leftDom = domConstruct.create("div", {
								className : 'muiEvaluationHeadeRight'
							}, this.content);
			var uldom = domConstruct.create("ul", {
				className : 'muiEvaluationHistogramContainer'
			}, this.leftDom);
			var cw  = domGeometry.getContentBox(uldom).w - 60;
			
			array.forEach(this.scoreDetail, function(item) {
				if(this.evalCount <= 0 ) {
					item.item_with = "0px";
				} else {
					var percent = item.times / this.evalCount ;
					item.percent = (percent* 100) + "%";
					item.item_with = percent * cw  + "px";
				}
				this._buildHistogram(uldom, item, cw);
			}, this);
		},
		
		_buildHistogram: function(dom, item, cw) {
			
			var __li = domConstruct.create("li", {
				className : 'muiEvaluationHistogram'
			}, dom);
			domConstruct.create("span", {
				className : 'muiEvaluationHistogramTitle',
				innerHTML : item.star + "星"
			}, __li);
			//评分柱子
			var histogram = domConstruct.create("span", {
				className : 'muiEvaluationHistogramContent'
			}, __li);
			domStyle.set(histogram, {"width" : cw + "px"});
			var histogramBody =  domConstruct.create("span", {
				className : 'muiEvaluationHistogramBody'
			}, histogram);
			domStyle.set(histogramBody, {"width" : item.item_with});
			
			//后面的个数
			domConstruct.create("span", {
				className : 'muiEvaluationHistogramNum',
				innerHTML : item.times
			}, __li);
		},
		
		destroyContainerRendering : function() {
			if(this.container) {
				domConstruct.empty(this.container);
			}
		},
		
		_initData : function() {
			this.evalCount = 0;
			this._setScoreDetailAttr();
		},
		
		handleOnReload :function(widget, handle) {
			var scroll = viewRegistry.getEnclosingScrollable(this.domNode);
			if (widget === scroll) {
				this._request(handle);
			}
		}
		
	});
});