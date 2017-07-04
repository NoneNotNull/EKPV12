package com.landray.kmss.spi.interfaces;

import com.landray.kmss.spi.query.CriteriaQuery;

public interface QueryBuilder {
	public abstract QueryWrapper buildQuery(CriteriaQuery query)
			throws Exception;

}
