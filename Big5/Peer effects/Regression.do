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

VALDRIA LA PENA CONSIDERAR A PRIMER SEM COMO CONTROL? Y ESTAR USANDO PRIMER REGISTRO
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

keep if NOMBRE_DEL_CURSO=="Nivelación en Matemáticas" | NOMBRE_DEL_CURSO=="Economía General I" | NOMBRE_DEL_CURSO=="Nivelación en Lenguaje"

keep cod cod acayearterm NOMBRE_DEL_CURSO CALIFICACION_DEL_PROFESOR_DE_LA_ notasolonumero NOTA_FINAL_DEL_CURSO
rename CALIFICACION_DEL_PROFESOR_DE_LA_ nota_docente
gen nota_docente_no0=nota_docente
replace nota_docente_no0=. if nota_docente_no0==0



sort cod acayearterm NOMBRE_DEL_CURSO notasolonumero
by cod acayearterm NOMBRE_DEL_CURSO : gen n=_n
drop if n!=1
reg  nota_docente notasolonumero
reg  nota_docente_no0 notasolonumero
save "$bases/notas_cod_sem", replace

************************************************************************

clear all
global bases "C:\Users\Erzo\OneDrive - Universidad del Pacífico\Univesidad del Pacífico\Ciclo\lCiclo 7 2024 I\Asistente\Big5\Hasta_2023\Bases"
global outputs "C:\Users\Erzo\OneDrive - Universidad del Pacífico\Univesidad del Pacífico\Ciclo\lCiclo 7 2024 I\Asistente\Big5\Peer effects classrooms\Regress"
global outpuyears "C:\Users\Erzo\OneDrive - Universidad del Pacífico\Univesidad del Pacífico\Ciclo\lCiclo 7 2024 I\Asistente\Big5\Peer effects classrooms\Regress\Byyear"
global outpuyearsnocontrol "C:\Users\Erzo\OneDrive - Universidad del Pacífico\Univesidad del Pacífico\Ciclo\lCiclo 7 2024 I\Asistente\Big5\Peer effects classrooms\Regress\Byyear_nocontrol"
global outputstd "C:\Users\Erzo\OneDrive - Universidad del Pacífico\Univesidad del Pacífico\Ciclo\lCiclo 7 2024 I\Asistente\Big5\Peer effects classrooms\Regress\Byyear_std"
use "$bases/salones", clear

merge 1:1 cod acayearterm NOMBRE_DEL_CURSO using "$bases/notas_cod_sem", nogen keep(3)

reg  nota_docente c.notasolonumero##i.nombre_curso
reg  nota_docente c.notasolonumero i.nombre_curso
*reg  nota_docente_no0 notasolonumero i.nombre_curso
reg  nota_docente notasolonumero if nombre_curso==238
reg  nota_docente notasolonumero if nombre_curso==617
reg  nota_docente notasolonumero if nombre_curso==618
**
corr notasolonumero nota_docente
corr notasolonumero nota_docente  if nombre_curso==238
corr notasolonumero nota_docente if nombre_curso==617
corr notasolonumero nota_docente if nombre_curso==618

reg notasolonumero nota_docente  if nombre_curso==238
reg notasolonumero nota_docente if nombre_curso==617
reg notasolonumero nota_docente if nombre_curso==618
***************************************************
kdensity nota_docente if nombre_curso==238
kdensity nota_docente if nombre_curso==617
kdensity nota_docente if nombre_curso==618
****************************************************
sort salon 
by salon: egen Neuro_salon=mean(Neuro)
by salon: egen Extrav_salon=mean(Extrav)
by salon: egen Aperex_salon=mean(Aperex)
by salon: egen Amab_salon=mean(Amab)
by salon: egen Resp_salon=mean(Resp)

by salon: egen estandar_Neuro_salon=mean(estandar_Neuro)
by salon: egen estandar_Extrav_salon=mean(estandar_Extrav)
by salon: egen estandar_Aperex_salon=mean(estandar_Aperex)
by salon: egen estandar_Amab_salon=mean(estandar_Amab)
by salon: egen estandar_Resp_salon=mean(estandar_Resp)

egen evaleco1=std(nota_docente) if nombre_curso==238
egen evalnivelengua=std(nota_docente) if nombre_curso==617
egen evalnivemate=std(nota_docente) if nombre_curso==618

egen std_nota_docente=rowtotal(evaleco1 evalnivelengua evalnivemate)

local varlist ""2020-I PER" "2021-I PER" "2022-I PER" "2023-I PER""
foreach var of local varlist{
*RAW
corr Neuro Extrav Aperex Amab Resp Neuro_salon Extrav_salon Aperex_salon Amab_salon Resp_salon if cachimbo==1 & N_k >20 & nombre_curso==238 & acayearterm=="`var'"
corr Neuro Extrav Aperex Amab Resp Neuro_salon Extrav_salon Aperex_salon Amab_salon Resp_salon if cachimbo==1 & nombre_curso==238 & acayearterm=="`var'"
*ECO1:
reg notasolonumero Neuro Extrav Aperex Amab Resp Neuro_salon Extrav_salon Aperex_salon Amab_salon Resp_salon if cachimbo==1 & nombre_curso==238 & acayearterm=="`var'"
    outreg2 using "$outputs/`var'ECO1.doc", label bdec(3) sdec(3) ctitle(`var') replace
reg notasolonumero Neuro Extrav Aperex Amab Resp Neuro_salon Extrav_salon Aperex_salon Amab_salon Resp_salon nota_docente if cachimbo==1 & nombre_curso==238 & acayearterm=="`var'"
	outreg2 using "$outputs/`var'ECO1.doc", label bdec(3) sdec(3) ctitle(`var' control) append  
*NIVELENGUA:
reg notasolonumero Neuro Extrav Aperex Amab Resp Neuro_salon Extrav_salon Aperex_salon Amab_salon Resp_salon if cachimbo==1 & nombre_curso==617 & acayearterm=="`var'"
	outreg2 using "$outputs/`var'NIVELENGUA.doc", label bdec(3) sdec(3) ctitle(`var') replace
reg notasolonumero Neuro Extrav Aperex Amab Resp Neuro_salon Extrav_salon Aperex_salon Amab_salon Resp_salon nota_docente if cachimbo==1 & nombre_curso==617 & acayearterm=="`var'"
	outreg2 using "$outputs/`var'NIVELENGUA.doc", label bdec(3) sdec(3) ctitle(`var' control) append  
*NIVEMATE:
reg notasolonumero Neuro Extrav Aperex Amab Resp Neuro_salon Extrav_salon Aperex_salon Amab_salon Resp_salon if cachimbo==1 & nombre_curso==618 & acayearterm=="`var'"
	outreg2 using "$outputs/`var'NIVEMATE.doc", label bdec(3) sdec(3) ctitle(`var') replace
reg notasolonumero Neuro Extrav Aperex Amab Resp Neuro_salon Extrav_salon Aperex_salon Amab_salon Resp_salon nota_docente if cachimbo==1 & nombre_curso==618 & acayearterm=="`var'"
	outreg2 using "$outputs/`var'NIVEMATE.doc", label bdec(3) sdec(3) ctitle(`var' control) append  
*ALL	
reg notasolonumero Neuro Extrav Aperex Amab Resp Neuro_salon Extrav_salon Aperex_salon Amab_salon Resp_salon i.nombre_curso if cachimbo==1 & acayearterm=="`var'"
	outreg2 using "$outputs/`var'ALL.doc", label bdec(3) sdec(3) ctitle(`var') replace
reg notasolonumero Neuro Extrav Aperex Amab Resp Neuro_salon Extrav_salon Aperex_salon Amab_salon Resp_salon i.nombre_curso nota_docente if cachimbo==1 & acayearterm=="`var'"
	outreg2 using "$outputs/`var'ALL.doc", label bdec(3) sdec(3) ctitle(`var' control) append  



*ESTANDAR
*ESTANDARECO1:
reg notasolonumero estandar_Neuro estandar_Extrav estandar_Aperex estandar_Amab estandar_Resp estandar_Neuro_salon estandar_Extrav_salon estandar_Aperex_salon estandar_Amab_salon estandar_Resp_salon if cachimbo==1 & nombre_curso==238 & acayearterm=="`var'"
	outreg2 using "$outputs/`var'ESTANDARECO1.doc", label bdec(3) sdec(3) ctitle(`var') replace
reg notasolonumero estandar_Neuro estandar_Extrav estandar_Aperex estandar_Amab estandar_Resp estandar_Neuro_salon estandar_Extrav_salon estandar_Aperex_salon estandar_Amab_salon estandar_Resp_salon nota_docente if cachimbo==1 & nombre_curso==238  & acayearterm=="`var'"
	outreg2 using "$outputs/`var'ESTANDARECO1.doc", label bdec(3) sdec(3) ctitle(`var' control) append  
*ESTANDARNIVELENGUA:
reg notasolonumero estandar_Neuro estandar_Extrav estandar_Aperex estandar_Amab estandar_Resp estandar_Neuro_salon estandar_Extrav_salon estandar_Aperex_salon estandar_Amab_salon estandar_Resp_salon if cachimbo==1 & nombre_curso==617 & acayearterm=="`var'"
	outreg2 using "$outputs/`var'ESTANDARNIVELENGUA.doc", label bdec(3) sdec(3) ctitle(`var') replace
reg notasolonumero estandar_Neuro estandar_Extrav estandar_Aperex estandar_Amab estandar_Resp estandar_Neuro_salon estandar_Extrav_salon estandar_Aperex_salon estandar_Amab_salon estandar_Resp_salon nota_docente if cachimbo==1 & nombre_curso==617 & acayearterm=="`var'"
	outreg2 using "$outputs/`var'ESTANDARNIVELENGUA.doc", label bdec(3) sdec(3) ctitle(`var' control) append  
*ESTANDARNIVEMATE:
reg notasolonumero estandar_Neuro estandar_Extrav estandar_Aperex estandar_Amab estandar_Resp estandar_Neuro_salon estandar_Extrav_salon estandar_Aperex_salon estandar_Amab_salon estandar_Resp_salon if cachimbo==1 & nombre_curso==618 & acayearterm=="`var'"
	outreg2 using "$outputs/`var'ESTANDARNIVEMATE.doc", label bdec(3) sdec(3) ctitle(`var') replace
reg notasolonumero estandar_Neuro estandar_Extrav estandar_Aperex estandar_Amab estandar_Resp estandar_Neuro_salon estandar_Extrav_salon estandar_Aperex_salon estandar_Amab_salon estandar_Resp_salon nota_docente if cachimbo==1 & nombre_curso==618 & acayearterm=="`var'"
	outreg2 using "$outputs/`var'ESTANDARNIVEMATE.doc", label bdec(3) sdec(3) ctitle(`var' control) append  
*ESTANDARALL	
reg notasolonumero estandar_Neuro estandar_Extrav estandar_Aperex estandar_Amab estandar_Resp estandar_Neuro_salon estandar_Extrav_salon estandar_Aperex_salon estandar_Amab_salon estandar_Resp_salon i.nombre_curso if cachimbo==1 & acayearterm=="`var'"
	outreg2 using "$outputs/`var'ESTANDARALL.doc", label bdec(3) sdec(3) ctitle(`var') replace
reg notasolonumero estandar_Neuro estandar_Extrav estandar_Aperex estandar_Amab estandar_Resp estandar_Neuro_salon estandar_Extrav_salon estandar_Aperex_salon estandar_Amab_salon estandar_Resp_salon i.nombre_curso nota_docente if cachimbo==1 & acayearterm=="`var'"
	outreg2 using "$outputs/`var'ESTANDARALL.doc", label bdec(3) sdec(3) ctitle(`var' control) append  

}



reg notasolonumero estandar_Neuro estandar_Extrav estandar_Aperex estandar_Amab estandar_Resp estandar_Neuro_salon estandar_Extrav_salon estandar_Aperex_salon estandar_Amab_salon estandar_Resp_salon nota_docente i.acayearterm_ nota_docente if cachimbo==1
outreg2 using "$outputs/ALLYEARSCOURSES.doc", label bdec(3) sdec(3) ctitle(model 1) replace





*ECO1
reg notasolonumero Neuro Extrav Aperex Amab Resp Neuro_salon Extrav_salon Aperex_salon Amab_salon Resp_salon nota_docente if cachimbo==1 & nombre_curso==238 & acayearterm=="2020-I PER"
    outreg2 using "$outpuyears/ECO1.doc", label bdec(3) sdec(3) ctitle(2020-I PER) replace
reg notasolonumero Neuro Extrav Aperex Amab Resp Neuro_salon Extrav_salon Aperex_salon Amab_salon Resp_salon nota_docente if cachimbo==1 & nombre_curso==238 & acayearterm=="2021-I PER"
	outreg2 using "$outpuyears/ECO1.doc", label bdec(3) sdec(3) ctitle(2021-I PER) append  
reg notasolonumero Neuro Extrav Aperex Amab Resp Neuro_salon Extrav_salon Aperex_salon Amab_salon Resp_salon nota_docente if cachimbo==1 & nombre_curso==238 & acayearterm=="2022-I PER"
	outreg2 using "$outpuyears/ECO1.doc", label bdec(3) sdec(3) ctitle(2022-I PER) append  
reg notasolonumero Neuro Extrav Aperex Amab Resp Neuro_salon Extrav_salon Aperex_salon Amab_salon Resp_salon nota_docente if cachimbo==1 & nombre_curso==238 & acayearterm=="2023-I PER"
	outreg2 using "$outpuyears/ECO1.doc", label bdec(3) sdec(3) ctitle(2023-I PER) append  

*NIVELENGUA
reg notasolonumero Neuro Extrav Aperex Amab Resp Neuro_salon Extrav_salon Aperex_salon Amab_salon Resp_salon nota_docente if cachimbo==1 & nombre_curso==617 & acayearterm=="2020-I PER"
    outreg2 using "$outpuyears/NIVELENGUA.doc", label bdec(3) sdec(3) ctitle(2020-I PER) replace
reg notasolonumero Neuro Extrav Aperex Amab Resp Neuro_salon Extrav_salon Aperex_salon Amab_salon Resp_salon nota_docente if cachimbo==1 & nombre_curso==617 & acayearterm=="2021-I PER"
	outreg2 using "$outpuyears/NIVELENGUA.doc", label bdec(3) sdec(3) ctitle(2021-I PER) append  
reg notasolonumero Neuro Extrav Aperex Amab Resp Neuro_salon Extrav_salon Aperex_salon Amab_salon Resp_salon nota_docente if cachimbo==1 & nombre_curso==617 & acayearterm=="2022-I PER"
	outreg2 using "$outpuyears/NIVELENGUA.doc", label bdec(3) sdec(3) ctitle(2022-I PER) append  
reg notasolonumero Neuro Extrav Aperex Amab Resp Neuro_salon Extrav_salon Aperex_salon Amab_salon Resp_salon nota_docente if cachimbo==1 & nombre_curso==617 & acayearterm=="2023-I PER"
	outreg2 using "$outpuyears/NIVELENGUA.doc", label bdec(3) sdec(3) ctitle(2023-I PER) append  
*NIVEMATE
reg notasolonumero Neuro Extrav Aperex Amab Resp Neuro_salon Extrav_salon Aperex_salon Amab_salon Resp_salon nota_docente if cachimbo==1 & nombre_curso==618 & acayearterm=="2020-I PER"
    outreg2 using "$outpuyears/NIVEMATE.doc", label bdec(3) sdec(3) ctitle(2020-I PER) replace
reg notasolonumero Neuro Extrav Aperex Amab Resp Neuro_salon Extrav_salon Aperex_salon Amab_salon Resp_salon nota_docente if cachimbo==1 & nombre_curso==618 & acayearterm=="2021-I PER"
	outreg2 using "$outpuyears/NIVEMATE.doc", label bdec(3) sdec(3) ctitle(2021-I PER) append  
reg notasolonumero Neuro Extrav Aperex Amab Resp Neuro_salon Extrav_salon Aperex_salon Amab_salon Resp_salon nota_docente if cachimbo==1 & nombre_curso==618 & acayearterm=="2022-I PER"
	outreg2 using "$outpuyears/NIVEMATE.doc", label bdec(3) sdec(3) ctitle(2022-I PER) append  
reg notasolonumero Neuro Extrav Aperex Amab Resp Neuro_salon Extrav_salon Aperex_salon Amab_salon Resp_salon nota_docente if cachimbo==1 & nombre_curso==618 & acayearterm=="2023-I PER"
	outreg2 using "$outpuyears/NIVEMATE.doc", label bdec(3) sdec(3) ctitle(2023-I PER) append  





**NOCONTROL
*ECO1
reg notasolonumero Neuro Extrav Aperex Amab Resp Neuro_salon Extrav_salon Aperex_salon Amab_salon Resp_salon  if cachimbo==1 & nombre_curso==238 & acayearterm=="2020-I PER"
    outreg2 using "$outpuyearsnocontrol/ECO1.doc", label bdec(3) sdec(3) ctitle(2020-I PER) replace
reg notasolonumero Neuro Extrav Aperex Amab Resp Neuro_salon Extrav_salon Aperex_salon Amab_salon Resp_salon  if cachimbo==1 & nombre_curso==238 & acayearterm=="2021-I PER"
	outreg2 using "$outpuyearsnocontrol/ECO1.doc", label bdec(3) sdec(3) ctitle(2021-I PER) append  
reg notasolonumero Neuro Extrav Aperex Amab Resp Neuro_salon Extrav_salon Aperex_salon Amab_salon Resp_salon  if cachimbo==1 & nombre_curso==238 & acayearterm=="2022-I PER"
	outreg2 using "$outpuyearsnocontrol/ECO1.doc", label bdec(3) sdec(3) ctitle(2022-I PER) append  
reg notasolonumero Neuro Extrav Aperex Amab Resp Neuro_salon Extrav_salon Aperex_salon Amab_salon Resp_salon  if cachimbo==1 & nombre_curso==238 & acayearterm=="2023-I PER"
	outreg2 using "$outpuyearsnocontrol/ECO1.doc", label bdec(3) sdec(3) ctitle(2023-I PER) append  

*NIVELENGUA
reg notasolonumero Neuro Extrav Aperex Amab Resp Neuro_salon Extrav_salon Aperex_salon Amab_salon Resp_salon  if cachimbo==1 & nombre_curso==617 & acayearterm=="2020-I PER"
    outreg2 using "$outpuyearsnocontrol/NIVELENGUA.doc", label bdec(3) sdec(3) ctitle(2020-I PER) replace
reg notasolonumero Neuro Extrav Aperex Amab Resp Neuro_salon Extrav_salon Aperex_salon Amab_salon Resp_salon  if cachimbo==1 & nombre_curso==617 & acayearterm=="2021-I PER"
	outreg2 using "$outpuyearsnocontrol/NIVELENGUA.doc", label bdec(3) sdec(3) ctitle(2021-I PER) append  
reg notasolonumero Neuro Extrav Aperex Amab Resp Neuro_salon Extrav_salon Aperex_salon Amab_salon Resp_salon  if cachimbo==1 & nombre_curso==617 & acayearterm=="2022-I PER"
	outreg2 using "$outpuyearsnocontrol/NIVELENGUA.doc", label bdec(3) sdec(3) ctitle(2022-I PER) append  
reg notasolonumero Neuro Extrav Aperex Amab Resp Neuro_salon Extrav_salon Aperex_salon Amab_salon Resp_salon  if cachimbo==1 & nombre_curso==617 & acayearterm=="2023-I PER"
	outreg2 using "$outpuyearsnocontrol/NIVELENGUA.doc", label bdec(3) sdec(3) ctitle(2023-I PER) append  
*NIVEMATE
reg notasolonumero Neuro Extrav Aperex Amab Resp Neuro_salon Extrav_salon Aperex_salon Amab_salon Resp_salon  if cachimbo==1 & nombre_curso==618 & acayearterm=="2020-I PER"
    outreg2 using "$outpuyearsnocontrol/NIVEMATE.doc", label bdec(3) sdec(3) ctitle(2020-I PER) replace
reg notasolonumero Neuro Extrav Aperex Amab Resp Neuro_salon Extrav_salon Aperex_salon Amab_salon Resp_salon  if cachimbo==1 & nombre_curso==618 & acayearterm=="2021-I PER"
	outreg2 using "$outpuyearsnocontrol/NIVEMATE.doc", label bdec(3) sdec(3) ctitle(2021-I PER) append  
reg notasolonumero Neuro Extrav Aperex Amab Resp Neuro_salon Extrav_salon Aperex_salon Amab_salon Resp_salon  if cachimbo==1 & nombre_curso==618 & acayearterm=="2022-I PER"
	outreg2 using "$outpuyearsnocontrol/NIVEMATE.doc", label bdec(3) sdec(3) ctitle(2022-I PER) append  
reg notasolonumero Neuro Extrav Aperex Amab Resp Neuro_salon Extrav_salon Aperex_salon Amab_salon Resp_salon  if cachimbo==1 & nombre_curso==618 & acayearterm=="2023-I PER"
	outreg2 using "$outpuyearsnocontrol/NIVEMATE.doc", label bdec(3) sdec(3) ctitle(2023-I PER) append  
	
	
**ESTANDAR	
*ECO1
reg notasolonumero estandar_Neuro estandar_Extrav estandar_Aperex estandar_Amab estandar_Resp estandar_Neuro_salon estandar_Extrav_salon estandar_Aperex_salon estandar_Amab_salon estandar_Resp_salon nota_docente if cachimbo==1 & nombre_curso==238 & acayearterm=="2020-I PER"
    outreg2 using "$outputstd/ECO1.doc", label bdec(3) sdec(3) ctitle(2020-I PER) replace
reg notasolonumero estandar_Neuro estandar_Extrav estandar_Aperex estandar_Amab estandar_Resp estandar_Neuro_salon estandar_Extrav_salon estandar_Aperex_salon estandar_Amab_salon estandar_Resp_salon nota_docente if cachimbo==1 & nombre_curso==238 & acayearterm=="2021-I PER"
	outreg2 using "$outputstd/ECO1.doc", label bdec(3) sdec(3) ctitle(2021-I PER) append  
reg notasolonumero estandar_Neuro estandar_Extrav estandar_Aperex estandar_Amab estandar_Resp estandar_Neuro_salon estandar_Extrav_salon estandar_Aperex_salon estandar_Amab_salon estandar_Resp_salon nota_docente if cachimbo==1 & nombre_curso==238 & acayearterm=="2022-I PER"
	outreg2 using "$outputstd/ECO1.doc", label bdec(3) sdec(3) ctitle(2022-I PER) append  
reg notasolonumero estandar_Neuro estandar_Extrav estandar_Aperex estandar_Amab estandar_Resp estandar_Neuro_salon estandar_Extrav_salon estandar_Aperex_salon estandar_Amab_salon estandar_Resp_salon nota_docente if cachimbo==1 & nombre_curso==238 & acayearterm=="2023-I PER"
	outreg2 using "$outputstd/ECO1.doc", label bdec(3) sdec(3) ctitle(2023-I PER) append  
*NIVELENGUA
reg notasolonumero estandar_Neuro estandar_Extrav estandar_Aperex estandar_Amab estandar_Resp estandar_Neuro_salon estandar_Extrav_salon estandar_Aperex_salon estandar_Amab_salon estandar_Resp_salon nota_docente if cachimbo==1 & nombre_curso==617 & acayearterm=="2020-I PER"
    outreg2 using "$outputstd/NIVELENGUA.doc", label bdec(3) sdec(3) ctitle(2020-I PER) replace
reg notasolonumero estandar_Neuro estandar_Extrav estandar_Aperex estandar_Amab estandar_Resp estandar_Neuro_salon estandar_Extrav_salon estandar_Aperex_salon estandar_Amab_salon estandar_Resp_salon nota_docente if cachimbo==1 & nombre_curso==617 & acayearterm=="2021-I PER"
	outreg2 using "$outputstd/NIVELENGUA.doc", label bdec(3) sdec(3) ctitle(2021-I PER) append  
reg notasolonumero estandar_Neuro estandar_Extrav estandar_Aperex estandar_Amab estandar_Resp estandar_Neuro_salon estandar_Extrav_salon estandar_Aperex_salon estandar_Amab_salon estandar_Resp_salon nota_docente if cachimbo==1 & nombre_curso==617 & acayearterm=="2022-I PER"
	outreg2 using "$outputstd/NIVELENGUA.doc", label bdec(3) sdec(3) ctitle(2022-I PER) append  
reg notasolonumero estandar_Neuro estandar_Extrav estandar_Aperex estandar_Amab estandar_Resp estandar_Neuro_salon estandar_Extrav_salon estandar_Aperex_salon estandar_Amab_salon estandar_Resp_salon nota_docente if cachimbo==1 & nombre_curso==617 & acayearterm=="2023-I PER"
	outreg2 using "$outputstd/NIVELENGUA.doc", label bdec(3) sdec(3) ctitle(2023-I PER) append  
*NIVEMATE
reg notasolonumero estandar_Neuro estandar_Extrav estandar_Aperex estandar_Amab estandar_Resp estandar_Neuro_salon estandar_Extrav_salon estandar_Aperex_salon estandar_Amab_salon estandar_Resp_salon nota_docente if cachimbo==1 & nombre_curso==618 & acayearterm=="2020-I PER"
    outreg2 using "$outputstd/NIVEMATE.doc", label bdec(3) sdec(3) ctitle(2020-I PER) replace
reg notasolonumero estandar_Neuro estandar_Extrav estandar_Aperex estandar_Amab estandar_Resp estandar_Neuro_salon estandar_Extrav_salon estandar_Aperex_salon estandar_Amab_salon estandar_Resp_salon nota_docente if cachimbo==1 & nombre_curso==618 & acayearterm=="2021-I PER"
	outreg2 using "$outputstd/NIVEMATE.doc", label bdec(3) sdec(3) ctitle(2021-I PER) append  
reg notasolonumero estandar_Neuro estandar_Extrav estandar_Aperex estandar_Amab estandar_Resp estandar_Neuro_salon estandar_Extrav_salon estandar_Aperex_salon estandar_Amab_salon estandar_Resp_salon nota_docente if cachimbo==1 & nombre_curso==618 & acayearterm=="2022-I PER"
	outreg2 using "$outputstd/NIVEMATE.doc", label bdec(3) sdec(3) ctitle(2022-I PER) append  
reg notasolonumero estandar_Neuro estandar_Extrav estandar_Aperex estandar_Amab estandar_Resp estandar_Neuro_salon estandar_Extrav_salon estandar_Aperex_salon estandar_Amab_salon estandar_Resp_salon nota_docente if cachimbo==1 & nombre_curso==618 & acayearterm=="2023-I PER"
	outreg2 using "$outputstd/NIVEMATE.doc", label bdec(3) sdec(3) ctitle(2023-I PER) append  
	
	

	
*FE YEAR
reg notasolonumero estandar_Neuro estandar_Extrav estandar_Aperex estandar_Amab estandar_Resp estandar_Neuro_salon estandar_Extrav_salon estandar_Aperex_salon estandar_Amab_salon estandar_Resp_salon nota_docente i.acayearterm_ if cachimbo==1 & nombre_curso==238 	
    outreg2 using "$outputstd/feyear.doc", label bdec(3) sdec(3) ctitle(Eco1) replace
reg notasolonumero estandar_Neuro estandar_Extrav estandar_Aperex estandar_Amab estandar_Resp estandar_Neuro_salon estandar_Extrav_salon estandar_Aperex_salon estandar_Amab_salon estandar_Resp_salon nota_docente i.acayearterm_ if cachimbo==1 & nombre_curso==618 
	outreg2 using "$outputstd/feyear.doc", label bdec(3) sdec(3) ctitle(Nive lengua) append  
reg notasolonumero estandar_Neuro estandar_Extrav estandar_Aperex estandar_Amab estandar_Resp estandar_Neuro_salon estandar_Extrav_salon estandar_Aperex_salon estandar_Amab_salon estandar_Resp_salon nota_docente i.acayearterm_ if cachimbo==1 & nombre_curso==617 
	outreg2 using "$outputstd/feyear.doc", label bdec(3) sdec(3) ctitle(Nive mate) append  

*FE YEAR/ COURSES
reg notasolonumero estandar_Neuro estandar_Extrav estandar_Aperex estandar_Amab estandar_Resp estandar_Neuro_salon estandar_Extrav_salon estandar_Aperex_salon estandar_Amab_salon estandar_Resp_salon nota_docente i.acayearterm_ i.nombre_curso if cachimbo==1 
    outreg2 using "$outputstd/feyearcourses.doc", label bdec(3) sdec(3) ctitle(All) replace
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	

