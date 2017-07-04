package com.landray.kmss.common.test;

import java.util.Locale;

import com.landray.kmss.common.actions.RequestContext;
import com.landray.kmss.common.forms.IExtendForm;
import com.landray.kmss.common.model.IBaseModel;
import com.landray.kmss.common.service.IBaseService;

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
public abstract class BaseServiceTestCase extends
		SpringMockBasicDaoHibernateTestCase {
	/**
	 * 创建一个model对象，并对其进行赋值。
	 * 
	 * @return model对象
	 */
	protected abstract IExtendForm createFormObject() throws Exception;

	/**
	 * @return service的实现实例
	 */
	protected abstract IBaseService getServiceImp();

	/**
	 * 修改form对象中的值，以校验更新的操作是否成功。
	 * 
	 * @param modelObj
	 */
	protected abstract void changeFormValue(IExtendForm formObj);

	protected RequestContext getRequestContext() {
		RequestContext requestContext = new RequestContext();
		requestContext.setLocale(Locale.CHINA);
		return requestContext;
	}

	/**
	 * 测试常用的创建、按关键字查找、修改、删除操作。
	 * 
	 * @throws Exception
	 */
	public final void testBaseServiceImpCRUD() throws Exception {
		IBaseService serviceImp = getServiceImp();
		RequestContext requestContext = getRequestContext();
		IExtendForm form = createFormObject();

		// 提交Form
		requestContext.setMethod("POST");
		String primaryKey = serviceImp.add(form, requestContext);
		assertNotNull("保存失败：保存后关键字不应该为null", primaryKey);

		// 读取数据
		IBaseModel model = serviceImp.findByPrimaryKey(primaryKey, null, true);
		assertNotNull("执行findByPrimaryKey失败", model);
		String beforeStr = model.toString();
		requestContext.setMethod("GET");
		form = serviceImp.convertModelToForm(null, model, requestContext);

		// 修改数据
		changeFormValue(form);

		// 提交数据
		requestContext.setMethod("POST");
		serviceImp.update(form, requestContext);

		IBaseModel find_modelObj = serviceImp.findByPrimaryKey(primaryKey,
				null, true);
		assertFalse("保存失败，修改前和修改后的值一致", beforeStr.equals(find_modelObj
				.toString()));
		assertEquals("保存失败，保存前和保存后的值不一致", model.toString(), find_modelObj
				.toString());

		// 删除数据
		serviceImp.delete(model);
		assertNull("执行delete(modelobj)失败", serviceImp.findByPrimaryKey(
				primaryKey, null, true));
	}
}
