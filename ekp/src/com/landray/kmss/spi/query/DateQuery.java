package com.landray.kmss.spi.query;

import java.util.Date;

public class DateQuery extends BaseQuery {
	public DateQuery(String filed, SearchType type, Date... obj) {
		super(filed, type, obj);
	}
}
