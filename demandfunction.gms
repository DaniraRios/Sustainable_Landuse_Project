* Calculate Demand Function Truncation
Sale_Data(TIME,REGION,PRODUCT,"Truncation")
 $(ABS(Sale_Data(TIME,REGION,PRODUCT,"ELASTICITY")) GT 0.05 AND
       Sale_Data(TIME,REGION,PRODUCT,"QUANTITY")    GT 0  AND
       Sale_Data(TIME,REGION,PRODUCT,"PRICE"   )    GT 0       )
 = 10;

Sale_Data(TIME,REGION,PRODUCT,"Truncation")
 $(ABS(Sale_Data(TIME,REGION,PRODUCT,"ELASTICITY")) GT 0.05 AND
       Sale_Data(TIME,REGION,PRODUCT,"QUANTITY")    GT 0  AND
       Sale_Data(TIME,REGION,PRODUCT,"PRICE"   )    GT 0       )
 = MIN(Sale_Data(TIME,REGION,PRODUCT,"Truncation")
        $Sale_Data(TIME,REGION,PRODUCT,"Truncation"),10.0,
       (1.0/(Sale_Data(TIME,REGION,PRODUCT,"Truncation")
          **Sale_Data(TIME,REGION,PRODUCT,"ELASTICITY"))));


Sale_Data(TIME,REGION,PRODUCT,"CONSTANT")
 $(ABS(Sale_Data(TIME,REGION,PRODUCT,"ELASTICITY")) GT 0.05 AND
       Sale_Data(TIME,REGION,PRODUCT,"QUANTITY")    GT 0    AND
       Sale_Data(TIME,REGION,PRODUCT,"PRICE"   )    GT 0       )
 = - Sale_Data(TIME,REGION,PRODUCT,"PRICE") *
     Sale_Data(TIME,REGION,PRODUCT,"QUANTITY") *
   (Sale_Data(TIME,REGION,PRODUCT,"ELASTICITY")/
    (1+Sale_Data(TIME,REGION,PRODUCT,"ELASTICITY"))) *
    (1/Sale_Data(TIME,REGION,PRODUCT,"Truncation"))*
    Sale_Data(TIME,REGION,PRODUCT,"Truncation")**
    (-1/Sale_Data(TIME,REGION,PRODUCT,"ELASTICITY"));

*option Sale_Data:1:3:1; display Sale_Data;