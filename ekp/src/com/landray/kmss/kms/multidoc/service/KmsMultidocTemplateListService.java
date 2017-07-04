package com.landray.kmss.kms.multidoc.service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import com.landray.kmss.common.actions.RequestContext;
import com.landray.kmss.common.service.IXMLDataBean;
import com.landray.kmss.kms.multidoc.model.KmsMultidocTemplate;
import com.landray.kmss.util.StringUtil;

public class KmsMultidocTemplateListService implements IXMLDataBean{
	
	private IKmsMultidocTemplateService kmsMultidocTemplateService;
	
	
	public void setKmsMultidocTemplateService(
			IKmsMultidocTemplateService kmsMultidocTemplateService) {
		this.kmsMultidocTemplateService = kmsMultidocTemplateService;
	}

	
	public List getDataList(RequestContext requestInfo) throws Exception {
		String type = requestInfo.getParameter("type");
		List rtnList = new ArrayList();
		if ("root".equals(type)) {
			rtnList = getTree(requestInfo);
		} else if ("child".equals(type)) {
			rtnList = getList(requestInfo);
		}else if("search".equals(type)){
			rtnList = getSearchList(requestInfo);
		}
		return rtnList;
	}
	
	private List getTree(RequestContext requestInfo) throws Exception {
		List rtnList = new ArrayList();
		String orderBy = "kmsMultidocTemplate.fdOrder";
		String whereBlock = null;
		String selectId = requestInfo.getRequest().getParameter("selectId");
		if(StringUtil.isNotNull(selectId)){
			whereBlock = "kmsMultidocTemplate.hbmParent.fdId='"+selectId+"'";
		}else{
			whereBlock = "kmsMultidocTemplate.hbmParent is null ";	
		}
		 
		List list=kmsMultidocTemplateService.findValue("kmsMultidocTemplate.fdName,kmsMultidocTemplate.fdId", whereBlock, orderBy);
		
		for (int i = 0; i < list.size(); i++) {
			Object[] info = (Object[]) list.get(i);
			HashMap node = new HashMap();
			node.put("text", info[0].toString());
			node.put("value", info[1]);
			rtnList.add(node);
		}
		return rtnList;
	}
	
	private List getList(RequestContext requestInfo) throws Exception {
		List rtnList = new ArrayList();
		String orderBy = "kmsMultidocTemplate.fdOrder";
		String whereBlock = null;
		String selectId = requestInfo.getRequest().getParameter("selectId");
		if (StringUtil.isNotNull(selectId)) {
			 
				whereBlock="kmsMultidocTemplate.fdId='"+selectId+"'";
		}else{
			 
			    whereBlock = "kmsMultidocTemplate.hbmParent is null ";	
	    }
		 
		
		List list=kmsMultidocTemplateService.findValue("kmsMultidocTemplate.fdId,kmsMultidocTemplate.fdName", whereBlock, orderBy);
			for (int i = 0; i < list.size(); i++) {
				Object[] info = (Object[]) list.get(i);
				rtnList.add(info);
			}
		return rtnList;  
		 
	 
	}
	
	private List getSearchList(RequestContext requestInfo) throws Exception {
		List rtnList = new ArrayList();
		String orderBy = "kmsMultidocTemplate.fdOrder";
		String whereBlock = null;
		String keyword = requestInfo.getRequest().getParameter("keyword");
		if (StringUtil.isNotNull(keyword)) {
			whereBlock="kmsMultidocTemplate.fdName like '%"+keyword+"%'";
		}
		List list=kmsMultidocTemplateService.findValue("kmsMultidocTemplate.fdId,kmsMultidocTemplate.fdName", whereBlock, orderBy);
			for (int i = 0; i < list.size(); i++) {
				
				Object[] info = (Object[]) list.get(i);
				String fdid=(String)info[0];
				KmsMultidocTemplate k=(KmsMultidocTemplate)kmsMultidocTemplateService.findByPrimaryKey(fdid);
				if(k.getFdParent()!=null){
					String parentid=k.getFdParent().getFdId();
					KmsMultidocTemplate parent=(KmsMultidocTemplate)kmsMultidocTemplateService.findByPrimaryKey(parentid);
					String fdname=(String)info[1];
					info[1]=parent.getFdName()+"/"+fdname; //加上父类名字
				}
				//Object[] info = (Object[]) list.get(i);
				rtnList.add(info);
			}
		return rtnList;
	}
}
