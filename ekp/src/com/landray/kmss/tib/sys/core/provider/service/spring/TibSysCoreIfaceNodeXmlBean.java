package com.landray.kmss.tib.sys.core.provider.service.spring;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.w3c.dom.Document;
import org.w3c.dom.Element;

import com.landray.kmss.common.actions.RequestContext;
import com.landray.kmss.common.dao.HQLInfo;
import com.landray.kmss.common.service.IXMLDataBean;
import com.landray.kmss.tib.sys.core.provider.model.TibSysCoreNode;
import com.landray.kmss.tib.sys.core.provider.service.ITibSysCoreNodeService;
import com.landray.kmss.tib.sys.core.provider.util.ProviderXmlOperation;
import com.landray.kmss.util.SpringBeanUtil;
import com.landray.kmss.util.StringUtil;

public class TibSysCoreIfaceNodeXmlBean implements IXMLDataBean {

	public List getDataList(RequestContext requestInfo) throws Exception {
		String coreIfaceId = requestInfo.getParameter("coreIfaceId");
		// 获取Doc
		Document document = ProviderXmlOperation.initDocument();
		ITibSysCoreNodeService tibSysCoreNodeServiceImp = (ITibSysCoreNodeService) SpringBeanUtil
				.getBean("tibSysCoreNodeService");
		HQLInfo hqlInfo = new HQLInfo();
		hqlInfo.setWhereBlock("tibSysCoreNode.fdIface.fdId = :coreIfaceId "
				+ "and tibSysCoreNode.fdNodeEnable = :fdNodeEnable");
		hqlInfo.setParameter("coreIfaceId", coreIfaceId);
		hqlInfo.setParameter("fdNodeEnable", true);
		hqlInfo.setOrderBy("tibSysCoreNode.fdNodeLevel");
		// 根据层级排序获取节点对象集合
		List<TibSysCoreNode> nodeList = tibSysCoreNodeServiceImp
				.findList(hqlInfo);
		for (TibSysCoreNode coreNode : nodeList) {
			String fdNodePath = coreNode.getFdNodePath();
			// 获取设置好的节点及信息
			Element element = ProviderXmlOperation.getElement(document,
					coreNode.getFdNodeName(), coreNode.getFdNodeContent(),
					coreNode.getFdAttrJson());
			// 获取父类XPath
			String parentXpath = fdNodePath.substring(0, fdNodePath
					.lastIndexOf("/"));
			if (StringUtil.isNull(parentXpath)) {
				// root节点
				document.appendChild(element);
			} else {
				// 获取父类的Element
				Element parentElement = ProviderXmlOperation.selectElement(
						parentXpath, document).get(0);
				parentElement.appendChild(element);
			}
		}
		String nodeXml = ProviderXmlOperation.DocToString(document);
		List<Map<String, String>> rtnList = new ArrayList<Map<String, String>>();
		Map<String, String> map = new HashMap<String, String>();
		map.put("nodeXml", nodeXml);
		rtnList.add(map);
		return rtnList;
	}
	
}
