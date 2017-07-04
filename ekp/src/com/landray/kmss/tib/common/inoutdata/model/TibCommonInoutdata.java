package com.landray.kmss.tib.common.inoutdata.model;

import java.util.ArrayList;
import java.util.List;
import java.util.Set;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * 导出导入model
 * 
 * @author qiujh
 */
public class TibCommonInoutdata {

	/**
	 * 名称
	 */
	private String name;

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	/**
	 * 声明导出的属性名称
	 */
	private Set<String> propertys = null;

	public Set<String> getPropertys() {
		return propertys;
	}

	public void setPropertys(Set<String> propertys) {
		this.propertys = propertys;
	}

	/**
	 * 声明导入的条件
	 */
	private String where;

	public String getWhere() {
		return where;
	}

	public void setWhere(String where) {
		this.where = where;
	}

	private final static Pattern pattern = Pattern.compile(":[^\\s=)<>,]+");

	/**
	 * hql参数
	 * 
	 * @return
	 */
	public List<String> getParams() {
		List<String> paramList = new ArrayList<String>();
		if (where != null) {
			Matcher matcher = pattern.matcher(where);
			while (matcher.find()) {
				paramList.add(matcher.group(0).substring(1));
			}
		}
		return paramList;
	}

	/**
	 * 导入之前拦截事件 需实现
	 * com.landray.kmss.sys.datainit.service.spring.ISysDatainitInterceptor 接口
	 */
	private String interceptor;

	public String getInterceptor() {
		return interceptor;
	}

	public void setInterceptor(String interceptor) {
		this.interceptor = interceptor;
	}

}
