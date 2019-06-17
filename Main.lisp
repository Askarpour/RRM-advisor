(asdf:operate 'asdf:load-op 'sbvzot)
(use-package :trio-utils)
(defvar TSPACE 25)
(load "TaskLib/T.lisp")

(defconstant Hazards
 (&&
  *Hazardslist*
  (Risk_estimation)
  (RRMProperties 1 1)
  *RRMcall*
  ))

(defconstant ExeT1
 (&&  
  (load "TaskLib/T1.lisp")
  Hazards
  Config1
  (reset_actions action_indexes  1)
  (init_hazards hazard_indexes)
  (-P- EndEff_1_IN_L_6)
  (AlwF(!!(-P- EndEff_1_IN_L_9)))
  (-P- LINK1_1_IN_L_6)
  (-P- LINK2_1_IN_L_6)
 ))

(defconstant *sys*
 (&&
  (yesterday ExeT1)
 )
 )
(format t "~S" *sys*)
(sbvzot:zot TSPACE
 (&& *sys*))