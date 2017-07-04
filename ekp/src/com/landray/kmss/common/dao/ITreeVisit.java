package com.landray.kmss.common.dao;

import java.util.List;

import com.sunbor.web.tag.Page;

/**
 * 通用的数遍历接口。<br>
 * 作用范围：Dao层代码，通过bean调用。
 * 
 * @author 叶中奇
 * @version 1.0 2006-6-16
 */
public interface ITreeVisit {
	/**
	 * 获取parentId下的所有子
	 * 
	 * @param parentId
	 *            父ID
	 * @param whereBlock
	 *            where语句
	 * @param orderBy
	 *            排序字段
	 * @return 域模型列表
	 */
	public abstract List findListByParent(String parentId, String whereBlock,
			String orderBy) throws Exception;

	public abstract List findListByParent(String parentId, HQLInfo hqlInfo)
			throws Exception;

	/**
	 * 获取parentId下的所有子的某个字段值
	 * 
	 * @param parentId
	 *            父ID
	 * @param selectBlock
	 *            需要返回的值
	 * @param whereBlock
	 *            where语句
	 * @param orderBy
	 *            排序字段
	 * @return
	 */
	public abstract List findValueByParent(String parentId, String selectBlock,
			String whereBlock, String orderBy) throws Exception;

	public abstract List findValueByParent(String parentId, HQLInfo hqlInfo)
			throws Exception;

	/**
	 * 分页查询parentId下的所有子
	 * 
	 * @param parentId
	 *            父ID
	 * @param whereBlock
	 *            where语句
	 * @param orderBy
	 *            where语句
	 * @param pageno
	 *            第几页
	 * @param rowsize
	 *            每页多少航
	 * @return Page对象
	 * @throws Exception
	 */
	public abstract Page findPageByParent(String parentId, String whereBlock,
			String orderBy, int pageno, int rowsize) throws Exception;

	public abstract Page findPageByParent(String parentId, HQLInfo hqlInfo)
			throws Exception;
}