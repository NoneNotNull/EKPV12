/*压缩类型：标准*/
/***********************************************
JS文件说明：
该文件是JS调用常用的数据访问的一些方法。

KMSSData类说明：
主要用于处理哈希表数组（整体是一个普通的数组，数组的每个元素是一个哈希表）。
比如数据库中的一张表就可以看成是这中数据类型（多行记录，每行记录中，有多个字段，经常会习惯用字段名和第几条记录获取字段值）

作者：叶中奇
版本：1.0 2006-4-3
***********************************************/
Com_RegisterFile("data.js");
Com_IncludeFile("xml.js");

if(window.Data_XMLCatche==null)
	var Data_XMLCatche = new Array();
/***********************************************
功能：KMSSData的构造函数
参数
	kmssdata：可选，通过另一个KMSSData对象初始化当前对象的数据
***********************************************/
function KMSSData(kmssdata){
//=============================以下属性/方法仅供内部使用，普通模块请勿调用==============================
	this.data = kmssdata==null?new Array:kmssdata.data;
	this.unparseNum = 0;
//=============================以下属性/方法仅供内部使用，普通模块请勿调用==============================

	this.IsKMSSData = true;									//用于判断一个对象是否是KMSSData对象
	this.UseCache = true;									//是否采用缓存

	this.IsEmpty = DataFunc_IsEmpty;
	this.AddHashMap = DataFunc_AddHashMap;					//往数据对象中添加一条哈希表记录
	this.AddHashMapArray = DataFunc_AddHashMapArray;		//往数据对象中添加一个哈希表数组
	this.AddBeanData = DataFunc_AddBeanData;				//根据javabean的名字，采用AJAX方式获取数据，并将返回的数据添加到数据对象中
	this.AddXMLData = DataFunc_AddXMLData;					//根据xml的路径，采用AJAX方式获取数据，并将返回的数据添加到数据对象中
	this.AddKMSSData = DataFunc_AddKMSSData;				//将另外一个KMSSData对象的数据合并到当前对象中
	this.AddFromField = DataFunc_AddFromField;				//从表单的域中获取数据，并将结果数据添加到当前对象中
	this.AddXMLContent = DataFunc_AddXMLContent;			//从XML文本中加载数据
	
	this.Clear = DataFunc_Clear;							//清空表中所有数据
	this.Delete = DataFunc_Delete;							//删除表中的记录
	this.Format = DataFunc_Format;							//（转化哈希表的key值）
	this.IndexOf = DataFunc_IndexOf;						//获取索引值
	this.SwitchIndex = DataFunc_SwitchIndex;				//交换两个数据的位置
	this.UniqueTrimByKey = DataFunc_UniqueTrimByKey;		//根据关键字去除重复的记录
	this.Parse = DataFunc_Parse;
	
	this.GetHashMapArray = DataFunc_GetHashMapArray;		//获取哈希表数组
	this.PutToField = DataFunc_PutToField;					//将数据写入到表单的域中
	this.PutToSelect = DataFunc_PutToSelect;				//将数据作为下拉列表框的选项写入
	this.SendToBean = DataFunc_SendToBean;
	this.SendToUrl = DataFunc_SendToUrl;
	
	this.toString = DataFunc_ToString;						//覆盖对象默认的toString方法
}

/***********************************************
功能：采用现有的service构造通用的返回相关列表的beanName参数
参数：
	serviceName：
		必选，service名称
	rtnItem：
		必选，节点取值对应域模型中的字段名，如：fdName:fdId
	orderby：
		可选，排序列，多值用:分隔，为域模型中的字段名，如：forder
返回：beanName参数
***********************************************/
function Data_GetBeanNameFromService(serviceName, rtnItem, orderby){
	var beanName = "XMLGetDataService&service=" + serviceName + "&item=" + rtnItem;
	if(orderby!=null)
		beanName += "&orderby=" + orderby;
	return beanName;
}

function DataFunc_IsEmpty(){
	return this.GetHashMapArray().length==0;
}

/***********************************************
功能：采用现有的service构造通用的返回指定关键字的beanName参数
参数
	serviceName：必选，service的名字
	keyValue：必选，关键字的值，使用,或;分隔多值
	rtnItem：必选，对应域模型的字段，多值用:分隔，如：fdId:fdName
	keyItem：可选，关键字对应域模型字段，默认取fdId
	orderby：可选，排序列，格式同rtnItem
返回：beanName参数
***********************************************/
function Data_GetBeanNameFromServiceByKey(serviceName, keyValue, rtnItem, keyItem, orderby){
	if(keyValue==null || keyValue=="")
		return "";
	var beanName = "XMLGetDataByKeyService&service="+serviceName+"&item="+rtnItem;
	if(keyItem!=null && keyItem!="")
		beanName += "&key=" + keyItem;
	if(orderby!=null && orderby!="")
		orderby += "&key=" + orderby;
	if(keyValue.substring(0,2)!="!{")
		keyValue = encodeURIComponent(keyValue.replace(/;/g, ","));
	beanName += "&value=" + keyValue;
	return beanName;
}

function Data_GetBeanNameOfFindPage(service, rtnItem, pageno, rowsize, where, orderby){
	var beanName = "XMLGetPageService&service="+service+"&item="+rtnItem;
	if(pageno!=null && pageno!="")
		beanName += "&pageno=" + pageno;
	if(rowsize!=null && rowsize!="")
		beanName += "&rowsize=" + rowsize;
	if(where!=null && where!="")
		beanName += "&where=" + where;
	if(orderby!=null && orderby!="")
		beanName += "&orderby=" + orderby;
	return beanName;
}

/***********************************************
功能：随机生成ID
参数
	count：数字，可选，返回的ID数量
返回：
	若count值未传，返回字符串，若count值已经设置，返回数组
***********************************************/
function Data_GetRadomId(count){
	var data = new KMSSData();
	data.AddBeanData("XMLGetRadomIdService"+(count==null?"":"&count="+count));
	var rtnVal = data.GetHashMapArray();
	if(count==null)
		return rtnVal[0].value;
	var arr = new Array();
	for(var i=0; i<rtnVal.length; i++)
		arr[i] = rtnVal[i]["value"];
	return arr;
}

/***********************************************
功能：key值获取资源信息
参数
	keys：必选，多值用;分隔
返回：
	资源信息数组
***********************************************/
function Data_GetResourceString(keys){
	var data = new KMSSData();
	data.AddBeanData("XMLGetResourceService&key="+keys);
	var rtnVal = data.GetHashMapArray();
	if(rtnVal.length==1)
		return rtnVal[0]["key0"];
	var arr = new Array();
	for(var i=0; i<rtnVal.length; i++)
		arr[i] = rtnVal[i]["key0"];
	return arr;
}

/***********************************************
功能：根据关键字在指定的组织架构中查找数据
参数
	keyValue：必选，关键字的值，使用,或;分隔多值
	rtnItem：必选，对应域模型的字段，多值用:分隔，如：fdId:fdName
	keyItem：可选，关键字对应域模型字段，默认取fdId
	orderby：可选，排序列，格式同rtnItem
返回：
***********************************************/
function Data_GetOrgElementBeanNameByKey(keyValue, rtnItem, keyItem, orderby){
	return Data_GetBeanNameFromServiceByKey("sysOrgElementService", keyValue, rtnItem, keyItem, orderby);
}

function Data_GetOrgPersonBeanNameByKey(keyValue, rtnItem, keyItem, orderby){
	return Data_GetBeanNameFromServiceByKey("sysOrgPersonService", keyValue, rtnItem, keyItem, orderby);
}

//=============================以下函数为内部函数，普通模块请勿调用==============================
/***********************************************
功能：交换两个数据的位置
参数：
	i, j：必选，数据的索引号
返回：当前实例
***********************************************/
function DataFunc_SwitchIndex(i, j){
	this.Parse();
	var tmp = this.data[i];
	this.data[i] = this.data[j];
	this.data[j] = tmp;
	return this;
}

/***********************************************
功能：将数据进行格式化（转化哈希表的key值）
参数：
	toKeyList：
		可选，字符串，转换后的哈希表key值，用:分开多值。默认值为"id:name"
	fromKeyList：
		可选，字符串，转换后的哈希表key值，用:分开多值。默认值为"key0:key1[:...]"（跟toKeyList的长度一致），跟XMLBean返回的默认值一致
	isUsePreValue：
		可选，布尔型，若后面的值不存在的时候，是否默认取前面的值。默认值为true
返回：当前实例
样例：
	原值：
		[0]id=1;name=a
		[1]key0=2;key1=b
		[2]key0=3
		[3]info=4
	转换后的值：
		[0]id=1;name=a
		[1]id=2;name=b
		[2]id=3;name=3
		[3]id=null;name=null
***********************************************/
function DataFunc_Format(toKeyList, fromKeyList, isUsePreValue){
	this.Parse();
	var i, j;
	toKeyList = toKeyList==null?new Array("id", "name"):toKeyList.split(":");
	if(fromKeyList==null){
		fromKeyList = new Array;
		for(i=0; i<toKeyList.length; i++)
			fromKeyList[i] = "key"+i;
	}
	isUsePreValue = isUsePreValue==null?true:isUsePreValue;
	for(i=0; i<this.data.length; i++){
		for(j=0; j<fromKeyList.length; j++){
			if(this.data[i][toKeyList[j]]==null){
				if(this.data[i][fromKeyList[j]]==null){
					if(isUsePreValue && j>0)
						this.data[i][toKeyList[j]] = this.data[i][toKeyList[j-1]];
				}else{
					this.data[i][toKeyList[j]] = this.data[i][fromKeyList[j]];
					if(toKeyList[j]!=fromKeyList[j])
						this.data[i][fromKeyList[j]] = null;
				}
			}
		}
	}
	return this;
}

/***********************************************
功能：获取索引值
参数：
	keyName：
		必选，字符串，哈希表的key名
	keyValue：
		必选，需要查找的key值
返回：索引值
***********************************************/
function DataFunc_IndexOf(keyName, keyValue){
	this.Parse();
	for(var i=0; i<this.data.length; i++)
		if(this.data[i][keyName]==keyValue)
			return i;
	return -1;
}

/***********************************************
功能：删除表中的记录
参数：
	index：
		必选，数字，删除记录的起始索引
	count：
		可选，删除记录的个数，默认值为1
返回：当前实例
***********************************************/
function DataFunc_Delete(index, count){
	this.Parse();
	count = count==null?1:count;
	this.data.splice(index,count);
	return this;
}

/***********************************************
功能：根据关键字去除重复的记录
参数：
	keyName：
		必选，字符串，哈希表的key名
返回：当前实例
***********************************************/
function DataFunc_UniqueTrimByKey(keyName, trimKey){
	this.Parse();
	keyName = keyName==null?"id":keyName;
	trimKey = trimKey==null?keyName:trimKey;
	var trimKeys = trimKey.split(":");
	var rtnData = new Array;
	outerfor:
	for(var i=0; i<this.data.length; i++){
		for(var j=0; j<trimKeys.length; j++)
			if(this.data[i][trimKeys[j]]!=null && this.data[i][trimKeys[j]]!="")
				break;
		if(j==trimKeys.length)
			continue;
		for(var j=0; j<rtnData.length; j++)
			if(this.data[i][keyName]==rtnData[j][keyName])
				continue outerfor;
		rtnData[rtnData.length] = this.data[i];
	}
	this.data = rtnData;
	return this;
}

/***********************************************
功能：获取哈希表数组
返回：哈希表数组
***********************************************/
function DataFunc_GetHashMapArray(){
	this.Parse();
	return this.data;
}

/***********************************************
功能：清空表中所有数据
返回：当前实例
***********************************************/
function DataFunc_Clear(){
	if(this.data.length>0)
		this.data = new Array;
	this.unparseNum = 0;
	return this;
}

/***********************************************
功能：往数据对象中添加一条哈希表记录
参数
	hashMap：必选，哈希表数据
返回：当前实例
***********************************************/
function DataFunc_AddHashMap(hashMap){
	this.data[this.data.length] = hashMap;
	return this;
}

/***********************************************
功能：往数据对象中添加一个哈希表数组
参数
	hashMapArray：必选，哈希表数组
返回：当前实例
***********************************************/
function DataFunc_AddHashMapArray(hashMapArray){
	this.data = this.data.concat(hashMapArray);
	return this;
}

/***********************************************
功能：根据javabean的名字，采用AJAX方式获取数据，并将返回的数据添加到数据对象中
参数
	beanName：必选，javabean的名字
返回：当前实例
***********************************************/
function DataFunc_AddBeanData(beanName){
	return this.AddXMLData(XMLDATABEANURL+beanName);
}

/***********************************************
功能：根据xml的路径，采用AJAX方式获取数据，并将返回的数据添加到数据对象中
参数
	beanURL：必选，XML访问路径
返回：当前实例
***********************************************/
function DataFunc_AddXMLData(beanURL){
	this.unparseNum++;
	this.data[this.data.length] = beanURL;
	return this;
}

/***********************************************
功能：将另外一个KMSSData对象的数据合并到当前对象中
参数
	kmssdata：必选，KMSSData对象
返回：当前实例
***********************************************/
function DataFunc_AddKMSSData(kmssdata){
	this.unparseNum += kmssdata.unparseNum;
	this.data = this.data.concat(kmssdata.data);
	return this;
}

/***********************************************
功能：从表单的域中获取数据，并将结果数据添加到当前对象中
参数：
	itemList：
		必选，字符串，对应哈希表的key值，用:分开多个key
	fieldList：
		必选，数据类型可以为：
			字符串，对应的域的名字，用:分开多个key，个数必须与itemList一致
			域对象一维数组，个数必须与itemList一致
			域对象二维数组，第一个维度个数必须与itemList一致，第二个维度表示第几条记录
	splitStr：
		可选，数据多值分隔符号，不传值或为null则认为每个域中仅有一条数据
	isMulField：
		可选，当fieldList为字符串时有用，标记是否获取所有同名的域的值，默认值为false
返回：当前实例
***********************************************/
function DataFunc_AddFromField(itemList, fieldList, splitStr, isMulField){
	var i,j, k, n, valueList, fieldLen;
	itemList = itemList.split(":");
	if(typeof(fieldList)=="string"){
		fieldList = fieldList.split(":");
		for(i=0; i<fieldList.length; i++){
			fieldList[i] = document.getElementsByName(fieldList[i]);
			if(!isMulField)
				fieldList[i] = fieldList[i][0];
		}
	}
	fieldLen = isMulField?fieldList[0].length:1;
	var rtnData = new Array;
	for(i=0; i<fieldLen; i++){
		if(splitStr==null){
			n = rtnData.length;
			rtnData[n] = new Array;
			for(j=0; j<itemList.length; j++)
				rtnData[n][itemList[j]] = (isMulField?fieldList[j][i]:fieldList[j]).value;
		}else{
			valueList = new Array;
			for(j=0; j<itemList.length; j++)
				valueList[j] = (isMulField?fieldList[j][i]:fieldList[j]).value.split(splitStr);
			for(k=0; k<valueList[0].length; k++){
				n = rtnData.length;
				rtnData[n] = new Array;
				for(j=0; j<itemList.length; j++)
					rtnData[n][itemList[j]] = valueList[j][k];
			}
		}
	}
	this.AddHashMapArray(rtnData);
	return this;
}

function DataFunc_AddXMLContent(xmlContent){
	var rtnVal = DataFunc_GetDataByXML(XML_CreateByContent(xmlContent));
	this.data = this.data.concat(rtnVal);
	return this;
}

/***********************************************
功能：将数据写入到表单的域中
参数：同AddFromField
返回：当前实例
***********************************************/
function DataFunc_PutToField(itemList, fieldList, splitStr, isMulField){
	this.Parse();
	var i, j, value;
	itemList = itemList.split(":");
	if(typeof(fieldList)=="string"){
		fieldList = fieldList.split(":");
		for(i=0; i<fieldList.length; i++){
			fieldList[i] = document.getElementsByName(fieldList[i]);
			if(!isMulField)
				fieldList[i] = fieldList[i][0];
		}
	}
	for(i=0; i<fieldList.length; i++)
		if(isMulField){
			for(j=0; j<fieldList[i].length; j++)
				fieldList[i][j].value = "";
		}else{
			fieldList[i].value = "";
		}
	
	if(!isMulField && splitStr==null)
		splitStr = ";";
	for(i=0; i<this.data.length; i++){
		for(j=0; j<itemList.length; j++){
			value = this.data[i][itemList[j]]==null?"":this.data[i][itemList[j]];
			if(isMulField){
				if(fieldList[j][i]!=null)
					fieldList[j][i].value = value;
			}else{
				fieldList[j].value = i==0?value:(fieldList[j].value + splitStr + value);
			}
		}
	}
	return this;
}

/***********************************************
功能：将数据作为下拉列表框的选项写入
参数：
	fieldName：
		必选，下拉列表框，数据类型可以为：
			字符串：下拉列表框的名字
			对象：下拉列表框对象
	valueKey：
		必选，字符串，下拉列表框的值对应哈希表的key名。
	nameKey：
		可选，字符串，下拉列表框的显示文本对应哈希表的key名。默认值为valueKey。
	value：
		可选，字符串，下拉列表的默认值
返回：当前实例
***********************************************/
function DataFunc_PutToSelect(fieldName, valueKey, nameKey, value){
	this.Parse();
	if(nameKey==null)
		nameKey = valueKey;
	this.UniqueTrimByKey(valueKey, valueKey+":"+nameKey);
	var obj = typeof(fieldName)=="string"?document.getElementsByName(fieldName)[0]:fieldName;
	var selectedIndex = -1;
	for(var i=0;i<this.data.length;i++){
		if(value==this.data[i][valueKey])
			selectedIndex = i;
		obj.options[i] = new Option(this.data[i][nameKey], this.data[i][valueKey]);
	}
	for(;i<obj.options.length;)
		obj.options[i] = null;
	if(selectedIndex>-1)
		obj.selectedIndex = selectedIndex;
	return this;
}

/***********************************************
功能：将数据对象中XML数据对象部分进行解释
返回：当前实例
***********************************************/
function DataFunc_Parse(asyncFunction){
	if(this.unparseNum>0){
		for(var i=this.data.length-1; i>=0; i--){
			if(typeof(this.data[i])=="string"){
				var rtnVal = null;
				if(this.UseCache)
					rtnVal = Data_XMLCatche[this.data[i]];
				if(rtnVal==null){
					if(asyncFunction==null){
						rtnVal = DataFunc_GetDataByXML(XML_Create(this.data[i]));
						Data_XMLCatche[this.data[i]] = rtnVal;
					}else{
						var param = new Object();
						param.url = this.data[i];
						param.kmssdata = this;
						param.asyncFunction = asyncFunction;
						XML_Create(this.data[i], DataFunc_XMLAsyncFunction, param);
						continue;
					}
				}
				var leftData = this.data.slice(0, i);
				var rightData = this.data.slice(i+1);
				this.data = leftData.concat(rtnVal, rightData);
				this.unparseNum--;
			}
		}
	}
	return this;
}

function DataFunc_XMLAsyncFunction(xml, parameter){
	var url = parameter.url;
	var kmssdata = parameter.kmssdata;
	var rtnVal = DataFunc_GetDataByXML(xml);
	Data_XMLCatche[url] = rtnVal;
	for(var i=0; i<kmssdata.data.length; i++){
		if(kmssdata.data[i] == url){
			break;
		}
	}
	var leftData = kmssdata.data.slice(0, i);
	var rightData = kmssdata.data.slice(i+1);
	kmssdata.data = leftData.concat(rtnVal, rightData);
	kmssdata.unparseNum--;
	if(kmssdata.unparseNum==0){
		parameter.asyncFunction(kmssdata);
	}
}

function DataFunc_GetDataByXML(xml, path){
	var nodes = XML_GetNodesByPath(xml, path || "/dataList/data");
	var rtnVal = new Array;
	for(var i=0; i<nodes.length; i++){
		rtnVal[i] = new Array;
		var attNodes = nodes[i].attributes;
		for(var j=0; j<attNodes.length; j++)
			rtnVal[i][attNodes[j].nodeName] = attNodes[j].nodeValue;
	}
	return rtnVal;
}

function DataFunc_SendToUrl(url, action, synch){
	var http_request = null;
	var synchFlag = true;
	if(synch != null){
		synchFlag = synch;
	}
	
	if (window.XMLHttpRequest) {
		http_request = new XMLHttpRequest();
		if (http_request.overrideMimeType)
			http_request.overrideMimeType('text/xml');
	} else if (window.ActiveXObject) {
		var requestArray = ["Msxml2.XMLHTTP", "Microsoft.XMLHTTP"];
		for (var i = requestArray.length - 1; http_request == null && i >= 0; i--) {
			try	{
				http_request = new ActiveXObject(requestArray[i]);
			} catch (e) {
				//
			}
		}
	}
	if (http_request==null)
		return false;
	
	http_request.onreadystatechange = function(){
		if (http_request.readyState == 4) {
			if (http_request.status == 200) {
				action(http_request);
			} else {
				return false;
			}
		}
	}
	
	//将参数部分截取过来，避免过长的参数直接放url里通过get方式传递 modify by limh 2010年11月3日
	var index = url.search(/[&?]/);
	if(index > 0){
		var param = url.substr(index);
		url = url.substring(0,index);
	}
	http_request.open("POST", url, synchFlag);
	http_request.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
	var content = "";
	//将截取的参数加到send的body里去传递 modify by limh 2010年11月3日
	content += param;
	this.Parse();
	for(var i=0; i<this.data.length; i++)
		for(var o in this.data[i])
			content += "&"+o+"="+encodeURIComponent(this.data[i][o]);	
	http_request.send(content.substring(1));
	return true;
}

function DataFunc_SendToBean(beanName, action){
	this.SendToUrl(
		XMLDATABEANURL+beanName,
		function(http_request){
			var nodes = XML_GetNodesByPath(http_request.responseXML, "/dataList/data");
			rtnVal = new Array;
			for(var i=0; i<nodes.length; i++){
				rtnVal[i] = new Array;
				var attNodes = nodes[i].attributes;
				for(var j=0; j<attNodes.length; j++)
					rtnVal[i][attNodes[j].nodeName] = attNodes[j].nodeValue;
			}
			var rtnData = new KMSSData();
			rtnData.AddHashMapArray(rtnVal);
			action(rtnData);
		}
	);
}

/***********************************************
功能：覆盖对象默认的toString方法
返回：字符串
***********************************************/
function DataFunc_ToString(){
	var rtnVal = "";
	for(var i=0; i<this.data.length; i++){
		rtnVal += i+": ";
		for(var o in this.data[i])
			rtnVal += o+"="+this.data[i][o]+"; ";
		rtnVal += "\r\n";
	}
	return rtnVal;
}
//=============================以上函数为内部函数，普通模块请勿调用==============================