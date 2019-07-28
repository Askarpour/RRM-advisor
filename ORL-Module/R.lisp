;;Robot
(defvar roNum 1)
(defvar ro_indexes `(Base Link1 Link2 EndEff))
(defvar ro_indexes_1 `(Base_1 Link1_1 Link2_1 EndEff_1))


(defun Robot_Structure (roID)
 (alwf (&&
  (-A- i `(Base_1 Link1_1 Link2_1 EndEff_1)  (&& (positioning_rules i) (moving i) (moving_gradually i)))
	(|| (In_same_L `Link1_1 `Link2_1) (In_Adj_L `Link1_1 `Link2_1))
	(|| (In_same_L `Link2_1 `EndEff_1) (In_Adj_L `Link2_1 `EndEff_1))
  (-P- BASE_1_IN_L_3)
  (-E- i `(4 5 6) (-P- LINK1_1_IN_L i))
  (-A- i `(1 2 3) (&& (!! (-P- Link1_1_in_L i))(!! (-P- Link2_1_in_L i))))
  (-A- i `(1 2) (!! (-P- EndEff_1_in_L i)))
)))

