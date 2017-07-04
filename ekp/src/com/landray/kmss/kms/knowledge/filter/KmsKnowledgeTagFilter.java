package com.landray.kmss.kms.knowledge.filter;

import java.util.Arrays;
import java.util.List;

import com.landray.kmss.common.dao.HQLInfo;
import com.landray.kmss.common.dao.HQLParameter;
import com.landray.kmss.common.dao.HQLWrapper;
import com.landray.kmss.kms.knowledge.model.KmsKnowledgeBaseDoc;
import com.landray.kmss.sys.config.dict.SysDictModel;
import com.landray.kmss.sys.property.constant.SysPropertyConstant;
import com.landray.kmss.sys.property.filter.FilterItem;
import com.landray.kmss.sys.property.filter.FilterOption;
import com.landray.kmss.sys.property.filter.ISysPropertyFilter;
import com.landray.kmss.sys.property.filter.hql.HQLFragment;
import com.landray.kmss.sys.property.model.SysPropertyDefine;
import com.landray.kmss.sys.property.model.SysPropertyFilterSetting;
import com.landray.kmss.sys.tag.service.ISysTagApplicationLogService;
import com.landray.kmss.sys.tag.service.ISysTagMainRelationService;
import com.landray.kmss.util.HQLUtil;
import com.landray.kmss.util.StringUtil;
import com.landray.kmss.util.UserUtil;

public class KmsKnowledgeTagFilter implements ISysPropertyFilter,
		SysPropertyConstant {

	/**
	 * 标签筛选
	 */
	public static final String TYPE_SYS_TAG = "com.landray.kmss.sys.tag.model.SysTagMain";

	ISysTagApplicationLogService sysTagApplicationLogService = null;
	ISysTagMainRelationService sysTagMainRelationService = null;

	public void setSysTagApplicationLogService(
			ISysTagApplicationLogService sysTagApplicationLogService) {
		this.sysTagApplicationLogService = sysTagApplicationLogService;
	}

	public void setSysTagMainRelationService(
			ISysTagMainRelationService sysTagMainRelationService) {
		this.sysTagMainRelationService = sysTagMainRelationService;
	}

	public boolean accept(SysDictModel sysDictModel,
			SysPropertyDefine sysPropertyDefine) throws Exception {
		String type = sysPropertyDefine.getFdType();
		if (TYPE_SYS_TAG.equals(type)) {
			return true;
		}
		return false;
	}

	// ==========================搜索显示项过滤===========================

	public FilterItem doOptionFilter(SysDictModel sysDictModel,
			SysPropertyFilterSetting sysPropertyFilterSetting) throws Exception {
		// 热门标签，或者 使用过的标签 SysTagApplicationLogServiceImp

		List<String> results = sysTagApplicationLogService
				.findApplicationLogUsed(UserUtil.getUser().getFdId());

		FilterItem filterItem = new FilterItem();
		for (int i = 0; i < results.size(); i++) {
			if (i >= 10)
				break;
			filterItem.addOption(new FilterOption(results.get(i), results
					.get(i)));
		}
		filterItem.setType(PROP_FILTER_TYPE_ENUM);
		return filterItem;
	}

	// ==========================结果数据过滤=========================

	public HQLFragment doResultFilter(SysDictModel sysDictModel,
			String parpertyName, String value) throws Exception {
		HQLFragment hqlFragment = new HQLFragment();
		if (StringUtil.isNotNull(value)) {
			List<?> results = getTagModelIds(value);
			if (results.isEmpty()) {
				return hqlFragment;
			} else if (results.size() == 1) {
				String str = (String) results.get(0);
				String index = "tdocTag_" + HQLUtil.getFieldIndex();
				hqlFragment.setWhereBlock("kmsMultidocKnowledge.fdId = :"
						+ index);
				hqlFragment.setParameter(new HQLParameter(index, str));
			} else {
				HQLWrapper hqlWrapper = HQLUtil.buildPreparedLogicIN(
						"kmsMultidocKnowledge.fdId", results);
				hqlFragment.setWhereBlock(hqlWrapper.getHql());
				hqlFragment.setParameters(hqlWrapper.getParameterList());
			}
		}
		return hqlFragment;
	}

	/**
	 * 获取标签的主文档id
	 * 
	 * @param value
	 * @return
	 * @throws Exception
	 */
	private List<?> getTagModelIds(String value) throws Exception {
		HQLInfo hqlInfo = new HQLInfo();
		hqlInfo.setSelectBlock("sysTagMainRelation.fdMainTag.fdModelId");
		String model = "model_" + HQLUtil.getFieldIndex();
		hqlInfo.setWhereBlock("sysTagMainRelation.fdMainTag.fdModelName = :"
				+ model);
		hqlInfo.setParameter(model, KmsKnowledgeBaseDoc.class.getName());
		if (value.indexOf(';') > 0) {
			HQLWrapper hql = HQLUtil.buildPreparedLogicIN(
					"sysTagMainRelation.fdTagName", Arrays.asList(value
							.split(";")));
			hqlInfo.setWhereBlock(StringUtil.linkString(
					hqlInfo.getWhereBlock(), " and ", hql.getHql()));
			hqlInfo.setParameter(hql.getParameterList());
		} else {
			String index = "tag_" + HQLUtil.getFieldIndex();
			hqlInfo.setWhereBlock(StringUtil.linkString(
					hqlInfo.getWhereBlock(), " and ",
					"sysTagMainRelation.fdTagName = :" + index));
			hqlInfo.setParameter(index, value);
		}
		return sysTagMainRelationService.findList(hqlInfo);
	}

}
