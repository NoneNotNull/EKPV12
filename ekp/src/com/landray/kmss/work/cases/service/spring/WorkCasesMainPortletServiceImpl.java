package com.landray.kmss.work.cases.service.spring;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import com.landray.kmss.common.actions.RequestContext;
import com.landray.kmss.common.dao.HQLInfo;
import com.landray.kmss.common.service.IXMLDataBean;
import com.landray.kmss.constant.SysDocConstant;
import com.landray.kmss.util.DateUtil;
import com.landray.kmss.util.StringUtil;
import com.landray.kmss.work.cases.model.WorkCasesMain;
import com.landray.kmss.work.cases.service.IWorkCasesMainService;

public class WorkCasesMainPortletServiceImpl implements IXMLDataBean {
	protected IWorkCasesMainService workCasesMainService;
	private Log logger = LogFactory.getLog(this.getClass());
	@SuppressWarnings({ "unchecked", "rawtypes" })
	public List getDataList(RequestContext requestInfo) throws Exception {
		HQLInfo hqlInfo = new HQLInfo();
		String whereBlock = "1 = 1";
		whereBlock = StringUtil.linkString(whereBlock, " and ",
				"workCasesMain.docStatus = :docStatus");
		hqlInfo.setParameter("docStatus", SysDocConstant.DOC_STATUS_PUBLISH);
		hqlInfo.setWhereBlock(whereBlock);
		hqlInfo.setOrderBy("workCasesMain.docPublishTime desc,workCasesMain.docCreateTime desc");
		hqlInfo.setPageNo(1);
		hqlInfo.setRowSize(10);
		hqlInfo.setGetCount(false);
		List rtnList = workCasesMainService.findPage(hqlInfo).getList();
		logger.debug("rtnList.size()=" + rtnList.size());
		for (int i = 0; i < rtnList.size(); i++) {
			WorkCasesMain workCasesMain = (WorkCasesMain) rtnList.get(i);
			Map map = new HashMap();
			map.put("catename", workCasesMain.getDocCategory().getFdName());
			map.put("catehref", "/work/cases/?categoryId="
					+ workCasesMain.getDocCategory().getFdId());
			map.put("text", workCasesMain.getDocSubject());
			map.put("created", DateUtil.convertDateToString(
					workCasesMain.getDocPublishTime(), DateUtil.TYPE_DATE,
					requestInfo.getLocale()));
			map.put("creator", workCasesMain.getDocCreator().getFdName());
			StringBuffer sb = new StringBuffer();
			sb.append("/work/cases/work_cases_main/workCasesMain.do?method=view");
			sb.append("&fdId=" + workCasesMain.getFdId());
			map.put("href", sb.toString());
			map.put("id", workCasesMain.getFdId());
			rtnList.set(i, map);
		}
		return rtnList;
	}
	public void setWorkCasesMainService(
			IWorkCasesMainService workCasesMainService) {
		this.workCasesMainService = workCasesMainService;
	}
}

