/*压缩类型：标准*/
/***********************************************
JS文件说明：
该文件提供了图表的调用方法。

作者：易荣烽
版本：1.0 2010-1-4
修改记录:
   20110818   函数ChartFunc_Init增加xml返回值,
              避免flash内部调用报错.
***********************************************/

Com_RegisterFile("chart.js");
Com_IncludeFile("data.js");

//图表类型常量
var CHART_TYPE_PIE = "pie"; //用于图表类型（PieChart3D.swf）与系列类型（饼状图）
var CHART_TYPE_LINE = "line"; //用于图表类型（Chart2D.swf）与系列类型（线状图）
var CHART_TYPE_BAR = "column"; //用于图表类型（Chart3D.swf）与系列类型（柱状图）
var CHART_TYPE_AREA = "area"; //用于系列类型（区域图）
var CHART_TYPE_PLOT = "plot"; //用于系列类型（散点图）
var CHART_TYPE_MUTI = "muti"; //暂无用途
//图表数据类型常量
//字符串型
var CHART_DATA_TYPE_FIELD = "field";
//日期型
var CHART_DATA_TYPE_DATE = "date";
//线型，多数用于Y轴
var CHART_DATA_TYPE_LINEAR = "linear";

/*******configXml\dataXml具体配置样例**********************
请访问http://java.landray.com.cn/product/flashShow/index.html
在具体图表中点击查看数据即可
 **************************************************/

(function(){
/***********************************************
功能：图表构造函数
参数：
	refName：
		必选，字符串，引用的全局变量名
	chartType:
		必选，图表类型，CHART_TYPE_PIE|CHART_TYPE_LINE|CHART_TYPE_BAR
		CHART_TYPE_PIE对应PieChart3D.swf，CHART_TYPE_LINE对应Chart2D.swf，CHART_TYPE_BAR对应Chart3D.swf
	DOMElement：
		必选，HTML元素，需要放置目录树的HTML元素对象
***********************************************/
window.Chart = function (refName,chartType,DOMElement){
	this.configXml = null; 			//配置XML
	this.dataXml = null; 			//数据XML
	this.height = "100%"; 			//图表高度
	this.width = "100%";  			//图表宽度
	this.title = null;  			//图表名称
	this.xSuffix = null; 			//x轴后缀
	this.ySuffix = null;			//y轴后缀
	this.xDataType = null;			//x轴数据类型，默认为linear
	this.yDataType = null;			//y轴数据类型，默认为field
	this.xName = null;				//x轴名称
	this.yName = null;				//y轴名称
	
	//===============================以下参数饼图专用=====================================================
	this.pieHeight = null;			//饼状高度，默认为20
	this.ifLabel = null;			//饼面是否显示label，值为0，1，默认为显示
	this.label = null;				//饼面显示值，默认为percent，当ifLabel为0时，该参数无效
	this.itemsPerColumn = null;		//标题每列显示行数，默认为6行
	//===============================以上参数饼图专用=====================================================
	
	this.Show = ChartFunc_Show; 	//图表展现
	this.SetLabelByString = ChartFunc_SetLabelByString;  	//设置lables
	this.SetValueByString = ChartFunc_SetValueByString;		//设置数据
	
	//===============================以下属性/方法仅供内部使用，普通模块请勿调用============================
	this.refName = refName;			//引用全局变量名
	this.chartType = chartType;		//图表类型
	this.DOMElement = DOMElement;
	this.data = {};
	this.series = {};
	
	this.PrepareData = ChartFunc_PrepareData;
	this.Init = ChartFunc_Init;
}

/************************************************
功能：设置lables
参数：
	lables：
		必选，字符串
	splitStr:
		可选，分隔符号，为空则默认为“;”
************************************************/
function ChartFunc_SetLabelByString(lables,splitStr){
	splitStr = splitStr || ";";
	this.data["label"] = lables.split(splitStr);
}

/************************************************
功能：设置数据
参数：
	values：
		必选，字符串，参数值
	splitStr:
		可选，分隔符号，为空则默认为“;”
	valueName:
		必选，字符串，参数名称
	seriesName:
		可选，字符串，系列名称
	seriesType：
		必选，字符串，系列类型，CHART_TYPE_PIE，CHART_TYPE_LINE，CHART_TYPE_BAR，CHART_TYPE_PLOT，CHART_TYPE_MUTI
************************************************/
function ChartFunc_SetValueByString(values,splitStr, valueName, seriesName, seriesType){
	splitStr = splitStr || ";";
	valueName = valueName || "value";
	seriesType = seriesType || this.chartType;
	this.data[valueName] = values.split(splitStr);
	this.series[valueName] = {name:seriesName, type:seriesType};
}

/************************************************
功能：准备数据
************************************************/
function ChartFunc_PrepareData(){
	if(this.configXml==null){
		var xml = [];
		xml.push("<config");
		if(this.pieHeight){
			xml.push(' pieHeight="'+Com_HtmlEscape(this.pieHeight)+'"');
		}
		if(this.ifLabel){
			xml.push(' ifLabel="'+Com_HtmlEscape(this.ifLabel)+'"');
		}
		if(this.label){
			xml.push(' label="'+Com_HtmlEscape(this.label)+'"');
		}
		xml.push(">");
		if(this.xSuffix && this.ySuffix){
			xml.push('<format xSuffix="'+Com_HtmlEscape(this.xSuffix)+'" ySuffix="'+Com_HtmlEscape(this.ySuffix)+'"/>');
		}else if(this.xSuffix && !this.ySuffix){
			xml.push('<format xSuffix="'+Com_HtmlEscape(this.Suffix)+'"/>');
		}else if(!this.xSuffix && this.ySuffix){
			xml.push('<format ySuffix="'+Com_HtmlEscape(this.ySuffix)+'"/>');
		}		
		if(this.title){
			xml.push('<title name="'+Com_HtmlEscape(this.title)+'"/>');
		}		
		if(this.xDataType || this.xName || this.yDataType || this.yName){
			xml.push('<axis>');
			if(this.xDataType && this.xName ){
				xml.push('<horizontal type="'+this.xDataType+'" name="'+Com_HtmlEscape(this.xName)+'"/>');
			}else if(this.xDataType && !this.xName){
				xml.push('<horizontal type="'+this.xDataType+'"/>');
			}else if(!this.xDataType && this.xName){
				xml.push('<horizontal name="'+Com_HtmlEscape(this.xName)+'"/>');
			}else{
				xml.push('<horizontal type="field"/>');
			}
			if(this.yDataType && this.yName){
				xml.push('<vertical type="'+this.yDataType+'" name="'+Com_HtmlEscape(this.yName)+'"/>');
			}else if(this.yDataType && !this.yName){
				xml.push('<vertical type="'+this.yDataType+'"/>');
			}else if(!this.yDataType && this.yName){
				xml.push('<vertical name="'+Com_HtmlEscape(this.yName)+'"/>');
			}else{
				xml.push('<vertical type="linear"/>');
			}
			xml.push('</axis>');
		}		
		xml.push("<series>");
		for(var o in this.series){
			xml.push('<'+Com_HtmlEscape(this.series[o].type)+' xField="label" yField="'+Com_HtmlEscape(o)+'" seriesName="'+Com_HtmlEscape(this.series[o].name)+'"/>');
		}
		xml.push("</series>");
		if(this.itemsPerColumn){
			xml.push('<legend itemsPerColumn="'+Com_HtmlEscape(this.itemsPerColumn)+'"/>');
		}
		xml.push("</config>");
		this.configXml = xml.join("");
	}
	if(this.dataXml==null){
		var xml = [];
		xml.push('<data>');
		for(var i=0, length = this.data.label.length; i<length; i++){
			if(o=="label")
				continue;
			xml.push('<set label="'+Com_HtmlEscape(this.data["label"][i])+'" ');
			for(var o in this.data){
				if(o=="label")
					continue;
				xml.push(o+'="'+Com_HtmlEscape(this.data[o][i])+'" ');
			}
			xml.push('/>');
		}
		xml.push('</data>');
		this.dataXml = xml.join("");
	}
}
/******************************************
功能：展现图表
******************************************/
function ChartFunc_Show(){
	var flashType;
	if(this.chartType == CHART_TYPE_PIE){
		flashType = Com_Parameter.ContextPath+'resource/plusin/PieChart3D.swf';
	}else if(this.chartType == CHART_TYPE_LINE){
		flashType = Com_Parameter.ContextPath+'resource/plusin/Chart2D.swf';
	}else{
		flashType = Com_Parameter.ContextPath+'resource/plusin/Chart3D.swf';
	}
	var html;
	if(Com_Parameter.IE){
		html = ['<object classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000" width="'+this.width+'" height="'+this.height+'" accesskey="f" tabindex="1" id="', this.refName, '_ChartFlash">',
		        '<param name="movie" value="', flashType, '">',
		        '<param name="quality" value="high">',
		        '<param name="wmode" value="opaque">',
		        '<param name="flashvars" value="completeFunction=', this.refName, '.Init" />',
		        '</object>'];
	}else{
		html = ['<embed width="'+this.width+'" height="'+this.height+'" accesskey="f" tabindex="1" id="', this.refName, '_ChartFlash"',
		        ' src="', flashType, '" flashvars="completeFunction=', this.refName, '.Init" />'];
	}
	this.DOMElement.innerHTML = html.join('');
}
 
/*****************************
功能：初始化
*****************************/
function ChartFunc_Init() {
	var flashObj = document.getElementById(this.refName + "_ChartFlash");
	this.PrepareData();
	flashObj.setConfigToAS(this.configXml);
	// 修复饼状图title在ie下不显示的问题
	if (this.chartType == CHART_TYPE_PIE) {
		var self = this;
		setTimeout(function() {
					flashObj.setDataToAS(self.dataXml);
				}, 1);
		return;
	}
	flashObj.setDataToAS(this.dataXml);
	return "<success>true</success>";
}
})();