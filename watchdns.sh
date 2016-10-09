#!/usr/bin/env bash


restartDocker=false
testList=(
    'www.google.com'
    'www.6park.com'
    'www.youtube.com'
    'www.github.com'
    'www.rarbg.to'
)

function resolveAddress(){
    local resolvedAddress=''
    for add in ${testList[@]}
    do
        local addLine=$(dig +short ${add} A | grep -E '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}')
        #echo "${add}: ${addLine}"
        local addList=(${addLine[@]})
        if [ ! ${#addList[@]} -gt 0 ]
        then
	    echo "${add} count: ${#addList[@]}"
            restartDocker=true
            break
        fi
    done
}


while [ 1 -eq 1 ]
do
    restartDocker=false
    resolveAddress
    #echo "Is to restart docker? ${restartDocker}"
    if [ ${restartDocker} = true ]
    then
        cnt=$(docker ps |grep 'docker-chinadns:latest'|awk '{print  $1}')
        if [ "${cnt}" != "" ]
        then
            now=$(date +"%Y/%m/%d %T")
            echo "${now} - restart container"
            docker restart ${cnt}
        else
            cnt=$(docker ps -a |grep 'docker-chinadns:latest'|awk '{print  $1}')
            if [ "${cnt}" != "" ]
            then
                now=$(date +"%Y/%m/%d %T")
                echo "${now} - start container"
                docker start ${cnt}
            else
                echo "docker-chinadns:latest not found, exit."
                break;
            fi
        fi
    fi
    sleep 20s
done
exit
