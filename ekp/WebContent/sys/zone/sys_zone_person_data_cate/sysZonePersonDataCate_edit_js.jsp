<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<script type="text/javascript">
window.CKEDITOR_BASEPATH='${LUI_ContextPath}/resource/ckeditor/';
</script>
<script type="text/javascript">
	Com_IncludeFile("ckfilter.js|ckeditor.js", "ckeditor/");
</script>
<script src="${LUI_ContextPath}/resource/js/session.jsp"></script>

<script>
Com_IncludeFile("doclist.js|validation.js|dialog.js");
var validations = {
		'noSpecialChar':
		{
			error:"<span style='color:#cc0000;'>名称</span>&nbsp;不能包含特殊字符",
			test:function(v,e,o) {
				//过滤特殊字符
				var pattern = new RegExp("[`~!@#$^&*()=|{}':;',\\[\\].<>/?~！@#￥……&*（）&;—|{}【】‘；：”“'。，、？]");
				v = $.trim(v);
				if(pattern.test(v)) {
					return false;
				}
				return true;
			}
		},
		'limitLength':
		{
			error:"<span style='color:#cc0000;'>名称</span>&nbsp;长度不能大于50个字符",
			test:function(v,e,o) {
				//长度限制
				v = $.trim(v);
				if(v.length > 50) {
					return false;
				}
				return true;
			}
		},
		'checkNameOnly'://校验有提示，但是保存操作可以继续，待解决？？
		{
			error:"<span style='color:#cc0000;'>名称</span>&nbsp;不能重复",
			test:function(v,e,o) {
				//名称重复（明细表自身判断）
				v = $.trim(v);
				//获取所有行的目录名（除了本身）
				var	optTR = getParentByTagName("TR");
				var optTB = getParentByTagName("TABLE", optTR);
				var $optTB = $(optTB);
				//table总行数
				var tbRows = $optTB.find("tr").length;
				//当前操作的行索引
				var rowIndex = getIndex(optTB.rows, optTR);
				for(var i = 1; i < tbRows; i++) {
					if( i == rowIndex) {
						continue;
					}
					var fdName = $("input[name='fdDataCateTemplForms[" + (i-1) + "].fdName']").val();
					if(fdName == v) {
						return false;
					}
				}
				//数据库判断
				v = encodeURI(v);
				var propertyName = $(e).attr("name");
				var fdName = propertyName.substring(propertyName.lastIndexOf(".") + 1, propertyName.length);
				propertyName = propertyName.substring(0,propertyName.lastIndexOf("."));
				//明细表每行的fdId（编辑的时候，用于过滤本身）
				var fdId = $("input[name='" + propertyName + ".fdId']").val();
				var data = new KMSSData();
				data.UseCache = false;
				data.AddBeanData("sysZoneCheckNameOnlyService&fdId="+ fdId +"&beanName=sysZonePerDataTemplService&fieldName=" + fdName +"&fieldValue="+v);
				var retVal = data.GetHashMapArray();
				if(retVal[0]['size']>0){
					return false;
				}
				return true;
			}
		}	
	};
//$KMSSValidation(document.forms['sysZonePersonDataCateForm']).addValidators(validations);
$KMSSValidation().addValidators(validations);
</script>    
<style>
.lui_zone_ck_edit div{ margin: 2px auto;}
</style>
<script>
function contentBase64() {
	seajs.use(['lui/jquery'], function($) {
			$("form[name='sysZonePersonDataCateForm'] .content_mark")
				.each(function(){
						var $obj = $(this);
						 $obj.val(base64Encode($obj.val()));
				});
	});
}


function edit_templ_content(obj) {
	var self = obj;
	var editor;
	seajs.use( ['lui/dialog','lui/jquery'], function(dialog, $) {
		var $obj = $(self);
		var name = $obj.attr("name").substring(1);
		var _contentEle = $("[name='" + name +"']");
		var _content = _contentEle.val();
	    var dia = dialog.build({
			id : 'editDiv',
			config : {
				height: 550,
				width:  800,
				lock : true,
				cache : false,
				title : "编辑内容",
				content : {
					type : "html",
					html : ['<div class="lui_zone_ck_edit" >',
							'<textarea  id="_editContent" style="width:800px;height:389px;overflow: hidden;">',_content,
							'</textarea>',
							'</div>'
						   ].join(" "),
				    iconType : "",
				    buttons : [ {
						name : "${lfn:message('button.ok')}",
						value : true,
						focus : true,
						fn : function(value,_dialog) {
							if(editor) {
								editor.destroy();
								var s = $("#_editContent");
								_contentEle.html(s.val());
							}
							_dialog.hide();
						}
				    }, {
						name : "${lfn:message('button.cancel')}",
						value : false,
						fn : function(value, _dialog) {
							_dialog.hide();
						}
					} ]
				}
			},

			callback : function(value, dialog) {
			}
		});
	    dia.content.on("layoutDone",  function() {
	    	var replace = document.getElementById("_editContent");
	    	editor = CKEDITOR.replace(replace, {"toolbarStartupExpanded":false,
				 						"toolbar":"Default",
				 						"height":"300",
				 						"width":"99%",
				 						"toolbarCanCollapse":"true"});
	    	CKFilter.addReplaceFilter('_editContent',true);
		});
	    dia.show();
	});
}
/** 
 * 是否删除 
 */
function delete_row(obj) {
	seajs.use( [ 'sys/ui/js/dialog' ], function(dialog) {
		dialog.confirm('删除该目录，将会删除对应所有黄页员工的此目录内容！', function(value) {
			if(value) ___toDelRow(obj);
		});
	});
}
/**
 * 删除行
 */
function ___toDelRow(obj){
	var optTR = getParentByTagName("TR", obj);
	var optTB = getParentByTagName("TABLE", optTR);
	var $optTB = $(optTB);
	//table总行数（删除前）
	var tbRows = $optTB.find("tr").length;
	//当前操作的行索引
	var rowIndex = getIndex(optTB.rows, optTR);
	if((tbRows - 1) == rowIndex) {
		//如果是最后一行
		//do nothing
	} else {
		//操作中间行
		//操作第一行
		for(var i = rowIndex; i <= (tbRows-2); i++) {
			$("input[name='fdDataCateTemplForms[" + i + "].fdOrder']").val(i-1);
		}
	}
	__docList_DeleteRow(optTR, optTB);
}
function __docList_DeleteRow(optTR, optTB){
	var tbInfo = DocList_TableInfo[optTB.id];
	var rowIndex = Com_ArrayGetIndex(optTB.rows, optTR);
	optTB.deleteRow(rowIndex);
	
	tbInfo.lastIndex--;
	for(var i = rowIndex; i<tbInfo.lastIndex; i++)
		DocListFunc_RefreshIndex(tbInfo, i);
}
/**
 * 上移
 */
 function up_row(optTR) {
	 if(optTR==null)
			optTR = getParentByTagName("TR");
	 var optTB = getParentByTagName("TABLE", optTR);
	 ////当前操作的行索引
	 var rowIndex = getIndex(optTB.rows, optTR);
	 if(rowIndex == 1) {
		 DocList_MoveRow(-1);
		 return;
	 }
	 $("input[name='fdDataCateTemplForms[" + (rowIndex-1) + "].fdOrder']").val((rowIndex-2));
	 $("input[name='fdDataCateTemplForms[" + (rowIndex-2) + "].fdOrder']").val((rowIndex-1));
	 DocList_MoveRow(-1);
}
 /**
  * 上移
  */
  function down_row(optTR) {
 	 if(optTR==null)
 			optTR = getParentByTagName("TR");
 	 var optTB = getParentByTagName("TABLE", optTR);
 	 ////当前操作的行索引
 	 var $optTB = $(optTB);
 	 var rowIndex = getIndex(optTB.rows, optTR);
 	 var tbRows = $optTB.find("tr").length;
 	 if(rowIndex == (tbRows-1)) {
 		 DocList_MoveRow(1);
 		 return;
 	 }
 	 $("input[name='fdDataCateTemplForms[" + (rowIndex-1) + "].fdOrder']").val((rowIndex));
 	 $("input[name='fdDataCateTemplForms[" + (rowIndex) + "].fdOrder']").val((rowIndex-1));
     DocList_MoveRow(1);
 }
/**
 * 获取行
 */
function getParentByTagName(tagName, obj) {
	if(obj==null){
		if(Com_Parameter.IE) {
			obj = event.srcElement;
		}
		else {
			obj = Com_GetEventObject().target;
		}
	}
	for(; obj!=null; obj = obj.parentNode) {
		if(obj.tagName == tagName) {
			return obj;
		}
	}
}
/**
 * 获取索引
 */
function getIndex(arr, key){
	for(var i=0; i<arr.length; i++)
		if(arr[i]==key)
			return i;
	return -1;
}
</script>