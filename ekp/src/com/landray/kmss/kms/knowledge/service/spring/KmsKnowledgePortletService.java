package com.landray.kmss.kms.knowledge.service.spring;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import net.sf.json.JSONArray;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.json.simple.JSONObject;

import com.landray.kmss.common.dao.HQLInfo;
import com.landray.kmss.common.model.IBaseTreeModel;
import com.landray.kmss.constant.SysDocConstant;
import com.landray.kmss.constant.SysAuthConstant.AuthCheck;
import com.landray.kmss.constant.SysAuthConstant.CheckType;
import com.landray.kmss.kms.knowledge.model.KmsKnowledgeBaseDoc;
import com.landray.kmss.kms.knowledge.model.KmsKnowledgeCategory;
import com.landray.kmss.kms.knowledge.service.IKmsKnowledgeBaseDocService;
import com.landray.kmss.kms.knowledge.service.IKmsKnowledgeCategoryService;
import com.landray.kmss.kms.knowledge.util.KmsKnowledgeUtil;
import com.landray.kmss.sys.cache.KmssCache;
import com.landray.kmss.util.DateUtil;
import com.landray.kmss.util.IDGenerator;
import com.landray.kmss.util.StringUtil;
import com.landray.kmss.util.UserUtil;

public class KmsKnowledgePortletService extends KmsPortletServiceAbstract{

	Log logger = LogFactory.getLog(KmsKnowledgePortletService.class);

	protected IKmsKnowledgeBaseDocService kmsKnowledgeBaseDocService = null;

	public void setKmsKnowledgeBaseDocService(
			IKmsKnowledgeBaseDocService kmsKnowledgeBaseDocService) {
		this.kmsKnowledgeBaseDocService = kmsKnowledgeBaseDocService;
	}

	protected IKmsKnowledgeCategoryService kmsKnowledgeCategoryService;

	public void setKmsKnowledgeCategoryService(
			IKmsKnowledgeCategoryService kmsKnowledgeCategoryService) {
		this.kmsKnowledgeCategoryService = kmsKnowledgeCategoryService;
	}


	/**
	 * 转换数据成JSON
	 * 
	 * @param request
	 * @param kList
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	private JSONArray toDataArray(List kList)
			throws Exception {

		JSONArray rtnArray = new JSONArray();
		for (int i = 0; i < kList.size(); i++) {

			KmsKnowledgeBaseDoc k = (KmsKnowledgeBaseDoc) kList.get(i);
			JSONObject json = new JSONObject();
			json.put("catename", k.getDocCategory().getFdName());
			json.put("catehref", "/kms/knowledge/?categoryId="
					+ k.getDocCategory().getFdId());
			json.put("text", k.getDocSubject());
			json.put("created", DateUtil.convertDateToString(k
					.getDocPublishTime(), DateUtil.PATTERN_DATE));
			// 维基库和文档库的封面key不同
			json.put("image", KmsKnowledgeUtil.getImgUrl(k));
			json
					.put(
							"href",
							"/kms/knowledge/kms_knowledge_base_doc/kmsKnowledgeBaseDoc.do?method=view&fdId="
									+ k.getFdId()
									+ "&fdKnowledgeType="
									+ k.getFdKnowledgeType());
			String author = k.getDocAuthor() != null ? k.getDocAuthor()
					.getFdName() : k.getOuterAuthor();
			json.put("creator", author);
			json.put("intr_c", k.getDocIntrCount());
			json.put("read_c", k.getDocReadCount());
			json.put("eval_c", k.getDocEvalCount());
			// 如果所有阅读者中有所有everyone，则缓存权限标志位，不再缓存权限信息
			if (k.getAuthAllReaders().contains(
					UserUtil.getEveryoneUser())
					|| (k.getAuthReaderFlag() != null && k
							.getAuthReaderFlag())) {
				json.put("authReaderFlag", new Boolean(true));
			} else {
				List<String> authPermissions = new ArrayList<String>();
				authPermissions.addAll(this.lists2Ids(k
						.getAuthAllReaders()));
				authPermissions.addAll(this.lists2Ids(k
						.getAuthAllEditors()));
				json.put("authPermissions", authPermissions);
			}
			rtnArray.add(json);
		}
		return rtnArray;
	}

	/**
	 * 不带权限查询,优先加载缓存数据
	 * 
	 * @param cacheKey
	 * @param request
	 * @return
	 * @throws Exception
	 */
	protected JSONArray findDataWithOutAuth(String cacheKey,
			HttpServletRequest request) throws Exception {
		KmssCache cache = new KmssCache(KmsKnowledgePortletService.class);
		JSONArray pageList = (JSONArray) cache.get(cacheKey);
		if (pageList == null) {
			pageList = findData(request, false);
			cache.put(cacheKey, pageList);
		}
		return pageList;
	}

	/**
	 * 查询数据
	 * 
	 * @param request
	 * @return
	 * @throws Exception
	 */
	protected JSONArray findData(HttpServletRequest request, boolean isWithAuth)
			throws Exception {

		String parentId = request.getParameter("categoryId");
		// 最新、最热、精华
		String type = request.getParameter("type");
		HQLInfo hqlInfo = new HQLInfo();
		hqlInfo.setPageNo(0);
		hqlInfo.setRowSize(DATA_NUM);
		String whereBlock = "kmsKnowledgeBaseDoc.docIsNewVersion =:docIsNewVersion and kmsKnowledgeBaseDoc.docStatus=:docStatus";
		hqlInfo.setParameter("docIsNewVersion", true);
		hqlInfo.setParameter("docStatus", SysDocConstant.DOC_STATUS_PUBLISH);
		// 不过滤权限
		if (!isWithAuth) {
			hqlInfo.setCheckParam(CheckType.AuthCheck, AuthCheck.SYS_NONE);
		}

		if ("docIsIntroduced".equals(type)) {// 精华文档
			whereBlock = StringUtil.linkString(whereBlock, " and ",
					" kmsKnowledgeBaseDoc.docIsIntroduced=:docIsIntroduced");
			hqlInfo.setParameter("docIsIntroduced", true);
			hqlInfo.setOrderBy("kmsKnowledgeBaseDoc.docPublishTime desc");
		} else if ("docPublishTime".equals(type)) {// 最新
			hqlInfo.setOrderBy("kmsKnowledgeBaseDoc.docPublishTime desc");
		} else if ("docReadCount".equals(type)) {// 最热
			hqlInfo.setOrderBy("kmsKnowledgeBaseDoc.docReadCount desc");
		}

		if (StringUtil.isNotNull(parentId)) {
			String [] ids  = parentId.split("\\s*[;,]\\s*");
			String categoryWhere = "";
			for(String id : ids) {
				KmsKnowledgeCategory treeModel = (KmsKnowledgeCategory) this.kmsKnowledgeCategoryService
					.findByPrimaryKey(id);
				categoryWhere = StringUtil.linkString(categoryWhere, " or ", buildCategoryHQL(hqlInfo, treeModel,
						"kmsKnowledgeBaseDoc"));
			}
			if(StringUtil.isNotNull(categoryWhere)) {
				whereBlock = StringUtil.linkString(whereBlock,  " and ", "(" + categoryWhere + ")");
			}
		}
		hqlInfo.setWhereBlock(whereBlock);
		List<?> list = kmsKnowledgeBaseDocService.findPage(hqlInfo).getList();
		return toDataArray(list);
	}

	protected String buildCategoryHQL(HQLInfo hqlInfo,
			IBaseTreeModel treeModel, String tableName) {
		String whereBlock;
		String treeUni = IDGenerator.generateID();
		if (StringUtil.isNull(treeModel.getFdHierarchyId())) {
			whereBlock = tableName + "." + getParentProperty()
					+ ".fdId=:_treeFdId" + treeUni;
			hqlInfo.setParameter("_treeFdId" + treeUni, treeModel.getFdId());
		} else {
			whereBlock = tableName + "." + getParentProperty()
					+ ".fdHierarchyId like :_treeHierarchyId" +  treeUni + " or " + tableName
					+ " in (select elements(knowledgeCategory.knowledges) "
					+ "from KmsKnowledgeCategory knowledgeCategory where "
					+ "knowledgeCategory.fdHierarchyId like :_treeHierarchyId" + treeUni + ")";

			hqlInfo.setParameter("_treeHierarchyId" + treeUni, treeModel
					.getFdHierarchyId()
					+ "%");
		}
		return "(" + whereBlock + ")";
	}

	protected String getParentProperty() {
		return "docCategory";
	}
	
}
