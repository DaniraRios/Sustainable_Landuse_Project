PARAMETER Step_data(STEP) Base value multiplier needed for stepwise linear approximation;
Step_data(STEP) = (ord(STEP)-card(STEP)/2)*abs(ord(STEP)-card(STEP)/2)*0.00001+1;
Step_data(STEP) $( Step_data(STEP) LT 1) = Step_data(STEP) - (1-Step_data(STEP))**0.8;
Step_data(STEP) $( Step_data(STEP) GT 1) = Step_data(STEP) **7;
OPTION Step_data:4:0:1;display Step_data;


Parameter Sale_Data(TIME,REGION,PRODUCT,ALLITEM)
/
year2015.Asia   .grain.quantity     52.16
year2015.Asia   .grain.price        39.40
year2015.Asia   .grain.elasticity   -0.70
year2015.Asia   .straw.quantity     50.91
year2015.Asia   .straw.price          EPS
year2015.Asia   .straw.elasticity   -0.70
year2015.Asia   .fiber.quantity     41.37
year2015.Asia   .fiber.price        34.38
year2015.Asia   .fiber.elasticity   -0.70
year2015.America.grain.quantity     58.98
year2015.America.grain.price        72.75
year2015.America.grain.elasticity   -0.70
year2015.America.straw.quantity    129.88
year2015.America.straw.price          EPS
year2015.America.straw.elasticity   -0.70
year2015.America.fiber.quantity     19.40
year2015.America.fiber.price        34.65
year2015.America.fiber.elasticity   -0.70
year2016.Asia   .grain.quantity     99.56
year2016.Asia   .grain.price        49.74
year2016.Asia   .grain.elasticity   -0.70
year2016.Asia   .straw.quantity     32.33
year2016.Asia   .straw.price          EPS
year2016.Asia   .straw.elasticity   -0.70
year2016.Asia   .fiber.quantity     45.01
year2016.Asia   .fiber.price        46.06
year2016.Asia   .fiber.elasticity   -0.70
year2016.America.grain.quantity    103.65
year2016.America.grain.price        84.77
year2016.America.grain.elasticity   -0.70
year2016.America.straw.quantity     70.95
year2016.America.straw.price          EPS
year2016.America.straw.elasticity   -0.70
year2016.America.fiber.quantity   2656.37
year2016.America.fiber.price        64.00
year2016.America.fiber.elasticity   -0.70
year2017.Asia   .grain.quantity    103.20
year2017.Asia   .grain.price        52.50
year2017.Asia   .grain.elasticity   -0.70
year2017.Asia   .straw.quantity    118.62
year2017.Asia   .straw.price          EPS
year2017.Asia   .straw.elasticity   -0.70
year2017.Asia   .fiber.quantity     52.51
year2017.Asia   .fiber.price        46.58
year2017.Asia   .fiber.elasticity   -0.70
year2017.America.grain.quantity     25.47
year2017.America.grain.price        86.05
year2017.America.grain.elasticity   -0.70
year2017.America.straw.quantity     80.33
year2017.America.straw.price          EPS
year2017.America.straw.elasticity   -0.70
year2017.America.fiber.quantity     32.42
year2017.America.fiber.price        52.82
year2017.America.fiber.elasticity   -0.70
year2018.Asia   .grain.quantity     74.93
year2018.Asia   .grain.price        56.06
year2018.Asia   .grain.elasticity   -0.70
year2018.Asia   .straw.quantity     67.86
year2018.Asia   .straw.price          EPS
year2018.Asia   .straw.elasticity   -0.70
year2018.Asia   .fiber.quantity     26.48
year2018.Asia   .fiber.price        59.46
year2018.Asia   .fiber.elasticity   -0.70
year2018.America.grain.quantity   1807.49
year2018.America.grain.price       105.41
year2018.America.grain.elasticity   -0.70
year2018.America.straw.quantity   1921.52
year2018.America.straw.price          EPS
year2018.America.straw.elasticity   -0.70
year2018.America.fiber.quantity     57.40
year2018.America.fiber.price        67.88
year2018.America.fiber.elasticity   -0.70
year2019.Asia   .grain.quantity    115.82
year2019.Asia   .grain.price        60.42
year2019.Asia   .grain.elasticity   -0.70
year2019.Asia   .straw.quantity     97.84
year2019.Asia   .straw.price          EPS
year2019.Asia   .straw.elasticity   -0.70
year2019.Asia   .fiber.quantity     49.74
year2019.Asia   .fiber.price        58.56
year2019.Asia   .fiber.elasticity   -0.70
year2019.America.grain.quantity    614.71
year2019.America.grain.price       113.69
year2019.America.grain.elasticity   -0.70
year2019.America.straw.quantity     24.35
year2019.America.straw.price          EPS
year2019.America.straw.elasticity   -0.70
year2019.America.fiber.quantity   4693.62
year2019.America.fiber.price        87.20
year2019.America.fiber.elasticity   -0.70
year2020.Asia   .grain.quantity    115.03
year2020.Asia   .grain.price        68.10
year2020.Asia   .grain.elasticity   -0.70
year2020.Asia   .straw.quantity     34.94
year2020.Asia   .straw.price          EPS
year2020.Asia   .straw.elasticity   -0.70
year2020.Asia   .fiber.quantity     14.78
year2020.Asia   .fiber.price        71.16
year2020.Asia   .fiber.elasticity   -0.70
year2020.America.grain.quantity    610.00
year2020.America.grain.price       112.19
year2020.America.grain.elasticity   -0.70
year2020.America.straw.quantity     96.97
year2020.America.straw.price          EPS
year2020.America.straw.elasticity   -0.70
year2020.America.fiber.quantity     64.51
year2020.America.fiber.price        78.14
year2020.America.fiber.elasticity   -0.70
year2021.Asia   .grain.quantity    119.68
year2021.Asia   .grain.price        60.44
year2021.Asia   .grain.elasticity   -0.70
year2021.Asia   .straw.quantity     52.00
year2021.Asia   .straw.price          EPS
year2021.Asia   .straw.elasticity   -0.70
year2021.Asia   .fiber.quantity     27.57
year2021.Asia   .fiber.price        73.32
year2021.Asia   .fiber.elasticity   -0.70
year2021.America.grain.quantity    114.84
year2021.America.grain.price       116.55
year2021.America.grain.elasticity   -0.70
year2021.America.straw.quantity    453.74
year2021.America.straw.price          EPS
year2021.America.straw.elasticity   -0.70
year2021.America.fiber.quantity   2182.34
year2021.America.fiber.price       101.26
year2021.America.fiber.elasticity   -0.70
year2022.Asia   .grain.quantity     54.37
year2022.Asia   .grain.price        68.90
year2022.Asia   .grain.elasticity   -0.70
year2022.Asia   .straw.quantity     55.09
year2022.Asia   .straw.price          EPS
year2022.Asia   .straw.elasticity   -0.70
year2022.Asia   .fiber.quantity    144.96
year2022.Asia   .fiber.price        68.04
year2022.Asia   .fiber.elasticity   -0.70
year2022.America.grain.quantity   1076.95
year2022.America.grain.price       133.41
year2022.America.grain.elasticity   -0.70
year2022.America.straw.quantity    841.71
year2022.America.straw.price          EPS
year2022.America.straw.elasticity   -0.70
year2022.America.fiber.quantity     62.20
year2022.America.fiber.price        94.58
year2022.America.fiber.elasticity   -0.70
/;






