package com.landray.kmss.kms.multidoc.service.spring;

import static com.landray.kmss.sys.property.util.SysPropertyUtil.ENTER;
import static com.landray.kmss.sys.property.util.SysPropertyUtil.setTab;

import java.util.List;

import com.landray.kmss.sys.property.builder.jsp.IJspBuilder;
import com.landray.kmss.sys.property.builder.jsp.ITagBuilder;
import com.landray.kmss.sys.property.model.SysPropertyReference;
import com.landray.kmss.sys.property.model.SysPropertyTemplate;
import com.landray.kmss.util.StringUtil;

public class KmsMultidocViewJspBuilder implements IJspBuilder {

	protected ITagBuilder tagBuilder;

	public void setTagBuilder(ITagBuilder tagBuilder) {
		this.tagBuilder = tagBuilder;
	}

	public String build(SysPropertyTemplate sysPropertyTemplate)
			throws Exception {
		List<SysPropertyReference> fdReferences = sysPropertyTemplate
				.getFdReferences();
		if (fdReferences == null) {
			return null;
		}
		StringBuilder jsp = new StringBuilder();
		jsp.append(getJspHead());
		jsp.append(ENTER);
		// jsp.append(getTableHead("sysPropertyTemplateTable"));
		boolean tr = true;
		int tdNum = 0;
		for (int i = 0; i < fdReferences.size(); i++) {
			SysPropertyReference sysPropertyReference = fdReferences.get(i);
			if (!sysPropertyReference.getFdDisplayInLine()) {
				// 计算不是显示成一行的数量
				tdNum++;
			}
			if (tr) {
				if (!sysPropertyReference.getFdDisplayInLine()) {
					// tr = false;
				}
				jsp.append(ENTER);
				jsp.append(setTab(1)).append("<tr>");
			} else {
				tr = true;
			}
			jsp.append(ENTER);
			jsp.append(setTab(2)).append(
					"<th valign= 'top'><nobr>");
			jsp.append(ENTER);
			jsp.append(setTab(3)).append(
					StringUtil.isNotNull(sysPropertyReference
							.getFdDisplayName()) ? sysPropertyReference
							.getFdDisplayName() : sysPropertyReference
							.getFdDefine().getFdName());
			jsp.append("</nobr></th><td colspan='3'>");
			StringBuilder jsp1 = tagBuilder.build(sysPropertyReference);
			jsp.append(jsp1);
			jsp.append(ENTER);
			jsp.append(setTab(2)).append("</td>");
			if (tr) {
				jsp.append(ENTER);
				jsp.append(setTab(1)).append("</tr>");
			} else {
				if (tdNum > 0 && i < fdReferences.size() - 1) {
					SysPropertyReference sysPropertyReferenceNext = fdReferences
							.get(i + 1);
					if (sysPropertyReferenceNext.getFdDisplayInLine()) {
						// tdPatch(jsp);
						tr = true;
						tdNum = 0;
					}
				}
			}
		}
		if (tdNum % 2 != 0) {
			// tdPatch(jsp);
		}
		jsp.append(ENTER);
		// jsp.append(getTableFoot());
		return jsp.toString();
	}

	private void tdPatch(StringBuilder jsp) {
		jsp.append(ENTER);
		jsp.append(setTab(2)).append("<td>&nbsp;</td>");
		jsp.append(ENTER);
		jsp.append(setTab(1)).append("</tr>");
	}

	private String getJspHead() {
		return "<%@ page language=\"java\" contentType=\"text/html; charset=UTF-8\" pageEncoding=\"UTF-8\"%>\r\n"
				+ "<%@ include file=\"/resource/jsp/common.jsp\"%>\r\n"
				+ "<%@ page import=\"com.landray.kmss.web.taglib.xform.TagUtils\" %>\t\n"
				+ "<%@ page import=\"com.landray.kmss.util.*\" %>";
	}

	private String getTableHead(String id) {
		return "<table id=\""
				+ id
				+ "\" border=\"0\" cellpadding=\"0\" align=\"center\" class=\"t_e4 m_t10\">\r\n<tbody> ";
	}

	private String getTableFoot() {
		return " </tbody>\r\n</table>";
	}

}
