package com.landray.kmss.common.service;

import java.util.List;

import org.apache.commons.beanutils.BeanUtils;
import org.springframework.beans.BeansException;
import org.springframework.context.ApplicationContext;
import org.springframework.context.ApplicationContextAware;

import com.landray.kmss.common.actions.RequestContext;
import com.landray.kmss.common.dao.HQLInfo;
import com.landray.kmss.util.ModelUtil;
import com.landray.kmss.util.StringUtil;

/**
 * 用于返回分页查询结果的XML的通用Service
 * 
 * @author 叶中奇
 */
public class XMLGetPageService implements IXMLDataBean, ApplicationContextAware {
	ApplicationContext applicationContext;

	public void setApplicationContext(ApplicationContext applicationContext)
			throws BeansException {
		this.applicationContext = applicationContext;
	}

	public List getDataList(RequestContext xmlContext) throws Exception {
		String para = xmlContext.getParameter("service");
		IBaseService baseService = (IBaseService) applicationContext
				.getBean(para);
		String tableName = baseService.getModelName();
		tableName = ModelUtil.getModelTableName(tableName) + ".";

		String whereBlock = null;
		para = xmlContext.getParameter("where");
		if (!StringUtil.isNull(para))
			whereBlock = para;

		para = xmlContext.getParameter("orderby");
		String orderBy = null;
		if (!StringUtil.isNull(para))
			orderBy = para;

		para = xmlContext.getParameter("pageno");
		int pageno = 1;
		if (!StringUtil.isNull(para))
			pageno = Integer.parseInt(para);

		para = xmlContext.getParameter("rowsize");
		int rowsize = 10;
		if (!StringUtil.isNull(para))
			rowsize = Integer.parseInt(para);

		para = xmlContext.getParameter("item");
		String[] itemList = para.split(":");
		HQLInfo hqlInfo = new HQLInfo();
		hqlInfo.setGetCount(false);
		hqlInfo.setWhereBlock(whereBlock);
		hqlInfo.setOrderBy(orderBy);
		hqlInfo.setPageNo(pageno);
		hqlInfo.setRowSize(rowsize);
		List rtnVal = baseService.findPage(hqlInfo).getList();

		for (int i = 0; i < rtnVal.size(); i++) {
			Object node = rtnVal.get(i);
			String[] itemValue = new String[itemList.length];
			for (int j = 0; j < itemList.length; j++) {
				try {
					if (!StringUtil.isNull(itemList[j]))
						itemValue[j] = String.valueOf(BeanUtils.getProperty(
								node, itemList[j]));
				} catch (Exception e) {
					itemValue[j] = "";
					e.printStackTrace();
				}
			}
			rtnVal.set(i, itemValue);
		}
		return rtnVal;
	}
}
