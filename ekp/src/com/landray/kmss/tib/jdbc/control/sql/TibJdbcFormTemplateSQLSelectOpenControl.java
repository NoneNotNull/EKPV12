package com.landray.kmss.tib.jdbc.control.sql;

import static com.landray.kmss.sys.xform.base.service.controls.TagNodeUtils.ENTER;
import static com.landray.kmss.sys.xform.base.service.controls.TagNodeUtils.filterNode;
import static com.landray.kmss.sys.xform.base.service.controls.TagNodeUtils.isType;
import static com.landray.kmss.sys.xform.base.service.controls.TagNodeUtils.setAttribute;
import static com.landray.kmss.sys.xform.base.service.controls.TagNodeUtils.setTitleAndSubject;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.htmlparser.Node;
import org.htmlparser.lexer.Lexer;
import org.htmlparser.nodes.TagNode;
import org.htmlparser.tags.InputTag;
import org.htmlparser.util.ParserException;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.JSONValue;
import org.springframework.util.Assert;

import com.landray.kmss.sys.xform.base.service.ISysFormTemplateControl;
import com.landray.kmss.sys.xform.base.service.ISysFormTemplateDetailsTableControl;
import com.landray.kmss.sys.xform.base.service.controls.FilterAction;
import com.landray.kmss.sys.xform.base.service.controls.LoopAction;
import com.landray.kmss.sys.xform.base.service.controls.TagNodeUtils;
import com.landray.kmss.sys.xform.base.service.parse.ParseAnnotation;
import com.landray.kmss.sys.xform.base.service.parse.ParseContext;
import com.landray.kmss.sys.xform.base.service.parse.ParseElement;
import com.landray.kmss.sys.xform.base.service.parse.ParseHandler;
import com.landray.kmss.util.ResourceUtil;
import com.landray.kmss.util.StringUtil;

/**
 * 扩展表单控件-自定义sql数据源，供前台选择数据和回写数据
 * 
 * @author 刘声斌 2010-11-2
 * 
 */
@ParseAnnotation(acceptType = "sqlSelectByOpen")
public class TibJdbcFormTemplateSQLSelectOpenControl implements
		ISysFormTemplateControl, FilterAction, ParseHandler,
		ISysFormTemplateDetailsTableControl {

	private static final String TYPE = "sqlSelectByOpen";

	private static final String SQL_QUERY_BEAN = "tibJdbcSqlSelectDataBean";

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

	private void doParse(Node node, final StringBuilder jsp, boolean isRequired)
			throws ParserException {
		if (node instanceof InputTag) {
			InputTag input = (InputTag) node;
			boolean multi = "true".equals(input.getAttribute("multiSelect"));
			String isLoadData = input.getAttribute("isLoadData");

			String sqlvalue = input.getAttribute("sqlvalue").replaceAll(
					"&#13;&#10;", " ").replaceAll("\t|\r|\n", " ");

			// 查询字段名
			String queryColumn = input.getAttribute("queryColumn");
			// 排序字符串
			String orderByValue = input.getAttribute("orderByValue");

			String inputParams = input.getAttribute("inputParams").replaceAll(
					"'", "\"");
			String outputParams = input.getAttribute("outputParams")
					.replaceAll("'", "\"");
			// 获取数据源7
			String sqlresource = input.getAttribute("sqlResource");
			if (StringUtil.isNotNull(sqlresource)) {
				sqlvalue = sqlresource + "@" + sqlvalue;
			}
			// 增加提交校验方法
			String required = input.getAttribute("_required");

			String idField = "extendDataFormInfo.value("
					+ input.getAttribute("id") + ")";
			String nameField = "extendDataFormInfo.value("
					+ input.getAttribute("id") + "_name" + ")";

			// 生成隐藏域
			jsp.append("<xform:text");
			setAttribute(jsp, "property", idField);
			setAttribute(jsp, "showStatus", "noShow");
			jsp.append("/>");
			// 编辑状态显示只读文本框
			jsp.append("<xform:text");
			setAttribute(jsp, "property", nameField);
			setTitleAndSubject(jsp, input.getAttribute("label"));
			setAttribute(jsp, "width", input);
			setAttribute(jsp, "style", input);
			setAttribute(jsp, "required", input);
			setAttribute(jsp, "showStatus", "readOnly");
			jsp.append("/>");
			if ("true".equals(required)) {
				jsp.append("<span class=txtstrong>*</span>");
			}
			jsp.append("<script type='text/javascript'>");
			if ("true".equals(required) && isRequired) {
				jsp.append("Com_Parameter.event[\"submit\"][Com_Parameter.event[\"submit\"].length] = function(){");
				jsp.append("var ")
					.append(input.getAttribute("id"))
					.append("=")
					.append("document.getElementsByName(\"extendDataFormInfo.value(")
					.append(input.getAttribute("id")).append(
								")\")[0].value;");
				jsp.append("if(" + input.getAttribute("id")).append(
						"==null || ").append(input.getAttribute("id")).append(
						"== \"\"){alert(\"")
						.append(input.getAttribute("label")).append(
								"为空，请单击<选择>查找！ \");return false;}");
				jsp.append("return true;};");
			}

			// js回调函数
			jsp.append("function _sqlSelectAfterCallBackFun_"
					+ input.getAttribute("id") + "(rtnVal){");
			jsp.append(getCallBackFun(outputParams));
			// 选择完成后，调用选择完后的的函数
			jsp.append("};");
			// 拼装替换sql中的参数为实际的值的function
			jsp.append(getSqlValue(sqlvalue, prepareParamsValue(inputParams),
					input.getAttribute("id")));
			// js的全部替换字符串方法
			jsp.append(" String.prototype.replaceAll  = function(s1,s2){");
			jsp.append("return this.replace(new RegExp(s1,\"gm\"),s2);}; ");

			// 点击控件中<选择>链接触发的js方法
			jsp.append(" function _clickSqlSelect_" + input.getAttribute("id"))
					.append("(){");
			// 生成校验js代码
			jsp.append(getCheckJS(inputParams));
			jsp.append("var sqlvalue = encodeURIComponent(getSqlValue_"
					+ input.getAttribute("id") + "(\"" + sqlvalue + "\"));");
			// 点击选择之前调用的方法
			jsp.append("if(typeof SQLSelectOnValueChangeBefore !='undefined' && SQLSelectOnValueChangeBefore instanceof Function){SQLSelectOnValueChangeBefore();}");
			jsp.append(" Dialog_List(" + multi + ", \"" + idField + "\",\""
					+ nameField + "\", \";\",\"" + SQL_QUERY_BEAN
					+ "&isLoadData=" + isLoadData + "&orderby=" + orderByValue
					+ "&sqlResource=" + sqlresource
					+ "&sqlValue=\"+sqlvalue,_sqlSelectAfterCallBackFun_"
					+ input.getAttribute("id") + ",\"" + SQL_QUERY_BEAN
					+ "&keyword=!{keyword}&column=" + queryColumn + "&orderby="
					+ orderByValue + "&sqlValue=\"+sqlvalue"
					+ "); return false;");
			jsp.append(" }; ");
			jsp.append("</script>");
			jsp.append("<xform:editShow>");
			String html = "<span><a href=\"javascript:void(0)\" onclick=\"_clickSqlSelect_"
					+ input.getAttribute("id")
					+ "()\">"
					+ ResourceUtil.getString("Designer_Lang.controlAttrSelect",
							"sys-xform-base") + "</a></span>";
			jsp.append(html);
			jsp.append("</xform:editShow>");

		}
		// 其他标签不处理
	}

	/**
	 * 解析生成明细表中的控件的jsp
	 * 
	 * @param node
	 * @param jsp
	 * @throws ParserException
	 */
	private void doParseDetailTable(Node node, final StringBuilder jsp)
			throws ParserException {
		if (node instanceof InputTag) {
			InputTag input = (InputTag) node;
			// 控件相关的方法名的唯一性标识后缀,如果在明细表，把!{index}替换成index
			String uniqueId = repalceAll(input.getAttribute("id"));
			boolean multi = "true".equals(input.getAttribute("multiSelect"));
			String isLoadData = input.getAttribute("isLoadData");

			String sqlvalue = input.getAttribute("sqlvalue").replaceAll(
					"&#13;&#10;", " ").replaceAll("\t|\r|\n", " ");
			// 查询字段名
			String queryColumn = input.getAttribute("queryColumn");
			// 排序字符串
			String orderByValue = input.getAttribute("orderByValue");
			String inputParams = input.getAttribute("inputParams").replaceAll(
					"'", "\"");
			String outputParams = input.getAttribute("outputParams")
					.replaceAll("'", "\"");
			// 获取数据源
			String sqlresource = input.getAttribute("sqlResource");
			if (StringUtil.isNotNull(sqlresource)) {
				sqlvalue = sqlresource + "@" + sqlvalue;
			}
			// 增加提交校验方法
			String required = input.getAttribute("_required");
			String idField = "extendDataFormInfo.value("
					+ input.getAttribute("id") + ")";
			String nameField = "extendDataFormInfo.value("
					+ input.getAttribute("id") + "_name" + ")";
			// 生成隐藏域
			jsp.append("<xform:text");
			setAttribute(jsp, "property", idField);
			setAttribute(jsp, "showStatus", "noShow");
			jsp.append("/>");
			// 编辑状态显示只读文本框
			jsp.append("<xform:text");
			setAttribute(jsp, "property", nameField);
			setTitleAndSubject(jsp, input.getAttribute("label"));
			setAttribute(jsp, "width", input);
			setAttribute(jsp, "style", input);
			setAttribute(jsp, "required", input);
			setAttribute(jsp, "showStatus", "readOnly");
			jsp.append("/>");
			if ("true".equals(required)) {
				jsp.append("<span class=txtstrong>*</span>");
			}
			jsp.append("<script type='text/javascript'>");
			// js的全部替换字符串方法
			jsp.append(" String.prototype.replaceAll  = function(s1,s2){");
			jsp.append("return this.replace(new RegExp(s1,\"gm\"),s2);}; ");
			if ("true".equals(required)) {
				jsp.append("Com_Parameter.event[\"submit\"][Com_Parameter.event[\"submit\"].length] = function(){");
				jsp.append("var detailTable_" + uniqueId);
				jsp.append("=\'").append(input.getAttribute("id"))
						.append("\';");
				jsp.append("detailTable_" + uniqueId).append(
						" = 'TABLE_DL_'+detailTable_").append(uniqueId).append(
						".substring(0,detailTable_").append(uniqueId).append(
						".indexOf(\".!{index}\"));");
				// 循环明细表的表格的所有行数，进行不能为空的校验
				jsp.append("for(var i=0;i<eval(detailTable_" + uniqueId)
						.append(").rows.length-2;i++){");
				// 当前行的控件ID
				jsp.append("var curControlId_").append(uniqueId).append("=")
					.append("\""+ input.getAttribute("id").replaceAll("![{]index[}]", "!{indexFlag}")+ "\"")
					.append(".replaceAll('!{indexFlag}',i);");
				jsp.append("var ")
					.append(uniqueId)
					.append("=")
					.append("document.getElementsByName(\"extendDataFormInfo.value(\"+curControlId_")
					.append(uniqueId).append("+\")\")[0].value;");
				jsp.append("if(" + uniqueId).append("==null || ").append(
					uniqueId).append("== \"\"){alert(\"").append(
					"第\"+(i+1)+\"行的 '").append(input.getAttribute("label"))
					.append("' 为空，请<选择>数据！ \");return false;}");
				jsp.append("}return true;};");
			}

			// js回调函数
			jsp.append("function _sqlSelectAfterCallBackFun_" + uniqueId
					+ "(rtnVal){");
			jsp.append(getCallBackFunByDetail(outputParams));
			// 选择完成后，调用选择完后的的函数
			jsp.append("if(typeof SQLSelectOnValueChangeAfter !='undefined' && SQLSelectOnValueChangeAfter instanceof Function){SQLSelectOnValueChangeAfter('"
							+ input.getAttribute("id") + "');}");
			jsp.append("};");
			// 拼装替换sql中的参数为实际的值的function
			jsp.append(getSqlValueByDetail(sqlvalue,
					prepareParamsValue(inputParams), uniqueId));
			// 点击控件中<选择>链接触发的js方法
			jsp.append(" function _clickSqlSelect_" + uniqueId).append(
					"(index){var currentTR = DocListFunc_GetParentByTagName('TR');");
			jsp.append("var index = currentTR.rowIndex -1;");
			// 生成校验js代码
			jsp.append(getCheckJSByDetail(inputParams));
			jsp.append("var sqlvalue = encodeURIComponent(getSqlValue_"
					+ uniqueId + "(\"" + sqlvalue + "\",index));");
			// 把!{index}变量，修改成!{indexFlag}，防止再次编辑时，被doclist.js中的通用代码给替换成数字
			jsp.append("var idField");
			jsp.append("=\'").append(
					idField.replaceAll("![{]index[}]", "!{indexFlag}")).append(
					"\';");
			jsp.append("idField").append(
					" = idField.replaceAll('!{indexFlag}',index);");
			jsp.append("var nameField");
			jsp.append("=\'").append(
					nameField.replaceAll("![{]index[}]", "!{indexFlag}"))
					.append("\';");
			jsp.append("nameField").append(
					" = nameField.replaceAll('!{indexFlag}',index);");
			// 点击选择之前调用的方法
			jsp.append("if(typeof SQLSelectOnValueChangeBefore !='undefined' && SQLSelectOnValueChangeBefore instanceof Function){SQLSelectOnValueChangeBefore();}");
			jsp.append(" Dialog_List(" + multi
					+ ",  idField , nameField , \";\",\"" + SQL_QUERY_BEAN
					+ "&isLoadData=" + isLoadData + "&orderby=" + orderByValue
					+ "&sqlResource=" + sqlresource
					+ "&sqlValue=\"+sqlvalue+\"&tib_index=\"+index,_sqlSelectAfterCallBackFun_"
					+ uniqueId + ",\"" + SQL_QUERY_BEAN
					+ "&keyword=!{keyword}&column=" + queryColumn + "&orderby="
					+ orderByValue + "&sqlValue=\"+sqlvalue+\"&tib_index=\"+index"
					+ ",false,null,'选择',index); return false;");
			jsp.append(" }; ");
			jsp.append("</script>");
			jsp.append("<xform:editShow>");
			String html = "<span><a href=\"javascript:void(0)\" onclick=\"_clickSqlSelect_"
					+ uniqueId
					+ "('!{index}')\">"
					+ ResourceUtil.getString("Designer_Lang.controlAttrSelect",
							"sys-xform-base") + "</a></span>";
			jsp.append(html);
			jsp.append("</xform:editShow>");

		}
		// 其他标签不处理
	}

	public void end(Node node, StringBuilder jsp) throws ParserException {
		doParse(node, jsp, true);
	}

	public void filter(Node node, StringBuilder jsp) throws ParserException {
		doParse(node, jsp, true);
	}

	public void start(Node node, StringBuilder jsp) throws ParserException {
		doParse(node, jsp, true);
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
									doParseDetailTable(input, jsp);
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

	/**
	 * 根据sql输入参数,生成校验js代码
	 * 
	 * @param inputParams
	 * @return js代码
	 */
	private String getCheckJS(String inputParams) {
		StringBuffer jsCode = new StringBuffer("");
		// 获取配置的sql参数
		JSONObject json = (JSONObject) JSONValue.parse(inputParams.replaceAll(
				"\t|\r|\n", ""));
		JSONArray parameters = (JSONArray) json.get("inputParams");
		for (int i = 0, length = parameters.size(); i < length; i++) {
			// 输入参数，格式为{name:'', dataType:'', idField:'', nameField:''}
			JSONObject inputParam = (JSONObject) parameters.get(i);
			// 控件唯一ID
			String controlID = ((String) inputParam.get("idField")).replaceAll(
					"\\$", "");
			// 控件名称
			String controlName = ((String) inputParam.get("nameField"))
					.replaceAll("\\$", "'");
			jsCode.append("var value" + i).append("= ").append(
					"GetXFormFieldValueById(\"").append(controlID).append(
					"\")[0];");
			jsCode.append("if(value" + i).append(
					"== \"\" || value" + i + " == null)").append(" { ");
			jsCode.append("alert(\"");
			jsCode.append("请先填写" + controlName + "！");
			jsCode.append("\");return false;");
			jsCode.append(" }");
		}
		return jsCode.toString();
	}

	/**
	 * 根据sql输入参数,生成校验js代码
	 * 
	 * @param inputParams
	 * @return js代码
	 */
	private String getCheckJSByDetail(String inputParams) {
		StringBuffer jsCode = new StringBuffer("");
		// 获取配置的sql参数
		JSONObject json = (JSONObject) JSONValue.parse(inputParams.replaceAll(
				"\t|\r|\n", ""));
		JSONArray parameters = (JSONArray) json.get("inputParams");
		for (int i = 0, length = parameters.size(); i < length; i++) {
			// 输入参数，格式为{name:'', dataType:'', idField:'', nameField:''}
			JSONObject inputParam = (JSONObject) parameters.get(i);
			// 控件唯一ID
			String controlID = ((String) inputParam.get("idField")).replaceAll(
					"\\$", "");
			// 控件名称
			String controlName = ((String) inputParam.get("nameField"))
					.replaceAll("\\$", "'");
			// 明细表处理start
			// jsCode.append("if(arguments.length>=1 && index !='!{index}'){");
			jsCode.append("var controlId");
			jsCode.append("=\'").append(controlID).append("\';");
			jsCode.append("if(controlId.indexOf(\".\") != -1){controlId")
				  .append(" = controlId.substring(0,controlId.indexOf(\".\")+1) + index + controlId.substring(controlId.indexOf(\".\"));}");
            jsCode.append("var selectEle").append("=");
            jsCode.append("document.getElementsByName(\"extendDataFormInfo.value(\"+controlId+\")\")[0];");
            jsCode.append("var optionArr").append("=");
            jsCode.append("selectEle.getElementsByTagName(\"option\");");
            jsCode.append("var value"+i).append("=").append("'';");
            jsCode.append("for (var optIndex=0;optIndex<optionArr.length;optIndex++){");
            jsCode.append("if(optionArr[optIndex].selected){");
			jsCode.append(" value" + i).append("= ").append("optionArr[optIndex].value;}");
			jsCode.append("if(value" + i).append(
					"== \"\" || value" + i + " == null)").append(" { ");
			jsCode.append("if(controlId.indexOf(\".\") != -1){");
			jsCode.append("alert(\"");
			jsCode.append("请先填写第 \"+ (parseInt(index)+1) +\" 行的 " + controlName
					+ "！");
			jsCode.append("\");}else{");
			jsCode.append("alert(\"");
			jsCode.append("请先填写 " + controlName + "！");
			jsCode.append("\");}return false;");
			jsCode.append(" }");
			jsCode.append("}");
			// 明细表处理end 
		}
		return jsCode.toString();
	}

	private String getSqlValue(String sql,
			Map<String, Map<String, String>> params, String curControlID) {
		Assert.notNull(sql);
		// 记录替换后的SQL
		StringBuffer sqlBuf = new StringBuffer("");
		StringBuffer sqlBufJSCode = new StringBuffer(" function getSqlValue_"
				+ curControlID + "(sql){");
		sqlBufJSCode.append("var targetSql = sql;");
		// 正则表达式
		Pattern pattern = Pattern.compile(":[^\\s=)<>,]+");
		Matcher matcher = pattern.matcher(sql);
		// 替换相应的参数为 实际的值
		while (matcher.find()) {
			String paramName = matcher.group(0).substring(1);
			Map<String, String> map = params.get(paramName);
			String controlID = map.keySet().iterator().next();
			String dateType = map.get(controlID);
			// 替换sql的参数
			sqlBufJSCode.append(" targetSql = targetSql.replaceAll(\"").append(
					":" + paramName + "\"").append(",");
			if ("String".equalsIgnoreCase(dateType)) {
				sqlBufJSCode.append("\"'\"+").
				append("GetXFormFieldValueById(\"").append(controlID).append(
						"\")[0]");
				sqlBufJSCode.append("+\"'\");");
			}
			if ("DateTime".equalsIgnoreCase(dateType)) {
				sqlBufJSCode.append("\"'\"+").
				append("GetXFormFieldValueById(\"").append(controlID).append(
						"\")[0]");
				sqlBufJSCode.append("+\"'\");");
			}
			if ("Double".equalsIgnoreCase(dateType)) {
				sqlBufJSCode.append("GetXFormFieldValueById(\"").append(controlID)
						.append("\")[0]");
			}
			matcher.appendReplacement(sqlBuf, "?");
		}
		matcher.appendTail(sqlBuf);
		sqlBufJSCode.append("return targetSql; };");
		return sqlBufJSCode.toString();
	}

	private String getSqlValueByDetail(String sql,
			Map<String, Map<String, String>> params, String curControlID) {
		Assert.notNull(sql);
		// 记录替换后的SQL
		StringBuffer sqlBuf = new StringBuffer("");
		StringBuffer sqlBufJSCode = new StringBuffer(" function getSqlValue_"
				+ curControlID + "(sql,index){");
		sqlBufJSCode.append("var targetSql = sql;");
		// 正则表达式
		Pattern pattern = Pattern.compile(":[^\\s=)<>,]+");
		Matcher matcher = pattern.matcher(sql);
		// 替换相应的参数为 实际的值
		while (matcher.find()) {
			String paramName = matcher.group(0).substring(1);
			Map<String, String> map = params.get(paramName);
			String controlID = map.keySet().iterator().next();
			String dateType = map.get(controlID);
			sqlBufJSCode.append("var controlId");
			sqlBufJSCode.append("=\'").append(controlID).append("\';");
			sqlBufJSCode
					.append("if(controlId.indexOf(\".\") != -1){controlId = controlId.substring(0,controlId.indexOf(\".\")+1) + index + controlId.substring(controlId.indexOf(\".\"));}");
			// 替换sql的参数
			sqlBufJSCode.append(" targetSql = targetSql.replaceAll(\"").append(
					":" + paramName + "\"").append(",");
			if ("String".equalsIgnoreCase(dateType)) {
				sqlBufJSCode
						.append("\"'\"+")
						.append(
								"eval(\"document.getElementsByName('extendDataFormInfo.value(\"+ controlId +\")')[0].value\")")
						.append("+\"'\");");
			}
			if ("DateTime".equalsIgnoreCase(dateType)) {
				sqlBufJSCode
						.append("\"'\"+")
						.append(
								"eval(\"document.getElementsByName('extendDataFormInfo.value(\"+ controlId +\")')[0].value\")")
						.append("+\"'\");");
			}
			if ("Double".equalsIgnoreCase(dateType)) {
				sqlBufJSCode
						.append(
								"eval(\"document.getElementsByName('extendDataFormInfo.value(\"+ controlId +\")')[0].value\")")
						.append(");");
			}
			// sqlBufJSCode.append("}");
			// 明细表处理end
			matcher.appendReplacement(sqlBuf, "?");
		}
		matcher.appendTail(sqlBuf);

		sqlBufJSCode.append("return targetSql; };");
		return sqlBufJSCode.toString();
	}

	/**
	 * 准备查询参数
	 * 
	 * @param context
	 * @param parameters
	 * @return
	 */
	private Map<String, Map<String, String>> prepareParamsValue(
			String inputParams) {
		Map<String, Map<String, String>> rtnResult = new HashMap<String, Map<String, String>>();
		// 获取配置的sql参数
		JSONObject json = (JSONObject) JSONValue.parse(inputParams.replaceAll(
				"\t|\r|\n", ""));
		JSONArray parameters = (JSONArray) json.get("inputParams");
		for (int i = 0, length = parameters.size(); i < length; i++) {
			// 输入参数，格式为{name:'', dataType:'', idField:'', nameField:''}
			JSONObject inputParam = (JSONObject) parameters.get(i);
			// 数据格式
			String dataType = (String) inputParam.get("dataType");
			// 公式
			String controlID = ((String) inputParam.get("idField")).replaceAll(
					"\\$", "");

			Map<String, String> map = new HashMap<String, String>();
			map.put(controlID, dataType);

			rtnResult.put((String) inputParam.get("name"), map);
		}

		return rtnResult;
	}

	/**
	 * 根据sql输出参数,生成回调函数的js代码
	 * 
	 * @param outputParams
	 * @return 回调函数js代码
	 */
	private String getCallBackFun(String outputParams) {
		StringBuffer jsCode = new StringBuffer("");
		// 获取配置的sql输出参数
		JSONObject json = (JSONObject) JSONValue.parse(outputParams.replaceAll(
				"\t|\r|\n", ""));
		JSONArray parameters = (JSONArray) json.get("outputParams");

		jsCode.append("if(rtnVal == null || rtnVal == 'undefined'){return;}");
		jsCode.append("var hashMapArray = rtnVal.GetHashMapArray();");
		jsCode.append("for(var i = 0;i<hashMapArray.length;i++){");
		if (parameters == null)
			return jsCode.toString();
		for (int i = 0, length = parameters.size(); i < length; i++) {
			// 输出参数，格式为[{"isUse":"false","nameField":"","idField":"","name":"fd_id"}]
			JSONObject outputParam = (JSONObject) parameters.get(i);

			// 控件唯一ID
			String controlID = ((String) outputParam.get("idField"))
					.replaceAll("\\$", "");

			// 是否使用
			String isUse = ((String) outputParam.get("isUse"));
			// 数据库字段名
			String columnName = ((String) outputParam.get("name"))
					.toUpperCase();

			if ("true".equalsIgnoreCase(isUse)) {
				jsCode.append("var setValueObject" + i).append("=");
				jsCode
						.append("document.getElementsByName(\"extendDataFormInfo.value(");
				jsCode.append(controlID).append(")\")[0];");
				jsCode.append("if(setValueObject" + i).append("){");

				jsCode.append("setValueObject" + i + ".value").append("=");
				jsCode.append("hashMapArray[i].").append(columnName).append(
						"==null ?\"\":").append("hashMapArray[i].").append(
						columnName).append(";");
				jsCode.append("}");

			}
		}

		jsCode.append(" }");

		return jsCode.toString();
	}

	/**
	 * 根据sql输出参数,生成回调函数的js代码
	 * 
	 * @param outputParams
	 * @return 回调函数js代码
	 */
	private String getCallBackFunByDetail(String outputParams) {
		StringBuffer jsCode = new StringBuffer("");
		// 获取配置的sql输出参数
		JSONObject json = (JSONObject) JSONValue.parse(outputParams.replaceAll(
				"\t|\r|\n", ""));
		JSONArray parameters = (JSONArray) json.get("outputParams");

		jsCode.append("if(rtnVal == null || rtnVal == 'undefined'){return;}");
		jsCode.append("var hashMapArray = rtnVal.GetHashMapArray();");
		jsCode.append("for(var i = 0;i<hashMapArray.length;i++){" +
				"var index = hashMapArray[i]['tib_index'];");
		for (int i = 0, length = parameters.size(); i < length; i++) {
			// 输出参数，格式为[{"isUse":"false","nameField":"","idField":"","name":"fd_id"}]
			JSONObject outputParam = (JSONObject) parameters.get(i);

			// 控件唯一ID
			String controlID = ((String) outputParam.get("idField"))
					.replaceAll("\\$", "");

			// 是否使用
			String isUse = ((String) outputParam.get("isUse"));
			// 数据库字段名
			String columnName = ((String) outputParam.get("name"))
					.toUpperCase();

			if ("true".equalsIgnoreCase(isUse)) {
				jsCode.append("var controlId");
				jsCode.append("=\'").append(controlID).append("\';");
				jsCode
						.append("if(controlId.indexOf(\".\") != -1){controlId = controlId.substring(0,controlId.indexOf(\".\")+1) + index + controlId.substring(controlId.indexOf(\".\"));}");

				jsCode.append("var setValueObject" + i).append("=");
				jsCode
						.append("document.getElementsByName(\"extendDataFormInfo.value(\"+ controlId +\")\")[0];");
				jsCode.append("if(setValueObject" + i).append("){");
				jsCode.append("setValueObject" + i + ".value").append("=");
				jsCode.append("hashMapArray[i].").append(columnName).append(
						"==null ?\"\":").append("hashMapArray[i].").append(
						columnName).append(";");
				jsCode.append("}");

				// jsCode.append("}");// 明细表处理end
			}
		}

		jsCode.append(" }");

		return jsCode.toString();
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

	/**
	 * 移动端
	 */
	@Override
	public boolean parse(ParseElement elem, ParseContext context)
			throws Exception {
		StringBuilder jsp = context.getJsp();

		for (ParseElement e : elem) {
			if (e.isBegin()) {
				continue;
			}
			if (e.isEnd()) {
				jsp.append(ENTER);
				continue;
			}
			if (isSqlSelect(e.getNode())) {
				doParse(e.getNode(), jsp, false);
				continue;
			}
		}
		return true;
	}
	
	private boolean isSqlSelect(Node node) {
		if (node instanceof InputTag) {
			InputTag sqlSelect = (InputTag) node;
			if (TYPE.equalsIgnoreCase(sqlSelect.getAttribute("type"))) {
				return true;
			}
		}
		return false;
	}
	
}
