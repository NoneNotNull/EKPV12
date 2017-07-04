/**
 * 
 */
package com.landray.kmss.tib.common.inoutdata.interceptor;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import com.landray.kmss.common.dao.IBaseDao;
import com.landray.kmss.common.model.IBaseModel;
import com.landray.kmss.sys.authorization.model.SysAuthRole;
import com.landray.kmss.tib.common.inoutdata.service.spring.TibCommonInoutdataInterceptorImp;

/**
 * @author 邱建华
 * @version 1.0 2013-1-6
 */
public class TibCommonInoutdataAuthRoleInterceptor extends TibCommonInoutdataInterceptorImp {

	private static Log logger = LogFactory
			.getLog(TibCommonInoutdataAuthRoleInterceptor.class);

	@Override
	public IBaseModel beforeSave(IBaseDao baseDao, IBaseModel baseModel) {
		if (baseModel != null && baseModel instanceof SysAuthRole) {
			SysAuthRole sysAuthRole = (SysAuthRole) baseModel;

			// 重要：继承关系交给子类维护，否则会出现导入不正确
			sysAuthRole.getHbmRolesInh().clear();

			if (sysAuthRole.getFdInhRoles().isEmpty()) {
				logger.warn("角色 [" + sysAuthRole.getFdName()
						+ "]， 不存在该模块或者权限分配为空，不进行导入！");
				return null;
			}
		}
		return super.beforeSave(baseDao, baseModel);
	}

	@Override
	public IBaseModel beforeUpdate(IBaseDao baseDao, IBaseModel baseModel) {
		if (baseModel != null && baseModel instanceof SysAuthRole) {
			SysAuthRole sysAuthRole = (SysAuthRole) baseModel;

			// 重要：继承关系交给子类维护，否则会出现导入不正确
			sysAuthRole.getHbmRolesInh().clear();

			if (sysAuthRole.getFdInhRoles().isEmpty()) {
				logger.warn("角色 [" + sysAuthRole.getFdName()
						+ "]， 不存在该模块或者权限分配为空，不进行导入！");
				return null;
			}
		}
		return super.beforeUpdate(baseDao, baseModel);
	}

}
