package com.landray.kmss.code.create.hbmdict;

import java.io.File;
import java.util.ArrayList;
import java.util.List;

import com.landray.kmss.code.util.XMLReaderUtil;

public class HbmMapping {
	public static HbmMapping getInstance(String filePath) throws Exception {
		return (HbmMapping) XMLReaderUtil.getInstance(new File(filePath),
				HbmMapping.class);
	}

	private List classes = new ArrayList();

	public List getClasses() {
		return classes;
	}

	public void addClass(HbmClass hbmClass) {
		this.classes.add(hbmClass);
	}

	public void addSubclass(HbmSubclass subclass) {
		this.classes.add(subclass);
	}
}
