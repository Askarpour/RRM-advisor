(load "TaskLib/ActionList.lisp")
(load "TaskLib/fcm.lisp")

(defvar action_indexes (loop for i from 1 to 8 collect i))
(defvar T1 1)

;;List of actions
;; 
;; ro picks a wp 
;; ro is holding the wp
;; arm approaches the pallet
;; ro inserts the wp
;; op approaches the pallet
;; op screwdrives
;; op retracts from the pallet
;; arm retracts from the pallet

(defconstant Config1
 (alwf (&&
   (SeqAction action_indexes 1)
   (mutually_exclusive2 action_indexes 1)
   (relativeProperties 1 1)
   (Operator_Body 1)
   (Robot_Structure ro_indexes_1)
; List of actions 
   (pick-first 1 1 3 1)
   (ee_hold_moving 2 1 7 1 3 1)
   (move 3 1 3 4 1 1)
   (insertp 4 1 4 1)
   (op_moves 5 1 4 1)
   (unscrew 6 1 4 1)
   (op_moves 7 1 5 1)
   (move 8 1 4 3 1 2)

   (!! (-P- hold))
   (-> (basemoves (setq l '(3 8)) 1)(no_part_moving 1))
)))

