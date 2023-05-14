option limcol=0; option limrow=0;
option solprint=off;

$setglobal gp_term svg


SETS
allitem
 /land, water, energy, labor
  emission,pollution,
  cost, production,quantity,price,elasticity,
  grain,straw,fiber,croppro,
  maximum , minimum,
  export, import,
  constant,truncation, Reference
 /
crop
 /wheat,maize,sugarcane/
resource(allitem)
 /land, water, energy, labor/
envimpact(allitem)
 /emission,pollution/
product(allitem)
 /grain,straw,fiber/
Alltime
 /year2015*year2022,2015_2020,2021_2022/
time(Alltime)
 /year2015*year2022/
time1(Alltime)
 /year2015*year2020/
time2(Alltime)
 /year2021*year2022/
history
 /1950*2020/
StorageItem
 /Level,Addition,Release/
AllRegion
 /Asia,America,Developed/
Region(AllRegion)
 /Asia,America/
Step
 /Step1*Step400/
Time_Map(AllTime,AllTime)
Region_Map(AllRegion,AllRegion)
;

Time_Map(Time,Time) = yes;
Time_Map(Time1,"2015_2020") = yes;
Time_Map(Time2,"2021_2022") = yes;

Region_Map(Region,Region) = yes;
Region_Map("Asia","Developed") = yes;
Region_Map("America","Developed") = yes;


ALIAS(Region,Importer,Exporter);

$include regionmarket_data.gms
$include demandfunction.gms
$include regionproduct_data.gms
$include regionresource_data.gms
$include regioncrop_data.gms
$include cropmix_data.gms
$include envimpact_data.gms
$include tradecost_data.gms
$include emissionpolicy_data.gms




Free variable
    WELFARE_VAR                                   mill dollars;

NONNEGATIVE variables
    SALE_VAR(TIME,REGION,PRODUCT)                 mill tons
    CROP_VAR(TIME,REGION,CROP)                    mill ha
    CROPMIX_VAR(TIME,REGION,HISTORY)
    SALEStep_VAR(TIME,REGION,PRODUCT,STEP)
    MINSALE_VAR(TIME,REGION,PRODUCT)           mill tons
    STORAGE_VAR(TIME,REGION,Product,StorageItem)
    Trade_Var(Time,Region,Region,Product)
    Emission_Var(Time,Region,ENVIMPACT)
;

Equations
Objective_Func
Resource_Equ(TIME,REGION,RESOURCE)
Cropmix_Equ(TIME,REGION,CROP)
Product_Equ(TIME,REGION,PRODUCT)
Product_MinEqu(TIME,REGION,PRODUCT)
SALE_Convexity_Equ(TIME,REGION,PRODUCT)
SALE_Identity_Equ(TIME,REGION,PRODUCT)
Environmental_Equ(TIME,REGION,ENVIMPACT)
CapEmission_Equ(AllTime,AllRegion,Envimpact)
MINSALE_Equ(TIME,REGION,PRODUCT)
Storage_Equ(TIME,REGION,Product)
;


Model
Landuse_AsianAmerican
/
Objective_Func
Resource_Equ
Product_Equ
Environmental_Equ
Cropmix_Equ
MINSALE_Equ
Sale_Convexity_Equ
Sale_Identity_Equ
Storage_Equ
CapEmission_Equ
/
;


Objective_Func..

  WELFARE_VAR
    =L=
* Price endogneous sales (Area under all domestic demand curves)
  SUM((TIME,REGION,PRODUCT)
   $(Sale_Data(TIME,REGION,PRODUCT,"QUANTITY")   GT  0    AND
     Sale_Data(TIME,REGION,PRODUCT,"PRICE")      GT  0    AND
     Sale_Data(TIME,REGION,PRODUCT,"ELASTICITY") LT -0.05     ),

   SUM(STEP $(Sale_Data(TIME,REGION,PRODUCT,"Truncation") GE
              1/Step_data(STEP)),
     (Step_data(STEP)**
       (1./Sale_Data(TIME,REGION,PRODUCT,"ELASTICITY")) *
      Sale_Data(TIME,REGION,PRODUCT,"QUANTITY") *
      Step_data(STEP) *
      Sale_Data(TIME,REGION,PRODUCT,"PRICE") *
      Sale_Data(TIME,REGION,PRODUCT,"ELASTICITY") /
       (1.+Sale_Data(TIME,REGION,PRODUCT,"ELASTICITY"))
     +Sale_Data(TIME,REGION,PRODUCT,"CONSTANT")) *
    SALEStep_VAR(TIME,REGION,PRODUCT,STEP)))

* Price exogneous sales
 +SUM((TIME,REGION,PRODUCT)
   $(Sale_Data(TIME,REGION,PRODUCT,"PRICE")      GT  0    AND
     Sale_Data(TIME,REGION,PRODUCT,"ELASTICITY") GE -0.05     ),
   Sale_Data(TIME,REGION,PRODUCT,"Price") *
   SALE_VAR(TIME,REGION,PRODUCT))
* Cost of production
 -SUM((TIME,REGION,CROP)
   $ SUM(PRODUCT,CROP_DATA(REGION,TIME,CROP,PRODUCT)),
   CROP_DATA(REGION,TIME,CROP,"COST") *
   CROP_VAR(TIME,REGION,CROP))

* Cost of storage
 -SUM((TIME,REGION,PRODUCT),
   (Sale_Data(TIME,REGION,PRODUCT,"Price")/10) *
    STORAGE_VAR(Time,REGION,Product,"Level"))

* Cost of storage change
 -SUM((TIME,REGION,PRODUCT),
   (Sale_Data(TIME,REGION,PRODUCT,"Price")/100) *
   (STORAGE_VAR(TIME,REGION,Product,"Addition")
    +STORAGE_VAR(TIME,REGION,Product,"Release")))

* Cost of trade
 -SUM((Exporter,Importer,TIME,PRODUCT),
  tradecost_data(Exporter,Importer,TIME,PRODUCT) *
  trade_var(Time,Exporter,Importer,PRODUCT))
$ontext
* Emissions
 - SUM((Time,Region,ENVIMPACT),
    Emission_DATA(Time,Region,ENVIMPACT,"Price") *
    Emission_Var(Time,Region,ENVIMPACT))
$offtext
;


MINSALE_Equ(TIME,REGION,PRODUCT)..

  SALE_VAR(TIME,REGION,PRODUCT)

  +  MINSALE_VAR(TIME,REGION,PRODUCT)

  =G=

 PRODUCT_DATA(time,region,product,"minimum");


Storage_Equ(TIME,REGION,Product) ..

  STORAGE_VAR(TIME,REGION,Product,"Level")

  =E=

   STORAGE_VAR(Time-1,REGION,Product,"Level")
 + STORAGE_VAR(TIME,REGION,Product,"Addition")
 - STORAGE_VAR(TIME,REGION,Product,"Release")
;

Product_Equ(TIME,REGION,PRODUCT)..

 + SALE_VAR(TIME,REGION,PRODUCT)
 + STORAGE_VAR(TIME,REGION,Product,"Addition")

 + SUM(Importer,
    trade_var(Time,Region,Importer,PRODUCT))

 - SUM(Exporter,
     trade_var(Time,Exporter,Region,PRODUCT))

 - STORAGE_VAR(TIME,REGION,Product,"Release")
 - SUM(CROP,
    CROP_DATA(REGION,TIME,CROP,PRODUCT) *
    CROP_VAR(TIME,REGION,CROP))

   =L= 0;


Resource_Equ(TIME,REGION,RESOURCE)..

 SUM(CROP
  $ SUM(PRODUCT,CROP_DATA(REGION,TIME,CROP,PRODUCT)),
  CROP_DATA(REGION,TIME,CROP,RESOURCE) *
  CROP_VAR(TIME,REGION,CROP))

  =L= RESOURCE_DATA(TIME,REGION,RESOURCE,"Maximum");


Cropmix_Equ(TIME,REGION,CROP)
 $(SUM(PRODUCT,CROP_DATA(REGION,TIME,CROP,PRODUCT)) and
   SUM(HISTORY,CROPMIX_Data(REGION,HISTORY,CROP)))..

   CROP_VAR(TIME,REGION,CROP)

   =E=

   SUM(HISTORY,
   CROPMIX_Data(REGION,HISTORY,CROP)*
   CROPMIX_VAR(TIME,REGION,HISTORY));


Environmental_Equ(TIME,REGION,ENVIMPACT)..

 SUM(CROP
  $ SUM(PRODUCT,CROP_DATA(REGION,TIME,CROP,PRODUCT)),
  CROP_DATA(REGION,TIME,CROP,ENVIMPACT) *
  CROP_VAR(TIME,REGION,CROP))

  =E= Emission_Var(Time,Region,ENVIMPACT);


  CapEmission_Equ(AllTime,AllRegion,Envimpact)
 $ Emission_DATA(AllTime,AllRegion,ENVIMPACT,"Maximum")..

 SUM((Time_Map(Time,AllTime),Region_Map(Region,AllRegion)),
  Emission_Var(Time,Region,ENVIMPACT))

  =L=  Emission_DATA(AllTime,AllRegion,ENVIMPACT,"Maximum");

* Demand Convexity Constraints
Sale_CONVEXITY_Equ(TIME,REGION,PRODUCT)
 $(Sale_Data(TIME,REGION,PRODUCT,"QUANTITY")   GT  0    AND
   Sale_Data(TIME,REGION,PRODUCT,"PRICE")      GT  0    AND
   Sale_Data(TIME,REGION,PRODUCT,"ELASTICITY") LT -0.05    )..

 SUM(STEP
  $(Sale_Data(TIME,REGION,PRODUCT,"Truncation") GE
     1/Step_data(STEP) ),
  SALEStep_VAR(TIME,REGION,PRODUCT,STEP))

     =L= 1;


* Demand Identity Constraints
Sale_IDENTITY_Equ(TIME,REGION,PRODUCT)
 $(Sale_Data(TIME,REGION,PRODUCT,"QUANTITY") GT  0    AND
   Sale_Data(TIME,REGION,PRODUCT,"PRICE")    GT  0    AND
   Sale_Data(TIME,REGION,PRODUCT,"ELASTICITY") LT -0.05    )..

 SUM(STEP
  $(Sale_Data(TIME,REGION,PRODUCT,"Truncation") GE
    1/Step_data(STEP)),
  Step_data(STEP) *
  Sale_Data(TIME,REGION,PRODUCT,"QUANTITY") *
  SALEStep_VAR(TIME,REGION,PRODUCT,STEP))

     =L= Sale_VAR(TIME,REGION,PRODUCT);


$onecho > %system.fn%.gck
blockpic
analysis
postopt
$offecho


Emission_DATA(Time,Region,ENVIMPACT,"Price")
 = 0;


Solve Landuse_AsianAmerican using LP maximizing WELFARE_VAR;
display CROP_VAR.L,SALE_VAR.L,STORAGE_VAR.L,CROPMIX_VAR.L
display CapEmission_Equ.M,Emission_Var.L;
display Resource_Equ.M,Environmental_Equ.M,SALEStep_VAR.L, Objective_Func.M;


Set Scenario /NoPolicy,50CAP/;

Parameter
ProductReport(TIME,REGION,Product,Scenario,Allitem)

;


ProductReport(TIME,REGION,Product,"NoPolicy","Production")
 = SUM(CROP,
    CROP_DATA(REGION,TIME,CROP,PRODUCT) *
    CROP_VAR.L(TIME,REGION,CROP));


ProductReport(TIME,REGION,Product,"NoPolicy","Price")
 = Product_Equ.M(TIME,REGION,PRODUCT);

Emission_DATA(Time,Region,"Emission","Maximum")
 = Emission_Var.L(Time,Region,"Emission")* 0.5;

Solve Landuse_AsianAmerican using LP maximizing WELFARE_VAR;


ProductReport(TIME,REGION,Product,"50CAP","Production")
 = SUM(CROP,
    CROP_DATA(REGION,TIME,CROP,PRODUCT) *
    CROP_VAR.L(TIME,REGION,CROP));



ProductReport(TIME,REGION,Product,"50CAP","Price")
 = Product_Equ.M(TIME,REGION,PRODUCT);



option ProductReport:1:1:1;

display ProductReport;
Parameter
plot_ProductReport(*,*,*)
;
$libinclude gnuplotxyz
$setglobal gp_loop1 AllItem
$setglobal gp_loop2 REGION
$setglobal gp_loop3 no

$setglobal gp_key top center


display time;



LOOP((Allitem,REGION)
  $ SUM((Product,Scenario,Time), ProductReport(TIME,REGION, Product, Scenario,Allitem )),

plot_ProductReport(Time,Product,Scenario)
 = ProductReport(TIME,REGION,Product,Scenario,Allitem);

plot_ProductReport(Time,"Straw",Scenario)
 $ sameas(Allitem,"Price")
 = 0;


$libinclude gnuplotxyz  plot_ProductReport
);

$setglobal gp_loop1 no
$setglobal gp_loop2 no





