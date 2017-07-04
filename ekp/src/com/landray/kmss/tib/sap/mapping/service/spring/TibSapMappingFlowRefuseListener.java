/**
 * 
 */
package com.landray.kmss.tib.sap.mapping.service.spring;

import net.sf.json.JSONObject;

import com.landray.kmss.common.model.IBaseModel;
import com.landray.kmss.sys.lbpm.engine.manager.event.EventExecutionContext;
import com.landray.kmss.sys.lbpm.engine.manager.event.IEventListener;
import com.landray.kmss.tib.common.mapping.model.TibCommonMappingFunc;
import com.landray.kmss.tib.common.mapping.service.ITibCommonMappingFuncService;

/**
 * SAP流程驳回功能，当驳回事件产生时，则执行SAP所定义的函数映射
 * @author qiujh
 * @version 1.0 2014-6-3
 */
public class TibSapMappingFlowRefuseListener implements IEventListener {

	private ITibCommonMappingFuncService tibCommonMappingFuncService;
	private TibSapMappingRunFunction tibSapMappingRunFunction;
	
	public void setTibCommonMappingFuncService(
			ITibCommonMappingFuncService tibCommonMappingFuncService) {
		this.tibCommonMappingFuncService = tibCommonMappingFuncService;
	}

	public void setTibSapMappingRunFunction(
			TibSapMappingRunFunction tibSapMappingRunFunction) {
		this.tibSapMappingRunFunction = tibSapMappingRunFunction;
	}

	public void handleEvent(EventExecutionContext execution, String parameter)
			throws Exception {
		try {
			IBaseModel baseModel = execution.getMainModel();
			JSONObject jsonObj = JSONObject.fromObject(parameter);
			String mappFuncId = jsonObj.getString("sapFuncValue");
			// 执行RunBapi
			TibCommonMappingFunc mappFunc = (TibCommonMappingFunc) tibCommonMappingFuncService
					.findByPrimaryKey(mappFuncId);
			tibSapMappingRunFunction.runBapi(mappFunc, baseModel);
		} catch (Exception e) {
			e.printStackTrace();
			throw new Exception(e);
		}
	}
	
}
