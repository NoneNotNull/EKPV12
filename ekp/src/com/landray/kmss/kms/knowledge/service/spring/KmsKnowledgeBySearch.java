package com.landray.kmss.kms.knowledge.service.spring;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import com.landray.kmss.common.actions.RequestContext;
import com.landray.kmss.common.dao.HQLInfo;
import com.landray.kmss.common.service.IXMLDataBean;
import com.landray.kmss.kms.knowledge.model.KmsKnowledgeBaseDoc;
import com.landray.kmss.kms.knowledge.service.IKmsKnowledgeBaseDocService;
import com.landray.kmss.util.StringUtil;

public class KmsKnowledgeBySearch implements IXMLDataBean {
	private IKmsKnowledgeBaseDocService kmsKnowledgeBaseDocService;

	public void setKmsKnowledgeBaseDocService(
			IKmsKnowledgeBaseDocService kmsKnowledgeBaseDocService) {
		this.kmsKnowledgeBaseDocService = kmsKnowledgeBaseDocService;
	}
	
	public List getDataList(RequestContext requestInfo) throws Exception {
		List rtnList = new ArrayList();
		String key = requestInfo.getRequest().getParameter("key");
		String whereBlock = "";
		HQLInfo hqlInfo = new HQLInfo();
		if (StringUtil.isNotNull(key)) {
			whereBlock = "kmsKnowledgeBaseDoc.docSubject like :key";
			hqlInfo.setParameter("key", "%"+key+"%");
		}
		hqlInfo.setDistinctType(HQLInfo.DISTINCT_YES);
		hqlInfo.setWhereBlock(whereBlock);
		
		List<KmsKnowledgeBaseDoc> kmsKnowledgeList = 
						kmsKnowledgeBaseDocService.findList(hqlInfo);
		Map<String, Object> dataMap = null;
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
			rtnList.add(dataMap);
		}
		return rtnList;
	}

}
