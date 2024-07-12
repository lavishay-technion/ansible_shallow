#!/bin/bash
declare -a users_list
for  i in $(cat /etc/passwd)
do
    if [ $(echo $i | cut -d ':' -f 2) == 'x' ]
    then
        users_list+=($(echo $i | cut -d ':' -f 1))
    fi
done
echo "{\"users\":["
tempo=$(( ${#users_list[*]}-1 ))

for (( i=o ; i<${#users_list[*]} ; i++ ))
do
    if [ $i == $tempo ]
    then
        echo "    "\"${users_list[$i]}\"]}""
    else
        echo "    "\"${users_list[$i]}\",""
    fi
done
