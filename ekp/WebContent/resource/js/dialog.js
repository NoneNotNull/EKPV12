/*压缩类型：标准*/
/***********************************************
JS文件说明：
该文件提供了通用的对话框的操作函数

作者：叶中奇
版本：1.0 2006-4-3
***********************************************/
Com_RegisterFile("dialog.js");
Com_IncludeFile("treeview.js");

var Dialog_AddressInfo;

/***********************************************
功能：KMSSDialog的构造函数
参数：
	mulSelect：
		可选，true多选，false单选，默认值为单选
	showOption：
		可选，true显示选择列表框，false，仅显示目录树部分，默认值为true
***********************************************/
function KMSSDialog(mulSelect, showOption){
//=============================以下属性/方法仅供内部使用，普通模块请勿调用==============================
	this.mulSelect = mulSelect;
	this.notNull = false;
	this.winTitle = null;
	this.showOption = showOption==null?true:showOption;
	this.itemList = null;
	this.fieldList = null;
	this.fieldSplit = null;
	this.isMulField = null;
	this.tree = null;
	this.URL = Com_Parameter.ResPath + "html/dialog.html";
	this.searchBeanURL = null;
	this.valueData = new KMSSData();
	this.optionData = new KMSSData();
	this.rtnData = null;
	this.AfterShowAction = null;
	this.AfterShow = DialogFunc_AfterShow;
	this.XMLDebug = Com_Parameter.XMLDebug;
	this.Lang = Com_Parameter.Lang;
//=============================以上属性/方法仅供内部使用，普通模块请勿调用==============================

	this.BindingField = DialogFunc_BindingField;							//将对话框数据与域绑定
	this.CreateTree = DialogFunc_CreateTree;								//创建一棵目录树，并返回树的根节点
	this.AddDefaultValue = DialogFunc_AddDefaultValue;						//往对话框的已选列表中添加数据
	this.AddDefaultOption = DialogFunc_AddDefaultOption;					//往对话框的备选列表中添加数据
	this.AddDefaultOptionBeanData = DialogFunc_AddDefaultOptionBeanData;	//通过javabean的方式获取数据，并添加到对话框的备选列表中
	this.AddDefaultOptionXMLData = DialogFunc_AddDefaultOptionXMLData;		//通过XML的方式获取数据，往对话框的备选列表中添加数据
	this.SetSearchBeanData = DialogFunc_SetSearchBeanData;					//设置用于数据搜索的javabean名称
	this.SetSearchXMLData = DialogFunc_SetSearchXMLData;					//设置用于数据搜索的XML的URL路径
	this.SetAfterShow = DialogFunc_SetAfterShow;							//设置对话框执行完毕后需要执行的代码
	this.Show = DialogFunc_Show;											//弹出对话框
	this.XMLCatche = Data_XMLCatche;										//对话框信息缓存
}
/***********************************************
功能：类别选择对话框
参数：
	modelName：
		必选，域模型名称，如果没有值则取当前URL参数modelName
	idField：
		可选，绑定关键字的域名字或对象或对象列表
	nameField：
		可选，绑定显示名的域名字或对象或对象列表
	mulSelect：
		可选，true多选，false单选，默认值为单选	
	authType:
		可选,默认02,权限校验方式,0显示所有(00可以选中所有,01只能选中有维护权限的,02只能选中有使用权限的),1 只显示有维护权限的 2 只显示有使用权限的	
	showType:
		可选,显示方式,0显示子场所分类,只1显示父场所分类,2只显示父场所分类和子场所分类
	orgTreeId:
		可选,当前组织机构树ID	
	action：
		可选，函数对象，当对话框关闭后需要执行的操作，样例：
//			function MyAction(rtnVal){
				//在此写入您的代码，采用rtnVal可用获取返回值，该值为KMSSData对象，采用this可用访问到对话框对象
			}
			将MyAction传递给action参数
	notNull：
		可选，true（默认）表示可以为空
	exceptValue:
		见Dialog_Tree说明
	winTitle：
		可选，窗口的标题
***********************************************/
function Dialog_Category(modelName, idField, nameField,mulSelect,authType,showType,areaId,action,notNull,exceptValue,winTitle){
	if(modelName==null || modelName=="") {
		modelName = Com_GetUrlParameter(location.href,"fdModelName");
		if(modelName==null) return false;
	}
	if(idField==null) idField = 'fdParentId';
	if(nameField==null) nameField = 'fdParentName';
	if(mulSelect==null) mulSelect = false;
	if(authType==null) authType = "02";
	if(showType==null) showType = "0";
	var keys = "sys-category:dialog.maintree.title;sys-category:dialog.main.title";
	var arr = Data_GetResourceString(keys);
	var treeTitle = arr[0];
	if(winTitle==null) winTitle = arr[1];	
	Dialog_Tree(mulSelect, idField, nameField, null, 'sysCategoryTreeService&showType=' + showType + '&authType=' + authType + (areaId!=null&&areaId!=""?("&orgId="+ areaId):"") + '&modelName=' + modelName + '&categoryId=!{value}', treeTitle, null,action, exceptValue, null, notNull, winTitle);
}
/***********************************************
功能：组织机构选择对话框
参数：
	idField：
		可选，绑定关键字的域名字或对象或对象列表
	nameField：
		可选，绑定显示名的域名字或对象或对象列表
	mulSelect：
		可选，true多选，false单选，默认值为单选	
	authType:
		可选,对节点的验证权限,0显示所有(00可以选中所有,01只能选中有维护权限的,02只能选中有使用权限的),1 只显示有维护权限的 2 只显示有使用权限的
	action：
		可选，函数对象，当对话框关闭后需要执行的操作，样例：
//			function MyAction(rtnVal){
				//在此写入您的代码，采用rtnVal可用获取返回值，该值为KMSSData对象，采用this可用访问到对话框对象
			}
			将MyAction传递给action参数
	notNull：
		可选，true（默认）表示可以为空
	exceptValue:
		见Dialog_Tree说明
	winTitle：
		可选，窗口的标题
***********************************************/
function Dialog_OrgTree(idField, nameField,mulSelect,authType,action,notNull,exceptValue,winTitle){
	if(idField==null) idField = 'fdOrgTreeId';
	if(nameField==null) nameField = 'fdOrgTreeName';
	if(mulSelect==null) mulSelect = false;
	if(authType==null) authType = "02";
	var keys = "sys-category:dialog.orgtree.title;sys-category:dialog.org.title";
	var arr = Data_GetResourceString(keys);
	var treeTitle = arr[0];
	if(winTitle==null) winTitle = arr[1];	
	Dialog_Tree(mulSelect, idField, nameField, null, 'sysCategoryOrgTreeTreeService&authType=' + authType +  '&categoryId=!{value}', treeTitle, null,action, exceptValue, null, notNull, winTitle);
}
/***********************************************
功能：模板选择对话框
参数：
	modelName：
		必选，域模型名称，如果没有值则取当前URL参数modelName
	urlParam：
		必选，创建的url，其中id参数用参数!{id},显示名参数用!{name} 如果需要自动返回域值，请按格式调用："ID域名::Name域名"
	mulSelect：
		可选，true多选，false单选，默认值为单选	
	isReturn:
		可选，是返回urlParam还是直接打开urlParam链接，默认为false，直接打开urlParam链接
	authType:
		可选,默认02,权限校验方式,0显示所有(00可以选中所有,01只能选中有维护权限的,02只能选中有使用权限的),1 只显示有维护权限的 2 只显示有使用权限的	
	action：
		可选，函数对象，当对话框关闭后需要执行的操作，样例：
			function MyAction(rtnVal){
				//在此写入您的代码，采用rtnVal可用获取返回值，该值为KMSSData对象，采用this可用访问到对话框对象
			}
			将MyAction传递给action参数
	notNull：
		可选，false（默认）表示不可以为空
	winTitle：
		可选，窗口的标题
***********************************************/
function Dialog_Template(modelName, urlParam,mulSelect,isReturn,authType,action,notNull,winTitle){
	if(modelName==null || modelName=="") modelName = Com_GetUrlParameter(location.href,"modelName");
	if(notNull==null) notNull = true;
	if(isReturn==null) isReturn = false;
	if(mulSelect==null) mulSelect = false;
	if(authType==null) authType = "02";
	var idObj, nameObj;
	var result = null;

	var dialogObject = [];
	dialogObject.BindingField = DialogFunc_BindingField;
	dialogObject.BAfterShow = DialogFunc_AfterShow;
	if(isReturn) {
		var i = urlParam.indexOf("::");
		if(i>0) {
			var idField = urlParam.substring(0,i);			
			var nameField = urlParam.substring(i+2);
			dialogObject.valueData = new KMSSData();
			dialogObject.BindingField(idField,nameField);
		}
	}	

	dialogObject.AfterShow = function() {
		if(this.rtnData!=null) {
			var theUrl = Com_ReplaceParameter(urlParam,this.rtnData[0]);
			if(action!=null) action(this.rtnData);
			if(isReturn) {
				if(this.itemList==null) {
					result = theUrl;				
				}else{
					result = this.BAfterShow();
				}
			}else Com_OpenWindow(theUrl, "_blank");
		}
	}	

	Com_EventPreventDefault();
	dialogObject.XMLDebug = Com_Parameter.XMLDebug;
	dialogObject.modelName = modelName;
	dialogObject.notNull = notNull;
	dialogObject.winTitle = winTitle;
	dialogObject.mulSelect = mulSelect;
	dialogObject.authType = authType;

	var url =  Com_Parameter.ResPath + "jsp/categorydialog_main.jsp" + "?s_css="+Com_Parameter.Style;
	width = 400;
	height = 480;
	var left = (screen.width-width)/2;
	var top = (screen.height-height)/2;
	if(window.showModalDialog){
		var winStyle = "resizable:1;scroll:1;dialogwidth:"+width+"px;dialogheight:"+height+"px;dialogleft:"+left+";dialogtop:"+top;
		window.showModalDialog(url, dialogObject, winStyle);
	}else{
		var winStyle = "resizable=1,scrollbars=1,width="+width+",height="+height+",left="+left+",top="+top+",dependent=yes,alwaysRaised=1";
		Com_Parameter.Dialog = dialogObject;
		window.open(url, "_blank", winStyle);
	}
	return result;
}

/***********************************************
功能：简单类别选择对话框
参数：
	modelName：
		必选，域模型名称，如果没有值则取当前URL参数modelName
	mulSelect：
		必选，true多选，false单选，默认值为多选
	idField：
		可选，绑定关键字的域名字或对象或对象列表
	nameField：
		可选，绑定显示名的域名字或对象或对象列表
	splitStr：
		可选，字符串，值分隔符，若需要将多个值放置在一个域中，该项不能为null
	authType:
		可选,默认02,权限校验方式,0显示所有(00可以选中所有,01只能选中有维护权限的,02只能选中有使用权限的),1 只显示有维护权限的 2 只显示有使用权限的	
	action：
		可选，函数对象，当对话框关闭后需要执行的操作，样例：
			function MyAction(rtnVal){
				//在此写入您的代码，采用rtnVal可用获取返回值，该值为KMSSData对象，采用this可用访问到对话框对象
			}
			将MyAction传递给action参数
	notNull：
		可选，true（默认）表示可以为空
	exceptValue:
		见Dialog_Tree说明
	winTitle：
		可选，窗口的标题	
	extProps :
		可选，其他参数判断，多个值以;号隔开 例如：extProps=fdTemplateType:1;fdTemplateType:3
说明：
	add by wubing
	date：2009-07-27			
***********************************************/
function Dialog_SimpleCategory(modelName,idField,nameField,mulSelect,splitStr,authType,action,notNull,exceptValue,winTitle,extProps){
	if(modelName==null || modelName=="") {
		modelName = Com_GetUrlParameter(location.href,"fdModelName");
		if(modelName==null) return false;
	}
	if(idField==null) idField = 'fdParentId';
	if(nameField==null) nameField = 'fdParentName';
	if(mulSelect==null) mulSelect = false;
	if(authType==null) authType = "02";
	var keys = "sys-simplecategory:dialog.maintree.title;sys-simplecategory:dialog.main.title";
	var arr = Data_GetResourceString(keys);
	var treeTitle = arr[0];
	if(winTitle==null) winTitle = arr[1];
	var url = 'sysSimpleCategoryTreeService&authType=' + authType + '&categoryId=!{value}';
	url+='&modelName=' + modelName + '&extProps=' + extProps;
	Dialog_Tree(mulSelect, idField, nameField, splitStr,url, treeTitle,null, action, exceptValue, null, notNull, winTitle,extProps);
}

/***********************************************
功能：新建文档时，简单分类选择对话框
参数：
	modelName：
		必选，域模型名称，如果没有值则取当前URL参数modelName
	urlParam：
		必选，创建的url，其中id参数用参数!{id},显示名参数用!{name} 如果需要自动返回域值，请按格式调用："ID域名::Name域名"
	mulSelect：
		可选，true多选，false单选，默认值为单选	
	isReturn:
		可选，是返回urlParam还是直接打开urlParam链接，默认为false，直接打开urlParam链接
	authType:
		可选,默认02,权限校验方式,0显示所有(00可以选中所有,01只能选中有维护权限的,02只能选中有使用权限的),1 只显示有维护权限的 2 只显示有使用权限的	
	action：
		可选，函数对象，当对话框关闭后需要执行的操作，样例：
			function MyAction(rtnVal){
				//在此写入您的代码，采用rtnVal可用获取返回值，该值为KMSSData对象，采用this可用访问到对话框对象
			}
			将MyAction传递给action参数
	notNull：
		可选，false（默认）表示不可以为空
	winTitle：
		可选，窗口的标题
add by wubing date:2009-07-30
***********************************************/
function Dialog_SimpleCategoryForNewFile(modelName, urlParam,mulSelect,isReturn,authType,action,notNull,winTitle){
	if(modelName==null || modelName=="") modelName = Com_GetUrlParameter(location.href,"modelName");
	if(notNull==null) notNull = true;
	if(isReturn==null) isReturn = false;
	if(mulSelect==null) mulSelect = false;
	if(authType==null) authType = "02";
	var idObj, nameObj;
	var result = null;

	var dialogObject = [];
	dialogObject.BindingField = DialogFunc_BindingField;
	dialogObject.BAfterShow = DialogFunc_AfterShow;
	if(isReturn) {
		var i = urlParam.indexOf("::");
		if(i>0) {
			var idField = urlParam.substring(0,i);			
			var nameField = urlParam.substring(i+2);
			dialogObject.valueData = new KMSSData();
			dialogObject.BindingField(idField,nameField);
		}
	}	

	dialogObject.AfterShow = function() {
		if(this.rtnData!=null) {
			var theUrl = Com_ReplaceParameter(urlParam,this.rtnData[0]);
			if(action!=null) action(this.rtnData);
			if(isReturn) {
				if(this.itemList==null) {
					result = theUrl;				
				}else{
					result = this.BAfterShow();
				}
			}else Com_OpenWindow(theUrl, "_blank");
		}
	}	

	Com_EventPreventDefault();
	dialogObject.XMLDebug = Com_Parameter.XMLDebug;
	dialogObject.modelName = modelName;
	dialogObject.notNull = notNull;
	dialogObject.winTitle = winTitle;
	dialogObject.mulSelect = mulSelect;
	dialogObject.authType = authType;

	var url =  Com_Parameter.ResPath + "jsp/simplecategorydialog_main.jsp" + "?s_css="+Com_Parameter.Style;
	width = 400;
	height = 480;
	var left = (screen.width-width)/2;
	var top = (screen.height-height)/2;
	if(window.showModalDialog){
		var winStyle = "resizable:1;scroll:1;dialogwidth:"+width+"px;dialogheight:"+height+"px;dialogleft:"+left+";dialogtop:"+top;
		window.showModalDialog(url, dialogObject, winStyle);
	}else{
		var winStyle = "resizable=1,scrollbars=1,width="+width+",height="+height+",left="+left+",top="+top+",dependent=yes,alwaysRaised=1";
		Com_Parameter.Dialog = dialogObject;
		window.open(url, "_blank", winStyle);
	}
	return result;
}

/***********************************************
功能：辅类别选择对话框
参数：
	mulSelect：
		必选，true多选，false单选，默认值为多选
	idField：
		可选，绑定关键字的域名字或对象或对象列表
	nameField：
		可选，绑定显示名的域名字或对象或对象列表
	splitStr：
		可选，字符串，值分隔符，若需要将多个值放置在一个域中，该项不能为null
	authType:
		可选,默认02,权限校验方式,0显示所有(00可以选中所有,01只能选中有维护权限的,02只能选中有使用权限的),1 只显示有维护权限的 2 只显示有使用权限的	
	action：
		可选，函数对象，当对话框关闭后需要执行的操作，样例：
			function MyAction(rtnVal){
				//在此写入您的代码，采用rtnVal可用获取返回值，该值为KMSSData对象，采用this可用访问到对话框对象
			}
			将MyAction传递给action参数
	notNull：
		可选，true（默认）表示可以为空
	exceptValue:
		见Dialog_Tree说明
	winTitle：
		可选，窗口的标题				
***********************************************/
function Dialog_property(mulSelect, idField, nameField,splitStr,authType,action,notNull,exceptValue,winTitle){
	if(mulSelect==null) mulSelect = true;
	if(idField==null) idField = 'docPropertyIds';
	if(nameField==null) nameField = 'docPropertyNames';
	if(authType==null) authType = "02";
	var keys = "sys-category:dialog.propertytree.title;sys-category:dialog.property.title";
	var arr = Data_GetResourceString(keys);
	var treeTitle = arr[0];
	if(winTitle==null) winTitle = arr[1];
	Dialog_Tree(mulSelect, idField, nameField, splitStr, 'sysCategoryPropertyTreeService&authType=' + authType + '&categoryId=!{value}', treeTitle,null, action, exceptValue, null, notNull, winTitle);
}
/***********************************************
功能：地址本对话框
参数：
	mulSelect：
		必选，true多选，false单选，默认值为单选
	idField：
		可选，绑定关键字的域名字或对象或对象列表
	nameField：
		可选，绑定显示名的域名字或对象或对象列表
	splitStr：
		可选，字符串，值分隔符，若需要将多个值放置在一个域中，该项不能为null
	selectType：
		可选，可取的值见以“ORG_”开始的常量部分（用|进行组合）
		默认值：ORG_TYPE_ALL
	action：
		可选，函数对象，当对话框关闭后需要执行的操作，样例：
			function MyAction(rtnVal){
				//在此写入您的代码，采用rtnVal可用获取返回值，该值为KMSSData对象，采用this可用访问到对话框对象
			}
			将MyAction传递给action参数
	treeAutoSelChildren：
		可选，true表示当选中目录树的父节点时，是否自动选中子节点，仅多选时可用，默认值为false
	startWith：
		可选，字符串，组织架构起始节点记录ID
	isMulField：
		可选，布尔型，当idField/nameField以字符串形式传递时有效，标记是否获取所有同名的域的值，默认值为false
	notNull：
		可选，true（默认）表示可以为空
	winTitle：
		可选，窗口的标题
	treeTitle：
		可选，当设置了startWith后，跟节点的名称
	exceptValue：
***********************************************/
function Dialog_Address(mulSelect, idField, nameField, splitStr, selectType, action, startWith, isMulField, notNull, winTitle, treeTitle, exceptValue){
	var dialog = new KMSSDialog(mulSelect);
	dialog.winTitle = winTitle;
	dialog.treeTitle = treeTitle;
	dialog.addressBookParameter = new Array();
	
	if(selectType==null || selectType==0)
		selectType = ORG_TYPE_ALL;
	dialog.addressBookParameter.exceptValue = exceptValue;
	dialog.addressBookParameter.selectType = selectType;
	dialog.addressBookParameter.startWith = startWith;
	dialog.BindingField(idField, nameField, splitStr, isMulField);
	dialog.SetAfterShow(action);
	if(notNull!=null)
		dialog.notNull = notNull;
	dialog.URL = Com_Parameter.ResPath + "jsp/address_main.jsp";
	dialog.Show(640, 480);
}

function Dialog_HrAddress(mulSelect, idField, nameField, splitStr, selectType, action, treeAutoSelChildren, startWith, isMulField, notNull, winTitle){
	if(Dialog_AddressInfo==null)
		Dialog_AddressInfo = Data_GetResourceString("hr-organization:hrOrganization.addressBook;hr-organization:hrOrganization.moduleName;hr-organization:hrOrg_group");
	if(selectType==null || selectType==0)
		selectType = ORG_TYPE_ALL;
	var para = "hrOrganizationDialogList&parent=!{value}&orgType="+selectType;
	var dialog = new KMSSDialog(mulSelect);
	dialog.winTitle = winTitle==null?Dialog_AddressInfo[0]:winTitle;
	var n1 = dialog.CreateTree(Dialog_AddressInfo[0]);
	var n2 = n1.AppendChild(Dialog_AddressInfo[1], para);
	var treeOrgType = selectType;
	if ((treeOrgType & ORG_TYPE_ALL) != ORG_TYPE_ORG)
		treeOrgType = treeOrgType & ~ORG_TYPE_ALL | ORG_TYPE_ORGORDEPT;
	n2.AppendHrOrgData(treeOrgType, para, null, startWith);
	if((selectType & ORG_TYPE_GROUP) == ORG_TYPE_GROUP){
		n2 = n1.AppendChild(Dialog_AddressInfo[2], "hrOrganizationDialogGroupList&groupCate=!{value}");
		n2.AppendBeanData(Tree_GetBeanNameFromService('hrOrgGroupcateService', 'hbmParent', 'fdName:fdId'),"hrOrganizationDialogGroupList&groupCate=!{value}");
	}
	dialog.tree.isAutoSelectChildren = treeAutoSelChildren;
	dialog.BindingField(idField, nameField, splitStr, isMulField);
	dialog.SetAfterShow(action);
	dialog.SetSearchBeanData("hrOrganizationDialogSearch&key=!{keyword}&orgType="+selectType+(startWith==null?"":"&startWith="+startWith));
	if(notNull!=null)
		dialog.notNull = notNull;
	dialog.Show();
}

function Dialog_KmAddress(mulSelect, idField, nameField, splitStr, selectType, action, treeAutoSelChildren, startWith, isMulField, notNull, winTitle){
	if(Dialog_AddressInfo==null)
		Dialog_AddressInfo = Data_GetResourceString("km-resinfo:kmOrganization.addressBook;km-resinfo:kmOrganization.moduleName");
	if(selectType==null || selectType==0)
		selectType = ORG_TYPE_ALL;
	var para = "kmResinfoOrgDialogList&parent=!{value}&orgType="+selectType;
	var dialog = new KMSSDialog(mulSelect);
	dialog.winTitle = winTitle==null?Dialog_AddressInfo[0]:winTitle;
	var n1 = dialog.CreateTree(Dialog_AddressInfo[0]);
	var n2 = n1.AppendChild(Dialog_AddressInfo[1], para);
	var treeOrgType = selectType;
	if ((treeOrgType & ORG_TYPE_ALL) != ORG_TYPE_ORG)
		treeOrgType = treeOrgType & ~ORG_TYPE_ALL | ORG_TYPE_ORGORDEPT;
	n2.AppendKmOrgData(treeOrgType, para, null, startWith);	
	dialog.tree.isAutoSelectChildren = treeAutoSelChildren;
	dialog.BindingField(idField, nameField, splitStr, isMulField);
	dialog.SetAfterShow(action);
	dialog.SetSearchBeanData("kmResinfoOrgDialogSearch&key=!{keyword}&orgType="+selectType+(startWith==null?"":"&startWith="+startWith));
	if(notNull!=null)
		dialog.notNull = notNull;
	dialog.Show();
}

/***********************************************
功能：树对话框的简单调用
参数：
	mulSelect：
		必选，true多选，false单选，默认值为单选
	idField：
		可选，绑定关键字的域名字或对象或对象列表
	nameField：
		可选，绑定显示名的域名字或对象或对象列表
	splitStr：
		可选，字符串，值分隔符，若需要将多个值放置在一个域中，该项不能为null
	treeBean：
		必选，字符串，目录树获取数据的bean名字
		treeBean中可以采用参数替换的方式指定，参数格式为：!{节点属性名}，如：
		节点node.value=123
		原给定的treeBean：beanName&para=!{value}
		实际使用的treeBean：beanName&para=123
	treeTitle：
		必选，字符串，目录树的跟节点显示内容
	treeAutoSelChildren：
		可选，true表示当选中目录树的父节点时，是否自动选中子节点，仅多选时可用，默认值为false
	action：
		可选，函数对象，当对话框关闭后需要执行的操作，样例：
			function MyAction(rtnVal){
				//在此写入您的代码，采用rtnVal可用获取返回值，该值为KMSSData对象，采用this可用访问到对话框对象
			}
			将MyAction传递给action参数
	exceptValue：
		可选，目录树中不期望出现的关键字，为字符串或字符串数组
	isMulField：
		可选，布尔型，当idField/nameField以字符串形式传递时有效，标记是否获取所有同名的域的值，默认值为false
	notNull：
		可选，true（默认）表示可以为空
***********************************************/
function Dialog_Tree(mulSelect, idField, nameField, splitStr, treeBean, treeTitle, treeAutoSelChildren, action, exceptValue, isMulField, notNull, winTitle){
	var dialog = new KMSSDialog(mulSelect, false);
	var node = dialog.CreateTree(treeTitle);
	dialog.winTitle = winTitle==null?treeTitle:winTitle;
	node.AppendBeanData(treeBean, null, null, null, exceptValue);
	dialog.tree.isAutoSelectChildren = treeAutoSelChildren;
	dialog.BindingField(idField, nameField, splitStr, isMulField);
	dialog.SetAfterShow(action);
	if(notNull!=null)
		dialog.notNull = notNull;
	dialog.Show();
}

/***********************************************
功能：列表对话框的简单调用
参数：
	mulSelect：
		必选，true多选，false单选，默认值为单选
	idField：
		可选，绑定关键字的域名字或对象或对象列表
	nameField：
		可选，绑定显示名的域名字或对象或对象列表
	splitStr：
		可选，字符串，值分隔符，若需要将多个值放置在一个域中，该项不能为null
	dataBean：
		必选，字符串，备选列表获取数据的bean名字
	action：
		可选，函数对象，当对话框关闭后需要执行的操作，样例：
			function MyAction(rtnVal){
				//在此写入您的代码，采用rtnVal可用获取返回值，该值为KMSSData对象，采用this可用访问到对话框对象
			}
			将MyAction传递给action参数
	searchBean：
		可选，字符串，用于搜索获取数据的bean名字，采用!{keyword}替换关键字输入的文本，样例：
			organizationDialogList&keyword=!{keyword}
	isMulField：
		可选，布尔型，当idField/nameField以字符串形式传递时有效，标记是否获取所有同名的域的值，默认值为false
	notNull：
		可选，true（默认）表示可以为空
***********************************************/
function Dialog_List(mulSelect, idField, nameField, splitStr, dataBean, action, searchBean, isMulField, notNull, winTitle){
	var dialog = new KMSSDialog(mulSelect, true);
	dialog.winTitle = winTitle;
	dialog.AddDefaultOptionBeanData(dataBean);
	dialog.BindingField(idField, nameField, splitStr, isMulField);
	dialog.SetAfterShow(action);
	if(searchBean!=null)
		dialog.SetSearchBeanData(searchBean);
	if(notNull!=null)
		dialog.notNull = notNull;
	dialog.Show();
}

/***********************************************
功能：左边树右边列表的对话框的简单调用
参数：
	mulSelect：
		必选，true多选，false单选，默认值为单选
	idField：
		可选，绑定关键字的域名字或对象或对象列表
	nameField：
		可选，绑定显示名的域名字或对象或对象列表
	splitStr：
		可选，字符串，值分隔符，若需要将多个值放置在一个域中，该项不能为null
	treeBean：
		必选，字符串，目录树获取数据的bean名字
		treeBean中可以采用参数替换的方式指定，参数格式为：!{节点属性名}，如：
		节点node.value=123
		原给定的treeBean：beanName&para=!{value}
		实际使用的treeBean：beanName&para=123
	treeTitle：
		必选，字符串，目录树的跟节点显示内容
	dataBean：
		必选，字符串，备选列表获取数据的bean名字
	action：
		可选，函数对象，当对话框关闭后需要执行的操作，样例：
			function MyAction(rtnVal){
				//在此写入您的代码，采用rtnVal可用获取返回值，该值为KMSSData对象，采用this可用访问到对话框对象
			}
			将MyAction传递给action参数
	searchBean：
		可选，字符串，用于搜索获取数据的bean名字，采用!{keyword}替换关键字输入的文本，样例：
			organizationDialogList&keyword=!{keyword}
	exceptValue：
		可选，目录树中不期望出现的关键字，为字符串或字符串数组
	isMulField：
		可选，布尔型，当idField/nameField以字符串形式传递时有效，标记是否获取所有同名的域的值，默认值为false
	notNull：
		可选，true（默认）表示可以为空
***********************************************/
function Dialog_TreeList(mulSelect, idField, nameField, splitStr, treeBean, treeTitle, dataBean, action, searchBean, exceptValue, isMulField, notNull, winTitle){
	var dialog = new KMSSDialog(mulSelect, true);
	var node = dialog.CreateTree(treeTitle);
	dialog.winTitle = winTitle==null?treeTitle:winTitle;
	node.AppendBeanData(treeBean, dataBean, null, null, exceptValue);
	node.parameter = dataBean;
	dialog.BindingField(idField, nameField, splitStr, isMulField);
	dialog.SetAfterShow(action);
	if(searchBean!=null)
		dialog.SetSearchBeanData(searchBean);
	if(notNull!=null)
		dialog.notNull = notNull;
	dialog.Show();
}

function Dialog_PopupWindow(url,width, height, parameter){
	width = width==null?640:width;
	height = height==null?820:height;
	var left = (screen.width-width)/2;
	var top = (screen.height-height)/2;
	if(window.showModalDialog){
		var winStyle = "resizable:1;scroll:1;dialogwidth:"+width+"px;dialogheight:"+height+"px;dialogleft:"+left+";dialogtop:"+top;
		return window.showModalDialog(url, parameter, winStyle);
	}else{
		var winStyle = "resizable=1,scrollbars=1,width="+width+",height="+height+",left="+left+",top="+top+",dependent=yes,alwaysRaised=1";
		Com_Parameter.Dialog = this;
		var tmpwin=window.open(url, "_blank", winStyle);
		if(tmpwin==undefined || tmpwin == "undefined")
			return window.returnValue;
		else{
			return tmpwin.returnValue;
		}
	}
	
}

//=============================以下函数为内部函数，普通模块请勿调用==============================

/***********************************************
功能：将对话框数据与域绑定
参数：
	idField：
		可选，绑定关键字的域名字或对象或对象列表
	nameField：
		可选，绑定显示名的域名字或对象或对象列表
	splitStr：
		可选，字符串，值分隔符，若需要将多个值放置在一个域中，该项不能为null
	isMulField：
		可选，布尔型，当idField/nameField以字符串形式传递时有效，标记是否获取所有同名的域的值，默认值为false
***********************************************/
function DialogFunc_BindingField(idField, nameField, fieldSplit, isMulField){
	if(idField==null && nameField==null)
		return;
	var itemList = null;
	var fieldList = new Array;
	function getField(name) {
		if (!window.DocList_GetRowFields)
			return document.getElementsByName(name);
		var event = Com_GetEventObject();
		if (!event)
			return document.getElementsByName(name);
		return DocList_GetRowFields(event.target || event.srcElement, name);
	}
	if(idField!=null){
		itemList = "id";
		if(typeof(idField)=="string"){
			fieldList[0] = getField(idField);
			if(!isMulField)
				fieldList[0] = fieldList[0][0];
		}else{
			isMulField = idField[0]!=null;
			fieldList[0] = idField;
		}
	}
	if(nameField!=null){
		itemList = itemList==null?"name":itemList+":name";
		var n = fieldList.length;
		if(typeof(nameField)=="string"){
			fieldList[n] = getField(nameField);
			if(!isMulField)
				fieldList[n] = fieldList[n][0];
		}else{
			isMulField = nameField[0]!=null;
			fieldList[n] = nameField;
		}
	}
	if(fieldSplit==null && !isMulField && this.mulSelect)
		this.fieldSplit = ";";
	else
		this.fieldSplit = fieldSplit;
	this.itemList = itemList;
	this.fieldList = fieldList;
	this.isMulField = isMulField;
	this.valueData.AddFromField(this.itemList, this.fieldList, this.fieldSplit, this.isMulField);
}

/***********************************************
功能：创建一棵目录树，并返回树的根节点
说明：
	目录树的构建操作跟treeview.js中描述的操作基本一致，不同的点如下：
	1、不能采用AppendURLChild、AppendLV2Child的方式添加子节点。
	2、节点的parameter参数类型为KMSSData或字符串（javabean名）
参数：
	treeTitle：
		必选，字符串，目录树的跟节点显示内容
返回：树的根节点
***********************************************/
function DialogFunc_CreateTree(treeTitle){
	this.tree = new TreeView("LKSTree", treeTitle);
	return this.tree.treeRoot;
}

/***********************************************
功能：往对话框的已选列表中添加数据
参数：
	kmssdata：
		必选，KMSSData对象
***********************************************/
function DialogFunc_AddDefaultValue(kmssdata){
	this.valueData.AddKMSSData(kmssdata);
}

/***********************************************
功能：往对话框的备选列表中添加数据
参数：
	kmssdata：
		必选，KMSSData对象
***********************************************/
function DialogFunc_AddDefaultOption(kmssdata){
	this.optionData.AddKMSSData(kmssdata);
}

/***********************************************
功能：通过javabean的方式获取数据，并添加到对话框的备选列表中
参数：
	beanName：
		必选，字符串，Javabean名
***********************************************/
function DialogFunc_AddDefaultOptionBeanData(beanName){
	this.AddDefaultOptionXMLData(XMLDATABEANURL+beanName);
}

/***********************************************
功能：通过XML的方式获取数据，往对话框的备选列表中添加数据
参数：
	beanURL：
		必选，字符串，XML的URL路径
***********************************************/
function DialogFunc_AddDefaultOptionXMLData(beanURL){
	this.optionData.AddXMLData(beanURL);
}

/***********************************************
功能：弹出对话框
参数：
	width：
		可选，窗口宽度
	height：
		可选，窗口高度
***********************************************/
function DialogFunc_Show(width, height){
	Com_EventPreventDefault();
	var url = Com_SetUrlParameter(this.URL,'s_css',Com_Parameter.Style);
	url = Com_SetUrlParameter(this.URL,'mul',(this.mulSelect?1:0));
	if(this.tree==null){
		width = width==null?(this.mulSelect?500:400):width;
	}else{
		if(this.mulSelect || this.showOption){
			width = width==null?640:width;
		}else{
			width = width==null?460:width;
		}
	}
	height = height==null?480:height;
	var left = (screen.width-width)/2;
	var top = (screen.height-height)/2;
	if(window.showModalDialog){
		var winStyle = "resizable:1;scroll:1;dialogwidth:"+width+"px;dialogheight:"+height+"px;dialogleft:"+left+";dialogtop:"+top;
		window.showModalDialog(url, this, winStyle);
	}else{
		var winStyle = "resizable=1,scrollbars=1,width="+width+",height="+height+",left="+left+",top="+top+",dependent=yes,alwaysRaised=1";
		Com_Parameter.Dialog = this;
		window.open(url, "_blank", winStyle);
	}
}

/***********************************************
功能：内部函数，对话框点击确定以后执行的函数
***********************************************/
function DialogFunc_AfterShow(){	
	if(this.rtnData!=null){
		this.rtnData = new KMSSData().AddHashMapArray(this.rtnData);
		if(this.itemList!=null){
			this.rtnData.PutToField(this.itemList, this.fieldList, this.fieldSplit, this.isMulField);
			var fieldObjs = this.fieldList;
			for ( var i = 0; i < fieldObjs.length; i++) {
				if(fieldObjs[i].name){
					var fieldObj=document.getElementsByName(fieldObjs[i].name);
					if(fieldObj.length>0){
						try{
							fieldObj[0].focus();
						}catch(e){}
					}
				}
			}
		}
	}
	if(this.AfterShowAction!=null)
		this.AfterShowAction(this.rtnData);
}

/***********************************************
功能：设置用于数据搜索的javabean名称
参数：
	beanName：
		必选，字符串，Javabean名
***********************************************/
function DialogFunc_SetSearchBeanData(beanName){
	this.SetSearchXMLData(XMLDATABEANURL+beanName);
}

/***********************************************
功能：设置用于数据搜索的XML的URL路径
参数：
	beanURL：
		必选，字符串，XML的URL路径
***********************************************/
function DialogFunc_SetSearchXMLData(beanURL){
	this.searchBeanURL = beanURL;
}

/***********************************************
功能：设置对话框执行完毕后需要执行的代码
参数：
	action：
		必选，函数对象
***********************************************/
function DialogFunc_SetAfterShow(action){
	this.AfterShowAction = action;
}
//=============================以上函数为内部函数，普通模块请勿调用==============================