package com.landray.kmss.kms.multidoc.service.spring;

import java.util.ArrayList;
import java.util.List;

import com.landray.kmss.kms.multidoc.service.IKmsMultidocKnowledgeService;
import com.landray.kmss.sys.config.dict.SysDictModel;
import com.landray.kmss.sys.organization.model.SysOrgElement;
import com.landray.kmss.sys.property.constant.ITypeConstant;
import com.landray.kmss.sys.property.filter.FilterItem;
import com.landray.kmss.sys.property.filter.FilterOption;
import com.landray.kmss.sys.property.filter.SysPropertyDeptFilter;
import com.landray.kmss.sys.property.model.SysPropertyDefine;
import com.landray.kmss.sys.property.model.SysPropertyFilterSetting;

public class KmsMultidocPostFilter extends SysPropertyDeptFilter {
	IKmsMultidocKnowledgeService kmsMultidocKnowledgeService;

	public void setKmsMultidocKnowledgeService(
			IKmsMultidocKnowledgeService kmsMultidocKnowledgeService) {
		this.kmsMultidocKnowledgeService = kmsMultidocKnowledgeService;
	}

	public boolean accept(SysDictModel sysDictModel,
			SysPropertyDefine sysPropertyDefine) throws Exception {
		String type = sysPropertyDefine.getFdType();
		String displayType = sysPropertyDefine.getFdDisplayType();

		if (ITypeConstant.TYPE_SYS_ORG_ELEMENT.equals(type)
				&& "docPosts".equals(displayType)) {
			return true;
		}
		return false;
	}

	public FilterItem doOptionFilter(SysDictModel sysDictModel,
			SysPropertyFilterSetting sysPropertyFilterSetting) throws Exception {

		List<SysOrgElement> results = new ArrayList<SysOrgElement>();
		results = kmsMultidocKnowledgeService.getOrgElement("ORG_TYPE_POST",
				null, true);

		FilterItem filterItem = new FilterItem();
		for (int i = 0; i < results.size(); i++) {
			SysOrgElement dpt = (SysOrgElement) results.get(i);
			filterItem.addOption(new FilterOption(dpt.getFdName(), dpt
					.getFdId()));

		}
		filterItem.setType(PROP_FILTER_TYPE_POST);
		return filterItem;
	}
}
