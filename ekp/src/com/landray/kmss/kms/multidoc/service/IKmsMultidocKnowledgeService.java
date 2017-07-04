package com.landray.kmss.kms.multidoc.service;

import java.util.HashMap;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import com.landray.kmss.common.actions.RequestContext;
import com.landray.kmss.common.dao.HQLWrapper;
import com.landray.kmss.kms.knowledge.model.KmsKnowledgeCategory;
import com.landray.kmss.kms.multidoc.model.KmsMultidocKnowledge;
import com.landray.kmss.sys.doc.service.ISysDocBaseInfoService;
import com.landray.kmss.sys.metadata.interfaces.IExtendDataService;
import com.landray.kmss.sys.organization.model.SysOrgElement;
import com.landray.kmss.sys.quartz.interfaces.SysQuartzJobContext;

/**
 * 创建日期 2006-九月-04
 * 
 * @author 王晖 知识库文档业务对象接口
 */
public interface IKmsMultidocKnowledgeService extends ISysDocBaseInfoService,
		IExtendDataService {


	/**
	 * 根据分类Id来查找分类
	 * 
	 * @param templateId
	 *            模板Id
	 * @return 模板域模型
	 * @throws Exception
	 */
	public KmsKnowledgeCategory getKnowledgeCategory(String categoryId)
			throws Exception;

	/**
	 * 根据传入的文档Id,和模板的Id更新模板
	 * 
	 * @param ids
	 *            主文档的Id,多个值之间用","隔开
	 * @param templateId
	 *            模板的Id
	 * @return
	 * @throws Exception
	 */
	public int updateDucmentTemplate(String ids, String templateId)
			throws Exception;

	/**
	 * 文档过期定时任务
	 * 
	 * @throws Exception
	 */
	public void updateDocExpire(SysQuartzJobContext context) throws Exception;

	/**
	 * 更新sys_relation_static表
	 * 
	 * @throws Exception
	 */
	public void updateRelationStatic(String fdId, String url) throws Exception;

	/**
	 * 得到机构相关信息
	 * 
	 * @throws Exception
	 */
	public List<SysOrgElement> getOrgElement(String orgType, String parentId,
			boolean isAll) throws Exception;

	/**
	 * 通过导入生成文档
	 * 
	 * @throws Exception
	 */
	public abstract void addDocByImportExcel(
			KmsMultidocKnowledge paramKmsMultidocKnowledge) throws Exception;

	/**
	 * 分类转移更新
	 * 
	 * @throws Exception
	 */
	public void updateChgCate(String docIds, String templateId,
			RequestContext requestInfo) throws Exception;

	/**
	 * 设置标签对象
	 * 
	 * @throws Exception
	 */
	public void setTagMain(String docId, String tags) throws Exception;

	/**
	 * 设置附件对象
	 * 
	 * @throws Exception
	 */
	public String setAttachment(String path, KmsMultidocKnowledge mainModel)
			throws Exception;

	/**
	 * 设置属性
	 * 
	 * @throws Exception
	 */
	public void setPropertyList(String docId, List<HashMap> propertyList)
			throws Exception;


	/**
	 * 获取当前分类为第几级分类
	 * 
	 * @throws Exception
	 */
	public int getLevelCount(KmsKnowledgeCategory kmsKnowledgeCategory)
			throws Exception;

	/**
	 * 根据分类拼出该分类的fdSetTopLevel排序码
	 * 
	 * @throws Exception
	 */
	public String getFdSetTopLevel(KmsKnowledgeCategory kmsKnowledgeCategory,
			String str) throws Exception;

	// 经过筛选器筛选后的文档hql（已权限处理）
	public HQLWrapper getDocHql(String whereBlock, String __joinBlock,
			HttpServletRequest request) throws Exception;
			
}
