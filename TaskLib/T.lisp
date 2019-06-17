(defvar notcall 0)
(defvar exetime 1)
; things to export
(defvar Threshold 2)

(load "ORL-Module/L.lisp")
(load "ORL-Module/O.lisp")
(load "ORL-Module/R.lisp")

(load "Hazards.lisp")
(load "RRM.lisp")
(load "REs.lisp")
(load "REv.lisp")
; (load "TaskLib/fcm.lisp") ;<-************************

(defun mutually_exclusive (str1 str2 str3 str4 str5 str6 index Tname)
  (eval (list `alwf (append `(&&)
   (loop for i in index collect
   `(&&
    (<->
      (-P- ,(read-from-string (format nil "~A_~A_~A" str1 i Tname))) 
      (&&
        (!! (-P- ,(read-from-string (format nil "~A_~A_~A" str2 i Tname))))
        (!! (-P- ,(read-from-string (format nil "~A_~A_~A" str3 i Tname))))
        (!! (-P- ,(read-from-string (format nil "~A_~A_~A" str4 i Tname))))
        (!! (-P- ,(read-from-string (format nil "~A_~A_~A" str5 i Tname))))
        (!! (-P- ,(read-from-string (format nil "~A_~A_~A" str6 i Tname))))
        ))))))))


(defun SeqAction (index Tname)
  (-A- i index
   (&&
     ;each action is done either by op or ro
    (<->(-P- Action_Doer_ro i Tname) (!!(-P- Action_Doer_op  i Tname)))

     ;op either starts or stops
    (!! (&& (-P- Op_starts i Tname) (-P- Op_stops i Tname)))

    ; op can start or stop only when in position
    (-> (-P- Op_starts i Tname) (-P- Action_Pre_L i Tname))
    (->  (-P- Op_stops i Tname) (-P- Action_Post_L i Tname))

    ;op can stop only if he started within past exetime units
    (->  (-P- Op_stops  i Tname) (withinP (-P- Op_starts i Tname) exetime))
    
     ;robot actions do not have waiting state
    (->(-P- Action_Doer_ro  i Tname) (Alwf(!! (-P- Action_State_wt i Tname))))
     
     ;ns
    (<->
      (-P- Action_State_ns i Tname)
      (&&
        (alwp (||(-P- Action_State_ns i Tname) (-P- Action_State_wt i Tname)))
        (!! (-P- Action_Pre i Tname))))

    ;waiting
    (<->
      (-P- Action_State_wt i Tname)
      (&& 
        (-P- Action_Doer_op i Tname)
        (-P- Action_Pre i Tname)
        (!!(-P- Op_starts i Tname))
        (alwp (||(-P- Action_State_ns i Tname)(-P- Action_State_wt i Tname)))
        (next (|| 
          (-P- Action_State_wt i Tname)
          (-P- Action_State_exe i Tname) 
          (-P- Action_State_exrm i Tname)
        ))
        ))

    ;exe
    (<->
      (-P- Action_State_exe i Tname)
      (&& 
        (!! (-P- Action_Post i Tname))
        (-P- no_RRM)
        (!! (-P- hold))
        (alwp(&&
          (!! (-P- Action_State_dn i Tname))
          ))
        (alwF(&&
          (!! (-P- Action_State_ns i Tname))
          (!! (-P- Action_State_wt i Tname))
          ))
        (||
          (Yesterday (&& (-P- Action_State_wt i Tname) (-P- Action_Pre i Tname)))
          (Yesterday(-P- Action_State_exe i Tname))
          (Yesterday(-P- Action_State_exrm i Tname))
          (&&(Yesterday(-P- Action_State_ns i Tname)) (-P- Action_Pre i Tname) (-P- Action_Doer_ro i Tname))
          (Yesterday(-P- Action_State_hd i Tname))
        )
        ))

    ;exrm
    (<->
      (-P- Action_State_exrm i Tname)
      (&& 
        (!! (-P- Action_Post i Tname))
        (!! (-P- no_RRM)) 
        (!! (-P- hold))
        (alwp(&&
          (!! (-P- Action_State_dn i Tname))
          ))
        (alwF(&&
          (!! (-P- Action_State_ns i Tname))
          (!! (-P- Action_State_wt i Tname))
          ))
        (||
          (Yesterday (&& (-P- Action_State_wt i Tname) (-P- Action_Pre i Tname)))
          (Yesterday(-P- Action_State_exe i Tname))
          (Yesterday(-P- Action_State_exrm i Tname))
          (&&(Yesterday(-P- Action_State_ns i Tname)) (-P- Action_Pre i Tname) (-P- Action_Doer_ro i Tname) )
          (Yesterday(-P- Action_State_hd i Tname))
        )
      ))

    ;hold
    (<->
      (-P- Action_State_hd i Tname)
      (&& 
        (alwF(&&
          (!! (-P- Action_State_ns i Tname))
          (!! (-P- Action_State_wt i Tname))
          ))
        (-P- hold) 
        (alwp(&&
          (!! (-P- Action_State_dn i Tname))
          ))
        (Yesterday (!! (|| (-P- Action_State_ns i Tname) (-P- Action_State_wt i Tname) (-P- Action_State_dn i Tname))))
      )
    )

    ; done
    (<->
      (-P- Action_State_dn i Tname) 
      (&& 
        (alwf (-P- Action_State_dn i Tname))
        (SomP ( || (-P- Action_State_exrm i Tname) (-P- Action_State_exe i Tname)))
       (|| 
        (Yesterday(-P- Action_State_dn i Tname)) 
        (&& (Yesterday(-P- Action_State_exrm i Tname)) (-P- Action_Post i Tname))
        (&& (Yesterday(-P- Action_State_exe i Tname)) (-P- Action_Post i Tname))
        )
       (SomP 
       (lasted (|| (-P- Action_State_exrm i Tname) (-P- Action_State_exe i Tname)) exetime)
       )
      )
    )

    (<->
      (-P- safety-property)
      (&& (Risk= Threshold) (Yesterday (Risk= Threshold))))

    )))

(defun reset_actions (index Tname)
 (-A- i index 
    (-P- Action_State_ns i Tname)))
   
