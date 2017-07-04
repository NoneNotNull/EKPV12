package com.landray.kmss.kms.knowledge.filter;

import com.landray.kmss.sys.config.dict.SysDictModel;
import com.landray.kmss.sys.property.constant.ITypeConstant;
import com.landray.kmss.sys.property.filter.FilterItem;
import com.landray.kmss.sys.property.filter.SysPropertyDeptFilter;
import com.landray.kmss.sys.property.model.SysPropertyDefine;
import com.landray.kmss.sys.property.model.SysPropertyFilterSetting;

public class KmsKnowledgePostFilter extends SysPropertyDeptFilter {

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

		FilterItem filterItem = new FilterItem();
		filterItem.setType(PROP_FILTER_TYPE_POST);
		return filterItem;
	}
}
