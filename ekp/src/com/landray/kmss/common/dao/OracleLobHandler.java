package com.landray.kmss.common.dao;

import org.springframework.jdbc.support.nativejdbc.NativeJdbcExtractor;
import org.springframework.jdbc.support.nativejdbc.WebSphereNativeJdbcExtractor;

public class OracleLobHandler extends
		org.springframework.jdbc.support.lob.OracleLobHandler {
	private String hibernateDialect;

	public String getHibernateDialect() {
		return hibernateDialect;
	}

	public void setHibernateDialect(String hibernateDialect) {
		this.hibernateDialect = hibernateDialect;
	}

	public boolean isOracle() {
		return hibernateDialect != null
				&& hibernateDialect
						.equals("org.hibernate.dialect.Oracle9Dialect");
	}

	private static final String WEBSPHERE_CLASS = "/com/ibm/websphere/product/VersionInfo.class";

	private boolean isWebSphere() {
		if (getClass().getResource(WEBSPHERE_CLASS) != null) {
			return true;
		}
		return false;
	}

	@Override
	public void setNativeJdbcExtractor(NativeJdbcExtractor nativeJdbcExtractor) {
		if (isWebSphere()) {
			// 解决websphere下大字段保存出错问题
			super.setNativeJdbcExtractor(new WebSphereNativeJdbcExtractor());
		} else {
			super.setNativeJdbcExtractor(nativeJdbcExtractor);
		}
	}

}
