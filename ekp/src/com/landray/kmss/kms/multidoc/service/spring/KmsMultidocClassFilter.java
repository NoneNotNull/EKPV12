package com.landray.kmss.kms.multidoc.service.spring;

import java.util.Arrays;
import java.util.List;

import com.landray.kmss.common.dao.HQLParameter;
import com.landray.kmss.common.dao.HQLWrapper;
import com.landray.kmss.kms.multidoc.model.KmsMultidocTemplate;
import com.landray.kmss.kms.multidoc.service.IKmsMultidocTemplateService;
import com.landray.kmss.sys.config.dict.SysDictModel;
import com.landray.kmss.sys.property.constant.SysPropertyConstant;
import com.landray.kmss.sys.property.filter.FilterItem;
import com.landray.kmss.sys.property.filter.FilterOption;
import com.landray.kmss.sys.property.filter.ISysPropertyFilter;
import com.landray.kmss.sys.property.filter.hql.HQLFragment;
import com.landray.kmss.sys.property.model.SysPropertyDefine;
import com.landray.kmss.sys.property.model.SysPropertyFilterSetting;
import com.landray.kmss.util.HQLUtil;
import com.landray.kmss.util.StringUtil;

public class KmsMultidocClassFilter implements ISysPropertyFilter,
		SysPropertyConstant {

	/**
	 * 主类别
	 */
	public static final String TYPE_SYS_CATEGORY = "com.landray.kmss.kms.multidoc.model.KmsMultidocTemplate";

	private IKmsMultidocTemplateService kmsMultidocTemplateService;

	public void setKmsMultidocTemplateService(
			IKmsMultidocTemplateService kmsMultidocTemplateService) {
		this.kmsMultidocTemplateService = kmsMultidocTemplateService;
	}

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

		// TODO
		List results = kmsMultidocTemplateService.findList(
				" hbmParent.fdId  is null", "  fdOrder asc");

		FilterItem filterItem = new FilterItem();
		for (int i = 0; i < results.size(); i++) {
			KmsMultidocTemplate dpt = (KmsMultidocTemplate) results.get(i);
			filterItem.addOption(new FilterOption(dpt.getFdName(), dpt
					.getFdId()));
		}
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
