(define-item Risk `(0 1 2)) ;;max risk in the system
;;risk of each hazard
(defun REs-Hazards (index)
 (eval (list `alwf (append `(&&) (loop for hazard_id in index collect `(&&
	(-> ,(read-from-string (format nil "(Hazard_Risk_~A= 1)" hazard_id))
		 (&&(-P- ,(read-from-string (format nil "Hazard_occured_~A" hazard_id)))
		 	(||
		 		(&& ,(read-from-string (format nil "(Hazard_Se_~A= 4)" hazard_id)) 
		 			,(read-from-string (format nil "(!!(Hazard_CI_~A= 9))" hazard_id))
		 			 )
		 		(&& ,(read-from-string (format nil "(Hazard_Se_~A= 3)" hazard_id)) 
		 			,(read-from-string (format nil "(!!(Hazard_CI_~A= 9))" hazard_id))
		 			)
				(&& ,(read-from-string (format nil "(Hazard_Se_~A= 2)" hazard_id))
					,(read-from-string (format nil "(Hazard_CI_~A= 9)" hazard_id))
					)
				(&& ,(read-from-string (format nil "(Hazard_Se_~A= 1)" hazard_id)) 
					,(read-from-string (format nil "(!!(Hazard_CI_~A= 9))" hazard_id))
					)
			)))

	(<-> ,(read-from-string (format nil "(Hazard_Risk_~A= 2)" hazard_id))
		 (&&
		 	(-P- ,(read-from-string (format nil "Hazard_occured_~A" hazard_id)))
		 	(||
		 		(&& ,(read-from-string (format nil "(Hazard_Se_~A= 4)" hazard_id))
		 			,(read-from-string (format nil "(Hazard_CI_~A= 9)" hazard_id))
		 			)
		 		(&& ,(read-from-string (format nil "(Hazard_Se_~A= 3)" hazard_id)) 
		 			,(read-from-string (format nil "(Hazard_CI_~A= 9)" hazard_id))
		 			)
				(&& ,(read-from-string (format nil "(Hazard_Se_~A= 2)" hazard_id)) 
					,(read-from-string (format nil "(!!(Hazard_CI_~A= 9))" hazard_id))
					)
				(&& ,(read-from-string (format nil "(Hazard_Se_~A= 1)" hazard_id)) 
					,(read-from-string (format nil "(!!(Hazard_CI_~A= 9))" hazard_id))
					)
			))
	)
	))))))	

(defun nothing_comes_close (opID)
  (-A- bp body_indexes_1
  	(-A- rp ro_indexes_1
		 (!!(-P-  moveDirection rp bp `clos))
   )))

;;severity calculation
(defun REs (index opID roID)
 (eval (list `alwf (append `(&&) (loop for hazard_id in index collect `(&&
	(-> ,(read-from-string (format nil "(Hazard_Se_~A= 4)" hazard_id))
		(&&
			(-P- RELATIVEFORCE_1_1_high)
			(-P- RELATIVEVELOCITY_1_1_high)))
			
	(-> ,(read-from-string (format nil "(Hazard_Se_~A= 3)" hazard_id))
		(||
			(&& (-P- RELATIVEFORCE_1_1_mid) (-P- RELATIVEVELOCITY_1_1_high))
			(&& (-P- RELATIVEFORCE_1_1_mid) (-P- RELATIVEVELOCITY_1_1_mid))
			(&& (-P- RELATIVEFORCE_1_1_high) (-P- RELATIVEVELOCITY_1_1_mid)) ))
	(-> ,(read-from-string (format nil "(Hazard_Se_~A= 2)" hazard_id))
		(||
			(&& (-P- RELATIVEFORCE_1_1_mid) (-P- RELATIVEVELOCITY_1_1_low))
			(&& (-P- RELATIVEFORCE_1_1_low) (-P- RELATIVEVELOCITY_1_1_mid) )))

	(-> ,(read-from-string (format nil "(Hazard_Se_~A= 1)" hazard_id))
			(&& (-P- RELATIVEFORCE_1_1_low) (-P- RELATIVEVELOCITY_1_1_low) ))

	(-> ,(read-from-string (format nil "(Hazard_Se_~A= 0)" hazard_id))
		(&& (-P- RELATIVEFORCE_1_1_none) (-P- RELATIVEVELOCITY_1_1_none) ))

	))))))


(defun risk_is_2 (index)
	(eval (append `(||) (loop for hazard_id in index collect `,(read-from-string (format nil "(Hazard_Risk_~A= 2)" hazard_id))))))

(defun risk_is_1 (index)
	(eval (append `(||) (loop for hazard_id in index collect `,(read-from-string (format nil "(Hazard_Risk_~A= 1)" hazard_id))))))

(defun risk_is_0 (index)
	(eval (append `(&&) (loop for hazard_id in index collect `,(read-from-string (format nil "(Hazard_Risk_~A= 0)" hazard_id))))))

;total risk
(defun Risk_estimation ()
 (alwF (&&
 	(->  (Risk= 2) (risk_is_2 hazard_indexes))
 	(->  (Risk= 1) (&& (risk_is_1 hazard_indexes) (!!(risk_is_2 hazard_indexes))))
 	(->  (Risk= 0) (risk_is_0 hazard_indexes))
 	(REs hazard_indexes 1 1)
 	(REs-Hazards hazard_indexes)

  )))	