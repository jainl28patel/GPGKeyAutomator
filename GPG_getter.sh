#!/bin/bash

export(){ 
    echo "Enter the index of key which you want to use :"
    read m
    if [[ $m -le $j2 ]]; 
    then
        command1="gpg --armor --export "${secret_list[$((m-1))]}
        $command1
        changeKey="git config --global user.signingkey "${secret_list[$((m-1))]}
        $changeKey
    else
        echo "No such key exists"   
    fi 
}

echo "########################  Welcome to GPG Key Generator / Getter  #########################"
echo "Enter index for : 
1) Get existing 
2) Create New Key
3) Terminate"
echo "Enter the value :"  
read n

if [[ $n -eq 1 ]];
then
    key=$(gpg --list-secret-keys --keyid-format=long|awk '/sec/{if (length($2)>0) print $2}')
    uid=$(gpg --list-secret-keys --keyid-format=long|awk '/uid/')
    declare -a secret_list=()
    declare -a uid_list=()
    j=0
    n1=${#key}
    n2=${#uid}
    for((i=0;i<$n1;i++));
    do
        if [[ ${key:$i:1} == '/' ]] 
        then
            secret_list[$j]=${key:$i+1:16}
            ((j++))
        fi
    done
    j2=0
    s=0
    e=0
    for((i=0;i<$n2;i++));
    do
        if [[ ${uid:$i:1} == ']' ]] 
        then
            s=$i+1
        fi
        if [[ ${uid:$i:1} == '>' ]] 
        then
            e=$i+1
            uid_list[$j2]=${uid:$s+1:$e-$s}
            ((j2++))
        fi
    done
    echo "The List of Different UID : "
    for((i=0;i<$j2;i++));
    do
        j=$((i+1))
        echo $j. ${uid_list[$i]}
    done
    # echo "Enter the index of key which you want to use : "
    # read m
    export $secret_list
    # if [[ $m -le $j2 ]] 
    # then
    #     # command1="gpg --armor --export "${secret_list[$((m-1))]}
    #     # $command1
    #     export($m)
    # else
    #     echo "No such key exists"   
    # fi         

    # changeKey="git config --global user.signingkey "${secret_list[$((m-1))]}
    # $changeKey

elif [[ $n -eq 2 ]];
then
    gpg --full-generate-key
   
elif [[ $n -eq 3 ]];
then
    echo "GPG_getter Successfully Terminated"

else
    echo "############################  INVALID INPUT  ##############################"
    echo "############################  Please Enter Valid Input  ########################" 
    bash GPG_getter.sh
fi
