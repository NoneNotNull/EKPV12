define([ "dojo/_base/declare", "dojo/dom-construct", "dijit/registry", 
         "mui/form/Input", "dojo/query", "dojo/NodeList-traverse"
         ], function(declare, domConstruct, registry, Input, query) {
	var claz = declare("sys.xform.mobile.controls.ChinaValue", [ Input ], {

		inputClass: 'muiFormInput muiFormChina',
		
		postCreate: function() {
			this.inherited(arguments);
			if(this.edit){
				this.subscribe(this.EVENT_VALUE_CHANGED, '_upperValue');
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
			var chinaBtn = domConstruct.create("i", {
				className : 'mui mui-uper'
			}, optContainer);
			this.connect(chinaBtn, 'click', '_upper');
		},

		buildEdit: function() {
			this.buildReadOnly();
		},
	
		_upperValue: function(srcObj , val){
			if(this != srcObj){
				if(this.relatedid!=null && this.relatedid!=''){
					this._upper();
				}
			}
		},
		
		_upper: function(){
			if(this.relatedid!=null && this.relatedid!=''){
				var domArr = query('[widgetid]', this.xformAreaNode);
				if(domArr.length>0){
					for ( var i = 0; i < domArr.length; i++) {
						var wgt = registry.byNode(domArr[i]);
						var tmpName = this._parseCalcName(wgt);
						if(this.relatedid.indexOf(tmpName)>-1){
							this._fillValue(wgt);
							break;
						}
					}
				}
			}
		},
		_fillValue:function(wgt){
			var val = wgt.get('value');
			var chinaStr = this._parseChinaValue(val);
			this.set("value",chinaStr);
		},
		_parseCalcName: function(wgt) {
			var name = wgt.name;
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
		 _parseChinaValue:function(value){
			var chineseValue = ""; //转换后的汉字金额   
			//数字才做转化
			if(!isNaN(value)){
				//如果大于9999999999999,提示超出可计算范围
				if(value>9999999999999 || value <-9999999999999){
					chineseValue="超出大写可计算范围";
					return chineseValue;
				}
				//如果是负数,前面加"负"字
				if(value<0){
					chineseValue="负";
					value=Math.abs(value);
				}
				var numberValue = new String(Math.round(value * 100)); //数字金额   
				var String1 ='零壹贰叁肆伍陆柒捌玖'; //汉字数字   
				var String2 =' 万仟佰拾亿仟佰拾万仟佰拾元角分'; //对应单位   
				var len = numberValue.length; //   numberValue的字符串长度   
				var Ch1; //数字的汉语读法   
				var Ch2; //数字位的汉字读法   
				var nZero = 0; //用来计算连续的零值的个数   
				var String3; //指定位置的数值   
				if (numberValue == "0") {
					chineseValue = '零元整';
					return chineseValue;
				}
				String2 = String2.substr(String2.length - len, len); //   取出对应位数的STRING2的值   
				for ( var i = 0; i < len; i++) {
					String3 = parseInt(numberValue.substr(i, 1), 10); //   取出需转换的某一位的值   
					if (i != (len - 3) && i != (len - 7) && i != (len - 11)
							&& i != (len - 15)) {
						if (String3 == 0) {
							Ch1 = "";
							Ch2 = "";
							nZero = nZero + 1;
						} else if (String3 != 0 && nZero != 0) {
							Ch1 = '零'
									+ String1.substr(String3, 1);
							Ch2 = String2.substr(i, 1);
							nZero = 0;
						} else {
							Ch1 = String1.substr(String3, 1);
							Ch2 = String2.substr(i, 1);
							nZero = 0;
						}
						//该位是万亿，亿，万，元位等关键位   
					} else { 
						if (String3 != 0 && nZero != 0) {
							Ch1 = '零'
									+ String1.substr(String3, 1);
							Ch2 = String2.substr(i, 1);
							nZero = 0;
						} else if (String3 != 0 && nZero == 0) {
							Ch1 = String1.substr(String3, 1);
							Ch2 = String2.substr(i, 1);
							nZero = 0;
						} else if (String3 == 0 && nZero >= 3) {
							Ch1 = "";
							Ch2 = "";
							nZero = nZero + 1;
						} else {
							Ch1 = "";
							Ch2 = String2.substr(i, 1);
							nZero = nZero + 1;
						}
						//如果该位是亿位或元位，则必须写上   
						if (i == (len - 11) || i == (len - 3)) {
							Ch2 = String2.substr(i, 1);
						}
					}
					chineseValue = chineseValue + Ch1 + Ch2;
				}
				var String4 =0;
				if(len>2){
					String4=parseInt(numberValue.substr(len - 2, 1), 10);
				}
				//最后一位（分）为0时，加上“整”  
				if (String3 == 0 && String4 == 0) {  
					chineseValue = chineseValue+ '整';
				}
			}
			return chineseValue;
		}
	});
	return claz;
});