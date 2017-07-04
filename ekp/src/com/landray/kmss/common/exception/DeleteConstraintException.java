package com.landray.kmss.common.exception;

import com.landray.kmss.util.KmssMessage;

public class DeleteConstraintException extends KmssRuntimeException {
	public DeleteConstraintException(Exception e, Long id) {
		super(new KmssMessage("errors.deleteConstraint2", id), e);
	}

	public DeleteConstraintException(Exception e) {
		super(new KmssMessage("errors.deleteConstraint1"), e);
	}
}
