package com.landray.kmss.kms.knowledge.model;

import java.util.Date;

import com.landray.kmss.sys.organization.model.SysOrgElement;
import com.landray.kmss.util.StringUtil;

/**
 * 文档基本信息
 * 
 * @author
 * @version 1.0 2013-09-26
 */
public class KmsKnowledgeIndex extends KmsKnowledgeBaseDoc {

	private static final long serialVersionUID = 1575299925584611691L;

	public KmsKnowledgeIndex(String fdId, String docSubject, String docStatus,
			String outerAuthor, Date docPublishTime, Boolean docIsIntroduced,
			Long docReadCount, Integer fdKnowledgeType, String docAuthorId,
			KmsKnowledgeCategory docCategory, String fdDescription) {
		super.setFdId(fdId);
		super.setDocSubject(docSubject);
		super.setDocStatus(docStatus);
		super.setOuterAuthor(outerAuthor);
		super.setDocPublishTime(docPublishTime);
		super.setDocIsIntroduced(docIsIntroduced);
		super.setDocReadCount(docReadCount);
		super.setFdKnowledgeType(fdKnowledgeType);
		if (docAuthorId != null) {
			SysOrgElement docAuthor = new SysOrgElement();
			docAuthor.setFdId(docAuthorId);
			super.setDocAuthor(docAuthor);
		}
		if (StringUtil.isNotNull(fdDescription))
			super.setFdDescription(fdDescription);
		super.setDocCategory(docCategory);
	};

//	public KmsKnowledgeIndex(String fdId, String docSubject, String docStatus,
//			String outerAuthor, Date docPublishTime, Boolean docIsIntroduced,
//			Long docReadCount, Integer fdKnowledgeType,
//			SysOrgElement docAuthor, KmsKnowledgeCategory docCategory,
//			String fdDescription) {
//		super.setFdId(fdId);
//		super.setDocSubject(docSubject);
//		super.setDocStatus(docStatus);
//		super.setOuterAuthor(outerAuthor);
//		super.setDocPublishTime(docPublishTime);
//		super.setDocIsIntroduced(docIsIntroduced);
//		super.setFdKnowledgeType(fdKnowledgeType);
//		super.setDocReadCount(docReadCount);
//		super.setDocAuthor(docAuthor);
//		super.setDocCategory(docCategory);
//		super.setFdDescription(fdDescription);
//	};

}
