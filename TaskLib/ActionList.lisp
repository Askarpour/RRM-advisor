;operator moves
(defun op_moves (actionid Traceid dest opId)
   (alwf (&&
    (-P- Action_Doer_op actionid Traceid)
    (->(-P- Action_Pre actionid Traceid) (-P- Action_State_dn (- actionid 1) Traceid))
    (->(-P- Action_Post actionid Traceid) (inside `operator_1_arm_area dest))
    )))

;op holding the wp in dest
(defun op_hold(actionid Traceid masteraction preaction dest opId)
  (alwf (&&
   (-P- Action_Doer_op actionid Traceid)
   (<->(-P- Action_Pre actionid Traceid)  (&&(inside `OPERATOR_1_ARM_AREA dest)(!!(Yesterday(-P- Action_State_dn preaction Traceid)))(-P- Action_State_dn preaction Traceid)))
   (<->(-P- Action_Post actionid Traceid) (-P- Action_State_dn masteraction Traceid))
   (->(||  (-P- Action_State_exe actionid Traceid) (-P- Action_State_exrm actionid Traceid) )(inside `operator_1_arm_area dest))
)))

;op releases the wp in dest
(defun op_release(actionid Traceid dest opId)
  (alwf (&&
   (-P- Action_Doer_op actionid Traceid)
   (->(-P- Action_Pre actionid Traceid)  (&&(inside `OPERATOR_1_ARM_AREA dest)(-P- Action_State_dn (- actionid 1) Traceid)))
   (->(-P- Action_Post actionid Traceid) (!!(inside `OPERATOR_1_ARM_AREA dest))))
))

;operator inserts the wp on a pallet
(defun insertp(actionid Traceid bin opId)
  (alwf (&&
   (-P- Action_Doer_op actionid Traceid)
   (->(-P- Action_Pre actionid Traceid) (&&(-P- Action_State_dn (- actionid 1) Traceid)(inside `OPERATOR_1_ARM_AREA bin)))
   (->(-P- Action_Pre_L actionid Traceid) (inside `OPERATOR_1_ARM_AREA bin))
   (->(-P- Action_Post actionid Traceid) (inside `OPERATOR_1_ARM_AREA bin))
   (->(-P- Action_Post_L actionid Traceid) (inside `OPERATOR_1_ARM_AREA bin))
   (->(|| (-P- Action_State_exe actionid Traceid) (-P- Action_State_exrm actionid Traceid)) (inside `OPERATOR_1_ARM_AREA bin))
)))

;operator inserts the wp on a pallet
(defun first_insertp(actionid Traceid bin opId)
  (alwf (&&
   (-P- Action_Doer_op actionid Traceid)
   (->(-P- Action_Pre actionid Traceid)  (inside `OPERATOR_1_ARM_AREA bin) )
   (->(-P- Action_Pre_L actionid Traceid) (inside `OPERATOR_1_ARM_AREA bin))
   (->(-P- Action_Post actionid Traceid) (inside `OPERATOR_1_ARM_AREA bin))
   (->(-P- Action_Post_L actionid Traceid) (inside `OPERATOR_1_ARM_AREA bin))
   (->(|| (-P- Action_State_exe actionid Traceid) (-P- Action_State_exrm actionid Traceid)) (inside `OPERATOR_1_ARM_AREA bin))
)))

;operator inspects the execution
(defun inspectp(actionid traceid inspection-pos opId)
 (alwf (&&
   (-P- Action_Doer_op actionid Traceid)
   (->(-P- Action_Pre actionid Traceid) (&&(-P- Action_State_dn (- actionid 1) Traceid) (inside `operator_1_arm_area inspection-pos) (inside `EndEff_1 inspection-pos) (-P- Robot_Idle)))
   (->(-P- Action_Pre_L actionid Traceid) (&& (inside `operator_1_arm_area inspection-pos) (inside `EndEff_1 inspection-pos)))
   (->(-P- Action_Post actionid Traceid) (&& (inside `operator_1_arm_area inspection-pos)  (inside `EndEff_1 inspection-pos)))
   (->(-P- Action_Post_L actionid Traceid)(&&(inside `operator_1_arm_area inspection-pos)  (inside `EndEff_1 inspection-pos)))
)))

;robot-ee is moving
(defun move(actionid Traceid source dest opId preaction)
 (alwf (&&
   (-P- Action_Doer_ro actionid Traceid)
   (->(-P- Action_Pre actionid Traceid) (&&(-P- Action_State_dn preaction Traceid)))
   (->(-P- Action_Post actionid Traceid) (inside `EndEff_1 dest))
   (->(-P- Action_Post_L actionid Traceid) (inside `EndEff_1 dest))
   )))

;robot-ee is moving
(defun firstmove(actionid Traceid source dest)
  (alwf (&&
   (-P- Action_Doer_ro actionid Traceid)
   (->(-P- Action_Pre actionid Traceid) (&&(inside `EndEff_1 source)))
   (->(-P- Action_Pre_L actionid Traceid) (&&(inside `EndEff_1 source)))
   (->(-P- Action_Post actionid Traceid) (&&(inside `EndEff_1 source)))
   )))

; ro picks a wp
(defun pick(actionid Traceid dest opId)
 `(alwf (&&
   (-P- Action_Doer_ro actionid Traceid)
   (->(-P- Action_Pre actionid Traceid) (&& (||   (In_Adj_with_L `EndEff_1 dest) (inside `EndEff_1 dest)) (||   (In_Adj_with_L `Base_1 dest) (inside `Base_1 dest))(-P- Action_State_dn (- actionid 1) Traceid)))
   (->(-P- Action_Post actionid Traceid) (&& (inside `EndEff_1 dest)))
   (->(|| (-P- Action_State_exe actionid Traceid) (-P- Action_State_exrm actionid Traceid)) (&& (inside `EndEff_1 dest) (!!(-P- Base_1_Moving))))
 )))

; first ro picks a wp
(defun pick-first(actionid Traceid dest opId)
 (alwf (&&
   (-P- Action_Doer_ro actionid Traceid)
   (->(-P- Action_Pre actionid Traceid) (&& (|| (In_Adj_with_L `EndEff_1 dest) (inside `EndEff_1 dest)) ))
   (->(-P- Action_Post actionid Traceid) (&& (inside `EndEff_1 dest)))
   (->(|| (-P- Action_State_exe actionid Traceid) (-P- Action_State_exrm actionid Traceid)) (&& (inside `EndEff_1 dest) (!!(-P- Base_1_Moving))))
 )))

;ro removes wp from pallet
(defun removep(actionid Traceid pallet)
  (alwf (&&
    (-P- Action_Doer_ro actionid Traceid)
    (->(-P- Action_Pre actionid Traceid) (-P- Action_State_dn (- actionid 1) Traceid))
    (->(-P- Action_Post actionid Traceid) (&& (inside `EndEff_1 pallet) (-P- BP1_empty)))
    (->(-P- Action_Post_L actionid Traceid) (inside `EndEff_1 pallet))
    (->(|| (-P- Action_State_exe actionid Traceid) (-P- Action_State_exrm actionid Traceid)) (&& (inside `EndEff_1 pallet) (-P- remove-going-on))))))

;operator unscrews the part
(defun unscrew(actionid traceid piece-pos opId)
  (alwf (&&
    (-P- Action_Doer_op actionid Traceid)
    (->(-P- Action_Pre actionid Traceid) (&& (-P- Action_State_dn (- actionid 1) Traceid) (inside `operator_1_arm_area piece-pos)))
    (->(-P- Action_Post actionid Traceid) (inside `operator_1_arm_area piece-pos))
    (->(|| (-P- Action_State_exe actionid Traceid) (-P- Action_State_exrm actionid Traceid)) (&& (inside `operator_1_arm_area piece-pos) (!!(-P- Base_1_Moving))))
)))

;robot base is moving
(defun base_move(actionid Traceid source dest)
  (alwf (&&
   (-P- Action_Doer_ro actionid Traceid)
   (->(-P- Action_Pre actionid Traceid) (&& (-P- Action_State_dn (- actionid 1) Traceid)))
   (->(-P- Action_Post actionid Traceid) (inside `Base_1 dest))
   (->(|| (-P- Action_State_exe actionid Traceid) (-P- Action_State_exrm actionid Traceid)) (-P- Base_1_Moving))
 )))

;robot base is moving
(defun first_base_move(actionid Traceid source dest)
  (alwf (&&
 ;        (-P- Action_Doer_ro actionid Traceid)
   (->(-P- Action_Post actionid Traceid) (&& (inside `EndEff_1 dest))))))

(defun ee_hold(actionid Traceid masteraction preaction dest opId)
  (alwf (&&
   (-P- Action_Doer_ro actionid Traceid)
   (<->(-P- Action_Pre actionid Traceid)  (&&(inside `endeff_1 dest)(!!(Yesterday(-P- Action_State_dn preaction Traceid)))(-P- Action_State_dn preaction Traceid)))
   (<->(-P- Action_Post actionid Traceid) (-P- Action_State_dn masteraction Traceid))
   (->(||  (-P- Action_State_exe actionid Traceid) (-P- Action_State_exrm actionid Traceid) )(inside `endeff_1 dest))
)))

(defun ee_hold_moving(actionid Traceid masteraction preaction source opId)
  (alwf (&&
   (-P- Action_Doer_ro actionid Traceid)
   (<->(-P- Action_Pre actionid Traceid)  (&&(inside `endeff_1 source)(!!(Yesterday(-P- Action_State_dn preaction Traceid)))(-P- Action_State_dn preaction Traceid)))
   (<->(-P- Action_Post actionid Traceid) (-P- Action_State_dn masteraction Traceid))
)))

;op send mobe signal
(defun send_move_signal(actionid Traceid preaction)
  (alwf (&&
   (->(-P- Action_Pre actionid Traceid) (|| (-P- Action_State_dn preaction Traceid)))
   (-> (|| (-P- Action_State_exrm actionid Traceid) (-P- Action_State_exe actionid Traceid))(&&(operatorStill 1) (next (-P- Action_State_dn actionid Traceid))))
   (-P- Action_Doer_op actionid Traceid))))

(defun mutually_exclusive2 (index Tname)
  (&&
    (mutually_exclusive "Action_State_ns" "Action_State_wt" "Action_State_exe" "Action_State_dn" "Action_State_exrm" "Action_State_hd" index Tname)
    (mutually_exclusive "Action_State_wt" "Action_State_ns" "Action_State_exe" "Action_State_dn" "Action_State_exrm" "Action_State_hd" index Tname)
    (mutually_exclusive "Action_State_exe" "Action_State_ns" "Action_State_wt" "Action_State_dn" "Action_State_exrm" "Action_State_hd" index Tname)
    (mutually_exclusive "Action_State_dn" "Action_State_ns" "Action_State_wt" "Action_State_exe" "Action_State_exrm" "Action_State_hd" index Tname)
    (mutually_exclusive "Action_State_exrm" "Action_State_ns" "Action_State_wt" "Action_State_exe" "Action_State_dn" "Action_State_hd" index Tname)
    (mutually_exclusive "Action_State_hd" "Action_State_ns" "Action_State_wt" "Action_State_exe" "Action_State_dn" "Action_State_exrm" index Tname)
    (mutually_exclusive "Action_State_ex" "Action_State_ns" "Action_State_wt" "Action_State_exe" "Action_State_dn" "Action_State_exrm" index Tname)))
