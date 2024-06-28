clear all
global bases "C:\Users\Erzo\OneDrive - Universidad del Pacífico\Univesidad del Pacífico\Ciclo\lCiclo 7 2024 I\Asistente\Big5\Hasta_2023\Bases"
global outputs "C:\Users\Erzo\OneDrive - Universidad del Pacífico\Univesidad del Pacífico\Ciclo\lCiclo 7 2024 I\Asistente\Big5\Peer effects classrooms\Regress"
global outpuyears "C:\Users\Erzo\OneDrive - Universidad del Pacífico\Univesidad del Pacífico\Ciclo\lCiclo 7 2024 I\Asistente\Big5\Peer effects classrooms\Regress\Byyear"
global outpuyearsnocontrol "C:\Users\Erzo\OneDrive - Universidad del Pacífico\Univesidad del Pacífico\Ciclo\lCiclo 7 2024 I\Asistente\Big5\Peer effects classrooms\Regress\Byyear_nocontrol"
global outputstd "C:\Users\Erzo\OneDrive - Universidad del Pacífico\Univesidad del Pacífico\Ciclo\lCiclo 7 2024 I\Asistente\Big5\Peer effects classrooms\Regress\Byyear_std"
use "$bases/salones", clear

merge 1:1 cod acayearterm NOMBRE_DEL_CURSO using "$bases/notas_cod_sem", nogen keep(3)


*Variables:
*EDAD_INGRESO / Mujer / NUMERO_HERMANOS / NUMERO_HERMANOS_EN_LA_UP / BACHILLERATO_INTERNACIONAL / COLEGIO_DE_ALTO_RENDIMIENTO / MODALIDAD_DE_ADMISION /ESCALAS/ CARRERAS
encode GENERO, gen(Mujer)
recode Mujer (1=1 "F") (2=0 "M"), gen (Mujer_)
drop Mujer
rename Mujer_ Mujer
**
gen N_hermanos=real(NUMERO_HERMANOS)
gen N_hermanos_UP=real(NUMERO_HERMANOS_EN_LA_UP)
**
encode BACHILLERATO_INTERNACIONAL , gen(IB)
recode IB (2=1 "SI") (1=0 "NO"), gen (IB_)
drop IB
rename IB_ IB
**
encode COLEGIO_DE_ALTO_RENDIMIENTO, gen(CAr)
recode CAr (2=1 "SI") (1=0 "NO"), gen (CAr_)
drop CAr
rename CAr_ CAr
**
encode MODALIDAD_DE_ADMISION, gen(Modalidad_admisión)
**
encode  ESCALA_DE_PAGO_INICIAL, gen(escalas)
**
encode CARRERA, gen(carreras)
**
encode salon, gen(salones)
**eco1=238
**nivelengua=617
**nivemate=618

sort salones
bys salones: gen N_K=sum(cachimbo)


reg N_hermanos_UP i.salones if acayearterm_==5 & nombre_curso==618 & cachimbo==1

local a=Ftail(e(df_m), e(df_r), e(F))
di `a'
*TODOS LOS SALONES
**ECO1	
local a=2020
foreach i in 3 5 7 9{
matrix define f_pval`i'= J(9,6, .)
local m 1
foreach j in 238 617 618{
if `j'==238{
local c="ECO1"
}
if `j'==617{
local c="N_Lengua"
}
if `j'==618{
local c="N_Mate"
}
reg EDAD_INGRESO i.salones if acayearterm_==`i' & nombre_curso==`j' & cachimbo==1
matrix f_pval`i'[1,`m']= Ftail(e(df_m), e(df_r), e(F))
reg Mujer i.salones if acayearterm_==`i' & nombre_curso==`j' & cachimbo==1
matrix f_pval`i'[2,`m']= Ftail(e(df_m), e(df_r), e(F))
reg N_hermanos i.salones if acayearterm_==`i' & nombre_curso==`j' & cachimbo==1
matrix f_pval`i'[3,`m']= Ftail(e(df_m), e(df_r), e(F))
reg N_hermanos_UP i.salones if acayearterm_==`i' & nombre_curso==`j' & cachimbo==1
matrix f_pval`i'[4,`m']= Ftail(e(df_m), e(df_r), e(F))
reg IB i.salones if acayearterm_==`i' & nombre_curso==`j' & cachimbo==1
matrix f_pval`i'[5,`m']= Ftail(e(df_m), e(df_r), e(F))
reg CAr i.salones if acayearterm_==`i' & nombre_curso==`j' & cachimbo==1
matrix f_pval`i'[6,`m']= Ftail(e(df_m), e(df_r), e(F))
reg Modalidad_admisión i.salones if acayearterm_==`i' & nombre_curso==`j' & cachimbo==1
matrix f_pval`i'[7,`m']= Ftail(e(df_m), e(df_r), e(F))
reg escalas i.salones if acayearterm_==`i' & nombre_curso==`j' & cachimbo==1
matrix f_pval`i'[8,`m']= Ftail(e(df_m), e(df_r), e(F))
reg carreras i.salones if acayearterm_==`i' & nombre_curso==`j' & cachimbo==1
matrix f_pval`i'[9,`m']= Ftail(e(df_m), e(df_r), e(F))

reg EDAD_INGRESO i.salones if acayearterm_==`i' & nombre_curso==`j' & cachimbo==1 & N_K>=18
matrix f_pval`i'[1,3+`m']= Ftail(e(df_m), e(df_r), e(F))
reg Mujer i.salones if acayearterm_==`i' & nombre_curso==`j' & cachimbo==1 & N_K>=18
matrix f_pval`i'[2,3+`m']= Ftail(e(df_m), e(df_r), e(F))
reg N_hermanos i.salones if acayearterm_==`i' & nombre_curso==`j' & cachimbo==1 & N_K>=18
matrix f_pval`i'[3,3+`m']= Ftail(e(df_m), e(df_r), e(F))
reg N_hermanos_UP i.salones if acayearterm_==`i' & nombre_curso==`j' & cachimbo==1 & N_K>=18
matrix f_pval`i'[4,3+`m']= Ftail(e(df_m), e(df_r), e(F))
reg IB i.salones if acayearterm_==`i' & nombre_curso==`j' & cachimbo==1 & N_K>=18
matrix f_pval`i'[5,3+`m']= Ftail(e(df_m), e(df_r), e(F))
reg CAr i.salones if acayearterm_==`i' & nombre_curso==`j' & cachimbo==1 & N_K>=18
matrix f_pval`i'[6,3+`m']= Ftail(e(df_m), e(df_r), e(F))
reg Modalidad_admisión i.salones if acayearterm_==`i' & nombre_curso==`j' & cachimbo==1 & N_K>=18
matrix f_pval`i'[7,3+`m']= Ftail(e(df_m), e(df_r), e(F))
reg escalas i.salones if acayearterm_==`i' & nombre_curso==`j' & cachimbo==1 & N_K>=18
matrix f_pval`i'[8,3+`m']= Ftail(e(df_m), e(df_r), e(F))
reg carreras i.salones if acayearterm_==`i' & nombre_curso==`j' & cachimbo==1 & N_K>=18
matrix f_pval`i'[9,3+`m']= Ftail(e(df_m), e(df_r), e(F))
matrix list f_pval`i'
local m=`m'+1

}
local k="`a'"  

putexcel set  "C:\Users\Erzo\OneDrive - Universidad del Pacífico\Univesidad del Pacífico\Ciclo\lCiclo 7 2024 I\Asistente\Big5\Peer effects classrooms\F_Test\K\Test_`k'", modify
putexcel B2=matrix(f_pval`i')
putexcel A2="Edad_ingreso"
putexcel A3="Mujer"
putexcel A4="N_hermanos"
putexcel A5="N_hermanosUP"
putexcel A6="IB"
putexcel A7="CAr"
putexcel A8="Modalidad_admisión"
putexcel A9="Escalas"
putexcel A10="Carrera"
putexcel B1="Eco1_todos"
putexcel C1="N_Lengua_todos"
putexcel D1="N_Mate_todos"
putexcel E1="Eco1_>18"
putexcel F1="N_Lengua_>18"
putexcel G1="N_Mate_>18"
local a=`a'+1
}





******************************************************************************************************************Todos, cachimbo y no caahcimbo


*TODOS LOS SALONES
**ECO1
local a=2020
foreach i in 3 5 7 9{
matrix define f_pval`i'= J(9,6, .)
local m 1
foreach j in 238 617 618{
if `j'==238{
local c="ECO1"
}
if `j'==617{
local c="N_Lengua"
}
if `j'==618{
local c="N_Mate"
}
reg EDAD_INGRESO i.salones if acayearterm_==`i' & nombre_curso==`j'  
matrix f_pval`i'[1,`m']= Ftail(e(df_m), e(df_r), e(F))
reg Mujer i.salones if acayearterm_==`i' & nombre_curso==`j'  
matrix f_pval`i'[2,`m']= Ftail(e(df_m), e(df_r), e(F))
reg N_hermanos i.salones if acayearterm_==`i' & nombre_curso==`j'  
matrix f_pval`i'[3,`m']= Ftail(e(df_m), e(df_r), e(F))
reg N_hermanos_UP i.salones if acayearterm_==`i' & nombre_curso==`j' 
matrix f_pval`i'[4,`m']= Ftail(e(df_m), e(df_r), e(F))
reg IB i.salones if acayearterm_==`i' & nombre_curso==`j' 
matrix f_pval`i'[5,`m']= Ftail(e(df_m), e(df_r), e(F))
reg CAr i.salones if acayearterm_==`i' & nombre_curso==`j'  
matrix f_pval`i'[6,`m']= Ftail(e(df_m), e(df_r), e(F))
reg Modalidad_admisión i.salones if acayearterm_==`i' & nombre_curso==`j'  
matrix f_pval`i'[7,`m']= Ftail(e(df_m), e(df_r), e(F))
reg escalas i.salones if acayearterm_==`i' & nombre_curso==`j'  
matrix f_pval`i'[8,`m']= Ftail(e(df_m), e(df_r), e(F))
reg carreras i.salones if acayearterm_==`i' & nombre_curso==`j' 
matrix f_pval`i'[9,`m']= Ftail(e(df_m), e(df_r), e(F))

reg EDAD_INGRESO i.salones if acayearterm_==`i' & nombre_curso==`j' & N_K>=18
matrix f_pval`i'[1,3+`m']= Ftail(e(df_m), e(df_r), e(F))
reg Mujer i.salones if acayearterm_==`i' & nombre_curso==`j' & N_K>=18
matrix f_pval`i'[2,3+`m']= Ftail(e(df_m), e(df_r), e(F))
reg N_hermanos i.salones if acayearterm_==`i' & nombre_curso==`j' & N_K>=18
matrix f_pval`i'[3,3+`m']= Ftail(e(df_m), e(df_r), e(F))
reg N_hermanos_UP i.salones if acayearterm_==`i' & nombre_curso==`j' & N_K>=18
matrix f_pval`i'[4,3+`m']= Ftail(e(df_m), e(df_r), e(F))
reg IB i.salones if acayearterm_==`i' & nombre_curso==`j' & N_K>=18
matrix f_pval`i'[5,3+`m']= Ftail(e(df_m), e(df_r), e(F))
reg CAr i.salones if acayearterm_==`i' & nombre_curso==`j' & N_K>=18
matrix f_pval`i'[6,3+`m']= Ftail(e(df_m), e(df_r), e(F))
reg Modalidad_admisión i.salones if acayearterm_==`i' & nombre_curso==`j' & N_K>=18
matrix f_pval`i'[7,3+`m']= Ftail(e(df_m), e(df_r), e(F))
reg escalas i.salones if acayearterm_==`i' & nombre_curso==`j' & N_K>=18
matrix f_pval`i'[8,3+`m']= Ftail(e(df_m), e(df_r), e(F))
reg carreras i.salones if acayearterm_==`i' & nombre_curso==`j' & N_K>=18
matrix f_pval`i'[9,3+`m']= Ftail(e(df_m), e(df_r), e(F))
matrix list f_pval`i'
local m=`m'+1

}
local k="`a'"  

putexcel set  "C:\Users\Erzo\OneDrive - Universidad del Pacífico\Univesidad del Pacífico\Ciclo\lCiclo 7 2024 I\Asistente\Big5\Peer effects classrooms\F_Test\K_NoK\Test_`k'", modify
putexcel B2=matrix(f_pval`i')
putexcel A2="Edad_ingreso"
putexcel A3="Mujer"
putexcel A4="N_hermanos"
putexcel A5="N_hermanosUP"
putexcel A6="IB"
putexcel A7="CAr"
putexcel A8="Modalidad_admisión"
putexcel A9="Escalas"
putexcel A10="Carrera"
putexcel B1="Eco1_todos"
putexcel C1="N_Lengua_todos"
putexcel D1="N_Mate_todos"
putexcel E1="Eco1_>18"
putexcel F1="N_Lengua_>18"
putexcel G1="N_Mate_>18"
local a=`a'+1
}


















****************************************************************************************************
*TODOS LOS SALONES
**ECO1

matrix define f_pval= J(9,6, .)
local m 1
foreach j in 238 617 618{
reg EDAD_INGRESO i.salones if nombre_curso==`j'  
matrix f_pval[1,`m']= Ftail(e(df_m), e(df_r), e(F))
reg Mujer i.salones if nombre_curso==`j'  
matrix f_pval[2,`m']= Ftail(e(df_m), e(df_r), e(F))
reg N_hermanos i.salones if nombre_curso==`j'   
matrix f_pval[3,`m']= Ftail(e(df_m), e(df_r), e(F))
reg N_hermanos_UP i.salones if nombre_curso==`j'  
matrix f_pval[4,`m']= Ftail(e(df_m), e(df_r), e(F))
reg IB i.salones if nombre_curso==`j'  
matrix f_pval[5,`m']= Ftail(e(df_m), e(df_r), e(F))
reg CAr i.salones if nombre_curso==`j'  
matrix f_pval[6,`m']= Ftail(e(df_m), e(df_r), e(F))
reg Modalidad_admisión i.salones if nombre_curso==`j'  
matrix f_pval[7,`m']= Ftail(e(df_m), e(df_r), e(F))
reg escalas i.salones if nombre_curso==`j'  
matrix f_pval[8,`m']= Ftail(e(df_m), e(df_r), e(F))
reg carreras i.salones if nombre_curso==`j'  
matrix f_pval[9,`m']= Ftail(e(df_m), e(df_r), e(F))

reg EDAD_INGRESO i.salones if  nombre_curso==`j' & N_K>=18
matrix f_pval[1,3+`m']= Ftail(e(df_m), e(df_r), e(F))
reg Mujer i.salones if  nombre_curso==`j' & N_K>=18
matrix f_pval[2,3+`m']= Ftail(e(df_m), e(df_r), e(F))
reg N_hermanos i.salones if  nombre_curso==`j' & N_K>=18
matrix f_pval[3,3+`m']= Ftail(e(df_m), e(df_r), e(F))
reg N_hermanos_UP i.salones if  nombre_curso==`j' & N_K>=18
matrix f_pval[4,3+`m']= Ftail(e(df_m), e(df_r), e(F))
reg IB i.salones if  nombre_curso==`j' & N_K>=18
matrix f_pval[5,3+`m']= Ftail(e(df_m), e(df_r), e(F))
reg CAr i.salones if  nombre_curso==`j' & N_K>=18
matrix f_pval[6,3+`m']= Ftail(e(df_m), e(df_r), e(F))
reg Modalidad_admisión i.salones if  nombre_curso==`j' & N_K>=18
matrix f_pval[7,3+`m']= Ftail(e(df_m), e(df_r), e(F))
reg escalas i.salones if  nombre_curso==`j' & N_K>=18
matrix f_pval[8,3+`m']= Ftail(e(df_m), e(df_r), e(F))
reg carreras i.salones if  nombre_curso==`j' & N_K>=18
matrix f_pval[9,3+`m']= Ftail(e(df_m), e(df_r), e(F))
matrix list f_pval
local m=`m'+1

}

putexcel set  "C:\Users\Erzo\OneDrive - Universidad del Pacífico\Univesidad del Pacífico\Ciclo\lCiclo 7 2024 I\Asistente\Big5\Peer effects classrooms\F_Test\Test_All", modify
putexcel B2=matrix(f_pval)
putexcel A2="Edad_ingreso"
putexcel A3="Mujer"
putexcel A4="N_hermanos"
putexcel A5="N_hermanosUP"
putexcel A6="IB"
putexcel A7="CAr"
putexcel A8="Modalidad_admisión"
putexcel A9="Escalas"
putexcel A10="Carrera"
putexcel B1="Eco1_todos"
putexcel C1="N_Lengua_todos"
putexcel D1="N_Mate_todos"
putexcel E1="Eco1_>18"
putexcel F1="N_Lengua_>18"
putexcel G1="N_Mate_>18"






*************************************************CACHIMBOS
matrix define f_pval= J(9,6, .)
local m 1
foreach j in 238 617 618{
reg EDAD_INGRESO i.salones if nombre_curso==`j'  & cachimbo==1
matrix f_pval[1,`m']= Ftail(e(df_m), e(df_r), e(F))
reg Mujer i.salones if nombre_curso==`j'   & cachimbo==1
matrix f_pval[2,`m']= Ftail(e(df_m), e(df_r), e(F))
reg N_hermanos i.salones if nombre_curso==`j'  & cachimbo==1  
matrix f_pval[3,`m']= Ftail(e(df_m), e(df_r), e(F))
reg N_hermanos_UP i.salones if nombre_curso==`j'   & cachimbo==1
matrix f_pval[4,`m']= Ftail(e(df_m), e(df_r), e(F))
reg IB i.salones if nombre_curso==`j'   & cachimbo==1
matrix f_pval[5,`m']= Ftail(e(df_m), e(df_r), e(F))
reg CAr i.salones if nombre_curso==`j'  & cachimbo==1
matrix f_pval[6,`m']= Ftail(e(df_m), e(df_r), e(F))
reg Modalidad_admisión i.salones if nombre_curso==`j'  
matrix f_pval[7,`m']= Ftail(e(df_m), e(df_r), e(F))
reg escalas i.salones if nombre_curso==`j' & cachimbo==1 
matrix f_pval[8,`m']= Ftail(e(df_m), e(df_r), e(F))
reg carreras i.salones if nombre_curso==`j'  & cachimbo==1
matrix f_pval[9,`m']= Ftail(e(df_m), e(df_r), e(F))

reg EDAD_INGRESO i.salones if  nombre_curso==`j' & N_K>=18 & cachimbo==1
matrix f_pval[1,3+`m']= Ftail(e(df_m), e(df_r), e(F))
reg Mujer i.salones if  nombre_curso==`j' & N_K>=18 & cachimbo==1
matrix f_pval[2,3+`m']= Ftail(e(df_m), e(df_r), e(F))
reg N_hermanos i.salones if  nombre_curso==`j' & N_K>=18 & cachimbo==1
matrix f_pval[3,3+`m']= Ftail(e(df_m), e(df_r), e(F))
reg N_hermanos_UP i.salones if  nombre_curso==`j' & N_K>=18 & cachimbo==1
matrix f_pval[4,3+`m']= Ftail(e(df_m), e(df_r), e(F))
reg IB i.salones if  nombre_curso==`j' & N_K>=18 & cachimbo==1
matrix f_pval[5,3+`m']= Ftail(e(df_m), e(df_r), e(F))
reg CAr i.salones if  nombre_curso==`j' & N_K>=18 & cachimbo==1
matrix f_pval[6,3+`m']= Ftail(e(df_m), e(df_r), e(F))
reg Modalidad_admisión i.salones if  nombre_curso==`j' & N_K>=18 & cachimbo==1
matrix f_pval[7,3+`m']= Ftail(e(df_m), e(df_r), e(F))
reg escalas i.salones if  nombre_curso==`j' & N_K>=18 & cachimbo==1
matrix f_pval[8,3+`m']= Ftail(e(df_m), e(df_r), e(F))
reg carreras i.salones if  nombre_curso==`j' & N_K>=18 & cachimbo==1
matrix f_pval[9,3+`m']= Ftail(e(df_m), e(df_r), e(F))
matrix list f_pval
local m=`m'+1

}

putexcel set  "C:\Users\Erzo\OneDrive - Universidad del Pacífico\Univesidad del Pacífico\Ciclo\lCiclo 7 2024 I\Asistente\Big5\Peer effects classrooms\F_Test\Test_Cachimbos", modify
putexcel B2=matrix(f_pval)
putexcel A2="Edad_ingreso"
putexcel A3="Mujer"
putexcel A4="N_hermanos"
putexcel A5="N_hermanosUP"
putexcel A6="IB"
putexcel A7="CAr"
putexcel A8="Modalidad_admisión"
putexcel A9="Escalas"
putexcel A10="Carrera"
putexcel B1="Eco1_todos"
putexcel C1="N_Lengua_todos"
putexcel D1="N_Mate_todos"
putexcel E1="Eco1_>18"
putexcel F1="N_Lengua_>18"
putexcel G1="N_Mate_>18"









