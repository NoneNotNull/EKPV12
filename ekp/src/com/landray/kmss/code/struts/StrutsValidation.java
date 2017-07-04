package com.landray.kmss.code.struts;

import java.io.File;
import java.util.ArrayList;
import java.util.List;

import com.landray.kmss.code.util.XMLReaderUtil;

public class StrutsValidation {
	public static StrutsValidation getInstance(File file) throws Exception {
		return (StrutsValidation) XMLReaderUtil.getInstance(file,
				StrutsValidation.class);
	}

	private List<ValidateForm> validateForms = new ArrayList<ValidateForm>();

	public List<ValidateForm> getValidateForms() {
		return validateForms;
	}

	public void setValidateForms(List<ValidateForm> validateForms) {
		this.validateForms = validateForms;
	}

	public void addValidateForm(ValidateForm formBean) {
		this.validateForms.add(formBean);
	}
}
