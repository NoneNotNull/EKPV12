package com.landray.kmss.kms.multidoc.actions;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import com.landray.kmss.common.dao.HQLInfo;
import com.landray.kmss.kms.common.actions.KmsOuterSearchAction;
import com.landray.kmss.kms.common.webservice.util.WSUtils;
import com.landray.kmss.kms.multidoc.model.KmsMultidocKnowledge;
import com.landray.kmss.kms.multidoc.service.IKmsMultidocKnowledgeService;
import com.landray.kmss.kms.multidoc.webservice.doc.form.MultidocDocEntity;
import com.landray.kmss.util.DateUtil;
import com.landray.kmss.util.StringUtil;

/**
 * 多维库对外提精确查询处理,主要是针对异构系统的数据交互
 * 
 * @author Administrator
 * 
 */
public class KmsMultidocKnowledgeOuterSearchAction extends KmsOuterSearchAction {

	@Override
	protected List<?> buildResultList(HttpServletRequest request,
			List<?> results) {
		List<MultidocDocEntity> resultList = new ArrayList<MultidocDocEntity>(
				results.size());
		String containerPathPrefix = WSUtils.getContainerContextPath();
		for (Iterator<?> it = results.iterator(); it.hasNext();) {
			KmsMultidocKnowledge knowledge = (KmsMultidocKnowledge) it.next();
			MultidocDocEntity entity = new MultidocDocEntity();
			entity.setDocAutherName(StringUtil.isNotNull(knowledge
					.getOuterAuthor()) ? knowledge.getOuterAuthor() : knowledge
					.getDocAuthor().getFdName());
			entity.setDocPublishTime(DateUtil.convertDateToString(knowledge
					.getDocPublishTime(), DateUtil.PATTERN_DATETIME));
			entity.setDocStatus(knowledge.getDocStatus());
			entity.setDocSubject(knowledge.getDocSubject());
			entity.setFdTemplateName(knowledge.getDocCategory()
					.getFdName());
			String docUrl = containerPathPrefix
					.concat("/kms/multidoc/kms_multidoc_knowledge/kmsMultidocKnowledge.do?method=view&fdId="
							+ knowledge.getFdId()
							+ "&categoryId="
							+ knowledge.getDocCategory().getFdId());
			entity.setDocUrl(docUrl);
			resultList.add(entity);
		}
		return resultList;
	}
	
	

	/**
	 * 文档状态
	 * 
	 * @param request
	 * @param hqlInfo
	 */
	@Override
	protected void changeSearchPageHQLInfo(HttpServletRequest request,
			HQLInfo hqlInfo) {

		String statusBlock = "kmsMultidocKnowledge.docStatus like '3%'";	
		String whereBlock = hqlInfo.getWhereBlock();
		if (StringUtil.isNotNull(hqlInfo.getWhereBlock())) {
			whereBlock = "(" + whereBlock + ")";
		}
		hqlInfo.setWhereBlock(StringUtil.linkString(whereBlock, " and ",
				statusBlock));
	}


	protected IKmsMultidocKnowledgeService kmsMultidocKnowledgeService;

	protected IKmsMultidocKnowledgeService getServiceImp(
			HttpServletRequest request) {
		if (kmsMultidocKnowledgeService == null)
			kmsMultidocKnowledgeService = (IKmsMultidocKnowledgeService) getBean("kmsMultidocKnowledgeService");
		return kmsMultidocKnowledgeService;
	}

}
