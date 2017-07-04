package com.landray.kmss.spi.query;

import java.util.ArrayList;
import java.util.List;

public class CollectionQuery extends BaseQuery {
	private List<BaseQuery> andList = new ArrayList<BaseQuery>();

	private List<BaseQuery> orList = new ArrayList<BaseQuery>();

	public List<BaseQuery> getAndList() {
		return andList;
	}

	public void setAndList(List<BaseQuery> andList) {
		this.andList = andList;
	}

	public List<BaseQuery> getOrList() {
		return orList;
	}

	public void setOrList(List<BaseQuery> orList) {
		this.orList = orList;
	}

	public CollectionQuery() {
		super("$collection$", SearchType.LIST);
	}

	public void and(BaseQuery query) {
		andList.add(query);
	}

	public void or(BaseQuery query) {
		orList.add(query);
	}

	public String val(SearchType type, List list) throws Exception {
		if (list == null || list.size() < 1) {
			throw new Exception("参数值为空");
		}
		if (type == SearchType.BT) {
			if (list.size() < 2) {
				throw new Exception("参数值为空");
			}
			return list.get(0) + " and " + list.get(1);
		} else if (type == SearchType.IN) {
			String temp = "";
			for (int i = 0; i < list.size(); i++) {
				if (temp.length() > 0) {
					temp += "," + list.get(i);
				} else {
					temp += "" + list.get(i);
				}
			}
			return temp;
		} else {
			return list.get(0) + "";
		}
	}

	public String string() throws Exception {
		StringBuffer sb = new StringBuffer();
		if (andList.size() > 0 || orList.size() > 0) {
			sb.append("(");
			for (int i = 0; i < andList.size(); i++) {
				BaseQuery bq = andList.get(i);
				if (bq.getType() == SearchType.LIST) {
					CollectionQuery cq = (CollectionQuery) bq;
					if (sb.length() > 1) {
						sb.append(" and " + cq.string());
					} else {
						sb.append(cq.string());
					}
				} else {
					if (sb.length() > 1) {
						sb.append(" and " + bq.getFiled() + " "
								+ bq.getType().getText() + " "
								+ val(bq.getType(), bq.getValues()));
					} else {
						sb.append(bq.getFiled() + " " + bq.getType().getText()
								+ " " + val(bq.getType(), bq.getValues()));
					}
				}
			}
			for (int i = 0; i < orList.size(); i++) {
				BaseQuery bq = orList.get(i);
				if (bq.getType() == SearchType.LIST) {
					CollectionQuery cq = (CollectionQuery) bq;
					if (sb.length() > 1) {
						sb.append(" or " + cq.string());
					} else {
						sb.append(cq.string());
					}
				} else {
					if (sb.length() > 1) {
						sb.append(" or " + bq.getFiled() + " "
								+ bq.getType().getText() + " "
								+ val(bq.getType(), bq.getValues()));
					} else {
						sb.append(bq.getFiled() + " " + bq.getType().getText()
								+ " " + val(bq.getType(), bq.getValues()));
					}
				}
			}
			sb.append(")");
		}
		return sb.toString();
	}
}
