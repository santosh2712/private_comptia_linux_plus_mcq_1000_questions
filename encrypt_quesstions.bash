#!/usr/bin/env bash
#Title          : encrypt_quesstions.bash
#Description    :       
#Author         : Santosh Kulkarni
#Date           : 25-Nov-2022 12-20
#Version        :       
#Usage          : ./encrypt_quesstions.bash
#Notes:                 
#Tested on Bash Version: 5.2.9(1)-release
#Mail ID:       santosh.kulkarni4u@gmail.com
############################### Global Variable Declaration Section Started ########################
#--------------------------------------------------------------------------------------------------#
# shellcheck disable=SC2034
utility_version="2.3.31"
# shellcheck disable=SC2034
utility_release_date_13_carector="31 March 2022"
# shellcheck disable=SC2034
scriptName=$( basename "$0" )
scriptName_space_removed="${scriptName// /}"
# shellcheck disable=SC2034
scriptName_with_full_path=$( realpath "$0" )
# shellcheck disable=SC2034
script_dir=$(dirname  "$(readlink -f  "$0")")
# shellcheck disable=SC2034
script_dir_only_name=$(basename "$script_dir" )
# shellcheck disable=SC2034
date_and_time_stamp="$(date '+%d-%h-%y_%H_%M')"
# shellcheck disable=SC2034
utility_name_30_caractor="      The Sample Utility      "
# shellcheck disable=SC2034
utility_name_space_removed="${utility_name_30_caractor// /}"
# shellcheck disable=SC2034
Temp_dir="$script_dir/Temp"
# shellcheck disable=SC2034
Logs_dir="$script_dir/Logs"
# shellcheck disable=SC2034
# 
LOCKFILE="/tmp/lock_${scriptName_space_removed}"
# 
#--------------------------------------------------------------------------------------------------#
#  Starting Trap contold for INT TERM EXIT Signals
#--------------------------------------------------------------------------------------------------#

trap "rm -f ${LOCKFILE}; exit" INT TERM EXIT

#--------------------------------------------------------------------------------------------------#
#  Putting Logs in same directory by default 
#--------------------------------------------------------------------------------------------------#
# UNComment Following line if Standard Error STDERR and Standard  output  STDRR is thrown on following Line 
# exec >log_${date_and_time_stamp}.txt 2>&1
#--------------------------------------------------------------------------------------------------#
############################### Global Array Declaration Section Started ###########################
#--------------------------------------------------------------------------------------------------#
# Declare packages you want to check before running the script.
# Use below function to check the packages 
# check_binary_with_check_packges_before_arrey_function "check_packges_before_arrey" or  "package name to check"
declare -a check_packges_before_arrey=( sudo yum  not_exist_package)
#
# 
#--------------------------------------------------------------------------------------------------#
############################### Global Array Declaration Section Ended #############################
#--------------------------------------------------------------------------------------------------#
# 
# 
#--------------------------------------------------------------------------------------------------#
############################# Global Function  Section Started #####################################
#--------------------------------------------------------------------------------------------------#
function trap_SIGINT_Cntrl_C_signal_function () 
{
    # shellcheck disable=SC2283
    draw_line_function = green 
    warn_msg "Control -c or SIGINT or one of the following signal received for the process"
    warn_msg "SIGHUP or SIGFPE "
    warn_msg "SIGKILL or SIGTERM "
    # shellcheck disable=SC2283
    draw_line_function = green 
    pidof_shell_session=$( cat "$LOCKFILE" ) 
    [[ -f "${LOCKFILE}"  ]] && rm -f "${LOCKFILE}"
    exit 255 
    # shellcheck disable=SC2086
    if ps -p $pidof_shell_session ; then
        #statements
        kill -9  $pidof_shell_session
    fi
}
#--------------------------------------------------------------------------------------------------#
function trap_exit () 
{
    info_msg "Exiting script "
    [[ -f "${LOCKFILE}"  ]] && rm -f "${LOCKFILE}"
    # 
    exit 
    # shellcheck disable=SC2086

}
#--------------------------------------------------------------------------------------------------#
#--------------------------------------------------------------------------------------------------#
#--------------------------------------------------------------------------------------------------#
#--------------------------------------------------------------------------------------------------#
#
# The following function prints a text using custom color
# -c or --color define the color for the print. See the array colors for the available options.
# -n or --noline directs the system not to print a new line after the content.
# Last argument is the message to be printed.
function cecho_function () 
{
    # 
    declare -A colors;
    colors=(\
        ['black']='\E[0;47m'\
        ['red']='\E[0;31m'\
        ['green']='\E[0;32m'\
        ['yellow']='\E[0;33m'\
        ['blue']='\E[0;34m'\
        ['magenta']='\E[0;35m'\
        ['cyan']='\E[0;36m'\
        ['white']='\E[0;37m'\
    );
    # 
    local defaultMSG="No message passed.";
    local defaultColor="black";
    local defaultNewLine=true ;
    # 
    while [[ $# -gt 1 ]];
    do
    key="$1";
    # 
    case $key in
        -c|--color)
            color="$2";
            shift;
        ;;
        -n|--noline)
            newLine=false;
        ;;
        *)
            # unknown option
        ;;
    esac
    shift;
    done
    # 
    message=${1:-$defaultMSG};   # Defaults to default message.
    color=${color:-$defaultColor};   # Defaults to default color, if not specified.
    newLine=${newLine:-$defaultNewLine};
    # 
    echo -en "${colors[$color]}";
    echo -en "$message";
    if [ "$newLine" = true ] ; then
        echo;
    fi
    tput sgr0; #  Reset text attributes to normal without clearing screen.
    # 
    return;
    # 
}
# 
#--------------------------------------------------------------------------------------------------#
# 
function load_version_file_function ()
{
Version_File="$script_dir/.Version_info.txt"
if [[ -f $Version_File ]]; then
        #statements
    cat "$Version_File"
else 
cat << EOF > "$Version_File"
#
|==========================================================|
| ${utility_name_30_caractor} | Version: ${utility_version}         |
|==========================================================|
| Developed by: Santosh Kulkarni | Sys Admin: NANDED WZ    |
|----------------------------------------------------------|
| Released Date: ${utility_release_date_13_carector}                             |
|----------------------------------------------------------|
| Mail: santosh.kulkarni4u@gmail.com | Cell: 9960708564    |
|----------------------------------------------------------|
|                                                          |
|==========================================================|    
#
EOF
#
load_version_file_function
#
fi
}
# 
#--------------------------------------------------------------------------------------------------#
# 
function check_version_file_integrity_function () 
{
        check_version_file_integrity_function_with_hash=false
        local correct_md5sum="688b433c3cd5811e9bd0eb9d8bd0a3e5"
        local current_version_file_md5sum
        current_version_file_md5sum=$(md5sum "$Version_File" | cut -f 1 )
        if [[ ${check_version_file_integrity_function_with_hash,,} == "true" ]] ; then
            # 
            if [[ "$current_version_file_md5sum"  == "$correct_md5sum" ]]; then
                # 
                info_msg "Version file integrity check OK"
                # 
            else 
                # 
                error_msg "Version_File is changed. Incorrect modification Exiting script"
                exit 1     
                # 
            fi 
            # 
        fi
}
#
#--------------------------------------------------------------------------------------------------#
#
function load_conf_file_function ()
{
    # 
    external_conf_file_1="$script_dir/external_conf_file_1.conf"
    # 
    if [[ -f "$external_conf_file_1"  ]]; then
        # shellcheck disable=SC1090
        source "$external_conf_file_1"
        # 
        draw_line_function - white 50
        info_msg "Conf file $external_conf_file_1 is loaded"
        draw_line_function - white 50
        # 
    else 
        # 
        draw_line_function - white 50
        error_msg "WARN: $external_conf_file_1 file not found exiting "
        draw_line_function - white 50
        exit 1     
        # 
    fi
    # 
}
# 
#--------------------------------------------------------------------------------------------------#
# 
__get_remote_server_role_bash_function ()
{
#
# B1Appvm1  p902as01
# B2Appvm2  p902as02
# B2DBvm1   p902db01
# B1DBvm2   p902db02
# Base1os   k902ps01
# Base2os   k902ps02
# BackUPos  p902bk
# p902as01 p902as02 p902db01 p902db02 k902ps01 k902ps0  p902bk
#
local _remote_server_hostname=${1:-$(hostname)} 
#
if   [[ ${_remote_server_hostname,,} =~ "p"[0-9]{3}"as01"    ]]; then
        # 
        _server_role_bash="B1Appvm1"
        info_msg "remote server is $_server_role_bash server role. With hostname:  $_remote_server_hostname"
        #statements
#
#
elif [[ ${_remote_server_hostname,,} =~ "p"[0-9]{3}"as02"    ]]; then
        # 
        _server_role_bash="B2Appvm2"
        info_msg "remote server is $_server_role_bash server role. With hostname:  $_remote_server_hostname"
        #statements
#
elif [[ ${_remote_server_hostname,,} =~ "p"[0-9]{3}"db01"    ]]; then
        # 
        _server_role_bash="B2DBvm1"
        info_msg "remote server is $_server_role_bash server role. With hostname:  $_remote_server_hostname"
        #statements
elif [[ ${_remote_server_hostname,,} =~ "p"[0-9]{3}"db02"    ]]; then
        # 
        _server_role_bash="B1DBvm2"
        info_msg "remote server is $_server_role_bash server role. With hostname:  $_remote_server_hostname"
        #statements        
#
elif [[ ${_remote_server_hostname,,} =~ "k"[0-9]{3}"ps01"    ]]; then
        # 
        _server_role_bash="Base1os"
        info_msg "remote server is $_server_role_bash server role. With hostname:  $_remote_server_hostname"
        #statements
elif [[ ${_remote_server_hostname,,} =~ "k"[0-9]{3}"ps02"    ]]; then
        # 
        _server_role_bash="Base2os"
        info_msg "remote server is $_server_role_bash server role. With hostname:  $_remote_server_hostname"
        #statements 
#
elif [[ ${_remote_server_hostname,,} =~ "p"[0-9]{3}"bk"    ]]; then
        # 
        _server_role_bash="BackUPos"
        info_msg "remote server is $_server_role_bash server role. With hostname:  $_remote_server_hostname"
        #statements 
#
else 
    _server_role_bash="NA"
    error_msg "remote server is Unindentified, server hostname: $_remote_server_hostname"
fi
# 
# 
###############################################
# 
# for i in p098as01 p098as02 p098db01 p098db02 k098ps01 k098ps02  p098bk ; do
#         #statements
#         draw_line_function
#         __get_remote_server_role_bash_function $i 
#         draw_line_function
# done
# 
#
}
# 
#--------------------------------------------------------------------------------------------------#
# 
black () {
# 
    cecho_function -c 'black' "$@";
}
red () {
# 
    cecho_function -c 'red' "$@";
}
green () {
# 
    cecho_function -c 'green' "$@";
}
yellow () {
# 
    cecho_function -c 'yellow' "$@";
}
blue () {
# 
    cecho_function -c 'blue' "$@";
}
magenta () {
# 
    cecho_function -c 'magenta' "$@";
}
cyan () {
# 
    cecho_function -c 'cyan' "$@";
}
white () {
# 
    cecho_function -c 'white' "$@";
}
# 
info_msg () {
# 
    cecho_function -c 'green' "[INFO]: $*";
}
# 
warn_msg () {
# 
    cecho_function -c 'blue' "[WARN]: $*";
}
# 
error_msg () {
# 
    cecho_function -c 'red' "[ERROR]: $*";
}
# 
#--------------------------------------------------------------------------------------------------#
#
function check_binary()
{
# 
    if [[ $# -lt 1 ]]; then
        error_msg 'Missing required argument to check_binary()!' 2
    fi
    # 
    if ! command -v "$1" > /dev/null 2>&1; then
        if [[ -n ${2-} ]]; then
            error_msg "Missing dependency: Couldn't locate $1." 1
            draw_line_function - white 50
        else
            error_msg "Missing dependency: $1"
            draw_line_function - white 50
            return 1
        fi
    fi
    # 
    info_msg "Found Package Installed : $1"
    draw_line_function - white 50
    return 0
#
}
#
#--------------------------------------------------------------------------------------------------#
#
function check_binary_with_check_packges_before_arrey_function ()
{
#
for Pkg in "${check_packges_before_arrey[@]}"; do
    #statements
    # shellcheck disable=SC2086
    check_binary $Pkg
done
}
#
#--------------------------------------------------------------------------------------------------#
#
# DESC: Run the requested command as root (via sudo if requested)
# ARGS: $1 (optional): Set to zero to not attempt execution via sudo
#       $@ (required): Passed through for execution as root user
# OUTS: None
function run_as_root_function() 
{
    if [[ $# -eq 0 ]]; then
        white 'Missing required argument to run_as_root_function()!' 2
    fi
    # 
    if [[ ${1-} =~ ^0$ ]]; then
        local skip_sudo=true
        shift
    fi
    # 
    if [[ $EUID -eq 0 ]]; then
        "$@"
    elif [[ -z ${skip_sudo-} ]]; then
        sudo -H -- "$@"
    else
        white "Unable to run requested command as root: $*" 1
    fi
}
# 
#--------------------------------------------------------------------------------------------------#
# 
# DESC: Validate we have superuser access as root (via sudo if requested)
# ARGS: $1 (optional): Set to any value to not attempt root access via sudo
# OUTS: None
# 
# shellcheck disable=SC2120
function check_superuser_function() 
{
    local superuser
    if [[ $EUID -eq 0 ]]; then
        superuser=true
    elif [[ -z ${1-} ]]; then
        if check_binary sudo; then
            white 'Sudo: Updating cached credentials ...'
            if ! sudo -v; then
                # 
                red "Sudo: Couldn't acquire credentials ..." 
                # 
            else
                local test_euid
                test_euid="$(sudo -H -- "$BASH" -c 'printf "%s" "$EUID"')"
                if [[ $test_euid -eq 0 ]]; then
                    superuser=true
                fi
            fi
        fi
    fi
#
    if [[ -z ${superuser-} ]]; then
        red 'Unable to acquire superuser credentials.' #"${fg_red-}"
        return 1
    fi
    #
    green 'Successfully acquired superuser credentials.'
    return 0
    # 
}
# 
#--------------------------------------------------------------------------------------------------#
# 
draw_line_function ()
{
local default_carector_to_print
default_carector_to_print=${1:--}
local line_colour_default
line_colour_default=${2:- white}
local default_carector_lenth_to_print
default_carector_lenth_to_print=${3:-$(tput cols)}
# echo "default_carector_to_print:$default_carector_to_print line_colour_default:$line_colour_default default_carector_lenth_to_print:$default_carector_lenth_to_print "
$line_colour_default "$(printf %"$default_carector_lenth_to_print"s | tr " " "$default_carector_to_print" )"
# 
# Usage:
# Warm: dont use \ as default_carector_to_print
# function_name <default_carector_to_print> <Colour> <default_carector_lenth_to_print>
# draw_line_function = cyan
# draw_line_function = white 50 
}
# 
#--------------------------------------------------------------------------------------------------#
#  
function __display_date_and_time_from_seconds ()
{
#
    if [[ -z ${1} || ${1} -lt 60 ]] ;then
        min=0 ; secs="${1}"
    else
        time_mins=$(echo "scale=2; ${1}/60" | bc)
        # shellcheck disable=SC2086
        min=$(echo ${time_mins} | cut -d'.' -f1)
        # shellcheck disable=SC2086
        secs="0.$(echo ${time_mins} | cut -d'.' -f2)"
        # shellcheck disable=SC2086
        secs=$(echo ${secs}*60|bc|awk '{print int($1+0.5)}')
    fi
    echo "Time Elapsed : ${min} minutes and ${secs} seconds."

################### Usage ##########
# __display_date_and_time_from_seconds  455
# would show result as :- 7 minutes and 35 seconds
# 
# _start_time=$(date '+%s')
# sleep 2 
# _end_time=$(date '+%s')
# _total_time_in_seccond=$(($_end_time-$_start_time))# 
# elapsed_time_in_hour_minute_format=$( __display_date_and_time_from_seconds $_total_time_in_seccond ) # 
# or use as below 
# __display_date_and_time_from_seconds  $_time_elapsed
# echo $_time_elapsed
}
#
#--------------------------------------------------------------------------------------------------#
# 
function __new_create_directors_function ()
{
    # 
    array_to_create_directory=("$@")
    # 
    declare -i array_to_create_directory_elements_count=${#array_to_create_directory[@]}
    #
    # shellcheck disable=SC2086
    if [ $array_to_create_directory_elements_count -ge 1 ]; then
        #statements
        # echo "array is ${array_to_create_directory[@]}"
        for Dir in "${array_to_create_directory[@]}" ; do
            #statements
            [[ -d "$Dir" ]] || mkdir -p "$Dir"
        done
    else 
        warn_msg "__new_create_directors_function function required arguments"    
    fi
    #_____________________________________________________________
    # Usage
    # Function Name "${array_anme[@]"
    # Example 
    # __new_create_directors_function ${dir_arrey[@]}
    #_____________________________________________________________
    # 
}
# 
#--------------------------------------------------------------------------------------------------#
# 
function check_run_control_function () 

{


if [ -e ${LOCKFILE} ] && kill -0 `cat ${LOCKFILE}`; then

    red "Another Instance of the script $scriptName is running or. script had unclean execution on last run as $LOCKFILE is present"
    exit 1
else
    echo $$ > ${LOCKFILE}
fi

}
# 
#--------------------------------------------------------------------------------------------------#
# 
# Printing colour with tput 
colorprintf_function () 
{
    case $1 in
        "black") tput setaf 0;;
        "red") tput  setaf 1;;
        "green") tput setaf 2;;
        "orange") tput setaf 3;;
        "blue") tput setaf 4;;
        "purple") tput setaf 5;;
        "cyan") tput setaf 6;;
        "white") tput setaf 7;;
        "gray" | "grey") tput setaf 8;;
    esac
    # printf "%s\n" "$2"  
    printf "%s\n" "$2" 
    tput sgr0
    wait 
    # 
    # Usage: 
    # colorprintf_function red "This is sample test in red "
}
# 
#--------------------------------------------------------------------------------------------------#
# 
csv_to_xlsx_function () 
{
    input=$1
    output=$2
    input=$(realpath "$input" )
    output=$(realpath "$output" )
    if [[ -d "$input" ]]; then
        #statements
        info_msg "XLSX create input is directory. Creating XLSX $output file"
        # 
        ansible -m blue_xlswriter_old -a "csv_dir=$input format_header=true output_xlsx_file=$output" localhost &> /dev/null
        # 
    elif  [[ -f "$input" ]]; then 
        info_msg "XLSX create input is file. Creating xlsx $output file"
        local xlsx_input_temp="/tmp/$utility_name_space_removed"
        [[ -d $xlsx_input_temp ]] && rm -rf "$xlsx_input_temp" &> /dev/null 
        [[ -d $xlsx_input_temp ]] || mkdir -p  "$xlsx_input_temp" 
        cp -f "$input" "$xlsx_input_temp" && \
        ansible -m blue_xlswriter_old -a "csv_dir=$xlsx_input_temp format_header=true output_xlsx_file=$output" localhost &> /dev/null
    else 
        error_msg "XLSX create input file not correct. Input as directory of csv file "
    fi
}
# 
#--------------------------------------------------------------------------------------------------#
# 
# print usage information
function _echo_usage 
{
  echo 'USAGE:'
  echo "bm -h                   - Prints this usage info"
  echo 'bm -a <bookmark_name>   - Saves the current directory as "bookmark_name"'
  echo 'bm [-g] <bookmark_name> - Goes (cd) to the directory associated with "bookmark_name"'
  echo 'bm -p <bookmark_name>   - Prints the directory associated with "bookmark_name"'
  echo 'bm -d <bookmark_name>   - Deletes the bookmark'
  echo 'bm -l                   - Lists all available bookmarks'
}
#
#--------------------------------------------------------------------------------------------------#
# 
#--------------------------------------------------------------------------------------------------#
############################# Global Function  Section Ended #######################################
#--------------------------------------------------------------------------------------------------#
#
#
#
#==================================================================================================#
# Running Script : Script Body section started  
#==================================================================================================#
# ----------------------------------------------------
#  checking if another instance is running or not 
check_run_control_function
# ----------------------------------------------------
# 
# Trap control mechanism to cleanup the shell after execution 
# =====================================
trap trap_SIGINT_Cntrl_C_signal_function  SIGHUP SIGINT SIGQUIT  SIGFPE SIGKILL SIGTERM
trap trap_exit EXIT
# =====================================
# Configuration file mechanism added 
# 
load_version_file_function
# # Printing some sample variable 
# # 
# white "script_dir:$script_dir"
# white "scriptName:$scriptName"
# white "scriptName_with_full_path:$scriptName_with_full_path"
# white "script_dir_only_name:$script_dir_only_name"
# colorprintf_function cyan "colorprintf_function cyan: This cyan is using colorprintf_function function"
# #
# red "This red is using cecho_function function"
# #
# # message
# #
# draw_line_function _ green 40
# check_binary_with_check_packges_before_arrey_function
# draw_line_function _ green 40
# # Running Command as root 
# #run_as_root_function id  
# # checking weather super user permission is available
# #check_superuser_function
# draw_line_function
#
# Clearing Runcontrl_dir dir if exist
#sleep 10
#
#==================================================================================================#
# Running Script : Script Body section Ended  
#==================================================================================================#
# 

input_question_dir="$script_dir/question_assets_without_encryption"
output_question_dir="$script_dir/after_encruption"
arrey_file="$script_dir/arrey_file"

[[ -d "$output_question_dir" ]] && rm -rf "$output_question_dir" 
[[ -d "$output_question_dir" ]] || mkdir -p  "$output_question_dir" 

> $arrey_file

max=500
find $input_question_dir -type d -maxdepth 1 -mindepth 1 |  while read file_dir ; do 
cd $file_dir
for (( i = 0; i < max; i++ )); do
    #statements
    new_file_name=$(openssl rand -hex 20)
    wait
    input_file_name="$file_dir/$i"
    new_name=$(dirname $input_file_name| xargs basename )
    output_dir="$output_question_dir/$new_name"
    [[ -d $output_dir ]] || mkdir -p  ${output_dir}
    output_file_path="$output_dir/${new_file_name}.gpg"
    password_for_file=$(cat /dev/urandom | tr -dc '[:alpha:]' | fold -w ${1:-20} | head -n 1)
    wait
    # echo "input_file_name: $input_file_name new_file_name:$new_file_name password_for_file: $password_for_file new_name:$new_name output_file_path:$output_file_path"
    if [[ -f "$input_file_name" ]]; then
        #statements
        gpg --batch --yes  --output ${output_file_path}  --symmetric --passphrase ${password_for_file}  ${input_file_name}
        wait
        # echo "$new_file_name="
        # test_var[$another_key_var]=$another_value_var
        echo 'question_key_val_ass_arrey['$new_file_name']='$password_for_file >> $arrey_file
        # gpg --batch --output  ttess.txt  --passphrase qbRvqOIuypdXTlsBXUGH  --decrypt "after_encruption/System_Operations_and_Maintenance_189_Questions/02ad51963a99a197fca68af6bf02ada0bd45a05a.gpg"
    fi




done


done 

# for i in words; do
#     #statements
# done