clear all
set more off
global bases "C:\Users\Erzo\OneDrive - Universidad del Pacífico\Univesidad del Pacífico\Ciclo\lCiclo 7 2024 I\Asistente\Big5\Hasta_2023\Bases"
use "$bases/baseregresion", clear

***gpa=alfa+alfa1*NEURO+alfa2*EXTRAV+alfa3*APEREX+alfa4*AGREE+alfa5*CONCIENT+aCICLO1+bCICLO2+cCICLO3+...+nCICLON //solo para los cuales coincide su primersem con su primer registro
sort cod acayearterm1
by cod: gen periefectivo = acayearterm1[1]
*el que me da la BD es perinoefectivo
gen perinoefectivo= primersem2

gen coincide=0
replace coincide=1 if perinoefectivo==periefectivo

gen primerciclo=0
replace primerciclo=1 if acayearterm1==perinoefectivo

tab primerciclo
tab primerciclo if coincide==1

gen promciclo1=.
replace promciclo1=primerciclo*promedio_ciclo
by cod:egen prom1ciclo=total(promciclo1)

gen segundociclo=0
replace segundociclo=1 if acayearterm1==perinoefectivo+1


tab segundociclo
tab segundociclo if coincide==1


*************************************************************BIG5****************************************************************************
matrix define coefysd = J(30,5, .)	


local contador 1
local mi_lisstt estandar_Neuro estandar_Extrav estandar_Aperex estandar_Amab estandar_Resp
foreach var of local mi_lisstt {
reg  promedio_ciclo c.estandar_Neuro##i.primersem2 c.estandar_Extrav##i.primersem2 c.estandar_Aperex##i.primersem2 c.estandar_Amab##i.primersem2 c.estandar_Resp##i.primersem2   if coincide==1 & primerciclo==1,robust

forvalues j=1/10{
			lincom `var' + `j' .primersem2#c.`var'
			local valor = r(estimate)
			matrix coefysd[`j',`contador'] = `valor'
			
			matrix coefysd[11+(`j'-1)*2,`contador'] =r(lb)
			matrix coefysd[12+(`j'-1)*2,`contador'] =r(ub)
		}
local contador=`contador'+ 1
}  
	
	
	
	
***********PLOTEAR
global relacionciclos1 "C:\Users\Erzo\OneDrive - Universidad del Pacífico\Univesidad del Pacífico\Ciclo\lCiclo 7 2024 I\Asistente\Big5\Hasta_2023\Resultados\Relacion\Ciclos1"
local j 1
local palabras Neuro Extrav Aperex Amab Resp
foreach palabra in `palabras' {
	matrix define `palabra'=J(3,10,.)
	matrix rownames `palabra' = estimate ll95 ul95
	matrix colnames `palabra' = coh2019-I coh2019-II coh2020-I coh2020-II coh2021-I coh2021-II coh2022-I coh2022-II coh2023-I coh2023-II
	forvalues i=1/10{
	matrix `palabra'[1, `i']=coefysd[`i', `j' ]
	matrix `palabra'[2, `i']=coefysd[11+2*(`i'-1), `j' ]
    matrix `palabra'[3, `i']=coefysd[12+2*(`i'-1), `j' ]
    
}

    
    coefplot matrix(`palabra'), ci((2 3))  title("`palabra'Ciclos1") vertical mlabel(string(@b, "%5.2f") + " (" + string(@ll, "%5.2f") + "; " + string(@ul, 		"%5.2f") + ")") mlabposition(12) mlabsize(1.2) xlabel(, angle(45)) name(`palabra'`numero') xline(3, lcolor(red) lpattern(dash)) yline(0)
	
	graph export "$relacionciclos1/`palabra'.png", replace
	local j =`j'+1
}

*graph drop Neuro Extrav Aperex Amab Resp

*******************************************************************SIN2

global relacionciclos1sin2 "C:\Users\Erzo\OneDrive - Universidad del Pacífico\Univesidad del Pacífico\Ciclo\lCiclo 7 2024 I\Asistente\Big5\Hasta_2023\Resultados\Relacion\Ciclos1sin2"
local j 1
local palabras Neuro Extrav Aperex Amab Resp
foreach palabra in `palabras' {
	matrix define `palabra'c1=J(3,10,.)
	matrix rownames `palabra'c1 = estimate ll95 ul95
	matrix colnames `palabra'c1 = coh2019-I coh2019-II coh2020-I coh2020-II coh2021-I coh2021-II coh2022-I coh2022-II coh2023-I coh2023-II
	forvalues i=1/10{
	matrix `palabra'c1[1, `i']=coefysd[`i', `j' ]
	matrix `palabra'c1[2, `i']=coefysd[11+2*(`i'-1), `j' ]
    matrix `palabra'c1[3, `i']=coefysd[12+2*(`i'-1), `j' ]
    
}
matselrc `palabra'c1 `palabra'c1, col(1,3,5,7,9)
    
    coefplot matrix(`palabra'c1), ci((2 3))  title("`palabra'Ciclos1_sin_2_sem") vertical mlabel(string(@b, "%5.2f") + " (" + string(@ll, "%5.2f") + "; " + string(@ul, 		"%5.2f") + ")") mlabposition(12) mlabsize(1.2) xlabel(, angle(45)) name("`palabra'Ciclo1no2sem") xline(2, lcolor(red) lpattern(dash)) yline(0)
	
	graph export "$relacionciclos1sin2/`palabra'.png", replace
	local j =`j'+1
}


*graph drop Neuro_ Extrav_ Aperex_ Amab_ Resp_



**********************************************************************SUBCOMNEURO
matrix define coefysdneuro = J(30,6, .)	


local contador 1
local mi_lisstt estandar_Ansiedad estandar_Hostilid estandar_Depresion estandar_Ansiedad_S estandar_Impulsiv estandar_Vulnerab
foreach var of local mi_lisstt {
reg  promedio_ciclo c.estandar_Ansiedad##i.primersem2 c.estandar_Hostilid##i.primersem2 c.estandar_Depresion##i.primersem2 c.estandar_Ansiedad_S##i.primersem2 c.estandar_Impulsiv##i.primersem2 c.estandar_Vulnerab##i.primersem2 c.estandar_Extrav##i.primersem2 c.estandar_Aperex##i.primersem2 c.estandar_Amab##i.primersem2 c.estandar_Resp##i.primersem2   if coincide==1 & primerciclo==1,robust

forvalues j=1/10{
			lincom `var' + `j' .primersem2#c.`var'
			local valor = r(estimate)
			matrix coefysdneuro[`j',`contador'] = `valor'
			
			matrix coefysdneuro[11+(`j'-1)*2,`contador'] =r(lb)
			matrix coefysdneuro[12+(`j'-1)*2,`contador'] =r(ub)
		}
local contador=`contador'+ 1
	}  
	
       

global relacionsumcn "C:\Users\Erzo\OneDrive - Universidad del Pacífico\Univesidad del Pacífico\Ciclo\lCiclo 7 2024 I\Asistente\Big5\Hasta_2023\Resultados\Relacion\Subcomp\Neuro"
local j 1
local palabras Ansiedad Hostilid Depresion Ansiedad_S Impulsiv Vulnerab 
foreach palabra in `palabras' {
	matrix define `palabra'=J(3,10,.)
	matrix rownames `palabra' = estimate ll95 ul95
	matrix colnames `palabra' = coh2019-I coh2019-II coh2020-I coh2020-II coh2021-I coh2021-II coh2022-I coh2022-II coh2023-I coh2023-II
	forvalues i=1/10{
	matrix `palabra'[1, `i']=coefysdneuro[`i', `j' ]
	matrix `palabra'[2, `i']=coefysdneuro[11+2*(`i'-1), `j' ]
    matrix `palabra'[3, `i']=coefysdneuro[12+2*(`i'-1), `j' ]
    
}
matselrc `palabra' `palabra', col(1,3,5,7,9)
    
    coefplot matrix(`palabra'), ci((2 3))  title("`palabra'Ciclos1_sin_2_sem") vertical mlabel(string(@b, "%5.2f") + " (" + string(@ll, "%5.2f") + "; " + string(@ul, 		"%5.2f") + ")") mlabposition(12) mlabsize(1.2) xlabel(, angle(45)) name(`palabra') xline(2, lcolor(red) lpattern(dash)) yline(0)
	
	graph export "$relacionsumcn/`palabra'.png", replace
	local j =`j'+1
}


***************************************************************************SUBCOM RESP
matrix define coefysdresp = J(30,6, .)	


local contador 1
local mi_lisstt estandar_Compet estandar_Orden estandar_S_Deber estandar_N_Logro estandar_Autodis estandar_Delibera
foreach var of local mi_lisstt {
reg  promedio_ciclo c.estandar_Compet##i.primersem2 c.estandar_Orden##i.primersem2 c.estandar_S_Deber##i.primersem2 c.estandar_N_Logro##i.primersem2 c.estandar_Autodis##i.primersem2 c.estandar_Delibera##i.primersem2 c.estandar_Extrav##i.primersem2 c.estandar_Aperex##i.primersem2 c.estandar_Amab##i.primersem2 c.estandar_Neuro##i.primersem2   if coincide==1 & primerciclo==1,robust

forvalues j=1/10{
			lincom `var' + `j' .primersem2#c.`var'
			local valor = r(estimate)
			matrix coefysdresp[`j',`contador'] = `valor'
			
			matrix coefysdresp[11+(`j'-1)*2,`contador'] =r(lb)
			matrix coefysdresp[12+(`j'-1)*2,`contador'] =r(ub)
		}
local contador=`contador'+ 1
	}  
	
            

global relacionsumcr "C:\Users\Erzo\OneDrive - Universidad del Pacífico\Univesidad del Pacífico\Ciclo\lCiclo 7 2024 I\Asistente\Big5\Hasta_2023\Resultados\Relacion\Subcomp\Resp"
local j 1
local palabras Compet Orden S_Deber N_Logro Autodis Delibera
foreach palabra in `palabras' {
	matrix define `palabra'=J(3,10,.)
	matrix rownames `palabra' = estimate ll95 ul95
	matrix colnames `palabra' = coh2019-I coh2019-II coh2020-I coh2020-II coh2021-I coh2021-II coh2022-I coh2022-II coh2023-I coh2023-II
	forvalues i=1/10{
	matrix `palabra'[1, `i']=coefysdresp[`i', `j' ]
	matrix `palabra'[2, `i']=coefysdresp[11+2*(`i'-1), `j' ]
    matrix `palabra'[3, `i']=coefysdresp[12+2*(`i'-1), `j' ]
    
}
matselrc `palabra' `palabra', col(1,3,5,7,9)
    
    coefplot matrix(`palabra'), ci((2 3))  title("`palabra'Ciclos1_sin_2_sem") vertical mlabel(string(@b, "%5.2f") + " (" + string(@ll, "%5.2f") + "; " + string(@ul, 		"%5.2f") + ")") mlabposition(12) mlabsize(1.2) xlabel(, angle(45)) name(`palabra') xline(2, lcolor(red) lpattern(dash)) yline(0)
	
	graph export "$relacionsumcr/`palabra'.png", replace
	local j =`j'+1
}


***************************************************************************SUBCOM EXTRAV
matrix define coefysdextr = J(30,6, .)	


local contador 1
local mi_lisstt estandar_Cordial estandar_Gregar estandar_Asert estandar_Activ estandar_B_emoci estandar_Emo_posi
foreach var of local mi_lisstt {
reg  promedio_ciclo c.estandar_Cordial##i.primersem2 c.estandar_Gregar##i.primersem2 c.estandar_Asert##i.primersem2 c.estandar_Activ##i.primersem2 c.estandar_B_emoci##i.primersem2 c.estandar_Emo_posi##i.primersem2 c.estandar_Resp##i.primersem2 c.estandar_Aperex##i.primersem2 c.estandar_Amab##i.primersem2 c.estandar_Neuro##i.primersem2   if coincide==1 & primerciclo==1,robust

forvalues j=1/10{
			lincom `var' + `j' .primersem2#c.`var'
			local valor = r(estimate)
			matrix coefysdextr[`j',`contador'] = `valor'
			
			matrix coefysdextr[11+(`j'-1)*2,`contador'] =r(lb)
			matrix coefysdextr[12+(`j'-1)*2,`contador'] =r(ub)
		}
local contador=`contador'+ 1
	}  
	
                 

global relacionsumcex "C:\Users\Erzo\OneDrive - Universidad del Pacífico\Univesidad del Pacífico\Ciclo\lCiclo 7 2024 I\Asistente\Big5\Hasta_2023\Resultados\Relacion\Subcomp\Extrav"
local j 1
local palabras Cordial Gregar Asert Activ B_emoci Emo_posi 
foreach palabra in `palabras' {
	matrix define `palabra'=J(3,10,.)
	matrix rownames `palabra' = estimate ll95 ul95
	matrix colnames `palabra' = coh2019-I coh2019-II coh2020-I coh2020-II coh2021-I coh2021-II coh2022-I coh2022-II coh2023-I coh2023-II
	forvalues i=1/10{
	matrix `palabra'[1, `i']=coefysdextr[`i', `j' ]
	matrix `palabra'[2, `i']=coefysdextr[11+2*(`i'-1), `j' ]
    matrix `palabra'[3, `i']=coefysdextr[12+2*(`i'-1), `j' ]
    
}
matselrc `palabra' `palabra', col(1,3,5,7,9)
    
    coefplot matrix(`palabra'), ci((2 3))  title("`palabra'Ciclos1_sin_2_sem") vertical mlabel(string(@b, "%5.2f") + " (" + string(@ll, "%5.2f") + "; " + string(@ul, 		"%5.2f") + ")") mlabposition(12) mlabsize(1.2) xlabel(, angle(45)) name(`palabra') xline(2, lcolor(red) lpattern(dash)) yline(0)
	
	graph export "$relacionsumcex/`palabra'.png", replace
	local j =`j'+1
}



***************************************************************************SUBCOM Amab
matrix define coefysdamab = J(30,6, .)	


local contador 1
local mi_lisstt estandar_Confi estandar_Franq estandar_Altru estandar_A_concil estandar_Modest estandar_Sensi_D
foreach var of local mi_lisstt {
reg  promedio_ciclo c.estandar_Confi##i.primersem2 c.estandar_Franq##i.primersem2 c.estandar_Altru##i.primersem2 c.estandar_A_concil##i.primersem2 c.estandar_Modest##i.primersem2 c.estandar_Sensi_D##i.primersem2 c.estandar_Resp##i.primersem2 c.estandar_Aperex##i.primersem2 c.estandar_Extrav##i.primersem2 c.estandar_Neuro##i.primersem2   if coincide==1 & primerciclo==1,robust

forvalues j=1/10{
			lincom `var' + `j' .primersem2#c.`var'
			local valor = r(estimate)
			matrix coefysdamab[`j',`contador'] = `valor'
			
			matrix coefysdamab[11+(`j'-1)*2,`contador'] =r(lb)
			matrix coefysdamab[12+(`j'-1)*2,`contador'] =r(ub)
		}
local contador=`contador'+ 1
	}  
	
                 

global relacionsuamab "C:\Users\Erzo\OneDrive - Universidad del Pacífico\Univesidad del Pacífico\Ciclo\lCiclo 7 2024 I\Asistente\Big5\Hasta_2023\Resultados\Relacion\Subcomp\Amab"
local j 1
local palabras Confi Franq Altru A_concil Modest Sensi_D 
foreach palabra in `palabras' {
	matrix define `palabra'=J(3,10,.)
	matrix rownames `palabra' = estimate ll95 ul95
	matrix colnames `palabra' = coh2019-I coh2019-II coh2020-I coh2020-II coh2021-I coh2021-II coh2022-I coh2022-II coh2023-I coh2023-II
	forvalues i=1/10{
	matrix `palabra'[1, `i']=coefysdamab[`i', `j' ]
	matrix `palabra'[2, `i']=coefysdamab[11+2*(`i'-1), `j' ]
    matrix `palabra'[3, `i']=coefysdamab[12+2*(`i'-1), `j' ]
    
}
matselrc `palabra' `palabra', col(1,3,5,7,9)
    
    coefplot matrix(`palabra'), ci((2 3))  title("`palabra'Ciclos1_sin_2_sem") vertical mlabel(string(@b, "%5.2f") + " (" + string(@ll, "%5.2f") + "; " + string(@ul, 		"%5.2f") + ")") mlabposition(12) mlabsize(1.2) xlabel(, angle(45)) name(`palabra') xline(2, lcolor(red) lpattern(dash)) yline(0)
	
	graph export "$relacionsuamab/`palabra'.png", replace
	local j =`j'+1
}





***************************************************************************SUBCOM aperex
matrix define coefysdaperex = J(30,6, .)	


local contador 1
local mi_lisstt estandar_Fanta estandar_Estet estandar_Sentim estandar_Accion estandar_Ideas estandar_Valores
foreach var of local mi_lisstt {
reg  promedio_ciclo c.estandar_Fanta##i.primersem2 c.estandar_Estet##i.primersem2 c.estandar_Sentim##i.primersem2 c.estandar_Accion##i.primersem2 c.estandar_Ideas##i.primersem2 c.estandar_Valores##i.primersem2 c.estandar_Resp##i.primersem2 c.estandar_Amab##i.primersem2 c.estandar_Extrav##i.primersem2 c.estandar_Neuro##i.primersem2   if coincide==1 & primerciclo==1,robust

forvalues j=1/10{
			lincom `var' + `j' .primersem2#c.`var'
			local valor = r(estimate)
			matrix coefysdaperex[`j',`contador'] = `valor'
			
			matrix coefysdaperex[11+(`j'-1)*2,`contador'] =r(lb)
			matrix coefysdaperex[12+(`j'-1)*2,`contador'] =r(ub)
		}
local contador=`contador'+ 1
	}  
	
                 

global relacionsuaperex "C:\Users\Erzo\OneDrive - Universidad del Pacífico\Univesidad del Pacífico\Ciclo\lCiclo 7 2024 I\Asistente\Big5\Hasta_2023\Resultados\Relacion\Subcomp\Aperex"
local j 1
local palabras Fanta Estet Sentim Accion Ideas Valores 
foreach palabra in `palabras' {
	matrix define `palabra'=J(3,10,.)
	matrix rownames `palabra' = estimate ll95 ul95
	matrix colnames `palabra' = coh2019-I coh2019-II coh2020-I coh2020-II coh2021-I coh2021-II coh2022-I coh2022-II coh2023-I coh2023-II
	forvalues i=1/10{
	matrix `palabra'[1, `i']=coefysdaperex[`i', `j' ]
	matrix `palabra'[2, `i']=coefysdaperex[11+2*(`i'-1), `j' ]
    matrix `palabra'[3, `i']=coefysdaperex[12+2*(`i'-1), `j' ]
    
}
matselrc `palabra' `palabra', col(1,3,5,7,9)
    
    coefplot matrix(`palabra'), ci((2 3))  title("`palabra'Ciclos1_sin_2_sem") vertical mlabel(string(@b, "%5.2f") + " (" + string(@ll, "%5.2f") + "; " + string(@ul, 		"%5.2f") + ")") mlabposition(12) mlabsize(1.2) xlabel(, angle(45)) name(`palabra') xline(2, lcolor(red) lpattern(dash)) yline(0)
	
	graph export "$relacionsuaperex/`palabra'.png", replace
	local j =`j'+1
}







**************************************************************************************************************GPA CICLO2 CONTROLANDO POR GPA CICLO1************************************
matrix define coefysd2 = J(30,5, .)	


local contador 1
local mi_lisstt estandar_Neuro estandar_Extrav estandar_Aperex estandar_Amab estandar_Resp
foreach var of local mi_lisstt {
reg  promedio_ciclo c.estandar_Neuro##i.primersem2 c.estandar_Extrav##i.primersem2 c.estandar_Aperex##i.primersem2 c.estandar_Amab##i.primersem2 c.estandar_Resp##i.primersem2  prom1ciclo  if coincide==1 & segundociclo==1,robust

forvalues j=1/9{
			lincom `var' + `j' .primersem2#c.`var'
			local valor = r(estimate)
			matrix coefysd2[`j',`contador'] = `valor'
			
			matrix coefysd2[11+(`j'-1)*2,`contador'] =r(lb)
			matrix coefysd2[12+(`j'-1)*2,`contador'] =r(ub)
		}
local contador=`contador'+ 1
}




**BIG5
global relacionciclos2c1 "C:\Users\Erzo\OneDrive - Universidad del Pacífico\Univesidad del Pacífico\Ciclo\lCiclo 7 2024 I\Asistente\Big5\Hasta_2023\Resultados\Relacion\Ciclos2contrciclo1"
local j 1
local palabras Neuro Extrav Aperex Amab Resp
foreach palabra in `palabras' {
	matrix define `palabra'=J(3,9,.)
	matrix rownames `palabra' = estimate ll95 ul95
	matrix colnames `palabra' = coh2019-I coh2019-II coh2020-I coh2020-II coh2021-I coh2021-II coh2022-I coh2022-II coh2023-I
	forvalues i=1/9{
	matrix `palabra'[1, `i']=coefysd2[`i', `j' ]
	matrix `palabra'[2, `i']=coefysd2[11+2*(`i'-1), `j' ]
    matrix `palabra'[3, `i']=coefysd2[12+2*(`i'-1), `j' ]
    
}

    
    coefplot matrix(`palabra'), ci((2 3))  title("`palabra'Ciclos2") vertical mlabel(string(@b, "%5.2f") + " (" + string(@ll, "%5.2f") + "; " + string(@ul, 		"%5.2f") + ")") mlabposition(12) mlabsize(1.2) xlabel(, angle(45)) name("`palabra'Ciclos2") xline(3, lcolor(red) lpattern(dash)) yline(0)
	
	graph export "$relacionciclos2c1/`palabra'.png", replace
	local j =`j'+1
}



**************************************************************************************************************GPA CICLO2 CONTROLANDO POR GPA CICLO1 sin 2 sem************************************
matrix define coefysd2sin = J(30,5, .)	


local contador 1
local mi_lisstt estandar_Neuro estandar_Extrav estandar_Aperex estandar_Amab estandar_Resp
foreach var of local mi_lisstt {
reg  promedio_ciclo c.estandar_Neuro##i.primersem2 c.estandar_Extrav##i.primersem2 c.estandar_Aperex##i.primersem2 c.estandar_Amab##i.primersem2 c.estandar_Resp##i.primersem2  prom1ciclo  if coincide==1 & segundociclo==1,robust

forvalues j=1/9{
			lincom `var' + `j' .primersem2#c.`var'
			local valor = r(estimate)
			matrix coefysd2sin[`j',`contador'] = `valor'
			
			matrix coefysd2sin[11+(`j'-1)*2,`contador'] =r(lb)
			matrix coefysd2sin[12+(`j'-1)*2,`contador'] =r(ub)
		}
local contador=`contador'+ 1
}




**BIG5
global relacionciclos2c1sin2 "C:\Users\Erzo\OneDrive - Universidad del Pacífico\Univesidad del Pacífico\Ciclo\lCiclo 7 2024 I\Asistente\Big5\Hasta_2023\Resultados\Relacion\Ciclos2contrciclo1\Sin2"
local j 1
local palabras Neuro Extrav Aperex Amab Resp
foreach palabra in `palabras' {
	matrix define `palabra'c2_c1=J(3,9,.)
	matrix rownames `palabra'c2_c1 = estimate ll95 ul95
	matrix colnames `palabra'c2_c1 = coh2019-I coh2019-II coh2020-I coh2020-II coh2021-I coh2021-II coh2022-I coh2022-II coh2023-I
	forvalues i=1/9{
	matrix `palabra'c2_c1[1, `i']=coefysd2sin[`i', `j' ]
	matrix `palabra'c2_c1[2, `i']=coefysd2sin[11+2*(`i'-1), `j' ]
    matrix `palabra'c2_c1[3, `i']=coefysd2sin[12+2*(`i'-1), `j' ]
    
}
matselrc `palabra'c2_c1 `palabra'c2_c1, col(1,3,5,7,9)

    
    coefplot matrix(`palabra'c2_c1), ci((2 3))  title("`palabra'Ciclos2_control_Ciclo1") vertical mlabel(string(@b, "%5.2f") + " (" + string(@ll, "%5.2f") + "; " + string(@ul, 		"%5.2f") + ")") mlabposition(12) mlabsize(1.2) xlabel(, angle(45)) name("`palabra'Ciclos2_sin_sem2si1") xline(1.5, lcolor(red) lpattern(dash)) yline(0)
	
	graph export "$relacionciclos2c1sin2/`palabra'.png", replace
	local j =`j'+1
}



*****************************************************************************************GPA CICLO 2
global all "C:\Users\Erzo\OneDrive - Universidad del Pacífico\Univesidad del Pacífico\Ciclo\lCiclo 7 2024 I\Asistente\Big5\Hasta_2023\Resultados\Relacion\ALL"
global ciclo2noctrl "C:\Users\Erzo\OneDrive - Universidad del Pacífico\Univesidad del Pacífico\Ciclo\lCiclo 7 2024 I\Asistente\Big5\Hasta_2023\Resultados\Relacion\Ciclos2nocontrol"

matrix define coefysd = J(30,5, .)	


local contador 1
local mi_lisstt estandar_Neuro estandar_Extrav estandar_Aperex estandar_Amab estandar_Resp
foreach var of local mi_lisstt {
reg  promedio_ciclo c.estandar_Neuro##i.primersem2 c.estandar_Extrav##i.primersem2 c.estandar_Aperex##i.primersem2 c.estandar_Amab##i.primersem2 c.estandar_Resp##i.primersem2   if coincide==1 & segundociclo==1,robust

forvalues j=1/9{
			lincom `var' + `j' .primersem2#c.`var'
			local valor = r(estimate)
			matrix coefysd[`j',`contador'] = `valor'
			
			matrix coefysd[11+(`j'-1)*2,`contador'] =r(lb)
			matrix coefysd[12+(`j'-1)*2,`contador'] =r(ub)
		}
local contador=`contador'+ 1
}  



global relacionciclos1sin2 "C:\Users\Erzo\OneDrive - Universidad del Pacífico\Univesidad del Pacífico\Ciclo\lCiclo 7 2024 I\Asistente\Big5\Hasta_2023\Resultados\Relacion\Ciclos1sin2"
local j 1
local palabras Neuro Extrav Aperex Amab Resp
foreach palabra in `palabras' {
	matrix define `palabra'c2=J(3,9,.)
	matrix rownames `palabra'c2 = estimate ll95 ul95
	matrix colnames `palabra'c2 = coh2019-I coh2019-II coh2020-I coh2020-II coh2021-I coh2021-II coh2022-I coh2022-II coh2023-I 
	forvalues i=1/9{
	matrix `palabra'c2[1, `i']=coefysd[`i', `j' ]
	matrix `palabra'c2[2, `i']=coefysd[11+2*(`i'-1), `j' ]
    matrix `palabra'c2[3, `i']=coefysd[12+2*(`i'-1), `j' ]
    
}
matselrc `palabra'c2 `palabra'c2, col(1,3,5,7,9)
    
    coefplot matrix(`palabra'c2), ci((2 3))  title("`palabra'Ciclos2") vertical mlabel(string(@b, "%5.2f") + " (" + string(@ll, "%5.2f") + "; " + string(@ul, 		"%5.2f") + ")") mlabposition(12) mlabsize(1.2) xlabel(, angle(45)) name("`palabra'Ciclos2_sin_sem2") xline(1.5, lcolor(red) lpattern(dash)) yline(0)
	
	graph export "$ciclo2noctrl/`palabra'.png", replace
	local j =`j'+1
}

*graph drop Neuro_ Extrav_ Aperex_ Amab_ Resp_

local palabras Neuro Extrav Aperex Amab Resp
foreach palabra in `palabras' {
    graph combine `palabra'Ciclo1no2sem `palabra'Ciclos2_sin_sem2 `palabra'Ciclos2_sin_sem2si1 , rows(2) cols(3)  xsize(14) ysize(7)
	graph export "$all/`palabra'.png", replace
}


**************************************************************************
local palabras Neuro Extrav Aperex Amab Resp
foreach palabra in `palabras' {
	matrix define `palabra'=J(3,9,.)
	matrix rownames `palabra' = estimate ll95 ul95
	matrix colnames `palabra' = coh2019-I coh2019-II coh2020-I coh2020-II coh2021-I coh2021-II coh2022-I coh2022-II coh2023-I 
	forvalues i=1/9{
	matrix `palabra'[1, `i']=coefysd[`i', `j' ]
	matrix `palabra'[2, `i']=coefysd[11+2*(`i'-1), `j' ]
    matrix `palabra'[3, `i']=coefysd[12+2*(`i'-1), `j' ]
    
}
matselrc `palabra' `palabra', col(1,3,5,7,9)
    
    coefplot matrix(`palabra'), ci((2 3))  title("`palabra'Ciclos2") vertical mlabel(string(@b, "%5.2f") + " (" + string(@ll, "%5.2f") + "; " + string(@ul, 		"%5.2f") + ")") mlabposition(12) mlabsize(1.2) xlabel(, angle(45)) name("`palabra'Ciclos2_sin_sem2") xline(1.5, lcolor(red) lpattern(dash)) yline(0)
	
	graph export "$ciclo2noctrl/`palabra'.png", replace
	local j =`j'+1
}
***********************************************************


local palabras Neuro Extrav Aperex Amab Resp
foreach palabra in `palabras'{
	
matrix coljoinbyname eso= `palabra'c1 `palabra'c2 `palabra'c2_c1
matrix colnames eso= coh2019-Ic1 coh2020-Ic1 coh2021-Ic1 coh2022-Ic1 coh2023-Ic1 coh2019-Ic2 coh2020-Ic2 coh2021-Ic2 coh2022-Ic2 coh2023-Ic2 coh2019-Ic2_c1 coh2020-Ic2_c1 coh2021-Ic2_c1 coh2022-Ic2_c1 coh2023-Ic2_c1
coefplot matrix(eso), ci((2 3))  title("`palabra'Ciclos_1_2_y_2-1") vertical mlabel(string(@b, "%5.2f") + " (" + string(@ll, "%5.2f") + "; " + string(@ul, 		"%5.2f") + ")") mlabposition(12) mlabsize(1.2) xlabel(, angle(45))  name("`palabra'") xline(2 5.5 6.5 10.5 11.5, lcolor(red) lpattern(dash)) xline(5.5 10.5, lcolor(black) lpattern(solid) ) yline(0)

graph export "$all/uni`palabra'.png", replace
*graph drop `palabra'
}


/*
matrix coljoinbyname eso= Neuroc1 Neuroc2 Neuroc2_c1
matrix colnames eso= coh2019-Ic1 coh2020-Ic1 coh2021-Ic1 coh2022-Ic1 coh2023-Ic1 coh2019-Ic2 coh2020-Ic2 coh2021-Ic2 coh2022-Ic2 coh2023-Ic2 coh2019-Ic2_c1 coh2020-Ic2_c1 coh2021-Ic2_c1 coh2022-Ic2_c1 coh2023-Ic2_c1
coefplot matrix(eso), ci((2 3))  title("`palabra'Ciclos_1_2_y_2-1") vertical mlabel(string(@b, "%5.2f") + " (" + string(@ll, "%5.2f") + "; " + string(@ul, 		"%5.2f") + ")") mlabposition(12) mlabsize(1.2) xlabel(, angle(45))  xline(2 5.5 6.5 10.5 11.5, lcolor(red) lpattern(dash)) xline(5.5 10.5, lcolor(black) ) yline(0)


`palabra'c1 `palabra'c2 `palabra'c2_c21
matrix colnames `palabra' = coh2019-Ic1 coh2019-IIc1 coh2020-Ic1 coh2020-IIc1 coh2021-Ic1 coh2021-IIc1 coh2022-Ic1 coh2022-IIc1 coh2023-Ic1 coh2023-IIc1 coh2019-Ic2 coh2019-IIc2 coh2020-Ic2 coh2020-IIc2 coh2021-Ic2 coh2021-IIc2 coh2022-Ic2 coh2022-IIc2 coh2023-Ic2 coh2019-Ic2_c1 coh2019-IIc2_c1 coh2020-Ic2_c1 coh2020-IIc2_c1 coh2021-Ic2_c1 coh2021-IIc2_c1 coh2022-Ic2_c1 coh2022-IIc2_c1 coh2023-Ic2_c1 
*/











*========================================================================================Añadiendo controles===============================================================================*
clear all
set more off
global bases "C:\Users\Erzo\OneDrive - Universidad del Pacífico\Univesidad del Pacífico\Ciclo\lCiclo 7 2024 I\Asistente\Big5\Hasta_2023\Bases"
use "$bases/baseregresion", clear

***gpa=alfa+alfa1*NEURO+alfa2*EXTRAV+alfa3*APEREX+alfa4*AGREE+alfa5*CONCIENT+aCICLO1+bCICLO2+cCICLO3+...+nCICLON //solo para los cuales coincide su primersem con su primer registro
sort cod acayearterm1
by cod: gen periefectivo = acayearterm1[1]
*el que me da la BD es perinoefectivo
gen perinoefectivo= primersem2

gen coincide=0
replace coincide=1 if perinoefectivo==periefectivo

gen primerciclo=0
replace primerciclo=1 if acayearterm1==perinoefectivo

tab primerciclo
tab primerciclo if coincide==1

gen promciclo1=.
replace promciclo1=primerciclo*promedio_ciclo
by cod:egen prom1ciclo=total(promciclo1)

gen segundociclo=0
replace segundociclo=1 if acayearterm1==perinoefectivo+1


tab segundociclo
tab segundociclo if coincide==1



************************************************************CICLO1
matrix define coefysd = J(30,5, .)	


local contador 1
local mi_lisstt estandar_Neuro estandar_Extrav estandar_Aperex estandar_Amab estandar_Resp
foreach var of local mi_lisstt {
reg  promedio_ciclo c.estandar_Neuro##i.primersem2 c.estandar_Extrav##i.primersem2 c.estandar_Aperex##i.primersem2 c.estandar_Amab##i.primersem2 c.estandar_Resp##i.primersem2  totalcreditaje if coincide==1 & primerciclo==1,robust

forvalues j=1/10{
			lincom `var' + `j' .primersem2#c.`var'
			local valor = r(estimate)
			matrix coefysd[`j',`contador'] = `valor'
			
			matrix coefysd[11+(`j'-1)*2,`contador'] =r(lb)
			matrix coefysd[12+(`j'-1)*2,`contador'] =r(ub)
		}
local contador=`contador'+ 1
}  
	
	
global relacionciclos1sin2 "C:\Users\Erzo\OneDrive - Universidad del Pacífico\Univesidad del Pacífico\Ciclo\lCiclo 7 2024 I\Asistente\Big5\Hasta_2023\Resultados\Relacion\Nuevos_controles\Solo_Creditaje\ciclo1"
local j 1
local palabras Neuro Extrav Aperex Amab Resp
foreach palabra in `palabras' {
	matrix define `palabra'c1=J(3,10,.)
	matrix rownames `palabra'c1 = estimate ll95 ul95
	matrix colnames `palabra'c1 = coh2019-I coh2019-II coh2020-I coh2020-II coh2021-I coh2021-II coh2022-I coh2022-II coh2023-I coh2023-II
	forvalues i=1/10{
	matrix `palabra'c1[1, `i']=coefysd[`i', `j' ]
	matrix `palabra'c1[2, `i']=coefysd[11+2*(`i'-1), `j' ]
    matrix `palabra'c1[3, `i']=coefysd[12+2*(`i'-1), `j' ]
    
}
matselrc `palabra'c1 `palabra'c1, col(1,3,5,7,9)
    
    coefplot matrix(`palabra'c1), ci((2 3))  title("`palabra'Ciclos1_sin_2_sem") vertical mlabel(string(@b, "%5.2f") + " (" + string(@ll, "%5.2f") + "; " + string(@ul, 		"%5.2f") + ")") mlabposition(12) mlabsize(1.2) xlabel(, angle(45)) name("`palabra'Ciclo1no2sem") xline(2, lcolor(red) lpattern(dash)) yline(0)
	
	graph export "$relacionciclos1sin2/`palabra'.png", replace
	local j =`j'+1
}

**************************************************************************************************************GPA CICLO2 CONTROLANDO POR GPA CICLO1 sin 2 sem************************************
matrix define coefysd2sin = J(30,5, .)	


local contador 1
local mi_lisstt estandar_Neuro estandar_Extrav estandar_Aperex estandar_Amab estandar_Resp
foreach var of local mi_lisstt {
reg  promedio_ciclo c.estandar_Neuro##i.primersem2 c.estandar_Extrav##i.primersem2 c.estandar_Aperex##i.primersem2 c.estandar_Amab##i.primersem2 c.estandar_Resp##i.primersem2  prom1ciclo  totalcreditaje if coincide==1 & segundociclo==1,robust

forvalues j=1/9{
			lincom `var' + `j' .primersem2#c.`var'
			local valor = r(estimate)
			matrix coefysd2sin[`j',`contador'] = `valor'
			
			matrix coefysd2sin[11+(`j'-1)*2,`contador'] =r(lb)
			matrix coefysd2sin[12+(`j'-1)*2,`contador'] =r(ub)
		}
local contador=`contador'+ 1
}




**BIG5
global relacionciclos2c1sin2 "C:\Users\Erzo\OneDrive - Universidad del Pacífico\Univesidad del Pacífico\Ciclo\lCiclo 7 2024 I\Asistente\Big5\Hasta_2023\Resultados\Relacion\Nuevos_controles\Solo_Creditaje\ciclo2_1"
local j 1
local palabras Neuro Extrav Aperex Amab Resp
foreach palabra in `palabras' {
	matrix define `palabra'c2_c1=J(3,9,.)
	matrix rownames `palabra'c2_c1 = estimate ll95 ul95
	matrix colnames `palabra'c2_c1 = coh2019-I coh2019-II coh2020-I coh2020-II coh2021-I coh2021-II coh2022-I coh2022-II coh2023-I
	forvalues i=1/9{
	matrix `palabra'c2_c1[1, `i']=coefysd2sin[`i', `j' ]
	matrix `palabra'c2_c1[2, `i']=coefysd2sin[11+2*(`i'-1), `j' ]
    matrix `palabra'c2_c1[3, `i']=coefysd2sin[12+2*(`i'-1), `j' ]
    
}
matselrc `palabra'c2_c1 `palabra'c2_c1, col(1,3,5,7,9)

    
    coefplot matrix(`palabra'c2_c1), ci((2 3))  title("`palabra'Ciclos2_control_Ciclo1") vertical mlabel(string(@b, "%5.2f") + " (" + string(@ll, "%5.2f") + "; " + string(@ul, 		"%5.2f") + ")") mlabposition(12) mlabsize(1.2) xlabel(, angle(45)) name("`palabra'Ciclos2_sin_sem2si1") xline(1.5, lcolor(red) lpattern(dash)) yline(0)
	
	graph export "$relacionciclos2c1sin2/`palabra'.png", replace
	local j =`j'+1
}



*****************************************************************************************GPA CICLO 2
global all "C:\Users\Erzo\OneDrive - Universidad del Pacífico\Univesidad del Pacífico\Ciclo\lCiclo 7 2024 I\Asistente\Big5\Hasta_2023\Resultados\Relacion\Nuevos_controles\Solo_Creditaje\All"
global ciclo2noctrl "C:\Users\Erzo\OneDrive - Universidad del Pacífico\Univesidad del Pacífico\Ciclo\lCiclo 7 2024 I\Asistente\Big5\Hasta_2023\Resultados\Relacion\Nuevos_controles\Solo_Creditaje\ciclo2"

matrix define coefysd = J(30,5, .)	


local contador 1
local mi_lisstt estandar_Neuro estandar_Extrav estandar_Aperex estandar_Amab estandar_Resp
foreach var of local mi_lisstt {
reg  promedio_ciclo c.estandar_Neuro##i.primersem2 c.estandar_Extrav##i.primersem2 c.estandar_Aperex##i.primersem2 c.estandar_Amab##i.primersem2 c.estandar_Resp##i.primersem2  totalcreditaje if coincide==1 & segundociclo==1,robust

forvalues j=1/9{
			lincom `var' + `j' .primersem2#c.`var'
			local valor = r(estimate)
			matrix coefysd[`j',`contador'] = `valor'
			
			matrix coefysd[11+(`j'-1)*2,`contador'] =r(lb)
			matrix coefysd[12+(`j'-1)*2,`contador'] =r(ub)
		}
local contador=`contador'+ 1
}  



local j 1
local palabras Neuro Extrav Aperex Amab Resp
foreach palabra in `palabras' {
	matrix define `palabra'c2=J(3,9,.)
	matrix rownames `palabra'c2 = estimate ll95 ul95
	matrix colnames `palabra'c2 = coh2019-I coh2019-II coh2020-I coh2020-II coh2021-I coh2021-II coh2022-I coh2022-II coh2023-I 
	forvalues i=1/9{
	matrix `palabra'c2[1, `i']=coefysd[`i', `j' ]
	matrix `palabra'c2[2, `i']=coefysd[11+2*(`i'-1), `j' ]
    matrix `palabra'c2[3, `i']=coefysd[12+2*(`i'-1), `j' ]
    
}
matselrc `palabra'c2 `palabra'c2, col(1,3,5,7,9)
    
    coefplot matrix(`palabra'c2), ci((2 3))  title("`palabra'Ciclos2") vertical mlabel(string(@b, "%5.2f") + " (" + string(@ll, "%5.2f") + "; " + string(@ul, 		"%5.2f") + ")") mlabposition(12) mlabsize(1.2) xlabel(, angle(45)) name("`palabra'Ciclos2_sin_sem2") xline(1.5, lcolor(red) lpattern(dash)) yline(0)
	
	graph export "$ciclo2noctrl/`palabra'.png", replace
	local j =`j'+1
}

*graph drop Neuro_ Extrav_ Aperex_ Amab_ Resp_

local palabras Neuro Extrav Aperex Amab Resp
foreach palabra in `palabras' {
    graph combine `palabra'Ciclo1no2sem `palabra'Ciclos2_sin_sem2 `palabra'Ciclos2_sin_sem2si1 , rows(2) cols(3)  xsize(14) ysize(7)
	graph export "$all/`palabra'.png", replace
}


***********************************************************


local palabras Neuro Extrav Aperex Amab Resp
foreach palabra in `palabras'{
	
matrix coljoinbyname eso= `palabra'c1 `palabra'c2 `palabra'c2_c1
matrix colnames eso= coh2019-Ic1 coh2020-Ic1 coh2021-Ic1 coh2022-Ic1 coh2023-Ic1 coh2019-Ic2 coh2020-Ic2 coh2021-Ic2 coh2022-Ic2 coh2023-Ic2 coh2019-Ic2_c1 coh2020-Ic2_c1 coh2021-Ic2_c1 coh2022-Ic2_c1 coh2023-Ic2_c1
coefplot matrix(eso), ci((2 3))  title("`palabra'Ciclos_1_2_y_2-1") vertical mlabel(string(@b, "%5.2f") + " (" + string(@ll, "%5.2f") + "; " + string(@ul, 		"%5.2f") + ")") mlabposition(12) mlabsize(1.2) xlabel(, angle(45))  name("`palabra'") xline(2 5.5 6.5 10.5 11.5, lcolor(red) lpattern(dash)) xline(5.5 10.5, lcolor(black) lpattern(solid) ) yline(0)

graph export "$all/uni`palabra'.png", replace

}


















*========================================================================================SOLO===============================================================================*
clear all
set more off
global bases "C:\Users\Erzo\OneDrive - Universidad del Pacífico\Univesidad del Pacífico\Ciclo\lCiclo 7 2024 I\Asistente\Big5\Hasta_2023\Bases"
use "$bases/baseregresion", clear

***gpa=alfa+alfa1*NEURO+alfa2*EXTRAV+alfa3*APEREX+alfa4*AGREE+alfa5*CONCIENT+aCICLO1+bCICLO2+cCICLO3+...+nCICLON //solo para los cuales coincide su primersem con su primer registro
sort cod acayearterm1
by cod: gen periefectivo = acayearterm1[1]
*el que me da la BD es perinoefectivo
gen perinoefectivo= primersem2

gen coincide=0
replace coincide=1 if perinoefectivo==periefectivo

gen primerciclo=0
replace primerciclo=1 if acayearterm1==perinoefectivo

tab primerciclo
tab primerciclo if coincide==1

gen promciclo1=.
replace promciclo1=primerciclo*promedio_ciclo
by cod:egen prom1ciclo=total(promciclo1)

gen segundociclo=0
replace segundociclo=1 if acayearterm1==perinoefectivo+1


tab segundociclo
tab segundociclo if coincide==1


*******************************************************************************************Solo

************************************************************CICLO1
matrix define coefysd = J(30,5, .)	


local contador 1
local mi_lisstt estandar_Neuro estandar_Extrav estandar_Aperex estandar_Amab estandar_Resp
foreach var of local mi_lisstt {
reg  promedio_ciclo c.estandar_Neuro##i.primersem2 c.estandar_Extrav##i.primersem2 c.estandar_Aperex##i.primersem2 c.estandar_Amab##i.primersem2 c.estandar_Resp##i.primersem2 if coincide==1 & primerciclo==1,robust

forvalues j=1/10{
			lincom `var' + `j' .primersem2#c.`var'
			local valor = r(estimate)
			matrix coefysd[`j',`contador'] = `valor'
			
			matrix coefysd[11+(`j'-1)*2,`contador'] =r(lb)
			matrix coefysd[12+(`j'-1)*2,`contador'] =r(ub)
		}
local contador=`contador'+ 1
}  
	
	
global relacionciclos1sin2 "C:\Users\Erzo\OneDrive - Universidad del Pacífico\Univesidad del Pacífico\Ciclo\lCiclo 7 2024 I\Asistente\Big5\Hasta_2023\Resultados\Relacion\Nuevos_controles\Solo\ciclo1"
local j 1
local palabras Neuro Extrav Aperex Amab Resp
foreach palabra in `palabras' {
	matrix define `palabra'c1=J(3,10,.)
	matrix rownames `palabra'c1 = estimate ll95 ul95
	matrix colnames `palabra'c1 = coh2019-I coh2019-II coh2020-I coh2020-II coh2021-I coh2021-II coh2022-I coh2022-II coh2023-I coh2023-II
	forvalues i=1/10{
	matrix `palabra'c1[1, `i']=coefysd[`i', `j' ]
	matrix `palabra'c1[2, `i']=coefysd[11+2*(`i'-1), `j' ]
    matrix `palabra'c1[3, `i']=coefysd[12+2*(`i'-1), `j' ]
    
}
matselrc `palabra'c1 `palabra'c1, col(1,3,5,7,9)
    
    coefplot matrix(`palabra'c1), ci((2 3))  title("`palabra'Ciclos1_sin_2_sem") vertical mlabel(string(@b, "%5.2f") + " (" + string(@ll, "%5.2f") + "; " + string(@ul, 		"%5.2f") + ")") mlabposition(12) mlabsize(1.2) xlabel(, angle(45)) name("`palabra'Ciclo1no2sem") xline(2, lcolor(red) lpattern(dash)) yline(0)
	
	graph export "$relacionciclos1sin2/`palabra'.png", replace
	local j =`j'+1
}

**************************************************************************************************************GPA CICLO2 CONTROLANDO POR GPA CICLO1 sin 2 sem************************************
matrix define coefysd2sin = J(30,5, .)	


local contador 1
local mi_lisstt estandar_Neuro estandar_Extrav estandar_Aperex estandar_Amab estandar_Resp
foreach var of local mi_lisstt {
reg  promedio_ciclo c.estandar_Neuro##i.primersem2 c.estandar_Extrav##i.primersem2 c.estandar_Aperex##i.primersem2 c.estandar_Amab##i.primersem2 c.estandar_Resp##i.primersem2  prom1ciclo  if coincide==1 & segundociclo==1,robust

forvalues j=1/9{
			lincom `var' + `j' .primersem2#c.`var'
			local valor = r(estimate)
			matrix coefysd2sin[`j',`contador'] = `valor'
			
			matrix coefysd2sin[11+(`j'-1)*2,`contador'] =r(lb)
			matrix coefysd2sin[12+(`j'-1)*2,`contador'] =r(ub)
		}
local contador=`contador'+ 1
}




**BIG5
global relacionciclos2c1sin2 "C:\Users\Erzo\OneDrive - Universidad del Pacífico\Univesidad del Pacífico\Ciclo\lCiclo 7 2024 I\Asistente\Big5\Hasta_2023\Resultados\Relacion\Nuevos_controles\Solo\ciclo2_1"
local j 1
local palabras Neuro Extrav Aperex Amab Resp
foreach palabra in `palabras' {
	matrix define `palabra'c2_c1=J(3,9,.)
	matrix rownames `palabra'c2_c1 = estimate ll95 ul95
	matrix colnames `palabra'c2_c1 = coh2019-I coh2019-II coh2020-I coh2020-II coh2021-I coh2021-II coh2022-I coh2022-II coh2023-I
	forvalues i=1/9{
	matrix `palabra'c2_c1[1, `i']=coefysd2sin[`i', `j' ]
	matrix `palabra'c2_c1[2, `i']=coefysd2sin[11+2*(`i'-1), `j' ]
    matrix `palabra'c2_c1[3, `i']=coefysd2sin[12+2*(`i'-1), `j' ]
    
}
matselrc `palabra'c2_c1 `palabra'c2_c1, col(1,3,5,7,9)

    
    coefplot matrix(`palabra'c2_c1), ci((2 3))  title("`palabra'Ciclos2_control_Ciclo1") vertical mlabel(string(@b, "%5.2f") + " (" + string(@ll, "%5.2f") + "; " + string(@ul, 		"%5.2f") + ")") mlabposition(12) mlabsize(1.2) xlabel(, angle(45)) name("`palabra'Ciclos2_sin_sem2si1") xline(1.5, lcolor(red) lpattern(dash)) yline(0)
	
	graph export "$relacionciclos2c1sin2/`palabra'.png", replace
	local j =`j'+1
}



*****************************************************************************************GPA CICLO 2
global all "C:\Users\Erzo\OneDrive - Universidad del Pacífico\Univesidad del Pacífico\Ciclo\lCiclo 7 2024 I\Asistente\Big5\Hasta_2023\Resultados\Relacion\Nuevos_controles\Solo\All"
global ciclo2noctrl "C:\Users\Erzo\OneDrive - Universidad del Pacífico\Univesidad del Pacífico\Ciclo\lCiclo 7 2024 I\Asistente\Big5\Hasta_2023\Resultados\Relacion\Nuevos_controles\Solo\ciclo2"

matrix define coefysd = J(30,5, .)	


local contador 1
local mi_lisstt estandar_Neuro estandar_Extrav estandar_Aperex estandar_Amab estandar_Resp
foreach var of local mi_lisstt {
reg  promedio_ciclo c.estandar_Neuro##i.primersem2 c.estandar_Extrav##i.primersem2 c.estandar_Aperex##i.primersem2 c.estandar_Amab##i.primersem2 c.estandar_Resp##i.primersem2  if coincide==1 & segundociclo==1,robust

forvalues j=1/9{
			lincom `var' + `j' .primersem2#c.`var'
			local valor = r(estimate)
			matrix coefysd[`j',`contador'] = `valor'
			
			matrix coefysd[11+(`j'-1)*2,`contador'] =r(lb)
			matrix coefysd[12+(`j'-1)*2,`contador'] =r(ub)
		}
local contador=`contador'+ 1
}  



local j 1
local palabras Neuro Extrav Aperex Amab Resp
foreach palabra in `palabras' {
	matrix define `palabra'c2=J(3,9,.)
	matrix rownames `palabra'c2 = estimate ll95 ul95
	matrix colnames `palabra'c2 = coh2019-I coh2019-II coh2020-I coh2020-II coh2021-I coh2021-II coh2022-I coh2022-II coh2023-I 
	forvalues i=1/9{
	matrix `palabra'c2[1, `i']=coefysd[`i', `j' ]
	matrix `palabra'c2[2, `i']=coefysd[11+2*(`i'-1), `j' ]
    matrix `palabra'c2[3, `i']=coefysd[12+2*(`i'-1), `j' ]
    
}
matselrc `palabra'c2 `palabra'c2, col(1,3,5,7,9)
    
    coefplot matrix(`palabra'c2), ci((2 3))  title("`palabra'Ciclos2") vertical mlabel(string(@b, "%5.2f") + " (" + string(@ll, "%5.2f") + "; " + string(@ul, 		"%5.2f") + ")") mlabposition(12) mlabsize(1.2) xlabel(, angle(45)) name("`palabra'Ciclos2_sin_sem2") xline(1.5, lcolor(red) lpattern(dash)) yline(0)
	
	graph export "$ciclo2noctrl/`palabra'.png", replace
	local j =`j'+1
}

*graph drop Neuro_ Extrav_ Aperex_ Amab_ Resp_

local palabras Neuro Extrav Aperex Amab Resp
foreach palabra in `palabras' {
    graph combine `palabra'Ciclo1no2sem `palabra'Ciclos2_sin_sem2 `palabra'Ciclos2_sin_sem2si1 , rows(2) cols(3)  xsize(14) ysize(7)
	graph export "$all/`palabra'.png", replace
}


***********************************************************


local palabras Neuro Extrav Aperex Amab Resp
foreach palabra in `palabras'{
	
matrix coljoinbyname eso= `palabra'c1 `palabra'c2 `palabra'c2_c1
matrix colnames eso= coh2019-Ic1 coh2020-Ic1 coh2021-Ic1 coh2022-Ic1 coh2023-Ic1 coh2019-Ic2 coh2020-Ic2 coh2021-Ic2 coh2022-Ic2 coh2023-Ic2 coh2019-Ic2_c1 coh2020-Ic2_c1 coh2021-Ic2_c1 coh2022-Ic2_c1 coh2023-Ic2_c1
coefplot matrix(eso), ci((2 3))  title("`palabra'Ciclos_1_2_y_2-1") vertical mlabel(string(@b, "%5.2f") + " (" + string(@ll, "%5.2f") + "; " + string(@ul, 		"%5.2f") + ")") mlabposition(12) mlabsize(1.2) xlabel(, angle(45))  name("`palabra'") xline(2 5.5 6.5 10.5 11.5, lcolor(red) lpattern(dash)) xline(5.5 10.5, lcolor(black) lpattern(solid) ) yline(0)

graph export "$all/uni`palabra'.png", replace

}













*==================================================================================Creditos y selfefficacy=========================================================================*

*========================================================================================Añadiendo controles===============================================================================*
clear all
set more off
global bases "C:\Users\Erzo\OneDrive - Universidad del Pacífico\Univesidad del Pacífico\Ciclo\lCiclo 7 2024 I\Asistente\Big5\Hasta_2023\Bases"
use "$bases/baseregresion", clear

***gpa=alfa+alfa1*NEURO+alfa2*EXTRAV+alfa3*APEREX+alfa4*AGREE+alfa5*CONCIENT+aCICLO1+bCICLO2+cCICLO3+...+nCICLON //solo para los cuales coincide su primersem con su primer registro
sort cod acayearterm1
by cod: gen periefectivo = acayearterm1[1]
*el que me da la BD es perinoefectivo
gen perinoefectivo= primersem2

gen coincide=0
replace coincide=1 if perinoefectivo==periefectivo

gen primerciclo=0
replace primerciclo=1 if acayearterm1==perinoefectivo

tab primerciclo
tab primerciclo if coincide==1

gen promciclo1=.
replace promciclo1=primerciclo*promedio_ciclo
by cod:egen prom1ciclo=total(promciclo1)

gen segundociclo=0
replace segundociclo=1 if acayearterm1==perinoefectivo+1


tab segundociclo
tab segundociclo if coincide==1



************************************************************CICLO1
matrix define coefysd = J(30,5, .)	


local contador 1
local mi_lisstt estandar_Neuro estandar_Extrav estandar_Aperex estandar_Amab estandar_Resp
foreach var of local mi_lisstt {
reg  promedio_ciclo c.estandar_Neuro##i.primersem2 c.estandar_Extrav##i.primersem2 c.estandar_Aperex##i.primersem2 c.estandar_Amab##i.primersem2 c.estandar_Resp##i.primersem2  totalcreditaje if coincide==1 & primerciclo==1,robust

forvalues j=1/10{
			lincom `var' + `j' .primersem2#c.`var'
			local valor = r(estimate)
			matrix coefysd[`j',`contador'] = `valor'
			
			matrix coefysd[11+(`j'-1)*2,`contador'] =r(lb)
			matrix coefysd[12+(`j'-1)*2,`contador'] =r(ub)
		}
local contador=`contador'+ 1
}  
	
	
global relacionciclos1sin2 "C:\Users\Erzo\OneDrive - Universidad del Pacífico\Univesidad del Pacífico\Ciclo\lCiclo 7 2024 I\Asistente\Big5\Hasta_2023\Resultados\Relacion\Nuevos_controles\Creditaje_selfefficacy\ciclo1"
local j 1
local palabras Neuro Extrav Aperex Amab Resp
foreach palabra in `palabras' {
	matrix define `palabra'c1=J(3,10,.)
	matrix rownames `palabra'c1 = estimate ll95 ul95
	matrix colnames `palabra'c1 = coh2019-I coh2019-II coh2020-I coh2020-II coh2021-I coh2021-II coh2022-I coh2022-II coh2023-I coh2023-II
	forvalues i=1/10{
	matrix `palabra'c1[1, `i']=coefysd[`i', `j' ]
	matrix `palabra'c1[2, `i']=coefysd[11+2*(`i'-1), `j' ]
    matrix `palabra'c1[3, `i']=coefysd[12+2*(`i'-1), `j' ]
    
}
matselrc `palabra'c1 `palabra'c1, col(1,3,5,7,9)
    
    coefplot matrix(`palabra'c1), ci((2 3))  title("`palabra'Ciclos1_sin_2_sem") vertical mlabel(string(@b, "%5.2f") + " (" + string(@ll, "%5.2f") + "; " + string(@ul, 		"%5.2f") + ")") mlabposition(12) mlabsize(1.2) xlabel(, angle(45)) name("`palabra'Ciclo1no2sem") xline(2, lcolor(red) lpattern(dash)) yline(0)
	
	graph export "$relacionciclos1sin2/`palabra'.png", replace
	local j =`j'+1
}

**************************************************************************************************************GPA CICLO2 CONTROLANDO POR GPA CICLO1 sin 2 sem************************************
matrix define coefysd2sin = J(30,5, .)	


local contador 1
local mi_lisstt estandar_Neuro estandar_Extrav estandar_Aperex estandar_Amab estandar_Resp
foreach var of local mi_lisstt {
reg  promedio_ciclo c.estandar_Neuro##i.primersem2 c.estandar_Extrav##i.primersem2 c.estandar_Aperex##i.primersem2 c.estandar_Amab##i.primersem2 c.estandar_Resp##i.primersem2  prom1ciclo  totalcreditaje c.estandar_Neuro#c.prom1ciclo if coincide==1 & segundociclo==1,robust

forvalues j=1/9{
			lincom `var' + `j' .primersem2#c.`var'
			local valor = r(estimate)
			matrix coefysd2sin[`j',`contador'] = `valor'
			
			matrix coefysd2sin[11+(`j'-1)*2,`contador'] =r(lb)
			matrix coefysd2sin[12+(`j'-1)*2,`contador'] =r(ub)
		}
local contador=`contador'+ 1
}




**BIG5
global relacionciclos2c1sin2 "C:\Users\Erzo\OneDrive - Universidad del Pacífico\Univesidad del Pacífico\Ciclo\lCiclo 7 2024 I\Asistente\Big5\Hasta_2023\Resultados\Relacion\Nuevos_controles\Creditaje_selfefficacy\ciclo2_1"
local j 1
local palabras Neuro Extrav Aperex Amab Resp
foreach palabra in `palabras' {
	matrix define `palabra'c2_c1=J(3,9,.)
	matrix rownames `palabra'c2_c1 = estimate ll95 ul95
	matrix colnames `palabra'c2_c1 = coh2019-I coh2019-II coh2020-I coh2020-II coh2021-I coh2021-II coh2022-I coh2022-II coh2023-I
	forvalues i=1/9{
	matrix `palabra'c2_c1[1, `i']=coefysd2sin[`i', `j' ]
	matrix `palabra'c2_c1[2, `i']=coefysd2sin[11+2*(`i'-1), `j' ]
    matrix `palabra'c2_c1[3, `i']=coefysd2sin[12+2*(`i'-1), `j' ]
    
}
matselrc `palabra'c2_c1 `palabra'c2_c1, col(1,3,5,7,9)

    
    coefplot matrix(`palabra'c2_c1), ci((2 3))  title("`palabra'Ciclos2_control_Ciclo1") vertical mlabel(string(@b, "%5.2f") + " (" + string(@ll, "%5.2f") + "; " + string(@ul, 		"%5.2f") + ")") mlabposition(12) mlabsize(1.2) xlabel(, angle(45)) name("`palabra'Ciclos2_sin_sem2si1") xline(1.5, lcolor(red) lpattern(dash)) yline(0)
	
	graph export "$relacionciclos2c1sin2/`palabra'.png", replace
	local j =`j'+1
}



*****************************************************************************************GPA CICLO 2
global all "C:\Users\Erzo\OneDrive - Universidad del Pacífico\Univesidad del Pacífico\Ciclo\lCiclo 7 2024 I\Asistente\Big5\Hasta_2023\Resultados\Relacion\Nuevos_controles\Creditaje_selfefficacy\All"
global ciclo2noctrl "C:\Users\Erzo\OneDrive - Universidad del Pacífico\Univesidad del Pacífico\Ciclo\lCiclo 7 2024 I\Asistente\Big5\Hasta_2023\Resultados\Relacion\Nuevos_controles\Creditaje_selfefficacy\ciclo2"

matrix define coefysd = J(30,5, .)	


local contador 1
local mi_lisstt estandar_Neuro estandar_Extrav estandar_Aperex estandar_Amab estandar_Resp
foreach var of local mi_lisstt {
reg  promedio_ciclo c.estandar_Neuro##i.primersem2 c.estandar_Extrav##i.primersem2 c.estandar_Aperex##i.primersem2 c.estandar_Amab##i.primersem2 c.estandar_Resp##i.primersem2  totalcreditaje if coincide==1 & segundociclo==1,robust

forvalues j=1/9{
			lincom `var' + `j' .primersem2#c.`var'
			local valor = r(estimate)
			matrix coefysd[`j',`contador'] = `valor'
			
			matrix coefysd[11+(`j'-1)*2,`contador'] =r(lb)
			matrix coefysd[12+(`j'-1)*2,`contador'] =r(ub)
		}
local contador=`contador'+ 1
}  



local j 1
local palabras Neuro Extrav Aperex Amab Resp
foreach palabra in `palabras' {
	matrix define `palabra'c2=J(3,9,.)
	matrix rownames `palabra'c2 = estimate ll95 ul95
	matrix colnames `palabra'c2 = coh2019-I coh2019-II coh2020-I coh2020-II coh2021-I coh2021-II coh2022-I coh2022-II coh2023-I 
	forvalues i=1/9{
	matrix `palabra'c2[1, `i']=coefysd[`i', `j' ]
	matrix `palabra'c2[2, `i']=coefysd[11+2*(`i'-1), `j' ]
    matrix `palabra'c2[3, `i']=coefysd[12+2*(`i'-1), `j' ]
    
}
matselrc `palabra'c2 `palabra'c2, col(1,3,5,7,9)
    
    coefplot matrix(`palabra'c2), ci((2 3))  title("`palabra'Ciclos2") vertical mlabel(string(@b, "%5.2f") + " (" + string(@ll, "%5.2f") + "; " + string(@ul, 		"%5.2f") + ")") mlabposition(12) mlabsize(1.2) xlabel(, angle(45)) name("`palabra'Ciclos2_sin_sem2") xline(1.5, lcolor(red) lpattern(dash)) yline(0)
	
	graph export "$ciclo2noctrl/`palabra'.png", replace
	local j =`j'+1
}

*graph drop Neuro_ Extrav_ Aperex_ Amab_ Resp_

local palabras Neuro Extrav Aperex Amab Resp
foreach palabra in `palabras' {
    graph combine `palabra'Ciclo1no2sem `palabra'Ciclos2_sin_sem2 `palabra'Ciclos2_sin_sem2si1 , rows(2) cols(3)  xsize(14) ysize(7)
	graph export "$all/`palabra'.png", replace
}


***********************************************************


local palabras Neuro Extrav Aperex Amab Resp
foreach palabra in `palabras'{
	
matrix coljoinbyname eso= `palabra'c1 `palabra'c2 `palabra'c2_c1
matrix colnames eso= coh2019-Ic1 coh2020-Ic1 coh2021-Ic1 coh2022-Ic1 coh2023-Ic1 coh2019-Ic2 coh2020-Ic2 coh2021-Ic2 coh2022-Ic2 coh2023-Ic2 coh2019-Ic2_c1 coh2020-Ic2_c1 coh2021-Ic2_c1 coh2022-Ic2_c1 coh2023-Ic2_c1
coefplot matrix(eso), ci((2 3))  title("`palabra'Ciclos_1_2_y_2-1") vertical mlabel(string(@b, "%5.2f") + " (" + string(@ll, "%5.2f") + "; " + string(@ul, 		"%5.2f") + ")") mlabposition(12) mlabsize(1.2) xlabel(, angle(45))  name("`palabra'") xline(2 5.5 6.5 10.5 11.5, lcolor(red) lpattern(dash)) xline(5.5 10.5, lcolor(black) lpattern(solid) ) yline(0)

graph export "$all/uni`palabra'.png", replace

}




































*=========================================================================================================================================================================================*
clear all
set more off
global bases "C:\Users\Erzo\OneDrive - Universidad del Pacífico\Univesidad del Pacífico\Ciclo\lCiclo 7 2024 I\Asistente\Big5\Hasta_2023\Bases"
global margins "C:\Users\Erzo\OneDrive - Universidad del Pacífico\Univesidad del Pacífico\Ciclo\lCiclo 7 2024 I\Asistente\Big5\Peer effects classrooms\Margins"
use "$bases/baseregresion", clear

***gpa=alfa+alfa1*NEURO+alfa2*EXTRAV+alfa3*APEREX+alfa4*AGREE+alfa5*CONCIENT+aCICLO1+bCICLO2+cCICLO3+...+nCICLON //solo para los cuales coincide su primersem con su primer registro
sort cod acayearterm1
by cod: gen periefectivo = acayearterm1[1]
*el que me da la BD es perinoefectivo
gen perinoefectivo= primersem2

gen coincide=0
replace coincide=1 if perinoefectivo==periefectivo

gen primerciclo=0
replace primerciclo=1 if acayearterm1==perinoefectivo

tab primerciclo
tab primerciclo if coincide==1

gen promciclo1=.
replace promciclo1=primerciclo*promedio_ciclo
by cod:egen prom1ciclo=total(promciclo1)

gen segundociclo=0
replace segundociclo=1 if acayearterm1==perinoefectivo+1


tab segundociclo
tab segundociclo if coincide==1


reg  promedio_ciclo c.estandar_Neuro##i.primersem2 c.estandar_Extrav##i.primersem2 c.estandar_Aperex##i.primersem2 c.estandar_Amab##i.primersem2 c.estandar_Resp##i.primersem2  c.estandar_Neuro#c.prom1ciclo c.estandar_Extrav#c.prom1ciclo c.estandar_Aperex#c.prom1ciclo c.estandar_Amab#c.prom1ciclo c.estandar_Resp#c.prom1ciclo prom1ciclo if coincide==1 & segundociclo==1,robust


margins, dydx(estandar_Neuro) at(prom1ciclo=(0(1)20))
marginsplot, recast(line) recastci(rarea) ciopt(color(%30)) yline(0) ylabel(-0.4[0.1]0.7) 
graph export "$margins/neurointeract_0_20.png", replace

margins, dydx(estandar_Neuro) at(prom1ciclo=(9(1)20))
marginsplot, recast(line) recastci(rarea) ciopt(color(%30)) yline(0) ylabel(-0.1[0.05]0.4) 
graph export "$margins/neurointeract_9_20.png", replace










