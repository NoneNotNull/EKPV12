package com.landray.kmss.common.test;

import java.util.List;

import com.landray.kmss.common.dao.IBaseDao;
import com.landray.kmss.common.model.IBaseModel;
import com.landray.kmss.util.ModelUtil;

/**
 * 基于SpringMockBasicDaoHibernateTestCase扩展的测试基类，实现了CRUD等基础操作的测试方法，建议大部分测试类继承。<br>
 * 注意：要继承该类，必须<br>
 * <li>对应的model继承类{@link com.landray.kmss.common.model.BaseModel BaseModel}；</li>
 * <br>
 * <li>对应的Dao实现接口{@link com.landray.kmss.common.dao.IBaseDao IBaseDao}。</li>
 * 
 * @author 叶中奇
 * @version 1.0 2006-4-3
 */
public abstract class BaseDaoTestCase extends
		SpringMockBasicDaoHibernateTestCase {
	/**
	 * 创建一个model对象，并对其进行赋值。
	 * 
	 * @return model对象
	 */
	protected abstract IBaseModel createModelObject() throws Exception;

	/**
	 * @return Dao的实现实例
	 */
	protected abstract IBaseDao getDaoImp();

	/**
	 * 修改model对象中的值，以校验更新的操作是否成功。
	 * 
	 * @param modelObj
	 */
	protected abstract void changeModelValue(IBaseModel modelObj);

	/**
	 * 测试常用的创建、按关键字查找、修改、删除操作。
	 * 
	 * @throws Exception
	 */
	public final void testBaseDaoImpCRUD() throws Exception {
		IBaseModel modelObj = createModelObject();
		IBaseDao daoImp = getDaoImp();
		daoImp.add(modelObj);
		String primaryKey = modelObj.getFdId();
		assertNotNull("保存失败：保存后关键字不能为null", primaryKey);

		IBaseModel find_modelObj = daoImp.findByPrimaryKey(primaryKey, null,
				true);
		assertNotNull("执行findByPrimaryKey失败", find_modelObj);
		assertEquals("执行findByPrimaryKey失败：查找的结果与实际的结果不一致", modelObj,
				find_modelObj);

		// String beforeStr = modelObj.toString();
		changeModelValue(modelObj);
		daoImp.update(modelObj);
		find_modelObj = daoImp.findByPrimaryKey(primaryKey, null, true);
		// assertFalse("执行update失败，修改前和修改后的值一致", beforeStr.equals(find_modelObj
		// .toString()));
		assertEquals("执行update失败，保存前和保存后的值不一致", modelObj.toString(),
				find_modelObj.toString());

		daoImp.delete(modelObj);
		assertNull("执行delete(modelobj)失败", daoImp.findByPrimaryKey(primaryKey,
				null, true));
	}

	/**
	 * 测试FindList的方法是否正常运行。
	 * 
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	public final void testBaseDaoImpFindList() throws Exception {
		IBaseDao daoImp = getDaoImp();
		String tableName = ModelUtil.getModelTableName(daoImp.getModelName());
		IBaseModel obj1 = createModelObject();
		String key1 = daoImp.add(obj1);
		Thread.sleep(1);
		IBaseModel obj2 = createModelObject();
		String key2 = daoImp.add(obj2);

		String idKey = tableName + ".fdId";
		String whereBlock = idKey + "='" + key1 + "' or " + idKey + "='" + key2
				+ "'";

		List findList = daoImp.findList(whereBlock, idKey);
		assertEquals("执行findList（查找记录并根据ID排序）失败：结果条目数错误", findList.size(), 2);
		assertTrue("执行findList（查找记录并根据ID排序）失败：返回结果未包含插入记录", findList.get(0)
				.equals(obj1)
				&& findList.get(1).equals(obj2));
	}

	/**
	 * 测试FindPage的方法是否正常运行。
	 * 
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	public final void testBaseDaoImpFindPage() throws Exception {
		IBaseDao daoImp = getDaoImp();
		String tableName = ModelUtil.getModelTableName(daoImp.getModelName());

		IBaseModel obj1 = createModelObject();
		String key1 = daoImp.add(obj1);
		Thread.sleep(1);
		IBaseModel obj2 = createModelObject();
		String key2 = daoImp.add(obj2);

		String idKey = tableName + ".fdId";
		String whereBlock = idKey + "='" + key1 + "' or " + idKey + "='" + key2
				+ "'";

		List findList = daoImp.findPage(null, null, 1, 5).getList();
		assertTrue("执行findPage（查找所有记录）失败：至少返回2条结果", findList.size() >= 2);

		findList = daoImp.findPage(whereBlock, idKey, 1, 5).getList();
		assertEquals("执行findPage（查找记录并根据ID排序）失败：结果条目数错误", findList.size(), 2);
		assertTrue("执行findPage（查找记录并根据ID排序）失败：返回结果未包含插入记录", findList.get(0)
				.equals(obj1)
				&& findList.get(1).equals(obj2));
	}

	/**
	 * 测试FindValue的方法是否正常运行。
	 * 
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	public final void testBaseDaoImpFindValue() throws Exception {
		IBaseDao daoImp = getDaoImp();
		String tableName = ModelUtil.getModelTableName(daoImp.getModelName());

		IBaseModel obj1 = createModelObject();
		String key1 = daoImp.add(obj1);
		Thread.sleep(1);
		IBaseModel obj2 = createModelObject();
		String key2 = daoImp.add(obj2);

		String idKey = tableName + ".fdId";
		String whereBlock = idKey + "='" + key1 + "' or " + idKey + "='" + key2
				+ "'";

		List findList = daoImp.findValue(idKey, whereBlock, idKey);
		assertEquals("执行findValue（查找记录的ID并根据ID排序）失败：结果条目数错误", findList.size(),
				2);
		assertTrue("执行findValue（查找所有的ID并根据ID排序）失败：返回结果未包含插入记录", findList.get(0)
				.equals(key1)
				&& findList.get(1).equals(key2));
	}
}
