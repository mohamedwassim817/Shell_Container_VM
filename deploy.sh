#!/bin/bash 

function helpp(){

echo "  --create : passer en parametre le nombre de machines 
 
        --stop : passer en parmetre le nom de la machine 
 
        --help : montrer toutes les commandes
"
}

 
function createVm(){

echo "creation vm"
  

 v=1



 for machine in $(seq $v $2 )
  do
      docker build .
  
      echo "image built $machine"

  idImage=$(docker images --format "{{.ID}}" --filter "dangling=true" | head -n 1 | awk '{print $1}')

      echo "id image $machine retreved $idImage"

     docker run -itd --cap-add NET_ADMIN --cap-add SYS_ADMIN --publish-all=true  -v /srv/data:/srv/html -v /sys/fs/cgroup:/sys/fs/cgroup:ro $idImage /bin/bash




       echo "container running $machine"

      
       idContainer=$(docker ps --format "{{.ID}}" | head -n 1 | awk '{print $1}')


        echo "id of container $machine retreved $idContainer"


       docker exec -it $idContainer /bin/bash -c echo "L'ip de la machine : "$(ip addr | grep inet -m 3 | xargs -n 3 | tail -n 3 | awk '{print $1}')

done



}

function removeVm(){

echo "suppression vm"

containerId=$(docker ps --format "{{.ID}}" | head -n 1)
docker stop $containerId
docker rm $containerId

echo "$containerId deleted successfully !!!"

}







if [ "$1" == "--create" ]
then
  createVm $2

   elif [  "$1" == "--stop"  ]
   then
    removeVm

   elif [  "$1" == "--help"  ]
   then
       help
else
 echo "entrer une option valide !!!!!"
 
fi















  









