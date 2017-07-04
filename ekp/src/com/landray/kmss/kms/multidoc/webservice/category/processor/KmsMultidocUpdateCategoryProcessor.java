package com.landray.kmss.kms.multidoc.webservice.category.processor;

import com.landray.kmss.common.forms.IExtendForm;
import com.landray.kmss.kms.common.webservice.processor.category.AbstractUpdateCategoryProcessor;
import com.landray.kmss.kms.knowledge.forms.KmsKnowledgeCategoryForm;

public class KmsMultidocUpdateCategoryProcessor extends
		AbstractUpdateCategoryProcessor {

	@Override
	protected IExtendForm createFormInstance() {
		return new KmsKnowledgeCategoryForm();
	}

}
