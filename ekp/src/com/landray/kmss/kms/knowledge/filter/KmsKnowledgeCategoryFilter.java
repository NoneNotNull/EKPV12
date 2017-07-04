package com.landray.kmss.kms.knowledge.filter;

import java.util.Arrays;

import com.landray.kmss.common.dao.HQLParameter;
import com.landray.kmss.common.dao.HQLWrapper;
import com.landray.kmss.sys.config.dict.SysDictModel;
import com.landray.kmss.sys.property.constant.SysPropertyConstant;
import com.landray.kmss.sys.property.filter.FilterItem;
import com.landray.kmss.sys.property.filter.ISysPropertyFilter;
import com.landray.kmss.sys.property.filter.hql.HQLFragment;
import com.landray.kmss.sys.property.model.SysPropertyDefine;
import com.landray.kmss.sys.property.model.SysPropertyFilterSetting;
import com.landray.kmss.util.HQLUtil;
import com.landray.kmss.util.StringUtil;

public class KmsKnowledgeCategoryFilter implements ISysPropertyFilter,
		SysPropertyConstant {

	/**
	 * 主类别
	 */
	public static final String TYPE_SYS_CATEGORY = "com.landray.kmss.kms.knowledge.model.KmsKnowledgeCategory";

	public boolean accept(SysDictModel sysDictModel,
			SysPropertyDefine sysPropertyDefine) throws Exception {
		String type = sysPropertyDefine.getFdType();
		if (TYPE_SYS_CATEGORY.equals(type)) {
			return true;
		}
		return false;
	}

	// ==========================搜索显示项过滤===========================
	public FilterItem doOptionFilter(SysDictModel sysDictModel,
			SysPropertyFilterSetting sysPropertyFilterSetting) throws Exception {


		FilterItem filterItem = new FilterItem();
		filterItem.setModelName(TYPE_SYS_CATEGORY);
		filterItem.setType(PROP_FILTER_TYPE_SIMPLECATEGORY);
		return filterItem;
	}

	// ==========================结果数据过滤=========================
	public HQLFragment doResultFilter(SysDictModel sysDictModel,
			String parpertyName, String value) throws Exception {
		HQLFragment hqlFragment = new HQLFragment();
		if (StringUtil.isNotNull(value)) {
			if (value.indexOf(';') > 0) {
				String[] newStr = value.split(";");
				HQLWrapper hqlWrapper = HQLUtil.buildPreparedLogicIN(
						parpertyName + ".fdId", Arrays.asList(newStr));
				hqlFragment.setWhereBlock(hqlWrapper.getHql());
				hqlFragment.setParameters(hqlWrapper.getParameterList());
			} else {
				String index = "docClass_" + HQLUtil.getFieldIndex();
				hqlFragment.setWhereBlock(parpertyName + ".fdId = :" + index);
				hqlFragment.setParameter(new HQLParameter(index, value));
			}
		}
		return hqlFragment;
	}

}
