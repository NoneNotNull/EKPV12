/*压缩类型：标准*/
/***********************************************
JS文件说明：
该文件提供了目录树的调用方法。

作者：叶中奇
版本：1.0 2006-4-3
***********************************************/

Com_RegisterFile("treeview.js");
Com_IncludeFile("data.js|rightmenu.js");

//组织架构常量
var ORG_TYPE_ORG = 0x1;															//机构
var ORG_TYPE_DEPT = 0x2;														//部门
var ORG_TYPE_POST = 0x4;													//岗位
var ORG_TYPE_PERSON = 0x8;														//个人
var ORG_TYPE_GROUP = 0x10;														//群组
var ORG_TYPE_ROLE = 0x20;		
var ORG_TYPE_ORGORDEPT = ORG_TYPE_ORG | ORG_TYPE_DEPT;							//机构或部门
var ORG_TYPE_POSTORPERSON = ORG_TYPE_POST | ORG_TYPE_PERSON;					//岗位或个人
var ORG_TYPE_ALLORG = ORG_TYPE_ORGORDEPT | ORG_TYPE_POSTORPERSON;				//所有组织架构类型
var ORG_TYPE_ALL = ORG_TYPE_ALLORG | ORG_TYPE_GROUP;							//所有组织架构类型+群组
var ORG_FLAG_AVAILABLEYES = 0x100;												//有效标记
var ORG_FLAG_AVAILABLENO = 0x200;												//无效标记
var ORG_FLAG_AVAILABLEALL = ORG_FLAG_AVAILABLEYES | ORG_FLAG_AVAILABLENO;		//包含有效和无效标记
var ORG_FLAG_BUSINESSYES = 0x400;												//业务标记
var ORG_FLAG_BUSINESSNO = 0x800;												//非业务标记
var ORG_FLAG_BUSINESSALL = ORG_FLAG_BUSINESSYES | ORG_FLAG_BUSINESSNO;			//包含业务和非业务标记

//目录树常量
var TREENODEUNIDCOUNTER = 0;		//目录树节点ID计数器
var TREENODESTYLE = new Object();	//目录树样式设置器
var TREESTYLE = "default";			//目录树的风格
var TREENXMLBEANURL = Com_Parameter.ContextPath + "sys/common/treexml.jsp?s_bean=";	//目录树bean数据获取路径
var IMGPATHPREFIX = Com_Parameter.ResPath+"style/default/tree/";			//目录树图片路径

/***********************************************
功能：目录树视图的构造函数
参数：
	refName：
		必选，字符串，引用的全局变量名
	text：
		必选，字符串，树根节点的文本内容
	DOMElement：
		必选，HTML元素，需要放置目录树的HTML元素对象
***********************************************/
function TreeView(refName, text, DOMElement){
//=============================以下属性/方法仅供内部使用，普通模块请勿调用==============================
	var root = new TreeNode(text);
	root.isExpanded = true;
	root.treeView = this;
	this.treeRoot = root;
	this.refName = refName;
	this.DOMElement = DOMElement;
	this.currentNodeID = -1;
	this.lastCheckedNode = null;
	this.noHTMLCache = false;
	this.authNodeValue = null;                              //节点权限过滤（显示有权限的节点）

	this.DrawNode = TreeFunc_DrawNode;						//画目录树中的一个节点
	this.DrawNodeIndentHTML = TreeFunc_DrawNodeIndentHTML;	//画目录树节点中的缩进部分
	this.DrawNodeOuterHTML = TreeFunc_DrawNodeOuterHTML;	//画节点的所有内容（包括子节点）
	this.DrawNodeInnerHTML = TreeFunc_DrawNodeInnerHTML;	//画节点的内容
//=============================以上属性/方法仅供内部使用，普通模块请勿调用==============================

	this.isShowCheckBox = false;							//是否显示单选/复选框
	this.isMultSel = true;									//是否多选
	this.isAutoSelectChildren = false;						//选择父节点是否自动选中子节点
	this.isHrefAddInfo = true;								//是否自动在HREF中添加树的信息

	this.ClickNode = TreeFunc_ClickNode;					//点击节点
	this.DblClickNode = null;				//双击树节点
	this.ExpandNode = TreeFunc_ExpandNode;					//展开节点
	this.GetCheckedNode = TreeFunc_GetCheckedNode;			//获取所有选定的节点
	this.GetCurrentNode = TreeFunc_GetCurrentNode;			//获取当前高亮的节点
	this.SelectNode = TreeFunc_SelectNode;					//选中节点
	this.SetCurrentNode = TreeFunc_SetCurrentNode;			//将节点设为当前节点
	this.SetNodeChecked = TreeFunc_SetNodeChecked;			//设置节点是否被选中
	this.SetTreeRoot = TreeFunc_SetTreeRoot;				//设置目录树的根节点
	this.Show = TreeFunc_Show;								//展现目录树
	this.EnableRightMenu = function(){};					//本功能废弃

	this.OnNodeQueryDraw = null;							//事件：在画节点前触发
	this.OnNodePostDraw = null;								//事件：在画节点后触发
	this.OnNodeQueryExpand = null;							//事件：在节点展开前触发
	this.OnNodePostExpand = null;							//事件：在节点展开后触发
	this.OnNodeQueryClick = null;							//事件：在节点点击前触发
	this.OnNodePostClick = null;							//事件：在节点点击后触发
	this.OnNodeCheckedQueryChange = null;
	this.OnNodeCheckedPostChange = null;
}

/***********************************************
功能：目录树节点的构造函数，不建议外部程序调用
参数：
	text：
		必选，字符串，节点文本内容
	parameter：
		可选，action的参数
	action：
		可选，函数对象，点击节点需要执行的动作
	value：
		可选，一般为字符串，节点的值
	title：
		可选，字符串，鼠标放在节点上显示的文本
	nodeType：
		可选，节点类型，决定节点显示的图标，目前支持的类型有：
			ORG_TYPE_ORG：机构；ORG_TYPE_DEPT：部门；ORG_TYPE_PERSON：个人；其他：文件夹和文件
***********************************************/
function TreeNode(text, parameter, action, value, title, nodeType){
//=============================以下属性/方法仅供内部使用，普通模块请勿调用==============================
	this.XMLDataInfo = null;
	this.treeView = null;
	this.LV2UseURL = null;

	this.CheckFetchChildrenNode = NodeFunc_CheckFetchChildrenNode;		//检查节点的子结点信息是否有载入
	this.FetchChildrenUseXMLNode = NodeFunc_FetchChildrenUseXMLNode;	//载入一个节点的内容
//=============================以上属性/方法仅供内部使用，普通模块请勿调用==============================

//=============================以下属性为只读，普通模块请勿修改==============================
	this.id = TREENODEUNIDCOUNTER++;
	this.parent = null;
	this.firstChild = null;
	this.nextSibling = null;
	this.prevSibling = null;
	this.lastChild = null;
//=============================以上属性为只读，普通模块请勿修改==============================
	this.authType = "00";		//对节点的验证权限,0显示所有(00可以选中所有,01只能选中有维护权限的,02只能选中有使用权限的),1 只显示有维护权限的 2 只显示有使用权限的
	this.title = title==null?text:title;
	this.text = text;
	this.value = value;
	this.parameter = parameter;
	this.action = action;
	this.nodeType = nodeType==null?"node":nodeType;
	this.isExpanded = false;
	this.isChecked = false;
	this.isShowCheckBox = null;
	this.isHrefAddInfo = null;
	this.AppendChild = NodeFunc_AppendChild;		//添加一个子节点，并指定其参数
	this.AppendURLChild = NodeFunc_AppendURLChild;	//添加一个子节点，点击节点打开指定的URL
	
	this.AppendLV2Child = NodeFunc_AppendLV2Child;	//添加一个子节点，点击节点打开中间帧的架构信息
	this.AppendCV2Child = NodeFunc_AppendCV2Child;	//添加一个子节点，点击节点打开中间帧的类别树信息
	this.AppendHrLV2Child = NodeFunc_AppendHrLV2Child;	//添加一个子节点，点击节点打开中间帧的架构信息
	this.AppendBeanData = NodeFunc_AppendBeanData;	//通过JavaBean的数据方式批量添加子结点
	this.AppendXMLData = NodeFunc_AppendXMLData;	//通过XML的数据方式批量添加子结点
	this.AppendOrgData = NodeFunc_AppendOrgData;	//添加组织架构树
	this.AppendSetCategary = NodeFunc_AppendSetCategary;	//添加模块的类别设置
	this.AppendOrgTreeData = NodeFunc_AppendOrgTreeData;	//添加组织分类树
	this.AppendCategoryData = NodeFunc_AppendCategoryData;	//添加类别展开树
	this.AppendCategoryDataWithAdmin = NodeFunc_AppendCategoryDataWithAdmin; // 全局分类模块维护树
	this.AppendSimpleCategoryData = NodeFunc_AppendSimpleCategoryData; //添加简单分类展开树
	this.AppendSimpleCategoryDataWithAdmin = NodeFunc_AppendSimpleCategoryDataWithAdmin;//简单分类模块维护树
	this.AppendPropertyData = NodeFunc_AppendPropertyData;	//添加简单类别展开树
	this.AppendProData = NodeFunc_AppendProData; //添加辅分类别展开树，不包含模板
	this.AppendHrOrgData = NodeFunc_AppendHrOrgData;//添加组织架构树
	this.AppendKmOrgInfoData = NodeFunc_AppendKmOrgInfoData;  //添加组织架构树
	this.AppendKmOrgData = NodeFunc_AppendKmOrgData;  //添加组织架构树
	
	this.FetchChildrenNode = null;					//展开子节点的操作定义
	
	this.AddChild = NodeFunc_AddChild;				//往节点下添加一个子节点
	this.Remove = NodeFunc_Remove;					//删除节点
	this.RemoveChildren = NodeFunc_RemoveChildren;	//删除子节点
	Tree_SetNodeHTMLDirty(this);
}

/***********************************************
功能：载入目录树样式
参数：
	style：
		可选，样式名称，默认根据目录树所在的位置确定，目前支持的选项有：
			nav：导航栏、LV1/LV2/LV3/LV4：相应页面级别的样式
***********************************************/
function Tree_IncludeCSSFile(style)
{
	if(style!=null){
		TREESTYLE = style;
	}else{
		try{
			if(parent.Nav_CurIndex!=null){
				TREESTYLE = "nav";
			}else{
				var i = Com_RunMainFrameFunc("Frame_GetWinLevel");
				if(i!=null)
					TREESTYLE = "LV"+i;
			}
		}catch(e){}
	}
	document.write("<style>.TVN_TreeNode_Current{background-color:#FFFFCC; padding:2px; border:1px solid #999999;}</style>");
	Com_IncludeFile("tree_page.js", "style/"+Com_Parameter.Style+"/tree/");
	if(TREESTYLE=="LV2")
		Com_AddEventListener(window, "load", Tree_DrawLockIcon);
}

/***********************************************
功能：根据标题获取子节点
参数：
	parent：必选，目录树节点
	text：必选，字符串
返回：目录树节点，找不到则返回null
***********************************************/
function Tree_GetChildByText(parent, text){
	if(parent==null)
		return null;
	else
		for(var now=parent.firstChild;now!=null;now=now.nextSibling)
			if(now.text == text)
				return now;
}

/***********************************************
功能：根据ID获取节点
参数：
	root：必选，目录树节点，查找起始点
	id：必选，节点ID
返回：目录树节点，找不到则返回null
***********************************************/
function Tree_GetNodeByID(root, id){
	var Result;
	if(root == null)
		return null;
	if(root.id == id)
		return root;
	for(var now=root.firstChild; now!=null; now=now.nextSibling){
		Result = Tree_GetNodeByID(now, id);
		if(Result!=null)
			return Result;
	}
	return null;
}

function Tree_GetNodeByValue(root, value){
	var Result;
	if(root == null)
		return null;
	if(root.value == value)
		return root;
	for(var now=root.firstChild; now!=null; now=now.nextSibling){
		Result = Tree_GetNodeByValue(now, value);
		if(Result!=null)
			return Result;
	}
	return null;
}

/***********************************************
功能：根据指定的路径获取节点
参数：
	root：必选，目录树节点，查找起始点
	path：必选，路径描述（路径以text+分隔符组成）
	SepStr：可选，路径分隔符，默认值为\
返回：目录树节点，找不到则返回null
***********************************************/
function Tree_GetNodeByPath(root, path, SepStr){
	SepStr = SepStr==null?"\\":SepStr;
	var p = path.split(SepStr);
	var i = 0;
	var now = root;
	if(p[0]==""){
		if(root.text!=p[1])
			return null;
		i = 2;
	}
	for(; now!=null && i<p.length; i++){
		now.CheckFetchChildrenNode();
		now = Tree_GetChildByText(now, p[i]);
	}
	return now;
}

/***********************************************
功能：获取节点路径
参数：
	node：必选，目录树节点
	SepStr：可选，路径分隔符，默认值为\
	toNode：可选，终止节点
返回：字符串，节点路径
***********************************************/
function Tree_GetNodePath(node, SepStr, toNode){
	if(node == null)
		return "";
	if(SepStr == null)
		SepStr = "\\";
	for(var Result="";node.parent!=null && node.parent!=toNode; node=node.parent)
		Result = SepStr+node.text+Result;
	Result = node.text+Result;
	return Result;
}

/***********************************************
功能：采用现有的service构造通用的目录树使用的beanName参数
参数：
	serviceName：
		必选，service名称
	parentItem：
		必选，在域模型中父对象映射名称
	rtnItem：
		必选，节点取值对应域模型中的字段名，如：fdName:fdId
	orderby：
		可选，排序列，多值用:分隔，为域模型中的字段名，如：forder
返回：目录树使用的beanName参数
***********************************************/
function Tree_GetBeanNameFromService(serviceName, parentItem, rtnItem, orderby){
	var beanName = "XMLGetTreeService&service=" + serviceName + "&parent=" + parentItem + "&item=" + rtnItem;
	if(orderby!=null)
		beanName += "&orderby=" + orderby;
	return beanName+"&fdId=!{value}";
}

//=============================以下函数仅供内部使用，普通模块请勿调用==============================
/***********************************************
功能：往节点下添加一个子节点
参数：
	node：必选，子节点
	nextSibling：可选，添加到哪个节点的前面，默认为null
***********************************************/
function NodeFunc_AddChild(node, nextSibling){
	if (node.prevSibling!=null){
		node.prevSibling.nextSibling = node.nextSibling;
		Tree_SetNodeHTMLDirty(node.prevSibling);
	}
	if(node.nextSibling!=null){
		node.nextSibling.prevSibling = node.prevSibling;
		Tree_SetNodeHTMLDirty(node.nextSibling);
	}
	if(node.parent!=null){
		if(node.parent.firstChild==node)
			node.parent.firstChild = node.nextSibling;
		if(node.parent.lastChild==node)
			node.parent.lastChild = node.prevSibling;
		Tree_SetNodeHTMLDirty(node.parent);
	}
	node.parent = this;
	if(nextSibling!=null && nextSibling.parent!=this)
		nextSibling = null;
	node.nextSibling = nextSibling;
	if(nextSibling==null){
		if(this.lastChild==null){
			this.firstChild = node;
			node.prevSibling = null;
		}else{
			node.prevSibling = this.lastChild;
			node.prevSibling.nextSibling = node;
		}
		this.lastChild = node;
	}else{
		node.prevSibling = nextSibling.prevSibling;
		nextSibling.prevSibling = node;
		if(node.prevSibling==null)
			this.firstChild = node;
		else
			node.prevSibling.nextSibling = node;
	}
	node.treeView = this.treeView;
	Tree_SetNodeHTMLDirty(this);
	Tree_SetNodeHTMLDirty(node);
	Tree_SetNodeHTMLDirty(node.prevSibling);
	Tree_SetNodeHTMLDirty(node.nextSibling);
}

/***********************************************
功能：添加一个子节点，并指定其参数
参数：
	text：必选，字符串，节点显示文本
	parameter：可选，节点action参数，任意类型
	action：可选，函数对象，节点的操作
	value：可选，节点值
	title：可选，字符串，节点标题，默认取text
	nodeType：可选，字符串，节点图标样式
***********************************************/
function NodeFunc_AppendChild (text, parameter, action, value, title, nodeType){
	var node = new TreeNode(text, parameter, action, value, title, nodeType);
	this.AddChild(node);
	return node;
}

/***********************************************
功能：添加一个子节点，点击节点打开指定的URL
参数：
	text：必选，字符串，节点显示文本
	url：可选，点击节点后需要打开的URL
		URL中可以采用参数替换的方式指定，参数格式为：!{节点属性名}，如：
		节点node.value=123
		原给定的URL：../sysorgdept.do?method=list&parent=!{value}
		实际使用的URL：../sysorgdept.do?method=list&parent=123
	target：可选，打开URL的目标帧，默认为下一级帧
		数字：帧的级数
		字符串：window.open使用的目标帧名
	winStyle：可选，窗口的风格
		若target为数字：max：最大化，mid：视图和文档大小平分，min：最小化
		若target为字符串：window.open使用的风格
	value：可选，节点值
	title：可选，字符串，节点标题，默认取text
	nodeType：可选，字符串，节点图标样式
***********************************************/
function NodeFunc_AppendURLChild(text, url, target, winStyle, value, title, nodeType){
	var parameter;
	if(url!=null)
	{
		parameter = new Array;
		parameter[0] = url;
		parameter[1] = target;
		parameter[2] = winStyle;
	}
	var node = new TreeNode(text, parameter, null, value, title, nodeType);
	this.AddChild(node);
	return node;
}

/***********************************************
功能：添加一个子节点，点击节点打开中间帧的架构信息
参数：
	text：必选，字符串，节点显示文本
	url：可选，点击中间帧节点后需要打开的URL
		同AppendURLChild的URL参数，但使用的节点为组织架构树中的节点，常用的参数有：
			!{value}：组织架构ID
			!{nodeType}：组织架构类型
	orgType：组织架构展现类型
	startWith：组织架构起始部门ID
	target：可选，打开URL的目标帧，默认为下一级帧
		数字：帧的级数
		字符串：window.open使用的目标帧名
	winStyle：可选，窗口的风格
		若target为数字：max：最大化，mid：视图和文档大小平分，min：最小化
		若target为字符串：window.open使用的风格
	value：可选，节点值
	title：可选，字符串，节点标题，默认取text
	nodeType：可选，字符串，节点图标样式
***********************************************/
function NodeFunc_AppendLV2Child(text, url, orgType, startWith, target, winStyle, value, title, nodeType, noRoot){
	orgType = orgType==null?ORG_TYPE_DEPT:orgType;
	var orgURL = Com_Parameter.ContextPath + "sys/organization/orgtree.jsp?orgType="+orgType+
		(startWith==null?"":"&startWith="+startWith)+
		(target==null?"":"&target="+target)+
		(winStyle==null?"":"&winstyle="+winStyle);
	if(noRoot==null)
		noRoot = (orgType & ORG_TYPE_ORGORDEPT) == 0;
	orgURL += "&noRoot=" + noRoot + "&url=!{LV2UseURL}";
	var node = this.AppendURLChild(text, orgURL, 2, null, value, title, nodeType);
	node.LV2UseURL = url;
	return node;
}
/***********************************************
功能：添加一个子节点，点击节点打开中间帧的类别树信息
参数：
	text：必选，字符串，节点显示文本
	modelName"必选，字符串，当前域模型
	url：可选，点击中间帧节点后需要打开的URL
		同AppendURLChild的URL参数，但使用的节点为类别树中的节点，常用的参数有：
			!{value}：类别ID
	startWith：类别的起始ID
	target：可选，打开URL的目标帧，默认为下一级帧
		数字：帧的级数
		字符串：window.open使用的目标帧名
	winStyle：可选，窗口的风格
		若target为数字：max：最大化，mid：视图和文档大小平分，min：最小化
		若target为字符串：window.open使用的风格
	value：可选，节点值
	title：可选，字符串，节点标题，默认取text
	nodeType：可选，字符串，节点图标样式
***********************************************/
function NodeFunc_AppendCV2Child(text, modelName,url, startWith, target, winStyle, value, title, nodeType){
	if(modelName==null || modelName=="") return false;
	var categoryURL = Com_Parameter.ContextPath + "sys/category/categorytree.jsp?modelName="+modelName+
		(startWith==null?"":"&startWith="+startWith)+
		(target==null?"":"&target="+target)+
		(winStyle==null?"":"&winstyle="+winStyle);
	categoryURL += "&url=!{LV2UseURL}";
	var node = this.AppendURLChild(text, categoryURL, 2, null, value, title, nodeType);
	node.LV2UseURL = url;
	return node;
	
}

function NodeFunc_AppendHrLV2Child(text, url, orgType, startWith, target, winStyle, value, title, nodeType, noRoot){
	orgType = orgType==null?ORG_TYPE_DEPT:orgType;
	var orgURL = Com_Parameter.ContextPath + "hr/organization/orgtree.jsp?orgType="+orgType+
		(startWith==null?"":"&startWith="+startWith)+
		(target==null?"":"&target="+target)+
		(winStyle==null?"":"&winstyle="+winStyle);
	if(noRoot==null)
		noRoot = (orgType & ORG_TYPE_ORGORDEPT) == 0;
	orgURL += "&noRoot=" + noRoot + "&url=!{LV2UseURL}";
	var node = this.AppendURLChild(text, orgURL, 2, null, value, title, nodeType);
	node.LV2UseURL = url;
	return node;
}

/***********************************************
功能：通过JavaBean的数据方式批量添加子结点
参数：
	beanName：必选，字符串，Javabean的名称，可带参数，如：beanName&para=value
		beanName中可以采用参数替换的方式指定，参数格式为：!{节点属性名}，如：
		节点node.value=123
		原给定的beanName：beanName&para=!{value}
		实际使用的beanName：beanName&para=123
	parameter：可选，节点action参数，任意类型
	action：可选，函数对象，节点的操作
	isAutoFetch：可选，布尔型，下一级节点配置自动继承上一级的配置
	exceptValue：可选，字符串或数组，不显示的节点
***********************************************/
function NodeFunc_AppendBeanData(beanName, parameter, action, isAutoFetch, exceptValue){
	this.AppendXMLData(TREENXMLBEANURL+beanName, parameter, action, isAutoFetch, exceptValue)
}

/***********************************************
功能：通过XML的数据方式批量添加子结点
参数：
	beanURL：必选，字符串，XML的URL路径
		beanURL中可以采用参数替换的方式指定，参数格式为：!{节点属性名}，如：
		节点node.value=123
		原给定的beanURL：...&para=!{value}
		实际使用的beanURL：...&para=123
	parameter：可选，节点action参数，任意类型
	action：可选，函数对象，节点的操作
	isAutoFetch：可选，布尔型，下一级节点配置自动继承上一级的配置
	exceptValue：可选，字符串或数组，不显示的节点
***********************************************/
function NodeFunc_AppendXMLData(beanURL, parameter, action, isAutoFetch, exceptValue){
	this.XMLDataInfo = {
		"beanURL":beanURL,
		"parameter":parameter,
		"action":action,
		"isAutoFetch":(isAutoFetch==null?true:isAutoFetch)
	};
	if(exceptValue!=null){
		if(exceptValue instanceof Array)
			this.XMLDataInfo.exceptValue = exceptValue;
		else{
			this.XMLDataInfo.exceptValue = new Array;
			this.XMLDataInfo.exceptValue[0] = exceptValue;
		}
	}
	this.FetchChildrenNode = NodeFunc_FetchChildrenByXML;
}

/***********************************************
功能：添加组织架构树
参数：
	orgType：必选，组织架构树类型，可取的值见以“ORG_”开始的常量部分（用|进行组合）
	parameter：可选，节点action参数，任意类型
	action：可选，函数对象，节点的操作
	startWith：组织架构起始部门ID
	exceptValue：可选，字符串或数组，不显示的节点
说明：
	由该函数创建的节点，节点.value=组织结构ID，节点.nodeType=组织架构类型
	一般的，调用该函数时，action不需要进行设置，parameter设置为URL或URL+目标帧的数组或URL+目标帧+窗口风格的数组的形式，这样，程序会自动调用Com_OpenWindow的方法打开指定的URL，同样，URL采用参数替换的形式。
***********************************************/
function NodeFunc_AppendOrgData(orgType, parameter, action, startWith, exceptValue){
	this.AppendBeanData("organizationTree&parent=!{value}&orgType="+orgType, parameter, action, true, exceptValue);
	if(startWith!=null)
		this.value = startWith;
}
/***********************************************
功能：添加一个类别设置子节点，点击节点打开类别设置的URL
参数：
	text：必选，字符串，节点显示文本
	modelName:域模型名称
	target：可选，打开URL的目标帧，默认为下一级帧
		数字：帧的级数
		字符串：window.open使用的目标帧名
	winStyle：可选，窗口的风格
		若target为数字：max：最大化，mid：视图和文档大小平分，min：最小化
		若target为字符串：window.open使用的风格
	value：可选，节点值
	title：可选，字符串，节点标题，默认取text
	nodeType：可选，字符串，节点图标样式
****************************************************/
function NodeFunc_AppendSetCategary(text, modelName, target, winStyle, value, title, nodeType) {
	var url = Com_Parameter.ContextPath + "sys/category/sys_category_main/sysCategoryMain_tree.jsp?modelName="+modelName;
	var parameter;
	if(url!=null)
	{
		parameter = new Array;
		parameter[0] = url;
		parameter[1] = target;
		parameter[2] = winStyle;
	}
	var node = new TreeNode(text, parameter, null, value, title, nodeType);

	this.AddChild(node);
	return node;

}
/***********************************************
功能：添加组织分类树
参数：
	parameter：可选，节点action参数，任意类型
	action：可选，函数对象，节点的操作
	startWith：组织架构起始部门ID
	exceptValue：可选，字符串或数组，不显示的节点
说明：
	一般的，调用该函数时，action不需要进行设置，parameter设置为URL或URL+目标帧的数组或URL+目标帧+窗口风格的数组的形式，这样，程序会自动调用Com_OpenWindow的方法打开指定的URL，同样，URL采用参数替换的形式。
***********************************************/
function NodeFunc_AppendOrgTreeData(parameter, action, startWith, exceptValue){
	this.AppendBeanData("sysCategoryOrgTreeTreeService&authType=" + this.authType + "&categoryId=!{value}", parameter, action, true, exceptValue);
	if(startWith!=null)
		this.value = startWith;
}
/***********************************************
功能：添加类别展开树
参数：
	modelName:必填，当前的域模型名称
	parameter：可选，节点action参数，任意类型
	showTemplate: 可选，是否显示模板，0不显示，1 显示模板，类别不可选择，2 显示模板并且类别可选择 默认是2
	showType:可选,显示方式,0显示子场所分类,1只显示父场所分类,2只显示父场所分类和子场所分类
	action：可选，函数对象，节点的操作
	startWith：展开分类根节点ID
	exceptValue：可选，字符串或数组，不显示的节点
说明：
	由该函数创建的节点，节点.value=类别ID，节点.name=类别名称
	一般的，调用该函数时，action不需要进行设置，parameter设置为URL或URL+目标帧的数组或URL+目标帧+窗口风格的数组的形式，这样，程序会自动调用Com_OpenWindow的方法打开指定的URL，同样，URL采用参数替换的形式。
***********************************************/
function NodeFunc_AppendCategoryData(modelName, parameter, showTemplate,showType,action, startWith,exceptValue, extendPara){
	if(modelName==null || modelName=="") return;
	if(showTemplate==null) showTemplate = 2;
	if(showType==null) showType = "0";
	var cateUrl = "sysCategoryTreeService&showType=" + showType + "&authType=" + this.authType + "&categoryId=!{value}&modelName="+modelName;
	if(extendPara!=null){
		cateUrl += "&extendPara="+encodeURIComponent(extendPara);
	}
	if(typeof(parameter)=="string" && parameter.indexOf("nodeType")==-1) {
		parameter += "&nodeType=!{nodeType}";
	}
	if(showTemplate) cateUrl += "&getTemplate=" + showTemplate;
	this.AppendBeanData(cateUrl, parameter, action, true, exceptValue);
	if(startWith!=null)
		this.value = startWith;
}
/***********************************************
功能：添加简单类别展开树
参数：
	modelName:必填，当前的域模型名称
	parameter：可选，节点action参数，任意类型
	action：可选，函数对象，节点的操作
	startWith：展开分类根节点ID
	exceptValue：可选，字符串或数组，不显示的节点
	extProps : 可选，其他参数判断，多个值以;号隔开 例如：extProps=fdTemplateType:1;fdTemplateType:3
说明：
	由该函数创建的节点，节点.value=类别ID，节点.name=类别名称
	一般的，调用该函数时，action不需要进行设置，parameter设置为URL或URL+目标帧的数组或URL+目标帧+窗口风格的数组的形式，这样，程序会自动调用Com_OpenWindow的方法打开指定的URL，同样，URL采用参数替换的形式。
	add by wubing
	date：2009-07-27			
***********************************************/
function NodeFunc_AppendSimpleCategoryData(modelName,parameter,action, startWith,exceptValue, extendService,extProps){
	if(modelName==null || modelName=="") return;
	var cateUrl = 'sysSimpleCategoryTreeService'+(extendService!=null?';'+extendService:'')+'&authType=' + this.authType + '&categoryId=!{value}'+'&extProps='+extProps;
	cateUrl+='&modelName=' + modelName;
	if(extendService!=null){
		cateUrl += "&extendService="+encodeURIComponent(extendService);
	}
	if(typeof(parameter)=="string" && parameter.indexOf("nodeType")==-1) {
		parameter += "&nodeType=!{nodeType}";
	}
	this.AppendBeanData(cateUrl, parameter, action, true, exceptValue);
	if(startWith!=null)
		this.value = startWith;
}

/***********************************************
功能：添加辅类别展开树
参数：
	parameter：可选，节点action参数，任意类型
	showTemplate: 可选，是否显示模板，默认是不显示
	modelName:域模型名称,当showTemplate=true时必选
	action：可选，函数对象，节点的操作
	startWith：展开分类根节点ID
	exceptValue：可选，字符串或数组，不显示的节点
说明：
	由该函数创建的节点，节点.value=类别ID，节点.name=类别名称
	一般的，调用该函数时，action不需要进行设置，parameter设置为URL或URL+目标帧的数组或URL+目标帧+窗口风格的数组的形式，这样，程序会自动调用Com_OpenWindow的方法打开指定的URL，同样，URL采用参数替换的形式。
***********************************************/
function NodeFunc_AppendPropertyData(parameter, showTemplate, modelName,action, startWith,exceptValue){
	var cateUrl = "sysCategoryPropertyTreeService&authType=" + this.authType + "&categoryId=!{value}";
	if(showTemplate==null) showTemplate = false;
	if(showTemplate) cateUrl += "&modelName=" + modelName+ "&getTemplate=1&href="+encodeURIComponent(parameter);
	this.AppendBeanData(cateUrl, parameter, action, true, exceptValue);
	if(startWith!=null)
		this.value = startWith;
}

function NodeFunc_AppendProData(parameter,action, startWith,exceptValue){
	var cateUrl = "sysCategoryPropertyTreeService&authType=" + this.authType + "&categoryId=!{value}";
	this.AppendBeanData(cateUrl, parameter, action, true, exceptValue);
	if(startWith!=null)
		this.value = startWith;
}
function NodeFunc_AppendHrOrgData(orgType, parameter, action, startWith, exceptValue){
	this.AppendBeanData("hrOrganizationTree&parent=!{value}&orgType="+orgType, parameter, action, true, exceptValue);
	if(startWith!=null)
		this.value = startWith;
}

function NodeFunc_AppendKmOrgData(orgType, parameter, action, startWith, exceptValue){
	this.AppendBeanData("kmOrganizationTree&parent=!{value}&orgType="+orgType, parameter, action, true, exceptValue);
	if(startWith!=null)
		this.value = startWith;
}

function NodeFunc_AppendKmOrgInfoData(orgType, parameter, action, startWith, exceptValue){
	this.AppendBeanData("kmResinfoOrgInfoTree&parent=!{value}&orgType="+orgType, parameter, action, true, exceptValue);
	if(startWith!=null)
		this.value = startWith;
}
/***********************************************
功能：检查节点的子结点信息是否有载入
***********************************************/
function NodeFunc_CheckFetchChildrenNode(){
	if(this.FetchChildrenNode!=null){
		if(this.FetchChildrenNode()!=false)
			this.FetchChildrenNode = null;
		Tree_SetNodeHTMLDirty(this);
		if(this.treeView.isAutoSelectChildren && this.treeView.isMultSel && this.isChecked){
			for(var node=this.firstChild; node!=null; node=node.nextSibling)
				node.isChecked = true;
		}
	}
}

/***********************************************
功能：默认的XML载入子节点的方法
***********************************************/
function NodeFunc_FetchChildrenByXML(){
	var nodesValue = new KMSSData().AddXMLData(Com_ReplaceParameter(this.XMLDataInfo.beanURL, this)).GetHashMapArray();
	for(var i=0; i<nodesValue.length; i++)
		this.FetchChildrenUseXMLNode(nodesValue[i]);
}

/***********************************************
功能：载入一个节点的内容
参数：Tree_GetChildByText
	attValue：节点内容的哈希表
***********************************************/
function NodeFunc_FetchChildrenUseXMLNode(attValue){
	//attValue:"text","title","value","isChecked","beanURL","nodeType","href","target","winStyle","isExpanded","beanName","isAutoFetch","isShowCheckBox","splitStr"
	if(this.treeView && this.treeView.authNodeValue) {
		if(this.treeView.authNodeValue instanceof Array) {
			if(Com_ArrayGetIndex(this.treeView.authNodeValue, attValue["value"])==-1) {
				return;
			}
		} else {
			if(this.treeView.authNodeValue != attValue["value"]) {
				return;
			}
		}
	}
	if(this.XMLDataInfo.exceptValue!=null && Com_ArrayGetIndex(this.XMLDataInfo.exceptValue, attValue["value"])>-1)
		return;
	var treeNode;
	if(attValue["splitStr"]==null){
		if(attValue["href"]==null){
			treeNode = this.AppendChild(
				attValue["text"],
				this.XMLDataInfo.parameter,
				this.XMLDataInfo.action,
				attValue["value"],
				attValue["title"],
				attValue["nodeType"]
			);
		}else{
			treeNode = this.AppendURLChild(
				attValue["text"],
				attValue["href"],
				attValue["target"],
				attValue["winStyle"],
				attValue["value"],
				attValue["title"],
				attValue["nodeType"]
			);
		}
	}else{
		var textArray = attValue["text"].split(attValue["splitStr"]);
		var text;
		var node = this;
		for(var i=0 ; i<textArray.length; i++){
			text = textArray[i];
			var child = Tree_GetChildByText(node, text);
			if(child==null){
				child = node.AppendURLChild(text);
			}
			node = child;
		}
		if(attValue["href"]==null){
			node.XMLDataInfo = new Object;
			node.XMLDataInfo.parameter = this.XMLDataInfo.parameter;
			node.XMLDataInfo.action = this.XMLDataInfo.action;
			node.value = attValue["value"];
			node.title = attValue["title"];
			node.nodeType = attValue["nodeType"];
		}else{
			node.href =attValue["href"];
			node.target = attValue["target"];
			node.winStyle = attValue["winStyle"];
			node.value = attValue["value"];
			node.title = attValue["title"];
			node.nodeType = attValue["nodeType"];
		}
		treeNode = node;
	}
	if(attValue["isExpanded"]=="1" || attValue["isExpanded"]=="true")
		treeNode.isExpanded = true;
	if(attValue["isChecked"]=="1" || attValue["isChecked"]=="true")
		treeNode.isChecked = true;
	if(attValue["isShowCheckBox"]=="0" || attValue["isShowCheckBox"]=="false")
		treeNode.isShowCheckBox = false;
	if(attValue["isAutoFetch"]==null){
		attValue["isAutoFetch"] = this.XMLDataInfo.isAutoFetch;
	}else{
		if(attValue["isAutoFetch"]=="0" || attValue["isAutoFetch"]=="false")
			attValue["isAutoFetch"] = false;
		else
			attValue["isAutoFetch"] = true;
	}
	if(attValue["beanName"]!=null && attValue["beanName"]!=""){
		var index = this.XMLDataInfo.beanURL.indexOf("?s_bean=");
		if(index>-1)
			attValue["beanURL"] = this.XMLDataInfo.beanURL.substring(0, index) + "?s_bean=" +attValue["beanName"];
		else
			attValue["beanURL"] = TREENXMLBEANURL+attValue["beanName"];
	}
	if((attValue["beanURL"]==null || attValue["beanURL"]=="") && attValue["isAutoFetch"])
		attValue["beanURL"] = this.XMLDataInfo.beanURL;
	if(attValue["beanURL"]!=null && attValue["beanURL"]!=""){
		treeNode.AppendXMLData(attValue["beanURL"], this.XMLDataInfo.parameter, this.XMLDataInfo.action, attValue["isAutoFetch"]);
		treeNode.XMLDataInfo.exceptValue = this.XMLDataInfo.exceptValue;
		treeNode.FetchChildrenNode = this.FetchChildrenNode;
	}
	return treeNode;
}

/***********************************************
功能：删除节点
***********************************************/
function NodeFunc_Remove(){
	if(this.prevSibling==null){
		if(this.parent!=null)
			this.parent.firstChild = this.nextSibling;
	}else{
		this.prevSibling.nextSibling = this.nextSibling;
		Tree_SetNodeHTMLDirty(this.prevSibling);
	}
	if(this.nextSibling==null){
		if(this.parent!=null)
			this.parent.lastChild = this.prevSibling;
	}else{
		this.nextSibling.prevSibling = this.prevSibling;
		Tree_SetNodeHTMLDirty(this.nextSibling);
	}
	this.treeView.lastCheckedNode = null;
	Tree_SetNodeHTMLDirty(this.parent);
}

/***********************************************
功能：删除子节点
***********************************************/
function NodeFunc_RemoveChildren(){
	this.firstChild = null;
	this.lastChild = null;
	this.treeView.lastCheckedNode = null;
	Tree_SetNodeHTMLDirty(this);
}

/***********************************************
功能：点击节点
参数：
	node：节点ID或对象
***********************************************/
function TreeFunc_ClickNode(node){
	var isHrefAddInfo, path;
	var isActRun = false;
	if(typeof(node)=="number")
		node = Tree_GetNodeByID(this.treeRoot, node);
	if(node == null)
		return;
	if (this.OnNodeQueryClick!=null)
		if (this.OnNodeQueryClick(node)==false)
			return;
	if(node.action==null){
		if((node.isShowCheckBox==true || node.isShowCheckBox==null && this.isShowCheckBox==true) && node.value!=null){
			this.SetNodeChecked(node, this.isMultSel?"reverse":true);
			return;
		}
		var href = typeof(node.parameter)=="string"?new Array(node.parameter):node.parameter;
		if(href!=null && href[0]!=""){
			var url = Com_ReplaceParameter(href[0], node);
			if(node.isHrefAddInfo==null)
				isHrefAddInfo = node.treeView.isHrefAddInfo;
			else
				isHrefAddInfo = node.isHrefAddInfo;
			if(isHrefAddInfo){
				var dns = TreeFunc_GetUrlDNS(url);
				if(dns==null || dns==TreeFunc_GetUrlDNS(location.href)){
					var path = Com_GetUrlParameter(location.href, "s_path");
					path = path==null?"":(path+">>");
					url = Com_SetUrlParameter(url, "s_path", path+Tree_GetNodePath(node,">>",node.treeView.treeRoot));
				}
			}
			Com_OpenWindow(url, href[1], href[2]);
			isActRun = true;
		}
	}else{
		if(node.action(node.parameter)==false)
			return;
		isActRun = true;
	}
	if(isActRun){
		this.SetCurrentNode(node);
		if (this.OnNodePostClick!=null)
			this.OnNodePostClick(node);
	}else
		this.ExpandNode(node);
}

/***********************************************
功能：画目录树中的一个节点
参数：
	node：节点对象
	indent_level：缩进级别
	Visible：是否可见
***********************************************/
function TreeFunc_DrawNode(node, indent_level, Visible){
	var Result = this.DrawNodeOuterHTML(node, indent_level, Visible);
	Visible = Visible && node.isExpanded;
	indent_level++;
	if(node.isExpanded)
		for(var child=node.firstChild; child!=null; child=child.nextSibling)
			Result += this.DrawNode(child, indent_level, Visible);
	return Result;
}

/***********************************************
功能：画目录树节点中的缩进部分
参数：
	node：节点对象
	indent_level：缩进级别
***********************************************/
function TreeFunc_DrawNodeIndentHTML(node, indent_level){
	
	var CannotExpand = (node.FetchChildrenNode==null && node.firstChild==null);
	var Result;

	if(node.nodeType==ORG_TYPE_ORG)
		Result = TREENODESTYLE.imgOrgNode;
	else if(node.nodeType==ORG_TYPE_DEPT)
		Result = TREENODESTYLE.imgDeptNode;
	else if(node.nodeType==ORG_TYPE_PERSON)
		Result = TREENODESTYLE.imgPersonNode;
	else if(node.nodeType=="CATEGORY")
		Result = (node.isExpanded&&!CannotExpand?TREENODESTYLE.imgOpenCategoryNode:TREENODESTYLE.imgCategoryNode);
	else if(node.nodeType=="CATEGORY_PARENT")
		Result = (node.isExpanded&&!CannotExpand?TREENODESTYLE.imgOpenCategoryParentNode:TREENODESTYLE.imgCategoryParentNode);
	else if(node.nodeType=="CATEGORY_SON")
		Result = (node.isExpanded&&!CannotExpand?TREENODESTYLE.imgOpenCategorySonNode:TREENODESTYLE.imgCategorySonNode);				
	else if(node.nodeType=="TEMPLATE")
		Result = TREENODESTYLE.imgTemplateNode;
	else if(node.nodeType=="CUBECHILD"){ 
		Result = node.isExpanded&&!CannotExpand?TREENODESTYLE.imgCubeChildNode:TREENODESTYLE.imgCubeChildNode;
    }
	else 
		Result = CannotExpand?TREENODESTYLE.imgLeaf:(node.isExpanded?TREENODESTYLE.imgOpenedFolder:TREENODESTYLE.imgClosedFolder);
	
	Result = "<img src=" + Result + " border=0>";
	if(!CannotExpand)
		Result = "<a href=\"javascript:"+this.refName+".ExpandNode("+node.id+")\">"+Result+"</a>";
	if(indent_level <= 0)
		return Result;
	if(node.nextSibling == null){	
		if(CannotExpand)
			Result = "<img src="+TREENODESTYLE.imgLastNode+">"+Result;
		else
			Result = "<a href=\"javascript:"+this.refName+".ExpandNode("+node.id+")\">"
				+(node.isExpanded?"<img src="+TREENODESTYLE.imgLastNodeMinus+" border=0>":"<img src="+TREENODESTYLE.imgLastNodePlus+" border=0>")+"</a>"+Result;
	}else{
		if(CannotExpand)
			Result = "<img src="+TREENODESTYLE.imgNode+">"+Result;
		else
			Result = "<a href=\"javascript:"+this.refName+".ExpandNode("+node.id+")\">"
				+(node.isExpanded?"<img src="+TREENODESTYLE.imgNodeMinus+" border=0>":"<img src="+TREENODESTYLE.imgNodePlus+" border=0>")+"</a>"+Result;
	}

	var now = node.parent;
	for(i=indent_level-1; i>0; i--){
		if(now == null)
			break;
		Result = "<img src="+(now.nextSibling == null?TREENODESTYLE.imgBlank:TREENODESTYLE.imgVertLine)+">"+Result;
		now = now.parent;
	}
	return Result;
}

/***********************************************
功能：画节点的内容
参数：
	node：节点对象
	indent_level：缩进级别
***********************************************/
function TreeFunc_DrawNodeInnerHTML(node, indent_level)
{
	var Result;
	var isEnd = false;
	if (this.OnNodeQueryDraw!=null){
		Result = this.OnNodeQueryDraw(node)
		if (typeof(Result)=="string")
			isEnd = true;
	}
	if(!isEnd){
		Result = "<table id='TVN_"+node.id+"' cellpadding=0 cellspacing=0 border=0><tr>"
			+"<td valign=middle nowrap>"+this.DrawNodeIndentHTML(node, indent_level)+"</td>"
			+"<td valign=middle nowrap "+(this.currentNodeID==node.id?"class=TVN_TreeNode_Current":"")+">";
		if((node.isShowCheckBox==true || node.isShowCheckBox==null && this.isShowCheckBox==true) && node.value!=null)
			var ChkStr = "<input onClick='"+this.refName+".SelectNode("+node.id+")' type="+(this.isMultSel?"checkbox":"radio")
				+" id='CHK_"+node.id+"' value=\""+Com_HtmlEscape(node.value)+"\" name=List_Selected "+(node.isChecked?"Checked":"")+">";
		else
			var ChkStr = "";
		Result += "<a lks_nodeid="+node.id+" title=\""+Com_HtmlEscape(node.title)+"\" href=\"javascript:void(0)\" onClick=\""+this.refName+".ClickNode("+node.id+");\"";
		if(this.DblClickNode!=null)
			Result += " ondblclick=\""+this.refName+".DblClickNode("+node.id+");\"";
		Result += ">"+ChkStr+Com_HtmlEscape(node.text)+"</a>";
		Result += "</td></tr></table>";
		if (this.OnNodePostDraw!=null){
			var tmpStr = this.OnNodePostDraw(node,Result)
			if (typeof(tmpStr)=="string")
				Result = tmpStr;
		}
	}
	if(TREENODESTYLE.isOneoff)
		Tree_ResumeStyle();
	return Result;
}

/***********************************************
功能：画节点的所有内容（包括子节点）
参数：
	node：节点对象
	indent_level：缩进级别
	Visible：是否可见
***********************************************/
function TreeFunc_DrawNodeOuterHTML(node, indent_level, Visible){
	if(!Visible)
		return "";
	if(node.isExpanded){
		node.CheckFetchChildrenNode();
		if(this.noHTMLCache || node.isExpandedHTMLDirty)
			node.outerHTMLExpanded = this.DrawNodeInnerHTML(node, indent_level);
		node.isExpandedHTMLDirty = false;
		return node.outerHTMLExpanded;
	}else{
		if(this.noHTMLCache || node.isCollapsedHTMLDirty)
			node.outerHTMLCollapsed = this.DrawNodeInnerHTML(node, indent_level);
		node.isCollapsedHTMLDirty = false;
		return node.outerHTMLCollapsed;
	}
}

/***********************************************
功能：展开节点
参数：
	node：节点ID或对象
***********************************************/
function TreeFunc_ExpandNode(node){
	if(typeof(node)=="number")
		node = Tree_GetNodeByID(this.treeRoot, node);
	if(node == null)
		return;
	if (this.OnNodeQueryExpand!=null)
		if (this.OnNodeQueryExpand(node)==false)
			return;
	node.isExpanded = !node.isExpanded;
	var indent_level=0;
	for(var now=node; now.parent!=null; now=now.parent)
		indent_level++;
	var element = document.getElementById("TVN_"+node.id);
	if(node.isExpanded){
		if(element!=null)
			Com_SetOuterHTML(element, this.DrawNode(node, indent_level, true));
	}else{
		if(element!=null)
			Com_SetOuterHTML(element, this.DrawNodeOuterHTML(node, indent_level, true));
		TreeFunc_HideChildren(node);
	}
	if (this.OnNodePostExpand!=null)
		this.OnNodePostExpand(node);
}

/***********************************************
功能：获取所有选定的节点
返回：对象数组
***********************************************/
function TreeFunc_GetCheckedNode(){
	if(!this.isMultSel)
		return this.lastCheckedNode;
	var Result = new Array;
	TreeFunc_GetChildCheckedNode(this.treeRoot, Result);
	return Result;
}

function TreeFunc_GetCurrentNode(){
	if(this.currentNodeID==-1)
		return null;
	return Tree_GetNodeByID(this.treeRoot, this.currentNodeID);
}
/***********************************************
功能：获取节点中子节点的选定的节点
***********************************************/
function TreeFunc_GetChildCheckedNode(node, Result){
	if(node.isChecked){
		Result[Result.length] = node;
		if(node.treeView.isAutoSelectChildren)
			node.CheckFetchChildrenNode();
	}
	for(var now=node.firstChild; now!=null; now=now.nextSibling)
		TreeFunc_GetChildCheckedNode(now, Result)
}

/***********************************************
功能：隐藏子节点
***********************************************/
function TreeFunc_HideChildren(node){
	var element;
	for(var now=node.firstChild; now!=null;now = now.nextSibling){
		element = document.getElementById("TVN_"+now.id);
		if(element != null)
			Com_SetOuterHTML(element, "");
		if(now.isExpanded)
			TreeFunc_HideChildren(now);
	}
}

/***********************************************
功能：选中节点
参数：
	node：节点ID或对象
***********************************************/
function TreeFunc_SelectNode(node){
	Com_EventStopPropagation();
	if(typeof(node)=="number")
		node = Tree_GetNodeByID(this.treeRoot, node);
	if(node == null)
		return;
	return this.SetNodeChecked(node, "remain");
}

/***********************************************
功能：将节点设为当前节点
参数：
	node：节点ID或对象
***********************************************/
function TreeFunc_SetCurrentNode(node){
	if(typeof(node)=="number")
		node = Tree_GetNodeByID(this.treeRoot, node);
	if(node == null)
		return;
	if (this.currentNodeID==node.id)
		return;
	var now;
	var indent_level;
	var element;
	var CurNode;
	if (this.currentNodeID==-1){
		this.currentNodeID=node.id;
	}else{
		CurNode = Tree_GetNodeByID(this.treeRoot,this.currentNodeID);
		if(CurNode==null){
			this.currentNodeID=node.id;
		}else{
			now = CurNode;
			for(indent_level = 0;now.parent != null;now = now.parent)
				indent_level++;
			element = document.getElementById("TVN_"+this.currentNodeID);
			this.currentNodeID=node.id;
			Tree_SetNodeHTMLDirty(CurNode);
			if(element!=null){
				element.rows[0].cells[1].className = "";
			}
		}
	}
	now = Tree_GetNodeByID(this.treeRoot,this.currentNodeID);
	for(indent_level = 0;now.parent != null;now = now.parent){
		if(!now.parent.isExpanded)
			this.ExpandNode(now.parent.id);
		indent_level++;
	}
	element = document.getElementById("TVN_"+this.currentNodeID);
	Tree_SetNodeHTMLDirty(node);
	if(element!=null)
		element.rows[0].cells[1].className = "TVN_TreeNode_Current";
}

/***********************************************
功能：设置节点是否被选中
参数：
	node：节点ID或对象
	optType：操作类型，可为以下的值
		布尔型：设置是否选中
		字符串：
			reverse：反选
			remain：保留原有状态
***********************************************/
function TreeFunc_SetNodeChecked(node, optType){
	if(typeof(node)=="number")
		node = Tree_GetNodeByID(this.treeRoot, node);
	if(node == null)
		return false;
	var checked;
	var element = document.getElementById("CHK_"+node.id);
	switch(optType){
	case "reverse":
		checked = !element.checked;
		break;
	case "remain":
		checked = element.checked;
		break;
	default:
		checked = optType;
	}
	var isChanged = node.isChecked != checked;
	if(element!=null)
		element.checked = node.isChecked;
	if(!isChanged)
		return true;
	if (this.OnNodeCheckedQueryChange!=null)
		if (this.OnNodeCheckedQueryChange(node, optType)==false)
			return false;
	if(element!=null)
		element.checked = checked;
	node.isChecked = checked;
	if(this.isMultSel){
		if(this.isAutoSelectChildren)
			for(var now=node.firstChild; now!=null; now=now.nextSibling)
				this.SetNodeChecked(now, checked);
	}else{
		if(this.lastCheckedNode != null && this.lastCheckedNode!=node){
			this.lastCheckedNode.isChecked = false;
			element = document.getElementById("CHK_"+this.lastCheckedNode.id);
			if(element!=null)
				element.checked = false;
			Tree_SetNodeHTMLDirty(this.lastCheckedNode);
		}
		this.lastCheckedNode = node;
	}
	Tree_SetNodeHTMLDirty(node);
	if (this.OnNodeCheckedPostChange!=null)
		this.OnNodeCheckedPostChange(node);
	return true;
}

/***********************************************
功能：设置目录树的根节点
参数：
	path：路径
	SepStr：可选，路径分隔符，默认为\
***********************************************/
function TreeFunc_SetTreeRoot(path, SepStr)
{
	var node = Tree_GetNodeByPath(this.treeRoot, path, SepStr);
	if(node != null){
		this.treeRoot = node;
		node.parent = null;
		node.prevSibling = null;
		node.nextSibling = null;
	}
}

/***********************************************
功能：展现目录树
***********************************************/
function TreeFunc_Show(){
	var noCache = this.noHTMLCache;
	this.noHTMLCache = true;
	if(TREENODESTYLE.isOneoff==null)
		Tree_ResumeStyle();
	var Result = this.DrawNode(this.treeRoot, 0, true);
	this.DOMElement.innerHTML = Result;
	this.noHTMLCache = noCache;
}

/***********************************************
功能：重置树节点样式
***********************************************/
function Tree_ResumeStyle(){
	TREENODESTYLE.imgVertLine = IMGPATHPREFIX+"vertline.gif";
	TREENODESTYLE.imgNode = IMGPATHPREFIX+"node.gif";
	TREENODESTYLE.imgDeptNode = IMGPATHPREFIX+"dept.gif";
	TREENODESTYLE.imgOrgNode = IMGPATHPREFIX+"org.gif";
	TREENODESTYLE.imgCategoryNode = IMGPATHPREFIX+"category.gif";
	TREENODESTYLE.imgOpenCategoryNode = IMGPATHPREFIX+"opencategory.gif";
	TREENODESTYLE.imgCategoryParentNode = IMGPATHPREFIX+"categoryparent.gif";
	TREENODESTYLE.imgOpenCategoryParentNode = IMGPATHPREFIX+"opencategoryparent.gif";
	TREENODESTYLE.imgCategorySonNode = IMGPATHPREFIX+"categoryson.gif";
	TREENODESTYLE.imgOpenCategorySonNode = IMGPATHPREFIX+"opencategoryson.gif";
	TREENODESTYLE.imgTemplateNode = IMGPATHPREFIX+"template.gif";
	TREENODESTYLE.imgPersonNode = IMGPATHPREFIX+"person.gif";
	TREENODESTYLE.imgNodePlus = IMGPATHPREFIX+"nodeplus.gif";
	TREENODESTYLE.imgNodeMinus = IMGPATHPREFIX+"nodeminus.gif";
	TREENODESTYLE.imgLastNode = IMGPATHPREFIX+"lastnode.gif";
	TREENODESTYLE.imgLastNodePlus = IMGPATHPREFIX+"lastnodeplus.gif";
	TREENODESTYLE.imgLastNodeMinus = IMGPATHPREFIX+"lastnodeminus.gif";
	TREENODESTYLE.imgOpenedFolder = IMGPATHPREFIX+"openfolder.gif";
	TREENODESTYLE.imgClosedFolder = IMGPATHPREFIX+"closedfolder.gif";
	TREENODESTYLE.imgBlank = IMGPATHPREFIX+"blank.gif";
	TREENODESTYLE.imgLeaf = IMGPATHPREFIX+"link.gif";
	TREENODESTYLE.imgCubeChildNode = IMGPATHPREFIX+"cubeChild.gif";
	TREENODESTYLE.isOneoff = false;
}

/***********************************************
功能：将节点记录的HTML代码设置为需要重新计算的
***********************************************/
function Tree_SetNodeHTMLDirty(node){
	if(node!=null){
		node.isExpandedHTMLDirty = true;
		node.isCollapsedHTMLDirty = true;
	}
}

/***********************************************
功能：显示目录树上方的锁定图标
***********************************************/
Tree_FrameIsLock = true;
function Tree_DrawLockIcon(){
	var newElem = document.createElement("INPUT");
	newElem.type = "image";
	newElem.src = Com_Parameter.StylePath+"tree/lock_yes.gif";
	newElem.className = "lockicon";
	newElem.onclick = function (){
		Tree_FrameIsLock = !Tree_FrameIsLock;
		this.src = Com_Parameter.StylePath+"tree/lock_"+(Tree_FrameIsLock?"yes":"no")+".gif";
		Com_RunMainFrameFunc("Frame_FireHideEvent", Tree_FrameIsLock);
		this.blur();
	};
	document.body.appendChild(newElem);
}

function TreeFunc_GetUrlDNS(url){
	var i = url.indexOf("?");
	if(i>-1)
		url = url.substring(0, i);
	i = url.indexOf("://");
	if(i==-1)
		return null;
	for(i+=3; i<url.length; i++)
		if(url.charAt(i)!="/")
			break;
	i = url.indexOf("/", i);
	if(i==-1)
		return url;
	return url.substring(0, i);
}

/***********************************************
功能：添加简单类别展开树-模块维护
参数：
	modelName:必填，当前的域模型名称
	managerParameter:必填，节点action参数，管理员权限、类别维护人员权限
	optParameter:必填，节点action参数，扩充权限
	action：可选，函数对象，节点的操作
	startWith：展开分类根节点ID
	exceptValue：可选，字符串或数组，不显示的节点
	extProps :可选，其他参数判断，多个值以;号隔开 例如：extProps=fdTemplateType:1;fdTemplateType:3
说明：
	由该函数创建的节点，节点.value=类别ID，节点.name=类别名称
	一般的，调用该函数时，action不需要进行设置，parameter设置为URL或URL+目标帧的数组或URL+目标帧+窗口风格的数组的形式，这样，程序会自动调用Com_OpenWindow的方法打开指定的URL，同样，URL采用参数替换的形式。
	add by yirf
	date：2014-07-22			
***********************************************/
function NodeFunc_AppendSimpleCategoryDataWithAdmin(modelName,managerParameter,optParameter,action, startWith,exceptValue, extendService,extProps){
	if(modelName==null || modelName=="") return;
	if(managerParameter==null || managerParameter=="") return;
	if(optParameter==null || optParameter=="") return;
	var cateUrl = 'sysSimpleCategoryTreeService'+(extendService!=null?';'+extendService:'')+'&authType=' + this.authType + '&categoryId=!{value}'+'&extProps='+extProps;
	cateUrl+='&modelName=' + modelName;
	if(extendService!=null){
		cateUrl += "&extendService="+encodeURIComponent(extendService);
	}
	if(typeof(managerParameter)=="string" && managerParameter.indexOf("nodeType")==-1) {
		managerParameter += "&nodeType=!{nodeType}";
	}
	if(typeof(optParameter)=="string" && optParameter.indexOf("nodeType")==-1) {
		optParameter += "&nodeType=!{nodeType}";
	}
	this.AppendBeanData(cateUrl, managerParameter, action, true, exceptValue);
	this.FetchChildrenNode = SimpleCategoryNodeFunc_FetchChildrenNode;
	this.optParameter = optParameter;
	this.managerParameter = managerParameter;
	if(startWith!=null)
		this.value = startWith;
}
function SimpleCategoryNodeFunc_FetchChildrenNode(){
	if(this.authIds == null && this.authRole != "optAll"){
		var modelName = Com_GetUrlParameter(this.XMLDataInfo.beanURL,"modelName");
		this.authIds = new KMSSData().AddBeanData("sysSimpleCategoryAuthList&modelName="+modelName+"&authType=01").GetHashMapArray();
	}
	var nodesValue = new KMSSData().AddXMLData(Com_ReplaceParameter(this.XMLDataInfo.beanURL, this)).GetHashMapArray();
	for(var i=0; i<nodesValue.length; i++){
		if(this.authRole == "optAll"){
			if(nodesValue[i]["isShowCheckBox"]=="0" || nodesValue[i]["href"] == ""){
				nodesValue[i]["href"] = null;
				nodesValue[i]["isShowCheckBox"] = null;
				this.XMLDataInfo.parameter = this.optParameter;
			}else{
				this.XMLDataInfo.parameter = this.managerParameter;
			}
			var treeNode = this.FetchChildrenUseXMLNode(nodesValue[i]);
			treeNode.FetchChildrenNode = SimpleCategoryNodeFunc_FetchChildrenNode;
			treeNode.authRole = this.authRole;
			treeNode.optParameter = this.optParameter;
			treeNode.managerParameter = this.managerParameter;
		}else if(category_CheckAuth(nodesValue[i],this.authIds,true)){
			var treeNode = this.FetchChildrenUseXMLNode(nodesValue[i]);
			treeNode.FetchChildrenNode = SimpleCategoryNodeFunc_FetchChildrenNode;
			treeNode.authIds = this.authIds;
		}
	}
}

function category_CheckAuth(nodeValue,authIds,checkShowCheckBox){
	if(checkShowCheckBox){
		if(nodeValue["isShowCheckBox"]!="0"){
			return true;
		}
	}
	var value = nodeValue["value"];
	for(var i=0; i<authIds.length; i++){
		if(authIds[i]["v"]==value){
			return true;
		}
	}
	return false;
}

/***********************************************
功能：添加类别展开树-模块维护
参数：
	modelName:必填，当前的域模型名称
	managerParameter:必填，节点action参数，管理员权限、类别维护人员权限
	optParameter:必填，节点action参数，扩充权限
	showTemplate: 可选，是否显示模板，0不显示，1 显示模板，类别不可选择，2 显示模板并且类别可选择 默认是2
	showType:可选,显示方式,0显示子场所分类,1只显示父场所分类,2只显示父场所分类和子场所分类
	action：可选，函数对象，节点的操作
	startWith：展开分类根节点ID
	exceptValue：可选，字符串或数组，不显示的节点
说明：
	由该函数创建的节点，节点.value=类别ID，节点.name=类别名称
	一般的，调用该函数时，action不需要进行设置，parameter设置为URL或URL+目标帧的数组或URL+目标帧+窗口风格的数组的形式，这样，程序会自动调用Com_OpenWindow的方法打开指定的URL，同样，URL采用参数替换的形式。
***********************************************/
function NodeFunc_AppendCategoryDataWithAdmin(modelName, managerParameter,optParameter, showTemplate,showType,action, startWith,exceptValue, extendPara){
	if(modelName==null || modelName=="") return;
	if(managerParameter==null || managerParameter=="") return;
	if(optParameter==null || optParameter=="") return;
	if(showTemplate==null) showTemplate = 2;
	if(showType==null) showType = "0";
	var cateUrl = "sysCategoryTreeService&showType=" + showType + "&authType=" + this.authType + "&categoryId=!{value}&modelName="+modelName;
	if(extendPara!=null){
		cateUrl += "&extendPara="+encodeURIComponent(extendPara);
	}
	if(typeof(managerParameter)=="string" && managerParameter.indexOf("nodeType")==-1) {
		managerParameter += "&nodeType=!{nodeType}";
	}
	if(typeof(optParameter)=="string" && optParameter.indexOf("nodeType")==-1) {
		optParameter += "&nodeType=!{nodeType}";
	}
	if(showTemplate) cateUrl += "&getTemplate=" + showTemplate;
	this.AppendBeanData(cateUrl, managerParameter, action, true, exceptValue);
	this.FetchChildrenNode = CategoryNodeFunc_FetchChildrenNode;
	this.optParameter = optParameter;
	this.managerParameter = managerParameter;
	if(startWith!=null)
		this.value = startWith;
}
function CategoryNodeFunc_FetchChildrenNode(){
	if(this.nodeType != "TEMPLATE"){
		var beanUrl;
		if(this.authIds == null){
			var modelName = Com_GetUrlParameter(this.XMLDataInfo.beanURL,"modelName");
			beanUrl = "sysCategoryAuthListService&modelName="+modelName+"&getTemplate=2";
			if(this.authRole == "optAll"){
				beanUrl += "&nohierarchyId=true";
			}
			this.authIds = new KMSSData().AddBeanData(beanUrl).GetHashMapArray();
		}
		beanUrl = Com_ReplaceParameter(this.XMLDataInfo.beanURL, this);
		if(this.authRole == "optAll"){
			beanUrl = Com_SetUrlParameter(beanUrl,"authType","00");
		}
		var nodesValue = new KMSSData().AddXMLData(beanUrl).GetHashMapArray();
		for(var i=0; i<nodesValue.length; i++){
			if(this.authRole == "optAll"){
				var treeNode;
				if(this.manageList || category_CheckAuth(nodesValue[i],this.authIds)){
					this.XMLDataInfo.parameter = this.managerParameter;
					treeNode = this.FetchChildrenUseXMLNode(nodesValue[i]);
					treeNode.manageList = true;
				}else{
					this.XMLDataInfo.parameter = this.optParameter;
					treeNode = this.FetchChildrenUseXMLNode(nodesValue[i]);
				}
				treeNode.FetchChildrenNode = CategoryNodeFunc_FetchChildrenNode;
				treeNode.authIds = this.authIds;
				treeNode.authRole = this.authRole;
				treeNode.optParameter = this.optParameter;
				treeNode.managerParameter = this.managerParameter;
			}else if(category_CheckAuth(nodesValue[i],this.authIds,true)){
				var treeNode = this.FetchChildrenUseXMLNode(nodesValue[i]);
				treeNode.FetchChildrenNode = CategoryNodeFunc_FetchChildrenNode;
				treeNode.authIds = this.authIds;
				if(treeNode["isShowCheckBox"]=="0" || treeNode["href"] == ""){
					treeNode.authType = "01";
				}else{
					treeNode.authType = "00";
					if(treeNode.nodeType != "TEMPLATE"){
						treeNode.XMLDataInfo.beanURL = Com_SetUrlParameter(this.XMLDataInfo.beanURL,"authType",treeNode.authType);
					}
				}
			}
		}
	}
}
//=============================以上函数仅供内部使用，普通模块请勿调用==============================
