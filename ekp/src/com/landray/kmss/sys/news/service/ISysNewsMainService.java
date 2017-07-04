package com.landray.kmss.sys.news.service;

import java.util.List;
import java.util.Map;

import com.landray.kmss.common.actions.RequestContext;
import com.landray.kmss.sys.metadata.interfaces.IExtendDataService;

/**
 * 创建日期 2007-Sep-17
 * 
 * @author 舒斌 新闻主表单业务对象接口
 */
public interface ISysNewsMainService extends IExtendDataService {

	/**
	 * 批量转移文档
	 * 
	 * @param ids
	 * @param templateId
	 * @throws Exception
	 */
	public void updateTemplate(String[] ids, String templateId)
			throws Exception;

	/**
	 * 置顶设置
	 * 
	 * @param ids
	 *            list界面选择的记录ID集
	 * @param days
	 *            置顶天数
	 * @param isTop
	 *            操作指示;true表示置顶,false表示取消置顶
	 * @throws Exception
	 */
	public void updateTop(String[] ids, Long days, boolean isTop)
			throws Exception;

	public void updateTopAgent() throws Exception;

	/**
	 * 得到新闻的路径
	 * 
	 * @param templateId
	 * @return
	 * @throws Exception
	 */
	public StringBuffer getNewsPath(String templateId) throws Exception;

	/**
	 * 取消或重新发布
	 * 
	 * @param ids
	 * @param op
	 *            false为表示取消发布，为true表示重新发布
	 * @throws Exception
	 */
	public void updatePublish(String[] ids, boolean op) throws Exception;

	/**
	 * 与模板同步权限
	 * 
	 * @param tmpId
	 *            -- 模板ID
	 * @throws Exception
	 */
	public void updateAuthWithTmp(String tmpId) throws Exception;

	public List findListPublishRecord(String fdModelName, String fdModelId)
			throws Exception;

	/**
	 * 得到图片+内容portlet数据
	 * 
	 * @param requestInfo
	 * @return
	 * @throws Exception
	 */
	public Map<String, Object> getPortletDataMap(RequestContext requestInfo)
			throws Exception;

}
