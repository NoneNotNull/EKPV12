package com.landray.kmss.sys.news.dao;

import java.util.List;

import com.landray.kmss.common.dao.IBaseDao;

/**
 * 创建日期 2007-Sep-17
 * 
 * @author 舒斌 新闻主表单数据访问接口
 */
public interface ISysNewsMainDao extends IBaseDao {
	/**
	 * 根据模板id得到改模板的路径
	 * 
	 * @param templateId
	 * @return
	 * @throws Exception
	 */
	public List getNewsPath(String templateId) throws Exception;

	public void updateTopAgent() throws Exception;
}
