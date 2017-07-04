package com.landray.kmss.kms.multidoc.service.spring;

import java.util.List;

import com.landray.kmss.common.actions.RequestContext;
import com.landray.kmss.common.dao.HQLInfo;
import com.landray.kmss.common.service.IXMLDataBean;
import com.landray.kmss.constant.SysOrgConstant;
import com.landray.kmss.sys.organization.interfaces.SysOrgHQLUtil;
import com.landray.kmss.sys.organization.model.SysOrgElement;
import com.landray.kmss.sys.organization.service.ISysOrgElementService;
import com.landray.kmss.sys.organization.service.spring.OrgDialogUtil;
import com.landray.kmss.util.ArrayUtil;
import com.landray.kmss.util.StringUtil;

public class KmsMultidocOrgDialogList implements IXMLDataBean, SysOrgConstant {
	private ISysOrgElementService sysOrgElementService;

	public List getDataList(RequestContext xmlContext) throws Exception {
		IXMLDataBean extension = OrgDialogUtil.getExtension("orgList");
		if ((extension != null) && (extension != this)) {
			return extension.getDataList(xmlContext);
		}

		int orgType = 31;
		String para = xmlContext.getParameter("parent");
		HQLInfo hqlInfo = new HQLInfo();
		String whereBlock;
		String fdParentId = para;
		if (StringUtil.isNull(para)) {
			whereBlock = "sysOrgElement.hbmParent=null and sysOrgElement.fdOrgType<>4";
		} else {
			whereBlock = "sysOrgElement.hbmParent.fdId=:hbmParentId and sysOrgElement.fdOrgType<>4";
			hqlInfo.setParameter("hbmParentId", para);
		}
		para = xmlContext.getParameter("orgType");
		if ((para != null) && (!(para.equals(""))))
			try {
				orgType = Integer.parseInt(para);
			} catch (NumberFormatException localNumberFormatException) {
			}
		orgType = orgType & 0xF0F;
		whereBlock = SysOrgHQLUtil.buildWhereBlock(orgType, whereBlock,
				"sysOrgElement");
		hqlInfo.setWhereBlock(whereBlock);
		hqlInfo
				.setOrderBy("sysOrgElement.fdOrgType desc, sysOrgElement.fdOrder, sysOrgElement.fdName");
		List elemList = this.sysOrgElementService
				.findList(whereBlock,
						"sysOrgElement.fdOrgType desc, sysOrgElement.fdOrder, sysOrgElement.fdName");

		if (((orgType & 0x8) == 8) && (StringUtil.isNotNull(fdParentId))) {
			whereBlock = SysOrgHQLUtil
					.buildWhereBlock(4,
							"sysOrgElement.hbmParent.fdId=:fdParentId",
							"sysOrgElement");
			HQLInfo hql = new HQLInfo();
			hql.setWhereBlock(whereBlock);
			hqlInfo.setParameter("hbmParentId", fdParentId);
			List<SysOrgElement> postList = this.sysOrgElementService.findList(
					whereBlock, "sysOrgElement.fdOrder");
			for (SysOrgElement post : postList) {
				ArrayUtil.concatTwoList(post.getFdPersons(), elemList);
			}
		}
		return OrgDialogUtil.getResultEntries(elemList);
	}

	public void setSysOrgElementService(
			ISysOrgElementService sysOrgElementService) {
		this.sysOrgElementService = sysOrgElementService;
	}
}
