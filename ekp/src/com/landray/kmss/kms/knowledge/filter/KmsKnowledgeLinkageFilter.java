package com.landray.kmss.kms.knowledge.filter;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import com.landray.kmss.common.actions.RequestContext;
import com.landray.kmss.common.dao.HQLParameter;
import com.landray.kmss.common.dao.HQLWrapper;
import com.landray.kmss.common.service.IXMLDataBean;
import com.landray.kmss.sys.config.dict.SysDictModel;
import com.landray.kmss.sys.property.constant.IDisplayTypeConstant;
import com.landray.kmss.sys.property.constant.ITypeConstant;
import com.landray.kmss.sys.property.constant.SysPropertyConstant;
import com.landray.kmss.sys.property.filter.FilterItem;
import com.landray.kmss.sys.property.filter.ISysPropertyFilter;
import com.landray.kmss.sys.property.filter.hql.HQLFragment;
import com.landray.kmss.sys.property.model.SysPropertyDefine;
import com.landray.kmss.sys.property.model.SysPropertyFilterSetting;
import com.landray.kmss.sys.property.service.ISysPropertyDefineService;
import com.landray.kmss.sys.property.util.SysPropertyUtil;
import com.landray.kmss.util.HQLUtil;
import com.landray.kmss.util.StringUtil;

import edu.emory.mathcs.backport.java.util.Arrays;

/**
 * 子父属性联合筛选器
 * @author 郭昌平
 * 2013-04-10
 */
public class KmsKnowledgeLinkageFilter implements ISysPropertyFilter,
		IXMLDataBean, SysPropertyConstant {


	private ISysPropertyDefineService sysPropertyDefineService;

	public void setSysPropertyDefineService(
			ISysPropertyDefineService sysPropertyDefineService) {
		this.sysPropertyDefineService = sysPropertyDefineService;
	}
	
	/**
	 * 筛选器是否接受该属性使用
	 */
	public boolean accept(SysDictModel sysDictModel,
			SysPropertyDefine sysPropertyDefine) throws Exception {
		String displayType = sysPropertyDefine.getFdDisplayType();
		String type = sysPropertyDefine.getFdType();
		if (ITypeConstant.TYPE_STRING.equals(type)
				&& sysPropertyDefine.getHbmParent() != null
				&& (IDisplayTypeConstant.DIS_TYPE_RADIO.equals(displayType)
						|| IDisplayTypeConstant.DIS_TYPE_CHECKBOX
								.equals(displayType) || IDisplayTypeConstant.DIS_TYPE_SELECT
						.equals(displayType))) {
			return true;
		}
		return false;
	}

	/**
	 * 筛选项定义
	 */
	public FilterItem doOptionFilter(SysDictModel sysDictModel,
			SysPropertyFilterSetting sysPropertyFilterSetting) throws Exception {
		FilterItem filterItem = new FilterItem();
		filterItem.setIsOrg(true);
		//filterItem.addOption(new FilterOption("默认选项","defalut"));
		if (sysPropertyFilterSetting != null) {
			SysPropertyDefine define = sysPropertyFilterSetting.getFdDefine();
			filterItem.setDialogJsOption("Dialog_Options('" + define.getFdId()
					+ "','!{idField}','!{nameField}','optionDialog_Sel_After');");
		}
		return filterItem;
	}

	/**
	 * 数据过滤
	 */
	public HQLFragment doResultFilter(SysDictModel sysDictModel,
			String parpertyName, String value) throws Exception {
		
		HQLFragment hqlFragment = new HQLFragment();
		String val = format(value);
		if (StringUtil.isNotNull(val)) {
			if (val.indexOf(getSplitStr()) > 0) {
				HQLWrapper hqlWrapper = HQLUtil.buildPreparedLogicIN(
						parpertyName, Arrays.asList(val.split(getSplitStr())));
				hqlFragment.setWhereBlock(hqlWrapper.getHql());
				hqlFragment.setParameters(hqlWrapper.getParameterList());
			} else {
				String index = "enum_" + HQLUtil.getFieldIndex();
				hqlFragment.setWhereBlock(parpertyName + " = :" + index);
				hqlFragment.setParameter(new HQLParameter(index, val));
			}
		}
		return hqlFragment;
	}

	/**
	 * 异步获取数据
	 */
	public List getDataList(RequestContext requestInfo) throws Exception {

		String defineId = requestInfo.getParameter("defineId");
		// String parentValue = requestInfo.getParameter("parentValue");
		List<Map<String, String>> rtnList = new ArrayList<Map<String, String>>();
		
		if (StringUtil.isNotNull(defineId)) {
			SysPropertyDefine sysPropertyDefine = (SysPropertyDefine) sysPropertyDefineService
					.findByPrimaryKey(defineId);
			SysPropertyDefine parentDefine = (SysPropertyDefine) sysPropertyDefine
					.getHbmParent();
			String parentOptionsSource = SysPropertyUtil.getParamString(
					parentDefine, PARAM_OPTIONS_SOURCE);
			//父属性选项
			if (PARAM_OPTIONS_SOURCE_INPUT.equals(parentOptionsSource)) {
				String parentOptions = SysPropertyUtil.getParamString(
						parentDefine, PARAM_OPTIONS_SOURCE_INPUT_OPTIONS);
				Map<String, String> parentOptionMap = SysPropertyUtil
						.getOptionMap(parentOptions);
				rtnList.add(parentOptionMap);
				String optionsSource = SysPropertyUtil.getParamString(
						sysPropertyDefine, PARAM_OPTIONS_SOURCE);
				//子属性选项
				if (PARAM_OPTIONS_SOURCE_INPUT.equals(optionsSource)) {
					// 手工输入
					Iterator<Map.Entry<String, String>> iters = parentOptionMap
							.entrySet().iterator();
					String options = SysPropertyUtil.getParamString(
							sysPropertyDefine,
							PARAM_OPTIONS_SOURCE_INPUT_OPTIONS);
					while (iters.hasNext()) {
						Map.Entry<String, String> entry = iters.next();
						Map<String, String> optionMap = SysPropertyUtil
								.getOptionMap(options,entry.getValue());
						rtnList.add(optionMap);
					}
				}
			}
		}
		return rtnList;
	}
	
	protected String format(String str) {
		return str;
	}

	protected String getSplitStr() {
		return ";";
	}
}
