package com.landray.kmss.spi.query;

import java.util.Date;

public class CriteriaBuilder {
	public static CollectionQuery buildAndQuery(BaseQuery... query) {
		CollectionQuery q = new CollectionQuery();
		if (query != null) {
			for (int i = 0; i < query.length; i++) {
				q.and(query[i]);
			}
		}
		return q;
	}

	public static BooleanQuery buildQuery(String filed, SearchType type,
			Boolean... obj) {
		return new BooleanQuery(filed, type, obj);
	}

	public static DateQuery buildQuery(String filed, SearchType type,
			Date... obj) {
		return new DateQuery(filed, type, obj);
	}

	public static DoubleQuery buildQuery(String filed, SearchType type,
			Double... obj) {
		return new DoubleQuery(filed, type, obj);
	}

	public static FloatQuery buildQuery(String filed, SearchType type,
			Float... obj) {
		return new FloatQuery(filed, type, obj);
	}

	public static IntegerQuery buildQuery(String filed, SearchType type,
			Integer... obj) {
		return new IntegerQuery(filed, type, obj);
	}

	public static LongQuery buildQuery(String filed, SearchType type,
			Long... obj) {
		return new LongQuery(filed, type, obj);
	}

	public static StringQuery buildQuery(String filed, SearchType type,
			String... obj) {
		return new StringQuery(filed, type, obj);
	}

	public static ObjectQuery buildQuery(String filed, SearchType type,
			Object... obj) {
		return new ObjectQuery(filed, type, obj);
	}
}
