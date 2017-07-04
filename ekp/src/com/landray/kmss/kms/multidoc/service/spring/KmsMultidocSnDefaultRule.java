package com.landray.kmss.kms.multidoc.service.spring;

import com.landray.kmss.kms.multidoc.model.KmsMultidocSnContext;
import com.landray.kmss.kms.multidoc.service.IKmsMultidocSnRule;
import com.landray.kmss.util.StringUtil;

public class KmsMultidocSnDefaultRule implements IKmsMultidocSnRule {

	/**
	 * 根据上下文生成流水号，规则为“前缀+日期+最大号”，最大号不足4位补“0”。
	 * 
	 * @param kmReviewSnContext
	 *            上下文，用于传递查询流水号的参数及返回信息
	 * @return String;
	 * @throws Exception
	 */
	public String createSerialNumber(KmsMultidocSnContext kmsMultidocSnContext)
			throws Exception {
		String flowNumber = StringUtil.linkString(kmsMultidocSnContext.getFdPrefix(),
				"", kmsMultidocSnContext.getFdDate());
		String sn_str = formatNumber(kmsMultidocSnContext.getFdMaxNumber()
				.longValue());
		return StringUtil.linkString(flowNumber, "", sn_str);

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
