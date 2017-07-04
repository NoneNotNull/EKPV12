package com.landray.kmss.tib.sys.soap.connector.util.header.licence;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.servlet.jsp.JspException;

import com.landray.kmss.web.taglib.xform.AbstractDataSourceTag;
import com.landray.kmss.web.taglib.xform.DataSourceType;

@SuppressWarnings("serial")
public class LicenceHeaderPluginsTag extends AbstractDataSourceTag{

	@Override
	protected List<DataSourceType> acquireResult() throws JspException {
		
		List<Map<String, String>> configs = LicenceHeaderPlugin.getConfigs();
		List<DataSourceType> result = new ArrayList<DataSourceType>();
		for(Map<String, String> config :configs){
			DataSourceType dsType = new DataSourceType();
			String displayName = config.get(LicenceHeaderPlugin.displayName);
			String valueKey = config.get(LicenceHeaderPlugin.handlerKey);
			dsType.setName(displayName);
			dsType.setValue(valueKey);
			result.add(dsType);
		}
		return result;
	}
	
	

}
