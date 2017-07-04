package com.landray.kmss.tib.sap.mapping.plugins.controls.list;

import static com.landray.kmss.sys.xform.base.service.controls.TagNodeUtils.filterNode;
import static com.landray.kmss.sys.xform.base.service.controls.TagNodeUtils.isType;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.InputStreamReader;
import java.util.List;

import org.htmlparser.Node;
import org.htmlparser.lexer.Lexer;
import org.htmlparser.nodes.TagNode;
import org.htmlparser.tags.InputTag;
import org.htmlparser.util.ParserException;

import com.landray.kmss.sys.config.loader.ConfigLocationsUtil;
import com.landray.kmss.sys.xform.base.service.ISysFormTemplateControl;
import com.landray.kmss.sys.xform.base.service.ISysFormTemplateDetailsTableControl;
import com.landray.kmss.sys.xform.base.service.controls.FilterAction;
import com.landray.kmss.sys.xform.base.service.controls.LoopAction;
import com.landray.kmss.sys.xform.base.service.controls.TagNodeUtils;
import com.landray.kmss.util.ResourceUtil;

/**
 * 连接sap，调用sap中的数据，list列表
 * @author 邱建华 2013-3-11
 * 
 */
public class TibSapMappingListControl implements
		ISysFormTemplateControl, FilterAction,
		ISysFormTemplateDetailsTableControl {

	private static final String TYPE = "sapDataByList";

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
			String loading_lang = ResourceUtil.getString("sapPlugin.controls.loading", "tib-sap"); 
			String controlSelected = ResourceUtil.getString("sapPlugin.controls.controlSelected", "tib-sap");
			InputTag input = (InputTag) node;
			// 控件相关的方法名的唯一性标识后缀,如果在明细表，把!{index}替换成index
			String uniqueId = repalceAll(input.getAttribute("id"));
			// 是否多选
			boolean multi = "true".equals(input.getAttribute("multiSelect"));
			String isMulti = "0";
			if (multi) {
				isMulti = "1";
			} 
			// String isLoadData = input.getAttribute("isLoadData");
			// 映射列表Id
			String mappingFuncId = input.getAttribute("mappingList");
			// 样式
			String listStyle = input.getAttribute("_listStyle");
			// 显示值的JSON
			String showValueJson = input.getAttribute("_showValueJson");
			// 增加提交校验方法
			String required = input.getAttribute("required");
			String ESAP_IdField = "extendDataFormInfo.value("+ input.getAttribute("id") + ")";
			String ESAP_NameField = "extendDataFormInfo.value("+ input.getAttribute("id") + "_name" + ")";
			
			// 引用js
			jsp.append("<script type='text/javascript'>Com_IncludeFile('jquery.js');</script>");
			jsp.append("<script src='<c:url value=\"/tib/common/resource/js/commonFormEvent.js\"/>'></script>");
			jsp.append("<script src='<c:url value=\"/tib/sap/mapping/sapEkpFormEvent.js\"/>'></script>");
			jsp.append("<script src='<c:url value=\"/tib/common/resource/js/sapEkp.js\"/>'></script>");
			jsp.append("<script src='<c:url value=\"/tib/sap/mapping/plugins/controls/common/loadPromptOperation.js\"/>'></script>");
			jsp.append("<script type='text/javascript'>");
			// 全局变量
			jsp.append("var ESAP_IdField;var ESAP_NameField;");
			jsp.append("var ESAP_EkpId = new Array();");
			jsp.append("var ESAP_Index;");
			jsp.append("var ESAP_BackXml;");
			jsp.append("var EkpCommon = new EkpCommonFormEvent();");
			jsp.append("var SapForm = new SapFormEvent();");
			// js的全部替换字符串方法
			jsp.append(" String.prototype.replaceAll  = function(s1,s2){");
			jsp.append("return this.replace(new RegExp(s1,\"gm\"),s2);}; ");
//			if ("true".equals(required)) {
//				jsp.append("Com_Parameter.event[\"submit\"][Com_Parameter.event[\"submit\"].length] = function(){");
//				jsp.append("var detailTable_" + uniqueId);
//				jsp.append("=\'").append(input.getAttribute("id")).append("\';");
//				jsp.append("detailTable_" + uniqueId)
//						.append(" = 'TABLE_DL_'+detailTable_").append(uniqueId)
//						.append(".substring(0,detailTable_").append(uniqueId)
//						.append(".indexOf(\".!{index}\"));");
//
//				// 循环明细表的表格的所有行数，进行不能为空的校验
//				jsp.append("for(var i=0;i<eval(detailTable_" + uniqueId)
//						.append(").rows.length-2;i++){");
//
//				// 当前行的控件ID
//				jsp.append("var curControlId_").append(uniqueId).append("=")
//						.append("\""+ input.getAttribute("id").replaceAll(
//										"![{]index[}]", "!{indexFlag}") + "\"")
//						.append(".replaceAll('!{indexFlag}',i);");
//				jsp.append("var ").append(uniqueId).append("=")
//						.append("document.getElementsByName(\"extendDataFormInfo.value(\"+curControlId_")
//						.append(uniqueId).append("+\")\")[0].value;");
//				jsp.append("if(" + uniqueId).append("==null || ")
//						.append(uniqueId).append("== \"\"){alert(\"")
//						.append(theFirst_lang +"\"+(i+1)+\""+ line_lang +" '")
//						.append(input.getAttribute("label"))
//						.append("' "+ emptySelectData_lang +" \");return false;}");
//				jsp.append("}return true;};");
//			}
			//====================================================================
			
			//========================_clickSapSelect_" + uniqueId方法
			// 点击控件中<选择>链接触发的js方法
			jsp.append(" function _clickSapSelect_" + uniqueId).append("(thisObj){");
			
			// 判断控件是否同时操作
			jsp.append("if(document.getElementById('SapDataByList_Sign').value == '0') {" +
					"Control_AppendLoadMsg(thisObj, 'sapListShowMsg_"+ uniqueId +"', '"+ controlSelected +"');"+
					"return;} else {" +
					"document.getElementById('SapDataByList_Sign').value = '0';" +
					"Common_RemoveMsg('sapListShowMsg_"+ uniqueId +"');" +
					"}");
			
			jsp.append("var currentTR = DocListFunc_GetParentByTagName('TR');");
			jsp.append("ESAP_Index = currentTR.rowIndex -1;");
			// 把!{index}变量，修改成!{indexFlag}，防止再次编辑时，被doclist.js中的通用代码给替换成数字
			jsp.append("ESAP_IdField");
			jsp.append("=\'").append(ESAP_IdField.replaceAll("![{]index[}]", "!{indexFlag}")).append("\';");
			jsp.append("ESAP_IdField").append(" = ESAP_IdField.replaceAll('!{indexFlag}',ESAP_Index);");
			jsp.append("ESAP_NameField");
			jsp.append("=\'").append(ESAP_NameField.replaceAll("![{]index[}]", "!{indexFlag}")).append("\';");
			jsp.append("ESAP_NameField").append(" = ESAP_NameField.replaceAll('!{indexFlag}',ESAP_Index);");
			// 调用下一步JS（从文件引入）
			jsp.append("SapDataByList_XmlTemplate_"+ uniqueId +"(thisObj);");
			jsp.append(" }; ");
			
			String jsFilePath = ConfigLocationsUtil.getWebContentPath() +
					"/tib/sap/mapping/plugins/controls/list/sapDataByList_include.js";
			File jsFile = new File(jsFilePath); 
			BufferedReader bis = new BufferedReader(new InputStreamReader(new FileInputStream(jsFile), "UTF-8"));
			String temp = "";
			StringBuffer jsStr = new StringBuffer("");
			while ((temp = bis.readLine()) != null) {
				jsStr.append(temp+"\n");  
			}
			String jspString = jsStr.toString().replaceAll("uniqueId", uniqueId)
				.replaceAll("_mappingFuncId", mappingFuncId)
				.replaceAll("_notEmpty_lang", notEmpty_lang)
				.replaceAll("_loading_lang", loading_lang)
				.replaceAll("_isMulti", isMulti)
				.replaceAll("_showValueJson", showValueJson);
//			System.out.println("jspString=="+jspString);
			jsp.append(jspString);
			
			jsp.append("</script>");
			// 选择按钮
			String html = "";
			if (listStyle.equals("1")) {
				html = "<span style='float:left;'><input type='button' "
					+ "onblur=\"Common_RemoveMsg('sapListShowMsg_"+ uniqueId +"');\"" 
					+ "onclick=\"_clickSapSelect_"
					+ uniqueId + "(this, '!{index}')\" value='"
					+ ResourceUtil.getString("Designer_Lang.controlAttrSelect",
							"sys-xform-base") + "' /></span>";
			} else 	if (listStyle.equals("2")) {
				html = "<span style='float:left;'><a href=\"javascript:void(0)\" " 
					+ "onblur=\"Common_RemoveMsg('sapListShowMsg_"+ uniqueId +"');\"" 
					+ "onclick=\"_clickSapSelect_"
					+ uniqueId + "(this, '!{index}')\">"
					+ ResourceUtil.getString("Designer_Lang.controlAttrSelect",
							"sys-xform-base") + "</a></span>";
			} else {
				html = "<span style='float:left;'><img src='${KMSS_Parameter_StylePath}icons/edit.gif' alt='" 
					+ ResourceUtil.getString("Designer_Lang.controlAttrSelect", "sys-xform-base") +"'"
					+ "onblur=\"Common_RemoveMsg('sapListShowMsg_"+ uniqueId +"');\"" 
					+ "onclick=\"_clickSapSelect_"
					+ uniqueId + "(this, '!{index}')\" style='cursor: hand'></span>";
			}
			jsp.append("<xform:editShow>" + html); // 解决页面不同，而显示要不同问题
			jsp.append("</xform:editShow>");
			// 图片和显示加载
			jsp.append("<input type='hidden' value='1' id='SapDataByList_Sign'/>");
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

}
