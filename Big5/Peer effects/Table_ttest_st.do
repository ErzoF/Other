local semestres ""2019-I PER" "2019-II PER" "2020-I PER" "2020-II PER" "2021-I PER" "2021-II PER" "2022-I PER" "2022-II PER" "2023-I PER""
foreach  semestre of local semestres{
	
local cursos ""Economía General I" "Nivelación en Lenguaje" "Nivelación en Matemáticas"" 
foreach  curso of local cursos{

global bases "C:\Users\Erzo\OneDrive - Universidad del Pacífico\Univesidad del Pacífico\Ciclo\lCiclo 7 2024 I\Asistente\Big5\Hasta_2023\Bases"
use "$bases/salones", clear
gen N_K=cachimbo
gen Neuro_k=Neuro if cachimbo==1
gen Extrav_k=Extrav if cachimbo==1
gen Aperex_k=Aperex if cachimbo==1
gen Amab_k=Amab if cachimbo==1
gen Resp_k=Resp if cachimbo==1
gen estandar_Neuro_k=estandar_Neuro if cachimbo==1
gen estandar_Extrav_k=estandar_Extrav if cachimbo==1
gen estandar_Aperex_k=estandar_Aperex if cachimbo==1
gen estandar_Amab_k=estandar_Amab if cachimbo==1
gen estandar_Resp_k=estandar_Resp if cachimbo==1



collapse (first) acayearterm N SECCION_DEL_CURSO (sum) N_K (first)NOMBRE_DEL_CURSO (mean)cachimbo Neuro Extrav Aperex Amab Resp estandar_Neuro estandar_Extrav estandar_Aperex estandar_Amab estandar_Resp Neuro_k Extrav_k Aperex_k Amab_k Resp_k estandar_Neuro_k estandar_Extrav_k estandar_Aperex_k estandar_Amab_k estandar_Resp_k, by (salon)

keep if acayearterm=="`semestre'" & NOMBRE_DEL_CURSO=="`curso'"

if "`semestre'"=="2019-I PER"{
local sem 20191	
}
if "`semestre'"=="2020-I PER"{
local sem 20201	
}
if "`semestre'"=="2021-I PER"{
local sem 20211	
}
if "`semestre'"=="2022-I PER"{
local sem 20221	
}
if "`semestre'"=="2023-I PER"{
local sem 20231	
}

if "`curso'"=="Economía General I"{
local cur eco1	
}
if "`curso'"=="Nivelación en Lenguaje"{
local cur nivelengua	
}
if "`curso'"=="Nivelación en Matemáticas"{
local cur nivemate
}
sort SECCION_DEL_CURSO


drop salon acayearterm NOMBRE_DEL_CURSO
order SECCION_DEL_CURSO N N_K cachimbo Neuro Extrav Aperex Amab Resp estandar_Neuro estandar_Extrav estandar_Aperex estandar_Amab estandar_Resp Neuro_k Extrav_k Aperex_k Amab_k Resp_k estandar_Neuro_k estandar_Extrav_k estandar_Aperex_k estandar_Amab_k estandar_Resp_k
rename SECCION_DEL_CURSO S
rename N N_T
rename cachimbo Pct_K
drop Neuro_k Extrav_k Aperex_k Amab_k Resp_k Neuro Extrav Aperex Amab Resp

summarize
if r(N)!=0{
global tablas "C:\Users\Erzo\OneDrive - Universidad del Pacífico\Univesidad del Pacífico\Ciclo\lCiclo 7 2024 I\Asistente\Big5\Peer effects classrooms\Tablas\standard"
export excel "$tablas/standard`cur'`sem'", firstrow(variable) replace
}
}
}


************************************************************************************************DUMMIES_raw_standar_20231 
*como ya filtro el raw, los salones con la variable estandarizada se mantendrán como max o como min
foreach j of numlist 2020 2021 2022 2023 { 
clear all
global bases "C:\Users\Erzo\OneDrive - Universidad del Pacífico\Univesidad del Pacífico\Ciclo\lCiclo 7 2024 I\Asistente\Big5\Hasta_2023\Bases"
use "$bases/salones", clear

gen Neuro_k=Neuro if cachimbo==1
gen Extrav_k=Extrav if cachimbo==1
gen Aperex_k=Aperex if cachimbo==1
gen Amab_k=Amab if cachimbo==1
gen Resp_k=Resp if cachimbo==1
gen estandar_Neuro_k=estandar_Neuro if cachimbo==1
gen estandar_Extrav_k=estandar_Extrav if cachimbo==1
gen estandar_Aperex_k=estandar_Aperex if cachimbo==1
gen estandar_Amab_k=estandar_Amab if cachimbo==1
gen estandar_Resp_k=estandar_Resp if cachimbo==1

collapse (first) acayearterm N SECCION_DEL_CURSO (first)NOMBRE_DEL_CURSO (mean)cachimbo estandar_Neuro estandar_Extrav estandar_Aperex estandar_Amab estandar_Resp estandar_Neuro_k estandar_Extrav_k estandar_Aperex_k estandar_Amab_k estandar_Resp_k, by (salon)
drop if N<10

keep if acayearterm=="`j'-I PER"
bys NOMBRE_DEL_CURSO: egen max_neuro_st_`j'1=max(estandar_Neuro)
bys NOMBRE_DEL_CURSO: egen min_neuro_st_`j'1=min(estandar_Neuro)
gen dummymax_neuro_st_`j'1=0
replace dummymax_neuro_st_`j'1=1 if max_neuro_st_`j'1==estandar_Neuro
gen dummymin_neuro_st_`j'1=0
replace dummymin_neuro_st_`j'1=1 if min_neuro_st_`j'1==estandar_Neuro


bys NOMBRE_DEL_CURSO: egen max_extrav_st_`j'1=max(estandar_Extrav)
bys NOMBRE_DEL_CURSO: egen min_extrav_st_`j'1=min(estandar_Extrav)
gen dummymax_extrav_st_`j'1=0
replace dummymax_extrav_st_`j'1=1 if max_extrav_st_`j'1==estandar_Extrav
gen dummymin_extrav_st_`j'1=0
replace dummymin_extrav_st_`j'1=1 if min_extrav_st_`j'1==estandar_Extrav

bys NOMBRE_DEL_CURSO: egen max_aperex_st_`j'1=max(estandar_Aperex)
bys NOMBRE_DEL_CURSO: egen min_aperex_st_`j'1=min(estandar_Aperex)
gen dummymax_aperex_st_`j'1=0
replace dummymax_aperex_st_`j'1=1 if max_aperex_st_`j'1==estandar_Aperex
gen dummymin_aperex_st_`j'1=0
replace dummymin_aperex_st_`j'1=1 if min_aperex_st_`j'1==estandar_Aperex


bys NOMBRE_DEL_CURSO: egen max_amab_st_`j'1=max(estandar_Amab)
bys NOMBRE_DEL_CURSO: egen min_amab_st_`j'1=min(estandar_Amab)
gen dummymax_amab_st_`j'1=0
replace dummymax_amab_st_`j'1=1 if max_amab_st_`j'1==estandar_Amab
gen dummymin_amab_st_`j'1=0
replace dummymin_amab_st_`j'1=1 if min_amab_st_`j'1==estandar_Amab


bys NOMBRE_DEL_CURSO: egen max_resp_st_`j'1=max(estandar_Resp)
bys NOMBRE_DEL_CURSO: egen min_resp_st_`j'1=min(estandar_Resp)
gen dummymax_resp_st_`j'1=0
replace dummymax_resp_st_`j'1=1 if max_resp_st_`j'1==estandar_Resp
gen dummymin_resp_st_`j'1=0
replace dummymin_resp_st_`j'1=1 if min_resp_st_`j'1==estandar_Resp


****

save "$bases/dummies_st_`j'1", replace
}




foreach j of numlist 2020 2021 2022 2023 { 
clear all
global bases "C:\Users\Erzo\OneDrive - Universidad del Pacífico\Univesidad del Pacífico\Ciclo\lCiclo 7 2024 I\Asistente\Big5\Hasta_2023\Bases"
use "$bases/salones", clear
gen N_K=cachimbo
gen Neuro_k=Neuro if cachimbo==1
gen Extrav_k=Extrav if cachimbo==1
gen Aperex_k=Aperex if cachimbo==1
gen Amab_k=Amab if cachimbo==1
gen Resp_k=Resp if cachimbo==1
gen estandar_Neuro_k=estandar_Neuro if cachimbo==1
gen estandar_Extrav_k=estandar_Extrav if cachimbo==1
gen estandar_Aperex_k=estandar_Aperex if cachimbo==1
gen estandar_Amab_k=estandar_Amab if cachimbo==1
gen estandar_Resp_k=estandar_Resp if cachimbo==1

collapse (first) acayearterm N SECCION_DEL_CURSO (sum) N_K (first)NOMBRE_DEL_CURSO (mean)cachimbo Neuro Extrav Aperex Amab Resp estandar_Neuro estandar_Extrav estandar_Aperex estandar_Amab estandar_Resp Neuro_k Extrav_k Aperex_k Amab_k Resp_k estandar_Neuro_k estandar_Extrav_k estandar_Aperex_k estandar_Amab_k estandar_Resp_k, by (salon)
drop if N<10
drop if N_K<20
keep if acayearterm=="`j'-I PER"
****
bys NOMBRE_DEL_CURSO: egen max_neuro_st_k_`j'1=max(estandar_Neuro_k)
bys NOMBRE_DEL_CURSO: egen min_neuro_st_k_`j'1=min(estandar_Neuro_k)
gen dummymax_neuro_st_k_`j'1=0
replace dummymax_neuro_st_k_`j'1=1 if max_neuro_st_k_`j'1==estandar_Neuro_k
gen dummymin_neuro_st_k_`j'1=0
replace dummymin_neuro_st_k_`j'1=1 if min_neuro_st_k_`j'1==estandar_Neuro_k
****
****
bys NOMBRE_DEL_CURSO: egen max_extrav_st_k_`j'1=max(estandar_Extrav_k)
bys NOMBRE_DEL_CURSO: egen min_extrav_st_k_`j'1=min(estandar_Extrav_k)
gen dummymax_extrav_st_k_`j'1=0
replace dummymax_extrav_st_k_`j'1=1 if max_extrav_st_k_`j'1==estandar_Extrav_k
gen dummymin_extrav_st_k_`j'1=0
replace dummymin_extrav_st_k_`j'1=1 if min_extrav_st_k_`j'1==estandar_Extrav_k
****
****
bys NOMBRE_DEL_CURSO: egen max_aperex_st_k_`j'1=max(estandar_Aperex_k)
bys NOMBRE_DEL_CURSO: egen min_aperex_st_k_`j'1=min(estandar_Aperex_k)
gen dummymax_aperex_st_k_`j'1=0
replace dummymax_aperex_st_k_`j'1=1 if max_aperex_st_k_`j'1==estandar_Aperex_k
gen dummymin_aperex_st_k_`j'1=0
replace dummymin_aperex_st_k_`j'1=1 if min_aperex_st_k_`j'1==estandar_Aperex_k
****
****
bys NOMBRE_DEL_CURSO: egen max_amab_st_k_`j'1=max(estandar_Amab_k)
bys NOMBRE_DEL_CURSO: egen min_amab_st_k_`j'1=min(estandar_Amab_k)
gen dummymax_amab_st_k_`j'1=0
replace dummymax_amab_st_k_`j'1=1 if max_amab_st_k_`j'1==estandar_Amab_k
gen dummymin_amab_st_k_`j'1=0
replace dummymin_amab_st_k_`j'1=1 if min_amab_st_k_`j'1==estandar_Amab_k
****
****
bys NOMBRE_DEL_CURSO: egen max_resp_st_k_`j'1=max(estandar_Resp_k)
bys NOMBRE_DEL_CURSO: egen min_resp_st_k_`j'1=min(estandar_Resp_k)
gen dummymax_resp_st_k_`j'1=0
replace dummymax_resp_st_k_`j'1=1 if max_resp_st_k_`j'1==estandar_Resp_k
gen dummymin_resp_st_k_`j'1=0
replace dummymin_resp_st_k_`j'1=1 if min_resp_st_k_`j'1==estandar_Resp_k

save "$bases/dummies_st_`j'1k", replace
}
************************************************************************************************merge con dummies para ttests
foreach i of numlist 20201 20211 20221 20231 { 
clear all
global bases "C:\Users\Erzo\OneDrive - Universidad del Pacífico\Univesidad del Pacífico\Ciclo\lCiclo 7 2024 I\Asistente\Big5\Hasta_2023\Bases"
use "$bases/salones", clear
merge m:1 salon acayearterm using "$bases/dummies_st_`i'", nogen // keep(3)
merge m:1 salon acayearterm using "$bases/dummies_st_`i'k", nogen // keep(3)
if `i'==20201{
keep if acayear=="2020"
}
if `i'==20211{
keep if acayear=="2021"
}
if `i'==20221{
keep if acayear=="2022"
}
if `i'==20231{
keep if acayear=="2023"
}


encode salon, gen(salon_)
replace dummymax_neuro_st_k_`i'=0 if cachimbo==0
replace dummymin_neuro_st_k_`i'=0 if cachimbo==0
replace dummymax_extrav_st_k_`i'=0 if cachimbo==0
replace dummymin_extrav_st_k_`i'=0 if cachimbo==0
replace dummymax_aperex_st_k_`i'=0 if cachimbo==0
replace dummymin_aperex_st_k_`i'=0 if cachimbo==0
replace dummymax_amab_st_k_`i'=0 if cachimbo==0
replace dummymin_amab_st_k_`i'=0 if cachimbo==0
replace dummymax_resp_st_k_`i'=0 if cachimbo==0
replace dummymin_resp_st_k_`i'=0 if cachimbo==0
/*
keep if dummymax_neuro_`j'1==1| dummymin_neuro_`j'1==1|dummymax_extrav_`j'1==1| dummymin_extrav_`j'1==1| dummymax_aperex_`j'1==1| dummymin_aperex_`j'1==1| dummymax_amab_`j'1==1| dummymin_amab_`j'1==1| dummymax_resp_`j'1==1| dummymin_resp_`j'1==1 | dummymax_neuro_k_`j'1==1| dummymin_neuro_k_`j'1==1|dummymax_extrav_k_`j'1==1| dummymin_extrav_k_`j'1==1| dummymax_aperex_k_`j'1==1| dummymin_aperex_k_`j'1==1| dummymax_amab_k_`j'1==1| dummymin_amab_k_`j'1==1| dummymax_resp_k_`j'1==1| dummymin_resp_k_`j'1==1

*/
***********Dummy eco1 neuro `i'
matrix define eco1`i' = J(2, 10, .)
mean estandar_Neuro if (dummymax_neuro_st_`i'==1|dummymin_neuro_st_`i'==1) & nombre_curso==238 , over(dummymax_neuro_st_`i') coefl
lincom   _b[c.estandar_Neuro@1.dummymax_neuro_st_`i']-_b[c.estandar_Neuro@0.dummymax_neuro_st_`i']
matrix eco1`i'[1,1] =  r(estimate)
matrix eco1`i'[2,1] = r(p)
***********Dummy eco1 extrav `i'
mean estandar_Extrav if (dummymax_extrav_st_`i'==1|dummymin_extrav_st_`i'==1) & nombre_curso==238 , over(dummymax_extrav_st_`i') coefl
lincom   _b[c.estandar_Extrav@1.dummymax_extrav_st_`i']-_b[c.estandar_Extrav@0.dummymax_extrav_st_`i']
matrix eco1`i'[1,2] =  r(estimate)
matrix eco1`i'[2,2] = r(p)
***********Dummy eco1 aperex `i'
mean estandar_Aperex if (dummymax_aperex_st_`i'==1|dummymin_aperex_st_`i'==1) & nombre_curso==238 , over(dummymax_aperex_st_`i') coefl
lincom   _b[c.estandar_Aperex@1.dummymax_aperex_st_`i']-_b[c.estandar_Aperex@0.dummymax_aperex_st_`i']
matrix eco1`i'[1,3] =  r(estimate)
matrix eco1`i'[2,3] = r(p)
***********Dummy eco1 amab `i'
mean estandar_Amab if (dummymax_amab_st_`i'==1|dummymin_amab_st_`i'==1) & nombre_curso==238 , over(dummymax_amab_st_`i') coefl
lincom   _b[c.estandar_Amab@1.dummymax_amab_st_`i']-_b[c.estandar_Amab@0.dummymax_amab_st_`i']
matrix eco1`i'[1,4] =  r(estimate)
matrix eco1`i'[2,4] = r(p)
***********Dummy eco1 resp `i'
mean estandar_Resp if (dummymax_resp_st_`i'==1|dummymin_resp_st_`i'==1) & nombre_curso==238 , over(dummymax_resp_st_`i') coefl
lincom   _b[c.estandar_Resp@1.dummymax_resp_st_`i']-_b[c.estandar_Resp@0.dummymax_resp_st_`i']
matrix eco1`i'[1,5] =  r(estimate)
matrix eco1`i'[2,5] = r(p)

*************************************************_k
***********Dummy eco1 neuro `i'
mean Neuro if (dummymax_neuro_st_k_`i'==1|dummymin_neuro_st_k_`i'==1) & nombre_curso==238 , over(dummymax_neuro_st_k_`i') coefl
lincom   _b[c.Neuro@1.dummymax_neuro_st_k_`i']-_b[c.Neuro@0.dummymax_neuro_st_k_`i']
matrix eco1`i'[1,6] =  r(estimate)
matrix eco1`i'[2,6] = r(p)
***********Dummy eco1 extrav `i'
mean Extrav if (dummymax_extrav_st_k_`i'==1|dummymin_extrav_st_k_`i'==1) & nombre_curso==238 , over(dummymax_extrav_st_k_`i') coefl
lincom   _b[c.Extrav@1.dummymax_extrav_st_k_`i']-_b[c.Extrav@0.dummymax_extrav_st_k_`i']
matrix eco1`i'[1,7] =  r(estimate)
matrix eco1`i'[2,7] = r(p)
***********Dummy eco1 aperex `i'
mean Aperex if (dummymax_aperex_st_k_`i'==1|dummymin_aperex_st_k_`i'==1) & nombre_curso==238 , over(dummymax_aperex_st_k_`i') coefl
lincom   _b[c.Aperex@1.dummymax_aperex_st_k_`i']-_b[c.Aperex@0.dummymax_aperex_st_k_`i']
matrix eco1`i'[1,8] =  r(estimate)
matrix eco1`i'[2,8] = r(p)
***********Dummy eco1 amab `i'
mean Amab if (dummymax_amab_st_k_`i'==1|dummymin_amab_st_k_`i'==1) & nombre_curso==238 , over(dummymax_amab_st_k_`i') coefl
lincom   _b[c.Amab@1.dummymax_amab_st_k_`i']-_b[c.Amab@0.dummymax_amab_st_k_`i']
matrix eco1`i'[1,9] =  r(estimate)
matrix eco1`i'[2,9] = r(p)
***********Dummy eco1 resp `i'
mean Resp if (dummymax_resp_st_k_`i'==1|dummymin_resp_st_k_`i'==1) & nombre_curso==238 , over(dummymax_resp_st_k_`i') coefl
lincom   _b[c.Resp@1.dummymax_resp_st_k_`i']-_b[c.Resp@0.dummymax_resp_st_k_`i']
matrix eco1`i'[1,10] =  r(estimate)
matrix eco1`i'[2,10] = r(p)
*************************************************
tab SECCION_DEL_CURSO if nombre_curso==238 
local a=r(r)+2
putexcel set  "C:\Users\Erzo\OneDrive - Universidad del Pacífico\Univesidad del Pacífico\Ciclo\lCiclo 7 2024 I\Asistente\Big5\Peer effects classrooms\Tablas\standard\standardeco1`i'", modify
putexcel E`a'=matrix(eco1`i')

di `a'
***********Dummy nivelengua neuro `i'
matrix define nivelengua`i' = J(2, 10, .)
mean Neuro if (dummymax_neuro_st_`i'==1|dummymin_neuro_st_`i'==1) & nombre_curso==617 , over(dummymax_neuro_st_`i') coefl
lincom   _b[c.Neuro@1.dummymax_neuro_st_`i']-_b[c.Neuro@0.dummymax_neuro_st_`i']
matrix nivelengua`i'[1,1] =  r(estimate)
matrix nivelengua`i'[2,1] = r(p)
***********Dummy nivelengua extrav `i'
mean Extrav if (dummymax_extrav_st_`i'==1|dummymin_extrav_st_`i'==1) & nombre_curso==617 , over(dummymax_extrav_st_`i') coefl
lincom   _b[c.Extrav@1.dummymax_extrav_st_`i']-_b[c.Extrav@0.dummymax_extrav_st_`i']
matrix nivelengua`i'[1,2] =  r(estimate)
matrix nivelengua`i'[2,2] = r(p)
***********Dummy nivelengua aperex `i'
mean Aperex if (dummymax_aperex_st_`i'==1|dummymin_aperex_st_`i'==1) & nombre_curso==617 , over(dummymax_aperex_st_`i') coefl
lincom   _b[c.Aperex@1.dummymax_aperex_st_`i']-_b[c.Aperex@0.dummymax_aperex_st_`i']
matrix nivelengua`i'[1,3] =  r(estimate)
matrix nivelengua`i'[2,3] = r(p)
***********Dummy nivelengua amab `i'
mean Amab if (dummymax_amab_st_`i'==1|dummymin_amab_st_`i'==1) & nombre_curso==617 , over(dummymax_amab_st_`i') coefl
lincom   _b[c.Amab@1.dummymax_amab_st_`i']-_b[c.Amab@0.dummymax_amab_st_`i']
matrix nivelengua`i'[1,4] =  r(estimate)
matrix nivelengua`i'[2,4] = r(p)
***********Dummy nivelengua resp `i'
mean Resp if (dummymax_resp_st_`i'==1|dummymin_resp_st_`i'==1) & nombre_curso==617 , over(dummymax_resp_st_`i') coefl
lincom   _b[c.Resp@1.dummymax_resp_st_`i']-_b[c.Resp@0.dummymax_resp_st_`i']
matrix nivelengua`i'[1,5] =  r(estimate)
matrix nivelengua`i'[2,5] = r(p)
*************************************************_k
***********Dummy nivelengua neuro `i'
mean estandar_Neuro if (dummymax_neuro_st_k_`i'==1|dummymin_neuro_st_k_`i'==1) & nombre_curso==617 , over(dummymax_neuro_st_k_`i') coefl
lincom   _b[c.estandar_Neuro@1.dummymax_neuro_st_k_`i']-_b[c.estandar_Neuro@0.dummymax_neuro_st_k_`i']
matrix nivelengua`i'[1,6] =  r(estimate)
matrix nivelengua`i'[2,6] = r(p)
***********Dummy nivelengua extrav `i'
mean estandar_Extrav if (dummymax_extrav_st_k_`i'==1|dummymin_extrav_st_k_`i'==1) & nombre_curso==617 , over(dummymax_extrav_st_k_`i') coefl
lincom   _b[c.estandar_Extrav@1.dummymax_extrav_st_k_`i']-_b[c.estandar_Extrav@0.dummymax_extrav_st_k_`i']
matrix nivelengua`i'[1,7] =  r(estimate)
matrix nivelengua`i'[2,7] = r(p)
***********Dummy nivelengua aperex `i'
mean estandar_Aperex if (dummymax_aperex_st_k_`i'==1|dummymin_aperex_st_k_`i'==1) & nombre_curso==617 , over(dummymax_aperex_st_k_`i') coefl
lincom   _b[c.estandar_Aperex@1.dummymax_aperex_st_k_`i']-_b[c.estandar_Aperex@0.dummymax_aperex_st_k_`i']
matrix nivelengua`i'[1,8] =  r(estimate)
matrix nivelengua`i'[2,8] = r(p)
***********Dummy nivelengua amab `i'
mean estandar_Amab if (dummymax_amab_st_k_`i'==1|dummymin_amab_st_k_`i'==1) & nombre_curso==617 , over(dummymax_amab_st_k_`i') coefl
lincom   _b[c.estandar_Amab@1.dummymax_amab_st_k_`i']-_b[c.estandar_Amab@0.dummymax_amab_st_k_`i']
matrix nivelengua`i'[1,9] =  r(estimate)
matrix nivelengua`i'[2,9] = r(p)
***********Dummy nivelengua resp `i'
mean estandar_Resp if (dummymax_resp_st_k_`i'==1|dummymin_resp_st_k_`i'==1) & nombre_curso==617 , over(dummymax_resp_st_k_`i') coefl
lincom   _b[c.estandar_Resp@1.dummymax_resp_st_k_`i']-_b[c.estandar_Resp@0.dummymax_resp_st_k_`i']
matrix nivelengua`i'[1,10] =  r(estimate)
matrix nivelengua`i'[2,10] = r(p)

tab SECCION_DEL_CURSO if nombre_curso==617
local a=r(r)+2
putexcel set  "C:\Users\Erzo\OneDrive - Universidad del Pacífico\Univesidad del Pacífico\Ciclo\lCiclo 7 2024 I\Asistente\Big5\Peer effects classrooms\Tablas\standard\standardnivelengua`i'", modify
putexcel E`a'=matrix(nivelengua`i')
*************************************************



***********Dummy nivemate neuro `i'
matrix define nivemate`i' = J(2, 10, .)
mean estandar_Neuro if (dummymax_neuro_st_`i'==1|dummymin_neuro_st_`i'==1) & nombre_curso==618 , over(dummymax_neuro_st_`i') coefl
lincom   _b[c.estandar_Neuro@1.dummymax_neuro_st_`i']-_b[c.estandar_Neuro@0.dummymax_neuro_st_`i']
matrix nivemate`i'[1,1] =  r(estimate)
matrix nivemate`i'[2,1] = r(p)
***********Dummy nivemate extrav `i'
mean estandar_Extrav if (dummymax_extrav_st_`i'==1|dummymin_extrav_st_`i'==1) & nombre_curso==618 , over(dummymax_extrav_st_`i') coefl
lincom   _b[c.estandar_Extrav@1.dummymax_extrav_st_`i']-_b[c.estandar_Extrav@0.dummymax_extrav_st_`i']
matrix nivemate`i'[1,2] =  r(estimate)
matrix nivemate`i'[2,2] = r(p)
***********Dummy nivemate aperex `i'
mean estandar_Aperex if (dummymax_aperex_st_`i'==1|dummymin_aperex_st_`i'==1) & nombre_curso==618 , over(dummymax_aperex_st_`i') coefl
lincom   _b[c.estandar_Aperex@1.dummymax_aperex_st_`i']-_b[c.estandar_Aperex@0.dummymax_aperex_st_`i']
matrix nivemate`i'[1,3] =  r(estimate)
matrix nivemate`i'[2,3] = r(p)
***********Dummy nivemate amab `i'
mean estandar_Amab if (dummymax_amab_st_`i'==1|dummymin_amab_st_`i'==1) & nombre_curso==618 , over(dummymax_amab_st_`i') coefl
lincom   _b[c.estandar_Amab@1.dummymax_amab_st_`i']-_b[c.estandar_Amab@0.dummymax_amab_st_`i']
matrix nivemate`i'[1,4] =  r(estimate)
matrix nivemate`i'[2,4] = r(p)
***********Dummy nivemate resp `i'
mean estandar_Resp if (dummymax_resp_st_`i'==1|dummymin_resp_st_`i'==1) & nombre_curso==618 , over(dummymax_resp_st_`i') coefl
lincom   _b[c.estandar_Resp@1.dummymax_resp_st_`i']-_b[c.estandar_Resp@0.dummymax_resp_st_`i']
matrix nivemate`i'[1,5] =  r(estimate)
matrix nivemate`i'[2,5] = r(p)

*************************************************_k
***********Dummy nivemate neuro `i'
mean estandar_Neuro if (dummymax_neuro_st_k_`i'==1|dummymin_neuro_st_k_`i'==1) & nombre_curso==618 , over(dummymax_neuro_st_k_`i') coefl
lincom   _b[c.estandar_Neuro@1.dummymax_neuro_st_k_`i']-_b[c.estandar_Neuro@0.dummymax_neuro_st_k_`i']
matrix nivemate`i'[1,6] =  r(estimate)
matrix nivemate`i'[2,6] = r(p)
***********Dummy nivemate extrav `i'
mean estandar_Extrav if (dummymax_extrav_st_k_`i'==1|dummymin_extrav_st_k_`i'==1) & nombre_curso==618 , over(dummymax_extrav_st_k_`i') coefl
lincom   _b[c.estandar_Extrav@1.dummymax_extrav_st_k_`i']-_b[c.estandar_Extrav@0.dummymax_extrav_st_k_`i']
matrix nivemate`i'[1,7] =  r(estimate)
matrix nivemate`i'[2,7] = r(p)
***********Dummy nivemate aperex `i'
mean estandar_Aperex if (dummymax_aperex_st_k_`i'==1|dummymin_aperex_st_k_`i'==1) & nombre_curso==618 , over(dummymax_aperex_st_k_`i') coefl
lincom   _b[c.estandar_Aperex@1.dummymax_aperex_st_k_`i']-_b[c.estandar_Aperex@0.dummymax_aperex_st_k_`i']
matrix nivemate`i'[1,8] =  r(estimate)
matrix nivemate`i'[2,8] = r(p)
***********Dummy nivemate amab `i'
mean estandar_Amab if (dummymax_amab_st_k_`i'==1|dummymin_amab_st_k_`i'==1) & nombre_curso==618 , over(dummymax_amab_st_k_`i') coefl
lincom   _b[c.estandar_Amab@1.dummymax_amab_st_k_`i']-_b[c.estandar_Amab@0.dummymax_amab_st_k_`i']
matrix nivemate`i'[1,9] =  r(estimate)
matrix nivemate`i'[2,9] = r(p)
***********Dummy nivemate resp `i'
mean estandar_Resp if (dummymax_resp_st_k_`i'==1|dummymin_resp_st_k_`i'==1) & nombre_curso==618 , over(dummymax_resp_st_k_`i') coefl
lincom   _b[c.estandar_Resp@1.dummymax_resp_st_k_`i']-_b[c.estandar_Resp@0.dummymax_resp_st_k_`i']
matrix nivemate`i'[1,10] =  r(estimate)
matrix nivemate`i'[2,10] = r(p)
*************************************************
tab SECCION_DEL_CURSO if nombre_curso==618 
local a=r(r)+2
di `a'
putexcel set  "C:\Users\Erzo\OneDrive - Universidad del Pacífico\Univesidad del Pacífico\Ciclo\lCiclo 7 2024 I\Asistente\Big5\Peer effects classrooms\Tablas\standard\standardnivemate`i'", modify
putexcel E`a'=matrix(nivemate`i')

}


