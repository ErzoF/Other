********************************************************************************
*																			   *
*				Personalidad y desempeño        				               *
*																			   *
********************************************************************************

*** Created: 			19/04/24
*** Last edited: 		19/15/24
*** Authors: 			Erzo Garay
*** Stata 18.0

********************************************************************************
clear all
set more off
global bases "C:\Users\Erzo\OneDrive - Universidad del Pacífico\Univesidad del Pacífico\Ciclo\lCiclo 7 2024 I\Asistente\Big5\Hasta_2023\Bases"
global outputs "C:\Users\Erzo\OneDrive - Universidad del Pacífico\Univesidad del Pacífico\Ciclo\lCiclo 7 2024 I\Asistente\Big5\Hasta_2023\Resultados"
global nobs "C:\Users\Erzo\OneDrive - Universidad del Pacífico\Univesidad del Pacífico\Ciclo\lCiclo 7 2024 I\Asistente\Big5\Hasta_2023\Resultados\N_obs"

import excel using "$bases/Base18_23", sheet ("Dataset") firstrow clear
save "$bases/base18_23", replace

******************************************************************************************************************************************************************************
clear all
set more off
global bases "C:\Users\Erzo\OneDrive - Universidad del Pacífico\Univesidad del Pacífico\Ciclo\lCiclo 7 2024 I\Asistente\Big5\Hasta_2023\Bases"
global outputs "C:\Users\Erzo\OneDrive - Universidad del Pacífico\Univesidad del Pacífico\Ciclo\lCiclo 7 2024 I\Asistente\Big5\Hasta_2023\Resultados"
global nobs "C:\Users\Erzo\OneDrive - Universidad del Pacífico\Univesidad del Pacífico\Ciclo\lCiclo 7 2024 I\Asistente\Big5\Hasta_2023\Resultados\N_obs"

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

*****************************************************************************VER VARIABLES QUE INDICAN PRIMER CICLO VS REGISTRO EN LA BASE DE DATOS
*********************PRIMER SEMESTRE DE ESTUDIO
egen acayearterm=concat(acayear acaterm), decode punct("-")
**Usar solo un valor de PRIMER_SEMESTRE_EN_QUE_CURSO_EST, cambio de carrera genera dos valores para un individuo, asumo que cambios de carrera se dan en primeros ciclos
sort cod PRIMER_SEMESTRE_EN_QUE_CURSO_EST
gen primersem1 =""
by cod: replace primersem1 = PRIMER_SEMESTRE_EN_QUE_CURSO_EST[1]
********************PRIMER REGISTRO
sort cod acayearterm 
gen primerregistro =""
by cod: replace primerregistro = acayearterm[1]
*******************PRIMER YEAR SEMESTRE DE INGRESO A LA CARRERA
egen acayearing=concat(AÑO_INGRESO_CARRERA SEMESTRE_INGRESO_CARRERA), decode punct("-")
sort cod acayearing 
gen primeringreso =""
by cod: replace primeringreso = acayearing[1]
********************DE la data actual cuantos primeros registros coinciden con primer semestre en que curso estudios
preserve
gen coincide=0
replace coincide=1 if primerregistro==primersem1
collapse (mean) coincide , by (cod)
summ coincide
restore
********************Desde la cohorte 2019I, quienes coinciden// 88% tiene primer registro igual al que dice su fecha de primer semestre en que curso estudios
preserve
encode primersem1, gen(primersem2)
drop if primersem2<30
gen coincide=0
replace coincide=1 if primerregistro==primersem1
collapse (mean) coincide , by (cod)
summ coincide
restore
*************************************desde la cohorte 2019I, ver como cambia la distribucion de la gente por cohorte si es que la limito a que coincida el primerregistro con primersem1
/*Por que esto es relevante para el analisisi prox: ASUMO QUE EL REGISTRO DE LA ENCUESTA PARA RELLENAR BIG5 SE DIO EN primersem1
Si considero al primer semestre de estudios como-->

primersem1(variable dada, no necesariamente tiene data registrada ese semestre): Asumo que el propio contexto del semestre puede afectar en el reporte del Big5 que se da a la universidad. Estudiantes que ingresaron en 2020II puede tener reportes mas altos en neuroticismo(subcomponente depresion incremento) o cualquier otro componenete del Big5 vario debido al contexto.

primerregistro(veo primer periodo desde el que se tiene registro): Acá asumiria que no importa en que periodo se dio el reporte, que como es una rasgo de la personalidad que es constante en el tiempo, no variará mucho, independiente del contexto. Alguien podria tener primersem=2019I y tener registros recien para el prox ciclo=2019II

*/
preserve
gen coincide=0
replace coincide=1 if primerregistro==primersem1
collapse (first) primerregistro primersem1 coincide, by (cod)
encode primersem,gen(primersem2)
encode primerregistro, gen(primerregistro1)
drop if primersem2<30

tab primersem2 
tab primersem2 if coincide==1
tab primerregistro1
restore
**********Limito lo mismo, pero ahora veo otra variable, ingreso a la carrera//esta variable tiene algunos missings
preserve
gen coincide=0
replace coincide=1 if primerregistro==primeringreso
collapse (first) primerregistro primeringreso coincide, by (cod)
encode primeringreso,gen(primering1)
drop if primering1<31

tab primering1 
tab primering1 if coincide==1
restore
********USO PRIMER REGISTRO// este por si mismo no tendria una regla para filtrar, lo que filtra es periodo de ingreso o de inicio de estudios

*********************************************************************Creo nueva variable donde los componentes del big 5 estén para cada periodo de una obs
* Lista de variables en string
local variables neuro N1_ANSIEDAD N2_HOSTILIDAD N3_DEPRESIÓN N4_ANSIEDAD_SOCIAL N5_IMPULSIVIDAD N6_VULNERABILIDAD extrav E1_CORDIALIDAD E2_GREGARISMO E3_ASERTIVIDAD E4_ACTIVIDAD E5_BÚSQUEDA_DE_EMOCIONES E6_EMOCIONES_POSITIVAS aperexpe O1_FANTASÍA O2_ESTÉTICA O3_SENTIMIENTOS O4_ACCIONES O5_IDEAS O6_VALORES amab A1_CONFIANZA A2_FRANQUEZA A3_ALTRUISMO A4_ACTITUD_CONCILIADORA A5_MODESTIA A6_SENSIBILIDAD_A_LOS_DEMÁS resp C1_COMPETENCIA C2_ORDEN C3_SENTIDO_DEL_DEBER C4_NECESIDAD_DE_LOGRO C5_AUTODISCIPLINA C6_DELIBERACIÓN

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

****************************************CUANTA DATA TENGO PARA  >2019I Y QUE TENGAN REPORTES DE BIG5
preserve
gen coincide=0
replace coincide=1 if primerregistro==primersem1
collapse (first) primerregistro primersem1 coincide Neuro, by (cod)
encode primersem,gen(primersem2)
encode primerregistro, gen(primerregistro1)
drop if primersem2<30

tab primersem2 
asdoc tab primersem2 if Neuro<1000000, save($nobs/solo2019I.doc)
asdoc tab primersem2 if Neuro<1000000, save($nobs/2019Iconreporte.doc)
summ coincide if Neuro<1000000
restore

***********************NINGUNO INICIA ESTUDIOS EN VERANO, BOTO ESAS OBS DE CADA INDIVIDUO


preserve
gen coincide=0
replace coincide=1 if primerregistro==primersem1
collapse (first) primerregistro primersem1 acayearterm coincide Neuro, by (cod)
encode primersem1,gen(primersem2)
label list primersem2
encode primerregistro, gen(primerregistro1)
label list primerregistro1
tab primerregistro1
drop if primersem2<30

tab primersem2 
drop if acayearterm=="2020-CUR VERANO"|acayearterm=="2021-CUR VERANO"|acayearterm=="2022-CUR VERANO"|acayearterm=="2023-CUR VERANO"
tab primersem2 
tab primersem2 if acayearterm!="2020-CUR VERANO"|acayearterm!="2021-CUR VERANO"|acayearterm!="2022-CUR VERANO"|acayearterm!="2023-CUR VERANO"
tab primerregistro1

restore




**********************************************NUEVA BASE BORRO data antes de 2019,los que no tienen info despues de 2019 y absurdos por prerrequisitos************************************
*Dropeo antes de 20191 y aquellos sin información

encode primersem1,gen(primersem3)
drop if primersem3<30
drop primersem3
drop if Neuro>1000000
encode primersem1,gen(primersem2)
drop if acayearterm=="2020-CUR VERANO"|acayearterm=="2021-CUR VERANO"|acayearterm=="2022-CUR VERANO"|acayearterm=="2023-CUR VERANO"

***********************VER SI ALGUNO TIENE UN MISMO CICLO CON NIVES Y CURSOS QUE LOS NECESITABAN COMO PRERREQUISITO
*NIVE LENGUA/LENGUA1****NIVE MATE/MATE1****NIVE MATE// ECO1*** eco1//eco2
*Consideran al curso expnerado como uno que se llevo en el primer ciclo registrado, solo elimino los que no tienen registros

encode NOMBRE_DEL_CURSO, gen(nombre_curso)
encode acayearterm, gen(acayearterm1)
label list nombre_curso

/*
242 Economía General I
243 Economía General II
624 Nivelación en Lenguaje
625 Nivelación en Matemáticas
590 Matemáticas I
528 Lenguaje I
*/
gen nivemate=0
replace nivemate=1 if  nombre_curso==625 & EXAMEN_FINAL_NOTA!=-1 & EXAMEN_PARCIAL_NOTA!=-1 & TRABAJO_NOTA!=-1
gen nivelengua=0
replace nivelengua=1 if  nombre_curso==624 & EXAMEN_FINAL_NOTA!=-1 & EXAMEN_PARCIAL_NOTA!=-1 & TRABAJO_NOTA!=-1
gen lengua1=0
replace lengua1=1 if  nombre_curso==528 & EXAMEN_FINAL_NOTA!=-1 & EXAMEN_PARCIAL_NOTA!=-1 & TRABAJO_NOTA!=-1
gen mate1=0
replace mate1=1 if  nombre_curso==590 & EXAMEN_FINAL_NOTA!=-1 & EXAMEN_PARCIAL_NOTA!=-1 & TRABAJO_NOTA!=-1
gen eco1=0
replace eco1=1 if  nombre_curso==242 & EXAMEN_FINAL_NOTA!=-1 & EXAMEN_PARCIAL_NOTA!=-1 & TRABAJO_NOTA!=-1
gen eco2=0
replace eco2=1 if  nombre_curso==243 & EXAMEN_FINAL_NOTA!=-1 & EXAMEN_PARCIAL_NOTA!=-1 & TRABAJO_NOTA!=-1

bys cod acayearterm1 : egen ciclonivemate =total(nivemate)
bys cod acayearterm1 : egen ciclonivelengua =total(nivelengua)
bys cod acayearterm1 : egen ciclolengua1 =total(lengua1)
bys cod acayearterm1 : egen ciclomate1 =total(mate1)
bys cod acayearterm1 : egen cicloeco1 =total(eco1)
bys cod acayearterm1 : egen cicloeco2 =total(eco2)

  


gen nive1mate=0
replace nive1mate=1 if ciclonivemate==1 & ciclomate1==1
gen nive1lengua=0
replace nive1lengua=1 if ciclonivelengua==1 & ciclolengua1==1
gen nivemateeco1=0
replace nivemateeco1=1 if ciclonivemate==1 & cicloeco1==1
gen eco1eco2=0
replace eco1eco2=1 if cicloeco1==1 & cicloeco2==1

gen absurdo1= nive1mate+nive1lengua+nivemateeco1+eco1eco2
bys cod : egen absurdo2 =total(absurdo1)



preserve
keep if absurdo2==0
collapse (first) primersem1, by(cod)
encode primersem1, gen(primersem2)
asdoc tab primersem2, save($nobs/sinpre.doc)
restore

*br cod nombre_curso primersem1 acayearterm1 if absurdo2!=0
*Dropeo observaciones que llevaron un curso junto con su prerrequisito, considero nives, ecosm lengua1 y mate1
drop if absurdo2>0 
************************DROPEO CURSOS EXONERADOS

drop if  nombre_curso==625 & EXAMEN_FINAL_NOTA==-1 & EXAMEN_PARCIAL_NOTA==-1 & TRABAJO_NOTA==-1
drop if  nombre_curso==624 & EXAMEN_FINAL_NOTA==-1 & EXAMEN_PARCIAL_NOTA==-1 & TRABAJO_NOTA==-1
drop if  nombre_curso==528 & EXAMEN_FINAL_NOTA==-1 & EXAMEN_PARCIAL_NOTA==-1 & TRABAJO_NOTA==-1
drop if  nombre_curso==590 & EXAMEN_FINAL_NOTA==-1 & EXAMEN_PARCIAL_NOTA==-1 & TRABAJO_NOTA==-1
drop if  nombre_curso==242 & EXAMEN_FINAL_NOTA==-1 & EXAMEN_PARCIAL_NOTA==-1 & TRABAJO_NOTA==-1
drop if  nombre_curso==243 & EXAMEN_FINAL_NOTA==-1 & EXAMEN_PARCIAL_NOTA==-1 & TRABAJO_NOTA==-1




****************************************************************************CALCULAR NUEVO PROMEDIO************************************************************************
**-1 entonces no tuvo evaluación, 0 si tuvo y no sacó puntos
**Si es que solo se considera una nota, 100%; si se consideran 2;50% c/u y si son 3, la distribucion general. No en todos se confirma este guess
**NIVES, ASIGNAR CREDITAJE CORRECTO
gen llevanive=1 if (nombre_curso==623 |nombre_curso==624 |nombre_curso==625)
sort cod acayearterm1 
bys cod acayearterm1 : egen almenos1nive =mean(llevanive)
gen creditajealtern=CREDITAJE_DEL_CURSO
replace creditajealtern=4 if nombre_curso==623| nombre_curso==625
replace creditajealtern=3 if nombre_curso==624

** Crear nueva nota para cada curso. Incluyo nives y reprobados/ Si se retiran del ciclo tienen nota 0, si se retiran de un curso tambien cero? o cuento solo los aprobados? POR AHORA NO LOS CUETNO: DE LOS QUE NO SON NUMERO, SOLO LOS REPROBADOS SERAN RECALCULADOS, LOS DEMÁS SEGUIRÁN CON MISSING, SI QUIERO CAMBIAR ESTO SOLO AÑADO NUEVOS STRING A LOS QUE LES QUIERO ASIGNAR UNA NOTA(SERÍA CERO)
** Las nivelaciones son las unicas que tienen nota con un creditaje igual a cero
gen notasolonumero=real(NOTA_FINAL_DEL_CURSO)
replace notasolonumero= round(round(0.3*(EXAMEN_FINAL_NOTA),0.1)+round(0.3*EXAMEN_PARCIAL_NOTA,0.1)+round(0.4*TRABAJO_NOTA,0.1)) if (NOTA_FINAL_DEL_CURSO=="REPR" |notasolonumero<1000) & EXAMEN_FINAL_NOTA>=0 & EXAMEN_PARCIAL_NOTA>=0 & TRABAJO_NOTA>=0

replace notasolonumero= round(round(0.5*EXAMEN_FINAL_NOTA,0.1)+round(0.5*EXAMEN_PARCIAL_NOTA,0.1)) if (NOTA_FINAL_DEL_CURSO=="REPR" |notasolonumero<1000) & EXAMEN_FINAL_NOTA>=0 & EXAMEN_PARCIAL_NOTA>=0 & TRABAJO_NOTA<0
replace notasolonumero= round(round(0.5*EXAMEN_FINAL_NOTA,0.1)+round(0.5*TRABAJO_NOTA,0.1)) if (NOTA_FINAL_DEL_CURSO=="REPR" |notasolonumero<1000 & EXAMEN_FINAL_NOTA>=0) & EXAMEN_PARCIAL_NOTA<0 & TRABAJO_NOTA>=0
replace notasolonumero= round(round(0.5*EXAMEN_PARCIAL_NOTA,0.1)+round(0.5*TRABAJO_NOTA,0.1)) if (NOTA_FINAL_DEL_CURSO=="REPR" |notasolonumero<1000) & EXAMEN_FINAL_NOTA<0 & EXAMEN_PARCIAL_NOTA>=0 & TRABAJO_NOTA>=0

replace notasolonumero= round(EXAMEN_PARCIAL_NOTA) if (NOTA_FINAL_DEL_CURSO=="REPR" |notasolonumero<1000 & EXAMEN_FINAL_NOTA<0) & EXAMEN_PARCIAL_NOTA>=0 & TRABAJO_NOTA<0
replace notasolonumero= round(TRABAJO_NOTA) if (NOTA_FINAL_DEL_CURSO=="REPR" |notasolonumero<1000) & EXAMEN_FINAL_NOTA<0 & EXAMEN_PARCIAL_NOTA<0 & TRABAJO_NOTA>=0
replace notasolonumero= round(EXAMEN_FINAL_NOTA) if (NOTA_FINAL_DEL_CURSO=="REPR" |notasolonumero<1000) & EXAMEN_FINAL_NOTA>=0 & EXAMEN_PARCIAL_NOTA<0 & TRABAJO_NOTA<0


***Calculo de nuevo promedio
replace creditajealtern=. if notasolonumero>20
gen total= creditajealtern*notasolonumero
sort cod acayearterm1 
bys cod acayearterm1 : egen totalnota =total(total)
bys cod acayearterm1 : egen totalcreditaje =total(creditajealtern)
gen promedio_ciclo= round(totalnota/totalcreditaje,0.01)
*replace promedio_ciclo=0 if promedio_ciclo>20 ////////////////////////////////////////////CAMBIAR SI NO SE QUIERE QUE SEA CERO UN CICLO RETIRADO


destring acayear, gen(acayear1)
drop acayear
rename acayear1 acayear
bys cod acayear : egen totalnotayear =total(total)
bys cod acayear : egen totalcreditajeyear =total(creditajealtern)
gen promedioyear= round(totalnotayear/totalcreditajeyear,0.01)
*replace promedio_ciclo=0 if promedio_ciclo>20
replace PROMEDIO_CICLO=. if PROMEDIO_CICLO==0

************************************************************************A NIVEL INDIVIDUO-SEMESTRE
sort primersem2 cod acayearterm1
collapse (mean) totalcreditaje EDAD_ACTUAL Neuro Extrav Aperex Amab Resp Ansiedad Hostilid Depresion Ansiedad_S Impulsiv Vulnerab Cordial Gregar Asert Activ B_emoci Emo_posi Fanta Estet Sentim Accion Ideas Valores Confi Franq Altru A_concil Modest Sensi_D Compet Orden S_Deber N_Logro Autodis Delibera promedioyear (first) NUMERO_HERMANOS LUGAR_DE_NACIMIENTO BACHILLERATO_INTERNACIONAL COLEGIO_DE_ALTO_RENDIMIENTO primersem1 CARRERA PRIMER_SEMESTRE_EN_QUE_CURSO_EST promedio_ciclo PROMEDIO_CICLO, by( cod acayearterm)

destring NUMERO_HERMANOS, gen(num_hermanos)
encode LUGAR_DE_NACIMIENTO, gen (Lugar_naci)
encode acayearterm, gen (acayearterm1)
encode BACHILLERATO_INTERNACIONAL, gen (Bach_Int)
encode COLEGIO_DE_ALTO_RENDIMIENTO, gen (CAR)
encode primersem1, gen (primersem2)
encode CARRERA, gen (Carrera)
encode PRIMER_SEMESTRE_EN_QUE_CURSO_EST, gen (Primer_sem_est)


local mi_listaaea NUMERO_HERMANOS LUGAR_DE_NACIMIENTO BACHILLERATO_INTERNACIONAL COLEGIO_DE_ALTO_RENDIMIENTO primersem1 CARRERA PRIMER_SEMESTRE_EN_QUE_CURSO_EST acayearterm
foreach var of local mi_listaaea {
	drop `var'
	}

local eso CAR Bach_Int
foreach var of local eso {
	recode `var' (1=0 "NO") (2=1 "SI"), gen (`var'_)
	drop `var'
	rename `var'_ `var'
}	




**************************************************************FACULTADES
decode Carrera, gen(Carrera_)
gen Facultad=""
replace Facultad="F_Eco_y_Fi" if Carrera_=="Economía" |Carrera_=="Finanzas"
replace Facultad="F_Ing" if Carrera_=="Ingeniería Empresarial" |Carrera_=="Ingeniería de la Información"
replace Facultad="F_Dere" if Carrera_=="Derecho"
replace Facultad="F_CE" if Carrera_=="Administración" |Carrera_=="Contabilidad" |Carrera_=="Marketing" |Carrera_=="Negocios Internacionales"
save "$bases/baseregresion", replace

*********************************************************************************ESTANDARIZAR VARIABLES
use "$bases/baseregresion", clear
decode primersem2, gen(primersem1)

sort primersem2 cod acayearterm1
collapse (mean) Neuro Extrav Aperex Amab Resp Ansiedad Hostilid Depresion Ansiedad_S Impulsiv Vulnerab Cordial Gregar Asert Activ B_emoci Emo_posi Fanta Estet Sentim Accion Ideas Valores Confi Franq Altru A_concil Modest Sensi_D Compet Orden S_Deber N_Logro Autodis Delibera (first) Carrera_ Facultad promedio_ciclo PROMEDIO_CICLO primersem1 promedioyear, by(cod)

encode primersem1, gen(primersem2)

**ESTANDARIZAR VAR-MEAN/DESV respecto de 2019
global evolucion "C:\Users\Erzo\OneDrive - Universidad del Pacífico\Univesidad del Pacífico\Ciclo\lCiclo 7 2024 I\Asistente\Big5\Hasta_2023\Resultados\Evolucion\Comp"
global evolucionN "C:\Users\Erzo\OneDrive - Universidad del Pacífico\Univesidad del Pacífico\Ciclo\lCiclo 7 2024 I\Asistente\Big5\Hasta_2023\Resultados\Evolucion\Subcomp\Neuro"
global evolucionE "C:\Users\Erzo\OneDrive - Universidad del Pacífico\Univesidad del Pacífico\Ciclo\lCiclo 7 2024 I\Asistente\Big5\Hasta_2023\Resultados\Evolucion\Subcomp\Extrav"
global evolucionAE "C:\Users\Erzo\OneDrive - Universidad del Pacífico\Univesidad del Pacífico\Ciclo\lCiclo 7 2024 I\Asistente\Big5\Hasta_2023\Resultados\Evolucion\Subcomp\Aperex"
global evolucionA "C:\Users\Erzo\OneDrive - Universidad del Pacífico\Univesidad del Pacífico\Ciclo\lCiclo 7 2024 I\Asistente\Big5\Hasta_2023\Resultados\Evolucion\Subcomp\Amab"
global evolucionR "C:\Users\Erzo\OneDrive - Universidad del Pacífico\Univesidad del Pacífico\Ciclo\lCiclo 7 2024 I\Asistente\Big5\Hasta_2023\Resultados\Evolucion\Subcomp\Resp"

local mi_listasa Neuro Extrav Aperex Amab Resp Ansiedad Hostilid Depresion Ansiedad_S Impulsiv Vulnerab Cordial Gregar Asert Activ B_emoci Emo_posi Fanta Estet Sentim Accion Ideas Valores Confi Franq Altru A_concil Modest Sensi_D Compet Orden S_Deber N_Logro Autodis Delibera
foreach var of local mi_listasa {
	gen h`var' = .
	gen l`var' = .
	egen MEAN_`var' = mean(`var'), by(primersem2)
	
	summarize `var'  if primersem2==1 
	gen MEANBASE_`var' = r(mean) 
	
	summarize `var'  if primersem2==1 
	gen sdBASE_`var'=r(sd)
	
	gen estandar_`var'=(`var'-MEANBASE_`var')/sdBASE_`var'
	gen estandar_MEAN_`var'=(MEAN_`var'-MEANBASE_`var')/sdBASE_`var'
}



local mi_listasas Neuro Extrav Aperex Amab Resp Ansiedad Hostilid Depresion Ansiedad_S Impulsiv Vulnerab Cordial Gregar Asert Activ B_emoci Emo_posi Fanta Estet Sentim Accion Ideas Valores Confi Franq Altru A_concil Modest Sensi_D Compet Orden S_Deber N_Logro Autodis Delibera
forvalues i = 1/10 {
	foreach var of local mi_listasa {
           ci mean `var' if primersem2 == `i'
           replace h`var' = (r(ub)-MEANBASE_`var')/sdBASE_`var' if primersem2 == `i'
           replace l`var' = (r(lb)-MEANBASE_`var')/sdBASE_`var' if primersem2 == `i'   
  } 
  }



  
********************************************************************************************************EVOLUCION POR SEMESTRE****************************************************************
sort primersem2
local mi_listasss Neuro Extrav Aperex Amab Resp  
foreach var of local mi_listasss {
gen ll`var'=cond(l`var' <-1, -1, l`var')
gen hh`var'=cond(h`var' >1, 1, h`var')
graph twoway (rcap ll`var' hh`var' primersem2) ///
             (connected estandar_MEAN_`var' primersem2, color(navy) msize(small)  //////
                        title(Cohort_`var') ///
                        ytitle(`var') ///
                        xtitle("CICLO") ///
                        xlab(1 "2019-I PER" 2 "2019-II PER" 3 "2020-I PER-1" 4 "2020-II PER" 5 "2021-I PER" 6 "2021-II PER" 7 "2022-I PER" 8 "2022-II PER" 9 "2023-I PER" 10 "2023-II PER", labsize(vsmall)) ///
                        ylab(, labsize(vsmall) ) ///
                        graphregion(color(white)) ///
                        bgcolor(white) ///
                        color(navy)) (scatteri 1 0.95 1 8.25, recast(line) lcolor(white) lwidth(medthick)) /// 
(scatteri -1 0.95 -1 8.25, recast(line) lcolor(white) lwidth(medthick) leg(off)), legend(off) ylabel(-1[0.1]1)
						 
graph export "$evolucion/`var'.png" , replace
}

local mi_listasss Ansiedad Hostilid Depresion Ansiedad_S Impulsiv Vulnerab  
foreach var of local mi_listasss {
gen ll`var'=cond(l`var' <-1, -1, l`var')
gen hh`var'=cond(h`var' >1, 1, h`var')
graph twoway (rcap ll`var' hh`var' primersem2) ///
             (connected estandar_MEAN_`var' primersem2, color(navy) msize(small)  //////
                        title(Cohort_`var') ///
                        ytitle(`var') ///
                        xtitle("CICLO") ///
                        xlab(1 "2019-I PER" 2 "2019-II PER" 3 "2020-I PER-1" 4 "2020-II PER" 5 "2021-I PER" 6 "2021-II PER" 7 "2022-I PER" 8 "2022-II PER" 9 "2023-I PER" 10 "2023-II PER", labsize(vsmall)) ///
                        ylab(, labsize(vsmall) ) ///
                        graphregion(color(white)) ///
                        bgcolor(white) ///
                        color(navy)) (scatteri 1 0.95 1 8.25, recast(line) lcolor(white) lwidth(medthick)) /// 
(scatteri -1 0.95 -1 8.25, recast(line) lcolor(white) lwidth(medthick) leg(off)), legend(off) ylabel(-1[0.1]1)
						 
graph export "$evolucionN/`var'.png" , replace
}

local mi_listasss Cordial Gregar Asert Activ B_emoci Emo_posi  
foreach var of local mi_listasss {
gen ll`var'=cond(l`var' <-1, -1, l`var')
gen hh`var'=cond(h`var' >1, 1, h`var')
graph twoway (rcap ll`var' hh`var' primersem2) ///
             (connected estandar_MEAN_`var' primersem2, color(navy) msize(small)  //////
                        title(Cohort_`var') ///
                        ytitle(`var') ///
                        xtitle("CICLO") ///
                        xlab(1 "2019-I PER" 2 "2019-II PER" 3 "2020-I PER-1" 4 "2020-II PER" 5 "2021-I PER" 6 "2021-II PER" 7 "2022-I PER" 8 "2022-II PER" 9 "2023-I PER" 10 "2023-II PER", labsize(vsmall)) ///
                        ylab(, labsize(vsmall) ) ///
                        graphregion(color(white)) ///
                        bgcolor(white) ///
                        color(navy)) (scatteri 1 0.95 1 8.25, recast(line) lcolor(white) lwidth(medthick)) /// 
(scatteri -1 0.95 -1 8.25, recast(line) lcolor(white) lwidth(medthick) leg(off)), legend(off) ylabel(-1[0.1]1)
						 
graph export "$evolucionE/`var'.png" , replace
}

local mi_listasss Fanta Estet Sentim Accion Ideas Valores 
foreach var of local mi_listasss {
gen ll`var'=cond(l`var' <-1, -1, l`var')
gen hh`var'=cond(h`var' >1, 1, h`var')
graph twoway (rcap ll`var' hh`var' primersem2) ///
             (connected estandar_MEAN_`var' primersem2, color(navy) msize(small)  //////
                        title(Cohort_`var') ///
                        ytitle(`var') ///
                        xtitle("CICLO") ///
                        xlab(1 "2019-I PER" 2 "2019-II PER" 3 "2020-I PER-1" 4 "2020-II PER" 5 "2021-I PER" 6 "2021-II PER" 7 "2022-I PER" 8 "2022-II PER" 9 "2023-I PER" 10 "2023-II PER", labsize(vsmall)) ///
                        ylab(, labsize(vsmall) ) ///
                        graphregion(color(white)) ///
                        bgcolor(white) ///
                        color(navy)) (scatteri 1 0.95 1 8.25, recast(line) lcolor(white) lwidth(medthick)) /// 
(scatteri -1 0.95 -1 8.25, recast(line) lcolor(white) lwidth(medthick) leg(off)), legend(off) ylabel(-1[0.1]1)
						 
graph export "$evolucionAE/`var'.png" , replace
}

local mi_listasss Confi Franq Altru A_concil Modest Sensi_D 
foreach var of local mi_listasss {
gen ll`var'=cond(l`var' <-1, -1, l`var')
gen hh`var'=cond(h`var' >1, 1, h`var')
graph twoway (rcap ll`var' hh`var' primersem2) ///
             (connected estandar_MEAN_`var' primersem2, color(navy) msize(small)  //////
                        title(Cohort_`var') ///
                        ytitle(`var') ///
                        xtitle("CICLO") ///
                        xlab(1 "2019-I PER" 2 "2019-II PER" 3 "2020-I PER-1" 4 "2020-II PER" 5 "2021-I PER" 6 "2021-II PER" 7 "2022-I PER" 8 "2022-II PER" 9 "2023-I PER" 10 "2023-II PER", labsize(vsmall)) ///
                        ylab(, labsize(vsmall) ) ///
                        graphregion(color(white)) ///
                        bgcolor(white) ///
                        color(navy)) (scatteri 1 0.95 1 8.25, recast(line) lcolor(white) lwidth(medthick)) /// 
(scatteri -1 0.95 -1 8.25, recast(line) lcolor(white) lwidth(medthick) leg(off)), legend(off) ylabel(-1[0.1]1)
						 
graph export "$evolucionA/`var'.png" , replace
}

local mi_listasss Compet Orden S_Deber N_Logro Autodis Delibera
foreach var of local mi_listasss {
gen ll`var'=cond(l`var' <-1, -1, l`var')
gen hh`var'=cond(h`var' >1, 1, h`var')
graph twoway (rcap ll`var' hh`var' primersem2) ///
             (connected estandar_MEAN_`var' primersem2, color(navy) msize(small)  //////
                        title(Cohort_`var') ///
                        ytitle(`var') ///
                        xtitle("CICLO") ///
                        xlab(1 "2019-I PER" 2 "2019-II PER" 3 "2020-I PER-1" 4 "2020-II PER" 5 "2021-I PER" 6 "2021-II PER" 7 "2022-I PER" 8 "2022-II PER" 9 "2023-I PER" 10 "2023-II PER", labsize(vsmall)) ///
                        ylab(, labsize(vsmall) ) ///
                        graphregion(color(white)) ///
                        bgcolor(white) ///
                        color(navy)) (scatteri 1 0.95 1 8.25, recast(line) lcolor(white) lwidth(medthick)) /// 
(scatteri -1 0.95 -1 8.25, recast(line) lcolor(white) lwidth(medthick) leg(off)), legend(off) ylabel(-1[0.1]1)
						 
graph export "$evolucionR/`var'.png" , replace
}



********************************************************************************************************EVOLUCION POR YEAR**********************************************************************
gen Year=0
replace Year=2019 if primersem2==1|primersem2==2
replace Year=2020 if primersem2==3|primersem2==4
replace Year=2021 if primersem2==5|primersem2==6
replace Year=2022 if primersem2==7|primersem2==8
replace Year=2023 if primersem2==9|primersem2==10
global evolucionY "C:\Users\Erzo\OneDrive - Universidad del Pacífico\Univesidad del Pacífico\Ciclo\lCiclo 7 2024 I\Asistente\Big5\Hasta_2023\Resultados\Evolucion\Year\Comp"
global evolucionNY "C:\Users\Erzo\OneDrive - Universidad del Pacífico\Univesidad del Pacífico\Ciclo\lCiclo 7 2024 I\Asistente\Big5\Hasta_2023\Resultados\Evolucion\Year\Subcomp\Neuro"
global evolucionEY "C:\Users\Erzo\OneDrive - Universidad del Pacífico\Univesidad del Pacífico\Ciclo\lCiclo 7 2024 I\Asistente\Big5\Hasta_2023\Resultados\Evolucion\Year\Subcomp\Extrav"
global evolucionAEY "C:\Users\Erzo\OneDrive - Universidad del Pacífico\Univesidad del Pacífico\Ciclo\lCiclo 7 2024 I\Asistente\Big5\Hasta_2023\Resultados\Evolucion\Year\Subcomp\Aperex"
global evolucionAY "C:\Users\Erzo\OneDrive - Universidad del Pacífico\Univesidad del Pacífico\Ciclo\lCiclo 7 2024 I\Asistente\Big5\Hasta_2023\Resultados\Evolucion\Year\Subcomp\Amab"
global evolucionRY "C:\Users\Erzo\OneDrive - Universidad del Pacífico\Univesidad del Pacífico\Ciclo\lCiclo 7 2024 I\Asistente\Big5\Hasta_2023\Resultados\Evolucion\Year\Subcomp\Resp"


local a_listasa Neuro Extrav Aperex Amab Resp Ansiedad Hostilid Depresion Ansiedad_S Impulsiv Vulnerab Cordial Gregar Asert Activ B_emoci Emo_posi Fanta Estet Sentim Accion Ideas Valores Confi Franq Altru A_concil Modest Sensi_D Compet Orden S_Deber N_Logro Autodis Delibera
foreach var of local a_listasa {
	gen hyear`var' = .
	gen lyear`var' = .
	egen year_MEAN`var' = mean(`var'), by(Year)
	
	summarize `var' if Year==2019 
	gen year_MEANBASE_`var' = r(mean)
	summarize `var'  if Year==2019 
	gen year_sdBASE_`var'=r(sd)
	
	gen year_estandar_`var'=(`var'-year_MEANBASE_`var')/year_sdBASE_`var'
	gen year_est_MEAN_`var'=(year_MEAN`var'-year_MEANBASE_`var')/year_sdBASE_`var'
	
	
}
local a_listasas Neuro Extrav Aperex Amab Resp Ansiedad Hostilid Depresion Ansiedad_S Impulsiv Vulnerab Cordial Gregar Asert Activ B_emoci Emo_posi Fanta Estet Sentim Accion Ideas Valores Confi Franq Altru A_concil Modest Sensi_D Compet Orden S_Deber N_Logro Autodis Delibera
forvalues i = 2019/2023 {
	foreach var of local a_listasa {
           ci mean `var' if Year == `i'
          replace hyear`var' = (r(ub)-year_MEANBASE_`var')/year_sdBASE_`var' if Year == `i'
           replace lyear`var' = (r(lb)-year_MEANBASE_`var')/year_sdBASE_`var' if Year == `i'
  } 
  }

  
sort Year
local a_listasss Neuro Extrav Aperex Amab Resp 
foreach var of local a_listasss {
graph twoway (rcap lyear`var' hyear`var' Year) ///
             (connected year_est_MEAN_`var' Year, color(navy) msize(small) ///
                        title(`var' "Over The Years") ///
                        ytitle(`var') ///
                        xtitle("Year") ///
                        xlab(2019(1)2023, labsize(vsmall)) ///
                        ylab(, labsize(vsmall) nogrid) ///
                        graphregion(color(white)) ///
                        bgcolor(white) ///
                        color(navy)), legend(off)
graph export "$evolucionY/`var'.png" , replace
}

local a_listasss Ansiedad Hostilid Depresion Ansiedad_S Impulsiv Vulnerab 
foreach var of local a_listasss {
graph twoway (rcap lyear`var' hyear`var' Year) ///
             (connected year_est_MEAN_`var' Year, color(navy) msize(small) ///
                        title(`var' "Over The Years") ///
                        ytitle(`var') ///
                        xtitle("Year") ///
                        xlab(2019(1)2023, labsize(vsmall)) ///
                        ylab(, labsize(vsmall) nogrid) ///
                        graphregion(color(white)) ///
                        bgcolor(white) ///
                        color(navy)), legend(off)
graph export "$evolucionNY/`var'.png" , replace
}
local a_listasss Cordial Gregar Asert Activ B_emoci Emo_posi 
foreach var of local a_listasss {
graph twoway (rcap lyear`var' hyear`var' Year) ///
             (connected year_est_MEAN_`var' Year, color(navy) msize(small) ///
                        title(`var' "Over The Years") ///
                        ytitle(`var') ///
                        xtitle("Year") ///
                        xlab(2019(1)2023, labsize(vsmall)) ///
                        ylab(, labsize(vsmall) nogrid) ///
                        graphregion(color(white)) ///
                        bgcolor(white) ///
                        color(navy)), legend(off)
graph export "$evolucionEY/`var'.png" , replace
}
local a_listasss Fanta Estet Sentim Accion Ideas Valores 
foreach var of local a_listasss {
graph twoway (rcap lyear`var' hyear`var' Year) ///
             (connected year_est_MEAN_`var' Year, color(navy) msize(small) ///
                        title(`var' "Over The Years") ///
                        ytitle(`var') ///
                        xtitle("Year") ///
                        xlab(2019(1)2023, labsize(vsmall)) ///
                        ylab(, labsize(vsmall) nogrid) ///
                        graphregion(color(white)) ///
                        bgcolor(white) ///
                        color(navy)), legend(off)
graph export "$evolucionAEY/`var'.png" , replace
}
local a_listasss Confi Franq Altru A_concil Modest Sensi_D Compet Orden S_Deber N_Logro Autodis Delibera
foreach var of local a_listasss {
graph twoway (rcap lyear`var' hyear`var' Year) ///
             (connected year_est_MEAN_`var' Year, color(navy) msize(small) ///
                        title(`var' "Over The Years") ///
                        ytitle(`var') ///
                        xtitle("Year") ///
                        xlab(2019(1)2023, labsize(vsmall)) ///
                        ylab(, labsize(vsmall) nogrid) ///
                        graphregion(color(white)) ///
                        bgcolor(white) ///
                        color(navy)), legend(off)
graph export "$evolucionAY/`var'.png" , replace
}
local a_listasss Compet Orden S_Deber N_Logro Autodis Delibera
foreach var of local a_listasss {
graph twoway (rcap lyear`var' hyear`var' Year) ///
             (connected year_est_MEAN_`var' Year, color(navy) msize(small) ///
                        title(`var' "Over The Years") ///
                        ytitle(`var') ///
                        xtitle("Year") ///
                        xlab(2019(1)2023, labsize(vsmall)) ///
                        ylab(, labsize(vsmall) nogrid) ///
                        graphregion(color(white)) ///
                        bgcolor(white) ///
                        color(navy)), legend(off)
graph export "$evolucionRY/`var'.png" , replace
}



*********************************************************************************GRAFICO EVOLUCION DE PROMEDIOS
***semestres
global prom "C:\Users\Erzo\OneDrive - Universidad del Pacífico\Univesidad del Pacífico\Ciclo\lCiclo 7 2024 I\Asistente\Big5\Hasta_2023\Resultados\Evolucion\Promedio"
global promy "C:\Users\Erzo\OneDrive - Universidad del Pacífico\Univesidad del Pacífico\Ciclo\lCiclo 7 2024 I\Asistente\Big5\Hasta_2023\Resultados\Evolucion\Year\Promedio"

gen hpromedio = .
gen lpromedio = .
egen MEAN_promedio = mean(promedio_ciclo), by(primersem2)

forvalues i = 1/10 {

           ci mean promedio_ciclo if primersem2 == `i'
           replace hpromedio = r(ub) if primersem2 == `i'
           replace lpromedio = r(lb) if primersem2 == `i'
  
}
  
 sort primersem2


graph twoway (rcap lpromedio hpromedio primersem2) ///
             (connected MEAN_promedio primersem2, color(navy) msize(small) ///
                        title("Cohorte_promedio_de_primer_ciclo") ///
                        ytitle("Promedio_de_primer_ciclo") ///
                        xtitle("Cohorte") ///
                        xlab(1 "2019-I PER" 2 "2019-II PER" 3 "2020-I PER-1" 4 "2020-II PER" 5 "2021-I PER" 6 "2021-II PER" 7 "2022-I PER" 8 "2022-II PER" 9 "2023-I PER" 10 "2023-II PER", labsize(vsmall)) ///
                        ylab(, labsize(vsmall) nogrid) ///
                        graphregion(color(white)) ///
                        bgcolor(white) ///
                        color(navy)), legend(off)
graph export "$prom/promedioprimerciclo.png" , replace
***anual
/*clear all
global promagregsem "C:\Users\Erzo\OneDrive - Universidad del Pacífico\Univesidad del Pacífico\Ciclo\jCiclo 5 2023 II\Asistente\Bases de datos\5 y habitos\Stata\OUTPUT\DOFILE\Con nuevo gpa\Resultados\Promedios\Agregados"
global bases "C:\Users\Erzo\OneDrive - Universidad del Pacífico\Univesidad del Pacífico\Ciclo\jCiclo 5 2023 II\Asistente\Bases de datos\5 y habitos\Stata\OUTPUT\DOFILE\Con nuevo gpa\Resultados"
use "$bases/CORRECIONGRAFICOS", clear
*/
gen hyearpromedio = .
gen lyearpromedio = .
egen MEANyear_promedio = mean(promedio_ciclo), by(Year)

forvalues i = 2019/2023 {
           ci mean promedio_ciclo if Year == `i'
           replace hyearpromedio = r(ub) if Year == `i'
           replace lyearpromedio = r(lb) if Year == `i'
  
}
  
sort Year

graph twoway (rcap lyearpromedio hyearpromedio Year) ///
             (connected MEANyear_promedio Year, color(navy) msize(small) ///
                        title("Cohorte_anual_promedio_de_primer_ciclo") ///
                        ytitle("Promedio_de_primer_ciclo") ///
                        xtitle("Year") ///
                        xlab(2019(1)2023, labsize(vsmall)) ///
                        ylab(, labsize(vsmall) nogrid) ///
                        graphregion(color(white)) ///
                        bgcolor(white) ///
                        color(navy)), legend(off) ylabel(12[0.5]15.5)
graph export "$promy/promedioyearprimerciclo.png" , replace



**********************************************
gen hpromedio_ = .
gen lpromedio_= .
egen MEAN_promedio_ = mean(PROMEDIO_CICLO), by(primersem2)

forvalues i = 1/10 {

           ci mean PROMEDIO_CICLO if primersem2 == `i'
           replace hpromedio_ = r(ub) if primersem2 == `i'
           replace lpromedio_ = r(lb) if primersem2 == `i'
  
}
  
 sort primersem2


graph twoway (rcap lpromedio_ hpromedio_ primersem2) ///
             (connected MEAN_promedio_ primersem2, color(navy) msize(small) ///
                        title("Cohorte_promedio_de_primer_ciclo") ///
                        ytitle("Promedio_de_primer_ciclo") ///
                        xtitle("Cohorte") ///
                        xlab(1 "2019-I PER" 2 "2019-II PER" 3 "2020-I PER-1" 4 "2020-II PER" 5 "2021-I PER" 6 "2021-II PER" 7 "2022-I PER" 8 "2022-II PER" 9 "2023-I PER" 10 "2023-II PER", labsize(vsmall)) ///
                        ylab(, labsize(vsmall) nogrid) ///
                        graphregion(color(white)) ///
                        bgcolor(white) ///
                        color(navy)), legend(off)
graph export "$prom/promedioprimercicloNOCORREGIDO.png" , replace


*****
gen hyearpromedio_ = .
gen lyearpromedio_ = .
egen MEANyear_promedio_ = mean(PROMEDIO_CICLO), by(Year)

forvalues i = 2019/2023 {
           ci mean PROMEDIO_CICLO if Year == `i'
           replace hyearpromedio_ = r(ub) if Year == `i'
           replace lyearpromedio_ = r(lb) if Year == `i'
  
}
  
sort Year

graph twoway (rcap lyearpromedio_ hyearpromedio_ Year) ///
             (connected MEANyear_promedio_ Year, color(navy) msize(small) ///
                        title("Cohorte_anual_promedio_de_primer_ciclo") ///
                        ytitle("Promedio_de_primer_ciclo") ///
                        xtitle("Year") ///
                        xlab(2019(1)2023, labsize(vsmall)) ///
                        ylab(, labsize(vsmall) nogrid) ///
                        graphregion(color(white)) ///
                        bgcolor(white) ///
                        color(navy)), legend(off) ylabel(12[0.5]15.5)
graph export "$promy/promedioyearprimercicloNOCORREGIDO.png" , replace
*******************************************************************
save "$bases/Individuoestand", replace
******************************************************************
clear all
set more off
use "$bases/baseregresion",clear

merge m:1 cod using "$bases/Individuoestand", nogen keep(3) keepusing( estandar_Neuro estandar_MEAN_Neuro estandar_Extrav estandar_MEAN_Extrav estandar_Aperex estandar_MEAN_Aperex estandar_Amab estandar_MEAN_Amab estandar_Resp estandar_MEAN_Resp estandar_Ansiedad estandar_MEAN_Ansiedad estandar_Hostilid estandar_MEAN_Hostilid estandar_Depresion estandar_MEAN_Depresion estandar_Ansiedad_S estandar_MEAN_Ansiedad_S estandar_Impulsiv estandar_MEAN_Impulsiv estandar_Vulnerab estandar_MEAN_Vulnerab estandar_Cordial estandar_MEAN_Cordial estandar_Gregar estandar_MEAN_Gregar estandar_Asert estandar_MEAN_Asert estandar_Activ estandar_MEAN_Activ estandar_B_emoci estandar_MEAN_B_emoci estandar_Emo_posi estandar_MEAN_Emo_posi estandar_Fanta estandar_MEAN_Fanta estandar_Estet estandar_MEAN_Estet estandar_Sentim estandar_MEAN_Sentim estandar_Accion estandar_MEAN_Accion estandar_Ideas estandar_MEAN_Ideas estandar_Valores estandar_MEAN_Valores estandar_Confi estandar_MEAN_Confi estandar_Franq estandar_MEAN_Franq estandar_Altru estandar_MEAN_Altru estandar_A_concil estandar_MEAN_A_concil estandar_Modest estandar_MEAN_Modest estandar_Sensi_D estandar_MEAN_Sensi_D estandar_Compet estandar_MEAN_Compet estandar_Orden estandar_MEAN_Orden estandar_S_Deber estandar_MEAN_S_Deber estandar_N_Logro estandar_MEAN_N_Logro estandar_Autodis estandar_MEAN_Autodis estandar_Delibera estandar_MEAN_Delibera)
save "$bases/baseregresion", replace



























