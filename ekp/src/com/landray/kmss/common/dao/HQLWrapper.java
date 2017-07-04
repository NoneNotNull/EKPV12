package com.landray.kmss.common.dao;

import java.util.ArrayList;
import java.util.List;

import com.landray.kmss.spi.interfaces.QueryWrapper;

/**
 * HQL包装器<br>
 * 
 * @author 缪贵荣
 * @version 1.0 2011-01-21
 */
public class HQLWrapper implements QueryWrapper {

	public HQLWrapper() {
		super();
	}

	public HQLWrapper(String hql) {
		super();
		this.hql = hql;
	}

	public HQLWrapper(String hql, List<HQLParameter> parameterList) {
		super();
		this.hql = hql;
		this.parameterList = parameterList;
	}

	/**
	 * hql语句或片段
	 */
	public String hql = null;

	public String getHql() {
		return hql;
	}

	public void setHql(String hql) {
		this.hql = hql;
	}

	/**
	 * hql预编译参数
	 */
	public List<HQLParameter> parameterList = new ArrayList<HQLParameter>();

	public List<HQLParameter> getParameterList() {
		return parameterList;
	}

	public void setParameterList(List<HQLParameter> parameterList) {
		this.parameterList = parameterList;
	}

	public void setParameter(HQLParameter hqlParameter) {
		parameterList.add(hqlParameter);
	}

}
