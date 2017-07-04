package com.landray.kmss.util;

import java.util.List;
import java.util.Locale;
import java.util.ResourceBundle;

import com.sunbor.web.tag.enums.ColumnEnums;
import com.sunbor.web.tag.enums.ColumnEnumsDigest;
import com.sunbor.web.tag.enums.Type;
import com.sunbor.web.tag.enums.ValueLabel;

public class EnumerationTypeUtil {

	protected static ColumnEnums columnEnums;

	protected String enumsFile;

	public EnumerationTypeUtil() {
		super();
	}

	public static EnumerationTypeUtil newInstance() {
		return new EnumerationTypeUtil();
	}

	public static List getColumnEnumsByType(String typeName) throws Exception {
		return getColumnEnumsByType(typeName, null);
	}

	public static List getColumnEnumsByType(String typeName, Locale locale)
			throws Exception {
		Type type = EnumerationTypeUtil.newInstance().getColumnEnums()
				.findType(typeName);

		for (int j = 0; j < type.getValueLabels().size(); j++) {
			ValueLabel valueLabel = (ValueLabel) type.getValueLabels().get(j);
			try {
				String label = null;

				label = findString(valueLabel.getLabelKey(), valueLabel
						.getBundle(), null, locale);

				if (label != null)
					valueLabel.setLabel(label);
			} catch (Exception e) {
				if (valueLabel.getLabel() == null)
					valueLabel.setLabel("");
			}
		}
		return type.getValueLabels();
	}

	public static String getColumnValueByLabel(String typeName,
			String labelValue) throws Exception {
		return getColumnValueByLabel(typeName, labelValue, null);
	}

	public static String getColumnValueByLabel(String typeName,
			String labelValue, Locale locale) throws Exception {
		if (labelValue == null)
			return null;
		List labels = getColumnEnumsByType(typeName, locale);
		for (int i = 0; i < labels.size(); i++) {
			ValueLabel valueLabel = (ValueLabel) labels.get(i);
			if (labelValue.equals(valueLabel.getLabel()))
				return valueLabel.getValue();
		}
		return null;
	}

	/**
	 * 根据枚举类型和枚举值,查找枚举的显示字符串
	 * 
	 * @param request
	 * @param type
	 * @param value
	 * @return
	 * @throws Exception
	 */
	public static String getColumnEnumsLabel(String type, String value,
			Locale locale) throws Exception {
		List columnEnums = getColumnEnumsByType(type, locale);
		for (int i = 0; i < columnEnums.size(); i++) {
			ValueLabel valueLabel = (ValueLabel) columnEnums.get(i);
			if (valueLabel.getValue().equals(value)) {
				return valueLabel.getLabel();
			}
		}
		return null;
	}

	public static String getColumnEnumsLabel(String type, String value)
			throws Exception {
		return getColumnEnumsLabel(type, value, null);
	}

	public ColumnEnums getColumnEnums() throws Exception {
		if (columnEnums == null) {
			columnEnums = ColumnEnumsDigest.getColumnEnums();
		}
		return columnEnums;
	}

	public static String findString(String key, String bundle, String resource,
			Locale locale) {
		String value = null;
		if (resource != null) {
			if (locale == null) {
				ResourceBundle rb = ResourceBundle.getBundle(resource);
				return rb.getString(key);
			} else {
				ResourceBundle rb = ResourceBundle.getBundle(resource, locale);
				return rb.getString(key);
			}
		}
		value = ResourceUtil.getString(key, bundle, locale);
		return value;
	}

}
