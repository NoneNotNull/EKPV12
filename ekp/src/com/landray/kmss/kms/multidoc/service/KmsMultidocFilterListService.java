package com.landray.kmss.kms.multidoc.service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.landray.kmss.common.actions.RequestContext;
import com.landray.kmss.common.dao.HQLInfo;
import com.landray.kmss.common.service.IXMLDataBean;
import com.landray.kmss.sys.property.service.ISysPropertyFilterService;
import com.landray.kmss.sys.property.service.ISysPropertyFilterSettingService;
import com.landray.kmss.sys.property.util.PluginUtil;
import com.landray.kmss.util.StringUtil;
import com.landray.kmss.web.taglib.xform.ICustomizeDataSource;

/**
 * KMS筛选设置、筛选类型下拉列表标签数据
 * 
 * @author
 * @version 1.0 2012-03-07
 */
public class KmsMultidocFilterListService implements IXMLDataBean,
		ICustomizeDataSource {

	private ISysPropertyFilterSettingService sysPropertyFilterSettingService;
	private ISysPropertyFilterService sysPropertyFilterService;

	public void setSysPropertyFilterSettingService(
			ISysPropertyFilterSettingService sysPropertyFilterSettingService) {
		this.sysPropertyFilterSettingService = sysPropertyFilterSettingService;
	}

	public void setSysPropertyFilterService(
			ISysPropertyFilterService sysPropertyFilterService) {
		this.sysPropertyFilterService = sysPropertyFilterService;
	}

	/**
	 *  
	 */
	public List<Map<String, String>> getDataList(RequestContext requestInfo)
			throws Exception {

		List<Map<String, String>> rtnList = new ArrayList<Map<String, String>>();
		String filterBean = requestInfo.getParameter("filterBean");
		List<String> modelList = new ArrayList<String>();
		// modelName 集合
		List<Map<String, Object>> options = PluginUtil.getFilters();
		if (StringUtil.isNull(filterBean)) { // 根节点
			// 系统筛选类别
			for (Map<String, Object> option : options) {
				String filterBeanName = (String) option
						.get(PluginUtil.PARAM_NAME_FILTER_BEAN);
				if (filterBeanName.equals("kmsMultidocClassFilter"))
					continue; // 按文档类别筛选不出现
				Map<String, String> rtnMap = new HashMap<String, String>();
				rtnMap.put("value", (String) option
						.get(PluginUtil.PARAM_NAME_FILTER_BEAN));
				rtnMap.put("text", (String) option
						.get(PluginUtil.PARAM_NAME_FILTER_TEXT));
				rtnMap.put("isShowCheckBox", String.valueOf(false));
				rtnMap.put("isExpanded", String.valueOf(true));
				rtnList.add(rtnMap);
			}

		} else { // 子节点

			// 组合modelName，供树展开调用~ by hongzq
			for (Map<String, Object> option : options) {
				String modelName = (String) option.get(PluginUtil.MODEL_NAME);
				if (modelName != null && (!modelList.contains(modelName))) {
					modelList.add(modelName);
				}
			}
			HQLInfo hqlInfo = new HQLInfo();
			hqlInfo
					.setSelectBlock("sysPropertyFilterSetting.fdId, sysPropertyFilterSetting.fdName");

			StringBuffer modelBlock = new StringBuffer();
			modelBlock.append("(");
			for (int i = 0; i < modelList.size(); i++) {
				modelBlock
						.append(i == 0 ? "sysPropertyFilterSetting.fdModelName = :fdModelName"
								+ i
								: " or sysPropertyFilterSetting.fdModelName = :fdModelName"
										+ i);
				hqlInfo.setParameter("fdModelName" + i + "", modelList.get(i));
			}
			modelBlock.append(")");
			hqlInfo.setWhereBlock(StringUtil.linkString(modelBlock.toString(),
					" and ", "sysPropertyFilterSetting.fdIsEnabled = true"));
			// 组合modelName~end

			String whereBlock = hqlInfo.getWhereBlock();
			whereBlock = StringUtil.linkString(whereBlock, " and ",
					"sysPropertyFilterSetting.fdFilterBean='" + filterBean
							+ "'");
			hqlInfo.setWhereBlock(whereBlock);
			// hqlInfo.setParameter("fdModelName", fdModelName);
			// hqlInfo.setParameter("allModelName", "*");

			List<?> results = sysPropertyFilterSettingService
					.findValue(hqlInfo);

			for (int i = 0; i < results.size(); i++) {
				Object[] obj = (Object[]) results.get(i);
				List filterList = sysPropertyFilterService.findList(
						"sysPropertyFilter.fdFilterSetting.fdId='"
								+ (String) obj[0] + "'", "");
				if (filterList.isEmpty())
					continue;
				Map<String, String> rtnMap = new HashMap<String, String>();
				rtnMap.put("value", (String) obj[0]);
				rtnMap.put("text", (String) obj[1]);
				rtnMap.put("isAutoFetch", String.valueOf(false));
				// rtnMap.put("isChecked", String.valueOf(true));
				rtnMap.put("isExpanded", String.valueOf(true));
				rtnList.add(rtnMap);
			}
		}
		return rtnList;
	}

	public String getDefaultValue() {
		return "";
	}

	/**
	 *  
	 */
	public Map<String, String> getOptions() {
		Map<String, String> rtnMap = new HashMap<String, String>();
		List<Map<String, Object>> options = PluginUtil.getFilters();
		for (Map<String, Object> option : options) {
			rtnMap.put((String) option.get(PluginUtil.PARAM_NAME_FILTER_BEAN),
					(String) option.get(PluginUtil.PARAM_NAME_FILTER_TEXT));
		}
		return rtnMap;
	}
}
