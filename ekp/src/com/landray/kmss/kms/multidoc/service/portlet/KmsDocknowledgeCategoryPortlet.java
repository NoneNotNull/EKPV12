package com.landray.kmss.kms.multidoc.service.portlet;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import net.sf.json.JSON;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import com.landray.kmss.common.actions.RequestContext;
import com.landray.kmss.common.dao.HQLInfo;
import com.landray.kmss.constant.BaseTreeConstant;
import com.landray.kmss.constant.SysAuthConstant;
import com.landray.kmss.kms.common.interfaces.IKmsDataBean;
import com.landray.kmss.kms.multidoc.model.KmsMultidocTemplate;
import com.landray.kmss.kms.multidoc.service.IKmsMultidocTemplateService;
import com.landray.kmss.util.StringUtil;

public class KmsDocknowledgeCategoryPortlet implements IKmsDataBean {

	public JSON getDataJSON(RequestContext requestInfo) throws Exception {
		String fdTemplateId = requestInfo.getParameter("fdTemplateId");
		String s_rowsize = requestInfo.getParameter("s_rowsize");
		String fdCategoryId = requestInfo.getParameter("fdCategoryId");
		int rowSize = 15;
		if (StringUtil.isNotNull(s_rowsize)) {
			rowSize = Integer.parseInt(s_rowsize);
		}
		HQLInfo hqlInfo = new HQLInfo();
		List<KmsMultidocTemplate> kmsMultidocTemplateList = null;
		JSONArray returnObject = new JSONArray();

		if (StringUtil.isNull(fdTemplateId)) {
			// 第一层的多维库分类
			String whereBlock = "kmsMultidocTemplate.hbmParent = null";
			if (StringUtil.isNotNull(fdCategoryId)) {
				whereBlock = "kmsMultidocTemplate.hbmParent = :fdCategoryId";
				hqlInfo.setParameter("fdCategoryId", fdCategoryId);
			}
			hqlInfo.setWhereBlock(whereBlock);
			hqlInfo.setOrderBy("kmsMultidocTemplate.fdOrder asc");
			hqlInfo.setRowSize(rowSize);
			hqlInfo.setAuthCheckType(SysAuthConstant.AUTH_CHECK_NONE);
			hqlInfo.setGetCount(false);
			kmsMultidocTemplateList = kmsMultidocTemplateService.findPage(
					hqlInfo).getList();
			for (int i = 0; i < kmsMultidocTemplateList.size(); i++) {
				KmsMultidocTemplate kmsMultidocTemplate = kmsMultidocTemplateList
						.get(i);
				JSONObject returnValue = new JSONObject();
				returnValue.put("fdId", kmsMultidocTemplate.getFdId());
				returnValue.put("fdText", kmsMultidocTemplate.getFdName());
				String fdHref = requestInfo.getContextPath()
						+ "/kms/multidoc/kms_multidoc_knowledge/kmsMultidocKnowledge.do?method=index&filterType=template&templateId="
						+ kmsMultidocTemplate.getFdId();
				returnValue.put("fdHref", fdHref);
				returnObject.add(returnValue);
			}
		} else {
			// 第二层以后的多维库分类
			String fdHierarchyId = BaseTreeConstant.HIERARCHY_ID_SPLIT
					+ fdTemplateId + BaseTreeConstant.HIERARCHY_ID_SPLIT;
			hqlInfo
					.setWhereBlock(" kmsMultidocTemplate.fdHierarchyId like :fdHierarchyId "
							+ "and kmsMultidocTemplate.hbmParent is not null");
			hqlInfo.setParameter("fdHierarchyId", fdHierarchyId + "%");
			hqlInfo
					.setOrderBy("kmsMultidocTemplate.fdHierarchyId ASC, kmsMultidocTemplate.fdOrder ASC");
			kmsMultidocTemplateList = kmsMultidocTemplateService
					.findList(hqlInfo);
			Iterator<KmsMultidocTemplate> iter = kmsMultidocTemplateList
					.iterator();

			int count, count2;
			List groupList = new ArrayList();
			List group = null;

			while (iter.hasNext()) {
				KmsMultidocTemplate kmsMultidocTemplate = iter.next();
				String tmpHierarchyId = kmsMultidocTemplate.getFdHierarchyId();
				// 计算BaseTreeConstant.HIERARCHY_ID_SPLIT在每个类别的
				// hierarchyId中出现的次数
				tmpHierarchyId = tmpHierarchyId.substring((tmpHierarchyId
						.indexOf(fdTemplateId)) - 1);
				count = charOccurCounter(tmpHierarchyId, 'x');
				// 当count次数为3, 4之间的时候，即类别为第二和第三层级的时候
				// 将类别信息保存到JSON对象当中去
				if (count <= 4 && count >= 3) {
					// 当类别为第2层级的时候
					if (count == 3) {
						group = new ArrayList();
						groupList.add(group);
					}

					// if (group.size() <= limit) {
					Map elem = new HashMap();
					elem.put("fdId", kmsMultidocTemplate.getFdId());
					elem.put("fdLevel", count - 1);
					elem.put("fdText", kmsMultidocTemplate.getFdName());
					String fdHref = requestInfo.getContextPath()
							+ "/kms/multidoc/kms_multidoc_knowledge/kmsMultidocKnowledge.do?method=index&filterType=template&templateId="
							+ kmsMultidocTemplate.getFdId();
					elem.put("fdHref", fdHref);
					group.add(elem);
					// }
				}
			}

			for (int i = 0; i < groupList.size(); i++) {
				group = (List) groupList.get(i);
				JSONArray hierarchy = new JSONArray();
				for (int j = 0; j < group.size(); j++) {
					Map elem = (Map) group.get(j);
					JSONObject returnValue = new JSONObject();
					returnValue.put("fdId", elem.get("fdId"));
					returnValue.put("fdLevel", elem.get("fdLevel"));
					returnValue.put("fdText", elem.get("fdText"));
					returnValue.put("fdHref", elem.get("fdHref"));
					hierarchy.add(returnValue);
				}

				returnObject.add(hierarchy);
			}
		}

		return returnObject;
	}

	private IKmsMultidocTemplateService kmsMultidocTemplateService;

	public void setKmsMultidocTemplateService(
			IKmsMultidocTemplateService kmsMultidocTemplateService) {
		this.kmsMultidocTemplateService = kmsMultidocTemplateService;
	}

	private int charOccurCounter(String s, char c) {
		int count = 0;
		for (int i = 0; i < s.length(); i++) {
			if (s.charAt(i) == c)
				count++;
		}
		return count;
	}

}
