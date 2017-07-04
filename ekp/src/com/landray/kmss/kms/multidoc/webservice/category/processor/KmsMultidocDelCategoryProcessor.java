package com.landray.kmss.kms.multidoc.webservice.category.processor;

import com.landray.kmss.common.model.IBaseModel;
import com.landray.kmss.kms.common.webservice.constant.WSConstant;
import com.landray.kmss.kms.common.webservice.processor.category.AbstractDelCategoryProcessor;
import com.landray.kmss.kms.knowledge.model.KmsKnowledgeCategory;

public class KmsMultidocDelCategoryProcessor extends
		AbstractDelCategoryProcessor {

	@Override
	protected IBaseModel createUnclassifiedModel() {
		KmsKnowledgeCategory template = new KmsKnowledgeCategory();
		template.setFdName(WSConstant.UNCLASSIFIY_NAME);
		template.setFdNumberPrefix("UNC");
		return template;
	}

}
