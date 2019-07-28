; Layout
(defvar L_indexes (loop for i from 1 to 9 collect i))
(defvar L_half 3)
(defvar L_last 6)
(defvar L_last_up 9)
(defvar L_first 1)

(defun IsPallet (i) (eval `(|| (-P- ,(read-from-string (format nil "~A_In_L_~A" i 1))) (-P- ,(read-from-string (format nil "~A_In_L_~A" i 2))) (-P- ,(read-from-string (format nil "~A_In_L_~A" i 3))))))
(defun IsWall (i) (&& (!! t)))
(defun occluded (i)(|| (IsWall i)(IsPallet i)))

;i has always a position. write (always_in_an_L `Link1)
(defun always_in_an_L (i)
  (eval (list `alwf (append `(||) (loop for l_i in L_indexes collect `(-P- ,(read-from-string (format nil "~A_In_L_~A" i l_i))))))))

;i only in l1. write (only_in_one_L `Link1 1)
(defun only_in_one_L (i l1)
  (eval (append `(&&)
   (loop for l2 in L_indexes 
      when (/= l1 l2) 
      collect 
      `(-> (-P- ,(read-from-string (format nil "~A_In_L_~A" i l1))) 
        (!! (-P- ,(read-from-string (format nil "~A_In_L_~A" i l2))))
)))))

(defun positioning_rules (i)
  (&&
    (-A- l2  L_indexes (only_in_one_L i l2))
    (always_in_an_L i)
  ))

; i inside j. write like (inside `Link1_id 1)
(defun Inside (i j)
  (eval
    `(&& (-P- ,(read-from-string (format nil "~A_In_L_~A" i j))) 
      (only_in_one_L ,(read-from-string (format nil "`~A" i)) ,(read-from-string (format nil "~A" j))) )))

;i and j are two adjacent elements. write (In_Adj_L `Link1 `Link2)
(defun In_Adj_L (i j)
  (eval (append `(||)  
   (loop for l_i in L_indexes collect
    `(&& (-P- ,(read-from-string (format nil "~A_In_L_~A" i l_i)))
      (In_Adj_L_help ,(read-from-string (format nil "`~A" j)) ,(read-from-string (format nil "~A" l_i)) )
      )))))
;i is adjacent to location j. write (In_Adj_L `Link1 1)
(defun In_Adj_with_L (i j)
  (eval (append `(||)  
   (loop for l_i in L_indexes collect
    `(&& (-P- ,(read-from-string (format nil "~A_In_L_~A" i l_i)))  
      (eval(Adj ,(read-from-string (format nil "~A" l_i)) ,(read-from-string (format nil "~A" j))))
    )))))

;auxiliary function, because lisp sucks
(defun In_Adj_L_help(j l_i)
  (eval (append `(||)  
   (loop for l_j in L_indexes collect
    `(&& (-P- ,(read-from-string (format nil "~A_In_L_~A" j l_j))) 
      (eval (Adj ,(read-from-string (format nil "~A" l_i)) ,(read-from-string (format nil "~A" l_j)))))
    ))))

(defun above_same_L (i j)
  (eval (append `(||)  
  (loop for l in '(1 2 3) ; in L_indexes when (<= (+ l L_half) L_last)
    collect
  `(&&
    (-P- ,(read-from-string (format nil "~A_In_L_~A" i l)))
    (-P- ,(read-from-string (format nil "~A_In_L_~A" j (+ l 3)))))))))

(defun above_same_L_upper (i j)
  (eval (append `(||)  
  (loop for l in '(4 5 6)
    collect
  `(&&
    (-P- ,(read-from-string (format nil "~A_In_L_~A" i  l)))
    (-P- ,(read-from-string (format nil "~A_In_L_~A" j (+ l 3)))))))))

;i and j are in the same L. write (In_same_L `Link1_1 `Link2_1)
(defun In_same_L (i j)
  (eval (append `(||)  
  (loop for l in L_indexes collect
  `(&&
    (-P- ,(read-from-string (format nil "~A_In_L_~A" i l)))
    (-P- ,(read-from-string (format nil "~A_In_L_~A" j l))))))))

(defun Adj (i j) 
  (|| 
    (&& ([=] i 1) (||([=] j 2) ([=] j 3) ([=] j 4) ([=] j 5) ))
    (&& ([=] i 2) (||([=] j 1) ([=] j 3) ([=] j 5) ))
    (&& ([=] i 3) (||([=] j 2) ([=] j 4) ([=] j 5) ([=] j 6) ([=] j 1) ))
    (&& ([=] i 4) (||([=] j 1) ([=] j 3)([=] j 5) ([=] j 6) ([=] j 8) ([=] j 9) ([=] j 7) ))
    (&& ([=] i 5) (||([=] j 1) ([=] j 3)([=] j 2) ([=] j 4) ([=] j 6) ([=] j 7) ))
    (&& ([=] i 6) (||([=] j 3) ([=] j 4) ([=] j 5) ([=] j 8) ([=] j 9) ))
    (&& ([=] i 7) (||([=] j 5) ([=] j 4) ([=] j 8) ))
    (&& ([=] i 8) (||([=] j 4) ([=] j 6) ([=] j 7) ([=] j 9) ))
    (&& ([=] i 9) (||([=] j 4) ([=] j 6) ([=] j 8) ))

  )
  )

(defun relativeProperties (opID roID)
 (alwf (&&    

    (<->(-P- RELATIVEVELOCITY_1_1_none)(&&(!!(-P- RELATIVEVELOCITY_1_1_low))(!!(-P- RELATIVEVELOCITY_1_1_mid))(!!(-P- RELATIVEVELOCITY_1_1_high))))
    (<->(-P- RELATIVEVELOCITY_1_1_low)(&&(!!(-P- RELATIVEVELOCITY_1_1_none))(!!(-P- RELATIVEVELOCITY_1_1_mid))(!!(-P- RELATIVEVELOCITY_1_1_high))))
    (<->(-P- RELATIVEVELOCITY_1_1_mid)(&&(!!(-P- RELATIVEVELOCITY_1_1_low))(!!(-P- RELATIVEVELOCITY_1_1_none))(!!(-P- RELATIVEVELOCITY_1_1_high))))
    (<->(-P- RELATIVEVELOCITY_1_1_high)(&&(!!(-P- RELATIVEVELOCITY_1_1_low))(!!(-P- RELATIVEVELOCITY_1_1_mid))(!!(-P- RELATIVEVELOCITY_1_1_none))))
    
    (<->(-P- relativeforce_1_1_none)(&&(!!(-P- relativeforce_1_1_low))(!!(-P- relativeforce_1_1_mid))(!!(-P- relativeforce_1_1_high))))
    (<->(-P- relativeforce_1_1_low)(&&(!!(-P- relativeforce_1_1_none))(!!(-P- relativeforce_1_1_mid))(!!(-P- relativeforce_1_1_high))))
    (<->(-P- relativeforce_1_1_mid)(&&(!!(-P- relativeforce_1_1_low))(!!(-P- relativeforce_1_1_none))(!!(-P- relativeforce_1_1_high))))
    (<->(-P- relativeforce_1_1_high)(&&(!!(-P- relativeforce_1_1_low))(!!(-P- relativeforce_1_1_mid))(!!(-P- relativeforce_1_1_none))))
    
    (-A- bodypart body_indexes_1
    (-A- robotpart ro_indexes_1 (&&
      (<->
        (-P- relativeSeparation robotpart bodypart `clos)
        (In_same_L robotpart bodypart)
      )
      (<->
        (-P- relativeSeparation robotpart bodypart `far)
        (In_Adj_L robotpart bodypart)
      )
      (<->
        (-P- relativeSeparation robotpart bodypart `very_far)
        (&&(!!(-P- relativeSeparation robotpart bodypart `clos)) (!!(-P- relativeSeparation robotpart bodypart `far)))
      )
      (<->  (-P- moveDirection robotpart bodypart `clos)
        (|| (&& (-P- relativeSeparation robotpart  bodypart `clos)(yesterday (-P- relativeSeparation robotpart  bodypart `far))) 
            (&& (-P- relativeSeparation robotpart  bodypart `far)(yesterday (-P- relativeSeparation robotpart  bodypart `very_far)))
      ))
      (<-> (-P- moveDirection robotpart bodypart `far)
           (!!(-P- moveDirection robotpart bodypart `clos))
      )
     )))
    (<->
      (-P- RELATIVEVELOCITY_1_1_none)
      (&&
        (next (|| (-P- RELATIVEVELOCITY_1_1_none) (-P- RELATIVEVELOCITY_1_1_low) ))
        (-P- OPERATORSTILL_1) 
        (-P- roStill)
    ))

    (<->
      (-P- RELATIVEVELOCITY_1_1_low)
      (&&
        (next (|| (-P- RELATIVEVELOCITY_1_1_none) (-P- RELATIVEVELOCITY_1_1_low) (-P- RELATIVEVELOCITY_1_1_mid)))
        (|| (-P- roStill) (-P- OPERATORSTILL_1))
    ))

    (<->
      (-P- RELATIVEVELOCITY_1_1_mid)
      (&&
        (next (|| (-P- RELATIVEVELOCITY_1_1_mid) (-P- RELATIVEVELOCITY_1_1_low) (-P- RELATIVEVELOCITY_1_1_high)))
        (!!(-P- OPERATORSTILL_1)) (!!(-P- roStill))
    ))
    (<->
    (-P- RELATIVEVELOCITY_1_1_high)
    (&&
      (next (|| (-P- RELATIVEVELOCITY_1_1_mid) (-P- RELATIVEVELOCITY_1_1_high)))
      (!!(-P- RELATIVEVELOCITY_1_1_mid))
      (!!(-P- RELATIVEVELOCITY_1_1_low))
      (!!(-P- RELATIVEVELOCITY_1_1_none))
    ))
)))

(defun not_close ()
  (-A- i body_indexes_1
    (-A- j ro_indexes_1
      (!! (-P- RELATIVESEPARATION j i `CLOS)))))


(defun forbiden_for_ro (roId l)
  (alwf
    (-A- i l
      (-A- b body_indexes
      (!! (-P- operator roId `_In_L b i))))))

(defun always_attached (i j)
  (alwf 
    (|| 
      (In_same_L i j)
      (above_same_L i j)
      (above_same_L_upper i j)
      (In_Adj_L i j)
      )))

(defun i_is_moving (i)
  (eval (append `(||)  
   (loop for l_i in L_indexes collect
    `(&& (-P- ,(read-from-string (format nil "~A_In_L_~A" i l_i))) 
      (yesterday(!!(-P- ,(read-from-string (format nil "~A_In_L_~A" i l_i))))))))))

(defun moving (i)
  (eval `(alwf (<->
      (-P- ,(read-from-string (format nil "~A_Moving" i)))
      (i_is_moving ,(read-from-string (format nil "`~A" i)))
      ))))


(defun moving_gradually (i)
  (eval (append `(&&)  
  (loop for l in L_indexes collect
  `(->
    (-P- ,(read-from-string (format nil "~A_In_L_~A" i l))) 
    (next(||
          (-P- ,(read-from-string (format nil "~A_In_L_~A" i l)))
          (In_Adj_with_L ,(read-from-string (format nil "`~A" i)) ,(read-from-string (format nil "~A" l)))
          ))
    )))))

;use like (robotidle (setq l '(1 2 3)) Tname)
(defun basemoves (l Tname)
  (-A- i l 
  (!! (|| (-P- Action_State_exe i Tname) (-P- Action_State_exrm i Tname)))))


(defun no_part_moving (roId)
   (eval (append `(&&)  
    (loop for i in ro_indexes collect 
      `(!!(-P- ,(read-from-string (format nil "~A_~A_Moving" i roId))))))))