(defvar operatorNum 1)
(defvar body_indexes `(head_area chest_area arm_area leg_area))
(defvar body_indexes_1 `(operator_1_head_area operator_1_chest_area operator_1_arm_area operator_1_leg_area))

(defun Operator_Body (opID)
 (alwf 
 	(&&
  	(-A- i body_indexes_1(&& (positioning_rules i)(moving i) (moving_gradually i)))	 
  	(||(In_same_L `operator_1_arm_area `operator_1_head_area) (In_Adj_L `operator_1_arm_area `operator_1_head_area))


    (above_same_L `operator_1_leg_area `operator_1_chest_area)
    (|| 
      (above_same_L_upper `operator_1_chest_area `operator_1_head_area) 
      (In_same_L `operator_1_chest_area `operator_1_head_area)
    )

    (-P- OPERATOR_1_LEG_AREA_IN_L_2)
    (!!(-P- OPERATOR_1_arm_AREA_IN_L_6))
    (ALWF(||(-P- OPERATOR_1_HEAD_AREA_IN_L_5)(-P- OPERATOR_1_HEAD_AREA_IN_L_8)))

 )))

(defun operatorStill (opId) (<-> (-P- OperatorStill opId) (-A- i body_indexes (!!(-P- operator opId i `Moving)))))