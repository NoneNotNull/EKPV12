define(function(require, exports, module) {
	    require("theme!chart");
		var base = require('lui/base');
		var Class = require("lui/Class");
		var $ = require("lui/jquery");
		var Evented = require('lui/Evented');
		var env = require('lui/util/env');
		var strutil = require('lui/util/str');
		var source = require("lui/data/source");
		var lang = require('lang!sys-ui');
		
		var Chart = base.Component.extend({
				initProps: function($super, cfg) {
					$super(cfg);
					this.loading = $("<img src='" + env.fn.formatUrl('/sys/ui/js/ajax.gif') + "' />");
				},
				textV:function(text){
		 			var txtArr = text.split(" ");
		 			var tmpArr =[];
		 			for ( var i = 0; i < txtArr.length; i++) {
						if(txtArr[i]!=""){
							if(i!=0){
								tmpArr.push("\n");
							}
							var oldChar = "";
							for(var j=0;j<txtArr[i].length;j++){
				 				var tmpChar = txtArr[i].charAt(j);
				 				if((/[^\x00-\xff]/g.test(oldChar) && oldChar!= "")//上一个字符是中文的情况
				 						||(/[^\x00-\xff]/g.test(tmpChar) && oldChar!= "" && !/[^\x00-\xff]/g.test(oldChar))){//本字符是中文并且上一字符非中文
			 						tmpArr.push("\n");
			 					}
			 					tmpArr.push(tmpChar);
				 				oldChar = tmpChar;
				 			}
						}else continue;
					}
		 			return tmpArr.join("");
		 		},
		 		load: function() {
					var ___isload=false;
					if(this.chartdata && this.chartdata instanceof source.UrlSource){
						if(this.chartdata.url){
							___isload=true;
						}
					}else{
						___isload=true;
					}
					if(___isload){
						$("#"+this.id+" .div_chart").append(this.loading);
						this.chartdata.get();
					}
				},
				startup: function() {
					if (this.isStartup) {
						return;
					}
					var _self = this;
					if (this.chartdata) {
						this.chartdata.on('error', this.onError, this);
						this.chartdata.on('data', this.onDataLoad, this);
					}
					this.isStartup = true;
				},
				switchChart:function(isTable){
		 			if(isTable=="1"){//当前状态显示图标
		 				$("#"+this.id+" .div_chart").hide();
		 				this.showList($("#"+this.id+" .div_listSection"));
		 			}else{
		 				$("#"+this.id+" .div_listSection").hide();
		 				$("#"+this.id+" .div_chart").show();
		 			}
		 		},
		 		
		 		prepareData:function(){
		 			
		 		},
		 		showList:function(listDiv){
		 			var _self = this; 
		 			var xdata=[];
		 			var field = [];
		 			var datas=[];
		 			var series = _self.result.series;
		 			if(series.length==1&&(series[0].type == 'pie'||series[0].type == 'gauge')){
		 				var pData = series[0];
		 				var tempdata=[];
		 				field.push(pData.name);
		 				for(var key in pData.data){
		 					var obj = pData.data[key];
		 					xdata.push(obj.name);
		 					tempdata.push(obj.value);
		 				}
		 				datas.push(tempdata);
		 			}else{
		 				xdata = _self.result.xAxis[0].data;
		 				for(var i=0;i<series.length;i++){
			 				var sData = series[i];
			 				field.push(sData.name);
			 				datas.push(sData.data);
			 			}
		 			}
		 			
		 			listDiv.html('');
		 			listDiv.append($("<div class='div_close com_btn_link'>返回</div>").click(function(){
		 				_self.switchChart("0");
		 			}));
		 			if(datas!=null && datas.length>0){
		 				var content = $('<table class="tab_listData"></table>');
		 				var titleTr = $('<tr class="tab_title"></tr>');
		 				$('<th></th>').appendTo(titleTr);
		 				for(var j=0;j<field.length;j++){
		 					$('<th>'+field[j]+'</th>').appendTo(titleTr);
		 				}
		 				titleTr.appendTo(content);
		 				
		 				for ( var k = 0; k < xdata.length; k++) {
							var dataTr = $('<tr class="tab_data"></tr>');
							$('<td>'+xdata[k]+'</td>').appendTo(dataTr);
							for ( var m = 0; m < datas.length; m++) {
								$('<td>'+datas[m][k]+'</td>').appendTo(dataTr);
							}
							dataTr.appendTo(content);
						}
		 			}
			 			listDiv.append(content);

			 			listDiv.show();

		 		},
				onDataLoad: function(rtn) {
		 			var chartDom = $("#"+this.id+" .div_chart");
		 			var _self = this;
					if(rtn.chart){
						if(rtn.chart.width){
							chartDom.width(rtn.chart.width);
						}
						if(rtn.chart.height){
							chartDom.height(rtn.chart.height);
						}
						delete rtn.chart;
					}
		 			this.result = rtn;
		 			
					if(rtn.title!=null&&rtn.title.text!=null){
						//如果标题摆放的位置为左居中或右居中，则把标题竖着摆放
						if(rtn.title.y == 'center'&&(rtn.title.x == 'left'||rtn.title.x == 'right')){
							rtn.title.text = _self.textV(rtn.title.text);
							if(rtn.title.subtext!=null){
								rtn.title.subtext = _self.textV(rtn.title.subtext);
					      }
					   }
					}
					if(rtn.toolbox&&rtn.toolbox.feature&&!rtn.toolbox.feature.dataTableView){
						this.mergeCustomOption({
							toolbox:{
								feature:{
									dataTableView:{
										show:true, 
										title:'数据视图',
										icon: Com_GetCurDnsHost() + Com_Parameter.ContextPath+"sys/ui/extend/theme/default/images/chart/switch.png",
						 				onclick:function(){
							             _self.switchChart("1");
						 				}
									}
								}
							}
						});
					}
					if(this.customOption){
						this._merge(rtn, this.customOption);
					}
					this.echart = echarts.init(chartDom[0]);
					if(rtn.on){
						for(var o in rtn.on){
							this.echart.on(o, rtn.on[o]);
						}
						delete rtn.on;
					}
					this.echart.setOption(rtn);
				},
				getEchart: function(){
					return this.echart;
				},
				onError: function(msg) {
					this.doRender(msg);
				},
				addChild: function(child) {
					if(child instanceof source.BaseSource){
					   this.chartdata = child;
					}
				},
				doRender: function(html) {
					this.loading.remove();
					if (html) {
						this.element.html("");
						this.element.append(html);
					}
					this.isLoad = true;
					this.fire({
						"name": "load"
					});
				},
				erase: function($super) {
					this.element.html("");
					$super();
				},
				draw: function() {
					if (this.isDrawed)
						return;
					this.element.show();
					this.load();
				},
				
				replaceDataSource:function(sourceCfg){
					if(sourceCfg!=null){
						this.chartdata = new source[sourceCfg.type](sourceCfg);
						this.chartdata.on('error', this.onError, this);
						this.chartdata.on('data', this.onDataLoad, this);
						this.load();
					}
				},
				mergeCustomOption: function(option,isLoad){
					if(!this.customOption){
						this.customOption=option;
					}else{
						this._merge(this.customOption,option);
					}
					//this.customOption=option;
					if(isLoad){
						this.load();
					}
				},
				_merge:function(destination,source){
					for (var property in source){
						if(typeof source[property]==="object"){
							if(!destination[property]){
								destination[property]={};
							}
							destination[property]=this._merge(destination[property],source[property]);
						}else{
							destination[property] = source[property];
						}
					}
					return destination;
				}
		  });  

		exports.Chart = Chart;
});