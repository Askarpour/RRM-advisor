(defvar RRMnum 5)

(defun RRMProperties (roId opId)
(eval (list `alwf (append `(&&

;;RRM_zone
(-> (-P- RRM_1) 
	;ro cannot be in upper layer
	(forbiden_for_ro 1 (setq l '(7 8 9)))
)
;;RRM_safeguard
(-> (-P- RRM_2) 
		(UNTIL_EE (-P- roStill) (-P- resume))
)

;;RRM_SSM
(<-> 
	(-P- RRM_3) 
	; (UNTIL_EE (&&(-P- roStill)(!!(operatorStill 1))) (not_close))
	(-A- r ro_indexes_1 (-A- o body_indexes_1  (!! (In_same_L r o))))
)

;;RRM_PFL
(-> (-P- RRM_4) 
	(->
		(|| (In_same_L `OPERATOR_1_HEAD_AREA `Link1_1)
			(In_same_L `OPERATOR_1_HEAD_AREA `Link2_1)
			(In_same_L `OPERATOR_1_HEAD_AREA `endeff_1)

			(In_same_L `OPERATOR_1_ARM_AREA `Link1_1)
			(In_same_L `OPERATOR_1_ARM_AREA `Link2_1)
			(In_same_L `OPERATOR_1_ARM_AREA `endeff_1)

			(In_same_L `OPERATOR_1_CHEST_AREA `Link1_1)
			(In_same_L `OPERATOR_1_CHEST_AREA `Link2_1)
			(In_same_L `OPERATOR_1_CHEST_AREA `endeff_1) )
		; (-P- hold)
		(&&(-P- RELATIVEVELOCITY_1_1_low)(-P- RELATIVEFORCE_1_1_low))
	)
)

; (alwf
; 	(<->
; 		(-P- hold)
; 		(|| (-P- RRM_4) (-P- RRM_3))
; 		)
; 	)

;;RRM_SSM_head
(<-> 
	(-P- RRM_5) 
	; (UNTIL_EE (&&(-P- roStill)(!!(operatorStill 1))) (not_close))
	(-A- r ro_indexes_1  (!! (In_same_L r `operator_1_head_area)))
)

(-> (-P- resume) (not_close))
;no RRM
(<->(-P- no_RRM) (&& (!! (-P- RRM_1)) (!! (-P- RRM_2)) (!! (-P- RRM_3))(!! (-P- RRM_4)) (!! (-P- RRM_5))))

;the final line for parser with spaces! dont change!!
  )))))
