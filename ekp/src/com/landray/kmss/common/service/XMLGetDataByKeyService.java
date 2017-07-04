package com.landray.kmss.common.service;

import java.util.List;

import org.springframework.beans.BeansException;
import org.springframework.context.ApplicationContext;
import org.springframework.context.ApplicationContextAware;

import com.landray.kmss.common.actions.RequestContext;
import com.landray.kmss.util.ModelUtil;
import com.landray.kmss.util.StringUtil;

/**
 * 用于根据key值返回查询结果的XML的通用Service
 * 
 * @author 叶中奇
 */
public class XMLGetDataByKeyService implements IXMLDataBean,
		ApplicationContextAware {
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
		para = xmlContext.getParameter("value");
		if (!StringUtil.isNull(para)) {
			whereBlock = " in (" + para + ")";
			para = xmlContext.getParameter("key");
			if (StringUtil.isNull(para))
				para = "fdId";
			whereBlock = tableName + para + whereBlock;
		}
		para = xmlContext.getParameter("item");
		String[] itemList = para.split(":");
		String selectBlock = "";
		for (int i = 0; i < itemList.length; i++)
			selectBlock += "," + tableName + itemList[i];
		selectBlock = selectBlock.substring(1);
		para = xmlContext.getParameter("orderby");
		String orderBy = null;
		if (!StringUtil.isNull(para)) {
			itemList = para.split(":");
			orderBy = "";
			for (int i = 0; i < itemList.length; i++)
				orderBy += "," + tableName + itemList[i];
			orderBy = orderBy.substring(1);
		}
		return baseService.findValue(selectBlock, whereBlock, orderBy);
	}
}
