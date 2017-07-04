/**
 * 
 */
package com.landray.kmss.tib.jdbc.service.bean;

import java.util.List;

import com.landray.kmss.common.actions.RequestContext;
import com.landray.kmss.common.service.IXMLDataBean;
import com.landray.kmss.tib.jdbc.constant.TibJdbcConstant;

/**
 * @author qiujh
 * @version 1.0 2013-10-11
 */
public class TibJdbcExpressionBean implements IXMLDataBean {

	public List getDataList(RequestContext requestInfo) throws Exception {
		String parentId = requestInfo.getParameter("parentId");
		return TibJdbcConstant.EXPRESSION_LIST;
	}
	
}
