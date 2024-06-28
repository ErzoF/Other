/*
clear all
global bases "C:\Users\Erzo\OneDrive - Universidad del Pacífico\Univesidad del Pacífico\Ciclo\lCiclo 7 2024 I\Asistente\Big5\Hasta_2023\Bases"
use "$bases/baseregresion", clear
decode acayearterm1, gen (acayearterm) 
save "$bases/baseregresion", replace
*/


clear all
local cursos 238 617 618 
local semestres 1 3 5 7 9
foreach semestre of local semestres {
foreach curso of local cursos {
clear all
set more off
global bases "C:\Users\Erzo\OneDrive - Universidad del Pacífico\Univesidad del Pacífico\Ciclo\lCiclo 7 2024 I\Asistente\Big5\Hasta_2023\Bases"
use "$bases/base18_23", clear

rename CODIGO_DEL_ALUMNO cod
rename ACADEMIC_YEAR acayear
rename ACADEMIC_TERM acaterm
rename N_NEUROTICISMO neuro
rename E_EXTROVERSIÓN extrav
rename O_APERTURA aperexpe
rename A_AMABILIDAD amab
rename C_RESONSABILIDAD resp
sort cod acayear acaterm neuro extrav aperexpe amab resp

/*
local variables neuro N1_ANSIEDAD N2_HOSTILIDAD N3_DEPRESIÓN N4_ANSIEDAD_SOCIAL N5_IMPULSIVIDAD N6_VULNERABILIDAD extrav E1_CORDIALIDAD E2_GREGARISMO E3_ASERTIVIDAD E4_ACTIVIDAD E5_BÚSQUEDA_DE_EMOCIONES E6_EMOCIONES_POSITIVAS aperexpe O1_FANTASÍA O2_ESTÉTICA O3_SENTIMIENTOS O4_ACCIONES O5_IDEAS O6_VALORES amab A1_CONFIANZA A2_FRANQUEZA A3_ALTRUISMO A4_ACTITUD_CONCILIADORA A5_MODESTIA A6_SENSIBILIDAD_A_LOS_DEMÁS resp C1_COMPETENCIA C2_ORDEN C3_SENTIDO_DEL_DEBER C4_NECESIDAD_DE_LOGRO C5_AUTODISCIPLINA C6_DELIBERACIÓN
*/
local variables neuro extrav aperexpe amab resp
foreach var of local variables {
    destring `var' , gen(`var'0)
	drop `var'
	rename `var'0 `var'
	}

************************************************************
bys cod : egen Neuro =mean(neuro)
bys cod : egen Extrav= mean(extrav)
bys cod : egen Aperex =mean(aperexpe)
bys cod : egen Amab =mean(amab)
bys cod : egen Resp =mean(resp)
/*
***SUBCOMP DE NEURO
bys cod : egen Ansiedad =mean(N1_ANSIEDAD)
bys cod : egen Hostilid= mean(N2_HOSTILIDAD)
bys cod : egen Depresion =mean(N3_DEPRESIÓN)
bys cod : egen Ansiedad_S =mean(N4_ANSIEDAD_SOCIAL)
bys cod : egen Impulsiv =mean(N5_IMPULSIVIDAD)
bys cod : egen Vulnerab =mean(N6_VULNERABILIDAD)
***SUBCOMP DE Extrav
bys cod : egen Cordial =mean(E1_CORDIALIDAD)
bys cod : egen Gregar= mean(E2_GREGARISMO)
bys cod : egen Asert =mean(E3_ASERTIVIDAD)
bys cod : egen Activ =mean(E4_ACTIVIDAD)
bys cod : egen B_emoci =mean(E5_BÚSQUEDA_DE_EMOCIONES)
bys cod : egen Emo_posi =mean(E6_EMOCIONES_POSITIVAS)
***SUBCOMP DE Aperex
bys cod : egen Fanta =mean(O1_FANTASÍA)
bys cod : egen Estet= mean(O2_ESTÉTICA)
bys cod : egen Sentim =mean(O3_SENTIMIENTOS)
bys cod : egen Accion =mean(O4_ACCIONES)
bys cod : egen Ideas =mean(O5_IDEAS)
bys cod : egen Valores =mean(O6_VALORES)
***SUBCOMP DE Amab
bys cod : egen Confi =mean(A1_CONFIANZA)
bys cod : egen Franq= mean(A2_FRANQUEZA)
bys cod : egen Altru =mean(A3_ALTRUISMO)
bys cod : egen A_concil =mean(A4_ACTITUD_CONCILIADORA)
bys cod : egen Modest =mean(A5_MODESTIA)
bys cod : egen Sensi_D =mean(A6_SENSIBILIDAD_A_LOS_DEMÁS)
***SUBCOMP DE Resp
bys cod : egen Compet =mean(C1_COMPETENCIA)
bys cod : egen Orden= mean(C2_ORDEN)
bys cod : egen S_Deber =mean(C3_SENTIDO_DEL_DEBER)
bys cod : egen N_Logro =mean(C4_NECESIDAD_DE_LOGRO)
bys cod : egen Autodis =mean(C5_AUTODISCIPLINA)
bys cod : egen Delibera =mean(C6_DELIBERACIÓN)
*/

egen acayearterm=concat(acayear acaterm), decode punct("-")
encode acayearterm, gen(acayearterm1)

merge m:1 cod acayearterm using "$bases/baseregresion", nogen keep(3) 

drop acayearterm1
encode acayearterm, gen(acayearterm_)

encode NOMBRE_DEL_CURSO, gen(nombre_curso)


keep if acayearterm_==`semestre' & nombre_curso== `curso'
sort DOCENTE_DEL_CURSO SECCION_DEL_CURSO

gen cachimbo=0

replace cachimbo=1 if PRIMER_SEMESTRE_EN_QUE_CURSO_EST==acayearterm
drop if SECCION_DEL_CURSO=="REC" |SECCION_DEL_CURSO=="rec"
gen salon=DOCENTE_DEL_CURSO+SECCION_DEL_CURSO+acayearterm
sort salon
bys salon: gen N=_N

cd "C:\Users\Erzo\OneDrive - Universidad del Pacífico\Univesidad del Pacífico\Ciclo\lCiclo 7 2024 I\Asistente\Big5\Peer effects classrooms\Listo"
tabstat N cachimbo Neuro Extrav Aperex Amab Resp, stat(mean) by(salon) columns(statistics)

estpost tabstat N cachimbo Neuro Extrav Aperex Amab Resp, stat(mean) by(salon) columns(statistics)
local mi_variable = 0
if `curso' ==238  local mi_variable ="Eco1"
if `curso' ==617 local mi_variable ="Nivelengua"
if `curso' ==618 local mi_variable ="Nivemate"

local mi_var = 0
if `semestre' ==1 local mi_var ="2019I"
if `semestre' ==3 local mi_var ="2020I"
if `semestre' ==5 local mi_var ="2021I"
if `semestre' ==7 local mi_var ="2022I"
if `semestre' ==9 local mi_var ="2023I"
esttab . using `mi_variable'`mi_var'.rtf, cells("mean(fmt(a3))") label
}
}












********************************************************************************************************************************

clear all
set more off
global bases "C:\Users\Erzo\OneDrive - Universidad del Pacífico\Univesidad del Pacífico\Ciclo\lCiclo 7 2024 I\Asistente\Big5\Hasta_2023\Bases"
use "$bases/base18_23", clear

rename CODIGO_DEL_ALUMNO cod
rename ACADEMIC_YEAR acayear
rename ACADEMIC_TERM acaterm
rename N_NEUROTICISMO neuro
rename E_EXTROVERSIÓN extrav
rename O_APERTURA aperexpe
rename A_AMABILIDAD amab
rename C_RESONSABILIDAD resp
sort cod acayear acaterm neuro extrav aperexpe amab resp

local variables neuro extrav aperexpe amab resp
foreach var of local variables {
    destring `var' , gen(`var'0)
	drop `var'
	rename `var'0 `var'
	}

************************************************************
bys cod : egen Neuro =mean(neuro)
bys cod : egen Extrav= mean(extrav)
bys cod : egen Aperex =mean(aperexpe)
bys cod : egen Amab =mean(amab)
bys cod : egen Resp =mean(resp)

egen acayearterm=concat(acayear acaterm), decode punct("-")
encode acayearterm, gen(acayearterm1)

merge m:1 cod acayearterm using "$bases/baseregresion", nogen keep(3) 

drop acayearterm1
encode acayearterm, gen(acayearterm_)

encode NOMBRE_DEL_CURSO, gen(nombre_curso)

sort DOCENTE_DEL_CURSO SECCION_DEL_CURSO

gen cachimbo=0

replace cachimbo=1 if PRIMER_SEMESTRE_EN_QUE_CURSO_EST==acayearterm
drop if SECCION_DEL_CURSO=="REC" |SECCION_DEL_CURSO=="rec"
gen salon=DOCENTE_DEL_CURSO+SECCION_DEL_CURSO+acayearterm
sort salon
bys salon: gen N=_N



keep if acayearterm_==1|acayearterm_== 3 |acayearterm_== 5|acayearterm_== 7|acayearterm_== 9
keep if nombre_curso== 238 |nombre_curso== 617|nombre_curso== 618

sort DOCENTE_DEL_CURSO SECCION_DEL_CURSO

save "$bases/salones", replace
collapse (first) acayearterm N (first)NOMBRE_DEL_CURSO (mean)cachimbo Neuro Extrav Aperex Amab Resp estandar_Neuro estandar_Extrav estandar_Aperex estandar_Amab estandar_Resp, by (salon)


cd "C:\Users\Erzo\OneDrive - Universidad del Pacífico\Univesidad del Pacífico\Ciclo\lCiclo 7 2024 I\Asistente\Big5\Peer effects classrooms\raw"
tabstat cachimbo N Neuro Extrav Aperex Amab Resp if acayearterm=="2019-I PER", stat(var cv sd) by(NOMBRE_DEL_CURS) columns(statistics)

estpost tabstat cachimbo N Neuro Extrav Aperex Amab Resp if acayearterm=="2019-I PER", stat(variance cv sd) by(NOMBRE_DEL_CURSO) columns(statistics)

esttab . using 2019Iraw.rtf, cells("variance cv sd (fmt(a3))") label


estpost tabstat cachimbo N Neuro Extrav Aperex Amab Resp if acayearterm=="2020-I PER", stat(variance cv sd) by(NOMBRE_DEL_CURSO) columns(statistics)

esttab . using 2020Iraw.rtf, cells("variance cv sd (fmt(a3))") label


estpost tabstat cachimbo N Neuro Extrav Aperex Amab Resp if acayearterm=="2021-I PER", stat(variance cv sd) by(NOMBRE_DEL_CURSO) columns(statistics)

esttab . using 2021Iraw.rtf, cells("variance cv sd (fmt(a3))") label


estpost tabstat cachimbo N Neuro Extrav Aperex Amab Resp if acayearterm=="2022-I PER", stat(variance cv sd) by(NOMBRE_DEL_CURSO) columns(statistics)

esttab . using 2022Iraw.rtf, cells("variance cv sd (fmt(a3))") label

estpost tabstat cachimbo N Neuro Extrav Aperex Amab Resp if acayearterm=="2023-I PER", stat(variance cv sd) by(NOMBRE_DEL_CURSO) columns(statistics) 

esttab . using 2023Iraw.rtf, cells("variance cv sd (fmt(a3))") label



cd "C:\Users\Erzo\OneDrive - Universidad del Pacífico\Univesidad del Pacífico\Ciclo\lCiclo 7 2024 I\Asistente\Big5\Peer effects classrooms\standar"

estpost tabstat cachimbo N estandar_Neuro estandar_Extrav estandar_Aperex estandar_Amab estandar_Resp if acayearterm=="2019-I PER", stat(variance cv sd) by(NOMBRE_DEL_CURSO) columns(statistics)

esttab . using 2019Istandar.rtf, cells("variance cv sd (fmt(a3))") label


estpost tabstat cachimbo N estandar_Neuro estandar_Extrav estandar_Aperex estandar_Amab estandar_Resp if acayearterm=="2020-I PER", stat(variance cv sd) by(NOMBRE_DEL_CURSO) columns(statistics)

esttab . using 2020Istandar.rtf, cells("variance cv sd (fmt(a3))") label


estpost tabstat cachimbo N estandar_Neuro estandar_Extrav estandar_Aperex estandar_Amab estandar_Resp if acayearterm=="2021-I PER", stat(variance cv sd) by(NOMBRE_DEL_CURSO) columns(statistics)

esttab . using 2021Istandar.rtf, cells("variance cv sd (fmt(a3))") label


estpost tabstat cachimbo N estandar_Neuro estandar_Extrav estandar_Aperex estandar_Amab estandar_Resp if acayearterm=="2022-I PER", stat(variance cv sd) by(NOMBRE_DEL_CURSO) columns(statistics)

esttab . using 2022Istandar.rtf, cells("variance cv sd (fmt(a3))") label

estpost tabstat cachimbo N estandar_Neuro estandar_Extrav estandar_Aperex estandar_Amab estandar_Resp if acayearterm=="2023-I PER", stat(variance cv sd) by(NOMBRE_DEL_CURSO) columns(statistics)

esttab . using 2023Istandar.rtf, cells("variance cv sd (fmt(a3))") label


************************************************************************************************DUMMIES_raw_standar_20231 
*como ya filtro el raw, los salones con la variable estandarizada se mantendrán como max o como min
foreach j of numlist 2020 2021 2022 2023 { 
clear all
global bases "C:\Users\Erzo\OneDrive - Universidad del Pacífico\Univesidad del Pacífico\Ciclo\lCiclo 7 2024 I\Asistente\Big5\Hasta_2023\Bases"
use "$bases/salones", clear
collapse (first) acayearterm N (first)NOMBRE_DEL_CURSO (mean)cachimbo Neuro Extrav Aperex Amab Resp estandar_Neuro estandar_Extrav estandar_Aperex estandar_Amab estandar_Resp, by (salon)

keep if acayearterm=="`j'-I PER"
bys NOMBRE_DEL_CURSO: egen max_neuro_`j'1=max(Neuro)
bys NOMBRE_DEL_CURSO: egen min_neuro_`j'1=min(Neuro)
gen dummymax_neuro_`j'1=0
replace dummymax_neuro_`j'1=1 if max_neuro_`j'1==Neuro
gen dummymin_neuro_`j'1=0
replace dummymin_neuro_`j'1=1 if min_neuro_`j'1==Neuro

bys NOMBRE_DEL_CURSO: egen max_extrav_`j'1=max(Extrav)
bys NOMBRE_DEL_CURSO: egen min_extrav_`j'1=min(Extrav)
gen dummymax_extrav_`j'1=0
replace dummymax_extrav_`j'1=1 if max_extrav_`j'1==Extrav
gen dummymin_extrav_`j'1=0
replace dummymin_extrav_`j'1=1 if min_extrav_`j'1==Extrav

bys NOMBRE_DEL_CURSO: egen max_aperex_`j'1=max(Aperex)
bys NOMBRE_DEL_CURSO: egen min_aperex_`j'1=min(Aperex)
gen dummymax_aperex_`j'1=0
replace dummymax_aperex_`j'1=1 if max_aperex_`j'1==Aperex
gen dummymin_aperex_`j'1=0
replace dummymin_aperex_`j'1=1 if min_aperex_`j'1==Aperex

bys NOMBRE_DEL_CURSO: egen max_amab_`j'1=max(Amab)
bys NOMBRE_DEL_CURSO: egen min_amab_`j'1=min(Amab)
gen dummymax_amab_`j'1=0
replace dummymax_amab_`j'1=1 if max_amab_`j'1==Amab
gen dummymin_amab_`j'1=0
replace dummymin_amab_`j'1=1 if min_amab_`j'1==Amab

bys NOMBRE_DEL_CURSO: egen max_resp_`j'1=max(Resp)
bys NOMBRE_DEL_CURSO: egen min_resp_`j'1=min(Resp)
gen dummymax_resp_`j'1=0
replace dummymax_resp_`j'1=1 if max_resp_`j'1==Resp
gen dummymin_resp_`j'1=0
replace dummymin_resp_`j'1=1 if min_resp_`j'1==Resp

keep if dummymax_neuro_`j'1==1| dummymin_neuro_`j'1==1|dummymax_extrav_`j'1==1| dummymin_extrav_`j'1==1| dummymax_aperex_`j'1==1| dummymin_aperex_`j'1==1| dummymax_amab_`j'1==1| dummymin_amab_`j'1==1| dummymax_resp_`j'1==1| dummymin_resp_`j'1==1
save "$bases/dummies_`j'1", replace
}

************************************************************************************************merge con dummies para ttests
foreach i of numlist 20201 20211 20221 20231 { 
clear all
global bases "C:\Users\Erzo\OneDrive - Universidad del Pacífico\Univesidad del Pacífico\Ciclo\lCiclo 7 2024 I\Asistente\Big5\Hasta_2023\Bases"
use "$bases/salones", clear
merge m:1 salon acayearterm using "$bases/dummies_`i'", nogen keep(3)

encode salon, gen(salon_)

***********Dummy eco1 neuro `i'
matrix define eco1`i' = J(5, 2, .)
mean Neuro if (dummymax_neuro_`i'==1|dummymin_neuro_`i'==1) & nombre_curso==238 , over(dummymax_neuro_`i') coefl
lincom   _b[c.Neuro@1.dummymax_neuro_`i']-_b[c.Neuro@0.dummymax_neuro_`i']
matrix eco1`i'[1,1] =  r(estimate)
matrix eco1`i'[1,2] = r(p)
***********Dummy eco1 extrav `i'
mean Extrav if (dummymax_extrav_`i'==1|dummymin_extrav_`i'==1) & nombre_curso==238 , over(dummymax_extrav_`i') coefl
lincom   _b[c.Extrav@1.dummymax_extrav_`i']-_b[c.Extrav@0.dummymax_extrav_`i']
matrix eco1`i'[2,1] =  r(estimate)
matrix eco1`i'[2,2] = r(p)
***********Dummy eco1 aperex `i'
mean Aperex if (dummymax_aperex_`i'==1|dummymin_aperex_`i'==1) & nombre_curso==238 , over(dummymax_aperex_`i') coefl
lincom   _b[c.Aperex@1.dummymax_aperex_`i']-_b[c.Aperex@0.dummymax_aperex_`i']
matrix eco1`i'[3,1] =  r(estimate)
matrix eco1`i'[3,2] = r(p)
***********Dummy eco1 amab `i'
mean Amab if (dummymax_amab_`i'==1|dummymin_amab_`i'==1) & nombre_curso==238 , over(dummymax_amab_`i') coefl
lincom   _b[c.Amab@1.dummymax_amab_`i']-_b[c.Amab@0.dummymax_amab_`i']
matrix eco1`i'[4,1] =  r(estimate)
matrix eco1`i'[4,2] = r(p)
***********Dummy eco1 resp `i'
mean Resp if (dummymax_resp_`i'==1|dummymin_resp_`i'==1) & nombre_curso==238 , over(dummymax_resp_`i') coefl
lincom   _b[c.Resp@1.dummymax_resp_`i']-_b[c.Resp@0.dummymax_resp_`i']
matrix eco1`i'[5,1] =  r(estimate)
matrix eco1`i'[5,2] = r(p)


putexcel set  "C:\Users\Erzo\OneDrive - Universidad del Pacífico\Univesidad del Pacífico\Ciclo\lCiclo 7 2024 I\Asistente\Big5\Peer effects classrooms\ttest\ttests`i'",sheet("eco1`i'") modify
putexcel B2=matrix(eco1`i')


***********Dummy nivelengua neuro `i'
matrix define nivelengua`i' = J(5, 2, .)
mean Neuro if (dummymax_neuro_`i'==1|dummymin_neuro_`i'==1) & nombre_curso==617 , over(dummymax_neuro_`i') coefl
lincom   _b[c.Neuro@1.dummymax_neuro_`i']-_b[c.Neuro@0.dummymax_neuro_`i']
matrix nivelengua`i'[1,1] =  r(estimate)
matrix nivelengua`i'[1,2] = r(p)
***********Dummy nivelengua extrav `i'
mean Extrav if (dummymax_extrav_`i'==1|dummymin_extrav_`i'==1) & nombre_curso==617 , over(dummymax_extrav_`i') coefl
lincom   _b[c.Extrav@1.dummymax_extrav_`i']-_b[c.Extrav@0.dummymax_extrav_`i']
matrix nivelengua`i'[2,1] =  r(estimate)
matrix nivelengua`i'[2,2] = r(p)
***********Dummy nivelengua aperex `i'
mean Aperex if (dummymax_aperex_`i'==1|dummymin_aperex_`i'==1) & nombre_curso==617 , over(dummymax_aperex_`i') coefl
lincom   _b[c.Aperex@1.dummymax_aperex_`i']-_b[c.Aperex@0.dummymax_aperex_`i']
matrix nivelengua`i'[3,1] =  r(estimate)
matrix nivelengua`i'[3,2] = r(p)
***********Dummy nivelengua amab `i'
mean Amab if (dummymax_amab_`i'==1|dummymin_amab_`i'==1) & nombre_curso==617 , over(dummymax_amab_`i') coefl
lincom   _b[c.Amab@1.dummymax_amab_`i']-_b[c.Amab@0.dummymax_amab_`i']
matrix nivelengua`i'[4,1] =  r(estimate)
matrix nivelengua`i'[4,2] = r(p)
***********Dummy nivelengua resp `i'
mean Resp if (dummymax_resp_`i'==1|dummymin_resp_`i'==1) & nombre_curso==617 , over(dummymax_resp_`i') coefl
lincom   _b[c.Resp@1.dummymax_resp_`i']-_b[c.Resp@0.dummymax_resp_`i']
matrix nivelengua`i'[5,1] =  r(estimate)
matrix nivelengua`i'[5,2] = r(p)
putexcel set  "C:\Users\Erzo\OneDrive - Universidad del Pacífico\Univesidad del Pacífico\Ciclo\lCiclo 7 2024 I\Asistente\Big5\Peer effects classrooms\ttest\ttests`i'",sheet("nivelengua`i'") modify
putexcel B2=matrix(nivelengua`i')



***********Dummy nivemate neuro `i'
matrix define nivemate`i' = J(5, 2, .)
mean Neuro if (dummymax_neuro_`i'==1|dummymin_neuro_`i'==1) & nombre_curso==618 , over(dummymax_neuro_`i') coefl
lincom   _b[c.Neuro@1.dummymax_neuro_`i']-_b[c.Neuro@0.dummymax_neuro_`i']
matrix nivemate`i'[1,1] =  r(estimate)
matrix nivemate`i'[1,2] = r(p)
***********Dummy nivemate extrav `i'
mean Extrav if (dummymax_extrav_`i'==1|dummymin_extrav_`i'==1) & nombre_curso==618 , over(dummymax_extrav_`i') coefl
lincom   _b[c.Extrav@1.dummymax_extrav_`i']-_b[c.Extrav@0.dummymax_extrav_`i']
matrix nivemate`i'[2,1] =  r(estimate)
matrix nivemate`i'[2,2] = r(p)
***********Dummy nivemate aperex `i'
mean Aperex if (dummymax_aperex_`i'==1|dummymin_aperex_`i'==1) & nombre_curso==618 , over(dummymax_aperex_`i') coefl
lincom   _b[c.Aperex@1.dummymax_aperex_`i']-_b[c.Aperex@0.dummymax_aperex_`i']
matrix nivemate`i'[3,1] =  r(estimate)
matrix nivemate`i'[3,2] = r(p)
***********Dummy nivemate amab `i'
mean Amab if (dummymax_amab_`i'==1|dummymin_amab_`i'==1) & nombre_curso==618 , over(dummymax_amab_`i') coefl
lincom   _b[c.Amab@1.dummymax_amab_`i']-_b[c.Amab@0.dummymax_amab_`i']
matrix nivemate`i'[4,1] =  r(estimate)
matrix nivemate`i'[4,2] = r(p)
***********Dummy nivemate resp `i'
mean Resp if (dummymax_resp_`i'==1|dummymin_resp_`i'==1) & nombre_curso==618 , over(dummymax_resp_`i') coefl
lincom   _b[c.Resp@1.dummymax_resp_`i']-_b[c.Resp@0.dummymax_resp_`i']
matrix nivemate`i'[5,1] =  r(estimate)
matrix nivemate`i'[5,2] = r(p)


putexcel set  "C:\Users\Erzo\OneDrive - Universidad del Pacífico\Univesidad del Pacífico\Ciclo\lCiclo 7 2024 I\Asistente\Big5\Peer effects classrooms\ttest\ttests`i'",sheet("nivemate`i'") modify
putexcel B2=matrix(nivemate`i')


}

