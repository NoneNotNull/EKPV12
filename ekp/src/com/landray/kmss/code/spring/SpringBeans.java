package com.landray.kmss.code.spring;

import java.io.File;
import java.util.ArrayList;
import java.util.List;

import com.landray.kmss.code.util.XMLReaderUtil;

public class SpringBeans {
	public static SpringBeans getInstance(File file) throws Exception {
		return (SpringBeans) XMLReaderUtil.getInstance(file, SpringBeans.class);
	}

	private List<SpringBean> beans = new ArrayList<SpringBean>();

	public List<SpringBean> getBeans() {
		return beans;
	}

	public void addBean(SpringBean bean) {
		beans.add(bean);
	}

	public void setBeans(List<SpringBean> beans) {
		this.beans = beans;
	}

}
