package com.landray.kmss.work.cases.test;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.jsp.JspException;

import com.landray.kmss.sys.ui.taglib.widget.WidgetTag;
import com.landray.kmss.util.StringUtil;
import com.landray.kmss.web.taglib.xform.TagUtils;

import net.sf.json.JSONObject;

public class SwitchTag extends WidgetTag {
	private static final long serialVersionUID = 381724555119852250L;

	private String property;
	private String checked = "false";
	private boolean showText = true;
	private String showType = "edit";
	private String enabledText;
	private String disabledText;
	private String text;
	private String onValueChange;
	private String checkVal = "true"; // 选中时的值，默认是true
	private String unCheckVal = "false"; // 非选中时的值，默认是false

	public String getProperty() {
		return property;
	}

	public void setProperty(String property) {
		this.property = property;
	}

	public String isChecked() {
		return checked;
	}

	public void setChecked(String checked) {
		this.checked = checked;
	}

	public String getShowType() {
		return showType;
	}

	public void setShowType(String showType) {
		this.showType = showType;
	}

	public boolean isShowText() {
		return showText;
	}

	public void setShowText(boolean showText) {
		this.showText = showText;
	}

	public String getEnabledText() {
		return enabledText;
	}

	public void setEnabledText(String enabledText) {
		this.enabledText = enabledText;
	}

	public String getDisabledText() {
		return disabledText;
	}

	public void setDisabledText(String disabledText) {
		this.disabledText = disabledText;
	}

	public String getText() {
		return text;
	}

	public void setText(String text) {
		this.text = text;
	}

	public String getOnValueChange() {
		return onValueChange;
	}

	public void setOnValueChange(String onValueChange) {
		this.onValueChange = onValueChange;
	}

	public String getCheckVal() {
		return checkVal;
	}

	public void setCheckVal(String checkVal) {
		this.checkVal = checkVal;
	}

	public String getUnCheckVal() {
		return unCheckVal;
	}

	public void setUnCheckVal(String unCheckVal) {
		this.unCheckVal = unCheckVal;
	}

	/**
	 * 转Boolean数据，将字符'true'转为true，其它转为false
	 */
	private String getBoolean(Object val) {
		if (val != null) {
			if (val instanceof Boolean) {
				return val.toString();
			} else {
				return this.getCheckVal().equals(val.toString().trim()) + "";
			}
		} else {
			return "false";
		}
	}

	@Override
	public int doStartTag() throws JspException {
		// 兼容SysAppConfig配置，在SysAppConfig表单中可以这样使用：<ui:switch
		// property="value(realTimeSearch)"></ui:switch>
		Object fValue = TagUtils.getFieldValue(
				(HttpServletRequest) pageContext.getRequest(), this.property);
		if (fValue != null && StringUtil.isNotNull(fValue.toString())) {
			// 获取表单初始值
			this.setChecked(getBoolean(fValue));
		} else {
			// 获取页面配置初始值
			this.setChecked(this.checked.equals(this.checkVal) + "");
		}
		return super.doStartTag();
	}

	public String getType() {
		return "lui/switch!Switch";
	}

	protected void postBuildConfigJson(JSONObject cfg) {
		putConfigValue(cfg, "property", this.getProperty());
		putConfigValue(cfg, "checked", this.isChecked());
		putConfigValue(cfg, "showType", this.getShowType());
		putConfigValue(cfg, "showText", this.isShowText());
		putConfigValue(cfg, "enabledText", this.getEnabledText());
		putConfigValue(cfg, "disabledText", this.getDisabledText());
		putConfigValue(cfg, "text", this.getText());
		putConfigValue(cfg, "onValueChange", this.getOnValueChange());
		putConfigValue(cfg, "checkVal", this.getCheckVal());
		putConfigValue(cfg, "unCheckVal", this.getUnCheckVal());
		super.postBuildConfigJson(cfg);
	}

	public void release() {
		this.property = null;
		this.checked = "false";
		this.showText = true;
		this.showType = "edit";
		this.enabledText = null;
		this.disabledText = null;
		this.text = null;
		this.onValueChange = null;
		this.checkVal = "true";
		this.unCheckVal = "false";
		super.release();
	}
}
