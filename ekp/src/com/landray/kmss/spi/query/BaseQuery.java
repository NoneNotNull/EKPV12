package com.landray.kmss.spi.query;

import java.util.ArrayList;
import java.util.List;

public class BaseQuery {
	// != <,<=,=,>,>=,in,like,between,ELEMIN
	private SearchType type;
	// 字段名
	private String filed;
	// 参数值
	private List values = new ArrayList();

	public BaseQuery(String filed, SearchType type, Object... obj) {
		this.type = type;
		this.filed = filed;
		if (obj != null) {
			for (int i = 0; i < obj.length; i++) {
				values.add(obj[i]);
			}
		}
	}

	public SearchType getType() {
		return type;
	}

	public String getFiled() {
		return filed;
	}

	public List<?> getValues() {
		return values;
	}
}
