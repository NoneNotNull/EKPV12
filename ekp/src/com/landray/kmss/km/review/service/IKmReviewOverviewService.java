/**
 * 
 */
package com.landray.kmss.km.review.service;

import java.util.List;

import com.landray.kmss.common.service.IBaseService;
import com.landray.kmss.km.review.model.KmReviewMain;
import com.landray.kmss.km.review.model.KmReviewTemPre;
import com.landray.kmss.sys.category.model.SysCategoryMain;

/**
 * @author zhangwentian 2010-9-13
 */
public interface IKmReviewOverviewService extends IBaseService {
	public List<KmReviewMain> getLatestDoc() throws Exception;

	public List<KmReviewMain> getHotDoc() throws Exception;

	public List<KmReviewTemPre>  getContentList(String authAreaId) throws Exception;

	public Integer getDocAmount(SysCategoryMain sysCategoryMain,String authAreaId) throws Exception;

	public Integer getDocAmount(String templateId,String authAreaId) throws Exception;

	public List getSecTemplateList(String categoryId,String authAreaId) throws Exception;

	public List getSecCategoryList(String categoryId,String authAreaId) throws Exception;
	public String updateReview() throws Exception;

	public String getReviewPre() throws Exception;
}
