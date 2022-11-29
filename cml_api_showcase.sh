#!/bin/bash
# Setting variables
# set -x
GREEN="\033[0;32m"
YELLOW="\033[0;33m"
RED="\033[0;31m"
BLUE="\033[0;36m"
NORM="\033[0m"

timestamp=`date +%Y%m%d-%H-%M-%S`
timestamp_log=`date +%Y%m%d-%H-%M-%S`
mkdir -p /tmp/cml_automation/${timestamp}
tmp_dir="/tmp/cml_automation/${timestamp}"
touch ${tmp_dir}/${timestamp_log}_log

function help
{
  echo "Usage: delete_devices-sites.sh [-d x.x.x.x] [-h] [-x]"
  echo ""
  echo "   -d  DNA-Center IP address"
  echo "   -h  Help menue"
  echo "   -x  Delete devices"
  echo ""
  echo ""
}

function header
{
  printf "\n"
  printf "\n"
  printf "${BLUE}                                                                                                      ${NORM}\n"
  printf "${BLUE}                         000                                             000                          ${NORM}\n"
  printf "${BLUE}                        00000                                           00000                         ${NORM}\n"
  printf "${BLUE}                        00000                                           00000                         ${NORM}\n"
  printf "${BLUE}                        00000                                           00000                         ${NORM}\n"
  printf "${BLUE}              00        00000        000                     000        00000         00              ${NORM}\n"
  printf "${BLUE}             0000       00000       00000                   00000       00000        0000             ${NORM}\n"
  printf "${BLUE}             0000       00008       00000                   00000       00000        0000             ${NORM}\n"
  printf "${BLUE}             0000       00000       00000         0         00000       00000        0000         00  ${NORM}\n"
  printf "${BLUE} 0000        0000       00000       00000        000        00000       00000        0000        0000 ${NORM}\n"
  printf "${BLUE} 0000        0000       00000       00000       00000       00000       00000        0000        0000 ${NORM}\n"
  printf "${BLUE} 0000        0000       00000       00000       00000       00000       00000        0000        0000 ${NORM}\n"
  printf "${BLUE} 0000        0000       00000       00000       00000       00000       00000        0000        0000 ${NORM}\n"
  printf "${BLUE} 0000        0007       00000        000         000         000        00000         00          00  ${NORM}\n"
  printf "${BLUE}                        00000                                           00000                         ${NORM}\n"
  printf "${BLUE}                        00000                                           00000                         ${NORM}\n"
  printf "${BLUE}                         000                                             000                          ${NORM}\n"
  printf "\n"
  printf "\n"
  printf "${RED}               000000000      0000        000000000         000000000         0000000000               ${NORM}\n"
  printf "${RED}             00000000000      0000       0000000000       000000000000      00000000000000             ${NORM}\n"
  printf "${RED}            000000000000      0000      00000            0000000000000     00000000 0000000            ${NORM}\n"
  printf "${RED}           00000              0000      00000           000000            000000       00000           ${NORM}\n"
  printf "${RED}           00000              0000       000000000      00000             00000        00000           ${NORM}\n"
  printf "${RED}           00000              0000        000000000     00000             00000        00000           ${NORM}\n"
  printf "${RED}           00000              0000             00000    000000            00000        00000           ${NORM}\n"
  printf "${RED}            000000000000      0000             00000     0000000000000      0000000   00000            ${NORM}\n"
  printf "${RED}             00000000000      0000      00000000000       000000000000       0000000000000             ${NORM}\n"
  printf "${RED}               000000000      0000      000000000            00000000          000000000               ${NORM}\n"
  printf "\n"
  printf "${YELLOW}                       Author: cbeye Last update:28/11/22                                           ${NORM}\n"
  printf "\n"
  printf "${YELLOW}         Your TMP dir is: ${tmp_dir}                                                                ${NORM}\n" | tee -a ${tmp_dir}/${timestamp_log}_log
}

function get_auth_token
{
    printf "\n"
    printf "${YELLOW}+++++++++++++++++++++++++++++++++++++++++++++++++++${NORM}\n"
    printf "${BLUE}                   CML authentication                       ${NORM}\n"
    printf "${YELLOW}+++++++++++++++++++++++++++++++++++++++++++++++++++${NORM}\n"
    read -p "Enter Username: " cml_username
    read -s -p "Enter Password: " cml_password
    printf "\n"
    printf "\n"
    CML_TOKEN=`curl --header "Content-Type:application/json" --header "Accept:application/json" -X POST --data '{"username":"'$cml_username'","password":"'$cml_password'"}' --insecure -s https://${CML_IP}/api/v0/authenticate | awk -F '"' '{print $2}' 2>&1`
    printf "${YELLOW}Your CML token is: ${GREEN}${CML_TOKEN}${NORM}\n"
    printf "\n"
}

function create_lab_api
{
    LAB_ID=`curl --header "Content-Type:application/json" --header "Accept:application/json" --header "authorization: Bearer ${CML_TOKEN}" -X POST --data '{"title": "CREATED_VIA_API"}' --insecure -s https://${CML_IP}/api/v0/labs | jq '.' | grep "id" | awk -F '"' '{print $4}'`
    printf "${YELLOW}Your Lab ID is: ${GREEN}${LAB_ID}${NORM}\n"
    SERVER01_NODE_ID=`curl --header "Content-Type:application/json" --header "Accept:application/json" --header "authorization: Bearer ${CML_TOKEN}" -X POST --data '{"x":495,"y":190,"label":"server01","configuration":"","node_definition":"server"}' --insecure -s https://${CML_IP}/api/v0/labs/${LAB_ID}/nodes?populate_interfaces=true | jq '.' | grep "id" | awk -F '"' '{print $4}'`
    printf "${YELLOW}Your SERVER01 ID is: ${GREEN}${LAB_ID}${NORM}\n"
    SERVER02_NODE_ID=`curl --header "Content-Type:application/json" --header "Accept:application/json" --header "authorization: Bearer ${CML_TOKEN}" -X POST --data '{"x":720,"y":190,"label":"server02","configuration":"","node_definition":"server"}' --insecure -s https://${CML_IP}/api/v0/labs/${LAB_ID}/nodes?populate_interfaces=true | jq '.' | grep "id" | awk -F '"' '{print $4}'`
    printf "${YELLOW}Your SERVER02 ID is: ${GREEN}${LAB_ID}${NORM}\n"
    SERVER01_INTERFACE_ID=`curl --header "Content-Type:application/json" --header "Accept:application/json" --header "authorization: Bearer ${CML_TOKEN}" -X POST --data '{"node":"'${SERVER01_NODE_ID}'","slot":1}' --insecure -s https://${CML_IP}/api/v0/labs/${LAB_ID}/interfaces | jq '.[0].id' | awk -F '"' '{print $2}'`
    SERVER02_INTERFACE_ID=`curl --header "Content-Type:application/json" --header "Accept:application/json" --header "authorization: Bearer ${CML_TOKEN}" -X POST --data '{"node":"'${SERVER02_NODE_ID}'","slot":1}' --insecure -s https://${CML_IP}/api/v0/labs/${LAB_ID}/interfaces | jq '.[0].id'| awk -F '"' '{print $2}'`
    curl --header "Content-Type:application/json" --header "Accept:application/json" --header "authorization: Bearer ${CML_TOKEN}" -X POST --data '{"src_int":"'${SERVER01_INTERFACE_ID}'","dst_int":"'${SERVER02_INTERFACE_ID}'"}' --insecure -s https://${CML_IP}/api/v0/labs/${LAB_ID}/links | jq '.' > /dev/null 2>&1
    curl --header "Content-Type:application/json" --header "Accept:application/json" --header "authorization: Bearer ${CML_TOKEN}" -X PUT --insecure -s https://${CML_IP}/api/v0/labs/${LAB_ID}/start | jq '.'
}

function create_lab_import
{
    LAB_ID=`curl --header "Content-Type:application/json" --header "Accept:application/json" --header "authorization: Bearer ${CML_TOKEN}" -X POST --data-raw $'lab:\n  description: \'\'\n  notes: \'\'\n  title: CREATED VIA FILE\n  version: 0.1.0\nlinks:\n  - id: l0\n    n1: n0\n    n2: n2\n    i1: i2\n    i2: i0\n    label: nxos9000-0-Ethernet1/1<->server-0-eth0\n  - id: l1\n    n1: n1\n    n2: n2\n    i1: i2\n    i2: i1\n    label: nxos9000-1-Ethernet1/1<->server-0-eth1\n  - id: l2\n    n1: n0\n    n2: n1\n    i1: i3\n    i2: i3\n    label: nxos9000-0-Ethernet1/2<->nxos9000-1-Ethernet1/2\nnodes:\n  - boot_disk_size: 0\n    configuration: |-\n      # workaround for booting to loader> prompt\n      echo \'from cli import cli\' > set_boot.py\n      echo \'import json\' >> set_boot.py\n      echo \'import os\' >> set_boot.py\n      echo \'import time\' >> set_boot.py\n      echo \'bootimage = json.loads(cli("show version | json"))["kick_file_name"]\' >> set_boot.py\n      echo \'set_boot = cli("conf t ; boot nxos {} ; no event manager applet BOOTCONFIG".format(bootimage))\' >> set_boot.py\n      echo \'i = 0\' >> set_boot.py\n      echo \'while i < 10:\' >> set_boot.py\n      echo \'    try:\' >> set_boot.py\n      echo \'        save_config = cli("copy running-config startup-config")\' >> set_boot.py\n      echo \'        break\' >> set_boot.py\n      echo \'    except Exception:\' >> set_boot.py\n      echo \'        i += 1\' >> set_boot.py\n      echo \'        time.sleep(1)\' >> set_boot.py\n      echo \'os.remove("/bootflash/set_boot.py")\' >> set_boot.py\n      event manager applet BOOTCONFIG\n       event syslog pattern "Configured from vty"\n       action 1.0 cli python bootflash:set_boot.py\n      # minimum needed config to login\n      no password strength-check\n      username admin role network-admin\n      username admin password cisco role network-admin\n      username cisco role network-admin\n      username cisco password cisco role network-admin\n    cpu_limit: 100\n    cpus: 0\n    data_volume: 0\n    hide_links: false\n    id: n0\n    label: nxos9000-0\n    node_definition: nxosv9000\n    ram: 0\n    tags: []\n    x: 380\n    y: 197\n    interfaces:\n      - id: i0\n        label: Loopback0\n        type: loopback\n      - id: i1\n        label: mgmt0\n        slot: 0\n        type: physical\n      - id: i2\n        label: Ethernet1/1\n        slot: 1\n        type: physical\n      - id: i3\n        label: Ethernet1/2\n        slot: 2\n        type: physical\n      - id: i4\n        label: Ethernet1/3\n        slot: 3\n        type: physical\n  - boot_disk_size: 0\n    configuration: |-\n      # workaround for booting to loader> prompt\n      echo \'from cli import cli\' > set_boot.py\n      echo \'import json\' >> set_boot.py\n      echo \'import os\' >> set_boot.py\n      echo \'import time\' >> set_boot.py\n      echo \'bootimage = json.loads(cli("show version | json"))["kick_file_name"]\' >> set_boot.py\n      echo \'set_boot = cli("conf t ; boot nxos {} ; no event manager applet BOOTCONFIG".format(bootimage))\' >> set_boot.py\n      echo \'i = 0\' >> set_boot.py\n      echo \'while i < 10:\' >> set_boot.py\n      echo \'    try:\' >> set_boot.py\n      echo \'        save_config = cli("copy running-config startup-config")\' >> set_boot.py\n      echo \'        break\' >> set_boot.py\n      echo \'    except Exception:\' >> set_boot.py\n      echo \'        i += 1\' >> set_boot.py\n      echo \'        time.sleep(1)\' >> set_boot.py\n      echo \'os.remove("/bootflash/set_boot.py")\' >> set_boot.py\n      event manager applet BOOTCONFIG\n       event syslog pattern "Configured from vty"\n       action 1.0 cli python bootflash:set_boot.py\n      # minimum needed config to login\n      no password strength-check\n      username admin role network-admin\n      username admin password cisco role network-admin\n      username cisco role network-admin\n      username cisco password cisco role network-admin\n    cpu_limit: 100\n    cpus: 0\n    data_volume: 0\n    hide_links: false\n    id: n1\n    label: nxos9000-1\n    node_definition: nxosv9000\n    ram: 0\n    tags: []\n    x: 536\n    y: 199\n    interfaces:\n      - id: i0\n        label: Loopback0\n        type: loopback\n      - id: i1\n        label: mgmt0\n        slot: 0\n        type: physical\n      - id: i2\n        label: Ethernet1/1\n        slot: 1\n        type: physical\n      - id: i3\n        label: Ethernet1/2\n        slot: 2\n        type: physical\n      - id: i4\n        label: Ethernet1/3\n        slot: 3\n        type: physical\n  - boot_disk_size: 0\n    configuration: |-\n      # this is a shell script which will be sourced at boot\n      hostname inserthostname_here\n      # configurable user account\n      USERNAME=cisco\n      PASSWORD=cisco\n      # no password for tc user by default\n      TC_PASSWORD=\n    cpu_limit: 100\n    cpus: 0\n    data_volume: 0\n    hide_links: false\n    id: n2\n    label: server-0\n    node_definition: server\n    ram: 0\n    tags: []\n    x: 475\n    y: 320\n    interfaces:\n      - id: i0\n        label: eth0\n        slot: 0\n        type: physical\n      - id: i1\n        label: eth1\n        slot: 1\n        type: physical\n' --insecure -s https://${CML_IP}/api/v0/import | jq '.' | grep "id" | awk -F '"' '{print $4}'`
    printf "${YELLOW}Your Lab ID is: ${GREEN}${LAB_ID}${NORM}\n"
    curl --header "Content-Type:application/json" --header "Accept:application/json" --header "authorization: Bearer ${CML_TOKEN}" -X PUT --insecure -s https://${CML_IP}/api/v0/labs/${LAB_ID}/start | jq '.'
}

function stop_start_links
{
    LAB_ID=`curl --header "Content-Type:application/json" --header "Accept:application/json" --header "authorization: Bearer ${CML_TOKEN}" -X GET --insecure -s https://${CML_IP}/api/v0/populate_lab_tiles | jq '.' | grep -A 8 "CREATED_VIA_API" | grep "id" | awk -F '"' '{print $4}'`
    printf "${YELLOW}Your Lab ID is: ${GREEN}${LAB_ID}${NORM}\n"
    LINK_ID=`curl --header "Content-Type:application/json" --header "Accept:application/json" --header "authorization: Bearer ${CML_TOKEN}" -X GET --insecure -s https://${CML_IP}/api/v0/labs/${LAB_ID}/links | jq '.' | awk -F '"' '{print $2}' | tr -d " \t\n\r"`
    printf "${YELLOW}Your Link ID is: ${GREEN}${LINK_ID}${NORM}\n"
    curl --header "Content-Type:application/json" --header "Accept:application/json" --header "authorization: Bearer ${CML_TOKEN}" -X PUT --insecure -s https://${CML_IP}/api/v0/labs/${LAB_ID}/links/${LINK_ID}/state/stop | jq '.'
    printf "${YELLOW}Stopping link ... wait 15 sec and enable link ...${NORM}\n"
    sleep 15
    curl --header "Content-Type:application/json" --header "Accept:application/json" --header "authorization: Bearer ${CML_TOKEN}" -X PUT --insecure -s https://${CML_IP}/api/v0/labs/${LAB_ID}/links/${LINK_ID}/state/start | jq '.'
}

function stop_start_nodes
{
    LAB_ID=`curl --header "Content-Type:application/json" --header "Accept:application/json" --header "authorization: Bearer ${CML_TOKEN}" -X GET --insecure -s https://${CML_IP}/api/v0/populate_lab_tiles | jq '.' | grep -A 8 "CREATED_VIA_API" | grep "id" | awk -F '"' '{print $4}'`
    printf "${YELLOW}Your Lab ID is: ${GREEN}${LAB_ID}${NORM}\n"
    while read NODE_ID 
      do
        printf "${YELLOW}Your Node ID is: ${GREEN}${NODE_ID}${NORM}\n"
        printf "${YELLOW}Stopping Node ... wait 15 sec and enable node ...${NORM}\n"
        curl --header "Content-Type:application/json" --header "Accept:application/json" --header "authorization: Bearer ${CML_TOKEN}" -X PUT --insecure -s https://${CML_IP}/api/v0/labs/${LAB_ID}/nodes/${NODE_ID}/state/stop | jq '.'
        sleep 15
        curl --header "Content-Type:application/json" --header "Accept:application/json" --header "authorization: Bearer ${CML_TOKEN}" -X PUT --insecure -s https://${CML_IP}/api/v0/labs/${LAB_ID}/nodes/${NODE_ID}/state/start | jq '.'
      done < <(curl --header "Content-Type:application/json" --header "Accept:application/json" --header "authorization: Bearer ${CML_TOKEN}" -X GET --insecure -s https://${CML_IP}/api/v0/labs/${LAB_ID}/nodes | jq '.' | sed '1d; $d' | awk -F '"' '{print $2}') 
}

function image_definitions
{
    curl --header "Content-Type:application/json" --header "Accept:application/json" --header "authorization: Bearer ${CML_TOKEN}" -X GET --insecure -s https://${CML_IP}/api/v0/image_definitions | jq '.'
}


function exit_abnormal
{          
  printf "${RED}!!!!! OH nooooo ... something went wrong! Try again! !!!!!${NORM}\n"
  help
  exit 1
} 

header

if [ "$#" == "0" ]
  then
    help
	else
    while getopts "d:cfhiln" opt
    do
      case $opt in
        d) CML_IP="${OPTARG}"
           echo "CML IP is: ${CML_IP}" 
           get_auth_token
            ;;
        h) help
            ;;
        i)
           image_definitions
            ;;
        c) create_lab_api
            ;;
        f)  create_lab_import
            ;;
        l)  stop_start_links
            ;;
        n)  stop_start_nodes
            ;;
      esac
    done
    shift $(($OPTIND -1))
fi