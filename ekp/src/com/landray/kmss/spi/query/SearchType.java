package com.landray.kmss.spi.query;

import com.landray.kmss.util.StringUtil;

public enum SearchType {
	NE {
		public String getText() {
			return "!=";
		}
	},
	GT {
		public String getText() {
			return ">";
		}
	},
	LT {
		public String getText() {
			return "<";
		}
	},
	EQ {
		public String getText() {
			return "=";
		}
	},
	GE {
		public String getText() {
			return ">=";
		}
	},
	LE {
		public String getText() {
			return "<=";
		}
	},
	BT {
		public String getText() {
			return "between";
		}
	},
	IN {
		public String getText() {
			return "in";
		}
	},
	LIKE {
		public String getText() {
			return "like";
		}
	},
	PREFIX {
		public String getText() {
			return "prefix";
		}
	},
	SUFFIX {
		public String getText() {
			return "suffix";
		}
	},
	LIST {
		public String getText() {
			return "$collection$";
		}
	};
	public static SearchType getTypeByString(String str) throws Exception {
		if (StringUtil.isNull(str)) {
			throw new Exception("字符串错误");
		}
		if (str.toLowerCase().equals("eq")) {
			return SearchType.EQ;
		}
		if (str.toLowerCase().equals("ne")) {
			return SearchType.NE;
		}
		if (str.toLowerCase().equals("gt")) {
			return SearchType.GT;
		}
		if (str.toLowerCase().equals("lt")) {
			return SearchType.LT;
		}
		if (str.toLowerCase().equals("ge")) {
			return SearchType.GE;
		}
		if (str.toLowerCase().equals("le")) {
			return SearchType.LE;
		}
		if (str.toLowerCase().equals("bt")) {
			return SearchType.BT;
		}
		if (str.toLowerCase().equals("in")) {
			return SearchType.IN;
		}
		if (str.toLowerCase().equals("like")) {
			return SearchType.LIKE;
		}
		if (str.toLowerCase().equals("prefix")) {
			return SearchType.PREFIX;
		}
		if (str.toLowerCase().equals("suffix")) {
			return SearchType.SUFFIX;
		}
		if (str.toLowerCase().equals("list")) {
			return SearchType.LIST;
		}
		throw new Exception("字符串错误");
	}

	public abstract String getText();
}
