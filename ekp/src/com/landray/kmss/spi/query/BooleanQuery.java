package com.landray.kmss.spi.query;

public class BooleanQuery extends BaseQuery {

	public BooleanQuery(String filed, SearchType type, Boolean... obj) {
		super(filed, type, obj);
	}

}
