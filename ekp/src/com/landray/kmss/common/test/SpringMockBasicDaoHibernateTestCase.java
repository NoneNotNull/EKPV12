package com.landray.kmss.common.test;

import com.landray.kmss.framework.test.AbstractExtendSpringMockSupportTests;
import com.landray.kmss.sys.authentication.background.IBackgroundAuthAdvanceService;
import com.landray.kmss.util.StringUtil;

/**
 * 测试代码基类，不建议直接继承，仅当BaseTestCase无法满足实际业务需求时才继承该类。
 * 
 * @author 叶中奇
 * @version 1.0 2006-4-3
 */
public abstract class SpringMockBasicDaoHibernateTestCase extends
		AbstractExtendSpringMockSupportTests {
	private IBackgroundAuthAdvanceService backgroundAuthService;

	protected void switchUser(String loginName) {
		try {
			getBackgroundAuthService().switchUser(loginName);
		} catch (Exception e) {
			System.err.println(e);
		}
	}

	protected void onSetUpInTransaction() throws Exception {
		super.onSetUpInTransaction();
		if (!StringUtil.isNull(KmssTestUtil.getDefaultUser()))
			switchUser(KmssTestUtil.getDefaultUser());
	}

	protected IBackgroundAuthAdvanceService getBackgroundAuthService() {
		if (backgroundAuthService == null) {
			backgroundAuthService = (IBackgroundAuthAdvanceService) applicationContext
					.getBean("backgroundAuthService");
		}
		return backgroundAuthService;
	}
}
