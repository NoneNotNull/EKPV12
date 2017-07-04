package com.landray.kmss.tib.sap.mapping.plugins.controls.select;

import static com.landray.kmss.sys.xform.base.service.controls.TagNodeUtils.filterNode;
import static com.landray.kmss.sys.xform.base.service.controls.TagNodeUtils.isType;
import static com.landray.kmss.sys.xform.base.service.controls.TagNodeUtils.setAttribute;

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
 * 连接sap，调用sap中的数据，Select控件
 * @author 邱建华 2013-3-9
 * 
 */
public class TibSapMappingSelectControl implements
		ISysFormTemplateControl, FilterAction,
		ISysFormTemplateDetailsTableControl {

	private static final String TYPE = "sapDataBySelect";

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
			String pleaseSelect = ResourceUtil.getString("sapPlugin.select", "tib-sap"); 
			InputTag input = (InputTag) node;
			// 控件相关的方法名的唯一性标识后缀,如果在明细表，把!{index}替换成index
			String uniqueId = repalceAll(input.getAttribute("id"));
			// 是否多选
			boolean multi = false;
			String isLoadData = input.getAttribute("isLoadData");
			// 数据来源(函数的ID)
			String fdRfcSettingId = input.getAttribute("fdRfcSettingId");
			// 获取显示值和描述值
			String _showValue = input.getAttribute("selectShowValue");
			String _showActual = input.getAttribute("selectActualValue");
			String showValue = _showValue.replaceAll("\\$", "");
			String showActual = _showActual.replaceAll("\\$", "");
			// 映射输入参数的JSON
			String inputParamJson = input.getAttribute("inputParams");
			// 增加提交校验方法
			String required = input.getAttribute("required");
			String ESAP_IdField_Span = "extendDataFormInfo.value("+ input.getAttribute("id") + "_span)";
			String ESAP_IdField_Select = "extendDataFormInfo.value("+ input.getAttribute("id") + ")";
			String ESAP_NameField_Select = "extendDataFormInfo.value("+ input.getAttribute("id") + "_name" + ")";
			String ESAP_ValueField_Select = "extendDataFormInfo.value("+ input.getAttribute("id") + "_value" + ")";
			String ESAP_TextField_Select = "extendDataFormInfo.value("+ input.getAttribute("id") + "_text" + ")";
			// 取XML
			ITibSysSapJcoFunctionUtil tibSysSapJcoFunctionUtil = (ITibSysSapJcoFunctionUtil) SpringBeanUtil
				.getBean("tibSysSapJcoFunctionUtil");
			String funcXml = (String) tibSysSapJcoFunctionUtil.getFunctionToXmlById(fdRfcSettingId);
			// 选择按钮
			jsp.append("<span style='float:left;' id='"+ ESAP_IdField_Span +"'>");
			
			String select = "<xform:select property='"+ ESAP_IdField_Select +"' " +
					"onValueChange=\"SapDataBySelect_LeaveValue(this, '"+ ESAP_ValueField_Select +"', '"+ ESAP_TextField_Select +"');\" " +
					"style='width: 85px;' htmlElementProperties=\"onclick='_clickSapControlSelect_"+ uniqueId + "(this, &quot;!{index}&quot;);' " +
					"onblur='Select_RemoveMsg();'\" ";
			jsp.append(select);
			setAttribute(jsp, "required", input.getAttribute("_required"));
			jsp.append("></xform:select>");
			String html = "<input type='hidden' id='sapSelectShowMsgId' value='sapSelectShowMsg_"+ uniqueId +"'/>";
			html += "<textarea style='display: none;' name='selectTemp_"+ uniqueId +"' id='selectTemp_"+ uniqueId +"'></textarea>";
			html += "<xform:text showStatus='noShow' property='"+ ESAP_ValueField_Select +"' />";
			//html += "<xform:text showStatus='noShow' property='"+ ESAP_TextField_Select +"' />";
			//html += "<c:if test=\"${param.method!='view'}\"><xform:text showStatus='noShow' property='"+ ESAP_TextField_Select +"' /></c:if>";
			html += "<c:if test=\"${param.method!='view'&&param.method!='print'}\"><xform:text showStatus='noShow' property='"+ ESAP_TextField_Select +"' /></c:if>";
			html += "<c:if test=\"${param.method=='view'||param.method=='print'}\"><xform:text property='"+ ESAP_TextField_Select +"' /></c:if>";
			jsp.append(html);
			jsp.append("</span>");
			// 图片和显示加载
			jsp.append("<input type='hidden' value='1' id='SapDataBySelect_Sign'/>");
			
			// 引用js
			jsp.append("<script type='text/javascript'>Com_IncludeFile('jquery.js');</script>");
			jsp.append("<script src='<c:url value=\"/tib/common/resource/js/commonFormEvent.js\"/>'></script>");
			jsp.append("<script src='<c:url value=\"/tib/sap/mapping/sapEkpFormEvent.js\"/>'></script>");
			jsp.append("<script src='<c:url value=\"/tib/common/resource/js/sapEkp.js\"/>'></script>");
			jsp.append("<script src='<c:url value=\"/tib/sap/mapping/plugins/controls/common/loadPromptOperation.js\"/>'></script>");
			
			jsp.append("<script type='text/javascript'>");
			// 全局变量
			jsp.append("var ESAP_IdField_Select;var ESAP_NameField_Select;");
			jsp.append("var ESAP_EkpId_Select = new Array();");
			jsp.append("var ESAP_Index_Select;");
			jsp.append("var EkpCommon = new EkpCommonFormEvent();");
			jsp.append("var SapForm = new SapFormEvent();");
			
			// js的全部替换字符串方法
			jsp.append(" String.prototype.replaceAll  = function(s1,s2){");
			jsp.append("return this.replace(new RegExp(s1,\"gm\"),s2);}; ");
			if ("true".equals(required)) {
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
					jsp.append("for(var i=0;i<requiredLen;i++){");

					// 当前行的控件ID
					jsp.append("var curControlId_").append(uniqueId).append("=")
							.append("\""+ input.getAttribute("id").replaceAll(
											"![{]index[}]", "!{indexFlag}") + "\"")
							.append(".replaceAll('!{indexFlag}',i);");
					jsp.append("if (document.getElementsByName(\"extendDataFormInfo.value(\"+curControlId_")
							.append(uniqueId).append("+\")\")[0] == null){return true;}");
					jsp.append("var ").append(uniqueId).append("=")
							.append("document.getElementsByName(\"extendDataFormInfo.value(\"+curControlId_")
							.append(uniqueId).append("+\")\")[0].value;");
					jsp.append("if(" + uniqueId).append("==null || ")
							.append(uniqueId).append("== \"\"){alert(\"")
							.append(theFirst_lang +"\"+(i+1)+\""+ line_lang +" '")
							.append(input.getAttribute("label"))
							.append("' "+ emptySelectData_lang +" \");return false;}");
					jsp.append("}return true;};");
			} 
				
						
			//====================================================================
			
			
			//========================_clickSapSelect_" + uniqueId方法
			// 点击控件中<选择>链接触发的js方法
			jsp.append(" function _clickSapControlSelect_" + uniqueId).append("(thisObj, indexValue){");
			// 判断控件是否同时操作
			jsp.append("if(document.getElementById('SapDataBySelect_Sign').value == '0') {" +
					"Control_AppendLoadMsg(thisObj, 'sapSelectShowMsg_"+ uniqueId +"', '"+ controlSelected +"');"+
					"return;} else {" +
					"document.getElementById('SapDataBySelect_Sign').value = '0';" +
					"Common_RemoveMsg('sapSelectShowMsg_"+ uniqueId +"');" +
					"}");
			jsp.append("ESAP_Index_Select = indexValue;");
			
			// 把!{index}变量，修改成!{indexFlag}，防止再次编辑时，被doclist.js中的通用代码给替换成数字
			jsp.append("ESAP_IdField_Select");
			jsp.append("=\'").append(ESAP_IdField_Select.replaceAll("![{]index[}]", "!{indexFlag}")).append("\';");
			jsp.append("ESAP_IdField_Select").append(" = ESAP_IdField_Select.replaceAll('!{indexFlag}',ESAP_Index_Select);");
			jsp.append("ESAP_NameField_Select");
			jsp.append("=\'").append(ESAP_NameField_Select.replaceAll("![{]index[}]", "!{indexFlag}")).append("\';");
			jsp.append("ESAP_NameField_Select").append(" = ESAP_NameField_Select.replaceAll('!{indexFlag}',ESAP_Index_Select);")
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
							"ekpid = 'extendDataFormInfo.value('+ekpid.replace('\\.', '.'+ ESAP_Index_Select +'.')+')';" +
							"if (document.getElementsByName(ekpid)[0] == null) {" +
							"ekpid = ekpid.replace('.'+ ESAP_Index_Select +'.', '.0.');" +
							"}}")
					.append("isRequired = rowJson.inputParamRequired;")
					.append("inputParamSelect = rowJson.inputParamSelect;")
					.append("ekpname = rowJson.inputParamText.replace(/\\\\$/g, '');")
					.append("}")
					.append("}")
					// 判断必填项是否有值，若必填项为空值，则在后面判断flag为false就return;
					.append("if (isRequired == 'true' && GetXFormFieldValueById(ekpid)[0] == '') {")
						.append("alert(ekpname+' "+ notEmpty_lang +"');flag = false;")
					.append("}")
					// 给ekpid全局赋值
					.append("ESAP_EkpId_Select[i] = ekpid;")
					// 设置节点后代的文本的值
					.append("$(fieldNode).text(GetXFormFieldValueById(ekpid)[0]);")
					.append("} ")
					// 检查避免重复获取数据
					.append("")
					.append("var tempInputValue = '';")
					.append("for (var j = 0; j < ESAP_EkpId_Select.length; j++) {")
					.append("var ekpidObj = GetXFormFieldById(ESAP_EkpId_Select[j]);")
					.append("tempInputValue += ESAP_EkpId_Select[j] + ':' + ekpidObj[0].value;")
					.append("}")
					.append("if (tempInputValue != '' && tempInputValue == document.getElementById('selectTemp_"+ uniqueId +"').value) {" +
							"document.getElementById('SapDataBySelect_Sign').value = '1';return;}")
					.append("else {document.getElementById('selectTemp_"+ uniqueId +"').value = tempInputValue;}")
					// 如果存在空值，那么停止，并把标记设为1表示可以继续操作控件
					.append("if (!flag){document.getElementById('SapDataBySelect_Sign').value = '1'; return;}")
					.append("else {")
					// 把传入参数设置为disable，让其不能改变
					.append("for (var j = 0; j < ESAP_EkpId_Select.length; j++) {")
					.append("var ekpidObj = GetXFormFieldById(ESAP_EkpId_Select[j]);")
					.append("ekpidObj[0].disabled = true;")
					.append("}").append("}");
			// 显示正在加载
			jsp.append("Control_AppendLoadImg(thisObj, 'sapSelectShowOnload_"+ uniqueId +"'+ ESAP_Index_Select);");
					// 为table类型的传入参数赋值,取tabel的属性为isin为1的table,调用sapEkpFormEvent.js
			jsp.append("SapForm.setImportTableXml(fdRfcParamXmlObject);")
					.append("var data = new KMSSData();")
					.append("data.SendToBean('tibSapMappingFormEventFuncBackXmlService&xml=' + ")
					.append("EkpCommon.XML2String(fdRfcParamXmlObject),function(callData){callBackExportParam"+ uniqueId +"(callData, indexValue, thisObj);});").append("}");

			
			//=======================callBackExportParam方法
			// 返回输出参数
			jsp.append("function callBackExportParam"+ uniqueId +"(rtnData, indexValue, selectObj) {")
				// 移除图片
				.append("Control_RemoveLoadImg('sapSelectShowOnload_"+ uniqueId +"'+ ESAP_Index_Select);")
				.append("document.getElementById('SapDataBySelect_Sign').value = '1';")
				// 打开传入参数的只读
				.append("for (var x = 0; x < ESAP_EkpId_Select.length; x++){")
					.append("var ekpidObj = GetXFormFieldById(ESAP_EkpId_Select[x]);")
					.append("ekpidObj[0].disabled = false;")
				.append("}")
				.append("ESAP_EkpId_Select = new Array();")
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
//					.append("if (ekpid == '')continue;")
//					// 设置传出参数的值
//					.append("SetXFormFieldValueById(ekpid, $(fieldNode).text());")
//				.append("}")
				// 得到传出表格，并进行遍历节点
				.append("var exportTables = XML_GetNodes(fdRfcParamXmlObject, ")
				.append("\"/jco/tables/table[@isin='0']\");")
				.append("for (var m = 0; m < exportTables.length; m++) {")
					.append("var table = exportTables[m];")
					.append("var records = $(table).children();")
					.append("var firstRecord = records[0];")
					// 画出select框的长度个数
					.append("selectObj.length = records.length;")
					.append("for (var j = 0; j < records.length; j++) {")
						.append("var record = records[j];")
						.append("var fields = $(record).children();")
						.append("var fields0 = $(firstRecord).children();")
						// 定义显示、实际
						.append("var tValue = '"+ showValue +"';")
						.append("var aValue = '"+ showActual +"';")
						.append("for (var z = 0; z < fields.length; z++) {")
							.append("var field = fields[z];")
							.append("var field0 = fields0[z];")
							.append("var ekpid = ESAP_IdField_Select.replace('.0.', '.'+ j +'.');")
							.append("var title = XML_GetAttribute(field0, 'title');")
							// 返回ekpid中含有.的数组，为后面判断是否明细起作用
							.append("var fds = ekpid.split('.');")
							.append("var fieldText = $(field).text();");
							// 显示值、实际值
							jsp.append(getTitleOperation(_showValue, "tValue"));
							jsp.append(getTitleOperation(_showActual, "aValue"));
						jsp.append("}")
						// 给显示值和实际值赋值
						.append("selectObj.options[j].text = tValue;")
						.append("selectObj.options[j].value = aValue;")
					.append("}")
				.append("}" +
						//"var esap_IdField_Select = '"+ ESAP_IdField_Select +"'.replace('!{index}', indexValue);" +
						"var esap_ValueField_Select = '"+ ESAP_ValueField_Select +"'.replace('!{index}', indexValue);" +
						"var esap_TextField_Select = '"+ ESAP_TextField_Select +"'.replace('!{index}', indexValue);" +
						"SapDataBySelect_LeaveValue(selectObj, esap_ValueField_Select, esap_TextField_Select);");
			jsp.append("}");
			// 编辑时onload
			jsp.append("$(function(){" +
					"var sapDataBySelectViewValue = '${param.method}';" +
					"var selectObj = document.getElementsByName('"+ ESAP_IdField_Select +"')[0];" +
					"var selectTextObj = document.getElementsByName('"+ ESAP_TextField_Select +"')[0];" +
					// 判断是否view页面
					"if (selectObj != null) {$('#selectTemp_"+ uniqueId +"').val('');" +
					"var selectValue = document.getElementsByName('"+ ESAP_ValueField_Select +"')[0].value;" +
					"if(selectObj == null)return;selectObj.length = 1;" +
					"selectObj.options[0].value = selectValue;" +
					"$(selectObj).val(selectValue);" +
					"if (selectTextObj.value == '') {selectObj.options[0].text = '==请选择==';}" +
					"else {selectObj.options[0].text = selectTextObj.value;}" +
					"}" +
					"else if(selectObj == null){" +
					// 把整个块设置一个值，处理权限区段问题
					"document.getElementById('"+ ESAP_IdField_Span +"').innerHTML=selectTextObj.value;}" +
					"});");
			
			//============方法结束============
			jsp.append("</script>");

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
//					jsp.append(showName +" = "+ showName +".replace(title, fieldText);");
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
//		System.out.println(jsp.toString());
		return jsp.toString();
	}

}
