package com.landray.kmss.kms.multidoc.service;

import java.text.DecimalFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.hibernate.Query;

import com.landray.kmss.common.actions.RequestContext;
import com.landray.kmss.common.dao.HQLInfo;
import com.landray.kmss.common.service.IXMLDataBean;
import com.landray.kmss.kms.multidoc.model.KmsMultidocKnowledge;
import com.landray.kmss.sys.evaluation.model.SysEvaluationMain;
import com.landray.kmss.sys.tag.model.SysTagMain;
import com.landray.kmss.sys.tag.model.SysTagMainRelation;
import com.landray.kmss.sys.tag.model.SysTagTags;
import com.landray.kmss.sys.tag.service.ISysTagMainRelationService;
import com.landray.kmss.sys.tag.service.ISysTagMainService;
import com.landray.kmss.sys.tag.service.ISysTagTagsService;
import com.landray.kmss.util.StringUtil;
import com.landray.kmss.util.UserUtil;

public class KmsMultidocKnowledgeXMLService implements IXMLDataBean {
	// public IKmsWikiMainService kmsWikiMainService;
	private ISysTagTagsService sysTagTagsService;
	private ISysTagMainService sysTagMainService;
	private ISysTagMainRelationService sysTagMainRelationService;
	private IKmsMultidocKnowledgeService kmsMultidocKnowledgeService;
	private String modelName = "com.landray.kmss.kms.multidoc.model.KmsMultidocKnowledge";

	// public void setKmsWikiMainService(IKmsWikiMainService kmsWikiMainService)
	// {
	// this.kmsWikiMainService = kmsWikiMainService;
	// }
	public void setKmsMultidocKnowledgeService(
			IKmsMultidocKnowledgeService kmsMultidocKnowledgeService) {
		this.kmsMultidocKnowledgeService = kmsMultidocKnowledgeService;
	}

	public void setSysTagTagsService(ISysTagTagsService sysTagTagsService) {
		this.sysTagTagsService = sysTagTagsService;
	}

	public void setSysTagMainService(ISysTagMainService sysTagMainService) {
		this.sysTagMainService = sysTagMainService;
	}

	public void setSysTagMainRelationService(
			ISysTagMainRelationService sysTagMainRelationService) {
		this.sysTagMainRelationService = sysTagMainRelationService;
	}

	public List getDataList(RequestContext requestInfo) throws Exception {
		String type = requestInfo.getParameter("type");
		List list = null;
		if (StringUtil.isNotNull(type)) {
			if ("0".equals(type)) { // 更新积分
				list = updateScore(requestInfo);
			}
			if ("1".equals(type)) {// 得到关联数量
				list = findRelationNum(requestInfo);
			}
			if ("2".equals(type) || "3".equals(type)) {// 更新标签
				list = updateTags(requestInfo, type);
			}
			if ("4".equals(type)) { // 分类转移时用
				list = updateTemplate(requestInfo, type);
			}
		}
		return list;
	}

	private List updateScore(RequestContext requestInfo) throws Exception {
		String fdId = requestInfo.getParameter("fdId");
		List rtnList = new ArrayList();
		try {
			if (StringUtil.isNotNull(fdId)) {
				String newScore = "0.0";
				KmsMultidocKnowledge model = (KmsMultidocKnowledge) kmsMultidocKnowledgeService
						.findByPrimaryKey(fdId);
				if (model != null) {
					String sql = "from  SysEvaluationMain  a where  a.fdModelId='"
							+ model.getFdId()
							+ "'  and a.fdModelName='"
							+ modelName + "'";
					Query query = kmsMultidocKnowledgeService.getBaseDao()
							.getHibernateSession().createQuery(sql);
					List<?> snList = query.list();
					int count = 0;
					int j = 0;
					Double score = 0.0d;
					for (int i = 0; i < snList.size(); i++) {
						SysEvaluationMain ev = (SysEvaluationMain) snList
								.get(i);
						if (ev.getFdEvaluationScore() != null) {
							count = 5 - ev.getFdEvaluationScore().intValue()
									+ count;
							j++;
						}
					}
					if (j > 0 && count > 0) {
						score = (double) count / j;
						DecimalFormat dcmFmt = new DecimalFormat("#.0");
						newScore = dcmFmt.format(score);
						model.setDocScore(new Double(newScore));
					} else
						model.setDocScore(score);

					kmsMultidocKnowledgeService.update(model);
					Map map = new HashMap();
					map.put("count", newScore);
					rtnList.add(map);
				}

			}

		} catch (Exception e) {
			e.printStackTrace();
		}

		return rtnList;
	}

	private List findRelationNum(RequestContext requestInfo) throws Exception {
		List rtnList = new ArrayList();
		String fdId = requestInfo.getParameter("fdId");
		String sql = "select a.fdId from  SysRelationMain  a where  a.fdModelId='"
				+ fdId + "' and a.fdModelName='" + modelName + "'";
		Query query = kmsMultidocKnowledgeService.getBaseDao()
				.getHibernateSession().createQuery(sql);
		List<?> snList = query.list();
		Map map = new HashMap();
		if (snList.size() > 0) {
			String fdid = (String) snList.get(0);
			sql = " from SysRelationEntry a where  a.sysRelationMain.fdId='"
					+ fdid + "'";
			query = kmsMultidocKnowledgeService.getBaseDao()
					.getHibernateSession().createQuery(sql);
			snList = query.list();
			if (snList.size() > 0)
				map.put("count", snList.size());
			else
				map.put("count", 1);
		} else
			map.put("count", 0);

		rtnList.add(map);
		return rtnList;
	}

	private List updateTags(RequestContext requestInfo, String type)
			throws Exception {
		String fdId = requestInfo.getParameter("fdId");
		String tags = requestInfo.getParameter("tags");
		KmsMultidocKnowledge kk = (KmsMultidocKnowledge) kmsMultidocKnowledgeService
				.findByPrimaryKey(fdId);
		// 次数减一，再插入
		if (StringUtil.isNotNull(fdId)) {
			try {
				HQLInfo hqlInfo = new HQLInfo();
				String whereBlock = " fdModelId='" + fdId
						+ "' and  fdModelName='" + modelName + "'";
				hqlInfo.setWhereBlock(whereBlock);
				List<SysTagMain> snList = sysTagMainService.findList(hqlInfo);
				SysTagMain sysTagMain = null;

				if (snList.size() > 0) {
					sysTagMain = (SysTagMain) snList.get(0);
				} else {
					if (StringUtil.isNull(tags.trim())) {
						return null;
					} else {
						SysTagMain tagMain = new SysTagMain();
						tagMain.setFdModelId(fdId);
						tagMain.setFdModelName(modelName);
						tagMain.setDocCreator(UserUtil.getUser());
						tagMain.setDocStatus("30");
						tagMain.setDocCreateTime(new Date());
						tagMain.setDocSubject(kk.getDocSubject());
						tagMain.setFdKey("mainDoc");
						sysTagMainService.add(tagMain);
						sysTagMain = tagMain;
					}
				}
				if ("2".equals(type)) {// 引用次数减一
					HQLInfo hqlInfo2 = new HQLInfo();
					String whereBlock2 = " fdMainTag.fdId='"
							+ sysTagMain.getFdId() + "'";
					hqlInfo2.setWhereBlock(whereBlock2);
					List<SysTagMainRelation> snList2 = sysTagMainRelationService
							.findList(hqlInfo2);
					for (SysTagMainRelation l : snList2) {
						String tName = l.getFdTagName();
						sysTagMainRelationService.delete(l);
						List findList = sysTagTagsService.findList(
								"sysTagTags.fdName ='" + tName + "'", null);
						if ((findList != null) && (!findList.isEmpty())) {
							SysTagTags t = (SysTagTags) findList.get(0);
							if (t.getFdQuoteTimes().intValue() > 0)
								t.setFdQuoteTimes(t.getFdQuoteTimes() - 1);
							if (t.getFdCountQuoteTimes().intValue() > 0)
								t
										.setFdCountQuoteTimes(t
												.getFdCountQuoteTimes() - 1);
							sysTagTagsService.update(t);
						}
					}
				}
				if (StringUtil.isNotNull(tags)) {
					String[] tag = tags.split(" ");
					for (int i = 0; i < tag.length; i++) {
						if (StringUtil.isNotNull(tag[i])) {
							SysTagMainRelation tagRelation = new SysTagMainRelation();
							tagRelation.setFdTagName(tag[i]);
							tagRelation.setFdMainTag(sysTagMain);
							sysTagMainRelationService.add(tagRelation);

							List findList = sysTagTagsService
									.findList("sysTagTags.fdName ='" + tag[i]
											+ "'", null);
							if ((findList != null) && (!findList.isEmpty())) {
								SysTagTags t = (SysTagTags) findList.get(0);
								t.setFdQuoteTimes(t.getFdQuoteTimes() + 1);
								t
										.setFdCountQuoteTimes(t
												.getFdCountQuoteTimes() + 1);
								sysTagTagsService.update(t);
							} else {
								SysTagTags tagTags = new SysTagTags();
								tagTags.setFdName(tag[i]);
								tagTags.setFdStatus(Integer.valueOf(1));
								tagTags.setFdIsPrivate(Integer.valueOf(0));
								tagTags.setFdQuoteTimes(Integer.valueOf(1));
								tagTags
										.setFdCountQuoteTimes(Integer
												.valueOf(1));
								sysTagTagsService.add(tagTags);
							}
						}
					}
				} else {
					if (sysTagMain != null)
						sysTagMainService.delete(sysTagMain);
				}
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		return null;
	}

	private List updateTemplate(RequestContext requestInfo, String type)
			throws Exception {
		Map map = new HashMap();
		List rtnList = new ArrayList();
		String fdIds = requestInfo.getParameter("docIds");
		String templateId = requestInfo.getParameter("templateId");
		if (StringUtil.isNull(fdIds) || StringUtil.isNull(templateId))
			map.put("count", 1);
		else {
			// 、String[] ids = fdIds.split("\\s*[;,]\\s*");
			// List<KmsMultidocKnowledge> docs =
			// kmsMultidocKnowledgeService.findByPrimaryKeys(ids);
			kmsMultidocKnowledgeService.updateChgCate(fdIds, templateId,
					requestInfo);
			map.put("count", 0);
		}
		rtnList.add(map);
		return rtnList;
	}

}
