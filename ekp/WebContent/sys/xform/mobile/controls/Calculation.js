define([ "dojo/_base/declare", "dojo/dom-construct", "dijit/registry", 
         "mui/form/Input", "dojo/query", "dojo/NodeList-traverse"
         ], function(declare, domConstruct, registry, Input, query) {
	var claz = declare("sys.xform.mobile.controls.Calculation", [ Input ], {

		inputClass: 'muiFormInput muiFormCalc',
		
		_calcFun:{'XForm_CalculatioFuns_Sum':'this._detail_sum',
		          'XForm_CalculatioFuns_Count':'this._detail_count',
		          'XForm_CalculatioFuns_Avg':'this._detail_avg'},

		postCreate: function() {
			this.inherited(arguments);
			if(this.edit){
				this.subscribe(this.EVENT_VALUE_CHANGED, '_calcValue');
			}
		},
		startup:function(){
			this.inherited(arguments);
			if(this.edit){
				var nodes = [];
				if("true"==this.isrow){
					nodes = query(this.domNode).parents(".detailTableNormalTd table tr");
					if(nodes.length==0){
						nodes = query(this.domNode).parents(".detailTableSimpleTd table tr");
					}
				}
				if(nodes.length>0){
					this.xformAreaNode = nodes[0];
				}else{
					this.xformAreaNode = document.forms[0];
				}
			}
		},
	
		buildOptIcon: function(optContainer) {
			var calcBtn = domConstruct.create("i", {
				className : 'mui mui-calc'
			}, optContainer);
			this.connect(calcBtn, 'click', '_calc');
		},

		buildEdit: function() {
			this.buildReadOnly();
		},
		
		viewValueSet:function(val){
			if('true' == this.thousandshow){
				var num = val + "";
				if (val == null || num == "" || isNaN(num)) {
					this.valueNode.innerHTML = "";
				    return;   
				}  
				var scale = 0;
				if(this.scale!=null && this.scale!=''){
					scale = parseInt(this.scale, 10);
				}
				this.valueNode.innerHTML = (parseFloat(num).toFixed(scale) + '').replace(/\d{1,3}(?=(\d{3})+(\.\d*)?$)/g, '$&,');
			}else{
				this.inherited(arguments);
			}
		},
		
		_calcValue: function(srcObj , val){
			if(this != srcObj){
				if("true" == this.autocalculate){
					this._calc();
				}
			}
		},
		
		_calc: function(){
			if("true" == this.calculation){
				if (this.expression==null || this.expression=='') {
					return;
				}
				var domArr = query('[widgetid]',this.xformAreaNode);
				if(domArr.length>0){
					var calcContexts = {};
					for ( var i = 0; i < domArr.length; i++) {
						var wgt = registry.byNode(domArr[i]);
						var tmpName = this._parseCalcName(wgt);
						if(tmpName!=null && tmpName!='' && (this.expression.indexOf(tmpName)>-1)){
							var values = calcContexts[tmpName];
							if(!values){
								values = [];
								calcContexts[tmpName] = [];
							}
							values.push(this._parserCalcValue(wgt));
							calcContexts[tmpName] = values;
						}
					}
					this._fillValue(calcContexts);
				}
			}
		},
		_fillValue:function(calcContexts){
			if(calcContexts==null || calcContexts=={}){
				return ;
			}
			var scriptStr = this.expression;
			var isFun = false;
			for(var funKey in this._calcFun){
				if(scriptStr.indexOf(funKey)>-1){
					scriptStr = scriptStr.replace("$" + funKey + "$",this._calcFun[funKey]);
					if(!isFun){
						isFun = true;
					}
				}
			}
			for(var key in calcContexts){
				var valStr = "";
				if(isFun){
					valStr = calcContexts[key].join(", ");
				}else{
					valStr = calcContexts[key].join(" + ");
					valStr = "(" + valStr + ")";
				}
				scriptStr = scriptStr.replace("$" + key + "$" , valStr);
			}
			var calcValue = 0;
			try{
				calcValue = new Function('return (' + scriptStr + ');').apply(this);
				if (calcValue!= null&&calcValue!= ''&&!isNaN(calcValue)) {
					var c = calcValue.toString();
					if (/\.\d*999999/.test(c) || /\.\d*0000000/.test(c)) {
						var _m = Math.pow(10, 6);
						calcValue = Math.round(parseFloat(calcValue)*_m)/_m;
					}
				}else{
					calcValue = 0; 
				}
			}catch(e){
				calcValue = 0;
			}
			this.set("value",calcValue);
		},
		
		_parseCalcName: function(wgt) {
			var name = wgt.get('name');
			if(name == null || name == ''){
				return null;
			}
			var sIndex = name.indexOf('value(');
			if (sIndex < 0) {
				sIndex = 0;
			}
			var eIndex = name.lastIndexOf(')');
			name = name.substring(sIndex + 6, eIndex);
			var dIndex = name.lastIndexOf('.');
			if (dIndex > -1) {
				name = name.substring(0,name.indexOf('.')) + name.substring(dIndex, name.length);
			}
			return name;
		},
		
		_parserCalcValue:function(wgt){
			var val = wgt.get('value');
			if (val == '' || val == null) {
				return "";
			}
			var isTime = /(\d:)/g.test(val);
			var isDate1 = /^\d{4}-\d{2}-\d{2}/.test(val);
			var isDate2 = /^\d{2}\/\d{2}\/\d{4}/.test(val);
			var d,t;
			if (isTime && (isDate1 || isDate2)) {
				var tmp = val.split(/ +/);
				d = this._parseDate(tmp[0], isDate1);
				t = this._parseTime(tmp[1]);
				return (new Date(d[0], parseFloat(d[1]) - 1, d[2], t[0], t[1], [2])).getTime();
			}
			if (isTime) {
				t = this._parseTime(val);
				return (parseFloat(t[0]) * 60 * 60 + parseFloat(t[1]) * 60 + parseFloat(t[2]));
			}
			if ((isDate1 || isDate2)) {
				d = this._parseDate(val, isDate1);
				return (new Date(d[0], parseFloat(d[1]) - 1, d[2])).getTime();
			}
			return parseFloat(val);
		},
		
		_parseDate:function(dateStr,chinaFmt){
			var rtn;
			if (chinaFmt) {
				return dateStr.split('-');
			} else {
				rtn = [];
				var tmpArray = dateStr.split('/');
				rtn[0] = tmpArray[2];
				rtn[1] = tmpArray[0];
				rtn[2] = tmpArray[1];
			}
			return rtn;
		},
		
		_parseTime:function(timeStr){
			return timeStr.split(':');
		},
		
		_detail_sum:function(){
			var array = (arguments.length > 1 || !(arguments[0] instanceof Array)) ? arguments : arguments[0];
			var sun = 0, num;
			for (var i = 0; i < array.length; i ++) {
				num = parseFloat(array[i]);
				if (isNaN(num)) num = 0;
				sun = this._accAdd(sun,num);
			}
			return sun;
			
		},
		_detail_avg:function(){
			var array = (arguments.length > 1 || !(arguments[0] instanceof Array)) ? arguments : arguments[0];
			var sun = 0, num, count = 0;
			for (var i = 0; i < array.length; i ++) {
				num = parseFloat(array[i]);
				if (isNaN(num)) {
					continue;
				}
				sun = this._accAdd(sun,num);
				count++;
			}
			return (sun / count);
		},
		_detail_count:function(){
			var array = (arguments.length > 1 || !(arguments[0] instanceof Array)) ? arguments : arguments[0];
			var sun = 0;
			for (var i = 0; i < array.length; i ++) {
				if (array[i] != null && array[i] != '' && !isNaN(array[i])) {
					sun++;
				}
			}
			return sun;
		},
		_accAdd:function(num1,num2){ 
		    var r1,r2,m; 
		    try{ 
		        r1 = num1.toString().split(".")[1].length; 
		    }catch(e){ 
		        r1 = 0; 
		    } 
		    try{ 
		        r2=num2.toString().split(".")[1].length; 
		    }catch(e){ 
		        r2=0; 
		    } 
		    m=Math.pow(10,Math.max(r1,r2)); 
		    return Math.round(num1*m+num2*m)/m; 
		}
	});
	return claz;
});