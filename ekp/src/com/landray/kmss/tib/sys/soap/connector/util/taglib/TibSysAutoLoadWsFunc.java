package com.landray.kmss.tib.sys.soap.connector.util.taglib;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.jsp.JspException;

import org.jfree.util.Log;

import com.eviware.soapui.model.iface.Operation;
import com.landray.kmss.tib.sys.soap.connector.interfaces.ITibSysSoap;
import com.landray.kmss.tib.sys.soap.connector.model.TibSysSoapSetting;
import com.landray.kmss.tib.sys.soap.connector.service.ITibSysSoapSettingService;
import com.landray.kmss.util.SpringBeanUtil;
import com.landray.kmss.web.taglib.xform.AbstractDataSourceTag;
import com.landray.kmss.web.taglib.xform.DataSourceType;

@SuppressWarnings("serial")
public class TibSysAutoLoadWsFunc extends AbstractDataSourceTag {

	protected String TibSysSoapSettingId = null;
	protected String TibSysSoapversion = null;

	@Override
	protected List<DataSourceType> acquireResult() throws JspException {
		List<DataSourceType> result = new ArrayList<DataSourceType>();
		ITibSysSoapSettingService TibSysSoapSettingService = (ITibSysSoapSettingService) SpringBeanUtil
				.getBean("tibSysSoapSettingService");
		ITibSysSoap TibSysSoap = (ITibSysSoap) SpringBeanUtil
				.getBean("tibSysSoap");
		try {
			TibSysSoapSetting soapuiSetting = (TibSysSoapSetting) TibSysSoapSettingService
					.findByPrimaryKey(TibSysSoapSettingId);
			if (soapuiSetting == null) {
				return result;
			}
			Map<String, Operation> operationMap = new HashMap<String, Operation>(
					1);
			operationMap = TibSysSoap.getAllOperation(soapuiSetting,
					TibSysSoapversion);
			if (operationMap == null || operationMap.isEmpty()) {
				return result;
			}
			for (String method : operationMap.keySet()) {
				DataSourceType dt = new DataSourceType();
				dt.setName(method);
				dt.setValue(method);
				result.add(dt);
			}
			return result;
		} catch (Exception e) {
			Log.error("加载数据抛出错误：" + e.getMessage());
			return result;
		}
	}

	public void release() {
		super.release();
		TibSysSoapSettingId = null;
		TibSysSoapversion = null;
	}

	public String getTibSysSoapSettingId() {
		return TibSysSoapSettingId;
	}

	public void setTibSysSoapSettingId(String TibSysSoapSettingId) {
		this.TibSysSoapSettingId = TibSysSoapSettingId;
	}

	public String getTibSysSoapversion() {
		return TibSysSoapversion;
	}

	public void setTibSysSoapversion(String TibSysSoapversion) {
		this.TibSysSoapversion = TibSysSoapversion;
	}

}
