package com.landray.kmss.kms.knowledge.service.spring;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import com.landray.kmss.common.actions.RequestContext;
import com.landray.kmss.common.dao.HQLInfo;
import com.landray.kmss.common.service.IXMLDataBean;
import com.landray.kmss.constant.SysAuthConstant;
import com.landray.kmss.kms.knowledge.model.KmsKnowledgeBaseDoc;
import com.landray.kmss.kms.knowledge.service.IKmsKnowledgeBaseDocService;
import com.landray.kmss.util.StringUtil;

public class KmsKnowledgeByCateDatabean implements IXMLDataBean{
	private IKmsKnowledgeBaseDocService kmsKnowledgeBaseDocService;

	public void setKmsKnowledgeBaseDocService(
			IKmsKnowledgeBaseDocService kmsKnowledgeBaseDocService) {
		this.kmsKnowledgeBaseDocService = kmsKnowledgeBaseDocService;
	}
	
	public List<Map<String, Object>> getDataList(RequestContext requestInfo)
	throws Exception {
		String categoryId = requestInfo.getParameter("categoryId");
		
		List<Map<String, Object>> resultList = new ArrayList<Map<String, Object>>();
		if (StringUtil.isNotNull(categoryId)) {
			String fdStatus = requestInfo.getParameter("fdStatus");
			
			Map<String, Object> dataMap = null;
			HQLInfo hqlInfo = new HQLInfo();
			String whereBlock="kmsKnowledgeBaseDoc.docCategory.fdId = :categoryId and kmsKnowledgeBaseDoc.docIsNewVersion=1 ";
			if(StringUtil.isNotNull(fdStatus)){
				whereBlock=whereBlock+" and kmsKnowledgeBaseDoc.docStatus=:docStatus";
				hqlInfo.setParameter("docStatus", fdStatus);
			}
			hqlInfo
					.setWhereBlock(whereBlock);
			hqlInfo.setParameter("categoryId", categoryId);
			hqlInfo.setOrderBy("kmsKnowledgeBaseDoc.docSubject ASC");
			
			if (hqlInfo.getCheckParam(SysAuthConstant.CheckType.AllCheck) == null) {
				hqlInfo.setCheckParam(SysAuthConstant.CheckType.AllCheck,
						SysAuthConstant.AllCheck.DEFAULT);
			}
			
			List<KmsKnowledgeBaseDoc> kmsKnowledgeList = kmsKnowledgeBaseDocService
					.findList(hqlInfo);
			Iterator<KmsKnowledgeBaseDoc> iterator = kmsKnowledgeList.iterator();
			while (iterator.hasNext()) {
				KmsKnowledgeBaseDoc knowledge = iterator.next();
				
				dataMap = new HashMap<String, Object>();
				dataMap.put("name", knowledge.getDocSubject());
				dataMap.put("id", knowledge.getFdId());
				dataMap.put("text", knowledge.getDocSubject());
				dataMap.put("value", knowledge.getFdId());
				
				String description = " ";
				if(StringUtil.isNotNull(knowledge.getFdDescription())){
					description = knowledge.getFdDescription();
				}
				dataMap.put("docDescription", description);
				dataMap.put("docPublishTime", knowledge.getDocPublishTime()==null?"":knowledge.getDocPublishTime());
				dataMap.put("docId", knowledge.getFdId());
				//内外部作者
				if(knowledge.getDocAuthor()!=null){
					dataMap.put("docAuthorName", knowledge.getDocAuthor().getFdName());
				}else{
					dataMap.put("docAuthorName", knowledge.getOuterAuthor());
				}
				dataMap.put("docCategoryName", knowledge.getDocCategory().getFdName());
				dataMap.put("docSubject", knowledge.getDocSubject());
				dataMap.put("fdKnowledgeType", knowledge.getFdKnowledgeType());
				resultList.add(dataMap);
			}
		}
		return resultList;
	}
}
