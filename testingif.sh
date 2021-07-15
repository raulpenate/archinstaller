#!/bin/bash

#numeric array
declare -a numerico

#associative array
declare -A AssaociativeArry 
    
declare –A array=('aqsa' 'rimsha' 'saeed' 'raza' 'awan')
echo ${array[@]}

echo $homosexualidad
#local array
function Foo(){
    local -a LocalArray #Numeric array which only exists in this function

    LocalArray[0]="Hi"
    LocalArray[1]="There"
    LocalArray[9]=15 #No need to be consecutive or string

    #Read specific values
    echo "${LocalArray[0]} ${LocalArray[1]}"
}

Foo