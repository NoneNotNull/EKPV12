/**
 * 
 */
package com.landray.kmss.tib.common.mapping.plugins.control;

import java.util.List;

import com.landray.kmss.sys.xform.base.service.controls.relation.RelationParamsTemplate;

/**
 * 获取服务信息接口
 * @author qiujh
 * @version 1.0 2014-7-2
 */
public interface ITibCommonMappingControlDispatcher {
	
	public List<TibCommonMappingControlTreeVo> getCateInfo(String selectId, String pluginKey)  throws Exception;
	
	public List<TibCommonMappingControlTreeVo> getFuncDataList(String selectId, String pluginKey) throws Exception;

	public String getTemplateXml(String funcId) throws Exception;
	
	/**
	 * 根据数据源等参数 获取相关入参
	 * (用于表单控件)
	 * @param key
	 * @param fdData
	 * @return
	 */
	public RelationParamsTemplate getParamsTemplate(String key, String fdData) throws Exception;
	
	/**
	 * 表单运行时 调用的接口 根据传入参数和模板标识 完成对输出结果的转换
	 * (用于表单控件)
	 * @param params
	 * @return
	 */
	public RelationParamsTemplate execute(String fdData, RelationParamsTemplate params,
			String funcId)throws Exception;
}
