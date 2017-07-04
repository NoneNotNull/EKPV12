package com.landray.kmss.tib.jdbc.service;

import java.util.List;
import java.util.Map;
import java.util.Set;

import com.landray.kmss.common.actions.RequestContext;
import com.landray.kmss.common.service.IBaseService;

/**
 * 映射配置业务对象接口
 * 
 * @author 
 * @version 1.0 2013-07-24
 */
public interface ITibJdbcMappManageService extends IBaseService {
	public Map getTableData(RequestContext requestInfo) throws Exception;
	
	public Map getDataSource()throws Exception;
	
	public List getTableFieldData(Map paraMap) throws Exception;
	
	public Set<String> getSourceTabFieldData(Map paraMap)throws Exception;
}
