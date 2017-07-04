package com.landray.kmss.km.review.util;

import org.apache.commons.lang.StringUtils;
import org.apache.log4j.Logger;

import com.landray.kmss.common.model.IBaseModel;
import com.landray.kmss.km.review.model.KmReviewMain;
import com.landray.kmss.sys.formula.parser.FormulaParser;

/**
 * @todo
 * @author 林秀贤
 * @date 2014-9-29
 */
public class KmReviewTitleUtil {

	private static final Logger logger = Logger
			.getLogger(KmReviewTitleUtil.class);

	/**
	 * 根据标题规则生成标题
	 * 
	 * @param modelObj
	 * @throws Exception
	 */
	public static void genTitle(IBaseModel modelObj) throws Exception {
		KmReviewMain mainModel = (KmReviewMain) modelObj;
		String titleRegulation = mainModel.getFdTemplate().getTitleRegulation();
		if (StringUtils.isNotBlank(titleRegulation)) {
			FormulaParser formulaParser = FormulaParser.getInstance(modelObj);
			Object docSubject = formulaParser.parseValueScript(titleRegulation);
			if (docSubject == null || "".equals(docSubject)) {
				throw new Exception("docSubject is null");
			}
			mainModel.setDocSubject(KmReviewTitleUtil
					.convertObjToString(docSubject));
		}
	}

	/**
	 * 
	 * 
	 * @param obj
	 * @param propName
	 * @return
	 */
	public static String convertObjToString(Object obj) {
		Object scriptValue = obj;
		String reString = "";

		if (scriptValue == null) {
			reString = "";
		} else {
			if (scriptValue.toString().length() > 200) {
				reString = scriptValue.toString().substring(0, 199);
			} else {
				reString = scriptValue.toString();
			}
		}
		return reString;
	}

}
