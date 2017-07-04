package com.landray.kmss.km.review.service.spring;

import com.landray.kmss.km.review.model.KmReviewSnContext;
import com.landray.kmss.km.review.service.IKmReviewSnRule;
import com.landray.kmss.util.StringUtil;

/**
 * 实现IKmReviewSnRule接口，根据自定义规则组装流水号
 * 
 * @author李明辉
 * 
 */

public class KmReviewSnDefaultRule implements IKmReviewSnRule {

	/**
	 * 根据上下文生成流水号，规则为“前缀+日期+最大号”，最大号不足4位补“0”。
	 * 
	 * @param kmReviewSnContext
	 *            上下文，用于传递查询流水号的参数及返回信息
	 * @return String;
	 * @throws Exception
	 */
	public String createSerialNumber(KmReviewSnContext kmReviewSnContext)
			throws Exception {
		String flowNumber = StringUtil.linkString(kmReviewSnContext
				.getFdPrefix(), "", kmReviewSnContext.getFdDate());
		// String templateId = kmReviewSnContext.getFdTemplate().getFdId();
		// flowNumber = StringUtil.linkString(flowNumber, "", templateId);
		String sn_str = formatNumber(kmReviewSnContext.getFdMaxNumber()
				.longValue());
		flowNumber = StringUtil.linkString(flowNumber, "", sn_str);

		return flowNumber;
	}

	/**
	 * 格式化数字,没有四位长度时,补足四位
	 * 
	 * @param number
	 * @return
	 */
	private String formatNumber(long number) {
		StringBuffer buffer = new StringBuffer();
		if (number < 10L) {
			buffer.append("000");
		} else if (number < 100L) {
			buffer.append("00");
		} else if (number < 1000) {
			buffer.append("0");
		}
		buffer.append(number);
		return buffer.toString();
	}

}
