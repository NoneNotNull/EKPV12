package com.landray.kmss.tib.jdbc.actions;

import javax.servlet.http.HttpServletRequest;

import com.landray.kmss.common.actions.ExtendAction;
import com.landray.kmss.common.service.IBaseService;
import com.landray.kmss.tib.jdbc.service.ITibJdbcRelationService;


/**
 * 映射关系 Action
 * 
 * @author 
 * @version 1.0 2013-07-24
 */
public class TibJdbcRelationAction extends ExtendAction {
	protected ITibJdbcRelationService tibJdbcRelationService;

	protected IBaseService getServiceImp(HttpServletRequest request) {
		if(tibJdbcRelationService == null)
			tibJdbcRelationService = (ITibJdbcRelationService)getBean("tibJdbcRelationService");
		return tibJdbcRelationService;
	}
}

