/**
 * 
 */
package com.landray.kmss.tib.soap.mapping.service.spring;

import net.sf.json.JSONObject;

import com.landray.kmss.common.model.IBaseModel;
import com.landray.kmss.sys.lbpm.engine.manager.event.EventExecutionContext;
import com.landray.kmss.sys.lbpm.engine.manager.event.IEventListener;
import com.landray.kmss.tib.common.mapping.model.TibCommonMappingFunc;
import com.landray.kmss.tib.common.mapping.service.ITibCommonMappingFuncService;

/**
 * @author qiujh
 * @version 1.0 2014-6-3
 */
public class TibSoapMappingFlowRefuseListener implements IEventListener {

	private ITibCommonMappingFuncService tibCommonMappingFuncService;
	private TibSoapMappingRunFunction tibSoapMappingRunFunction;
	
	public void setTibCommonMappingFuncService(
			ITibCommonMappingFuncService tibCommonMappingFuncService) {
		this.tibCommonMappingFuncService = tibCommonMappingFuncService;
	}

	public void setTibSoapMappingRunFunction(
			TibSoapMappingRunFunction tibSoapMappingRunFunction) {
		this.tibSoapMappingRunFunction = tibSoapMappingRunFunction;
	}

	public void handleEvent(EventExecutionContext execution, String parameter)
			throws Exception {
		try {
			IBaseModel baseModel = execution.getMainModel();
			JSONObject jsonObj = JSONObject.fromObject(parameter);
			String mappFuncId = jsonObj.getString("soapFuncValue");
			// 执行RunBapi
			TibCommonMappingFunc mappFunc = (TibCommonMappingFunc) tibCommonMappingFuncService
					.findByPrimaryKey(mappFuncId);
			tibSoapMappingRunFunction.runWS(mappFunc, baseModel);
		} catch (Exception e) {
			e.printStackTrace();
			throw new Exception(e);
		}
	}

}
