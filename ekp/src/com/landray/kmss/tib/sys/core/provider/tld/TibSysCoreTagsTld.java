package com.landray.kmss.tib.sys.core.provider.tld;

import java.io.IOException;
import java.io.StringWriter;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.jsp.JspException;
import javax.servlet.jsp.JspWriter;
import javax.servlet.jsp.tagext.BodyTagSupport;

import com.landray.kmss.common.dao.HQLInfo;
import com.landray.kmss.tib.sys.core.provider.model.TibSysCoreTag;
import com.landray.kmss.tib.sys.core.provider.service.ITibSysCoreTagService;
import com.landray.kmss.util.SpringBeanUtil;
import com.landray.kmss.util.StringUtil;
import com.landray.kmss.web.taglib.xform.TagUtils;
import com.sunbor.web.tag.Page;

import freemarker.template.Configuration;
import freemarker.template.Template;
import freemarker.template.TemplateException;

/**
 * 
 * 简单版的tld机制标签 不采用机制,自己更好控制标签变化
 * 
 * @author zhangtian
 * 
 */
public class TibSysCoreTagsTld extends BodyTagSupport {

	private static final long serialVersionUID = 1L;

	private String propertyId;
	private String propertyName;
	private Integer mostNumber;
	private Integer orderBy;
	

	@Override
	public int doStartTag() throws JspException {
//		fdIfaceTagVos
//		fdIfaceTagNames

		Object idValue = TagUtils.getFieldValue(
				(HttpServletRequest) pageContext.getRequest(), propertyId);
		
		if(StringUtil.isNull((String)idValue)){
			idValue="";
		}
		Object nameValue = TagUtils.getFieldValue(
				(HttpServletRequest) pageContext.getRequest(), propertyName);
		
		if(StringUtil.isNull((String)nameValue)){
			nameValue="";
		}
		
		
		JspWriter out = pageContext.getOut();

		try {
			Template template = getTagsTemplate();

			ITibSysCoreTagService tibSysCoreTagService = (ITibSysCoreTagService) SpringBeanUtil
					.getBean("tibSysCoreTagService");

			HQLInfo hqlInfo = new HQLInfo();
			
			hqlInfo.setOrderBy(" fdOrder desc ");
			hqlInfo.setPageNo(0);
			hqlInfo.setRowSize(10);

			Page page = tibSysCoreTagService.findPage(hqlInfo);
			List<TibSysCoreTag> tags= page.getList();
			Map<String, Object> map = new HashMap<String, Object>();
			map.put("tags", tags);
			map.put("propertyId", propertyId);
			map.put("propertyName", propertyName);
			map.put("propertyIdVal", idValue);
			map.put("propertyNameVal", nameValue);

			StringWriter sw = new StringWriter();
			template.process(map, sw);

			out.write(sw.toString());
		} catch (Exception e) {
			// TODO: handle exception
			e.printStackTrace();
		}

		// TODO 自动生成的方法存根
		return super.doStartTag();

	}

	public Template getTagsTemplate() throws Exception {

		Configuration config = TibSysCoreTldFMHelper.instanceDefaultCfg();
		Template temp = config.getTemplate("TibSysCoreTagsTld.ftl", "UTF-8");
		return temp;
	}
	
	public String getPropertyId() {
		return propertyId;
	}

	public void setPropertyId(String propertyId) {
		this.propertyId = propertyId;
	}

	public String getPropertyName() {
		return propertyName;
	}

	public void setPropertyName(String propertyName) {
		this.propertyName = propertyName;
	}

	public Integer getMostNumber() {
		return mostNumber;
	}

	public void setMostNumber(Integer mostNumber) {
		this.mostNumber = mostNumber;
	}

	public Integer getOrderBy() {
		return orderBy;
	}

	public void setOrderBy(Integer orderBy) {
		this.orderBy = orderBy;
	}

	public static void main(String[] args) throws IOException,
			TemplateException {

		// TibSysCoreTagsTld.class.get

		TibSysCoreTagsTld td = new TibSysCoreTagsTld();
		Configuration config = TibSysCoreTldFMHelper.instanceDefaultCfg();
		Template temp = config.getTemplate("TibSysCoreTagsTld.ftl", "UTF-8");
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("username", "hellosadfa");
		map.put("hello", "weefs");
		StringWriter sw = new StringWriter();
		temp.process(map, sw);
		System.out.println(sw.toString());
	}

}
