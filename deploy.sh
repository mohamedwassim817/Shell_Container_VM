#!/bin/bash 

function helpp(){

echo "  --create : passer en parametre le nombre de machines 
 
        --stop : passer en parmetre le nom de la machine 
  
        --kill : stopper toutes les pseudo VM
 
        --help : montrer toutes les commandes
"
}


 
function createVm(){

echo "creation vm"
  

 v=1




 for machine in $(seq $v  3 )
  do
      docker build .
  
      echo "image built $machine"

  idImage=$(docker images --format "{{.ID}}" --filter "dangling=true" | head -n 1 | awk '{print $1}')

      echo "id image $machine retreved $idImage"

     docker run -itd --cap-add NET_ADMIN --cap-add SYS_ADMIN --publish-all=true --hostname=debian -v /srv/data:/srv/html -v /sys/fs/cgroup:/sys/fs/cgroup:ro $idImage /bin/bash




       echo "container running $machine"

      
       idContainer=$(docker ps --format "{{.ID}}" | head -n 1 | awk '{print $1}')


        echo "id of container $machine retreved $idContainer"

  #nommer la machine 

    docker exec -it $idContainer /bin/bash -c "hostnamectl set-hostname debianVM"

    #info network
      ipadd=$(docker exec -it $idContainer /bin/bash -c "ip addr | grep inet -m 3 | xargs -n 3 | tail -n 3 | awk '{print"$($2)"}'" )

  
   #ip address
     ipadd1=$(docker exec -it $idContainer /bin/bash -c " hostname -I " )

   #ssh 1- copie de la cle pubiuqe dans le serveur 

    docker exec -it $idContainer /bin/bash -c "mkdir $HOME/.ssh/ && touch authorized_keys && touch known_hosts"

    

    docker cp ~/.ssh/id_rsa.pub  $idContainer:$HOME/.ssh/authorized_keys

   A+="$ipadd,"

 


    docker exec -it $idContainer /bin/bash -c "systemctl start sshd"

    docker exec -it $idContainer /bin/bash -c "echo "$(systemctl status sshd)" "

 
   # docker exec -it $idContainer /bin/bash -c ""
  
 # ARGS=( "${ARGS[@]}"  "$ipadd1" )

   
    
 #ARGS+=(500,400)

 # ces trois commandes vont etre executés automatiquement
  
    #ssh-keygen

   # ssh-copy-id "root@$ipadd1"

   #-f $ipadd1

   #echo "${table[@]}"

 

done

 echo "${A[@]}" | grep -n 1 | awk '{print $1}'


}

function removeVm(){

echo "suppression vm"

containerId=$(docker ps --format "{{.ID}}" | head -n 1)
docker stop $containerId
docker rm $containerId

echo "$containerId deleted successfully !!!"

}

function killVm(){


docker stop $(docker ps -a -q)

docker rm $(docker ps -a -q)

cd ~/.ssh/

#supprimer les public key des hosts en cas d'une ancienne connexion ssh 

v=$(cat known_hosts | grep = -1 | head -1 )

echo "" > known_hosts

echo "$v" > known_hosts

}






if [ "$1" == "--create" ]
then
  createVm $2

   elif [  "$1" == "--stop"  ]
   then
    removeVm
   elif [  "$1" == "--kill"  ]
   then
     killVm

   elif [  "$1" == "--help"  ]
   then
       help
else
 echo "entrer une option valide !!!!!"
 
fi















  









