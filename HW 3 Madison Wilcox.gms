$ONTEXT
CEE 6410 - Water Resources Systems Analysis
HW3 - Reservoir Operation Problem

THE PROBLEM:
A reservoir is designed to provide water for irrigation.  The reservoir has a capacity of 9,000 acre-feet.
Initial storage is 3,000 acre-feet of water. The size of the diversion canal and farmed area is very large
relative to the amount of irrigation water available, so there is no upper limit on usable irrigation water.
Any water above the reservoir capacity must be released to the river (spill). The ending storage must be equal
to or greater than the begin¬ning storage.  The benefits per unit of water, and the estimated inflows to the
reservoir in 3 months are given in Table 1. What is the diversion schedule that maximizes benefits?

Data:
Month     Inflow (ac-ft)    Benefit ($/ac-ft)
June      5,000             150
July      3,200             170
August    2,000             425

Initial Storage: 3,000 ac-ft
Max Storage:     9,000 ac-ft
Ending Storage:  >= 3,000 ac-ft

Madison Wilcox
9/29/26
$OFFTEXT

* 1. DEFINE the SETS
SETS t Time periods (months) / June, July, August /;

* 2. DEFINE input data
SCALARS
   S_init Initial reservoir storage at start of June (ac-ft) / 3000 /
   S_max  Maximum reservoir storage capacity (ac-ft)         / 9000 /;

PARAMETERS
   Inflow(t) Forecasted monthly inflows (ac-ft)
         / June    5000,
           July    3200,
           August  2000 /

   Benefit(t) Economic benefit per unit of diverted water ($ per ac-ft)
         / June    150,
           July    170,
           August  425 /;

* 3. DEFINE the variables
VARIABLES
   D(t)     
   S(t)     
   Spill(t) 
   VPROFIT  ;

* Non-negativity constraints
POSITIVE VARIABLES D, S, Spill;

* 4. COMBINE variables and data in equations
EQUATIONS
   PROFIT         
   MassBalance(t) 
   CapBound(t)    
   EndStorage     ;

* Objective Function
PROFIT.. 
   VPROFIT =E= SUM(t, Benefit(t) * D(t));

* Mass Balance Equation: Storage_t = Storage_t-1 + Inflow_t - Diversion_t - Spill_t
MassBalance(t).. 
   S(t) =E= (S_init$SAMEAS(t,'June') + S(t-1)$(NOT SAMEAS(t,'June'))) 
            + Inflow(t) - D(t) - Spill(t);

* Reservoir Capacity Constraint
CapBound(t).. 
   S(t) =L= S_max;

* Ending Storage Constraint: August ending storage >= Initial June storage
EndStorage.. 
   S('August') =G= S_init;

* 5. DEFINE the MODEL from the EQUATIONS
MODEL ReservoirOps / ALL /;

* 6. SOLVE the MODEL
SOLVE ReservoirOps USING LP MAXIMIZING VPROFIT;

* 7. DISPLAY RESULTS
DISPLAY D.L, S.L, Spill.L, VPROFIT.L, MassBalance.M, CapBound.M, EndStorage.M;