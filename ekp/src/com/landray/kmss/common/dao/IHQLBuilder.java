package com.landray.kmss.common.dao;

/**
 * HQL语句拼装器接口
 * 
 * @author 叶中奇
 */
public interface IHQLBuilder {
	/**
	 * 拼装HQL语句。
	 * 
	 * @param hqlInfo
	 *            HQL信息
	 */
	public abstract HQLWrapper buildQueryHQL(HQLInfo hqlInfo) throws Exception;

}
