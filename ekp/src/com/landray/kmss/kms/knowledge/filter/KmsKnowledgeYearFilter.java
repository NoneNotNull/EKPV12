package com.landray.kmss.kms.knowledge.filter;

import java.text.SimpleDateFormat;
import java.util.Arrays;
import java.util.Date;

import com.landray.kmss.common.dao.HQLParameter;
import com.landray.kmss.common.dao.HQLWrapper;
import com.landray.kmss.sys.config.dict.SysDictModel;
import com.landray.kmss.sys.property.constant.ITypeConstant;
import com.landray.kmss.sys.property.constant.SysPropertyConstant;
import com.landray.kmss.sys.property.filter.FilterItem;
import com.landray.kmss.sys.property.filter.FilterOption;
import com.landray.kmss.sys.property.filter.ISysPropertyFilter;
import com.landray.kmss.sys.property.filter.hql.HQLFragment;
import com.landray.kmss.sys.property.model.SysPropertyDefine;
import com.landray.kmss.sys.property.model.SysPropertyFilterSetting;
import com.landray.kmss.util.HQLUtil;
import com.landray.kmss.util.StringUtil;

public class KmsKnowledgeYearFilter implements ISysPropertyFilter,SysPropertyConstant {
	public boolean accept(SysDictModel sysDictModel,
			SysPropertyDefine sysPropertyDefine) throws Exception {
		String type = sysPropertyDefine.getFdType();
		String displayType = sysPropertyDefine.getFdDisplayType();
		if ((ITypeConstant.TYPE_DATETIME.equals(type) || ITypeConstant.TYPE_DATE
				.equals(type) || ITypeConstant.TYPE_TIME.equals(type))
				&& "docPublishTime".equals(displayType)) {
			return true;
		}
		return false;
	}
	public FilterItem doOptionFilter(SysDictModel sysDictModel,
			SysPropertyFilterSetting sysPropertyFilterSetting) {
		FilterItem filterItem = new FilterItem();
		SimpleDateFormat df = new SimpleDateFormat("yyyy");
		int year = Integer.parseInt(df.format(new Date()));
		for (int i = 0; i < 5; i++) {
			filterItem.addOption(new FilterOption(String.valueOf(year), String
					.valueOf(year)));
			year--;
		}
		filterItem.setType(PROP_FILTER_TYPE_ENUM);
		return filterItem;
	}

	public HQLFragment doResultFilter(SysDictModel sysDictModel,
			String parpertyName, String value) {
		HQLFragment hqlFragment = new HQLFragment();
		String val = format(value);
		if (StringUtil.isNotNull(val)) {
			if (val.indexOf(getSplitStr()) > 0) {
				String[] newStr = val.split(getSplitStr());
				Integer[] integer = new Integer[newStr.length];
				for (int i = 0; i < newStr.length; i++) {
					integer[i] = Integer.valueOf(newStr[i]);
				}
				HQLWrapper hqlWrapper = HQLUtil.buildPreparedLogicIN("year("
						+ parpertyName + ")", Arrays.asList(integer));
				hqlFragment.setWhereBlock(hqlWrapper.getHql());
				hqlFragment.setParameters(hqlWrapper.getParameterList());
			} else {
				String index = "year_" + HQLUtil.getFieldIndex();
				hqlFragment.setWhereBlock("year(" + parpertyName + ") = :"
						+ index);
				hqlFragment.setParameter(new HQLParameter(index, Integer
						.valueOf(val)));
			}
		}
		return hqlFragment;
	}

	protected String format(String str) {
		return str;
	}

	protected String getSplitStr() {
		return ";";
	}

}
