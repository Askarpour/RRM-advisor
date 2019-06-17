(load "TaskLib/ActionList.lisp")
(load "TaskLib/fcm.lisp")

(defvar action_indexes (loop for i from 1 to 6 collect i))
(defvar T1 1)


;;List of actions
;; 
;; op inserts a wp
;; op is holding the wp
;; op sends move signal to ro
;; arm approaches
;; op sends move signal to ro
;; arm retracts

(defconstant Config1
 (alwf (&&
   (SeqAction action_indexes 1)
   (mutually_exclusive2 action_indexes 1)
   (relativeProperties 1 1)
   (Operator_Body 1)
   (Robot_Structure 1)
   ; List of actions 
   (first_insertp 1 1 4 1)
   (op_hold 2 1 5 1 4 1)
   (send_move_signal 3 1 1)
   (move 4 1 6 4 1)
   (send_move_signal 5 1 4)
   (move 6 1 4 6 1)
   ; (!! (-P- hold))
   (-> (basemoves (setq l '(4 6)) 1)(no_part_moving 1))
)))

