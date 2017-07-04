package com.landray.kmss.common.test;

import com.landray.kmss.sys.authentication.intercept.IAuthenticationValidateCore;
import com.landray.kmss.sys.authentication.intercept.ValidatorRequestContext;

/**
 * 权限测试代码基类。
 * 
 * @author 叶中奇
 * @version 1.0 2006-4-3
 */
public abstract class BaseAuthenticationTestCase extends
		SpringMockBasicDaoHibernateTestCase {
	private IAuthenticationValidateCore validateCore = null;

	private IAuthenticationValidateCore getValidateCore() {
		if (validateCore == null) {
			validateCore = (IAuthenticationValidateCore) this.applicationContext
					.getBean("authenticationValidateCore");
		}
		return validateCore;
	}

	protected boolean excuteAuthentication(
			ValidatorRequestContext validatorContext) {
		return getValidateCore().checkAuthentication(validatorContext);
	}

	protected boolean excuteAuthentication(String url, String method) {
		return getValidateCore().checkAuthentication(url, method);
	}
}
