/**
 * 
 */
package com.landray.kmss.km.doc.service.spring;

import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import com.landray.kmss.common.dao.HQLInfo;
import com.landray.kmss.common.service.BaseServiceImp;
import com.landray.kmss.constant.SysAuthConstant;
import com.landray.kmss.constant.SysDocConstant;
import com.landray.kmss.km.doc.model.KmDocKnowledge;
import com.landray.kmss.km.doc.model.KmDocKnowledgePre;
import com.landray.kmss.km.doc.model.KmDocTemplate;
import com.landray.kmss.km.doc.model.KmDocTemplatePreview;
import com.landray.kmss.km.doc.service.IKmDocKnowledgePreService;
import com.landray.kmss.km.doc.service.IKmDocKnowledgeService;
import com.landray.kmss.km.doc.service.IKmDocTemplateService;
import com.landray.kmss.sys.authentication.user.KMSSUser;
import com.landray.kmss.sys.authorization.constant.ISysAuthConstant;
import com.landray.kmss.sys.authorization.interfaces.ISysAuthAreaModel;
import com.landray.kmss.sys.authorization.model.SysAuthArea;
import com.landray.kmss.sys.authorization.service.ISysAuthAreaService;
import com.landray.kmss.util.StringUtil;
import com.landray.kmss.util.UserUtil;

/**
 * @author zhangwentian 2010-9-10
 * @see 2011-08-18 李勇做了性能优化
 */
public class KmDocKnowledgePreServiceImp extends BaseServiceImp implements
		IKmDocKnowledgePreService {
	protected IKmDocKnowledgeService kmDocKnowledgeService;

	protected IKmDocTemplateService kmDocTemplateService;

	private ISysAuthAreaService sysAuthAreaService;

	public void setKmDocKnowledgeService(
			IKmDocKnowledgeService kmDocKnowledgeService) {
		this.kmDocKnowledgeService = kmDocKnowledgeService;
	}

	public void setKmDocTemplateService(
			IKmDocTemplateService kmDocTemplateService) {
		this.kmDocTemplateService = kmDocTemplateService;
	}

	public void setSysAuthAreaService(ISysAuthAreaService sysAuthAreaService) {
		this.sysAuthAreaService = sysAuthAreaService;
	}

	/*
	 * （非 Javadoc）
	 * 
	 * @see
	 * com.landray.kmss.km.doc.service.IKmDocKnowledgePreService#getLatestDoc()
	 * 显示最新的10条发布了的知识文档
	 */
	public List<KmDocKnowledge> getLatestDoc() throws Exception {
		List<KmDocKnowledge> lateseDocList = new ArrayList<KmDocKnowledge>();
		int rowSize = 10;
		String whereBlock = "kmDocKnowledge.docStatus='"
				+ SysDocConstant.DOC_STATUS_PUBLISH + "'";
		HQLInfo hqlInfo = new HQLInfo();
		hqlInfo.setWhereBlock(whereBlock);
		hqlInfo.setOrderBy("kmDocKnowledge.docPublishTime desc");
		hqlInfo.setPageNo(1);
		hqlInfo.setRowSize(rowSize);
		lateseDocList = kmDocKnowledgeService.findPage(hqlInfo).getList();
		return lateseDocList;
	}

	/*
	 * （非 Javadoc）
	 * 
	 * @see
	 * com.landray.kmss.km.doc.service.IKmDocKnowledgePreService#getHotDoc()
	 * 显示最热门的9条发布了的知识文档
	 */
	public List<KmDocKnowledge> getHotDoc() throws Exception {
		List<KmDocKnowledge> hotDocList = new ArrayList<KmDocKnowledge>();
		int rowSize = 10;
		String whereBlock = "kmDocKnowledge.docStatus='"
				+ SysDocConstant.DOC_STATUS_PUBLISH + "'";
		HQLInfo hqlInfo = new HQLInfo();
		hqlInfo.setWhereBlock(whereBlock);
		hqlInfo.setOrderBy("kmDocKnowledge.docReadCount desc");
		hqlInfo.setPageNo(1);
		hqlInfo.setRowSize(rowSize);
		hotDocList = kmDocKnowledgeService.findPage(hqlInfo).getList();
		return hotDocList;
	}

	public List<KmDocTemplatePreview> getMainContent(String authAreaId)
			throws Exception {
		HQLInfo firstHql = new HQLInfo();
		firstHql.setWhereBlock("kmDocTemplate.hbmParent.fdId is null");
		firstHql.setOrderBy("kmDocTemplate.fdOrder asc");
		firstHql.setCheckParam(SysAuthConstant.CheckType.AreaSpecified,
				authAreaId);
		firstHql.setCheckParam(SysAuthConstant.CheckType.AreaIsolation,
				ISysAuthConstant.ISOLATION_SCENE_CATEGORY);
		List<KmDocTemplate> firstCategoryList = kmDocTemplateService
				.findList(firstHql);
		List<KmDocTemplatePreview> kmDocTemplatePreviewList = new ArrayList<KmDocTemplatePreview>();
		// <String, Integer> firstCountMap = getDocAmount("first", authAreaId);
		HQLInfo secondHql = new HQLInfo();
		secondHql
				.setWhereBlock("kmDocTemplate.hbmParent.fdId in(select fdId from kmDocTemplate where kmDocTemplate.hbmParent.fdId is null)");
		secondHql.setOrderBy("kmDocTemplate.fdOrder asc");
		secondHql.setCheckParam(SysAuthConstant.CheckType.AreaSpecified,
				authAreaId);
		secondHql.setCheckParam(SysAuthConstant.CheckType.AreaIsolation,
				ISysAuthConstant.ISOLATION_SCENE_CATEGORY);
		List<KmDocTemplate> secondList = kmDocTemplateService
				.findList(secondHql);
		// Map<String, Integer> secondListCountMap = getDocAmount("second",
		// authAreaId);
		for (KmDocTemplate kmDocTemplate : firstCategoryList) {
			KmDocTemplatePreview kmDocTemplatePreview = new KmDocTemplatePreview();
			kmDocTemplatePreview.setTempName(kmDocTemplate.getFdName());
			kmDocTemplatePreview.setCategoryId(kmDocTemplate.getFdId());
			kmDocTemplatePreview.setDocAmount(getDocAmount(kmDocTemplate,
					authAreaId));
			List<KmDocTemplatePreview> tempList = new ArrayList<KmDocTemplatePreview>();
			for (int i = 0; i < secondList.size(); i++) {
				KmDocTemplate kmDocSecTemplate = secondList.get(i);
				if (kmDocSecTemplate.getHbmParent().getFdId().equals(
						kmDocTemplate.getFdId())) {
					KmDocTemplatePreview kmDocSecTemplatePreview = new KmDocTemplatePreview();
					kmDocSecTemplatePreview.setTempName(kmDocSecTemplate
							.getFdName());
					kmDocSecTemplatePreview.setCategoryId(kmDocSecTemplate
							.getFdId());
					kmDocSecTemplatePreview.setDocAmount(getDocAmount(
							kmDocSecTemplate, authAreaId));
					tempList.add(kmDocSecTemplatePreview);
				}
			}
			kmDocTemplatePreview.setTempList(tempList);
			kmDocTemplatePreview
					.setTrAmount(tempList.size() % 4 == 0 ? tempList.size() / 4
							: tempList.size() / 4 + 1);
			kmDocTemplatePreviewList.add(kmDocTemplatePreview);
		}
		return kmDocTemplatePreviewList;
	}

	public List<KmDocTemplate> getSecDocTemplateList(String categoryId)
			throws Exception {
		String sql = "kmDocTemplate.hbmParent.fdId = '" + categoryId + "'";
		List<KmDocTemplate> secondCategoryList = kmDocTemplateService.findList(
				sql, "kmDocTemplate.fdOrder asc");
		return secondCategoryList;
	}

	public Map<String, Integer> getDocAmount(String firstOrsecond,
			String authAreaId) throws Exception {
		Map<String, Integer> map = new HashMap<String, Integer>();
		HQLInfo hqlInfo = new HQLInfo();
		hqlInfo
				.setSelectBlock("kmDocTemplate.fdId,(select count(*) from KmDocKnowledge b right join b.kmDocTemplate a where b.docIsNewVersion=1 and b.docStatus like '3%' and substring(a.fdHierarchyId,1,length(kmDocTemplate.fdHierarchyId)) = kmDocTemplate.fdHierarchyId)");
		if ("first".equals(firstOrsecond)) {
			hqlInfo.setWhereBlock("kmDocTemplate.hbmParent.fdId is null");
		} else if ("second".equals(firstOrsecond)) {
			hqlInfo
					.setWhereBlock("kmDocTemplate.hbmParent.fdId in(select fdId from KmDocTemplate k where k.hbmParent.fdId is null)");
		}
		// 数据隔离
		hqlInfo.setCheckParam(SysAuthConstant.CheckType.AreaCheck,
				SysAuthConstant.AreaCheck.YES);
		hqlInfo.setCheckParam(SysAuthConstant.CheckType.AreaSpecified,
				authAreaId);

		List ret = kmDocTemplateService.getBaseDao().findList(hqlInfo);
		for (int i = 0; i < ret.size(); i++) {
			Object[] objs = (Object[]) ret.get(i);
			map.put(objs[0].toString(), objs[1] == null ? 0 : Integer
					.parseInt(objs[1].toString()));
		}
		return map;
	}

	private Integer getDocAmount(KmDocTemplate kmDocTemplate, String authAreaId)
			throws Exception {
		String fdHierarchyId = kmDocTemplate.getFdHierarchyId();
		HQLInfo hqlInfo = new HQLInfo();
		hqlInfo.setSelectBlock("count(*)");
		hqlInfo.setFromBlock(" KmDocKnowledge kmDocKnowledge ");
		hqlInfo.setJoinBlock(" right join kmDocKnowledge.kmDocTemplate a ");
		hqlInfo
				.setWhereBlock(" kmDocKnowledge.docIsNewVersion=1 and kmDocKnowledge.docStatus like '3%' and substring(a.fdHierarchyId,1,"
						+ fdHierarchyId.length() + ")='" + fdHierarchyId + "'");
		hqlInfo.setCheckParam(SysAuthConstant.CheckType.AreaSpecified,
				authAreaId);
		List list = kmDocKnowledgeService.findValue(hqlInfo);
		Object ret = list.get(0);
		if (ret == null) {
			return 0;
		} else {
			return Integer.parseInt(ret.toString());
		}
	}

	public Integer getDocAmount(KmDocTemplate kmDocTemplate) throws Exception {
		String fdHierarchyId = kmDocTemplate.getFdHierarchyId();
		HQLInfo hqlInfo = new HQLInfo();
		hqlInfo.setSelectBlock("count(*)");
		hqlInfo.setFromBlock(" KmDocKnowledge b ");
		hqlInfo.setJoinBlock(" right join b.kmDocTemplate a ");
		hqlInfo
				.setWhereBlock(" b.docIsNewVersion=1 and b.docStatus like '3%' and substring(a.fdHierarchyId,1,"
						+ fdHierarchyId.length() + ")='" + fdHierarchyId + "'");

		List list = kmDocKnowledgeService.findValue(hqlInfo);
		Object ret = list.get(0);
		if (ret == null) {
			return 0;
		} else {
			return Integer.parseInt(ret.toString());
		}
	}

	/**
	 * 定时任务更新知识文档概览
	 */
	public String updateKnowledgePre() throws Exception {
		String areaId = UserUtil.getKMSSUser().getAuthAreaId();
		HQLInfo hql = new HQLInfo();
		if (StringUtil.isNotNull(areaId)) {
			hql.setCheckParam(SysAuthConstant.CheckType.AreaSpecified, areaId);
		}
		List<KmDocKnowledgePre> docKnowledgePreList = this.findList(hql);
		if (docKnowledgePreList.size() > 0) {
			for (KmDocKnowledgePre kmDocKnowledgePre : docKnowledgePreList) {
				updateBuildTmp(kmDocKnowledgePre);
			}
		} else {
			return buildTmp();
		}
		return null;
	}

	/**
	 * 更新概览
	 * 
	 * @param pre
	 * @return
	 * @throws Exception
	 */
	private String updateBuildTmp(KmDocKnowledgePre pre) throws Exception {
		String fdPreContent = outContent(pre.getAuthArea() != null ? pre
				.getAuthArea().getFdId() : null);
		pre.setFdPreContent(fdPreContent);
		pre.setDocAlterTime(new Date());
		this.update(pre);
		return fdPreContent.toString();
	}

	/**
	 * 构建分类概览
	 * 
	 * @param fdCategoryId
	 * @return
	 * @throws Exception
	 */
	private String buildTmp() throws Exception {

		String areaId = UserUtil.getKMSSUser().getAuthAreaId();
		String fdPreContent = outContent(areaId);
		KmDocKnowledgePre pre = new KmDocKnowledgePre();
		pre.setFdPreContent(fdPreContent);
		pre.setDocAlterTime(new Date());
		// 设置场所
		if (pre instanceof ISysAuthAreaModel) {
			KMSSUser user = UserUtil.getKMSSUser();
			SysAuthArea authArea = (SysAuthArea) sysAuthAreaService
					.findByPrimaryKey(user.getAuthAreaId());
			pre.setAuthArea(authArea);
		}
		this.add(pre);
		return fdPreContent.toString();
	}

	/**
	 * 生成概览内容
	 * 
	 * @param fdCategoryId
	 * @param authAreaId
	 * @return
	 * @throws Exception
	 */
	public String outContent(String authAreaId) throws Exception {
		List<KmDocTemplatePreview> kmDocTemplatePreviewList = getMainContent(authAreaId);
		JSONArray array1 = new JSONArray();
		for (int i = 0; i < kmDocTemplatePreviewList.size(); i++) {
			KmDocTemplatePreview p1 = kmDocTemplatePreviewList.get(i);
			JSONObject obj1 = new JSONObject();
			obj1.put("text", p1.getTempName());
			obj1.put("count", "(" + p1.getDocAmount() + ")");
			obj1.put("id", p1.getCategoryId());
			obj1.put("href", "/km/doc?categoryId=" + p1.getCategoryId());
			JSONArray array2 = new JSONArray();
			for (int t = 0; t < p1.getTempList().size(); t++) {
				KmDocTemplatePreview p2 = p1.getTempList().get(t);
				JSONObject obj2 = new JSONObject();
				obj2.put("text", p2.getTempName());
				obj2.put("count", "(" + p2.getDocAmount() + ")");
				obj2.put("id", p2.getCategoryId());
				obj2.put("href", "/km/doc?categoryId=" + p2.getCategoryId());
				array2.add(obj2);
			}
			obj1.put("children", array2);
			array1.add(obj1);
		}
		return array1.toString();
	}

	public String getKmDocKnowledgePre() throws Exception {
		String fdPreContent = null;
		List<KmDocKnowledgePre> kmDocKnowledgePreList = new ArrayList<KmDocKnowledgePre>();
		HQLInfo hql = new HQLInfo();
		hql.setCheckParam(SysAuthConstant.CheckType.AreaCheck,
				SysAuthConstant.AreaCheck.YES);
		kmDocKnowledgePreList = this.findList(hql);
		if (!kmDocKnowledgePreList.isEmpty()) {
			fdPreContent = kmDocKnowledgePreList.get(0).getFdPreContent();
		}
		return fdPreContent;
	}
}
