
cd ~/.ssh/

v=$(cat known_hosts | grep = -1 | head -1 )

echo "" > known_hosts

echo "$v" > known_hosts
