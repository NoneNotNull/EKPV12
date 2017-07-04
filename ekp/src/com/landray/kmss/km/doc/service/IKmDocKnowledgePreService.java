/**
 * 
 */
package com.landray.kmss.km.doc.service;

import java.util.List;

import com.landray.kmss.common.service.IBaseService;
import com.landray.kmss.km.doc.model.KmDocKnowledge;
import com.landray.kmss.km.doc.model.KmDocTemplate;
import com.landray.kmss.km.doc.model.KmDocTemplatePreview;

/**
 * @author zhangwentian 2010-9-9
 */
public interface IKmDocKnowledgePreService extends IBaseService {

	public List<KmDocKnowledge> getLatestDoc() throws Exception;

	public List<KmDocKnowledge> getHotDoc() throws Exception;

	public List<KmDocTemplatePreview> getMainContent(String authAreaId) throws Exception;

	public Integer getDocAmount(KmDocTemplate kmDocTemplate) throws Exception;

	public List getSecDocTemplateList(String categoryId) throws Exception;

	public String updateKnowledgePre() throws Exception;

	public String getKmDocKnowledgePre() throws Exception;

}
