package com.landray.kmss.common.service;

import java.util.List;

import com.landray.kmss.common.actions.RequestContext;
import com.landray.kmss.common.convertor.ConvertorContext;
import com.landray.kmss.common.dao.HQLInfo;
import com.landray.kmss.common.dao.IBaseDao;
import com.landray.kmss.common.forms.IExtendForm;
import com.landray.kmss.common.model.IBaseModel;
import com.sunbor.web.tag.Page;

/**
 * 描述了常用的CRUD以及查询等方法的接口，建议大部分的Service接口继承。<br>
 * 详细方法请参阅{@link IDaoServiceCommon IDaoServiceCommon}<br>
 * 注意：要继承该类，必须<br>
 * <li>对应的model继承类{@link com.landray.kmss.common.model.IBaseModel IBaseModel}；</li>
 * 
 * @see BaseServiceImp
 * @author 叶中奇
 * @version 1.0 2006-04-02
 */
public interface IBaseService {
	/**
	 * @return Dao采用的域模型
	 */
	public abstract String getModelName();

	/**
	 * 将记录更新到数据库中。
	 * 
	 * @param modelObj
	 *            model对象
	 * @throws Exception
	 */
	public abstract String add(IBaseModel modelObj) throws Exception;

	/**
	 * 根据model对象从数据库中删除记录。
	 * 
	 * @param modelObj
	 *            model对象
	 * @throws Exception
	 */
	public abstract void delete(IBaseModel modelObj) throws Exception;

	/**
	 * 刷新Hibernate的Session
	 */
	public void flushHibernateSession();

	/**
	 * 清空Hibernate的Session
	 * 
	 */
	public void clearHibernateSession();

	/**
	 * 根据主键查找记录。
	 * 
	 * @param id
	 * @return model对象
	 * @throws Exception
	 */
	public abstract IBaseModel findByPrimaryKey(String id) throws Exception;

	/**
	 * 根据主键查找记录
	 * 
	 * @param id
	 * @param modelInfo
	 *            域模型信息，可以是域模型的Class，也可以是域模型的全称，若值为null则取xml配置的信息
	 * @param noLazy
	 *            为true则强制从数据库中读取，不做性能优化
	 * @return
	 * @throws Exception
	 */
	public abstract IBaseModel findByPrimaryKey(String id, Object modelInfo,
			boolean noLazy) throws Exception;

	/**
	 * 根据主键数组查找记录列表。
	 * 
	 * @param ids
	 * @return model对象列表
	 * @throws Exception
	 */
	public abstract List findByPrimaryKeys(String[] ids) throws Exception;

	/**
	 * 根据条件查找记录，并返回model对象列表。<br>
	 * 建议在实际业务逻辑的实现中调用本方法，然后再提供给其他地方使用。
	 * 
	 * @param hqlInfo
	 *            HQL的配置信息
	 * @return model对象列表
	 * @throws Exception
	 */
	public abstract List findList(HQLInfo hqlInfo) throws Exception;

	/**
	 * 根据条件查找记录，并返回model对象列表。<br>
	 * 建议在实际业务逻辑的实现中调用本方法，然后再提供给其他地方使用。
	 * 
	 * @param whereBlock
	 *            where的条件（见{@link IHQLInfo#setWhereBlock(java.lang.String)
	 *            IHQLInfo.setWhereBlock(java.lang.String)}）
	 * @param orderBy
	 *            排序列（见{@link IHQLInfo#setOrderBy(java.lang.String)
	 *            IHQLInfo.setOrderBy(java.lang.String)}）
	 * @return model对象列表
	 * @throws Exception
	 */
	public abstract List findList(String whereBlock, String orderBy)
			throws Exception;

	/**
	 * 根据条件查找记录，并返回model对象列表。<br>
	 * 建议在实际业务逻辑的实现中调用本方法，然后再提供给其他地方使用。
	 * 
	 * @param hqlInfo
	 *            HQL配置信息
	 * @return model对象列表
	 * @throws Exception
	 */
	public abstract Page findPage(HQLInfo hqlInfo) throws Exception;

	/**
	 * 根据条件查找记录，并以页面对象返回。<br>
	 * 建议在实际业务逻辑的实现中调用本方法，然后再提供给其他地方使用。
	 * 
	 * @param whereBlock
	 *            where的条件（见{@link IHQLInfo#setWhereBlock(java.lang.String)
	 *            IHQLInfo.setWhereBlock(java.lang.String)}）
	 * @param orderBy
	 *            排序列（见{@link IHQLInfo#setOrderBy(java.lang.String)
	 *            IHQLInfo.setOrderBy(java.lang.String)}）
	 * @param pageno
	 *            第几页
	 * @param rowsize
	 *            每页多少行
	 * @return 页面对象
	 * @throws Exception
	 */
	public abstract Page findPage(String whereBlock, String orderBy,
			int pageno, int rowsize) throws Exception;

	/**
	 * 根据条件查找记录，并返回指定的值。<br>
	 * 建议在实际业务逻辑的实现中调用本方法，然后再提供给其他地方使用。
	 * 
	 * @param hqlInfo
	 *            HQL配置信息
	 * @return 当selectBlock设置的是单个值，则返回由该值组成的List，若设置了多个值，则先由这多个值组成一个数组：Object[]，
	 *         再返回这个数组的List
	 * @throws Exception
	 */
	public abstract List findValue(HQLInfo hqlInfo) throws Exception;

	/**
	 * 根据条件查找记录，并返回指定的值。<br>
	 * 建议在实际业务逻辑的实现中调用本方法，然后再提供给其他地方使用。
	 * 
	 * @param selectBlock
	 *            返回值（见{@link IHQLInfo#setSelectBlock(java.lang.String)
	 *            IHQLInfo.setSelectBlock(java.lang.String)}）
	 * @param whereBlock
	 *            where的条件（见{@link IHQLInfo#setWhereBlock(java.lang.String)
	 *            IHQLInfo.setWhereBlock(java.lang.String)}）
	 * @param orderBy
	 *            排序列（见{@link IHQLInfo#setOrderBy(java.lang.String)
	 *            IHQLInfo.setOrderBy(java.lang.String)}）
	 * @return 当selectBlock设置的是单个值，则返回由该值组成的List，若设置了多个值，则先由这多个值组成一个数组：Object[]，
	 *         再返回这个数组的List
	 * @throws Exception
	 */
	public abstract List findValue(String selectBlock, String whereBlock,
			String orderBy) throws Exception;

	/**
	 * 将记录更新到数据库中。
	 * 
	 * @param modelObj
	 *            model对象
	 * @throws Exception
	 */
	public abstract void update(IBaseModel modelObj) throws Exception;

	/**
	 * 将Form进行转换后，添加到数据库中。
	 * 
	 * @param form
	 * @param requestContext
	 * @return id
	 * @throws Exception
	 */
	public abstract String add(IExtendForm form, RequestContext requestContext)
			throws Exception;

	/**
	 * 进行Form到Model的转换
	 * 
	 * @param form
	 * @param model
	 * @param requestContext
	 * @return Model
	 * @throws Exception
	 */
	public abstract IBaseModel convertFormToModel(IExtendForm form,
			IBaseModel model, RequestContext requestContext) throws Exception;

	/**
	 * 进行Form到Model的转换
	 * 
	 * @param form
	 * @param model
	 * @param context
	 *            转换上下文
	 * @return Model
	 * @throws Exception
	 */
	public abstract IBaseModel convertFormToModel(IExtendForm form,
			IBaseModel model, ConvertorContext context) throws Exception;

	/**
	 * 进行Model到Form的转换
	 * 
	 * @param form
	 * @param model
	 * @param requestContext
	 * @return Form
	 * @throws Exception
	 */
	public abstract IExtendForm convertModelToForm(IExtendForm form,
			IBaseModel model, RequestContext requestContext) throws Exception;

	/**
	 * 进行Model到Form的转换
	 * 
	 * @param form
	 * @param model
	 * @param context
	 *            转换上下文
	 * @return Form
	 * @throws Exception
	 */
	public abstract IExtendForm convertModelToForm(IExtendForm form,
			IBaseModel model, ConvertorContext context) throws Exception;

	/**
	 * 将Model的值clone到Form中
	 * 
	 * @param form
	 * @param model
	 * @param requestContext
	 * @return Form
	 * @throws Exception
	 */
	public abstract IExtendForm cloneModelToForm(IExtendForm form,
			IBaseModel model, RequestContext requestContext) throws Exception;

	/**
	 * 根据记录ID从数据库中删除记录。
	 * 
	 * @param id
	 * @throws Exception
	 */
	public abstract void delete(String id) throws Exception;

	/**
	 * 根据ID数组从数据库中批量删除记录。
	 * 
	 * @param ids
	 * @throws Exception
	 */
	public abstract void delete(String[] ids) throws Exception;

	/**
	 * 将Form进行转换后，更新到数据库中。
	 * 
	 * @param form
	 * @param requestContext
	 * @throws Exception
	 */
	public abstract void update(IExtendForm form, RequestContext requestContext)
			throws Exception;

	/**
	 * 获取BaseDao。
	 * 
	 * @return
	 * @throws Exception
	 */
	public abstract IBaseDao getBaseDao() throws Exception;

}
