package com.landray.kmss.kms.multidoc.webservice.category.form;

import com.landray.kmss.kms.common.webservice.form.category.KmsMaintainCategoryRequest;

public class KmsMultidocMaintainCategoryRequest extends
		KmsMaintainCategoryRequest {

	private static final long serialVersionUID = 5513304851504169203L;
	private String fdNumberPrefix;

	public String getFdNumberPrefix() {
		return fdNumberPrefix;
	}

	public void setFdNumberPrefix(String fdNumberPrefix) {
		this.fdNumberPrefix = fdNumberPrefix;
	}

}
