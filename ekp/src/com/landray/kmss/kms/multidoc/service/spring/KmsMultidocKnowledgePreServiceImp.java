package com.landray.kmss.kms.multidoc.service.spring;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import com.landray.kmss.common.dao.HQLInfo;
import com.landray.kmss.common.service.BaseServiceImp;
import com.landray.kmss.constant.SysAuthConstant;
import com.landray.kmss.constant.SysDocConstant;
import com.landray.kmss.kms.knowledge.model.KmsKnowledgeCategory;
import com.landray.kmss.kms.knowledge.service.IKmsKnowledgeCategoryService;
import com.landray.kmss.kms.multidoc.model.KmsMultidocKnowledge;
import com.landray.kmss.kms.multidoc.model.KmsMultidocKnowledgePre;
import com.landray.kmss.kms.multidoc.model.KmsMultidocTemplatePreview;
import com.landray.kmss.kms.multidoc.service.IKmsMultidocKnowledgePreService;
import com.landray.kmss.kms.multidoc.service.IKmsMultidocKnowledgeService;
import com.landray.kmss.sys.authentication.user.KMSSUser;
import com.landray.kmss.sys.authorization.interfaces.ISysAuthAreaModel;
import com.landray.kmss.sys.authorization.model.SysAuthArea;
import com.landray.kmss.sys.authorization.service.ISysAuthAreaService;
import com.landray.kmss.util.StringUtil;
import com.landray.kmss.util.UserUtil;

/**
 * @author zhangwentian
 * @update 2012-11-28
 */
public class KmsMultidocKnowledgePreServiceImp extends BaseServiceImp implements
		IKmsMultidocKnowledgePreService {

	protected IKmsMultidocKnowledgeService kmsMultidocKnowledgeService;

	protected IKmsKnowledgeCategoryService kmsKnowledgeCategoryService;

	private ISysAuthAreaService sysAuthAreaService;

	public void setKmsMultidocKnowledgeService(
			IKmsMultidocKnowledgeService kmsMultidocKnowledgeService) {
		this.kmsMultidocKnowledgeService = kmsMultidocKnowledgeService;
	}

	public void setKmsKnowledgeCategoryService(
			IKmsKnowledgeCategoryService kmsKnowledgeCategoryService) {
		this.kmsKnowledgeCategoryService = kmsKnowledgeCategoryService;
	}

	public void setSysAuthAreaService(ISysAuthAreaService sysAuthAreaService) {
		this.sysAuthAreaService = sysAuthAreaService;
	}

	/**
	 * 显示最新的10条发布了的知识文档
	 */
	public List<KmsMultidocKnowledge> getLatestDoc() throws Exception {
		List<KmsMultidocKnowledge> lateseDocList = new ArrayList<KmsMultidocKnowledge>();
		int rowSize = 10;
		String whereBlock = "kmsMultidocKnowledge.docIsNewVersion=1 and kmsMultidocKnowledge.docStatus='"
				+ SysDocConstant.DOC_STATUS_PUBLISH + "'";
		HQLInfo hqlInfo = new HQLInfo();
		hqlInfo.setWhereBlock(whereBlock);
		hqlInfo.setOrderBy("kmsMultidocKnowledge.docPublishTime desc");
		hqlInfo.setPageNo(1);
		hqlInfo.setRowSize(rowSize);
		hqlInfo.setGetCount(false);
		lateseDocList = kmsMultidocKnowledgeService.findPage(hqlInfo).getList();
		return lateseDocList;
	}

	/**
	 * 显示最热门的9条发布了的知识文档
	 */
	public List<KmsMultidocKnowledge> getHotDoc() throws Exception {
		List<KmsMultidocKnowledge> hotDocList = new ArrayList<KmsMultidocKnowledge>();
		int rowSize = 9;
		String whereBlock = "kmsMultidocKnowledge.docIsNewVersion=1 and kmsMultidocKnowledge.docStatus='"
				+ SysDocConstant.DOC_STATUS_PUBLISH + "'";
		HQLInfo hqlInfo = new HQLInfo();
		hqlInfo.setWhereBlock(whereBlock);
		hqlInfo.setOrderBy("kmsMultidocKnowledge.docReadCount desc");
		hqlInfo.setPageNo(1);
		hqlInfo.setRowSize(rowSize);
		hqlInfo.setGetCount(false);
		hotDocList = kmsMultidocKnowledgeService.findPage(hqlInfo).getList();
		return hotDocList;
	}

	/**
	 * 显示最热门的9条发布了的知识文档
	 */
	public List<KmsMultidocKnowledge> getSameTemplateDoc(String fdId,
			String templateId) throws Exception {

		List<KmsMultidocKnowledge> sameList = new ArrayList<KmsMultidocKnowledge>();
		int rowSize = 10;
		String whereBlock = "kmsMultidocKnowledge.docIsNewVersion=1 and kmsMultidocKnowledge.docStatus='"
				+ SysDocConstant.DOC_STATUS_PUBLISH
				+ "' and kmsMultidocKnowledge.fdId!= :knowledgeId and kmsMultidocKnowledge.docCategory.fdId=:templateId";
		HQLInfo hqlInfo = new HQLInfo();
		hqlInfo.setParameter("knowledgeId", fdId);
		hqlInfo.setParameter("templateId", templateId);
		hqlInfo.setWhereBlock(whereBlock);
		hqlInfo.setOrderBy("kmsMultidocKnowledge.docPublishTime desc");
		hqlInfo.setPageNo(1);
		hqlInfo.setRowSize(rowSize);
		sameList = kmsMultidocKnowledgeService.findPage(hqlInfo).getList();
		return sameList;
	}

	/**
	 * 获取多级分类目录列表
	 */
	public List<KmsMultidocTemplatePreview> getMainContent() throws Exception {

		String areaId = UserUtil.getKMSSUser().getAuthAreaId();
		return getMainContent(null, areaId);
	}

	/**
	 * 获取多级分类目录列表
	 * 
	 * @param fdCategoryId
	 * @param authAreaId
	 * @return
	 * @throws Exception
	 */
	private List<KmsMultidocTemplatePreview> getMainContent(
			String fdCategoryId, String authAreaId) throws Exception {

		int size;
		List<KmsKnowledgeCategory> firstCategoryList = this.getCategoryList(
				fdCategoryId, authAreaId);
		List<KmsMultidocTemplatePreview> preList = new ArrayList<KmsMultidocTemplatePreview>();

		for (KmsKnowledgeCategory firstTemplate : firstCategoryList) {
			KmsMultidocTemplatePreview firstPre = new KmsMultidocTemplatePreview();
			firstPre.setTempName(firstTemplate.getFdName());
			firstPre.setCategoryId(firstTemplate.getFdId());
			firstPre.setDocAmount(getDocAmount(firstTemplate, authAreaId));
			List<KmsKnowledgeCategory> secondCategoryList = this
					.getCategoryList(firstTemplate.getFdId(), authAreaId);
			
			
			List<KmsMultidocTemplatePreview> tempList = new ArrayList<KmsMultidocTemplatePreview>();

			for (KmsKnowledgeCategory secTemplate : secondCategoryList) {
				KmsMultidocTemplatePreview scPre = new KmsMultidocTemplatePreview();
				scPre.setTempName(secTemplate.getFdName());
				scPre.setCategoryId(secTemplate.getFdId());
				scPre.setDocAmount(getDocAmount(secTemplate, authAreaId));
				tempList.add(scPre);
			}
			firstPre.setTempList(tempList);
			
			fetchCategoryChilds(secondCategoryList,firstPre,authAreaId);
			preList.add(firstPre);
		}
		return preList;
	}
	//获取特定分类下所有子分类
	private void fetchCategoryChilds(List<KmsKnowledgeCategory> categoryList,
					KmsMultidocTemplatePreview firstPre,String authAreaId) throws Exception{
		List<KmsMultidocTemplatePreview> tempList = new ArrayList<KmsMultidocTemplatePreview>();

		for (KmsKnowledgeCategory secTemplate : categoryList) {
			KmsMultidocTemplatePreview scPre = new KmsMultidocTemplatePreview();
			scPre.setTempName(secTemplate.getFdName());
			scPre.setCategoryId(secTemplate.getFdId());
			scPre.setDocAmount(getDocAmount(secTemplate, authAreaId));
			
			List<KmsKnowledgeCategory> subCategoryList = this
					.getCategoryList(secTemplate.getFdId(), authAreaId);
			fetchCategoryChilds(subCategoryList,scPre,authAreaId);
			tempList.add(scPre);
		}
		firstPre.setTempList(tempList);
	}
	
	/**
	 * 获取子级分类
	 * 
	 * @param categoryId
	 * @param authAreaId
	 * @return
	 * @throws Exception
	 */
	private List<KmsKnowledgeCategory> getCategoryList(String categoryId,
			String authAreaId) throws Exception {

		HQLInfo hqlInfo = new HQLInfo();
		String tableName = "kmsKnowledgeCategory";
		StringBuffer whereBlock = new StringBuffer();
		if (StringUtil.isNotNull(categoryId)) {
			whereBlock.append(tableName);
			whereBlock.append(".hbmParent.fdId = :categoryId");
			hqlInfo.setParameter("categoryId", categoryId);
		} else {
			whereBlock.append(tableName);
			whereBlock.append(".hbmParent.fdId is null");
		}
		whereBlock.append(" and " + tableName
				+ ".fdTemplateType in('1','3')");
		hqlInfo.setWhereBlock(whereBlock.toString());
		hqlInfo.setOrderBy(tableName + ".fdOrder," + tableName + ".fdName,"
				+ tableName + ".fdId asc");

		hqlInfo.setCheckParam(SysAuthConstant.CheckType.AreaIsolation,
				SysAuthConstant.AreaIsolation.BRANCH);
		hqlInfo.setCheckParam(SysAuthConstant.CheckType.AreaSpecified,
				authAreaId);
		hqlInfo.setCheckParam(SysAuthConstant.CheckType.AuthCheck,
				SysAuthConstant.AuthCheck.SYS_NONE);
		List<KmsKnowledgeCategory> categoryList = this.kmsKnowledgeCategoryService
				.findList(hqlInfo);

		return categoryList;
	}

	/**
	 * 根据分类获取文档数量
	 */
	public Integer getDocAmount(KmsKnowledgeCategory kmsKnowledgeCategory,
			String authAreaId) throws Exception {

		String fdHierarchyId = kmsKnowledgeCategory.getFdHierarchyId();
		HQLInfo hqlInfo = new HQLInfo();
		String tableName = "kmsMultidocKnowledge";
		StringBuffer whereBlock = new StringBuffer();
		whereBlock.append("((" + tableName + ".docIsNewVersion=1) and ");
		whereBlock.append(tableName + ".docStatus like '3%') and substring(");
		whereBlock.append(tableName + ".docCategory.fdHierarchyId,1,");
		whereBlock.append(fdHierarchyId.length() + ")='" + fdHierarchyId + "'");

		// String authAreaId = authArea != null ? authArea.getFdId() : null;
		hqlInfo.setWhereBlock(whereBlock.toString());
		hqlInfo.setCheckParam(SysAuthConstant.CheckType.AreaSpecified,
				authAreaId);
		hqlInfo.setCheckParam(SysAuthConstant.CheckType.AuthCheck,
				SysAuthConstant.AuthCheck.SYS_NONE);
		Integer docAmount = kmsMultidocKnowledgeService.findList(hqlInfo)
				.size();
		return docAmount;
	}

	/**
	 * 定时任务更新知识文档概览
	 */
	public void updateKnowledgePre() throws Exception {

		List<KmsMultidocKnowledgePre> docKnowledgePreList = this.findList("",
				"");
		if (docKnowledgePreList.size() > 0) {
			for (KmsMultidocKnowledgePre kmsMultidocKnowledgePre : docKnowledgePreList)
				updateBuildTmp(kmsMultidocKnowledgePre);
		} else {
			buildTmp(null);
		}
	}

	/**
	 * 更新概览
	 * 
	 * @param pre
	 * @return
	 * @throws Exception
	 */
	private String updateBuildTmp(KmsMultidocKnowledgePre pre) throws Exception {

		String fdPreContent = outContent(pre.getFdCategoryId(), pre
				.getAuthArea() != null ? pre.getAuthArea().getFdId() : null);
		pre.setFdPreContent(fdPreContent);
		pre.setDocAlterTime(new Date());
		this.update(pre);
		return fdPreContent.toString();
	}

	/**
	 * 生成分类概览
	 * 
	 * @param fdCategoryId
	 * @param authAreaId
	 * @return
	 * @throws Exception
	 */
	private String outContent(String fdCategoryId, String authAreaId)
			throws Exception {
		JSONArray jsonArray = new JSONArray();
		
		List<KmsMultidocTemplatePreview> templatePreTopList = getMainContent(
				fdCategoryId, authAreaId);
		for (KmsMultidocTemplatePreview kmsMultidocTemplatePreview : templatePreTopList) {
			JSONObject jsonObject = new JSONObject();
			jsonObject.put("id", kmsMultidocTemplatePreview.getCategoryId());
			jsonObject.put("text", kmsMultidocTemplatePreview.getTempName());
			
			if (kmsMultidocTemplatePreview.getDocAmount() > 0) {
				jsonObject.put("docAmount", kmsMultidocTemplatePreview.getDocAmount());
			}
			fetchChilds(kmsMultidocTemplatePreview,jsonObject);
			
			jsonArray.add(jsonObject);
		}
		return jsonArray.toString();

	}
	/**
	 * 获取子分类
	 * 
	 */
	private void fetchChilds(KmsMultidocTemplatePreview kmsMultidocTemplatePreview, JSONObject jsonObject)throws Exception {
		JSONArray array = new JSONArray();
		for (KmsMultidocTemplatePreview temp : kmsMultidocTemplatePreview
				.getTempList()) {
			JSONObject JObject = new JSONObject();
			JObject.put("id",temp.getCategoryId());
			JObject.put("text",temp.getTempName());
			
			if (temp.getDocAmount() > 0) {
				JObject.put("docAmount",temp.getDocAmount());
			}
			fetchChilds(temp,JObject);
			array.add(JObject);
		}
		jsonObject.put("children",array);
	}
	
	
	/**
	 * 构建分类概览
	 * 
	 * @param fdCategoryId
	 * @return
	 * @throws Exception
	 */
	private String buildTmp(String fdCategoryId) throws Exception {

		String areaId = UserUtil.getKMSSUser().getAuthAreaId();
		String fdPreContent = outContent(fdCategoryId, areaId);
		KmsMultidocKnowledgePre pre = new KmsMultidocKnowledgePre();
		pre.setFdCategoryId(fdCategoryId);
		pre.setFdPreContent(fdPreContent);
		pre.setDocAlterTime(new Date());
		// 设置场所
		if (pre instanceof ISysAuthAreaModel) {
			KMSSUser user = UserUtil.getKMSSUser();
			SysAuthArea authArea = (SysAuthArea) sysAuthAreaService
					.findByPrimaryKey(user.getAuthAreaId());
			pre.setAuthArea(authArea);
		}
		this.add(pre);
		return fdPreContent.toString();
	}

	/**
	 * 获取分类概览
	 */
	public String updatePre(String fdCategoryId) throws Exception {

		String content, whereBlock;
		if (StringUtil.isNotNull(fdCategoryId)) {
			whereBlock = "kmsMultidocKnowledgePre.fdCategoryId='"
					+ fdCategoryId + "'";
		} else {
			whereBlock = "kmsMultidocKnowledgePre.fdCategoryId is null or kmsMultidocKnowledgePre.fdCategoryId = ''";
		}
		HQLInfo hqlInfo = new HQLInfo();
		hqlInfo.setWhereBlock(whereBlock);
		hqlInfo.setCheckParam(SysAuthConstant.CheckType.AreaIsolation,
				SysAuthConstant.AreaIsolation.SELF);
		hqlInfo.setCheckParam(SysAuthConstant.CheckType.AreaCheck,
				SysAuthConstant.AreaCheck.YES);
		List<KmsMultidocKnowledgePre> docKnowledgePreList = this
				.findList(hqlInfo);
		if (docKnowledgePreList.size() > 0) {
			content = docKnowledgePreList.get(0).getFdPreContent();
		} else {
			content = buildTmp(fdCategoryId);
		}
		return content;
	}
}
