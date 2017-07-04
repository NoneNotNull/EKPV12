package com.landray.kmss.tib.common.mapping.constant;

import com.landray.kmss.util.ResourceUtil;

public class TibCommonBussniessExection extends Exception{
	private static final long serialVersionUID = 8247672355494708906L;

	public TibCommonBussniessExection() {
		super();
	}

	public TibCommonBussniessExection(String key) {
		super(ResourceUtil.getString(key, "tib-common-mapping"));
	}

	public TibCommonBussniessExection(String key, Object arg) {
		super(ResourceUtil.getString(key, "tib-common-mapping", null, arg));
	}

	public TibCommonBussniessExection(String key, Object[] args) {
		super(ResourceUtil.getString(key, "tib-common-mapping", null, args));
	}
}
