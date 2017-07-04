<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/common.jsp"%>
<script language="JavaScript">
	Com_IncludeFile("dialog.js|doclist.js|data.js");
</script>
<script type="text/javascript">
	var this$; 
	var _dialog;
	seajs.use(['lui/jquery','lui/dialog'],function($,dialog) {
		this$ = $;
		_dialog = dialog;
	});

	var catelogJson = [];
	catelogJson = top.catelogJson;
	// 兼容多浏览器
	/*
	if (typeof (top.dialogArguments) != 'undefined') {
		catelogJson = top.dialogArguments;
	} else if (typeOf(top.opener) != 'undefined') {
		catelogJson = top.opener;
	}*/

	//初始化加载
	window.onload = function() {
		setTimeout("init()", 200);// 延迟初始化阶段工作(必须延迟不然添加行报错)
	}

	//初始化目录
	function init() {
		for ( var i = 0; i < catelogJson.length; i++) {
			var catelog = catelogJson[i];
			if (catelog != null) {
				DocList_AddRow('TABLE_DocList');//增加一行
				GetEl("fdCatelogList[" + i + "].fdId").value = catelog.fdId;
				GetEl("fdCatelogList[" + i + "].fdName").value = catelog.fdName;
				GetEl("fdCatelogList[" + i + "].fdOrder").value = catelog.fdOrder;
				GetEl("fdCatelogList[" + i + "].docContent").value = catelog.docContent;
				GetEl("fdCatelogList[" + i + "].fdParentId").value = catelog.fdParentId;
				GetEl("fdCatelogList[" + i + "].authEditorIds").value = catelog.authEditorIds;
				GetEl("fdCatelogList[" + i + "].authEditorNames").value = catelog.authEditorNames;
			}
		}
	}

	//全选
	function changeSelectAll(thisObj) {
		var selectObj = GetEls("fdCatelogList_seclect");
		if (thisObj.checked == true) {
			//全选
			if (selectObj != null) {
				for ( var i = 0; i < selectObj.length; i++) {
					selectObj[i].checked = true;
				}
			}
		} else {
			//取消全选
			for ( var i = 0; i < selectObj.length; i++) {
				selectObj[i].checked = false;
			}
		}
	}

	//选择行
	function changeSelect(thisObj) {
		var selectAllObj = GetEls("fdCatelogList_seclectAll");
		if (thisObj.checked == true) {
			var isAll = true;
			var selectObj = GetEl("fdCatelogList_seclect");
			for ( var i = 0; i < selectObj.length; i++) {
				if (selectObj[i].checked == false) {
					isAll = false;
					break;
				}
			}
			selectAllObj.checked = isAll;
		} else {
			selectAllObj.checked = false;
		}
	}

	//添加
	function add_Row() {
		DocList_AddRow('TABLE_DocList'); //添加行
		var url = "kmsWikiGenerateId";//获取ID
		var data = new KMSSData();
		data.SendToBean(url, getGenerateID);
	}

	//增行生成id
	function getGenerateID(rtnData) {
		if (rtnData.GetHashMapArray().length >= 1) {
			var obj = rtnData.GetHashMapArray()[0];
			var fdId = obj['fdId'];
			var index = GetID('TABLE_DocList').rows.length - 1;
			GetEl("fdCatelogList[" + (index - 1) + "].fdId").value = fdId;
		}
	}

	//上移
	function move_Row(val) {
		var selectObj = GetEls("fdCatelogList_seclect");
		var n = 0;
		for ( var i = 0; i < selectObj.length; i++) {
			if (selectObj[i].checked == true) {
				n++;//计算选中的个数。
				if (n > 1) {
					_dialog.alert("${lfn:message('kms-wiki:kmsWikiCatelogTemplate.onlyOne')}");
					return false;
				}
			}
		}
		if (n == 0) {
			_dialog.alert("${lfn:message('kms-wiki:kmsWikiCatelogTemplate.noOne')}");
			return false;
		}
		for ( var i = 0; i < selectObj.length; i++) {
			if (selectObj[i].checked == true) {
				DocList_MoveRow(val, selectObj[i].parentNode.parentNode);
				break;
			}
		}
	}

	//删除
	function delete_Row() {
		var delArr = [], m = 0, selectObj = GetEls("fdCatelogList_seclect");
		// 遍历所有需要删除行
		for ( var i = 0; i < selectObj.length; i++) {
			if (selectObj[i].checked == true) {
				delArr[m] = selectObj[i].parentNode.parentNode;
				m++;
			}
		}
		if (delArr == 0) {
			_dialog.alert("${lfn:message('kms-wiki:kmsWikiCatelogTemplate.noOne')}");
			return false;
		}
		_dialog.confirm('<bean:message key="page.comfirmDelete"/>',function(value, dialog) {
				if (value == true) {
					for ( var i = 0; i < delArr.length; i++) {
						DocList_DeleteRow(delArr[i]);
					}
					dialog.hide();
				}
			}
	   	);
		
	}

	//选择可编辑者
	function selectEditors(thisObj) {
		var idObj;
		var nameObj;
		idObj = this$(thisObj).find('input').attr('name');
		nameObj = this$(thisObj).find('textarea').attr('name');
		Dialog_Address(true, idObj, nameObj, ';', 'ORG_TYPE_ALL');
		
	}

	//提交
	function kmsWikiCatelog_doOk() {
		catelogJson = []; //清空json,重新拼装
		//拼装json
		var index = GetID('TABLE_DocList').rows.length - 1;
		for ( var i = 0; i < index; i++) {
			var _fdId = GetEl("fdCatelogList[" + i + "].fdId").value;
			var _fdName = GetEl("fdCatelogList[" + i + "].fdName").value;
			var _docContent = GetEl("fdCatelogList[" + i + "].docContent").value;
			var _fdParentId = GetEl("fdCatelogList[" + i + "].fdParentId").value;
			var _authEditorIds = GetEl("fdCatelogList[" + i + "].authEditorIds").value;
			var _authEditorNames = GetEl("fdCatelogList[" + i
					+ "].authEditorNames").value;
			catelogJson[i] = {
				fdId : _fdId,
				fdName : _fdName,
				fdOrder : i + 1,
				docContent : _docContent,
				fdParentId : _fdParentId,
				authEditorIds : _authEditorIds,
				authEditorNames : _authEditorNames
			};
		}
		// 兼容多浏览器
		top.returnValue = catelogJson;
		top.opener = top;
		top.open("", "_self");
		top.close();
	}

	//公共方法---获取对象
	function GetEl(element) {
		return document.getElementsByName(element)[0];
	}

	//公共方法---获取对象数组
	function GetEls(element) {
		return document.getElementsByName(element);
	}

	//公共方法---获取对象
	function GetID(id) {
		return document.getElementById(id);
	}
</script>
