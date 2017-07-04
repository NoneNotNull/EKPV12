package com.landray.kmss.code.struts;

import java.io.File;
import java.util.ArrayList;
import java.util.List;

import com.landray.kmss.code.util.XMLReaderUtil;

public class StrutsConfig {
	public static StrutsConfig getInstance(File file) throws Exception {
		return (StrutsConfig) XMLReaderUtil.getInstance(file,
				StrutsConfig.class);
	}

	private List<FormBean> formBeans = new ArrayList<FormBean>();

	public List<FormBean> getFormBeans() {
		return formBeans;
	}

	public void setFormBeans(List<FormBean> formBeans) {
		this.formBeans = formBeans;
	}

	public void addFormBean(FormBean formBean) {
		this.formBeans.add(formBean);
	}

	private MessageResources messageResources;

	public MessageResources getMessageResources() {
		return messageResources;
	}

	public void setMessageResources(MessageResources messageResources) {
		this.messageResources = messageResources;
	}

}
