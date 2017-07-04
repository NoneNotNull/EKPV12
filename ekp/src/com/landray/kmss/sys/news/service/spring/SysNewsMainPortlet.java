package com.landray.kmss.sys.news.service.spring;

import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import com.landray.kmss.common.actions.RequestContext;
import com.landray.kmss.common.dao.HQLInfo;
import com.landray.kmss.common.model.BaseModel;
import com.landray.kmss.common.service.IXMLDataBean;
import com.landray.kmss.constant.SysAuthConstant;
import com.landray.kmss.constant.SysDocConstant;
import com.landray.kmss.sys.attachment.model.SysAttMain;
import com.landray.kmss.sys.attachment.service.ISysAttMainCoreInnerService;
import com.landray.kmss.sys.authorization.constant.ISysAuthConstant;
import com.landray.kmss.sys.cache.KmssCache;
import com.landray.kmss.sys.news.model.SysNewsConfig;
import com.landray.kmss.sys.news.model.SysNewsMain;
import com.landray.kmss.sys.news.service.ISysNewsMainService;
import com.landray.kmss.sys.news.service.ISysNewsTemplateService;
import com.landray.kmss.sys.portal.util.PortletTimeUtil;
import com.landray.kmss.sys.simplecategory.interfaces.SimpleCategoryUtil;
import com.landray.kmss.sys.simplecategory.model.ISysSimpleCategoryModel;
import com.landray.kmss.util.ArrayUtil;
import com.landray.kmss.util.DateUtil;
import com.landray.kmss.util.ModelUtil;
import com.landray.kmss.util.StringUtil;
import com.landray.kmss.util.UserUtil;

public class SysNewsMainPortlet implements IXMLDataBean {
	private static final Log logger = LogFactory
			.getLog(SysNewsMainPortlet.class);
	protected ISysNewsMainService sysNewsMainService = null;

	protected ISysNewsTemplateService sysNewsTemplateService = null;

	protected ISysAttMainCoreInnerService sysAttMainCoreInnerService = null;

	public List getDataList(RequestContext requestInfo) throws Exception {
		
		Boolean isPermission = getPermission();
		List<Map> rtnList = new ArrayList<Map>();
		List authOrgIds = new ArrayList();
		String parentId = requestInfo.getParameter("cateid");
		// 如果为空则表示没有类别，取所有
		if (StringUtil.isNull(parentId)) {
			parentId = "all";
		}
		String para = requestInfo.getParameter("rowsize");
		int rowsize = 10;
		if (!StringUtil.isNull(para))
			rowsize = Integer.parseInt(para);
		String type = requestInfo.getParameter("type");
		List<Map> newsList = null;
		// 当启用了集团分级授权，则直接从数据库中查询数据，因为缓存的数据在切换场所时会导致数据不全
		if (ISysAuthConstant.IS_AREA_ENABLED) {
			newsList = getNewsWithAuth(rowsize, type, parentId, requestInfo);
			return newsList;
		} else {
			// 从缓存中取数据
			newsList = getNewsCacheWithOutAuth(parentId, requestInfo);
		}

		// 如果是管理员或拥有模块权限则无需取登录用户相关组织架构
		if (!isPermission) {
			authOrgIds = UserUtil.getKMSSUser().getUserAuthInfo()
					.getAuthOrgIds();
		}
		// 剩余条数
		int num = rowsize;
		for (int i = 0; i < newsList.size() && num != 0; i++) {
			Map rtnMap = new HashMap();
			Map map = newsList.get(i);
			// 如果是管理员或拥有模块权限则不进行权限过滤，直接获取rowsize的新闻记录即可
			if (!isPermission) {
				Boolean authReaderFlag = (Boolean) map.get("authReaderFlag");
				// 判断权限标志位,如果不是所有可以阅读则进行权限过滤
				if (authReaderFlag == null || !authReaderFlag) {
					List<String> authPermissions = (List<String>) map
							.get("authPermissions");
					// 判断有权限的组织架构是否和该登录用户的相关组织架构有交集，如果没有交集则没有权限
					Boolean permission = ArrayUtil.isListIntersect(
							authPermissions, authOrgIds);
					if (!permission) {
						continue;
					}
				}
			}
			rtnMap.putAll(map);
			if ("att".equals(type)) {
				String link = (String) map.get("link");
				if (StringUtil.isNotNull(link)) {
					rtnMap.put("href", link);
					rtnMap.put("target", "_self");
				} else {
					rtnMap.put("target", "_blank");
				}
			} else if ("pic".equals(type)) {
				rtnMap.put("image",map.get("image"));
				String href = (String) map.get("href");
				if (StringUtil.isNotNull(href)) {
					rtnMap.put("href", href);
				} 
				Boolean fdIsPic = (Boolean) map.get("fdIsPic");
				if (fdIsPic == null || !fdIsPic) {
					continue;
				}
			}else{
				rtnMap.putAll(map);
				rtnMap.put("target", "_blank");
			}
			num--;
			rtnList.add(rtnMap);
		}
		// 如果缓存数据为100条，但是取的数据还不够，则直接从数据库中查询数据
		if (num != 0 && newsList.size() == 100) {
			rtnList = getNewsWithAuth(rowsize, type, parentId, requestInfo);
		}
		return rtnList;
	}

	/**
	 * 获取类别下新闻数据(用于取缓存数据不够的时候才进行查询，带权限查询)
	 * 
	 * @param rowsize
	 * @param type
	 * @param parentId
	 * @param requestInfo
	 * @return
	 * @throws Exception
	 */
	private List<Map> getNewsWithAuth(int rowsize, String type,
			String parentId, RequestContext requestInfo) throws Exception {
		String whereBlock = "sysNewsMain.docStatus=:docStatus";
		String templateProperty = "sysNewsMain.fdTemplate";
		if (StringUtil.isNotNull(parentId) && !"all".equals(parentId)) {
			ISysSimpleCategoryModel category = (ISysSimpleCategoryModel) sysNewsTemplateService
					.findByPrimaryKey(parentId);
			whereBlock = SimpleCategoryUtil.buildChildrenWhereBlock(category,
					templateProperty, whereBlock);
		}
		HQLInfo hqlInfo = new HQLInfo();
		if ("pic".equals(type)) {
			whereBlock += " and sysNewsMain.fdIsPicNews=1";
		}
		hqlInfo.setSelectBlock("sysNewsMain.fdId" + ",sysNewsMain.docSubject"
				+ ",sysNewsMain.fdImportance" + ",sysNewsMain.docCreateTime"
				+ ",sysNewsMain.docCreator.fdName" + ",sysNewsMain.fdIsLink"
				+ ",sysNewsMain.fdLinkUrl" + ",sysNewsMain.docPublishTime"
				+",sysNewsMain.fdTemplate.fdId" + ",sysNewsMain.fdTemplate.fdName,sysNewsMain.fdDescription");
		
	    //时间范围参数
	    String scope=requestInfo.getParameter("scope");
	    if(StringUtil.isNotNull(scope)&&!scope.equals("no")){
	      whereBlock=StringUtil.linkString(whereBlock, " and ","sysNewsMain.docPublishTime > :fdStartTime");
	      hqlInfo.setParameter("fdStartTime",PortletTimeUtil.getDateByScope(scope));
	    }
		hqlInfo.setWhereBlock(whereBlock);
		hqlInfo
				.setOrderBy("sysNewsMain.fdIsTop desc,sysNewsMain.fdTopTime desc,sysNewsMain.docAlterTime desc,sysNewsMain.docPublishTime desc,sysNewsMain.docCreateTime desc");
		hqlInfo.setPageNo(1);
		hqlInfo.setRowSize(rowsize);
		hqlInfo.setGetCount(false);
		hqlInfo.setParameter("docStatus", SysDocConstant.DOC_STATUS_PUBLISH);
		hqlInfo.setCheckParam(SysAuthConstant.CheckType.AreaCheck,
				SysAuthConstant.AreaCheck.YES);
		List newsList = sysNewsMainService.findPage(hqlInfo).getList();
		List<Map> rtnList = new ArrayList<Map>();
		for (int i = 0; i < newsList.size(); i++) {
			Object[] val = (Object[]) newsList.get(i);
			Map map = new HashMap();
			map.put("id", val[0]);
			map.put("text", val[1]);
			map.put("importance", val[2]);
			map.put("created", DateUtil.convertDateToString((Date) val[7],
					DateUtil.TYPE_DATE, requestInfo.getLocale()));
			map.put("creator", val[4]);
			map.put("publishTime", DateUtil.convertDateToString((Date) val[7],
					DateUtil.TYPE_DATE, requestInfo.getLocale()));
		    //类别
			map.put("catename",val[9]);
			map.put("catehref","/sys/news/?categoryId=" + val[8]);
			//摘要
			map.put("description", val[10]);
			StringBuffer sb = new StringBuffer();
			// 判断如果是链接新闻则显示文档的链接
			if (val[5] == null || !(Boolean) val[5]) {
				sb.append("/sys/news/sys_news_main/sysNewsMain.do?method=view");
				sb.append("&fdId=" + val[0]);
			} else if ((Boolean) val[5] && val[6] != null) {
				sb.append(val[6]);
			}
			if ("att".equals(type)) {
				String link = getAttachmentLink(val[0].toString(),
						"fdAttachment");
				if (link == null) {
					map.put("href", sb.toString());
					map.put("target", "_blank");
				} else {
					map.put("href", link);
					map.put("target", "_self");
				}
			} else {
				map.put("href", sb.toString());
			}
			if ("pic".equals(type)) {
				String link = getAttachmentLink(val[0].toString(), "Attachment");
				map.put("image", link);
			}
			SysNewsConfig sysNewsConfig = new SysNewsConfig();
			map.put("width", sysNewsConfig.getfdImageW());
			map.put("height", sysNewsConfig.getfdImageH());
			rtnList.add(map);
		}
		return rtnList;
	}

	/**
	 * 获取类别下新闻缓存数据（不带权限查询）
	 * 
	 * @throws Exception
	 */
	private List<Map> getNewsCacheWithOutAuth(String parentId,
			RequestContext requestInfo) throws Exception {
		KmssCache cache = new KmssCache(SysNewsMainPortlet.class);
		
		List<Map> dataList = (List<Map>) cache.get(parentId);
		if (ArrayUtil.isEmpty(dataList)) {
			dataList = new ArrayList<Map>();
			logger.debug("重新加载该类别下新闻数据，不带权限查询前100条数据进行缓存");
			String whereBlock = "sysNewsMain.docStatus=:docStatus";
			if (StringUtil.isNotNull(parentId) && !"all".equals(parentId)) {
				String templateProperty = "sysNewsMain.fdTemplate";
				ISysSimpleCategoryModel category = (ISysSimpleCategoryModel) sysNewsTemplateService
						.findByPrimaryKey(parentId);
				whereBlock = SimpleCategoryUtil.buildChildrenWhereBlock(
						category, templateProperty, whereBlock);
			}
			
			String orderBy = "sysNewsMain.fdIsTop desc,sysNewsMain.fdTopTime desc,sysNewsMain.docAlterTime desc,sysNewsMain.docPublishTime desc,sysNewsMain.docCreateTime desc";
			HQLInfo hqlInfo = new HQLInfo();
		    //时间范围参数
		    String scope=requestInfo.getParameter("scope");
		    if(StringUtil.isNotNull(scope)&&!scope.equals("no")){
		      whereBlock=StringUtil.linkString(whereBlock, " and ","sysNewsMain.docPublishTime > :fdStartTime");
		      hqlInfo.setParameter("fdStartTime",PortletTimeUtil.getDateByScope(scope));
		    }
		    
			hqlInfo.setWhereBlock(whereBlock);
			hqlInfo.setOrderBy(orderBy);
			hqlInfo.setPageNo(1);
			hqlInfo.setRowSize(100);
			hqlInfo.setGetCount(false);
			hqlInfo.setAuthCheckType(SysAuthConstant.AUTH_CHECK_NONE);
			hqlInfo
					.setParameter("docStatus",
							SysDocConstant.DOC_STATUS_PUBLISH);
			hqlInfo.setCheckParam(SysAuthConstant.CheckType.AreaCheck,
					SysAuthConstant.AreaCheck.YES);
			List<SysNewsMain> rtnList = sysNewsMainService.findPage(hqlInfo)
					.getList();
			for (int i = 0; i < rtnList.size(); i++) {
				SysNewsMain sysNewsMain = (SysNewsMain) rtnList.get(i);
				Map map = new HashMap();
				map.put("id", sysNewsMain.getFdId());
				map.put("text", sysNewsMain.getDocSubject());
				map.put("importance", sysNewsMain.getFdImportance());
				map.put("created", DateUtil.convertDateToString(sysNewsMain
						.getDocPublishTime(), DateUtil.TYPE_DATE, requestInfo
						.getLocale()));
				map.put("creator", sysNewsMain.getDocCreator().getFdName());
				map.put("docAlterTime", sysNewsMain.getDocAlterTime());
				map.put("publishTime", DateUtil.convertDateToString(sysNewsMain
						.getDocPublishTime(), DateUtil.TYPE_DATE, requestInfo
						.getLocale()));
				map.put("fdIsLink", sysNewsMain.getFdIsLink());
				
				 //类别
				map.put("catename",sysNewsMain.getFdTemplate().getFdName());
				map.put("catehref","/sys/news/?categoryId=" + sysNewsMain.getFdTemplate().getFdId());
				//摘要
				map.put("description",sysNewsMain.getFdDescription());

				// 如果是链接新闻则保存链接
				if (sysNewsMain.getFdIsLink() != null
						&& sysNewsMain.getFdIsLink()) {
					map.put("href", sysNewsMain.getFdLinkUrl());
				} else {
					map.put("href",
							"/sys/news/sys_news_main/sysNewsMain.do?method=view&fdId="
									+ sysNewsMain.getFdId());
				}
				map.put("fdIsPic", sysNewsMain.getFdIsPicNews());
				// 如果是图片新闻则获取图片链接
				if (sysNewsMain.getFdIsPicNews() != null
						&& sysNewsMain.getFdIsPicNews()) {
					String link = getAttachmentLink(sysNewsMain.getFdId(),
							"Attachment");
					map.put("image", link);
				}
				String link = getAttachmentLink(sysNewsMain.getFdId(),
						"fdAttachment");
				// 获取附件新闻链接，如果不空则保存链接
				if (link != null) {
					map.put("link", link);
				}
				// 如果所有阅读者中有所有everyone，则缓存权限标志位，不再缓存权限信息
				if (sysNewsMain.getAuthAllReaders().contains(
						UserUtil.getEveryoneUser())
						|| (sysNewsMain.getAuthReaderFlag() != null && sysNewsMain
								.getAuthReaderFlag())) {
					map.put("authReaderFlag", new Boolean(true));
				} else {
					List<String> authPermissions = new ArrayList<String>();
					authPermissions.addAll(lists2Ids(sysNewsMain
							.getAuthAllReaders()));
					authPermissions.addAll(lists2Ids(sysNewsMain
							.getAuthAllEditors()));
					map.put("authPermissions", authPermissions);
				}
				SysNewsConfig sysNewsConfig = new SysNewsConfig();
				map.put("width", sysNewsConfig.getfdImageW());
				map.put("height", sysNewsConfig.getfdImageH());
				dataList.add(map);
			}
			cache.put(parentId, dataList);
		}
		return dataList;
	}

	/**
	 * 将可阅读者和可编辑者转换为id列表
	 * 
	 * @param list
	 * @return
	 */
	private List<String> lists2Ids(List list) {
		List<String> ids = new ArrayList<String>();
		for (int i = 0; i < list.size(); i++) {
			BaseModel m = (BaseModel) list.get(i);
			ids.add(m.getFdId());
		}
		return ids;
	}

	/**
	 * 获取该模块角色信息
	 * 
	 * @return
	 * @throws Exception
	 */
	private List<String> getModuleRoles() throws Exception {
		List<String> roleList = new ArrayList<String>();
		List roles = ModelUtil.getModelRoles(SysNewsMain.class.getName());
		for (int i = 0; i < roles.size(); i++) {
			roleList.add((String) roles.get(i));
			if (logger.isDebugEnabled()) {
				logger.debug(SysNewsMain.class.getName() + " ROLES ::"
						+ roles.get(i));
			}
		}
		return roleList;
	}

	/**
	 * 获取当前登录用户是否拥有模块权限或为管理员
	 * 
	 * @return
	 */
	private Boolean getPermission() throws Exception {
		Boolean isPermission = false;
		isPermission = UserUtil.getKMSSUser().isAdmin();
		List<String> authRoleAliases = new ArrayList<String>();
		List<String> moduleRoles = new ArrayList<String>();
		// 如果不是管理员则获取当前登录用户的角色列表以及模块角色信息
		if (!isPermission) {
			authRoleAliases = UserUtil.getKMSSUser().getUserAuthInfo()
					.getAuthRoleAliases();
			moduleRoles = getModuleRoles();
		}
		for (int i = 0; i < moduleRoles.size(); i++) {
			// 拥有模块其中的一个权限则为true
			if (authRoleAliases.contains(moduleRoles.get(i))) {
				isPermission = true;
				break;
			}
		}
		return isPermission;
	}

	private String getAttachmentLink(String newsId, String fdKey)
			throws Exception {
		List list = sysAttMainCoreInnerService.findByModelKey(
				"com.landray.kmss.sys.news.model.SysNewsMain", newsId, fdKey);
		if (list.isEmpty())
			return null;
		SysAttMain att = (SysAttMain) list.get(0);
		return "/sys/attachment/sys_att_main/sysAttMain.do?method=download&fdId="
				+ att.getFdId() + "&fileName=" + att.getFdFileName(); // 为能直接打开文件，需要传递文件名，修改人：傅游翔
	}

	public void setSysNewsMainService(ISysNewsMainService sysNewsMainService) {
		this.sysNewsMainService = sysNewsMainService;
	}

	public void setSysNewsTemplateService(
			ISysNewsTemplateService sysNewsTemplateService) {
		this.sysNewsTemplateService = sysNewsTemplateService;
	}

	public void setSysAttMainCoreInnerService(
			ISysAttMainCoreInnerService sysAttMainCoreInnerService) {
		this.sysAttMainCoreInnerService = sysAttMainCoreInnerService;
	}
}
