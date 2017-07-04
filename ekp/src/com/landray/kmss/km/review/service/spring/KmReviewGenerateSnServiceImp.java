package com.landray.kmss.km.review.service.spring;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.hibernate.LockMode;
import org.hibernate.Query;

import com.landray.kmss.common.service.BaseServiceImp;
import com.landray.kmss.km.review.model.KmReviewSn;
import com.landray.kmss.km.review.model.KmReviewSnContext;
import com.landray.kmss.km.review.service.IKmReviewGenerateSnService;
import com.landray.kmss.km.review.service.IKmReviewSnRule;
import com.landray.kmss.km.review.service.IKmReviewSnService;

/**
 * 
 * @author 李明辉 2010年11月4日
 * 
 *         生成流水号
 * 
 */
public class KmReviewGenerateSnServiceImp extends BaseServiceImp implements
		IKmReviewGenerateSnService {

	private static Log logger = LogFactory
			.getLog(KmReviewGenerateSnServiceImp.class);

	private IKmReviewSnService kmReviewSnService;

	public void setKmReviewSnService(IKmReviewSnService kmReviewSnService) {
		this.kmReviewSnService = kmReviewSnService;
	}

	private IKmReviewSnRule rule = new KmReviewSnDefaultRule();

	public void setRule(IKmReviewSnRule rule) {
		this.rule = rule;
	}

	/**
	 * 
	 * 生成流水号
	 * 
	 * @param context
	 * 
	 * @return String
	 */
	public String getSerialNumber(KmReviewSnContext context) throws Exception {

		String modelName = context.getFdModelName();
		Date curDate = new Date();
		SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
		String curActualDate = format.format(curDate);
		String templateId = context.getFdTemplate().getFdId();
		String prefix = context.getFdPrefix();
		String flowNumber = "";
		String sql = " from com.landray.kmss.km.review.model.KmReviewSn  kmReviewSn where   kmReviewSn.fdModelName =  :modelName and "
				+ " kmReviewSn.fdTemplateId = :templateId and kmReviewSn.fdPrefix = :prefix ";
		// 根据上下文的参数查询符合条件的流水号记录
		Query query = getBaseDao().getHibernateSession().createQuery(sql);
		query.setString("modelName", modelName);
		query.setString("templateId", templateId);
		// query.setString("curDate", curDate);
		query.setString("prefix", prefix);
		query.setLockMode("kmReviewSn", LockMode.UPGRADE);
		List<KmReviewSn> snList = query.list();
		KmReviewSn kmReviewSn = new KmReviewSn();

		// 如果有相应记录，取流水号
		if (snList.size() >= 1) {
			kmReviewSn = snList.get(0);
			String curSqlDate = kmReviewSn.getFdDate();
			if (curActualDate.equalsIgnoreCase(curSqlDate)) {
				context.setFdSn(kmReviewSn.getFdMaxNumber());
				flowNumber = rule.createSerialNumber(context);
				// 把记录中的流水号+1
				kmReviewSn.setFdMaxNumber(kmReviewSn.getFdMaxNumber() + 1);
			} else {
				context.setFdSn(new Long(1));
				flowNumber = rule.createSerialNumber(context);
				kmReviewSn.setFdDate(curActualDate);
				kmReviewSn.setFdMaxNumber(new Long(2));
			}
			kmReviewSnService.update(kmReviewSn);
			if (snList.size() > 1) {
				snList.remove(kmReviewSn);
				for (KmReviewSn kmReviewSnTemp : snList) {
					kmReviewSnService.delete(kmReviewSnTemp);
				}
			}
		} else {
			context.setFdSn(new Long(1));
			flowNumber = rule.createSerialNumber(context);
			// 插入一条记录
			kmReviewSn.setFdDate(curActualDate);
			kmReviewSn.setFdModelName(context.getFdModelName());
			kmReviewSn.setFdMaxNumber(new Long(2));
			kmReviewSn.setFdTemplateId(context.getFdTemplate().getFdId());
			kmReviewSn.setFdPrefix(context.getFdPrefix());
			kmReviewSnService.add(kmReviewSn);
		}
		return flowNumber;
	}

	/**
	 * 
	 * 初始化流水号
	 * 
	 * @param context
	 * 
	 * @return String
	 */
	public void initalizeSerialNumber(KmReviewSnContext context)
			throws Exception {
		String modelName = context.getFdModelName();
		Date curDate = new Date();
		SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
		String curActualDate = format.format(curDate);
		String templateId = context.getFdTemplate().getFdId();
		String prefix = context.getFdPrefix();
		String flowNumber = "";
		String sql = " from com.landray.kmss.km.review.model.KmReviewSn  kmReviewSn where   kmReviewSn.fdModelName =  :modelName and "
				+ " kmReviewSn.fdTemplateId = :templateId and kmReviewSn.fdPrefix = :prefix ";
		// 根据上下文的参数查询符合条件的流水号记录
		Query query = getBaseDao().getHibernateSession().createQuery(sql);
		query.setString("modelName", modelName);
		query.setString("templateId", templateId);
		query.setString("prefix", prefix);
		List<KmReviewSn> snList = query.list();
		if (snList.size() == 0) {
			// 插入一条记录
			KmReviewSn kmReviewSn = new KmReviewSn();
			kmReviewSn.setFdDate(curActualDate);
			kmReviewSn.setFdModelName(context.getFdModelName());
			kmReviewSn.setFdTemplateId(context.getFdTemplate().getFdId());
			kmReviewSn.setFdPrefix(context.getFdPrefix());
			kmReviewSnService.add(kmReviewSn);
		}
	}
}
