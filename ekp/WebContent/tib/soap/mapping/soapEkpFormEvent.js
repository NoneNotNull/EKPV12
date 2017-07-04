/**
 * 解决js 方法名称冲突问题,js方法模块分离 base on : commonFormEvent.js (setFieldCellValue
 * deleteMxRows getMxId getString) jquery.js
 */

// 加载页面引入需要的脚本

jQuery.ajax({
	type : "GET",
	url : Com_Parameter.ContextPath + "tib/soap/mapping/soapEkpFormEvent.jsp",
	dataType : "script",
	// 设置同步,待加载完成以后才往下执行
	async : false
});

(function() {
	// 需要的脚本
	Com_AddEventListener(window, "load", function() {
				ERP_Common_IncludeFile("resource/js/json2.js");
				ERP_Common_IncludeFile("tib/common/resource/js/erp.parser.js");
			});
})();

/**
 * 基于jquery 引入script 文件, 解决script使用document.write 时候无法在脚本中立刻生效， 需要结束script才生效问题
 * 
 * @param {}
 *            path
 */
function ERP_Common_IncludeFile(path) {
	jQuery.ajax({
		type : "GET",
		url : Com_Parameter.ContextPath + path,
		dataType : "script",
		// 设置同步,待加载完成以后才往下执行
		async : false
	});
}

function SoapuiFormEvent() {

	EkpCommonFormEvent.call(this, null);
	this.verion = "1.0";
	this.modelName = "ekpsoapui";
	this.info = "ERP soapui表单事件模块对象";
	this.formEventFuncXmlService = "tibCommonMappingFormEventFuncXmlService";
	this.formEventFuncBackXmlService = "tibSoapMappingFormEventFuncBackXmlService";
}

// 集成父类属性
SoapuiFormEvent.prototype = new EkpCommonFormEvent();


SoapuiFormEvent.prototype.getFuncXml = function(funcId, beforeAction,
		afterAction) {
		var data = new ERP_data();//new KMSSData();
	var that = this;
	//that.blockShow();
	
	data.SendToBean(this.formEventFuncXmlService + "&funcId=" + funcId,
			function(rtnData) {
				// 先执行xml赋值
				that.setInputParam(rtnData, funcId,beforeAction, afterAction);
			});
};

SoapuiFormEvent.prototype.setInputParam = function(rtnData,funcId, beforeAction,
		afterAction) {
	if (rtnData.GetHashMapArray().length == 0) {
		//that.blockhide();
		return;
	}
	if (!rtnData.GetHashMapArray()[0]["funcXml"]) {
		//that.blockhide();
		alert(TibSoapMapping_lang.noTemplateData);
		return;
	}
	if (beforeAction) {
		if ('[object Function]' == Object.prototype.toString.call(beforeAction)) {
			beforeAction.call(this, rtnData);
		}
	}
	var fdRfcParamXmlObject = ERP_parser
			.parseXml(rtnData.GetHashMapArray()[0]["funcXml"]);
	// var fdRfcParamXmlObject = XML_CreateByContent();
	var input = $(fdRfcParamXmlObject).find('Input'); 
//	获取soapuimainId ,用来给后台查询使用
	var webNode=$(fdRfcParamXmlObject).find('web');
	var attrVal=$(webNode).attr("ID");
	this.fillInputParam(input);
	//alert(fdRfcParamXmlObject.xml);
	this.callWebService(this.XML2String(fdRfcParamXmlObject),attrVal, afterAction);
};

// 填充输入参数
SoapuiFormEvent.prototype.fillInputParam = function(obj) {
	var that = this;
//	用来存放明细表的修改值
	var dt_store=[];
	this.fillInputParamLoop(obj,dt_store);
	this.detailDeal(dt_store);
};


// 得到函数执行后返回的xml
SoapuiFormEvent.prototype.callWebService = function(webservicexml,funcId, action) {
		var data = new ERP_data();//new KMSSData();
	var that = this;
	data.SendToBean(this.formEventFuncBackXmlService + "&xml=" + webservicexml+"&funcId="+funcId, function(
			rtnData) {
//		遮罩关闭
		//that.blockhide();		
				
		if (rtnData.GetHashMapArray().length == 0){
		//that.blockhide();
		}
			
		var funcBackXml = rtnData.GetHashMapArray()[0]["funcBackXml"];
		if (funcBackXml == '0') {
			alert(TibSoapMapping_lang.funcExecuteError);// 如果发生异常,则弹出提示对话框，并且不设置对应值
			return;
		}
		if (!funcBackXml) {
			alert(TibSoapMapping_lang.noReturnDataHandle);
			return;
		}
		if (funcBackXml == "error") {
			alert(TibSoapMapping_lang.returnError);
			return;
		}
		var fdRfcParamXmlObject = ERP_parser.parseXml(funcBackXml);
		var output = $(fdRfcParamXmlObject).find('Output');
		var fault = $(fdRfcParamXmlObject).find('Fault');
//		处理output
		if(output){
		that.fillOutputParam(output);
		}
		if(fault){
			that.fillOutputParam(fault);
		}
		if (action) {
			if ('[object Function]' == Object.prototype.toString.call(action)) {
				action.call(this, rtnData);
			}
		}
	});
};


SoapuiFormEvent.prototype.fillOutputParam=function (output){
	var map_store={};	
	this.fillOutputParamLoop(output,map_store);
	this.dealOutputDetail(map_store);

}

/**
 *
 * @param {} map_store
 *  map_store结构
 *  {
 *   tb1:{
 *   		field1:[nodeInfo],
 *   		field2:[nodeInfo]
 *   		}
 *   tb2:{
 *   		field1:[nodeInfo],
 *   		field2:[nodeInfo]
 *   		}  
 *  
 *  }
 */
SoapuiFormEvent.prototype.dealOutputDetail=function(map_store){
	 for(tb in map_store){
//	 	如果是非明细表的数据进行处理
//	 	非明细表就把节点都存放到数组，用，隔开字符串
	 	if(tb=="erp_single_field_"){
	 		var n_dtInfo=map_store[tb];
	 		for(n_field in n_dtInfo){
	 			var f_infos=n_dtInfo[n_field];
	 			var buf=[];
	 			if(f_infos.length>0){
	 				for(var i=0,len=f_infos.length;i<len;i++){
	 					var f_node=f_infos[i];
	 					var f_value=f_node.nodeValue;
	 					buf.push(f_value);
	 				}
	 			}
	 			var f_values=buf.join(",");
	 			SetXFormFieldValueById(n_field, f_values);
	 		}
	 		continue;
	 	}
	 	
	 	var table_DL="TABLE_DL_"+tb;
	 	var curtable=document.getElementById(table_DL);
//	 	空表格处理
	 	if(!curtable){
	 	 	continue ;
	 	}
//	 	清空表格的所有数据
	 	this.deleteMxRows(table_DL);
//	 	遍历所有的列
	 	var tb_elem=map_store[tb];
	 	
	 	for(field in tb_elem){
	 		var rows=tb_elem[field];
	 		
//	 		去除基准行跟标题行以后
	 		//var rowIndex=curtable.rows.length-2;
	 		for(var i=0;i<rows.length;i++){
	 			
	 			var rowInfo=rows[i];
//	 			当前行
	 			var rowIndex=curtable.rows.length-2;
	 			if(rowIndex<=i){
	 				DocList_AddRow(curtable);
	 			}
	 			var elem=document.getElementsByName('extendDataFormInfo.value(' + tb
				+ '.' + i + '.' + field + ')')[0];
				if(elem){
					$(elem).val(rowInfo.nodeValue);
				}
	 		}
	 	}
	 }
}


SoapuiFormEvent.prototype.fillOutputParamLoop=function (obj,map_store){
	
	if(!obj||$(obj).children().length<=0){
		 return ;
		}
	var c_doms =$(obj).children();
	var top_domInfo=null;
	for(var i=0,len=c_doms.length;i<len;i++){
		var curDom=c_doms[i];
		var curNode=ERP_parser.parseNodeInfo(c_doms[i]);
		if(i==1){
//			如果第一个节点,则标记住
			top_domInfo=curNode;
		}
		if(!ERP_parser.hasComment(curDom)){
//			节点名称相同,且没有注析的情况下可以当做第一个节点来处理
			if(top_domInfo&&top_domInfo.nodeName==curNode.nodeName){
				curNode["comment"]=top_domInfo["comment"];
			}
		}
		//		如果有注解
		if(curNode.comment) {
			//alert(curNode.nodeName);
//			注解信息
			var commentObject =curNode.comment;
//			存在配置信息的话
			if(commentObject["ekpid"]){
				var cur_ekpid =commentObject["ekpid"];
//				alert(cur_ekpid);
				var ekp_info =this.getEkpidInfo(cur_ekpid);
//				如果是明细表或者是多层结构
				if(ekp_info&&ekp_info.indexList.length>1){
//					自定义表单的情况
					if(ekp_info.indexList.length==2){
//						构造明细表结构
					if(!map_store[ekp_info.indexList[0]]){
						map_store[ekp_info.indexList[0]]={};
					}
//					构造列
					if(!map_store[ekp_info.indexList[0]][ekp_info.indexList[1]]){
						map_store[ekp_info.indexList[0]][ekp_info.indexList[1]]=[];
					}
//					填入数据
					map_store[ekp_info.indexList[0]][ekp_info.indexList[1]].push(curNode);
					}
					else{
//					todo：目前支持2层结构。。对3层支持
					}
					
				}
//				非明细表
				else if(ekp_info&&ekp_info.indexList.length==1){
//					不要跟erp_single_field_ 重复
					if(!map_store["erp_single_field_"]){
						map_store["erp_single_field_"]={};
					}
					if(!map_store["erp_single_field_"][ekp_info.indexList[0]]){
						map_store["erp_single_field_"][ekp_info.indexList[0]]=[];
					}
					map_store["erp_single_field_"][ekp_info.indexList[0]].push(curNode);
					//SetXFormFieldValueById(ekp_info.indexList[0], curNode.nodeValue);
				}
			}
		}
		this.fillOutputParamLoop(curDom,map_store);
		
		
	
	}
	
		
	
	
}


/**
 * 
 * @param {} dt_store
 * dt_store数组
 * {domNode:curDom,nodeInfo:curNode,values:valueList };
 * 
 */
SoapuiFormEvent.prototype.detailDeal=function (dt_store){
		if(dt_store&&dt_store.length>0){
			for(var i=0,len=dt_store.length;i<len ;i++){
				var dt_info =dt_store[i];
				var valueList=dt_info["values"];
				var curDom=dt_info["domNode"];
				if(valueList&&valueList.length>0&&curDom){
					for(var v_index=0,v_len=valueList.length;v_index<v_len;v_index++){
						var value=valueList[v_index]||"";
						var cloneNode=curDom.cloneNode(true);
						//var cloneNode=$(curDom).clone(true);
						ERP_parser.setNodeText(cloneNode,value);
						//$(cloneNode).val(value);
						$(cloneNode).insertBefore($(curDom));	
					}
//					把旧的节点删掉
					$(curDom).parent()[0].removeChild(curDom);
				}
				else{
				 continue;
				}
			}
		}
//		return ;
}


SoapuiFormEvent.prototype.fillInputParamLoop=function(obj,dt_store){
//	空节点跳过
	if(!obj||$(obj).children().length<=0){
	 return ;
	}
	var that =this ;
	var d_table={};
	
	var comment=null;
//	如果有注解的情况下,记录第一个节点
	var firstDomNode=null;
	var c_doms = $(obj).children();
	if (c_doms && c_doms.length > 0) {
//		 判断是否存在注解
		 if(ERP_parser.hasComment(c_doms[0])){
//		 	取得第一个节点是否存在注解
		 	firstDomNode=ERP_parser.parseNodeInfo(c_doms[0]);
		 }
	}
	for(var i=0,len = c_doms.length;i<len ;i++){
		var curDom=c_doms[i];
		var curNode=ERP_parser.parseNodeInfo(c_doms[i]);
//		空注解
		if(!curNode.comment){
			if(firstDomNode){
			curNode["comment"]=firstDomNode.comment;
			}
		}
//		二次校验
//		if(!curNode.comment){
//			this.fillInputParamLoop(curDom,dt_store);
//		}
//		如果有注解
		if(curNode.comment) {
			//alert(curNode.nodeName);
//			注解信息
			var commentObject =curNode.comment;
//			存在配置信息的话
			if(commentObject["ekpid"]){
				var cur_ekpid =commentObject["ekpid"];
//				alert(cur_ekpid);
				var ekp_info =this.getEkpidInfo(cur_ekpid)
//				如果是明细表或者是多层结构
				if(ekp_info&&ekp_info.indexList.length>1){
//					自定义表单的情况
					if(ekp_info.indexList.length==2){
					var valueList = GetXFormFieldValueById(ekp_info.indexList[ekp_info.indexList.length-1],true, true);
					var valueInfo={domNode:curDom,nodeInfo:curNode,values:valueList };
					dt_store.push(valueInfo);
					}
					else{
						// todo：目前支持2层结构。。对3层支持
					}
					
				}
//				非明细表
				else if(ekp_info&&ekp_info.indexList.length==1){
//					alert(ekp_info.indexList);
					var fieldValue=GetXFormFieldValueById(ekp_info.indexList[0], true)[0];
				 	curNode.nodeValue=fieldValue;
				 	ERP_parser.setNodeByNodeInfo(curDom,curNode);
//				 	alert(fieldValue);
				}
			}
		}
		this.fillInputParamLoop(curDom,dt_store);
	}
}

/**
 * 表单事件配置,表单事件不支持配置公式，一般只是简单的$a.b.c$
 * 当层级在2级别的时候一般当做表单明细表
 * @param {} ekpid
 * @return {Boolean}
 */
SoapuiFormEvent.prototype.getEkpidInfo=function (ekpid){
	if(!ekpid){
		return null;
	}
	var rtnstr=this.getString(ekpid);
	var ekp_info={};
	var str=rtnstr.split(".");
//	以.分开的数组,方便获取目标表单的值
	ekp_info.indexList=str;
//	保留原来字符串,方便比较
	ekp_info.source=ekpid;
//	如果是明细表,那么可以index来判断当前行数
	ekp_info.index=0;
	
	return ekp_info;
	}	




/**
 * 
 * @param {}
 *            funcId 当前sap映射模板id,(后台SapEkpTempFuncMainAction.generateJspFile
 *            方法自定填充 )
 * @param {}
 *            beforeAction 执行的获取SAP模板之前回调函数 可选
 * @param {}
 *            afterAction 执行的获取SAP模板之后回调函数 可选
 */
function doSOAP(funcId, beforeAction, afterAction) {
	var soapuiFormEvent = new SoapuiFormEvent();
	
	//遮罩全局控制
	//soapuiFormEvent.blockFlag=true;
	//soapuiFormEvent.blockInit();
	
	soapuiFormEvent.getFuncXml(funcId, beforeAction, afterAction);

}
