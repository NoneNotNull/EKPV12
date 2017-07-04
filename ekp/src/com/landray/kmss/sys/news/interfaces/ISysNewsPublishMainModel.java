package com.landray.kmss.sys.news.interfaces;

import com.landray.kmss.common.model.IBaseCreateInfoModel;
import com.landray.kmss.sys.authorization.interfaces.ISysAuthAreaModel;
import com.landray.kmss.sys.news.model.SysNewsPublishMain;
import com.landray.kmss.sys.organization.model.SysOrgElement;
import com.landray.kmss.sys.right.interfaces.IExtendAuthModel;

/**
 * 创建日期 2009-八月-02
 * 
 * @author 周超
 */
public interface ISysNewsPublishMainModel extends IExtendAuthModel,
		IBaseCreateInfoModel, ISysAuthAreaModel {
	public abstract SysNewsPublishMain getSysNewsPublishMain();

	public abstract void setSysNewsPublishMain(
			SysNewsPublishMain sysNewsPublishMain);

	public SysOrgElement getDocDept();// 强制加部门，因为新闻中必须

}
