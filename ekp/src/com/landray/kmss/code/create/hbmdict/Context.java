package com.landray.kmss.code.create.hbmdict;

import java.io.BufferedWriter;

import com.landray.kmss.util.ModelUtil;
import com.landray.kmss.util.ResourceUtil;
import com.landray.kmss.util.StringUtil;

public class Context {
	public final static int OUTPUTEMPTYATT = 1;

	public final static int CHECKRESOURCEKEY = 2;

	public final static int ENCODEATTVALUE = 4;

	public BufferedWriter output;

	public Class modelClass;

	public String tableName;

	public String bundle;

	public Context(HbmClass hbmClass, BufferedWriter output) throws Exception {
		this.output = output;
		modelClass = Class.forName(hbmClass.getName());
		tableName = ModelUtil.getModelTableName(hbmClass.getName());
		int i = hbmClass.getName().lastIndexOf(".model.");
		bundle = hbmClass.getName().substring("com.landray.kmss.".length(), i);
		bundle = StringUtil.replace(bundle, ".", "-");
	}

	public boolean checkField(String field) {
		try {
			modelClass.getDeclaredField(field);
		} catch (SecurityException e) {
		} catch (NoSuchFieldException e) {
			return false;
		}
		return true;
	}

	public void outputAttribute(String key, String value) throws Exception {
		outputAttribute(key, value, 0);
	}

	public void outputAttribute(String key, String value, int flag)
			throws Exception {
		if ((flag & CHECKRESOURCEKEY) > 0
				&& ResourceUtil.getString(value) == null)
			value = "";
		if (StringUtil.isNull(value)) {
			if ((flag & OUTPUTEMPTYATT) == 0)
				return;
			value = "";
		} else {
			if ((flag & ENCODEATTVALUE) > 0)
				value = StringUtil.XMLEscape(value);
		}
		output.write("\t" + key + "=\"" + value + "\"\r\n");
	}
}
