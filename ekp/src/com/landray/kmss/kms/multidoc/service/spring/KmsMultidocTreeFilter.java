package com.landray.kmss.kms.multidoc.service.spring;

import java.util.Arrays;
import java.util.List;
import java.util.Map;

import com.landray.kmss.common.dao.HQLParameter;
import com.landray.kmss.common.dao.HQLWrapper;
import com.landray.kmss.sys.config.dict.SysDictModel;
import com.landray.kmss.sys.property.filter.FilterItem;
import com.landray.kmss.sys.property.filter.FilterOption;
import com.landray.kmss.sys.property.filter.ISysPropertyFilter;
import com.landray.kmss.sys.property.filter.hql.HQLFragment;
import com.landray.kmss.sys.property.model.SysPropertyDefine;
import com.landray.kmss.sys.property.model.SysPropertyFilterSetting;
import com.landray.kmss.sys.property.model.SysPropertyTree;
import com.landray.kmss.sys.property.service.ISysPropertyTreeService;
import com.landray.kmss.util.HQLUtil;
import com.landray.kmss.util.StringUtil;

public class KmsMultidocTreeFilter implements ISysPropertyFilter {

	/**
	 * 树形筛选
	 */
	public static final String TYPE_PROPERTY_TREE = "com.landray.kmss.sys.property.model.SysPropertyTree";

	
	ISysPropertyTreeService  sysPropertyTreeService  = null;
	 
	 
	public void setSysPropertyTreeService(
			ISysPropertyTreeService sysPropertyTreeService) {
		this.sysPropertyTreeService = sysPropertyTreeService;
	}

	public boolean accept(SysDictModel sysDictModel,
			SysPropertyDefine sysPropertyDefine) throws Exception {
		String type = sysPropertyDefine.getFdType();
		if (TYPE_PROPERTY_TREE.equals(type)) {
			return true;
		}
		return false;
	}

	// =========================搜索显示项过滤============================

	public FilterItem doOptionFilter(SysDictModel sysDictModel,
			SysPropertyFilterSetting sysPropertyFilterSetting) throws Exception {
		 Map<?, ?>  map=sysPropertyFilterSetting.getFdDefine().getFdParamMap();
		String treeId=(String) map.get("fd_data_source");
		List<SysPropertyTree> results = sysPropertyTreeService.getTree(treeId) ;
		FilterItem filterItem = new FilterItem();
		for (int i = 0; i < results.size(); i++) {
			 if (i >= 10)
				break;
		     filterItem.addOption(new FilterOption(results.get(i).getFdName(), results.get(i).getFdId()));
			 		
		}
		return filterItem;
	}

	// ==========================显示结果数据项==========================

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
					String index = "docTree_" + HQLUtil.getFieldIndex();
					hqlFragment.setWhereBlock(parpertyName + ".fdId = :" + index);
					hqlFragment.setParameter(new HQLParameter(index, value));
				}
			}
			return hqlFragment;
	}
 

}

				 