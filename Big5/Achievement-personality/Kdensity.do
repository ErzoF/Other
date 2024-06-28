clear all
global bases "C:\Users\Erzo\OneDrive - Universidad del Pacífico\Univesidad del Pacífico\Ciclo\lCiclo 7 2024 I\Asistente\Big5\Hasta_2023\Bases" 
use "$bases/baseregresion", replace
decode Primer_sem_est, gen(semestreinicio)
keep if semestreinicio==acayearterm

encode acayearterm, gen(periodosem)
gen Year=2019
replace Year=2020 if periodosem==3
replace Year=2020 if periodosem==4
replace Year=2021 if periodosem==5
replace Year=2021 if periodosem==6
replace Year=2022 if periodosem==7
replace Year=2022 if periodosem==8
replace Year=2023 if periodosem==9
replace Year=2023 if periodosem==10


rename Aperex Open
label variable Open "(mean)Open"

collapse (first) Year Neuro Extrav Open Amab Resp, by(cod )

local big Neuro Extrav Open Amab Resp
foreach b of local big{
local graphs
foreach year of numlist 2019/2023 {   
gen `b'`year'=`b' if Year==`year'


}
}



global graficos "C:\Users\Erzo\OneDrive - Universidad del Pacífico\Univesidad del Pacífico\Ciclo\lCiclo 7 2024 I\Asistente\Big5\Peer effects classrooms\Kernels" 

graph twoway kdensity Neuro2019|| kdensity Neuro2020 || kdensity Neuro2021 || kdensity Neuro2022 || kdensity Neuro2023

graph export "$graficos/graphs`b'.png",replace

graph twoway kdensity Extrav2019|| kdensity Extrav2020 || kdensity Extrav2021 || kdensity Extrav2022 || kdensity Extrav2023

graph export "$graficos/Extrav.png",replace

graph twoway kdensity Open2019|| kdensity Open2020 || kdensity Open2021 || kdensity Open2022 || kdensity Open2023

graph export "$graficos/Open.png",replace

graph twoway kdensity Neuro2019|| kdensity Neuro2020 || kdensity Neuro2021 || kdensity Neuro2022 || kdensity Neuro2023

graph export "$graficos/graphs`b'.png",replace

graph twoway kdensity Neuro2019|| kdensity Neuro2020 || kdensity Neuro2021 || kdensity Neuro2022 || kdensity Neuro2023

graph export "$graficos/graphs`b'.png",replace






kdensity Neuro, addplot(Extrav)

gen Neuro2019=Neuro if Year==2019
graph twoway kdensity Neuro if Year==2019|| kdensity Neuro if Year==2020 || kdensity Neuro if Year==2021 || kdensity Neuro if Year==2022 || kdensity Neuro if Year==2023, legend(1 2 3 4 5)

 









global graficos "C:\Users\Erzo\OneDrive - Universidad del Pacífico\Univesidad del Pacífico\Ciclo\lCiclo 7 2024 I\Asistente\Big5\Peer effects classrooms\Kernels" 

* Crear gráficos individuales para cada año y guardar los nombres de los gráficos

local big Neuro Extrav Open Amab Resp
foreach b of local big{
local graphs
foreach year of numlist 2019/2023 {   

    histogram `b' if Year == `year', kdensity name(hist_`year'`b', replace) legend(off) title("`year'")
    local graphs `graphs' hist_`year'`b'
}
graph combine `graphs'
graph export "$graficos/graphs`b'.png",replace
}

