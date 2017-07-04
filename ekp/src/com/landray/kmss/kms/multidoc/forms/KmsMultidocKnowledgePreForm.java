package com.landray.kmss.kms.multidoc.forms;

import javax.servlet.http.HttpServletRequest;

import org.apache.struts.action.ActionMapping;

import com.landray.kmss.common.convertor.FormConvertor_IDToModel;
import com.landray.kmss.common.convertor.FormToModelPropertyMap;
import com.landray.kmss.common.forms.ExtendForm;
import com.landray.kmss.kms.multidoc.model.KmsMultidocKnowledgePre;
import com.landray.kmss.sys.authorization.model.SysAuthArea;

public class KmsMultidocKnowledgePreForm extends ExtendForm {

	protected String docAlterTime;

	protected String fdPreContent;

	/**
	 * @return docAlterTime
	 */
	public String getDocAlterTime() {
		return docAlterTime;
	}

	/**
	 * @param docAlterTime
	 *            要设置的 docAlterTime
	 */
	public void setDocAlterTime(String docAlterTime) {
		this.docAlterTime = docAlterTime;
	}

	/**
	 * @return fdPreContent
	 */
	public String getFdPreContent() {
		return fdPreContent;
	}

	/**
	 * @param fdPreContent
	 *            要设置的 fdPreContent
	 */
	public void setFdPreContent(String fdPreContent) {
		this.fdPreContent = fdPreContent;
	}

	public void reset(ActionMapping mapping, HttpServletRequest request) {
		super.reset(mapping, request);
		docAlterTime = null;
		fdPreContent = null;
		authAreaId = null;
		authAreaName = null;
	}

	public Class getModelClass() {
		return KmsMultidocKnowledgePre.class;
	}

	// 所属场所ID
	protected String authAreaId = null;

	public String getAuthAreaId() {
		return authAreaId;
	}

	public void setAuthAreaId(String authAreaId) {
		this.authAreaId = authAreaId;
	}

	// 所属场所名称
	protected String authAreaName = null;

	public String getAuthAreaName() {
		return authAreaName;
	}

	public void setAuthAreaName(String authAreaName) {
		this.authAreaName = authAreaName;
	}

	private FormToModelPropertyMap toModelPropertyMap;

	public FormToModelPropertyMap getToModelPropertyMap() {
		if (toModelPropertyMap == null) {
			toModelPropertyMap = new FormToModelPropertyMap();
			toModelPropertyMap.putAll(super.getToModelPropertyMap());
			toModelPropertyMap.put("authAreaId", new FormConvertor_IDToModel(
					"authArea", SysAuthArea.class));
		}
		return toModelPropertyMap;
	}

}
