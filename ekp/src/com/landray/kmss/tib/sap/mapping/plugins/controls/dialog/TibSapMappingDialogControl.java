package com.landray.kmss.tib.sap.mapping.plugins.controls.dialog;

import static com.landray.kmss.sys.xform.base.service.controls.TagNodeUtils.filterNode;
import static com.landray.kmss.sys.xform.base.service.controls.TagNodeUtils.isType;
import static com.landray.kmss.sys.xform.base.service.controls.TagNodeUtils.setAttribute;
import static com.landray.kmss.sys.xform.base.service.controls.TagNodeUtils.setTitleAndSubject;

import java.util.List;
import java.util.Stack;

import org.htmlparser.Node;
import org.htmlparser.lexer.Lexer;
import org.htmlparser.nodes.TagNode;
import org.htmlparser.tags.InputTag;
import org.htmlparser.util.ParserException;

import com.landray.kmss.sys.xform.base.service.ISysFormTemplateControl;
import com.landray.kmss.sys.xform.base.service.ISysFormTemplateDetailsTableControl;
import com.landray.kmss.sys.xform.base.service.controls.FilterAction;
import com.landray.kmss.sys.xform.base.service.controls.LoopAction;
import com.landray.kmss.sys.xform.base.service.controls.TagNodeUtils;
import com.landray.kmss.tib.sys.sap.connector.interfaces.ITibSysSapJcoFunctionUtil;
import com.landray.kmss.util.ResourceUtil;
import com.landray.kmss.util.SpringBeanUtil;

/**
 * 连接sap，调用sap中的数据，Dialog控件
 * @author 邱建华 2013-3-7
 * 
 */
public class TibSapMappingDialogControl implements
		ISysFormTemplateControl, FilterAction,
		ISysFormTemplateDetailsTableControl {

	private static final String TYPE = "sapDataByDialog";

	private static final String SQL_QUERY_BEAN = "tibSapMappingShowDataBean";

	public boolean parse(Node node, Lexer lexer, StringBuilder jsp,
			List<ISysFormTemplateControl> controls) throws Exception {
		if (node instanceof TagNode) {
			TagNode tagNode = (TagNode) node;
			if (isType(TYPE, tagNode)) {
				filterNode(tagNode, lexer, jsp, this);
				return true;
			}
		}
		return false;
	}

	private void doParse(Node node, final StringBuilder jsp)
			throws Exception {
		if (node instanceof InputTag) {
			// 定义资源国际化
			String theFirst_lang = ResourceUtil.getString("sapPlugin.controls.theFirst", "tib-sap"); 
			String line_lang = ResourceUtil.getString("sapPlugin.controls.line", "tib-sap"); 
			String emptySelectData_lang = ResourceUtil.getString("sapPlugin.controls.emptySelectData", "tib-sap"); 
			String notEmpty_lang = ResourceUtil.getString("sapPlugin.controls.notEmpty", "tib-sap"); 
			String controlSelected = ResourceUtil.getString("sapPlugin.controls.controlSelected", "tib-sap");
			String tableQueryFail_lang = ResourceUtil.getString("sapPlugin.controls.tableQueryFail", "tib-sap"); 
			String choose_lang = ResourceUtil.getString("sapPlugin.choose", "tib-sap"); 
			InputTag input = (InputTag) node;
			// 控件相关的方法名的唯一性标识后缀,如果在明细表，把!{index}替换成index
			String uniqueId = repalceAll(input.getAttribute("id"));
			// 是否多选
			boolean multi = "true".equals(input.getAttribute("multiSelect"));
			String isLoadData = input.getAttribute("isLoadData");
			// 数据来源(函数的ID)
			String fdRfcSettingId = input.getAttribute("fdRfcSettingId");
			// 获取显示值和描述值
			String _showValue = input.getAttribute("dialogShowValue");
			String _showDesc = input.getAttribute("dialogShowDesc");
			String _showActual = input.getAttribute("dialogActualValue");
			String showValue = _showValue.replaceAll("\\$", "");
			String showDesc = _showDesc.replaceAll("\\$", "");
			String showActual = _showActual.replaceAll("\\$", "");
//			System.out.println("_showValue="+_showValue+"--_showDesc="+_showDesc+"--_showActual="+_showActual);
			// 映射输入参数的JSON
			String inputParamJson = input.getAttribute("inputParams");
			// 增加提交校验方法
			String required = input.getAttribute("_required");
			if (required == null) {
				required = input.getAttribute("required");
			}
			String ESAP_IdField_Dialog = "extendDataFormInfo.value("+ input.getAttribute("id") + ")";
			String ESAP_NameField_Dialog = "extendDataFormInfo.value("+ input.getAttribute("id") + "_name" + ")";
			// 取XML
			ITibSysSapJcoFunctionUtil tibSysSapJcoFunctionUtil = (ITibSysSapJcoFunctionUtil) SpringBeanUtil
				.getBean("tibSysSapJcoFunctionUtil");
			String funcXml = (String) tibSysSapJcoFunctionUtil.getFunctionToXmlById(fdRfcSettingId);
			// 生成隐藏域
			jsp.append("<xform:text");
			setAttribute(jsp, "property", ESAP_IdField_Dialog);
			setAttribute(jsp, "showStatus", "noShow");
			jsp.append("/>");
			// 编辑状态显示只读文本框
			jsp.append("<xform:text");
			setAttribute(jsp, "property", ESAP_NameField_Dialog);
			setTitleAndSubject(jsp, input.getAttribute("label"));
			setAttribute(jsp, "width", input);
			setAttribute(jsp, "style", input);
			setAttribute(jsp, "required", input);
			setAttribute(jsp, "showStatus", "readOnly");
			jsp.append("></xform:text>");
			
			// 引用js
			jsp.append("<script type='text/javascript'>Com_IncludeFile('jquery.js');</script>");
			jsp.append("<script src='<c:url value=\"/tib/common/resource/js/commonFormEvent.js\"/>'></script>");
			jsp.append("<script src='<c:url value=\"/tib/sap/mapping/sapEkpFormEvent.js\"/>'></script>");
			jsp.append("<script src='<c:url value=\"/tib/common/resource/js/sapEkp.js\"/>'></script>");
			jsp.append("<script src='<c:url value=\"/tib/sap/mapping/plugins/controls/common/loadPromptOperation.js\"/>'></script>");
			
			jsp.append("<script type='text/javascript'>");
			// 全局变量
			jsp.append("var ESAP_IdField_Dialog;var ESAP_NameField_Dialog;");
			jsp.append("var ESAP_EkpId_Dialog = new Array();");
			jsp.append("var ESAP_Index_Dialog;");
			jsp.append("var EkpCommon = new EkpCommonFormEvent();");
			jsp.append("var SapForm = new SapFormEvent();");
			
			// js的全部替换字符串方法
			jsp.append(" String.prototype.replaceAll  = function(s1,s2){");
			jsp.append("return this.replace(new RegExp(s1,\"gm\"),s2);}; ");
			if ("true".equals(required)) {
				if (uniqueId.indexOf(".") != -1) {
					jsp.append("Com_Parameter.event[\"submit\"][Com_Parameter.event[\"submit\"].length] = function(){");
					jsp.append("var detailTable_" + uniqueId);
					jsp.append("=\'").append(input.getAttribute("id")).append("\';");
					// 增加非明细表校验控制
					jsp.append("var requiredLen = 1;var detailIndex = detailTable_").append(uniqueId)
							.append(".indexOf(\".!{index}\");")
							.append("if(detailIndex != -1){")
								.append("detailTable_" + uniqueId)
								.append(" = 'TABLE_DL_'+detailTable_").append(uniqueId)
								.append(".substring(0,detailTable_").append(uniqueId)
								.append(".indexOf(\".!{index}\"));")
								.append("requiredLen=eval(detailTable_" + uniqueId)
							.append(").rows.length-2;}");
					
	
					// 循环明细表的表格的所有行数，进行不能为空的校验
					jsp.append("for(var i=0;i<eval(detailTable_" + uniqueId)
							.append(").rows.length-2;i++){");
	
					// 当前行的控件ID
					jsp.append("var curControlId_").append(uniqueId).append("=")
							.append("\""+ input.getAttribute("id").replaceAll(
											"![{]index[}]", "!{indexFlag}") + "\"")
							.append(".replaceAll('!{indexFlag}',i);");
					jsp.append("var ").append(uniqueId).append("=")
							.append("document.getElementsByName(\"extendDataFormInfo.value(\"+curControlId_")
							.append(uniqueId).append("+\")\")[0].value;");
					jsp.append("if(" + uniqueId).append("==null || ")
							.append(uniqueId).append("== \"\"){alert(\"")
							.append(theFirst_lang +"\"+(i+1)+\""+ line_lang +" '")
							.append(input.getAttribute("label"))
							.append("' "+ emptySelectData_lang +" \");return false;}");
					jsp.append("}return true;};");
					
				} else {
					jsp
							.append("Com_Parameter.event[\"submit\"][Com_Parameter.event[\"submit\"].length] = function(){");
					jsp
							.append("var ")
							.append(input.getAttribute("id"))
							.append("=")
							.append(
									"document.getElementsByName(\"extendDataFormInfo.value(")
							.append(input.getAttribute("id")).append(
									")\")[0].value;");
					jsp.append("if(" + input.getAttribute("id")).append(
							"==null || ").append(input.getAttribute("id")).append(
							"== \"\"){alert(\"")
							.append(input.getAttribute("label"))
							.append("' "+ emptySelectData_lang +" \");return false;}");

					jsp.append("return true;};");
				}
			}
						
			//====================================================================
			
			
			//========================_clickSapSelect_" + uniqueId方法
			// 点击控件中<选择>链接触发的js方法
			jsp.append(" function _clickSapSelect_" + uniqueId).append("(thisObj, indexValue){");
			
			// 判断控件是否同时操作
			jsp.append("if(document.getElementById('SapDataByDialog_Sign').value == '0') {" +
					"Control_AppendLoadMsg(thisObj, 'sapDialogShowMsg_"+ uniqueId +"', '"+ controlSelected +"');"+
					"return;} else {" +
					"document.getElementById('SapDataByDialog_Sign').value = '0';" +
					"Common_RemoveMsg('sapDialogShowMsg_"+ uniqueId +"');" +
					"}");
			
			jsp.append("ESAP_Index_Dialog = indexValue;");
			// 把!{index}变量，修改成!{indexFlag}，防止再次编辑时，被doclist.js中的通用代码给替换成数字
			jsp.append("ESAP_IdField_Dialog");
			jsp.append("=\'").append(ESAP_IdField_Dialog.replaceAll("![{]index[}]", "!{indexFlag}")).append("\';");
			jsp.append("ESAP_IdField_Dialog").append(" = ESAP_IdField_Dialog.replaceAll('!{indexFlag}',ESAP_Index_Dialog);");
			jsp.append("ESAP_NameField_Dialog");
			jsp.append("=\'").append(ESAP_NameField_Dialog.replaceAll("![{]index[}]", "!{indexFlag}")).append("\';");
			jsp.append("ESAP_NameField_Dialog").append(" = ESAP_NameField_Dialog.replaceAll('!{indexFlag}',ESAP_Index_Dialog);");
			
			// 显示正在加载
			jsp.append("Control_AppendLoadImg(thisObj, 'showOnload_"+ uniqueId +"'+ ESAP_Index_Dialog);")	
					// 解析XML模版
					.append("var DialogFuncXml = \""+ funcXml.replaceAll("\n", "").replaceAll("\"", "'") +"\";")
					.append("var fdRfcParamXmlObject = XML_CreateByContent(DialogFuncXml);")
					.append("var importFields = XML_GetNodes(fdRfcParamXmlObject, \"/jco/import/field|/jco/structure/import/field\");");
					// 为import传入参数赋值
			jsp.append("var flag = true;")
					.append("var inputParamJson = eval(\"(" + inputParamJson + ")\");")
					.append("var tableJson = inputParamJson.TABLE_DocList;")
					.append("for (var i = 0; i < importFields.length; i++) {")
					.append("var fieldNode = importFields[i];")
					.append("var sapTitle = XML_GetAttribute(fieldNode, 'title');")
					// 定义并获取映射值
					.append("var isRequired = ''; var inputParamSelect = ''; var ekpid = ''; var ekpname='';")
					.append("for (var m = 0, lenI = tableJson.length; m < lenI; m++) {")
					.append("var rowJson = tableJson[m];")
					.append("if (rowJson.inputParamSelect == sapTitle) {")
					.append("ekpid = rowJson.inputParamId;")
					
					// 传入参数为明细表
					.append("if (ekpid.indexOf('.') != -1) {" +
							"ekpid = 'extendDataFormInfo.value('+ekpid.replace('\\.', '.'+ ESAP_Index_Dialog +'.')+')';" +
							"if (document.getElementsByName(ekpid)[0] == null) {" +
							"ekpid = ekpid.replace('.'+ ESAP_Index_Dialog +'.', '.0.');" +
							"}" +
							"}")
					
					.append("isRequired = rowJson.inputParamRequired;")
					.append("inputParamSelect = rowJson.inputParamSelect;")
					.append("ekpname = rowJson.inputParamText.replace(/\\\\$/g, '');")
					.append("}")
					.append("}")
					// 判断必填项是否有值，若必填项为空值，则在后面判断flag为false就return;
					.append("if (isRequired == 'true' && GetXFormFieldValueById(ekpid)[0] == '') {")
						.append("alert(ekpname+' "+ notEmpty_lang +"');flag = false;")
						// 隐藏图片和显示加载
						.append("Control_RemoveLoadImg('showOnload_"+ uniqueId +"'+ ESAP_Index_Dialog);")
					.append("}")
					// 给ekpid全局赋值
					.append("ESAP_EkpId_Dialog[i] = ekpid;")
					// 设置节点后代的文本的值
						.append("if (ekpid.indexOf('.') != -1) {")
						.append("$(fieldNode).text(document.getElementsByName(ekpid)[0].value);")
						.append("} else {")
						.append("$(fieldNode).text(GetXFormFieldValueById(ekpid)[0]);")
						.append("}")
					.append("}").append("if (!flag) {document.getElementById('SapDataByDialog_Sign').value = '1';return;}")
					.append("else {")
					// 把传入参数设置为disable，让其不能改变
					.append("for (var j = 0; j < ESAP_EkpId_Dialog.length; j++) {")
					.append("var ekpidObj = GetXFormFieldById(ESAP_EkpId_Dialog[j]);")
					.append("ekpidObj[0].disabled = true;").append("}").append("}");
					// 为table类型的传入参数赋值,调用sapEkpFormEvent.js
			jsp.append("SapForm.setImportTableXml(fdRfcParamXmlObject);")
					.append("var data = new KMSSData();")
					.append("data.SendToBean('tibSapMappingFormEventFuncBackXmlService&xml=' + ")
					.append("EkpCommon.XML2String(fdRfcParamXmlObject),callBackExportParam"+ uniqueId +");").append("}");

			
			//=======================callBackExportParam方法
			// 返回输出参数
			jsp.append("function callBackExportParam"+ uniqueId +"(rtnData) {")
				// 隐藏图片和显示加载
				.append("Control_RemoveLoadImg('showOnload_"+ uniqueId +"'+ ESAP_Index_Dialog);")
				.append("document.getElementById('SapDataByDialog_Sign').value = '1';")
				// 打开传入参数的只读
				.append("for (var x = 0; x < ESAP_EkpId_Dialog.length; x++){")
					.append("var ekpidObj = GetXFormFieldById(ESAP_EkpId_Dialog[x]);")
					.append("ekpidObj[0].disabled = false;")
				.append("}")
				.append("ESAP_EkpId_Dialog = new Array();")
				// 定义显示值，描述值，id，value
				.append("var showValueTitle = new Array();")
				.append("var showValueDesc = new Array();")
				.append("var showValueActual = new Array();")
				// 判断返回参数是否有值
				.append("if (rtnData.GetHashMapArray().length == 0){").append("return;}")
				.append("var funcBackXml = rtnData.GetHashMapArray()[0]['funcBackXml'];")
				.append("var msg = rtnData.GetHashMapArray()[0]['message'];")
				.append("if (msg != undefined){alert(msg);return;}")
				.append("if (!funcBackXml||funcBackXml == '0') {return;}")
				.append("var fdRfcParamXmlObject = XML_CreateByContent(funcBackXml);")
//				.append("var exportFields = XML_GetNodes(fdRfcParamXmlObject,")
//				.append("'/jco/export/field|/jco/export/structure/field');")
//				// 遍历传出参数节点
//				.append("for (var i = 0; i < exportFields.length; i++) {")
//					.append("var fieldNode = exportFields[i];")
//					.append("var ekpid = EkpCommon.getString(XML_GetAttribute(fieldNode, 'ekpid'));")
//					.append("if (ekpid == ''){continue;}")
//					// 设置传出参数的值
//					.append("SetXFormFieldValueById(ekpid, $(fieldNode).text());")
//				.append("}")
				// 得到传出表格，并进行遍历节点
				.append("var exportTables = XML_GetNodes(fdRfcParamXmlObject, ")
				.append("\"/jco/tables/table[@isin='0']\");")
//				.append("for (var m = 0; m < exportTables.length; m++) {")
					.append("var table = exportTables[0];")
					.append("var records = $(table).children();")
					.append("var firstRecord = records[0];")
					.append("for (var j = 0; j < records.length; j++) {")
						.append("var record = records[j];")
						.append("var fields = $(record).children();")
						.append("var fields0 = $(firstRecord).children();")
						// 定义显示、实际、描述值
						.append("var tValue = '"+ showValue +"';")
						.append("var dValue = '"+ showDesc +"';")
						.append("var aValue = '"+ showActual +"';")
						.append("for (var z = 0; z < fields.length; z++) {")
							.append("var field = fields[z];")
							.append("var field0 = fields0[z];")
							.append("var ekpid = ESAP_IdField_Dialog.replace('.0.', '.'+ j +'.');")
							.append("var title = XML_GetAttribute(field0, 'title');")
							// 返回ekpid中含有.的数组，为后面判断是否明细起作用
							.append("var fds = ekpid.split('.');")
							.append("var fieldText = $(field).text();");
							// 显示值、描述值、实际值
							jsp.append(getTitleOperation(_showValue, "tValue"));
							jsp.append(getTitleOperation(_showDesc, "dValue"));
							jsp.append(getTitleOperation(_showActual, "aValue"));
						jsp.append("}")
						// 给显示值,描述值和实际值赋值
						.append("showValueTitle.push(tValue);")
						.append("showValueDesc.push(dValue);")
						.append("showValueActual.push(aValue);")
					.append("}");
//				.append("}");
				// 判断是否查询正确(可能出现的映射错误)
//				jsp.append("alert('showValueTitle='+showValueTitle.join('----')+'---showValueDesc='+showValueDesc+'---showValueActual='+showValueActual);");
				jsp.append("if (showValueTitle == '' || showValueDesc == '' || showValueActual == '')")
					.append("{alert('"+ tableQueryFail_lang +"');return;}");
				// Dialog_List起弹出框的作用
				jsp.append("Dialog_List("+ multi +", ESAP_IdField_Dialog , ESAP_NameField_Dialog , \";\",\"" 
								+ SQL_QUERY_BEAN + "&index=\"+ESAP_Index_Dialog+\"&isLoadData=" + isLoadData
								+ "&showValueTitle=\"+encodeURIComponent(showValueTitle.join('-split-'))+\"" 
								+ "&showValueDesc=\"+encodeURIComponent(showValueDesc.join('-split-'))+\"&showValueActual=\"+encodeURIComponent(showValueActual.join('-split-'))"
								+ ",callBackIntoValue"
								+ ",\""+SQL_QUERY_BEAN
								+ "&keyword=!{keyword}&index=\"+ESAP_Index_Dialog+\"" +
								"&showValueTitle=\"+encodeURIComponent(showValueTitle.join('-split-'))+\"" +
								"&showValueDesc=\"+encodeURIComponent(showValueDesc.join('-split-'))+\"&showValueActual=\"+encodeURIComponent(showValueActual.join('-split-'))"
								+ ",false,null,'"+ choose_lang +"',ESAP_Index_Dialog); return false;" +
			"}");
			//============方法结束============
				
			//========callBackIntoValue方法（此方法主要用于给传出表格所映射的表单赋值）
			jsp.append("function callBackIntoValue(rtnData) {")
				.append("if (rtnData == undefined || rtnData == '')return;")
				// 得出明细表
				.append("var rowLength = '';")
				.append("var startIndex = ESAP_IdField_Dialog.indexOf('(');")
				.append("var endIndex = ESAP_IdField_Dialog.indexOf(')');")
				.append("var tempIdField = ESAP_IdField_Dialog.substring(startIndex + 1, endIndex);")
				// 截取()括号中的id，之后判断是否有.点，有则是明细表
				.append("var firstIndex = tempIdField.indexOf('.');")
				.append("if (firstIndex != -1) {")
					.append("var tempEkpId = tempIdField.substring(0, firstIndex);")
					.append("var tableKey = 'TABLE_DL_'+ tempEkpId.substring(0, firstIndex);")
					.append("var rows = document.getElementById(tableKey).rows;")
					.append("rowLength = rows.length;")
				.append("}")
				
				.append("var hashMapObj = rtnData.GetHashMapArray();")
				.append("var len = hashMapObj.length;")
				// 如果长度len大于0，那么证明是多值在
				.append("for (var i = 0; i < len; i++) {")
					.append("var dataObj = hashMapObj[i];")
					// 增加明细表的行
//					.append("if (firstIndex != -1) {")
//						// 算出新增的一行下标索引
//						.append("var sizeIndex = i + rowLength - 3;")
//						// 增加明细表一行
//						.append("if (i > 0) {")
//							.append("DocList_AddRow(tableKey); ")
//						// 填充映射的数据
//							.append("var id = dataObj['id'];")
//							.append("var name = dataObj['name'];")
//							.append("var controlId = ESAP_IdField_Dialog.replace('.'+ ESAP_Index_Dialog +'.', '.'+ sizeIndex +'.');")
//							.append("document.getElementsByName(controlId)[0].value = id;")
//							// 给控件再次赋值ESAP_NameField_Dialog
//							.append("var controlName = ESAP_NameField_Dialog.replace('.'+ ESAP_Index_Dialog +'.', '.'+ sizeIndex +'.');")
//							.append("document.getElementsByName(controlName)[0].value = name;")
//						.append("} else {document.getElementsByName(ESAP_IdField_Dialog)[0].value = dataObj['id'];")
//						.append("document.getElementsByName(ESAP_NameField_Dialog)[0].value = dataObj['name'];}")
//					// 非明细
//					.append("} else {")
//						.append("if (firstIndex != -1) {")
//						.append("var sizeIndex = i + rowLength - 3;")
//						.append("ESAP_IdField_Dialog = ESAP_IdField_Dialog.replace('.'+ ESAP_Index_Dialog +'.', '.'+ sizeIndex +'.');")
//						.append("ESAP_NameField_Dialog = ESAP_NameField_Dialog.replace('.'+ ESAP_Index_Dialog +'.', '.'+ sizeIndex +'.');")
//						.append("}")
						
						.append("var idValue = GetXFormFieldValueByLabel(ESAP_IdField_Dialog)[0];")
						.append("idValue = idValue == '' ? '' : idValue +';';")
						.append("var nameValue = GetXFormFieldValueByLabel(ESAP_NameField_Dialog)[0];")
						.append("nameValue = nameValue == '' ? '' : nameValue +';';")
						.append("SetXFormFieldValueByLabel(ESAP_IdField_Dialog, idValue + dataObj['id']);")
						.append("SetXFormFieldValueByLabel(ESAP_NameField_Dialog, nameValue + dataObj['name']);")
//					.append("}")
				.append("}")
			.append("}");
			
			jsp.append("</script>");
			// 选择按钮
			String html = "<xform:editShow><span>"
					+ "<a href=\"javascript:void(0)\" onblur=\"Common_RemoveMsg('sapDialogShowMsg_"+ uniqueId +"');\" onclick=\"_clickSapSelect_"
					+ uniqueId + "(this, '!{index}')\">"
					+ ResourceUtil.getString("Designer_Lang.controlAttrSelect",
							"sys-xform-base") + "</a></span></xform:editShow>";
			jsp.append(html);
			// 图片和显示加载
			jsp.append("<input type='hidden' value='1' id='SapDataByDialog_Sign'/>");

		}
		
	}

	public void end(Node node, StringBuilder jsp) throws ParserException {
		try {
			doParse(node, jsp);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	public void filter(Node node, StringBuilder jsp) throws ParserException {
		try {
			doParse(node, jsp);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	public void start(Node node, StringBuilder jsp) throws ParserException {
		try {
			doParse(node, jsp);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	public boolean parseDetailsTable(Node node, Lexer lexer,
			StringBuilder templateJsp, final String idPrefix,
			List<ISysFormTemplateControl> controls) throws Exception {
		if (node instanceof TagNode) {
			TagNode tagNode = (TagNode) node;
			if (isType(TYPE, tagNode)) {
				TagNodeUtils.loopForDetailsTable(this, tagNode, lexer,
						templateJsp, idPrefix, controls, new LoopAction() {
							public boolean action(Node aTagNode, Lexer lexer,
									StringBuilder jsp,
									List<ISysFormTemplateControl> controls)
									throws Exception {
								// 保持与 parse中方法的判断一致
								if (aTagNode instanceof InputTag) {
									InputTag input = (InputTag) aTagNode;
									TagNodeUtils.setDetailsTableId(idPrefix,
											input); // 明细表名称的特殊处理
									doParse(input, jsp);
									return true;
								}
								return false;
							}
						});
				return true;
			}
		}
		return false;
	}

	public String repalceAll(String str) {
		String newStr = "";
		for (int i = 0; i < str.length(); i++) {
			if (str.charAt(i) != '.' && str.charAt(i) != '}'
					&& str.charAt(i) != '{' && str.charAt(i) != '!') {
				newStr += str.charAt(i);
			}
		}
		return newStr;
	}

	private String getTitleOperation(String _titleValue, String showName) {
		StringBuffer jsp = new StringBuffer("");
		Stack<StringBuffer> s = new Stack<StringBuffer>();
		for (int i = 0, len = _titleValue.length(); i < len; i++) {
			char c = _titleValue.charAt(i);
			if (c == '$') {
				if (s.isEmpty()) {
					StringBuffer buf = new StringBuffer();
					buf.append(c);
					s.push(buf);
				} else {
					StringBuffer buf = s.pop();
					//jsp.append(showName +" = "+ showName +".replace(title, fieldText);");
					String javaTitle = buf.toString().replaceAll("\\$", "");
					jsp.append("if (title == '"+ javaTitle +"') {")
						.append(showName +" = "+ showName +".replace(title, fieldText);")
					.append("}");
				}
			} else {
				if (!s.isEmpty()) {
					StringBuffer buf = s.peek();
					buf.append(c);
				}
			}
		}
//		System.out.println("---"+jsp.toString());
		return jsp.toString();
	}
	
}
