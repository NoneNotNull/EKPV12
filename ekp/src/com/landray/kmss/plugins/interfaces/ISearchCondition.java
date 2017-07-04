package com.landray.kmss.plugins.interfaces;

import com.landray.kmss.common.actions.RequestContext;
import com.landray.kmss.sys.config.dict.SysDictCommonProperty;

public interface ISearchCondition {
	public String getType();

	public String getMessageKey() ;
	
	public String getName() ;
	
	public String getDialogJS(RequestContext requestContext, String idField, String nameField);

	public boolean isTreeModel();

	public SysDictCommonProperty getProperty();

	public String getDefaultValue();

	public String getEnumsType();
	
	public String getConditionClassName();
}
