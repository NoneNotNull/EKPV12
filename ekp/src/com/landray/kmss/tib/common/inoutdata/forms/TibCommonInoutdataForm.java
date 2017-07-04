package com.landray.kmss.tib.common.inoutdata.forms;

import org.apache.struts.upload.FormFile;

import com.landray.kmss.common.forms.ExtendForm;
import com.landray.kmss.tib.common.inoutdata.model.TibCommonInoutdata;


/**
 * 主文档 Form
 * 
 * @author 
 * @version 1.0 2013-01-05
 */
public class TibCommonInoutdataForm extends ExtendForm {
	private FormFile initfile;

	public FormFile getInitfile() {
		return initfile;
	}

	public void setInitfile(FormFile initfile) {
		this.initfile = initfile;
	}
	
	public Class getModelClass() {
		return TibCommonInoutdata.class;
	}
	
}
