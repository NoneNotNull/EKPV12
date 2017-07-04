package com.landray.kmss.kms.multidoc.service;

import java.util.List;

import com.landray.kmss.common.service.IBaseService;
import com.landray.kmss.kms.multidoc.model.KmsMultidocTemplate;

/**
 * 创建日期 2007-Sep-18
 * 
 * @author 王晖 模板设置业务对象接口
 */
public interface IKmsMultidocTemplateService extends IBaseService {

	public List<?> findLevelOneTemplate() throws Exception;
	
	/**
	 * 
	 * 查找直接的下级子类
	 * @param templateId 
	 * @return
	 * @throws Exception
	 */
	public List<KmsMultidocTemplate> findChildren(String templateId)  throws Exception; 
	/**
	 * 
	 * 查找所有的下级子类
	 * @param templateId 
	 * @return
	 * @throws Exception
	 */
	public List<KmsMultidocTemplate> findChildrenAll(KmsMultidocTemplate template)  throws Exception; 

	/**
	 * 
	 * 是否有同名的模板名称
	 * @param templateId 
	 * @return  true=有重名，false=无重名
	 * @throws Exception
	 */
   public boolean checkTemplateName(String templateId,String templateName,String parentId)throws Exception;
 
}
