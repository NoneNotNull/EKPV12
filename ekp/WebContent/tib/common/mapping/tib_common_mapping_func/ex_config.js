/**
 * 
 * 主要用来控制明细表,转出json元素,根据json元素初始化数据 base :doclist.js
 * /tib/common/mapping/tib_common_mapping_func/sapEkpTempFunc_edit.jsp 页面明细控制
 */
DetailJsonHelper = {};

DetailJsonHelper.apply = function(o, c, defaults) {
	if (defaults) {
		// no "this" reference for friendly out of scope calls
		DetailJsonHelper.apply(o, defaults);
	}
	if (o && c && typeof c == 'object') {
		for (var p in c) {
			o[p] = c[p];
		}
	}
	return o;
};

(function() {
	DetailJsonHelper.apply(DetailJsonHelper, {
		targetID : "extendForm_table",
		fieldTitle : "fdExtendForms[!{index}]",
		fieldArray : ["fdId", "fdExceptionType", "fdIsIgnore", "fdIsAssign",
				"fdAssignField", "fdAssignFieldid", "fdRefId", "fdAssignVal"],
		defData : [{
					'fdId' : '',
					'fdExceptionType' : MSG_Properties.businessFdExceptionType,
					'fdIsIgnore' : 'true',
					'fdIsAssign' : 'false',
					'fdAssignField' : '',
					'fdAssignFieldid' : '',
					'fdRefId' : '',
					'fdAssignVal' : ''
				}, {
					'fdId' : '',
					'fdExceptionType' : MSG_Properties.programFdExceptionType,
					'fdIsIgnore' : 'true',
					'fdIsAssign' : 'false',
					'fdAssignField' : '',
					'fdAssignFieldid' : '',
					'fdRefId' : '',
					'fdAssignVal' : ''
				}],
		// 配置json数据到动态表格
		initJsonData : function(array) {
			var jsonArray = null;
			// 校验数据
			if (typeof(array) == "string"&&array) {
				jsonArray = eval("(" + array + ")");
			} else if (this.isArray(array)) {
				jsonArray = array;
			}
			var flagArray = [false, false];
			if (jsonArray) {
				for (var i = 0, len = jsonArray.length; i < len; i++) {
					var jsonObject = jsonArray[i];
					if (jsonObject["fdExceptionType"]) {
//						alert(jsonObject["fdExceptionType"]);
						jsonObject["fdExceptionType"] == this.defData[0]['fdExceptionType']
								? flagArray[0] = true
								: jsonObject["fdExceptionType"] == this.defData[1]['fdExceptionType']
										? flagArray[1] = true
										: '';
					}
					var parseData = this.dataParse(jsonObject);
					DocList_AddRow(this.targetID, null, parseData);
				}
			}
			// 默认数据
			if (!flagArray[0]) {
				DocList_AddRow(this.targetID, null, this
								.dataParse(this.defData[0]));
			}
			if (!flagArray[1]) {
				DocList_AddRow(this.targetID, null, this
								.dataParse(this.defData[1]));
			}

		},
		// 取明细数据转化json [fieldName：fieldVal ] fieldName 去掉 from.[!index] 只取当前的
		getJsonFromDetail : function(targetID, index) {
			var jsonData = [];
			var target = null;
			if (!targetID) {
				target = this.targetID;
			}
			if (target) {
				if (typeof(target) == "string") {
					target = document.getElementById(target);
				}
				// 去数据行,一般动态第一行为title,第二行为基准行
				if (typeof index == "undefined") {
					index = 1;
				}
				for (var i = index, len = target.rows.length; i < len; i++) {
					var row = target.rows[i];
//					alert(this.getTitleIndex(row));
					var title=this.getTitleIndex(row);
					var rowJs = {};
					for (var j = 0, j_len = this.fieldArray.length; j < j_len; j++) {
//						var name = this.fieldTitle.replace("!{index}", dtNum)
//								+ "." + this.fieldArray[j];
						var name =title+"."+this.fieldArray[j];
						var elem = document.getElementsByName(name)[0];
						var value = this.getVal(elem);
//						alert(name+":"+value);
						rowJs[this.fieldArray[j]] = value;
					}
					if (!this.isEmptyObject(rowJs)) {
						jsonData.push(rowJs);
					}
				}
			}
//			alert(JSON.stringify(jsonData));
			return jsonData;
		},
		//取得fdExtendForms[0] 名字
		getTitleIndex : function(row) {
//			alert(row);
			if (row.cells.length <= 0)
				return null;
			for (var i = 0, len = row.cells.length; i < 1; i++) {
				var cell = row.cells[0];
				for (var c = 0, c_len = cell.childNodes.length; c < c_len; c++) {
					var child = cell.childNodes[0];
					if (child.nodeType == '1' && child.tagName == 'INPUT') {
//						 alert(child.name.split(".")[0]);
						return child.name.split(".")[0];
					}
				}
			}
			return null;
		},
		//取得节点的value 对checkbox 跟select处理一下
		getVal : function(elem) {
			if (!elem)
				return '';
			switch (elem.tagName) {
				case "INPUT" :
					if (elem.type == "checkbox") {
						return elem.checked == true ? 'true' : 'false';
					}
					return elem.value || '';
				case "SELECT" :
					for (var j = 0; j < elem.options.length; j++) {
						if (elem.options[j].selected == true)
							return elem.options[j].value;
					}
					return '';
				default :
					return elem.value || '';
			}
		},
		// 把{field：} 转化 {title[!{index}].field} 适应doclist.js
		dataParse : function(data) {
			var parse = {};
			if (this.fieldTitle) {
				for (name in data) {
					parse[this.fieldTitle + "." + name] = data[name];
				}
			} else {
				parse = data;
			}
			return parse;
		},
		isArray : function(obj) {
			return Object.prototype.toString.call(obj) === '[object Array]';
		},
		isEmptyObject : function(obj) {
			for (var x in obj) {
				return false;
			}
			return true;
		}
	});
	// 动态表格初始化
	if (DetailJsonHelper.targetID) {
		DocList_Info.push(DetailJsonHelper.targetID);
		DocListFunc_Init();
	}
})();


function toggleImp(){
   var bool=false;	
   $("input[controlElem='true']").each(function (index,dom){
        if(dom.checked){
          bool=true;
        }
        if(bool){
          return false;
        }
   });
   if(bool){
   $("label[toggleElem='true']").each(function (i,elem){
   	elem.parentNode.style.display='';
//   	$(elem.parentNode).fadeIn("slow");
   	
   })
   }
   else{
   $("label[toggleElem='true']").each(function (i,elem){
   	elem.parentNode.style.display='none';
//   		$(elem.parentNode).fadeOut("slow");
   })
   }
}

/**
 * 调用/tib/common/mapping/tib_common_mapping_func/sapEkpTempFunc_edit.jsp页面表单事件处理方式处理弹出框
 */
function formula_field_dialog(curElem) {
	var index = curElem.name;
	var bindId = DetailJsonHelper.fieldTitle.replace("!{index}", index)
			+ ".fdAssignFieldid";
	var bindName = DetailJsonHelper.fieldTitle.replace("!{index}", index)
			+ ".fdAssignField";
	simple_formula(bindId,bindName);
}
