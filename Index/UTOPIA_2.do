/*clear all
global base "C:\Users\Erzo\OneDrive - Universidad del Pacífico\Univesidad del Pacífico\Ciclo\lCiclo 7 2024 I\Asistente\ENAHO\Num_coles\Base"
use "$base/EM_2S_2022_alumnos_innominado"

keep if gestion2=="Estatal"

encode grupo_L, gen(categorias)
encode nom_DRE, gen(nombre_DRE)
gen peso_lectura=real(peso_L)
*keep if peso_lectura<1000000
gen en_inicio=0
replace en_inicio=1 if categorias==1
replace en_inicio=en_inicio* peso_lectura	

gen en_proceso=0
replace en_proceso=1 if categorias==2
replace en_proceso=en_proceso* peso_lectura	

gen previo_al_inicio=0
replace previo_al_inicio=1 if categorias==3
replace previo_al_inicio=previo_al_inicio* peso_lectura	

gen satisfactorio=0
replace satisfactorio=1 if categorias==4
replace satisfactorio=satisfactorio* peso_lectura	

/*
replace Departamento="APURIMAC" if Departamento=="APURÍMAC"
replace Departamento="HUANUCO" if Departamento=="HUÁNUCO"
replace Departamento="JUNIN" if Departamento=="JUNÍN"
replace Departamento="SAN MARTIN" if Departamento=="SAN MARTÍN"
replace Departamento="ANCASH" if Departamento=="ÁNCASH"
*/

collapse (sum) previo_al_inicio en_inicio en_proceso satisfactorio, by(nom_DRE)

******************************************
clear all
global base "C:\Users\Erzo\OneDrive - Universidad del Pacífico\Univesidad del Pacífico\Ciclo\lCiclo 7 2024 I\Asistente\ENAHO\Num_coles\Base"
import excel "$base/EM_2S_2022_alumnos_innominado", firstrow
save "$base/EM_2S_2022_alumnos_innominado", replace
********************************************
*/
global base "C:\Users\Erzo\OneDrive - Universidad del Pacífico\Univesidad del Pacífico\Ciclo\lCiclo 7 2024 I\Asistente\ENAHO\Num_coles\Base"

use "$base/EM_2S_2022_alumnos_innominado", clear
keep if gestion2=="Estatal"

replace nom_DRE="Apurimac" if nom_DRE=="Apurímac"
replace nom_DRE="Huanuco" if nom_DRE=="Huánuco"
replace nom_DRE="Junin" if nom_DRE=="Junín"
replace nom_DRE="San Martin" if nom_DRE=="San Martín"
replace nom_DRE="Ancash" if nom_DRE=="Áncash"
replace nom_DRE="Lima" if nom_DRE=="Lima Metropolitana" |nom_DRE=="Lima Provincias"

gen pesos_lectura=real(peso_L)
gen pesos_mate=real(peso_M)

encode grupo_L, gen(categorias_L)
encode grupo_M, gen(categorias_M)

sort ID_IE
bys ID_IE: egen pesoIE_mean_L=mean(pesos_lectura)
bys ID_IE: egen pesoIE_mean_Ltotal=mean(pesos_lectura)
bys ID_IE: egen pesoIE_mean_M=mean(pesos_mate)

gen pesoIE_inversa_L= real(pikIE_L)
replace pesoIE_inversa_L=1/pesoIE_inversa_L
gen pesoIE_inversa_M= real(pikIE_M)
replace pesoIE_inversa_M=1/pesoIE_inversa_M


gen satisfactorio_L=0
replace satisfactorio_L=1 if categorias_L==4 
replace satisfactorio_L=satisfactorio_L*pesos_lectura
gen satisfactorio_M=0
replace satisfactorio_M=1 if categorias_M==4


collapse (first) nom_DRE (sum) satisfactorio_L pesoIE_mean_Ltotal satisfactorio_M (mean) pesoIE_mean_L pesoIE_mean_M pesoIE_inversa_L pesoIE_inversa_M, by(ID_IE)
replace satisfactorio_L=satisfactorio_L/pesoIE_mean_Ltotal
*************************************************************************************Quintil superior
***********************LECTURA_MEAN
gsort nom_DRE -satisfactorio_L  ID_IE 
bys nom_DRE:egen quintil_mean_L=total(pesoIE_mean_L)
replace quintil_mean_L=quintil_mean_L/5
bys nom_DRE:gen cumsum_mean_L=sum(pesoIE_mean_L)

gen diff_mean_L=abs(cumsum_mean_L-quintil_mean_L)
bys nom_DRE: egen limit_mean_L=min(diff_mean_L)
gen limit1_mean_L=.
bys nom_DRE: replace limit1_mean_L=cumsum_mean_L if diff_mean_L==limit_mean_L
bys nom_DRE: egen limit2_mean_L=mean(limit1_mean_L)
bys nom_DRE: gen dummy_meanq_L=1 if cumsum_mean_L<=limit2_mean_L

***********************LECTURA_INVERSA
gsort nom_DRE -satisfactorio_L ID_IE
bys nom_DRE:egen quintil_inversa_L=total(pesoIE_inversa_L)
replace quintil_inversa_L=quintil_inversa_L/5
bys nom_DRE:gen cumsum_inversa_L=sum(pesoIE_inversa_L)

gen diff_inversa_L=abs(cumsum_inversa_L-quintil_inversa_L)
bys nom_DRE: egen limit_inversa_L=min(diff_inversa_L)

gen limit1_inversa_L=.
bys nom_DRE: replace limit1_inversa_L=cumsum_inversa_L if diff_inversa_L==limit_inversa_L
bys nom_DRE: egen limit2_inversa_L=mean(limit1_inversa_L)
bys nom_DRE: gen dummy_inversaq_L=1 if cumsum_inversa_L<=limit2_inversa_L
**********************Mate_MEAN
gsort nom_DRE -satisfactorio_M ID_IE
bys nom_DRE:egen quintil_mean_M=total(pesoIE_mean_M)
replace quintil_mean_M=quintil_mean_M/5
bys nom_DRE:gen cumsum_mean_M=sum(pesoIE_mean_M)

gen diff_mean_M=abs(cumsum_mean_M-quintil_mean_M)
bys nom_DRE: egen limit_mean_M=min(diff_mean_M)
gen limit1_mean_M=.
bys nom_DRE: replace limit1_mean_M=cumsum_mean_M if diff_mean_M==limit_mean_M
bys nom_DRE: egen limit2_mean_M=mean(limit1_mean_M)
bys nom_DRE: gen dummy_meanq_M=1 if cumsum_mean_M<=limit2_mean_M

***********************Mate_INVERSA
gsort nom_DRE -satisfactorio_L ID_IE
bys nom_DRE:egen quintil_inversa_M=total(pesoIE_inversa_M)
replace quintil_inversa_M=quintil_inversa_M/5
bys nom_DRE:gen cumsum_inversa_M=sum(pesoIE_inversa_M)

gen diff_inversa_M=abs(cumsum_inversa_M-quintil_inversa_M)
bys nom_DRE: egen limit_inversa_M=min(diff_inversa_M)

gen limit1_inversa_M=.
bys nom_DRE: replace limit1_inversa_M=cumsum_inversa_M if diff_inversa_M==limit_inversa_M
bys nom_DRE: egen limit2_inversa_M=mean(limit1_inversa_M)
bys nom_DRE: gen dummy_inversaq_M=1 if cumsum_inversa_M<=limit2_inversa_M

keep ID_IE nom_DRE dummy_meanq_L dummy_inversaq_L dummy_meanq_M dummy_inversaq_M

save "$base/mergequintil",replace
*******************************************************************************************merge
use "$base/EM_2S_2022_alumnos_innominado", clear
replace nom_DRE="Apurimac" if nom_DRE=="Apurímac"
replace nom_DRE="Huanuco" if nom_DRE=="Huánuco"
replace nom_DRE="Junin" if nom_DRE=="Junín"
replace nom_DRE="San Martin" if nom_DRE=="San Martín"
replace nom_DRE="Ancash" if nom_DRE=="Áncash"
replace nom_DRE="Lima" if nom_DRE=="Lima Metropolitana" |nom_DRE=="Lima Provincias"

merge m:1 nom_DRE ID_IE using "$base/mergequintil", keep(3) nogen
save "$base/mergetodo2022",replace




*********************************************************************************************************Decil superior
clear all
global base "C:\Users\Erzo\OneDrive - Universidad del Pacífico\Univesidad del Pacífico\Ciclo\lCiclo 7 2024 I\Asistente\ENAHO\Num_coles\Base"

use "$base/EM_2S_2022_alumnos_innominado", clear
keep if gestion2=="Estatal"

gen pesos_lectura=real(peso_L)
gen pesos_mate=real(peso_M)

encode grupo_L, gen(categorias_L)
encode grupo_M, gen(categorias_M)

sort ID_IE
bys ID_IE: egen pesoIE_mean_L=mean(pesos_lectura)
bys ID_IE: egen pesoIE_mean_L_total=mean(pesos_lectura)
bys ID_IE: egen pesoIE_mean_M=mean(pesos_mate)

gen pesoIE_inversa_L= real(pikIE_L)
replace pesoIE_inversa_L=1/pesoIE_inversa_L
gen pesoIE_inversa_M= real(pikIE_M)
replace pesoIE_inversa_M=1/pesoIE_inversa_M


gen satisfactorio_L=0
replace satisfactorio_L=1 if categorias_L==4
replace satisfactorio_L=satisfactorio_L*pesos_lectura
gen satisfactorio_M=0
replace satisfactorio_M=1 if categorias_M==4

/*replace satisfactorio_L_mean=satisfactorio_L* pesoIE_L	

gen satisfactorio_L_inversa=0
replace satisfactorio_L_inversa=1 if categorias_L==4
**replace satisfactorio_L_inversa=satisfactorio_L_inversa* pesoIE_inversa_L	

gen satisfactorio_M_mean=0
replace satisfactorio_M_mean=1 if categorias_M==4
**replace satisfactorio_M_mean=satisfactorio_M* pesoIE_M		

gen satisfactorio_M_inversa=0
replace satisfactorio_M_inversa=1 if categorias_M==4
**replace satisfactorio_M_inversa=satisfactorio_M_inversa* pesoIE_inversa_M	
*/
replace nom_DRE="Apurimac" if nom_DRE=="Apurímac"
replace nom_DRE="Huanuco" if nom_DRE=="Huánuco"
replace nom_DRE="Junin" if nom_DRE=="Junín"
replace nom_DRE="San Martin" if nom_DRE=="San Martín"
replace nom_DRE="Ancash" if nom_DRE=="Áncash"
replace nom_DRE="Lima" if nom_DRE=="Lima Metropolitana" |nom_DRE=="Lima Provincias"

collapse (first) nom_DRE (sum) satisfactorio_L pesoIE_mean_L_total satisfactorio_M (mean)pesoIE_mean_L pesoIE_mean_M pesoIE_inversa_L pesoIE_inversa_M, by(ID_IE)
replace satisfactorio_L=satisfactorio_L/pesoIE_mean_L_total
***********************LECTURA_MEAN
gsort nom_DRE -satisfactorio_L ID_IE  
bys nom_DRE:egen decil_mean_L=total(pesoIE_mean_L)
replace decil_mean_L=decil_mean_L/10
bys nom_DRE:gen cumsum_mean_L=sum(pesoIE_mean_L)

gen diff_mean_L=abs(cumsum_mean_L-decil_mean_L)
bys nom_DRE: egen limit_mean_L=min(diff_mean_L)
gen limit1_mean_L=.
bys nom_DRE: replace limit1_mean_L=cumsum_mean_L if diff_mean_L==limit_mean_L
bys nom_DRE: egen limit2_mean_L=mean(limit1_mean_L)
bys nom_DRE: gen dummy_meand_L=1 if cumsum_mean_L<=limit2_mean_L

***********************LECTURA_INVERSA
gsort nom_DRE -satisfactorio_L ID_IE
bys nom_DRE:egen decil_inversa_L=total(pesoIE_inversa_L)
replace decil_inversa_L=decil_inversa_L/10
bys nom_DRE:gen cumsum_inversa_L=sum(pesoIE_inversa_L)

gen diff_inversa_L=abs(cumsum_inversa_L-decil_inversa_L)
bys nom_DRE: egen limit_inversa_L=min(diff_inversa_L)

gen limit1_inversa_L=.
bys nom_DRE: replace limit1_inversa_L=cumsum_inversa_L if diff_inversa_L==limit_inversa_L
bys nom_DRE: egen limit2_inversa_L=mean(limit1_inversa_L)
bys nom_DRE: gen dummy_inversad_L=1 if cumsum_inversa_L<=limit2_inversa_L
**********************Mate_MEAN
gsort nom_DRE -satisfactorio_M ID_IE
bys nom_DRE:egen decil_mean_M=total(pesoIE_mean_M)
replace decil_mean_M=decil_mean_M/10
bys nom_DRE:gen cumsum_mean_M=sum(pesoIE_mean_M)

gen diff_mean_M=abs(cumsum_mean_M-decil_mean_M)
bys nom_DRE: egen limit_mean_M=min(diff_mean_M)
gen limit1_mean_M=.
bys nom_DRE: replace limit1_mean_M=cumsum_mean_M if diff_mean_M==limit_mean_M
bys nom_DRE: egen limit2_mean_M=mean(limit1_mean_M)
bys nom_DRE: gen dummy_meand_M=1 if cumsum_mean_M<=limit2_mean_M

***********************Mate_INVERSA
gsort nom_DRE -satisfactorio_L ID_IE
bys nom_DRE:egen decil_inversa_M=total(pesoIE_inversa_M)
replace decil_inversa_M=decil_inversa_M/10
bys nom_DRE:gen cumsum_inversa_M=sum(pesoIE_inversa_M)

gen diff_inversa_M=abs(cumsum_inversa_M-decil_inversa_M)
bys nom_DRE: egen limit_inversa_M=min(diff_inversa_M)

gen limit1_inversa_M=.
bys nom_DRE: replace limit1_inversa_M=cumsum_inversa_M if diff_inversa_M==limit_inversa_M
bys nom_DRE: egen limit2_inversa_M=mean(limit1_inversa_M)
bys nom_DRE: gen dummy_inversad_M=1 if cumsum_inversa_M<=limit2_inversa_M

keep ID_IE nom_DRE dummy_meand_L dummy_inversad_L dummy_meand_M dummy_inversad_M

save "$base/mergedecil",replace
*******************************************************************************************merge
use "$base/mergetodo2022", clear

merge m:1 nom_DRE ID_IE using "$base/mergedecil", keep(3) nogen
save "$base/mergetodo2022",replace












****************************************************************************************************COLLAPSE********************************************************

use "$base/mergetodo2022",clear

gen pesos_lectura=real(peso_L)
gen pesos_mate=real(peso_M)

encode grupo_L, gen(categorias_L)
encode grupo_M, gen(categorias_M)

sort ID_IE
bys ID_IE: egen pesoIE_mean_L=mean(pesos_lectura)
bys ID_IE: egen pesoIE_mean_M=mean(pesos_mate)

gen pesoIE_inversa_L= real(pikIE_L)
replace pesoIE_inversa_L=1/pesoIE_inversa_L
gen pesoIE_inversa_M= real(pikIE_M)
replace pesoIE_inversa_M=1/pesoIE_inversa_M

keep if dummy_meanq_L==1| dummy_inversaq_L==1| dummy_meanq_M==1| dummy_inversaq_M==1| dummy_meand_L==1| dummy_inversad_L==1| dummy_meand_M==1| dummy_inversad_M==1
************************************************************************quintil Lectora
gen dummy_meanq_L_suma=dummy_meanq_L*pesoIE_mean_L
gen grupo_meanq_L_suma=dummy_meanq_L*pesoIE_mean_L if categorias_L==4

bys nom_DRE: egen total_meanq_L=sum(dummy_meanq_L_suma)
bys nom_DRE: egen grupo_meanq_L=sum(grupo_meanq_L_suma)
gen satisfactorio_meanq_L=grupo_meanq_L/total_meanq_L

gen dummy_inversaq_L_suma=dummy_inversaq_L*pesoIE_inversa_L
gen grupo_inversaq_L_suma=dummy_inversaq_L*pesoIE_inversa_L if categorias_L==4

bys nom_DRE: egen total_inversaq_L=sum(dummy_inversaq_L_suma)
bys nom_DRE: egen grupo_inversaq_L=sum(grupo_inversaq_L_suma)
gen satisfactorio_inversaq_L=grupo_inversaq_L/total_inversaq_L


************************************************************************quintil Mate
gen dummy_meanq_M_suma=dummy_meanq_M*pesoIE_mean_M
gen grupo_meanq_M_suma=dummy_meanq_M*pesoIE_mean_M if categorias_M==4

bys nom_DRE: egen total_meanq_M=sum(dummy_meanq_M_suma)
bys nom_DRE: egen grupo_meanq_M=sum(grupo_meanq_M_suma)
gen satisfactorio_meanq_M=grupo_meanq_M/total_meanq_M

gen dummy_inversaq_M_suma=dummy_inversaq_M*pesoIE_inversa_M
gen grupo_inversaq_M_suma=dummy_inversaq_M*pesoIE_inversa_M if categorias_M==4

bys nom_DRE: egen total_inversaq_M=sum(dummy_inversaq_M_suma)
bys nom_DRE: egen grupo_inversaq_M=sum(grupo_inversaq_M_suma)
gen satisfactorio_inversaq_M=grupo_inversaq_M/total_inversaq_M
************************************************************************decil Lectora
gen dummy_meand_L_suma=dummy_meand_L*pesos_lectura
gen grupo_meand_L_suma=dummy_meand_L*pesos_lectura if categorias_L==4

bys nom_DRE: egen total_meand_L=sum(dummy_meand_L_suma)
bys nom_DRE: egen grupo_meand_L=sum(grupo_meand_L_suma)
gen satisfactorio_meand_L=grupo_meand_L/total_meand_L

gen dummy_inversad_L_suma=dummy_inversad_L*pesoIE_inversa_L
gen grupo_inversad_L_suma=dummy_inversad_L*pesoIE_inversa_L if categorias_L==4

bys nom_DRE: egen total_inversad_L=sum(dummy_inversad_L_suma)
bys nom_DRE: egen grupo_inversad_L=sum(grupo_inversad_L_suma)
gen satisfactorio_inversad_L=grupo_inversad_L/total_inversad_L

************************************************************************decil Mate
gen dummy_meand_M_suma=dummy_meand_M*pesoIE_mean_M
gen grupo_meand_M_suma=dummy_meand_M*pesoIE_mean_M if categorias_M==4

bys nom_DRE: egen total_meand_M=sum(dummy_meand_M_suma)
bys nom_DRE: egen grupo_meand_M=sum(grupo_meand_M_suma)
gen satisfactorio_meand_M=grupo_meand_M/total_meand_M

gen dummy_inversad_M_suma=dummy_inversad_M*pesoIE_inversa_M
gen grupo_inversad_M_suma=dummy_inversad_M*pesoIE_inversa_M if categorias_M==4

bys nom_DRE: egen total_inversad_M=sum(dummy_inversad_M_suma)
bys nom_DRE: egen grupo_inversad_M=sum(grupo_inversad_M_suma)
gen satisfactorio_inversad_M=grupo_inversad_M/total_inversad_M


collapse (mean) satisfactorio_meanq_L satisfactorio_inversaq_L satisfactorio_meanq_M satisfactorio_inversaq_M satisfactorio_meand_L satisfactorio_inversad_L satisfactorio_meand_M satisfactorio_inversad_M, by(nom_DRE)


*******************************************************************************
export excel "$base/Utopia_COMPARABLE_2022",firstrow(variables) sheet("2022") replace






global base "C:\Users\Erzo\OneDrive - Universidad del Pacífico\Univesidad del Pacífico\Ciclo\lCiclo 7 2024 I\Asistente\ENAHO\Num_coles\Base"

use "$base/mergetodo2022",clear

gen pesos_lectura=real(peso_L)
gen pesos_mate=real(peso_M)

encode grupo_L, gen(categorias_L)
encode grupo_M, gen(categorias_M)

sort ID_IE
bys ID_IE: egen pesoIE_mean_L=mean(pesos_lectura)
bys ID_IE: egen pesoIE_mean_M=mean(pesos_mate)

gen pesoIE_inversa_L= real(pikIE_L)
replace pesoIE_inversa_L=1/pesoIE_inversa_L
gen pesoIE_inversa_M= real(pikIE_M)
replace pesoIE_inversa_M=1/pesoIE_inversa_M

keep if dummy_meanq_L==1| dummy_inversaq_L==1| dummy_meanq_M==1| dummy_inversaq_M==1| dummy_meand_L==1| dummy_inversad_L==1| dummy_meand_M==1| dummy_inversad_M==1
************************************************************************quintil Lectora
gen dummy_meanq_L_suma=dummy_meanq_L*pesos_lectura
gen grupo_meanq_L_suma=dummy_meanq_L*pesos_lectura if categorias_L==4

bys nom_DRE: egen total_meanq_L=sum(dummy_meanq_L_suma)
bys nom_DRE: egen grupo_meanq_L=sum(grupo_meanq_L_suma)
gen satisfactorio_meanq_L=grupo_meanq_L/total_meanq_L

collapse (mean) satisfactorio_meanq_L , by(nom_DRE)


*************************************
global base "C:\Users\Erzo\OneDrive - Universidad del Pacífico\Univesidad del Pacífico\Ciclo\lCiclo 7 2024 I\Asistente\ENAHO\Num_coles\Base"

use "$base/EM_2S_2022_alumnos_innominado", clear
keep if gestion2=="Estatal"

replace nom_DRE="Apurimac" if nom_DRE=="Apurímac"
replace nom_DRE="Huanuco" if nom_DRE=="Huánuco"
replace nom_DRE="Junin" if nom_DRE=="Junín"
replace nom_DRE="San Martin" if nom_DRE=="San Martín"
replace nom_DRE="Ancash" if nom_DRE=="Áncash"
replace nom_DRE="Lima" if nom_DRE=="Lima Metropolitana" |nom_DRE=="Lima Provincias"

gen pesos_lectura=real(peso_L)
gen pesos_mate=real(peso_M)

encode grupo_L, gen(categorias_L)
encode grupo_M, gen(categorias_M)

sort ID_IE
bys ID_IE: egen pesoIE_mean_L=mean(pesos_lectura)
bys ID_IE: egen pesoIE_mean_M=mean(pesos_mate)

gen pesoIE_inversa_L= real(pikIE_L)
replace pesoIE_inversa_L=1/pesoIE_inversa_L
gen pesoIE_inversa_M= real(pikIE_M)
replace pesoIE_inversa_M=1/pesoIE_inversa_M


gen satisfactorio_L=0
replace satisfactorio_L=1 if categorias_L==4 
replace satisfactorio_L=satisfactorio_L*pesos_lectura


collapse (sum) satisfactorio_L pesos_lectura , by(nom_DRE)
replace satisfactorio_L=satisfactorio_L/pesos_lectura