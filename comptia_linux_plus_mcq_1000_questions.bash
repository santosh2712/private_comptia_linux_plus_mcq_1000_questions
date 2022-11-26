#!/usr/bin/env bash
#Title          : linux_mcq_new.bash
#Description    :       
#Author         : Santosh Kulkarni
#Date           : 25-Nov-2022 13-32
#Version        :       
#Usage          : ./linux_mcq_new.bash
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
    # 
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


# shellcheck disable=SC2086
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
__get_chapter_name ()
{
# 
selected_zone_directory_path="$_question_assets_dir"
# echo "selected_zone_directory_path:$selected_zone_directory_path"
if [[ -d "$_question_assets_dir" ]]; then
    #statements
    cd "$_question_assets_dir"
else 
    warn_msg "_question_assets_dir $_question_assets_dir not exist. Exiting script "
    exit 1 
fi
declare -a doname_arrey=( $(find -type d -maxdepth 1 2>/dev/null  | tr -d './' | tr '\n' ' ') )
#
doname_arrey+=('Exit')
# 
max_list_count_doname=$((${#doname_arrey[@]} -1 ))
# 
draw_line_function - blue 55
printf "%s \x1b[33;1;5m%s\x1b[0m\n" "NO |" "Chapter Name (Choose Chapter Number)"
# printf "%2s | %s %s\n" "NO" "Chapter Name (Choose Chapter Number)"
draw_line_function - blue 55
#
for i in "${!doname_arrey[@]}"; do
    printf "%2s) %s  \n" "$i" "${doname_arrey[$i]}"
done
draw_line_function -  blue  55
OLD_IFS=$IFS
IFS= read -p "Choose MCQ EXAM Chapter NO from above. Use numbers only from 0 to $max_list_count_doname : " -r  opt
draw_line_function -  blue  55
if [[ $opt =~ ^[0-9]+$ ]] && (( (opt >= 0) && (opt <= "${#doname_arrey[@]}") )); then
    # printf 'good\n'
    if [[ -z ${doname_arrey[$opt]} ]]; then
        red "[ERROR]: Enter only numbers from 0 to $max_list_count_doname"
        # exit 2
        do_option_number=$opt 
        # 
        __get_chapter_name
        #
            # 
    else  
    # set -ex  
        # echo "doname_arrey_opt: ${doname_arrey[$opt]}"  
        if [ ${doname_arrey[$opt]}  ==  "Exit" ]; then
            #statements
            green "You have Selected: ${doname_arrey[$opt]}"
            trap_exit 
        else     
            doname_Seleted=${doname_arrey[$opt]}
            green "You have Selected: ${doname_arrey[$opt]}"
            do_option_number=$opt 
            selected_exam_path=$(  realpath "$doname_Seleted" )
            # ../Scripting_Containers_and_Automation_171_Questions/.dbloop.file
            selected_exam_dbloop_file="${selected_exam_path}/.dbloop.file"
        fi

    fi
else
    red "[ERROR]: Enter only numbers from 0 to $max_list_count_doname"
    # 
    __get_chapter_name
    # 
fi
IFS=$OLD_IFS
#
}
# 
#--------------------------------------------------------------------------------------------------#
_clean_user_name_function () {
    local a=${1//[^[:alnum:]]/}
    echo "${a,,}"
}
#--------------------------------------------------------------------------------------------------#
_get_email_id_from_user ()
{

    draw_line_function 
    newLine=false
    printf "\x1b[33;1;5m%s\x1b[0m" "${__utility_name_header}" 
    white " | " 
    magenta "Created and compiled ${__developer_credit}"
    white " | "
    white "Utility Version: "
    newLine=true
    green "${__utility_version}"
    # 
    draw_line_function 
    green "Please Enter user name without spaces to begin or resume Linux MCQ "
    draw_line_function 
    magenta "User Name Example : Santosh.Kulkarni or Peter.Parker"
    draw_line_function 
    # 
    read -p "Please input user name without spaces: " -r userid_exam_full
    # 
    # 
    until [ ${#userid_exam_full} -ge 1  ]; do
        #statements
        read -p "Please input user name without spaces: " -r userid_exam_full
    done
    # 
    userid_exam="$(_clean_user_name_function "$userid_exam_full" )"
    # _clean_user_name_function 
    # _clean_user_name 

    if [[ -z $userid_exam ]]; then
        #statements
        error_msg "No input received"
        _get_email_id_from_user
    fi
    # 
    }
    
#--------------------------------------------------------------------------------------------------#
_check_for_fresh_or_resume_exam_function ()
{

    __get_chapter_name
    # 
    chapter_name_only_dir=$(basename "$selected_exam_path")
    chapter_name_without_space="${chapter_name_only_dir//_/ }" 
    # 
    _full_userid_record_path_dir="${user_session_dir}/${userid_exam}/${chapter_name_only_dir}"
    _user_total_question_dbloop_file="${_full_userid_record_path_dir}/user_total_question_dbloop.file"
    _user_completed_question_dbloop_file="${_full_userid_record_path_dir}/user_completed_question_dbloop.file"
    _user_remaining_question_dbloop_file="${_full_userid_record_path_dir}/user_remaining_question_dbloop.file"
    _user_exam_report_record_loop_file="${_full_userid_record_path_dir}/user_exam_report_record_loop.file"

    # _ans_file="${user_session_dir}/${userid_exam}/${chapter_name_only_dir}"
    # [[ -d $_full_userid_record_path_dir ]] || mkdir -p "${_full_userid_record_path_dir}/"
    # 
    if [[ -f  ${_user_total_question_dbloop_file} ]] && [[ -f ${_user_completed_question_dbloop_file} ]] &&  [[ -f "${_user_exam_report_record_loop_file}"  ]] && [[ -f ${_user_remaining_question_dbloop_file} ]]; then
        #statements
        draw_line_function
        green "Exam record found for user ${userid_exam} found."
        # draw_line_function
        _run_yes_no_choise_prompt
        # _run_resume_exam_for_user
    else
      # 
       __check_tests_before_and_start_fresh_exam_function     
      # 
    fi
    draw_line_function
}
#--------------------------------------------------------------------------------------------------#
__check_tests_before_and_start_fresh_exam_function ()
{
if [[ -f "${selected_exam_dbloop_file}" ]]; then
    #statements
    [[ -d "${_full_userid_record_path_dir}" ]] ||  rm -rf "${_full_userid_record_path_dir}"  > /dev/null 2>&1
    # 
    # ensuring fresh session started for user with new directory
    # 
    mkdir -p "${_full_userid_record_path_dir}/"
    # 
    # shellcheck disable=SC2181
    if [[ $? -ne 0  ]]; then
        #statements
        error_msg "Ensure user have read write access on present directory"
        error_msg "Move into script directory. And try after following commands" 
        draw_line_function
        # shellcheck disable=SC2016
        echo 'sudo  chown -R ${USER}:${USER} .user_session' 
        # shellcheck disable=SC2016
        echo 'sudo  chown -R ${USER}:${USER} . ' 
        echo 'sudo  chmod -R 755 * .'
        green "TIP: Run script from user home directory"
        draw_line_function
        exit 101 
    fi
    # 
    shuf "${selected_exam_dbloop_file}" > "${_user_total_question_dbloop_file}" 
    declare -i total_question_for_chapter_count
    total_question_for_chapter_count=$( wc -l  "${selected_exam_dbloop_file}"   | awk '{print $1}' )
    echo "EndLoop_Keywork" >> "${_user_total_question_dbloop_file}" 
    # 
    # 
    draw_line_function -
    info_msg "Welcome  $userid_exam for Linux MCQ in Bash Shell"
    info_msg "Creating fresh session for user : $userid_exam "
    draw_line_function -
    # info_msg "_ans_file : $_ans_file"
    # __get_chapter_name
    _run_fresh_exam_for_user
    # _run_yes_no_choise_prompt
else 
    error_msg "$selected_exam_dbloop_file not present"
    error_msg "Restarting Exam again"
    _get_email_id_from_user 
fi
        # 
}
#--------------------------------------------------------------------------------------------------#
#--------------------------------------------------------------------------------------------------#
declare -A question_key_val_ass_arrey
question_key_val_ass_arrey[68f955796e9410419949c4722d73471eaaa3704e]=RVnacSHiXeyRCUiaeOfD
question_key_val_ass_arrey[1584126f7b5056e216844eb65404f1e2b052f05b]=hCUlQqsdjSucbzUcyJZl
question_key_val_ass_arrey[24277024e194effd0bd80ce82ad918f9847ee8cb]=RQnUCbDUzrorcAlXtbAn
question_key_val_ass_arrey[d9ccc1e2675ffd4ce15ae104ac45a1a3f03f9c51]=kKfvBVyltMJmaYNQNcEJ
question_key_val_ass_arrey[90739364a08c0a4b92b6d228a09f3a40ba093d47]=MJYpOlDuWZutdAzOOwYX
question_key_val_ass_arrey[73c37e698f52e7d7ca6f69ed55b19c090f11b6af]=QEYrtkBAYzForMtYqPyU
question_key_val_ass_arrey[835b994d3af275bd39fd851571fd9ee4b6dab69b]=UPkuqjIzIvlTjHRfNwET
question_key_val_ass_arrey[6b9505c99816bd623cfa1e85eabf0aadc03ed4db]=IQjaoeUnJFKYfnIALdFY
question_key_val_ass_arrey[ec1af86b6f8d21e9844cf8d4e2f92aec9864676d]=XvTIhWgFpSFTFVOsYGZS
question_key_val_ass_arrey[4429b2048241cf28d279d9ab12d4bbc5483c39c7]=cuEIqVuFwBamMCRcmZlu
question_key_val_ass_arrey[ca97118caa806d81c6e0233ec8ca1359a681ffa9]=OXbXBLnEMHgRsurRDIfY
question_key_val_ass_arrey[d66f60f9e5040fce9289b6a718c698705467e6da]=GEwqbkVHPalZzLTAzMcW
question_key_val_ass_arrey[95585f182ebba949cd556ffff8d98593bc61cc97]=quYCqfYYMqDymYjXFFWG
question_key_val_ass_arrey[be0c781da5e4349370102d28d2e3d62ac70da92a]=nFsCLEPUbVXdiQXVjMUD
question_key_val_ass_arrey[37903e4c873e00f2efa644cd7c290dde3a5dcbb4]=XHUPGSoFtAeQdYnzBoHT
question_key_val_ass_arrey[12673db8e9aad5814bae61f2e42dd59ba90cd70b]=PmkSwdaIuuLCjodRvVLB
question_key_val_ass_arrey[00772d64ab40f13a3fbc789ffd89842a1432f817]=BvLfGEBphZIZzSSkhysw
question_key_val_ass_arrey[584faeb5587f9528388bfb41234aaafad0a95c40]=FNGVIJcxeManzCmHQzdL
question_key_val_ass_arrey[e829e1920a71a0b2e598cfffe77e2d1cee7a240d]=ZCrDPKhNXXSDFpOxiter
question_key_val_ass_arrey[5a62dd265f61c8f46dff08b410fbea14d6d1a779]=KzwazRQDwmzHKgTzPGON
question_key_val_ass_arrey[3f0523f1b116ee4afa2b02b63eeb6ea7457f78e5]=YGCjiSzAIvtUeCKabnHo
question_key_val_ass_arrey[2308854f75bdeeaa21dad951a3d9e470d2e7b756]=eDjTJSDhATnvBwXrHpzM
question_key_val_ass_arrey[fe96d8972b0c2911c781a013922828b9e6e6b114]=hdlCnGUHrBQhqUPiTjaC
question_key_val_ass_arrey[fad4bcde9595c94f1393e45f4d5d65dbb1e94469]=IMroVXKZmBhcQbcpwGvu
question_key_val_ass_arrey[5a36e13bffa53c5d3d4add68594262ab67d63daf]=sEHjSCEtNQtrXltYCpuJ
question_key_val_ass_arrey[08b3087aa5c7721433483945050f86737814ddb4]=uRqmsDEtWjDPOAQzKiaN
question_key_val_ass_arrey[efe87b2a58bc0c517e7e63e09d4f43746a3805c6]=SiWXczHYNMEHdgSbzAdd
question_key_val_ass_arrey[dd73d13603e347caef00d9947447a974a79cd565]=LrGYxKZWeYxpdwZYrpMn
question_key_val_ass_arrey[81a4c332a7dcbd107498000498c36ab1d1226df0]=wmAsCDHQQBFaTWkOvXac
question_key_val_ass_arrey[460f107d65dda9d12f7db1c2e8d3e3f1057b91ab]=COzLlwpXRQVyiQVEHBgT
question_key_val_ass_arrey[2a8a933d98ecbccaea4b15b5d5d03b9b2bb10713]=NaOHSdgWSYzDaQqwurve
question_key_val_ass_arrey[ddab4566782db912b1085d36cb1d12da0e1021e9]=rEiMXxKpVNSaFdTbHkaI
question_key_val_ass_arrey[c9d4894fc1ed0227258293385d700a3fc51f0200]=ZlkBkEEGdFiCphJjYBJl
question_key_val_ass_arrey[3d7488f82579e9580606464a0422e7a5540f88f3]=eOQUPYrrNKsMakRGTaVg
question_key_val_ass_arrey[d7167b161f96cecef776662c79d1be283be3330c]=gJCcUtVZtLMdDYoPkmFM
question_key_val_ass_arrey[e1c2226044b88200f7bc4362dd385eb9f48dcf11]=aUtiCAcsniTuEjESeUcA
question_key_val_ass_arrey[82d1a421251d802c394eb32c5e0c60e73fd70cfd]=SuVYWKNCwgzTpgdVXuYd
question_key_val_ass_arrey[f50bf521a50bb632eebde424827710aa47d1e14d]=DBPxnGuUksYRgLMMLfZo
question_key_val_ass_arrey[9caaf61867bebb774d68589f647ce1290844f752]=uKanhEMYHMwVwVXCqnvD
question_key_val_ass_arrey[c3bba6bb912d4625c98b1871e9e721a4d5a4dda5]=LgWZKbtUvejNsUegdcoY
question_key_val_ass_arrey[b64d4fa26af847e24c38cf4de07e21be99d97cad]=RutZuUafzVVlYaqmdzOP
question_key_val_ass_arrey[b0431e092610c7f44167690fb5dcf94d34f2303e]=iAikxaVejMEEEtvWERtg
question_key_val_ass_arrey[d0b2561cba749a5aa1aac0a52550ea26fc0ede15]=uLGVGkzyknhSAeWiuZHn
question_key_val_ass_arrey[a188b0b5bda5dbcea0448da1977ce53505c009bf]=aGGbkUeyLfBuJVnNjUCH
question_key_val_ass_arrey[251c0cd0b2027549567977da5d7aae6e338faf59]=OulIcEBQhzTlPhLbRCMC
question_key_val_ass_arrey[b0cf944c4f497a61834d1524e224ee627e998f1c]=NDJyZSGeQlzWiyTHfdtc
question_key_val_ass_arrey[6abe6560fb30e9f5ba2a8bf44641099ce1022fec]=kAcSrKRZsAWOURbeDNdv
question_key_val_ass_arrey[c5a63ccc819b58e7db361699c29fe7bfc4fcead4]=UcNEmzysJTesJmpEHExH
question_key_val_ass_arrey[4552c52e2e277b1d85d3bd87f76c380c6e5a50ef]=ySZylRwNVKmBkJaMqMPe
question_key_val_ass_arrey[026542b7f2a9c92391a06eccedb8bcb2cd72c134]=TcyAZVepTeNbnvmoJjca
question_key_val_ass_arrey[bb3eb8cb9b0134095b015c9a4fca85efac83d55f]=KbjUHBixhnngoKWrFHUk
question_key_val_ass_arrey[6701fe3c67d2ae93a509365ca39e95d275bf3e6b]=CkqMVlFDEVZYJmZcYdZu
question_key_val_ass_arrey[8462880f0e2087317d31a512f0cd6595c8a3a381]=iawxrxrgtdVIlDoNEMsi
question_key_val_ass_arrey[d827b0b7524abd2b33b386386cdcfe3bd03af02e]=koHksOgkQDGZSbPOABWC
question_key_val_ass_arrey[5592ee68522ecb5b1c78477797fc341af3e01d9c]=FZYEASXVDqVoEwrdZDnc
question_key_val_ass_arrey[649398f22205044debf163286f0b18226a23a643]=BrIHKarKGTJpMygZCqFG
question_key_val_ass_arrey[59279c2fb90af70bfef7e5945a382b7e5414cc08]=tAuWACdSSSQwTmlYFLvu
question_key_val_ass_arrey[a107ac01cdd25b5c260e9a9c2f80a4cd88bf4e9c]=qbSExWmtwwdGrqtZftIn
question_key_val_ass_arrey[e0fc0d39583ee7e0d5a33b8ecf686c666cf6ba3e]=iAwoPNrGqGsLCOJXReBO
question_key_val_ass_arrey[a68057ec85261954755df6aa39c82c5c1eafdda5]=ECBDlxdwTAMedxWLGFfh
question_key_val_ass_arrey[7df5c89f4b48fd0066caa0dcd9997bc1383c321c]=GQHQevGnYKEAtlOpJsfR
question_key_val_ass_arrey[b958e702ba60b16bb87f095567fea68c5bccdaa3]=TzYQLUiREmIsmLZudLyT
question_key_val_ass_arrey[d6e53f4f1020ce92a46684b08c84e622ede49bd7]=KxHHxKsUyKvchAwKBZlv
question_key_val_ass_arrey[fbf8dfd04a65fad83f5697d84d40904e68a8000d]=veZMXjQJthzUffHACzNv
question_key_val_ass_arrey[a9b764e0737437cbe3364ea23f337c47c8f308e9]=SibzhKHGfHzzsMXEuOFh
question_key_val_ass_arrey[fb1973d59dde6e40f0d9798979c3bbe02b769bb9]=RRFSysRdiUqUVVhsIjtX
question_key_val_ass_arrey[692204f07cb59d1209effcdff22d65dbbfda0fe6]=XgqXehAWxrZEActLlhrD
question_key_val_ass_arrey[b725a931b80034ba0f71d9900ffd43064ada9d0d]=luoCZDyanWgHLpFONhNU
question_key_val_ass_arrey[a27d30d98c8b69523b5781853e623930b9dafe48]=mgbtolXvqUsOQljZRxLJ
question_key_val_ass_arrey[38a98c35af3e9fd832c4121a65088df079edd482]=cbytdEREkYqcfMdcyZEG
question_key_val_ass_arrey[e4c02d1d4dee4f7b3c0c809b70495232a2de8841]=WESddjyMjcqJdQYnUHLg
question_key_val_ass_arrey[3267c975c8dc718869d5cc5f9ab7dfe0d3831c9d]=kYIKXKxgruHpqqeeJdFM
question_key_val_ass_arrey[47e200406b2d9fd96bd994b3438bc1697aa6f683]=eTeuUptJnlJytRCYVvMc
question_key_val_ass_arrey[3d14249987840c5d4f3c48cd5f3b696ba38f79f3]=PXvTIdJQkYsxNLDbPFdh
question_key_val_ass_arrey[03cffad943e46741701920861b532f1c58b08efd]=WWXcPTFyCNkumppFpXVt
question_key_val_ass_arrey[93153c625409f247bc9f0dbcf3b166f7a143ad7c]=mZsnUUbOGZPLMHjlVBRT
question_key_val_ass_arrey[5fe02dc037744cf0464de392760d3f2bdffa109b]=jacwjyjxDGLIoVDnXKjV
question_key_val_ass_arrey[12410e97c2a26372b101b6aa7d00a3b60c4378b7]=gqTuipYZHqEWhWDcywub
question_key_val_ass_arrey[86167947c2410cd051a9e06dfe621b34e28b1cda]=HgpftlcvkNsYEFmeziLb
question_key_val_ass_arrey[3e66056c3876170626858bfac838789813a6728c]=jXLUYvQhrcwEJiLqNsal
question_key_val_ass_arrey[db2457766525f0c48c3734855a1abcd9ca96ea4c]=sVdFXkLogasAHlVLDaKb
question_key_val_ass_arrey[8e876a047803502c60ece37b0b7f9c06e661bb78]=JMPKWpackhHKHwPYbiYr
question_key_val_ass_arrey[7f76cc7573fb4b6fd123ed237a5ba9bbadbb8b1b]=QgIlkubyLlrMndImIDiM
question_key_val_ass_arrey[9e8a05051181e753fb9d2b4d94edf764ee8b0f14]=AjHKOTCZbBRwXgMqmcBf
question_key_val_ass_arrey[6497e04085241d860c3e1c54364580903f30f5c6]=GgUQkrGxxobryhtkSYjQ
question_key_val_ass_arrey[003fdd1f4244bd1d8d3e0ad00e7bf60b117c39a2]=KZSRNFGxHubzkHZluzQz
question_key_val_ass_arrey[fd873d09d17442c443864131d34053a1a52202b1]=dtcPKispKUMtexBuoReD
question_key_val_ass_arrey[13d68a0e88a907e249b577244245d62b44e3d4bc]=CPiVzGUwuLiYEgMyCvgN
question_key_val_ass_arrey[9ac006c7b0c19830e579d3d68aa9f005c6f5dd30]=THCnFbCyHcsPEFnbhhir
question_key_val_ass_arrey[c1f803638a02fddf2b5c8fe97719cb83a22333a8]=fciKuRZBbWiRfAPrTdZJ
question_key_val_ass_arrey[f8925df3ef2a243eb450095b6ad2cd6743e6a5e5]=gNNirGiiJqzepNHljoFc
question_key_val_ass_arrey[78271a2a9e59b9eb4055c5ee51f8d347da5984c8]=rkuVZYnNbSJdBTEboDyw
question_key_val_ass_arrey[3b496224c74107c8956544d5b4433cca6091dc31]=DpldqIwrVHZydMxwhsco
question_key_val_ass_arrey[ef599ce31023042141cd6e836e7377cae682f9aa]=kIqAVZBRDGTjlpSwOSqr
question_key_val_ass_arrey[cd58e15feedbe6704eaec4f864ba53f2023815e4]=UbXzXaIdsMlVLMIGLZFS
question_key_val_ass_arrey[82174f36322de02eb21a17d05eaf7b76edee0a84]=aVnyZIKRYnLLzDinRycL
question_key_val_ass_arrey[cf4dc6d404526311d4de7a6e4656c43c9d990648]=YwReXUdBPsXerRBCZSQd
question_key_val_ass_arrey[8b24ca26a0d90187de1e735e4d1a36daa596b077]=sAHjjFrLoGRgwkLofimI
question_key_val_ass_arrey[ebd5e9b31ed5d5d079f4e2060569049ca34b4ac6]=ZEVroQPFfQYeslAXuxWC
question_key_val_ass_arrey[d406f206c4759c1599eb503f3c7703fdda48c2a1]=QKKLIubIAitspgkFbKVf
question_key_val_ass_arrey[d06db4c372b91e4facbf4bd26368c6c440fd4574]=hOhBzUNDoGpxagAjfsOL
question_key_val_ass_arrey[3d80869493d613c978c1f1bfba690f60624c1162]=DUWnMtFlNCZRqAZhSpVF
question_key_val_ass_arrey[17ecc2eeb5ed5b5d62337b7ae0374971b4a0cea5]=mMGVdCuUmBnrRPZSfQDB
question_key_val_ass_arrey[a4f7334deff0baadfccffaf2aeba26777a2be618]=AFdcnnhxiEbRPUXAwbRQ
question_key_val_ass_arrey[250ef2c82f958c2dcb8b99282a12e3f64736c52a]=vNAkZPAPKUMCzzeaDEBU
question_key_val_ass_arrey[1c026156316d6127066c7d4b08dbcc3067cbd41c]=pZEOqIwaDPtGIGBsvGNF
question_key_val_ass_arrey[fc2cad0c2718cb0873a5821e53f5b2e4a4ad815c]=iczgNyaGksPgySKaOjmt
question_key_val_ass_arrey[98ae0a3a2db6f9441e3595c0b7d99c4bb7fd4fed]=jXOcBgXsyhNyFBgTsuTg
question_key_val_ass_arrey[6004d4966d10c9435593c021d680131c69c0e9da]=AbWPVVNHPwUTxkzPcQpo
question_key_val_ass_arrey[fe34165d9a81b8d289d2da892001ad1e851dca94]=QWZitlgFeYtuYAhMBLLA
question_key_val_ass_arrey[917b1d05d44b98b73deb5832eab85a6214b934f9]=wWsxPeroMBJORNWVnPeD
question_key_val_ass_arrey[fd6b898ff38ed080cc96d4f9eaae4f93be87a44e]=MGWisqTVydjFaNoTgzKo
question_key_val_ass_arrey[89ad92f6d1afcbf96e2a1ae59e4dd1a340465c5e]=PaltHsKQjIhbgVoWiHki
question_key_val_ass_arrey[3fcfcbf1d1aea3f80c04fae93c1b0c6bf219ba07]=hABIElyjUZnpaqGJOUcT
question_key_val_ass_arrey[2b6d352d6ba45d2f025799fba1c12c8ada0ca692]=sqtFrpiQxcLVnHNyxhJy
question_key_val_ass_arrey[d72db036c2890be9f3c1ad6da8921f49f0babf09]=NxzSmrdtUdvJDmUHAnlt
question_key_val_ass_arrey[7ccc1ada1ca547a6699e79c23c57cac6c387f347]=MDHRFLJpmswTvwKumFuQ
question_key_val_ass_arrey[1b1d552149e7c8ee9b93ac8ca3980e852367e62e]=RBkruCKHbwdWQwRvlTxo
question_key_val_ass_arrey[7df3c8dcd3e70e56081fa47acb6926e184cf262f]=EnTDSFVyvzYywejkYspH
question_key_val_ass_arrey[bcd7da2f00929967bf53b74166fbcc34b21e4e75]=TcUfPDTLEfORdIjkBAoK
question_key_val_ass_arrey[e07653b9a6416a3baa6cc2f89bd72e0d0324602a]=oVKqlokDVnyhjpLKjAkm
question_key_val_ass_arrey[14fd52533dcd1b00104cdbe36cea746960bfeca4]=CdIithgKLQRWyOiRfJrf
question_key_val_ass_arrey[26bc9a47b735b9316a9cc089cd682e686ecf7b82]=nulYqVoykbcWMMeeLSXn
question_key_val_ass_arrey[06da3087f195b6c149f44df9f3ba2b3d94ddf74c]=WSHoYPjLMZiFyQWDZtYq
question_key_val_ass_arrey[fd8e48a586c45fe44d8ae3afbdf67edfd31a00f2]=ZJcJmidwvNeLWgTsGhbX
question_key_val_ass_arrey[f90c2e44ec6643bda603daf95c62a0921c9e7fd7]=cpqGzzrDEPbBzRiPvTjq
question_key_val_ass_arrey[3616e990f83b173392940954842a038fecbf0a14]=GNyRpbNkgRQXpkcLHfNQ
question_key_val_ass_arrey[2b969de124a7bca6432b5007432a907a6bc6549c]=iCzBLcbDWbUakPddhHOP
question_key_val_ass_arrey[515b325ec0e86993d43151ca3ba316b610907a19]=QwwonooBBrIgUcyqrLhK
question_key_val_ass_arrey[dad47a927c316bbfc2ce81a684432aa1d725aa73]=EEqzwUauTzAaeNrGMQBu
question_key_val_ass_arrey[7d320b1e5e4f86cc6bb23a417b0b8d6fa055778e]=zjQbGBKlntPGicKWpqYS
question_key_val_ass_arrey[ed9519cea619361e61328908caf44142145f00fc]=uViRPixkpQfDsGHYkIcz
question_key_val_ass_arrey[54a868cecc4b4c1a69c50664c261da02cc117326]=oRdyeWWPlDEayUyeCdad
question_key_val_ass_arrey[838aa42a6c5ea0a65fa9a877cb5ba83f3d8f1a8d]=AVikSOmNtaMVOeiYlasV
question_key_val_ass_arrey[a2dc9779894912a7997e0616cdd9d21d84354e6c]=YBbMNwOpxGKomkMUVZKL
question_key_val_ass_arrey[ec44db4bbee9d37c4571c15b01011b233e2130ae]=wCHxPmOpplgQDpZhflTK
question_key_val_ass_arrey[5f2d8c22811e483fd359b6ccd3324b797503e16b]=JuZqAJRGjWnNVadmHGWG
question_key_val_ass_arrey[d5b32c6b0551311ea66c5b5e8b49b8b0de8413c4]=IHAeXcOfCgJwFmxReOgU
question_key_val_ass_arrey[7b075e582301742a61b4f161abf5032c4e696325]=JGclVTTYBWraYIVrHhQL
question_key_val_ass_arrey[0ed8af8b329ae429b0711dd6411ae748d0ba7c0d]=sDFGvLOPIwprDTCfwHsK
question_key_val_ass_arrey[33ef06e3684ad35e83001e02824f331140ef33bd]=UGyUejGkmPHYktQjZaOr
question_key_val_ass_arrey[3c3536f6e5437f2f5377a11efa3f92556c37abb0]=ncUmxlpNiRBzrCesYGNz
question_key_val_ass_arrey[063430cfe1ac2a57c75b4bb487235c38c8a552ba]=ekIKiBQTmDaWLhpPezzM
question_key_val_ass_arrey[9b3dfaa12d8ae622ff7b7c122ddf0631cdb1336a]=HrdfHSUjbKOvauqnnDZa
question_key_val_ass_arrey[6804519b8029c1564f9aa98d1e0993dea839a8a3]=rjLkBxJWEXogrtKAoQDW
question_key_val_ass_arrey[d310ddc6073277b7d9b79ed532624ccd101e2d56]=JANftrbnQAdjgWKVuExj
question_key_val_ass_arrey[8f02501aa7219ccff7d57bc5888d92ab74396be6]=dQAqSuYyUMKYkDrCmOfD
question_key_val_ass_arrey[86ec6c29fa4bbdbcd44987ae13c9b7331f7031dd]=XgwdCBjXUvCfsMBIhSHZ
question_key_val_ass_arrey[c55ddd642c2fed5f253363cff157e519e3601018]=cwmfQWpZQZOGTvkOxAVJ
question_key_val_ass_arrey[518d0b624292bbf9844be1eed9c63ebcd9e2b86a]=AyrqPNiIpkljffjmTlSd
question_key_val_ass_arrey[f1d08b38faf86ad011e58ca370a417f5ab1e82a9]=WYiBbtkQNlAnrbiwzpqr
question_key_val_ass_arrey[e63c9b5a7e00f8e1c86a33e1fbb301d2694c9e67]=ueqUPSDxdrpXDfDTkusn
question_key_val_ass_arrey[2091d624c6b2fcf626d88bd0580bebc738661bda]=yhDgruduNgJQqwjGEEbn
question_key_val_ass_arrey[928be1f74b958e4a397c5eeb6b2a68b19d41aadd]=jpAApEJeuniRWxXJYNuT
question_key_val_ass_arrey[e1559444324981cfc9779692c1e34968f7784212]=YRwxbcXUAckioRRaNThb
question_key_val_ass_arrey[834fd67d1589cc529a472326fcd633c5a5efc0f4]=AiroKEuMtcttiZTXXYsO
question_key_val_ass_arrey[ab040be8cbd23abd3d9a8c3960c283e8c451785b]=EqCDWFvfrnDFunLmyunn
question_key_val_ass_arrey[8f84283ef7135ed807777e6e32b66bcefa56e983]=yOLJrIBoNQPfyZYqxUAw
question_key_val_ass_arrey[9830102e2282593fd03da2f654eac0211d14477f]=YdTQLIhWgWuziNhhVkup
question_key_val_ass_arrey[6f6a55c2192938669b0334fc3d7bde97447a9016]=KyLLiyCVOgHZtwrVDQgA
question_key_val_ass_arrey[e024ed6be5de81c8977c89e712854fe0670ab869]=uvjueVledCxbshAsApWZ
question_key_val_ass_arrey[8b146002a954a6f03f89f2155efd0ef9fce4e6b0]=vCKtTZUUxXjXyHxSOhuw
question_key_val_ass_arrey[384f2872fd8bf4ac4626e10fccbc35e2ae25be8a]=USwGvywHvyoJaTwWQDlK
question_key_val_ass_arrey[76e092b861262b5897e2effa0e40ddbf299eeb35]=UbjFGYmJzxFZNheYBNVm
question_key_val_ass_arrey[237617ba2db27ef8071cb1bf5f72319109a58813]=PNEOwMaahciymztlmFMq
question_key_val_ass_arrey[52522f4e065179b482dd2b020e99e035e6f38639]=oQpThjipBGlxDxlOIOop
question_key_val_ass_arrey[bc5746ab592df3108089fea44f5c8cdd0c0f7ebd]=uxaPwtvzHUuJxtWlvvdz
question_key_val_ass_arrey[f9b6a40ae5cca451675a07eb325d282e79c26f0b]=XMyLIqfAETMjVEylWjrL
question_key_val_ass_arrey[a700dc2836a75f365a1c1ad86bf7d0ca2d659b77]=cRDsAKKbeuxbgtTiyGAU
question_key_val_ass_arrey[7e733577e5cc3cb0289e9442f75dc28cacded24a]=EbKYMepGseXvPYHtpcKN
question_key_val_ass_arrey[b701d54172b304e9f8e0f0f16ec1711217ce1560]=drRwbeiCDWbklJnwseYj
question_key_val_ass_arrey[96ddcc284102cbe2e7df6392c00ffec74e070183]=YCIywgYPAhGdkyhDosbw
question_key_val_ass_arrey[e69d653a2d9bd10bbfd0eeeff931ad9aa064ebf4]=ChZTxsFOSEiZyQhrYpeQ
question_key_val_ass_arrey[b2c14fc4647f67d50f4216224ea49825bd6ae793]=KAgkibxAcarSOLLQBmHG
question_key_val_ass_arrey[37e4310fa2d046d1a7db86dc37b9bcd158178278]=ANoatkjWsVrzzZxynOWg
question_key_val_ass_arrey[62c851c32af44cef64e750054366d4bfa01dfe95]=iJNGvHjwPSlICkCMkthW
question_key_val_ass_arrey[d296b2a076672f82a9cf29c93b725d0d90931bbd]=KpsTnyJlLNZWOGUOfmSs
question_key_val_ass_arrey[bb973d47d0e1397aab57119df7ab9e6b7765d0b2]=cWGINVyKSrfDelysUZjJ
question_key_val_ass_arrey[0d5e5e377c8247c40ea4ec1d6ac23b2121da6690]=HoEHRqmbklAiVhnovikp
question_key_val_ass_arrey[fbe4f9a2a670566b963e0fe779275efc6fa2b1f2]=MFlSohXgikXnlvuLRRxc
question_key_val_ass_arrey[29c318b5e180356336fb065303a2b984f408e3a8]=BTapqoBuwBTVoFokhVAK
question_key_val_ass_arrey[1a8034cf8df412478fb0dc09bbaa3f9392363945]=sRTkRZbyLvHGJQnjAjTN
question_key_val_ass_arrey[9f731c4ffed6fbd9178403a5c307c7a92abb0298]=GyhoFJwDubSdULYgsjup
question_key_val_ass_arrey[507472422634485a85a74721d7ea3ca8e2f22740]=AAfvnfLTUQoPerwDJLFF
question_key_val_ass_arrey[2d7e15a24d4ea84d404eea714cf3ea2c772f032a]=mZaXPesTrTrGYogBvKKE
question_key_val_ass_arrey[a8b61d64f452262589305e901a40ebcfde6c36bb]=aumBnEchILKOsJRGhDtC
question_key_val_ass_arrey[83446f302bc52aafd6e017ced6f47cd9aeeb53ed]=gqhREXTlCtAMxQcuiSGD
question_key_val_ass_arrey[ff7f64edb6938db6d2b2087a96a46b9638da650f]=knqywYXFRdwRtZWJhcHv
question_key_val_ass_arrey[be81a89e0de9bed70e7660a17039a75f32d731f6]=ubDSxOkUMblvwoGFdLyU
question_key_val_ass_arrey[500dbc23b9f628eba75a9eb4d561af5a3b872926]=lInBHTdPcmpvFKTmDAMZ
question_key_val_ass_arrey[260b5337414d399646d5c2590e1ea036d83e5208]=SPDAASLAUDECSCUPVMmH
question_key_val_ass_arrey[d2d2724d0a4d519f3bf3066b5088a26b18a6a975]=KUfHebGhlMNaYJnlFMPN
question_key_val_ass_arrey[123a90ffd2a0557220418b44801ac51c2b386d39]=WvHPrVjksiOHXCEoEipF
question_key_val_ass_arrey[0be66edb516c990b5738462d6bd312fee1855d3d]=EjxfIiOpFvQkUWorufNn
question_key_val_ass_arrey[fefc2c2c5a888a9c3da5679a4625a68f21561ad4]=gwoqgqAXtrAeVFtoUnZu
question_key_val_ass_arrey[ef7d9bec79a2f0bb90e07ae217e6b53bea7c8d1f]=cQIuVDupfPqlODvTOzBa
question_key_val_ass_arrey[7d42a4f995bb68fa6bbb99c626680477d35db7e9]=LVmFkyoHZuOmyTiASdji
question_key_val_ass_arrey[b673efecde5fd06fd38abd7be5525a2cd6998bd7]=FqNqqDzDiZWcLRnWYQex
question_key_val_ass_arrey[30c1b1b19c0be9456416d3e2b27e30abcd4d8772]=nkZRezRkmCBrtwHsnqUF
question_key_val_ass_arrey[7297e86697d5405cf11e220764f2ebfa571b86a7]=jmjmpCycBzhXgqGxtMxi
question_key_val_ass_arrey[709bb759cb065189c126e4bdc8e08ca59055dc6d]=NrAReTSUMztviopNnMrG
question_key_val_ass_arrey[42bf514ebfea384f7e6f823717aa89b6204b6ff6]=iPWUYZeNtYYCyyNqmyXs
question_key_val_ass_arrey[86600871de7770a2c8fa495d8538c875adf44139]=VbvMzpqGqbFVtvnDgzTu
question_key_val_ass_arrey[338f46faf6cad5b39d578aab0290990b4b1e55b1]=wwiizPgFxldZGImptkyN
question_key_val_ass_arrey[1d016836485a79d0b24e841d732d06c30412a763]=mZDgNfHiZMgSQAtNqxKU
question_key_val_ass_arrey[4c386e2d7fcd517701bb4e592209228e4c229b82]=yVypKdJyicZRLZxKwIMV
question_key_val_ass_arrey[536a46f6e979b3224e9f9dc2d53e7eb8d8f1c365]=aLtsiMbGuzuazxkRKnus
question_key_val_ass_arrey[a62d984c0ddfaabb6d50bb1ebb46b97014d6d1fb]=zkZGAYjvCxjzaKbHwXsw
question_key_val_ass_arrey[ecdee0bdb95e2321c9ddff65e899d60fae864ee2]=YiprxbtrTeMHUhBTCbxU
question_key_val_ass_arrey[529e1eeeeb987afd19072a1609411b97e65f2172]=xQMGvgdKvuSIimgqaaHQ
question_key_val_ass_arrey[a77c696d18b7e8eca0aeec6fbd0997603b018e70]=jNUiSRmADMneZSHRfmeJ
question_key_val_ass_arrey[489a90dfa0ea6a57b780a281adf0500938112465]=htbSoVdxoziqAOjTbdNH
question_key_val_ass_arrey[e6cd8723fe15e9b8ab6d2ec9e35c783b9e0d4b98]=DjLEjaMoTdcQhlDtcONu
question_key_val_ass_arrey[2f43f659c375d3aacc601bce0ea1b0a9f7d5b661]=IHMWMEdtwyuuXNrRlYzN
question_key_val_ass_arrey[c62af300946246fd985eeb37a2b5fa0acceb4ee1]=aqZFWnweHGffyVpnWLFG
question_key_val_ass_arrey[be622479fdaed195a9cc44b88c26a08c45cddbdd]=RTFvfsMtXmCVVIMUdHdv
question_key_val_ass_arrey[ce8d43ea7b13c7a7ea7c228867f68c9f29866480]=FjHigJVtXCGQVYKOYxfr
question_key_val_ass_arrey[348063394ac92280c5781b5744834ab7714a3b28]=KgHsOUCawmMxtpaYIDGp
question_key_val_ass_arrey[3e7ec2290df570fb805fc65ab9559462a499c3fe]=fqCAwhkxTOxiHycvMfCW
question_key_val_ass_arrey[e0cf43e168fc2ede749a0fc16bb29eb64fa5a45a]=zylhMjihSYfLAByuRtum
question_key_val_ass_arrey[b52303c8e4167ed7b88a5b89d74326d3c12d9f95]=ipHkjsKEQCSMsdqZPUfI
question_key_val_ass_arrey[6f3309dfc6daafcd93aadb830469a026519dc37b]=kYgcwxgWzQjfwvePEEur
question_key_val_ass_arrey[b16f5be497fffe45f81c484fc4a8997e6c29bde8]=pDVNBuOLSTnaZzPAUJsH
question_key_val_ass_arrey[133bc72e7a856edd3cfe2a70387ffa7639d0d228]=LrRUNmMoDjuKvjFZtkgd
question_key_val_ass_arrey[63551e693acc35032bfffca09955689979bb1b26]=RoGcbNxvusUSstUliThw
question_key_val_ass_arrey[99fb7b01910b49e57304a8ab36a65f6325e446e4]=mpdKKnEsptJMzzlSvIrn
question_key_val_ass_arrey[b07c044c2605fd4775e6901073e35e6ff74cf621]=WRCgHDhgOcltSWMNfsDX
question_key_val_ass_arrey[cfa644e120416985c2f9a39ada082c2fa4712a24]=JRkFCMLKvMWCoGruLlJu
question_key_val_ass_arrey[42514d45448527b11195a96b5f0454926781bba7]=MYyVhUQsBSRFzSwjfVBG
question_key_val_ass_arrey[8c0f70a4653e9061a60132100074dcef1f4e4ae1]=eNjxKrgasYxWxtzGRdtt
question_key_val_ass_arrey[2a90c577569345d98b668e04748ea7386ec85d8f]=ixODPnTfsuDlFjIryQNX
question_key_val_ass_arrey[b91c60539a1c0ced47d884a9fe8b21f43da95663]=SYXcyGrZnksFQZLtgIMt
question_key_val_ass_arrey[a7b9825cd439c84ccc0925f367b426e60cb06d2e]=qUbPBHyATcFCyaGrsGfc
question_key_val_ass_arrey[35f04794cd3edddbc3771116bd3c33505f5a14c9]=cKXXxttNkFABGkKYYhGf
question_key_val_ass_arrey[2ce990be526d95169694e96ce0d8f52c1227fdfb]=exbMgxAeDJWvUbkcRhZp
question_key_val_ass_arrey[adfc19b9f9a29f98962e520b6716b5ef7a94898f]=pNiMPvfRVlFrxGcKgCIA
question_key_val_ass_arrey[e35e770670ecc8ecacd8c6d413c810a085bc023a]=CxutbXUDTaMazDkbNTFZ
question_key_val_ass_arrey[0c069066e3fe52b72fa722e91b5bb0f596fac848]=evHUeONrTtYyQytRCRoZ
question_key_val_ass_arrey[9e582516c4f9aedf6d0670652944ea233fe0587c]=zAIBbmlpBEYrgPMSRshG
question_key_val_ass_arrey[05fd7e0f5fe3f57e8097e59127c1168581bb4a7e]=ABEWZKODqaWZARamVsYO
question_key_val_ass_arrey[586c24c185923c717f4062e5d55dc47aa1ee885e]=pWxkkDBQnSUfKZaUUdIj
question_key_val_ass_arrey[63685d53ee9984a0cefa3340ca5d77628e5f1e13]=WmRkLhlkYNCTbKYKrYtA
question_key_val_ass_arrey[070b31ffabb6f29de933a94d152fdadea23bee7e]=idHyISCtTeVwlePwUahD
question_key_val_ass_arrey[0dc0f4e89bf3bb725b2d3dbf9a6f4e60ea7fc59f]=zfSXUOkJHbnXzZzLNixG
question_key_val_ass_arrey[3ed232d1c9d487e1046618086a1eb6cdff4dab5a]=EEDHyoUNMyoBnRUbczjP
question_key_val_ass_arrey[0d2e98e86dd615caa6e8a23a037af670aac03c2b]=MKdopSFQAzVFiNhKlNRK
question_key_val_ass_arrey[1edc664c6eaa5a442ec87a74b5f7b3d178c8f811]=aQutvbAYidiCoyIRvaAX
question_key_val_ass_arrey[efa4c2a6292968e01a5636cc3bcbd238896ed682]=uZMIPKsfgxJRHKtduHqn
question_key_val_ass_arrey[50558884351d020b79d82cf0516e2c13a8216c28]=MyjtJTGNJrdOYwNVwfJC
question_key_val_ass_arrey[f4097c343cf0c5d031891ae2c3b14d68c654faa4]=FDrPIdcVjySlpazjNFeF
question_key_val_ass_arrey[c1220f2ea1201cb5dc67b7ef828fa58ae8fbab54]=rktTrBqrtgJDAjSrqtvD
question_key_val_ass_arrey[be969d6301cae59f36e22ae129276e1d092054be]=ahtUeAsGSzPLaKKzthcJ
question_key_val_ass_arrey[02a1238a2daffec917bc124b639985ca24e14916]=MwLaKUuezUeFkmlNFXum
question_key_val_ass_arrey[938473faff0a7bd2562f3914ed8d8693f7866f18]=KpvVWGrYrOtslJYsuWIF
question_key_val_ass_arrey[1933b4f2d009b04165f51e618b6ed77ebc5d2d12]=qBbaFZiJMNtOqMRxHkDb
question_key_val_ass_arrey[76fbd3f14e9b682d68c91f55a34a207d01305518]=ubEEvBCziAunJHUNbHaG
question_key_val_ass_arrey[97c7e2d87112486b6526d61c54fb310766b99b56]=BoJzlIpBRkBhkOCoQxcd
question_key_val_ass_arrey[0750b83ce84405f33b0440a117504b7ea7977574]=voqQwaCPFxQUosyDfYLT
question_key_val_ass_arrey[5943d74d3e25e91a56debeeef85bf0ff513d9206]=BIICmHAbfdgssRqUiVrs
question_key_val_ass_arrey[163ae275302a06d6ab30f402ae36376ab95340d6]=foYyhaLkokNMSSRVHECb
question_key_val_ass_arrey[6b92c49c456a94c126ee1b467c38ae795569a3d2]=LzVyLRhFijxJFQIzbaxx
question_key_val_ass_arrey[6471c89a642681e57438a30226a0ebfbb420c393]=fgJRRyaXxYexYlfZIFZo
question_key_val_ass_arrey[76c19afebbe957f12a64b76f3350d0dc51150cee]=HzEpzZNYshJMoFnPiCwl
question_key_val_ass_arrey[9d9fbb8fb194d89850ef2478237c74bebb872c11]=UVEIZgWIIWnmWBfzCuuP
question_key_val_ass_arrey[293f4e5f443e63e30c1a38400ab30a9426140c95]=uloPGvwBROHJXauRhfdg
question_key_val_ass_arrey[12247c42b34caf53627224d21d8d7adb748f003f]=NgPmVnYYThMlqvubSFms
question_key_val_ass_arrey[5f6a47bd501c1f196f20b6b10a65c67a473a9ef4]=oQjuIDYAcDvFpGgxhzpx
question_key_val_ass_arrey[ce23501a4bc756dfda843f48b1ea927dfacee7fe]=WOTgHkNYSRvEbdzZJCGi
question_key_val_ass_arrey[37d77d94ee63ae7b12f439bfb6a84cc71797c2f3]=rrbWfXLdnEITTDRACZgU
question_key_val_ass_arrey[c5454467d0389d3933b24a13913d6f3243bc363f]=PGmrxhShiEiRnhwYWYfg
question_key_val_ass_arrey[29c79dca5a9bcb35c1e4dcfdd30817e2f6dc4e3c]=LhdLRWmYkatfleIPGyOS
question_key_val_ass_arrey[7522ba10d5b7ada526ebbe36b4716ba4407171e7]=ltovnBMWhiPXeCSUeSTF
question_key_val_ass_arrey[e47150559d5c8cc97f9dd8592d2eb6306de8bcf0]=wUkFNgsfqOZCfEcMzpCV
question_key_val_ass_arrey[da5bc9934bc3be3a0a43c37910b1be9fcb55f420]=kKHMtoDNlkhFAEfTKxrm
question_key_val_ass_arrey[70b280dda3deee1346b673f3bf637390cccbdffe]=vTmTkhPvBMElZMhPlgtW
question_key_val_ass_arrey[85d60906a4c169f6978376b395c9e1ccdf5f25b9]=qAijJYmrpmvNfiKmPqca
question_key_val_ass_arrey[b85a49b4812a78fb492df532315a42998c8a6a2a]=rvqIIWecmdshXXGyGyzZ
question_key_val_ass_arrey[88270647cdba6ec4d2eca2c013a758d08e4625cf]=vDZbMXzOuXNZeJbKxijq
question_key_val_ass_arrey[e135d0718ea3dca95fb1c31971419280fc156790]=BerTBKZkErbscVjyGSab
question_key_val_ass_arrey[03c1546339da80ad916ed7998ab0774e8f7b5103]=ZklvOuynIoWsygRzCHac
question_key_val_ass_arrey[15576c751ffc73708bad491e3f1184055b700a5d]=PxyfZyogPDTPlLldmbyR
question_key_val_ass_arrey[c134848143765afc32b0fd69594a2132a362449d]=AmgSpisiyRJKKVyVXhRG
question_key_val_ass_arrey[9083b1c99f74772e9e9e8e18453e1da80bb16a19]=mSixOCExKjlopkVwWqkV
question_key_val_ass_arrey[c5fdea9814f514b9577ee31bb42f4f6982acdd6f]=DOlplxTkPiqRWrnPqIXu
question_key_val_ass_arrey[ff8b249f696ea6692d8ee2f108c50f16bab54c8b]=KcUlViryKdoqHCCAixDJ
question_key_val_ass_arrey[7d4834070062ee64577f2e14e6886f55510e4497]=ncEmDnwOgXEKYbEextlt
question_key_val_ass_arrey[7e35795db493234c426ebcb478f3bbfeb936107f]=AfuACGDSeCluUXJtxOOO
question_key_val_ass_arrey[6a392310ddd1f5cfaac7ad819c7df423c9c0e8d6]=vVRsRhQistkNdBYGGqaQ
question_key_val_ass_arrey[182ca953d448057491fcd2f0cc4a6b5ad3f0f775]=CtlgQbXiEwoGNjBjWXtY
question_key_val_ass_arrey[67acdfe56d0299ee013480c631ac68b336bdddcb]=TFSiaAJrQPvnRIWoYPym
question_key_val_ass_arrey[bef682731cefe812d1bcbcf64ae560677d0553df]=ohnyaTjaYtuIGQVESweE
question_key_val_ass_arrey[e70ddfa4dd3dbdd4cecabf1a0ec231a5d5d38ff2]=jxuHzoMIlCrtaouhWfKF
question_key_val_ass_arrey[1df8c2226b73b986a1ddaddbfba60234e8d38731]=PMYoAjAnqKoPXsOjFgRR
question_key_val_ass_arrey[469e1a9393ad9c9ab2b83beb68dae62058c91204]=qzMZbBzxVCqLlegxyalO
question_key_val_ass_arrey[bbfcfdebe961bbf6234cb2c3adcdcad6b6bb2aa3]=JKuvWnQPQTDmdAQiKJkh
question_key_val_ass_arrey[8d3af7aa3d4a9904bf856214df14cd126ef65ddb]=yUGsZGDfOlkCRFUlBgjL
question_key_val_ass_arrey[930461c38923581d523e5c65dcab3f3fc749b4e4]=rNzGBamNcuGOmBupFsqQ
question_key_val_ass_arrey[07baab0d63ca10b06455d677b3c403ec11e491a3]=XStJucRxSnOLTwwAWAhg
question_key_val_ass_arrey[9e4a0d8690b66ca611a18144aa2989b45f4eec03]=VDEDcjSMhQdtnVPyQbNv
question_key_val_ass_arrey[de04c9989c238dd814ae6fee2cf6c36df0207882]=zhrSdtTBfOkaBXpPoRAd
question_key_val_ass_arrey[d12feea0ddd17b3e6633278fd48b9e864834f2e7]=fnKAoGjqgmBYvMmZWqqZ
question_key_val_ass_arrey[958163dc7db266c6249ed07abc854dedaa85186f]=adDyAVTxNLFxftspGAIM
question_key_val_ass_arrey[106fcae6f8cd90a9b978be22fbc0f15dfe141c08]=cuDJvcBrxNQJIXHsqqXK
question_key_val_ass_arrey[1bf8dc8597c162fbef32676953d3d99eb82b3624]=YuBCdYspbiwYtoDzeKtr
question_key_val_ass_arrey[bbe1ef7904b18383dde5c3784c620f9305fa9071]=FGzFwwWaHWBZkmFBgrWx
question_key_val_ass_arrey[bb03bf76b8b9bff007f20897286658a854cdfbd4]=WTYhNmkngAKztNbukRkp
question_key_val_ass_arrey[1a6702cfd0b317adcef051cf4debce6b2420bb57]=tlUgcscjnVVrOZckdjAQ
question_key_val_ass_arrey[06cdf7ab251af807c565810bcf76b19d9168a44c]=enhZIgjScatJOMPqGDep
question_key_val_ass_arrey[fb7db985f2504561b856783074884e9a166f8c4a]=nNJBiCjUDlgRAwpSHCgM
question_key_val_ass_arrey[c593301e40f6329a05fb27b3e283388368c6e40d]=AtCKyJdNQOuRuyBfHQtj
question_key_val_ass_arrey[f16ace95208cb17b8530f12952c3fcd8f11b0f7c]=svClkJyZPRhhFyuVzQFA
question_key_val_ass_arrey[f0abc31b86d796fce532ced24d96d19a2e635df1]=YrGEXwQwYhRIRdGXKvec
question_key_val_ass_arrey[bca33dbd10dbaf5ef79bb44f5f658e06bc25c601]=rrievPQhzYILhcRembrP
question_key_val_ass_arrey[ded83299cd05a22499610f00357623b74a1c9ff8]=kytCAbeHFOjSYooRMNYD
question_key_val_ass_arrey[bc996f8792d5dc97628185856b66a82cb1a52d7f]=WefkmBEvjDoXEhWhJNcj
question_key_val_ass_arrey[b6ec2ca5109ee9d5b265cb4746fb2e1053d5e085]=JpdcvbiiBcGvoTaMDqwc
question_key_val_ass_arrey[1b10eaa3625b844e7a830c28f7d6cd5db99e7d4e]=ORaBIhDSzWhUMVbaOCOr
question_key_val_ass_arrey[374cf776397e63eb53132d9dff2026f72bd30037]=tfoNJlVTPiBRyrpzfzJL
question_key_val_ass_arrey[0b4dd20f099386bf0506e79dcd1fa570703bdb87]=czTtPtwTBICOXRJeodFl
question_key_val_ass_arrey[9b6cb47da47b71457e29446f630526c0527dcf72]=ZqSwRJjDgGoYSrMQtTIS
question_key_val_ass_arrey[fe5a749dc1fdce199e70d60c82264d374e1e15c5]=MQNpAJUSSFdwUsRkEbeX
question_key_val_ass_arrey[d96ceee75e56106a0e7d4177193fb11214411968]=UvTDMlqyIXoLuAoNSAap
question_key_val_ass_arrey[621c705a2d790297c75e80572d1c7a1e778aa95a]=qWcziUtxFxYWpgStOCdo
question_key_val_ass_arrey[546058fe3fdff412adf39f6a7434f00a07b517aa]=JwoJfwsifDwODzZYcIpY
question_key_val_ass_arrey[4e479e2861ac399e571f38b8f40e8a88eaf684ef]=CtBFGkiXFJBjvdHJIYvw
question_key_val_ass_arrey[c49b949c02e243d0f63bfe1362ee00d23b8bad32]=CYKrHJMBBDUKYdEMLDqi
question_key_val_ass_arrey[50ce3e0f5e0be306d35959048a0d493b4417a9dc]=qtyqDRVJFKtKffOAAuif
question_key_val_ass_arrey[16450c8fc3b0fae8547acd317f030083a1489938]=MDUEbUYfdwmsPkugEnzX
question_key_val_ass_arrey[6d608ae0757bc34e1e4a3a10f01df0dd81c5c6bc]=IYSaFExmSxwXWVACvXZz
question_key_val_ass_arrey[c74a12deb0592c02016dd605e5f57b11dfc31e99]=qFIibiLABoKxMFjAxJDv
question_key_val_ass_arrey[89bdc9aeff9516a821a20ffa21373d1040572883]=kZWZglDSHiMYiKHknFzb
question_key_val_ass_arrey[d6c50dfa85d7034dc3658dcfd7ec1b3e5e5c79e4]=gmBSIvuNiAGcQeQxqJuc
question_key_val_ass_arrey[eac7248152f88c7223b6326a0640650d079342f4]=MeiqpTPwEhvkXZUfpzEy
question_key_val_ass_arrey[5a53eb2154eb06a73c83441a4005b8360bd3f6cc]=LksmswRDZZBhKKXmSMel
question_key_val_ass_arrey[2054b944e4eb7ffa1e720824e680a640e5182118]=JqUdZvhwjCTOJyCeFYSi
question_key_val_ass_arrey[16596a227f7cfd25315eff6631af00f73eac6a45]=fAabJCpbHLqLAapsptID
question_key_val_ass_arrey[8b587a0a0e44b1834ae32805c224475fa6808bdb]=WEAWcqQHDdftcllrikGE
question_key_val_ass_arrey[eb240614867c7febcc91ca43f1d09a770aad88fe]=HbNgxCsQLNvgYwjDYocy
question_key_val_ass_arrey[e6c6ab18426cc99414f9c49c9d7fa687cac0b300]=wykiXlLazXxSVWDJvRtR
question_key_val_ass_arrey[80719b80655ab179867f3caa1ce76079b47845b6]=CmJlqXVvczSiDTueBZEA
question_key_val_ass_arrey[2a71fb502beabeef75356bab68cebed1cd6c4e57]=kgtJFbMEvCzWPUDMvZnH
question_key_val_ass_arrey[6af6007fba7baef6c54e95a14f1c857b5cfa6ce9]=mbGiXVDHVdfoiFyDdBWb
question_key_val_ass_arrey[3621de7035a61746f22a32d8da0cc628db4f520d]=niemURqdzNuKCYbDPhDV
question_key_val_ass_arrey[d5641cb41dfc198d2f552c0b22f9a85e14a48b5a]=JLiAneiNzukWbDYUQunk
question_key_val_ass_arrey[60b72310cd54c2ba94f10a6d81d7359a2a082a12]=CiOJUahEQkVscVOxuDvi
question_key_val_ass_arrey[a2071b0293298ef1da31430cc061fef1b36a95ea]=NwlrJnBuaGnlPNNJxfNp
question_key_val_ass_arrey[14dfeaf36542244886266c7d811f3ca3a69904de]=tlldRZTFDcMaUzyPZZlA
question_key_val_ass_arrey[4759db76bb936b101cebf61052470cfda3a26361]=pkUCXVksjPoNALWPOlKI
question_key_val_ass_arrey[715118ce8503275252c05bf28d213077f84e4a2e]=AiZMkRhIKrYXMezEqFqa
question_key_val_ass_arrey[94bcc8665f09daf7642540521ccd85ce7874a554]=EpxTqOWKvogWzxIAafVt
question_key_val_ass_arrey[e0b6c35958c31fd50d643c9dd45dd171880db4e8]=uRgkDXsMnlMqqnMEjdaT
question_key_val_ass_arrey[8c26ae669c91f8bedb45ccdb9f44a8f6515bef23]=jKfRmdhTYLkSVxIHNrUN
question_key_val_ass_arrey[a750c2343423102ed5600044f49c595098627c02]=QzPHgoKKOwcBhrFPxBhF
question_key_val_ass_arrey[2d0bd8c73b6ca2e8cbf33a9bba2fac1ed3c1ccca]=BdWFijmZiyuTdHmMZbyy
question_key_val_ass_arrey[c6ed244d70f01194e704eeee024e24a5799da505]=wmYyqOkmkchZyKveEAuy
question_key_val_ass_arrey[3ca60407ef759a11586b0d5a2e77180cc8fba435]=BTEYDTRytnyLKgoifIGk
question_key_val_ass_arrey[919f1605d66ab4a34a7f4ddf08e31cbc6973c03d]=DKbjXxOFYruoHyWJsvVc
question_key_val_ass_arrey[d004da5fadc34242a3b4061edaea0e1ad02c7ff4]=bmUBJUSMhmymApXssKwJ
question_key_val_ass_arrey[806e47919d0bb114bf9b6b8780a72f6acfbea824]=BLGHExQdUmGZpeCrWMpJ
question_key_val_ass_arrey[659e2cfab98cc7f045a897c2df3c3b7cb2bbcd07]=xkWgWMEzzcmUAlGEPdnH
question_key_val_ass_arrey[f3f1430389b6ed084d76017b0da8355bc05e3c3a]=ISFZAwLzNdPDZRLTqTUl
question_key_val_ass_arrey[393581dcdd5d703364c7339ba20ad15800bab511]=thFRDhReEcUSRtTsSCha
question_key_val_ass_arrey[53555ebf2f9bab1dc43c4b0384a4cd5fdfc287bf]=ZYahOerSYNxFacqxGPYi
question_key_val_ass_arrey[8b39ab9ae481e89ca4ebf78438e2c0ac56faea9b]=TuRHYGCwaaivEEBPRgKn
question_key_val_ass_arrey[77fd9314fa9f5582eec8acd24dcc18cfb10ff2d5]=bxVSURyHquOYXXtkIOtL
question_key_val_ass_arrey[dc003ddff4c615f5d28b961d80dddaaab49e9c61]=bFYnkXOfOkpwIqlxUDOx
question_key_val_ass_arrey[c0f28efa2dc6082eeb9d231345793c5be1094e0a]=pZddhGtaPGspnJslTEiH
question_key_val_ass_arrey[40aacea6a7b99800574ba0c228e9cb8380b8496c]=SibuECKBwgtmBJkcyLWG
question_key_val_ass_arrey[0db54b6e33cbce6384c25b25e11baa6712816cfd]=YKdSLFOsmqwwGZhaDQCA
question_key_val_ass_arrey[2206a4fd95bbecf4b51f8432b4aa30a71c80be95]=peWytFBjSWAFJCBLEoRs
question_key_val_ass_arrey[0fe57e6cd6c3c1e1cdeda7a2fe2be15113642c5d]=tLJsUQWnGPuPXpolmQfa
question_key_val_ass_arrey[98e94f59bf1c436479b08a93d1570c373bf1c03d]=kAKxvJtIgZZBDZOmbKYi
question_key_val_ass_arrey[c785c597516fbc8c445e70a0a3fd2e54912aff4b]=ZBgxmflYuDibTghBIJvO
question_key_val_ass_arrey[20c58fde56b95c445191a77f8e2af924a5005067]=nzkbsdKZfxkpXWRHxGyW
question_key_val_ass_arrey[89357dbbf771d5e47a1f4bdef7074d6990a25c74]=XyAUPiaPqBYKNHzbJdCH
question_key_val_ass_arrey[6a8717fe2b06ae96f0efc21a49e0f9e1cb4a8f74]=amqdUimHLtvjuSdyOKby
question_key_val_ass_arrey[21259e534acd0339fe8a6a5640ad5d51f91f3e4e]=ncgGpEXCiFjdfOzzRaDx
question_key_val_ass_arrey[93259e2e196298bcb59fae0456dcb5c227b0ac1b]=mYbCTxcbrHHCExmzvSpO
question_key_val_ass_arrey[2c4693e11af994c6ff97cc0d0804bb29a1578889]=NvCRFwDHLMYqIPEHGKIO
question_key_val_ass_arrey[d01d90781048f6589818bc475ca15c59a8510e4f]=rYAbEPPdrJcpFkEyVtIA
question_key_val_ass_arrey[4eb10b6cb17ec38d7449d0c4eec1fd4780f305cd]=ToJkgkNkuSAfSAGIgCVF
question_key_val_ass_arrey[61647210121fdb1235c29fb62cdc2243db6db570]=AfnRacsYGYZIeuNMMBfu
question_key_val_ass_arrey[3db65bbd7402dbc4037e1e7b84670c3b8b7c9919]=sGMnszdMPlHCHvufKPcj
question_key_val_ass_arrey[4e08870f64b17a1c78f55a5cc8940c01b7481758]=eInSkUHngtazQrTGTpzt
question_key_val_ass_arrey[8e2e9bf7b7fd4625509284d30b3271d1fe0049ba]=oMUhbJNBeNcFnXVBoEXP
question_key_val_ass_arrey[be938a4a075be7d77f1acec6acc39119860809b9]=BJMavgNRERrtJeZKTODv
question_key_val_ass_arrey[3530efe450170b7fcd9c6f0e5e96265dc72ec712]=KuCBrjJKaxkZyPvEeCVe
question_key_val_ass_arrey[a6ac2cab8631c51e187ba8ef65d8d5bcc036a7b9]=izUBKpUJRoOYcSkXjqRl
question_key_val_ass_arrey[b3edc466fbc191fead073515d1095b5cab77ae3b]=SaOuYhqcsaiSZfRSuRTt
question_key_val_ass_arrey[617593e6d9655827639d79b84003e5b40b02ca6a]=kJKDNnCjjTRiivHKPyyZ
question_key_val_ass_arrey[39fb41cdea658353eb6a1b477aafe4dc4f83fe70]=VnlECMkKPfUtfIDwKfkJ
question_key_val_ass_arrey[cdfd302bfd273975fd660618e9bec3aabd9b2053]=hIepJLSdbSnyeeWcCaAy
question_key_val_ass_arrey[d069721e01c7e8c73d5fe5dd7443db3353474698]=EClwawznJNjIxegMiCpa
question_key_val_ass_arrey[4755179b42b296cfbb1f68e3a236d4e13e1133b1]=YeBVBtzrgZwZwmjNqXAk
question_key_val_ass_arrey[0944035cf3e548e5ab6bd7650f4a2058ad6714da]=MUQccWriOHmPTWmLLIpU
question_key_val_ass_arrey[2b16505b6b6656f6d4e2740651eeed4537f7cda9]=oQTQKnVJiTAXgOTTNTGK
question_key_val_ass_arrey[e608a7e2d49178a6363283b3e4a15f9fc59ccae5]=gSezRyLngNrrYjOzHYlL
question_key_val_ass_arrey[9352e289832cb4b71dddf7a2d5f8ee5b3b15680d]=mRAeUwzNhjkVwuXTDJlQ
question_key_val_ass_arrey[fb8336a83d5f911dc30f86c38c67995f612dc997]=nnpqjsakgyXucEZfEMRP
question_key_val_ass_arrey[83860a0aa0248795fe71cde29648328c3a434024]=BsHeNxDnyJjPIinXCDeb
question_key_val_ass_arrey[0065f2f96b5eb2424f39347841858fd7adf035eb]=UbFgTnnKVahnQuNAsBUr
question_key_val_ass_arrey[430cbb066085f2fd5a1d9989814facf7e5722f78]=BUoUDvEciZvBRuFqVHoo
question_key_val_ass_arrey[47b916bd3290ff1eec64e4d89a2a2bde66b8ad8f]=JzPLkgYbTKSUvGDLMkVF
question_key_val_ass_arrey[045aef6af3fda1f1e8b21dbc3b903b0ecf03867e]=ikZwllewIAaTGDLTFZve
question_key_val_ass_arrey[7168e2d9fa8d0f5106f6989343171543a4c662f5]=jQbCxDbYTyJaLsDSahHK
question_key_val_ass_arrey[c267e5dd9903a6ebbef019ff31bb3b3c82aee453]=BJwyEOZcomGzGlPehQUy
question_key_val_ass_arrey[7c29b0e558c06904b0064181fadfed21e301c3bd]=IriowQiRzPVBWUZctPvR
question_key_val_ass_arrey[ec929e47fdb2b21588e56b0f64160ee8dd7683d5]=GcZWNjDseWDCTlkDEHNk
question_key_val_ass_arrey[7947e2973e61b88fdc00845a2f6494385eedc952]=vNIrCIxEtetmqVqBNnfD
question_key_val_ass_arrey[9e20136f1c331c8f8300d26a4ab5da1c4ca9ac88]=wbBtAsDRHlsYitjjwxgW
question_key_val_ass_arrey[1cf97da0ac1f1c5b92dd887a609b2dff79af1a22]=QPlRmmMYcFQdbIZNZmYv
question_key_val_ass_arrey[caba7d05111df8b9c8f78fe39ec0e4d8b810f3bb]=QAoNWIyAAvvIXoTDKwvL
question_key_val_ass_arrey[4a0e6fdcc220a680792b1f3151069338ce62048e]=IxzTpDAlAhTJftPBhbUD
question_key_val_ass_arrey[49b3a6e52027bc9e69b408bf57b04b1cfec15787]=hGybCaIwTfqsCWYlcLeS
question_key_val_ass_arrey[74f2c8d95a3ace6603659614fb34f8deb84a23ee]=ApJVTOwLaviNnfdoEFBj
question_key_val_ass_arrey[4f39f816edebcdd232fb54f12f069ff0ca28d48d]=VytxTugUWJLlBbgUZJpW
question_key_val_ass_arrey[e7122ca87df933b53c0fa069467d5125bb513606]=xCcBMZIvCiecJWBsmwvT
question_key_val_ass_arrey[a2824b2fc45b827a47956ea3d7f4baac5b3ddc59]=OQgayHohURntkXSQPCoS
question_key_val_ass_arrey[e409b2c9b2506d391caaafd98db86708a59f024a]=UkdCgwmshMlLWnfBECaP
question_key_val_ass_arrey[cbebb51a04b715fa7d4bfec654189df341e42c3d]=zKGrPOaBHyjHDqTULwAg
question_key_val_ass_arrey[e7f3e0a7609e33b7a0a0fe88b846318ba06209d5]=OcysJRTkiXAUbImvtmQM
question_key_val_ass_arrey[de39a73187910f24a4a0fe3964ad6b51a2af9e40]=zfJhTUcZYTHMjAyxHrme
question_key_val_ass_arrey[44b351522f0d1fcd870621fdcf115a30795c2c7c]=uKtBQHnsDMBbMMKCSoNq
question_key_val_ass_arrey[db24d131e4cb05fe86c1395edfe8ddcc0bbeb2cf]=MszahKwfsysfdoLMFupv
question_key_val_ass_arrey[30546c2df50f69ac7a1e8743a845c4da4b3346c1]=KuujowBCMAYBnKjumNcZ
question_key_val_ass_arrey[f06ede9c60c0e50b323388550dc4c5b68c832e03]=uEUDOKPoCBKeXaaWdIRo
question_key_val_ass_arrey[0bd08ab9b96f200c1907f90ae7f4138ee6e3b6b6]=qbOGbiGeXATcYylgXKQs
question_key_val_ass_arrey[bddde8c88db84c20e31d608188945afdd8e3b639]=WJtffslfoXoxhTagkWjV
question_key_val_ass_arrey[0da70db6195cc2669c4f657adfc297fe10ab6630]=iLBplVNRslGXKGYETIbo
question_key_val_ass_arrey[31213f79421307f8e2dddf4ea145e924642e10ff]=KbfmXnPoGgdqxXycBzqA
question_key_val_ass_arrey[5cc2c9ee2a35db74a527acdc7f68f047bbfaa4d3]=BSelpDglPuLvcRNYqrfd
question_key_val_ass_arrey[2ec02754c178744fe128ef61e5b968f3bec8b900]=wHvAkTyMtDTlJgDJTaWg
question_key_val_ass_arrey[f284231a25d05c87e3b2e3b1ed4cb5d3b69884d8]=BkVpIZaYEJbZLuspXKAP
question_key_val_ass_arrey[6bcddfe249a17da0c11672af9cf03aeeee816c71]=ZgpbogytuinuGIscAufO
question_key_val_ass_arrey[c99aad9bbcadd48e8eb1c7ad0da731785cd40831]=oveJJssIcHaHXgsyneeS
question_key_val_ass_arrey[79a826ad791277e1306c0b2efedf966e6ee40461]=vJzWgynnkIJBpTyONVuo
question_key_val_ass_arrey[5c5c3f96bdf31b6d97311ffb354beb4f58c560c2]=oVzRyRrDaRubIBIbuOKe
question_key_val_ass_arrey[c0994da2e2852997a59a5126dc16769008d2a2bf]=nRcKLkxQXBpGbPZGJLCQ
question_key_val_ass_arrey[78a77df054ae16ebb41b720382c449280b8b6d4e]=YmUHgrwFzrCzcrVGYTzh
question_key_val_ass_arrey[7e9237d43a4af82427d8e9ffeda6160381a2f742]=kyLpTWIcQekUPIUWIpxg
question_key_val_ass_arrey[40c7be7cfc443a0b2c895990f9af08c8ee2ed5ed]=eaFvKmXzMZLKlexNqwzX
question_key_val_ass_arrey[0649672cea1fc94bd26b0a304b9d5e33f4e44b27]=cEvcURkSatUelPNfnEOs
question_key_val_ass_arrey[d907724907607a00b237908ec34f49061201db18]=ZlVeOWJIzEwLwnmFEHno
question_key_val_ass_arrey[c908501f8f5de2cbc204dfa6d2aad1e3cec116e7]=yMEHeOpKFLCwWSRkErSh
question_key_val_ass_arrey[4089dc15676bdb102d89bb0111540be5d5d7d1ca]=KBmuKAlUlpSTikrrupJW
question_key_val_ass_arrey[0711d13e97811e7efab1b232753ab13f5395c2e6]=WTIKMogQZcEmNjzviaBt
question_key_val_ass_arrey[edf178e7ec87392e9e46f331e3d866c096b78309]=PRtOJvzoVrnBMxhFzYoB
question_key_val_ass_arrey[be22c82ef55c1430c414c1933acee360594ca453]=QzZlCraviWamDLSDSBSP
question_key_val_ass_arrey[9f8104543735f7716968a007dc6039a94b1bcd2b]=GdiwTYUlCSjjvksZXRZN
question_key_val_ass_arrey[db3901f3150c43fab6e3ce61f2e74f29eff55942]=pECdpokJEhRVilIjKdEc
question_key_val_ass_arrey[8f3b79b4573c10f88ff5725b3f0dffb30e520586]=NotyKbYMgsjGFrAtrZJB
question_key_val_ass_arrey[b24568c5bc3e40e9263f9cc2dc5ee371dd4288ea]=AJtdEkYkMAmWECJwieNk
question_key_val_ass_arrey[347805b12c624467f8039f5a9e757585133ce4df]=JbQmHBhyYscwWzxqnkWP
question_key_val_ass_arrey[296a622581469e65ebcfd59179b52f3e578b0641]=MIbrqSgsQQiPTlxuxruZ
question_key_val_ass_arrey[7d52ca3c300a18cc8579a78193b1d191d3ff6dd3]=YayqABJcqqEcCeXFkrax
question_key_val_ass_arrey[87f28e10a60337cfb549bc6b066ffcf73777da3a]=pHOXTFYdmQIKzeTQrulk
question_key_val_ass_arrey[206ca19dfe2dcad14ac751f62a2adad1b83f088c]=eurcPzmCgaMlQoxZPdpl
question_key_val_ass_arrey[7294706bc9122f6a01727a8d013f519f9a9ebec0]=IkXUwsUbKbDakfVneLQc
question_key_val_ass_arrey[5d006d4f82b7c0f590eee6d9975758d02165d340]=MPaJpGbDFTbEPdWRdAUS
question_key_val_ass_arrey[f923236290a5b1f851e396252e9e197737651c29]=JAxBSntwbpMdWolFaeli
question_key_val_ass_arrey[fe0bed67981fb8d7584123b18c793fe75a431fc0]=usjFlSSLWIaOrYBmZXae
question_key_val_ass_arrey[b08688274102a37fc77cd22fea45366f30a01637]=VZljFEhoAXJtJDvsttER
question_key_val_ass_arrey[4c8a460d08dddeb2c1e48ccf97b86d5231ba5a92]=HxgeufrUoaVokEjdFlks
question_key_val_ass_arrey[51b1164b3fb3b73bed110c10fd047c94b3e453a4]=ZhOmKUfdNhFrbckDSaRy
question_key_val_ass_arrey[6286aae7a2d72758da0c670820b74a476fbba646]=RvWEFABaUEgHZehdZkmk
question_key_val_ass_arrey[a490b23d93d746f73431431c46ef7c89117bd2d8]=YdyxfxmgbRHSLDyUvZyS
question_key_val_ass_arrey[945bd86b75419564f32f9c243293bb5e9d35d139]=wRjNyYGnjvUSQNtFagSv
question_key_val_ass_arrey[a8d97aeaf4397f3c1ea3dd3f2f60967c64a5c839]=QXXvyWqJIKUsBxelUcRb
question_key_val_ass_arrey[7e50e2939748a2124a0066c6aecb8c22842147f1]=ogsakbwiKWlqYvovhGYv
question_key_val_ass_arrey[2a746a181fbffdc75043f60394b7de8171a57e10]=cuKoFDwHpNbBESzclvUA
question_key_val_ass_arrey[23348411054890f3df820767ef242539a4e4982f]=iGvDUWLRufrERZtHOMMD
question_key_val_ass_arrey[43e057ec0244cc9c1698f40cfb6add9dbe10e423]=qOAvOEvAiyKGgJUtwZjr
question_key_val_ass_arrey[ad1890c59db6a42783f3943e82ef684e5094bfeb]=FyhDvGacsNnGJREyVqlq
question_key_val_ass_arrey[2986c48c070a285e04372c5cd421de97182ec9eb]=hJQpASPhEJwkjuWMEJFf
question_key_val_ass_arrey[28f15e595592975b082126361757e4f10d1a0482]=aOPkzRIbfvFmXUwVutbp
question_key_val_ass_arrey[186f29af98a1ca2f5c537b57b10beaeed288f389]=wROvNViMulPvYVYibZjd
question_key_val_ass_arrey[510c6aadd2bb9dd15c32194c68927f74c7c17c04]=jQwefHztgVLNAWZTVHgP
question_key_val_ass_arrey[08c6c687802ce21f6dc18d9bdae5c3cee5338682]=wFohpjWAJFwXMMcYHPbS
question_key_val_ass_arrey[4954e84c3254bd2e433103de2734f38bff8ed5c8]=twfapBZgQCuorklogkWb
question_key_val_ass_arrey[6671db00e036c9ea55b3026f73cea27a3e86c136]=vubnNgJltnXBPfaKzfkw
question_key_val_ass_arrey[b985780722f66d38f5e25418931e2bc81fc38460]=TbJuJxiKSvaqBmtNtJtl
question_key_val_ass_arrey[ed3804aa7e4187db23b175e4ae6584ed342688ef]=KvILQBzGmqPsOijVQlJq
question_key_val_ass_arrey[4a0832bb74222605e05c0ef6aa93429de8fb3065]=fzMXgBvXDRTVTCWhsGJI
question_key_val_ass_arrey[b0674da06f7506fa7bf3c5d1b61cf252909f7d23]=tfwxifNyKrqOXOPjQrGD
question_key_val_ass_arrey[7361a94b796c2b536ea0c4597bc9c87b7b9ce4b8]=twPMQtBOxjFRpjhGwfUF
question_key_val_ass_arrey[3b2a6bc1531a5f49095cdf7fb532284a3f57ee4f]=ZDaDkthNRmPuRhoRaKwS
question_key_val_ass_arrey[94321a31629ddba89ff882d969b01f4e595db2e7]=kbUewRnYIxOJwRlFFAiw
question_key_val_ass_arrey[9ccd97945c1abe0b53f4e45dd59972fef50dea26]=GGomRLTgUrBsDhwtcRSR
question_key_val_ass_arrey[90ef1f818ab4c69192d2a54bcb4ea30ca8e8e867]=PhHCrlflzpEdRyOoQDqX
question_key_val_ass_arrey[628a22b287aa1f59962e60b3a3062830a13d1c2a]=ggjNnjidpOVLLnEVdnbi
question_key_val_ass_arrey[aca5594a16fc495c172192847cf50086f9f89baf]=SRcgoLRnhTsZpThItwwp
question_key_val_ass_arrey[ae7306832bf60867dedc8a14954b6bb243e7b040]=ZbltSwJXAKJdomJdgdFx
question_key_val_ass_arrey[ad7ff2b7d58ad1e0fb088e9c2ca3524d5fbfebda]=ISVXYwkvpJFjJyWFrdjZ
question_key_val_ass_arrey[e3c8e39ba3b63d30d784a23dc74f12ff52ec07f9]=MgSSxRmXGondBvsuHuPx
question_key_val_ass_arrey[586bd809f8d4c0483d01ce71e295c59d1946e9bc]=iSaYlgTboDQkCjPCssYL
question_key_val_ass_arrey[61cfe9a0af872a26328b1cf1c3601b91144e0f5a]=fXNDRiSQBJblLRoTVADb
question_key_val_ass_arrey[a62993b8950b1eaaae50372a0a180d4e81cce0d4]=VoaIrJBIuQGYLzQtlCsG
question_key_val_ass_arrey[630f695a8b5b394d95cbf74e6200fce52d04f70e]=XicwLAOplvggrzjdQQix
question_key_val_ass_arrey[73794148cf916b7c40da8301e382917137111d3c]=vZakxBIlecJbVehMxveo
question_key_val_ass_arrey[3be67588e506454d983cd0a85eda4b877d0f46fa]=jILVqSYoRQNBFrsqzIxE
question_key_val_ass_arrey[4aa14fb7c6455b04e6d4e1a7e2f774f80e9e1078]=hrjCwUjTAIhsssHRCOaF
question_key_val_ass_arrey[0e697332c047e8be60bf1aecd762879d4ac27ff9]=kMfYgVNzjkirSpPiquVT
question_key_val_ass_arrey[6d73d9b1da3208c457f9c8134cdcb11c5a80e3ff]=jGflRBxOndKuAdWdWpAd
question_key_val_ass_arrey[3eb949ac20313c43addf338ad41e02b46b6b58e8]=FpmSfjnaflsCRxshbLlY
question_key_val_ass_arrey[37c4e1918fa83b32eea249c8283dd38cde9cb949]=XFjaWYGdPnwdSduCIELz
question_key_val_ass_arrey[c58c7c959b4be702a2aa6ed737a5b442d957c559]=oZCbVfCUtDrTqzllvvrb
question_key_val_ass_arrey[b2e7ddd14a17765b1f758393cea06b6b11ef89d4]=MaXaRirgQeBJcnpJlTFd
question_key_val_ass_arrey[1ced4df0d1e63907b821654aba6c15113b42405d]=IqoJkUfJLtYUkmWjUXjN
question_key_val_ass_arrey[0785d38a0b528307a6484c690f54f54fb4a61a91]=ROaZVtEdtazhDGzYSDje
question_key_val_ass_arrey[268704b3766eee0491773a7e1bbde2157373dbb4]=JzxomtfYIcvnFbJMvpXu
question_key_val_ass_arrey[1326ce7fc5380d22922be400208c7b6dc3618055]=ybFzFbSJfjfMisaSzmdL
question_key_val_ass_arrey[d468b6b324eebe4c29d3f743095d5dbeabad88ca]=RNNSOVfIesLaBNFOszkn
question_key_val_ass_arrey[59fb6d7e1578c84cbe8b41e00942b2525369f902]=iXskPKmAtOSqMRhKGURc
question_key_val_ass_arrey[2f3979a447e4a64c4ac612e9f1dabbf8120bd364]=BPPANQMPmIosulDxsZOz
question_key_val_ass_arrey[a4e368b976f32d23a3f844e6088c0a7818205532]=wZzKCfyPLABmfmvRLHqm
question_key_val_ass_arrey[64fbe527742530f602908e84170b6470c8fd7d8a]=TbXUDFnGbJbjCgVzKljH
question_key_val_ass_arrey[54007aa3ec70c893d13f8ca3b85e7a9d05cc18d4]=tniveAfCAZavYrkNMmXX
question_key_val_ass_arrey[a4769a537cc69c534dd8672414575688a4c6358b]=BjQTUOvZEVBCdJylawTP
question_key_val_ass_arrey[f694aeac4a8d0c9bfcdf468f9a20911c2e9eec11]=FfOfQhoDZEpZoDietrJg
question_key_val_ass_arrey[abbc5969e1e269429cb6ddc8af7bf660e6f61e36]=qsJTzbUnDcLxDLuJBJiR
question_key_val_ass_arrey[f96f7db95473cf9d6a9c23ed27a6f4f17ab1c348]=gjNHsxRrSWtnOHipsSxN
question_key_val_ass_arrey[8a47800d8792589b1a0c99f0f7e94ab862966d88]=ZjUcwZMibjYQnAiORTpg
question_key_val_ass_arrey[abb5917ca39df6572e7c0d8f0e7b49e0ad262236]=BIIyigepfozGQsPYSvjD
question_key_val_ass_arrey[7c8534c3a01e1f506b5180390dd3bc246ab8e10a]=PmBmLxOMDmBbHlBLdZeZ
question_key_val_ass_arrey[3464741f32b933b8a9cf1d43cadd546e41e89286]=RzgAQwHrrQnryPdEheDF
question_key_val_ass_arrey[f73daedc44cd85ff387cf5372ad65c47a6d64918]=WIuMmQlIJlvTBoIbzuoT
question_key_val_ass_arrey[49faa65fbe32257428586a64e84b2b23f0e0cfda]=IrHiwAlGOaQSALUMwRyZ
question_key_val_ass_arrey[6b1b72eef45ddfe0c23911e2fed43966b16770a6]=DnMPfcItazdLEaGqIgES
question_key_val_ass_arrey[60a9be5520901ee1c91c5bd64589a9a1f89836c4]=GGHjPsvTgsAFbRnkHaMi
question_key_val_ass_arrey[1454b99c1cfc39cb5978bb97bf937a943a590075]=kQWIWlTQmZDdqGZPKmLN
question_key_val_ass_arrey[7acf6ea1e2edd945bf49de56aa7f23d03c91843e]=qltoGfdbgRqjHUtPmLSI
question_key_val_ass_arrey[83dee5f2e492c997028dde5b63f39bf31c4140e7]=cjtIdURCWcGEtRmMjrua
question_key_val_ass_arrey[52e86df61525ffd3c9bf1928c5155cf726148e22]=VriujzfLlNCFhCAQKFFA
question_key_val_ass_arrey[089501d3385c19412ec5a4b2c0845326cde49080]=VeSfpYpZErJDlfwqZlSd
question_key_val_ass_arrey[95e9365e0f41c42bc13ea14c7b180fc4659baa98]=IVriCRIKQtijJlhUkWUh
question_key_val_ass_arrey[eef5b89cb055337f625cfbae8aa4e701f7bc487c]=lSsQAdiThcAemkCOfJlO
question_key_val_ass_arrey[b17e5cd5e9f9bda00d314cfcac1259992700ed07]=ivGwFiMwcVsGKIDEMfpt
question_key_val_ass_arrey[a4b35c761cd44681c8e875dae3a6c9acd24444a3]=ggjNnsobCBejSDXDuLYI
question_key_val_ass_arrey[76c39a273e69a434241432b37f2fb0b750a5d314]=EOchXXUPfPAoeujjbtOC
question_key_val_ass_arrey[baed8afada65cd5e49ebce98f0e0c2490f975bf8]=AfWwtcKVCNbHqPGsfZkS
question_key_val_ass_arrey[f247cf15b6c6af0f44eaa0fe735f23be70cfa1ec]=xXThfZJGiGbCAGtKWRdC
question_key_val_ass_arrey[7ae053160dcfa9fb2e2aff3582f40212e07e0481]=gjWwGnzpBcwISVbtmzbp
question_key_val_ass_arrey[1edcf8a64ff1a00a10f9369d92920835080c4032]=rAMnUvNaGJoxZQOspZmX
question_key_val_ass_arrey[fbd0201027af9823d67575ebdd061a2b1f4ba309]=TexYhoypxMAHnKSsGeAx
question_key_val_ass_arrey[cf59530bf6bf1958f671def3138c85a2511d4427]=hXAJXnOBvqxMLpGEJpoF
question_key_val_ass_arrey[11a2f60dafe0d14f2bf8fd46f13ba0e4a989aa24]=IZCuKtMWQEQjTPTwlHww
question_key_val_ass_arrey[54201fb8e7611e4ed976c24d8939d4e73d6e728d]=gDgykEErZSaetwPJSCoF
question_key_val_ass_arrey[97343d6d735bdf9d398c75756d0c11991341c962]=wDONarGtwVTBIDuLxfqZ
question_key_val_ass_arrey[f636e943431f9e73eade03f974b3efa4df879ab3]=YKeOdCVeQBqBdLPynEEx
question_key_val_ass_arrey[c475db25a2e5c90f0fa2dd649ba13302aca7267b]=iYdMatjOZdAQitduZpnz
question_key_val_ass_arrey[e6a8452dc968c7343675b1e8e56237e139020916]=bsglsbmNilaMSFSMlYZS
question_key_val_ass_arrey[c9b31c33c9d406f5e73b97592cdd6694737c370a]=zvqJdrYPHFtHtHvfoLBr
question_key_val_ass_arrey[64ca6fd102b0c29f3187d7b68c6658bb7bf02ee4]=BHJenvkHGllFdJORDiqO
question_key_val_ass_arrey[9154e668ac96276175205a90012e3c38ee0741b8]=FBPcOVnbUSyWAVzZcggx
question_key_val_ass_arrey[3db12f13aa5fb3c4174549df39e669c6495274db]=QLNdxMCeleQGlcZiCBrP
question_key_val_ass_arrey[138e4a1b1cc177bd811daebc57f43aa759b6a931]=UguqdDzhTBYRlenLbLxl
question_key_val_ass_arrey[c9bfd7b3c3dc3a1b4f49d2e570807ecd8fb27aea]=WCPXUvxlzDtTOsRGogWW
question_key_val_ass_arrey[6dafcf90f5f7d2dd6b1e5d0928b6b1b35af962fe]=WresKHCAYySihoCqaHBN
question_key_val_ass_arrey[1f44385276bc8ca49f49848481c71cb291a1a919]=TJWnCXtyEnwRUkkywelQ
question_key_val_ass_arrey[854671e9e37ad6a14bfea49b370f26b33ff06204]=OVlhZxjsuOUNvWJdFHFB
question_key_val_ass_arrey[f6fdb4a5136ff20f38d55054eeb936c9997227c2]=BdlYYpPymKUYhtvtiqvZ
question_key_val_ass_arrey[a115ca38420356301d8de542787b911d86cfb7ff]=NCgjUsDjQlFOtSaHaiDz
question_key_val_ass_arrey[0adde6c5d896147db3f3774188c0a4452c458558]=agHViuwsgKmttTqikWeo
question_key_val_ass_arrey[7f2b097082b1bdf2fbebf6d3b6c036a02aac7fe9]=tnYqIyViLMomJdQXyduI
question_key_val_ass_arrey[1eb2d9c62e685b02508fedbd666746d43c21cb6f]=bYcquHFWIotUmFPfutUA
question_key_val_ass_arrey[38cee38e8d4bbad62d929cbd4130b13637543ab3]=TJShBsLXiELlfcjoauTw
question_key_val_ass_arrey[b742e683833905b56e034fd6e0a33e636707a84a]=SaBERfmVmZnrOpOvOrcc
question_key_val_ass_arrey[30641a742ca766cd974635dfc550a8e552ee733c]=jbqmESYaAyhLnnszbLhp
question_key_val_ass_arrey[83b6e5bf34411221cd199d44a8522cc942eb1f72]=MFhtlksoctesaCQDxOvP
question_key_val_ass_arrey[a032848c8590c58d8d060f56082b9f9d3f94c65d]=OFWBvIMeajLSKIPVZRXe
question_key_val_ass_arrey[29500b712bec9ece5576d38ac23b42deacbba317]=BYcjzBRyKGNlbJpRMdQz
question_key_val_ass_arrey[1284bd11a34aab4aee44dd9ebbd549388a1a7eb9]=ITiMznVVJTPyTEMyNhRj
question_key_val_ass_arrey[02dca54e20501fea82118e2f6992f91a34c155d3]=osGRtDXnnhuTaSfLpoxv
question_key_val_ass_arrey[f33ce623f54acf987994bb8cb355c0858e08de77]=fEqmqzszlsEWfdPvarAm
question_key_val_ass_arrey[6cb9732c326f8f9684b004ad7aa031074c34e591]=UiQIbYzgjsoPgxtcgoUT
question_key_val_ass_arrey[d4eb22227d76f4faa94681f6534fd4f2e0521541]=xxVjpBOxSwnwaYXskPIM
question_key_val_ass_arrey[5a1f6c9a78542fb03939e03f31d21a27ad887526]=NjMzuaoFQxbpJTAVdGSK
question_key_val_ass_arrey[4947c902591e200d63b2037b0c701d88abd1fdce]=lEgoxHcPaabVPYPGwEKJ
question_key_val_ass_arrey[626ba479ec72925627047bb9200a91b5a90a1472]=ajqAsEkghNjCOnwaafWx
question_key_val_ass_arrey[3ee7ed26a7b8f1e6bc2d0bdf642b3ba82a0a117f]=EopbmLWdWLvQZETLMlOB
question_key_val_ass_arrey[7168fd0f215681d0244f40ce318551c248e81131]=pLWVivLkWuncJfWsWSkP
question_key_val_ass_arrey[8d42bea46d18173d76cf0d4e9cf45a5c7f6a76e6]=OAwSuMIFANokCRIWuOwL
question_key_val_ass_arrey[f4b9ed580163cea7671f6375490d2763f9bc7da5]=YzNciQNFLWAkuxUjoSXa
question_key_val_ass_arrey[af73905b4d7ec259ebb1ce86949e14fbbd051d3c]=OTnWkpwAPypbtPnyXJdM
question_key_val_ass_arrey[44330a67d4de7f9873886a623db425722c3c246b]=bxGfPzckFNWHkGaBtvPb
question_key_val_ass_arrey[4729ba18033e071374e8ad74b9f5374ab7bdf7ec]=bmmpfyecPevjjVywpkzY
question_key_val_ass_arrey[98c6fa8af6a11f20c81f104eeacb8d34db580405]=eFjPTPcXMsesGkDqgKsi
question_key_val_ass_arrey[5ae51b6094c13cc7e43fc18c905672dcb83c88fb]=KCAmFQNcxSiqbYcswIhX
question_key_val_ass_arrey[87147610a6839c6f4c6371cefab77933748a089d]=uTTUcPDBRXVONnqgJRtF
question_key_val_ass_arrey[860635471de32bb0e6b95c163b2321e21d02e619]=clCHTIgUnMDQdhuZvEui
question_key_val_ass_arrey[dfa86acc37911dea32981deabb7c306bc880f827]=dqFDUDvpjgybifjMCiPZ
question_key_val_ass_arrey[163abea2e61e6652f7d14fd08a427b4bc7b293fd]=AWYRPpbLLkFGVfjtDSgx
question_key_val_ass_arrey[4cf292647557fc73dc60a3a6c6ee71347e2b53bd]=WotCHfSJVhwYWntGJmAv
question_key_val_ass_arrey[9e0bd16a9d45c4056464b1e4d7bcf76a892d1dd8]=XmlTkjtiavdAotUwCObO
question_key_val_ass_arrey[fb4d0477aeec01ca523db80717ee781fbd059c3a]=jzqbPfDUnLIGLMeUudyE
question_key_val_ass_arrey[8d1846f330f31ed2f6f37ad90e54133a0ea63c44]=XDODrpdPODGFVCEiaLGj
question_key_val_ass_arrey[e2c3fc0d30f8590f71422e7ce1d8936c48ae7aac]=FozfQXuoxaxjZUusrckg
question_key_val_ass_arrey[9a7f0ff86bf5647c89b21891e4dca98edcadfc9b]=NpqjfsiSwaFXqLAhkORt
question_key_val_ass_arrey[e498caa8df3e734da37aca88f89be0ae934fd8b4]=BMxHELhxqQGJBvtgCQyH
question_key_val_ass_arrey[981d8574dfa56993edcda8280e11d358898d18b7]=KuxpEwkKyzSmsznuzrUY
question_key_val_ass_arrey[867b36b539e3a2f5cf18ca8c1971a3585538b143]=DrTAspioIktALCTDSzzG
question_key_val_ass_arrey[1716ff4561ae7879849a28d3dc930197855e4db5]=BSGwflXJfVbKzLRirHOB
question_key_val_ass_arrey[d5f6fd998f111cc331ece9a808e035935ed19e41]=zNrtwwcQsjrkuFPBETUE
question_key_val_ass_arrey[6443f4aa0f57c439169b00c17b87af9ece7d1d32]=MKdkAhkpRVtoUQiQQOjl
question_key_val_ass_arrey[53573268fd6cbeb16e63f1c13ecbf1c1939a8174]=tAyzKGBhOpQanwFoYxBo
question_key_val_ass_arrey[ef662895621b840997a58dc4e38681c93e7a87aa]=EKWZnNOwqHmxZvfaDEsu
question_key_val_ass_arrey[61d01f667eb28341713d5b151fbd474b58c99bdc]=dOvlnGNDziUjMsqcSEJg
question_key_val_ass_arrey[9a0fd3cc86b9b46bf6029b049d4ae33a897c4731]=xnpUetBFcvNoGoQdhmbE
question_key_val_ass_arrey[d951da75e2944810e6b3ac5b5404555e0b12c91a]=QstlgKecHCLIYXeAJJLZ
question_key_val_ass_arrey[2005f0f7578c3b48c59f096e2dc48d8626f58cef]=scgVYmVZingtFXMBAGxX
question_key_val_ass_arrey[e6d6b6e7b4d626ed192f403c66d5779962a4943a]=dJETrWnrskpzMWeRxnYq
question_key_val_ass_arrey[0c288cc89c0d01c17f6b1c2ddd63bd3bcd2cc8fe]=SnkqAYRuBeAKfiykeiTC
question_key_val_ass_arrey[1b70d4ca1e0eb8b9aa1450d056d10324924b0ba7]=klyyYXTMquaZLweJXkuz
question_key_val_ass_arrey[77a3b7836fcb53dc516b3c176717288d9a6514e6]=fBYodyWqqudIxSPNvbZL
question_key_val_ass_arrey[347c6166c0e183244da36615fea53289f401ee81]=lJiuDyzEsQhHkStHuwUo
question_key_val_ass_arrey[ff08aa01f48f964d1bd545995bd4dc61ebb4a8be]=WCJbKmBTMxvvyDNOjeFT
question_key_val_ass_arrey[9f7ee63216f2ad105f8f9ce76064aed0258b1846]=GoLVfVbWQSUpKHtKwqPt
question_key_val_ass_arrey[0cb3e632aae2b87c91c2154b02e085e2eb769032]=crfVCeyJWuOaJYRbaOUg
question_key_val_ass_arrey[826a066d37b088d3828885f771e6cccb070cd2b6]=tWrNAHnPZBDVOHGTZgnc
question_key_val_ass_arrey[5dbd201173b5196bcda0b81db2c1ceef773602b6]=sAaICXMQjIQyipdcXhlQ
question_key_val_ass_arrey[b0661927ea15787bd99c961cb8432279a5334c8f]=jOWemKLqAMRmRyAUMFto
question_key_val_ass_arrey[562e54cddf2c90463fdb09b5ea14ebeddf8eb636]=AkImiPSRgrEAjQWTaHyP
question_key_val_ass_arrey[e44ae501a74b6782e146813bdace160133fdf088]=tzVYNLTccvSkPjFhhhVc
question_key_val_ass_arrey[3ae354548bd6f3fbccc49dea82a489dcf826f245]=msJRRyRomJBkmWxFYofr
question_key_val_ass_arrey[f4b410e681f407bf47ff68a2e9910f1ab54a1fe4]=TfAJwHuXoGrPPrsEGIkI
question_key_val_ass_arrey[4d0eb93ab6ff365dcfdf4a1cd2eaa89d0ef69079]=CsxnBwtYxfDWESHKSgkN
question_key_val_ass_arrey[bc79f34e36a9dfcbb9c7f319d93de5497d8aa30f]=CnhUdwbAnaJuPAAtxXNH
question_key_val_ass_arrey[83af00b407949ccc0134b4b3cf02a9bc6dd8b1ee]=VULCuaMOfxnbtAtNkHJJ
question_key_val_ass_arrey[5ed01c878ba1f43ba81465b771d6bea489a80fe5]=LNDyMJjmDHJwSzIJBBbE
question_key_val_ass_arrey[94e3eb261d3497664084467e0194e4ac00ef2010]=PJdIOKUaOzezXwmuBZjb
question_key_val_ass_arrey[1f0ba6f52eec01a2adfcd0af36ea0bf5b2275aab]=SmglHlrIbTencsARtPmN
question_key_val_ass_arrey[e0fc865f439bf3d8a666089a6f2eb2b52694db61]=HGFzzKBDtTjPaDVBwkDe
question_key_val_ass_arrey[63fcb38393fa353a9a47524ecda5436ebc0db2fc]=TdXZHQoVYflXLCdaOJUQ
question_key_val_ass_arrey[9816c170157a81de566f1683007c8d491703d700]=CPWtSCvFxUCRlakkxcfN
question_key_val_ass_arrey[bc787220484ca3292cdf1a1313c95f969a4fa218]=nPVjftiXkxIALmrgrnBC
question_key_val_ass_arrey[d5a22324712c261e2778298352cc01d4006c580f]=YomLONawtgEjRiKqpFRL
question_key_val_ass_arrey[27656a8c1bf1d27ca3e1cf9eafc42732a6351016]=rQuoNbzJTqdqECDlaFzl
question_key_val_ass_arrey[6af6968b35eb4a3c2da0a7421eedb8815e892e5e]=WBonYOvTgCxeJtIhNqYD
question_key_val_ass_arrey[930fbcaff03f6029db49f4696c786d6d91bc6c53]=BJyhXTIzCtcxDAATARQX
question_key_val_ass_arrey[e8aa79342cb3355eb92233a5ccbedb806223e638]=kViAJxFJIuYcyljHIzud
question_key_val_ass_arrey[9eb4896cb918a6013c3f0577e6e2451b952650d6]=HWxhWYACYMSVPzzvNDiK
question_key_val_ass_arrey[48baff3b81accbf50eb951ddbde38508f14cbf24]=HyuuooOdsxavhOeXITnY
question_key_val_ass_arrey[8a0959b167e3d84f46431727f68c441f79ca4a34]=BoFDLibEtYewSljVGvIH
question_key_val_ass_arrey[4b6f77bae84a3ab45f5d15727f97e77b59d6b0ae]=QUeJfPGkwvaejTDAVlvq
question_key_val_ass_arrey[43d346b1f230538c8127b879116867e9bf1c78d9]=rLENFrktZelPdTkTbkvY
question_key_val_ass_arrey[37ac816a1bc38d99e9b5341a2f6efd59460c6ab4]=qZAcnDRWPdSQhYJolHuK
question_key_val_ass_arrey[4618cf8dc9f5ed65034dc41e9a65d76968362e1b]=fhWWdPDpFxXvvDmFtklP
question_key_val_ass_arrey[d733e08b983f82a44c514ac04db8ef351b616115]=gILXaizaqWqTTlXVKRCX
question_key_val_ass_arrey[01e32f8be98a943297501a1f97c8a8ec9f14f7d7]=fPDWBBNUDaFjJyaetHKk
question_key_val_ass_arrey[511075cd883f6015f0ab5eac2eafecb49c96d4a4]=KZRZaIQFMkpmaAKAjMcm
question_key_val_ass_arrey[ac0d08752f9aadec0369654acf01bf212017bf32]=pGYKrKHoWodLeGFrpmgY
question_key_val_ass_arrey[acea88231b5f17708a60319865551f26041e7cd2]=kuozkyTTrbAtNyUVvbnX
question_key_val_ass_arrey[4de3ef5f165d3b73d8c5cccc15baeeb27771b974]=qoDhcNRuzbZMzDPqBIho
question_key_val_ass_arrey[7c449a1ed3ce786693020897f14a3030e97f7357]=MGDXHYpEXbIZTaEdmBbl
question_key_val_ass_arrey[4f9fdb1e5cf610f28e43877dcd26033d09cd644e]=EiamCjhLKULlQKEDQOcZ
question_key_val_ass_arrey[aa1456d3a17f0f970b6ad4a00d8dbdadcbedbc74]=MnSmzuGcfphaUxEnlmAr
question_key_val_ass_arrey[5ceea28425be12b1d5fe287691c82ec2ef173384]=QMWNASFiTDzffvHruUBV
question_key_val_ass_arrey[99bf724eb4bef792a36612fe18512ab5f2d1b3f3]=ezSRDFnDsnsurLMzGYip
question_key_val_ass_arrey[0b9420b9f7151e872a7e5ded1f29ac91b76df999]=fBsDwnHzQIznhjCEbIoR
question_key_val_ass_arrey[f1c294d8802a76f3b6b820a57d2be1fa283dadf9]=iyKpQxodmBGUKLblsXgW
question_key_val_ass_arrey[58cb5deb4b037a3df06d0295b2b87fc4cf13ec97]=QmzdPlOEUvSEffuymvQu
question_key_val_ass_arrey[bcd904bb84e4bb29100fef9fffe48cb139e69dd4]=ljJxgyMeYZUxwctElAMa
question_key_val_ass_arrey[6bdb62890072315d79eda848c9e549d90fac04d2]=CiyKtLTnnbDxTrvIDOxN
question_key_val_ass_arrey[9c180c8be32f2ea19fb8239972056cff7a6df5e1]=JaYdyqECNCFgyPRtdJFD
question_key_val_ass_arrey[a6303bae21eb1580745cc8a8408ab544dc0858a0]=dDKzUeljujIOFSPsItgV
question_key_val_ass_arrey[72155c9f9197835fe1024b7187f61b981b9d260e]=MVvWrYQYQbzSGDXbgiQs
question_key_val_ass_arrey[a625a9e556571fd083e50c7476c534ce81fcf81a]=ljbRpasmTzFTFNNVkrUX
question_key_val_ass_arrey[80c4493256965c9ed157768dbd620b22157c6922]=BlVinXjgPqbAOTjzFvrp
question_key_val_ass_arrey[8769361c0baf4a2b9bd673df5ff69dfdf909706e]=pmwDQTNdOtnToTrpmjSD
question_key_val_ass_arrey[9f9aa44494bea394f3ead589a9040f7c31643b6e]=BLsmuZOFLdQAOBybgkjF
question_key_val_ass_arrey[0120c5e895e229e774c9746a4460b7784668f5de]=sMduupALxgTtUYDrmFqS
question_key_val_ass_arrey[0c94ad7a461c28ed2ca992b5c9d80030cfcdefd1]=ThYKPTiJazCeOPbcpywI
question_key_val_ass_arrey[afa2198a321a14ecf0c76b329c69a05a4ff56912]=jQtFjocMvQZgtcDzYtAZ
question_key_val_ass_arrey[66bb9d1d53b89d45e5340db098b9fae5dba92a10]=PSEJJCemziQNyzgNAEWq
question_key_val_ass_arrey[51f96d04d15b913b0651ceb838d67940c95184e4]=ICtRGdfVEJvjBbQPKppV
question_key_val_ass_arrey[8f1a954b7130bc7dd07bb40f80cc461581026611]=zlWbMNPCwINePOVAmsKT
question_key_val_ass_arrey[c5d4aaefb3f1c55d166b69357303129033351095]=umbdAwPmVmScjYIBAKQz
question_key_val_ass_arrey[f43de5f61ea5c1fe65f1d85e6fb453d2af75b48a]=rvESlPDFQEosYdXosdUt
question_key_val_ass_arrey[43bc54c927b9dd62f5154210a5036db811f57dec]=PjBIreJpYWFZTpeZLalH
question_key_val_ass_arrey[b03d1fb55710d5f9ff90061deda92ab993980a17]=jpCWWTOvngXsuSodldpF
question_key_val_ass_arrey[4a65ae61cc9862240a5068f052fdb58b02a81d95]=paepASerJgVnHrKskvbX
question_key_val_ass_arrey[0cb88be0dfb3eb2b97d6af4314aaf7437051a58f]=CBZgBCRJhMZpturOscPb
question_key_val_ass_arrey[aa55926a2c0ae04b6364980c4b739dbd2aa07b40]=DDdSrkxdHkIzofgqkzBS
question_key_val_ass_arrey[f26b9e2b98afa7780a8926276b400c98ce5cdef6]=toJOGrQOoUoHYycbyUOv
question_key_val_ass_arrey[39e15ad7dbf28e6286b1adefcdf0e5b0b3452371]=VnyCubqAWalOIVNQIARr
question_key_val_ass_arrey[b0d58c4a6a9b943e851b326fbb4b9f42b3791b0e]=jMvFYYkOQFOdYrLxTlMZ
question_key_val_ass_arrey[cd60d30ee9161957620f4c8c685896f665a73173]=KNkUIgsmwDoneBdOiMRK
question_key_val_ass_arrey[ee3e8d9ef21478f3682ca536a58d34a5660eb7b5]=EvPapeCKjPgzrcSAAgHo
question_key_val_ass_arrey[5ae4d4058eeef314aa522a3ca6eb2ac881f8f166]=TiODrwpwHJQghIiDFzDV
question_key_val_ass_arrey[49051b8ee1c4601f1b9c31986b3afd0f0f9b7a1b]=vyOtNvVTZahCYjDHphER
question_key_val_ass_arrey[33a34129f90a4f1fa2c330579b9a7d65d7f600aa]=cCzqHNZLJqSUlpqeVwkZ
question_key_val_ass_arrey[21c5620e3f9a1c95d2e854b9d721852482a3abf4]=XgmLzPhTLVrGEATGiYbn
question_key_val_ass_arrey[18cb6436da099b52fb885c71850c2b80ac2c6d91]=XkFkuyXHHQxhBVbGTvlY
question_key_val_ass_arrey[018d99842bd340cff3481b0f90c00c886babfa73]=sNEQJqitoekIcYfGgJdS
question_key_val_ass_arrey[0ae423177d6c72a1fe3904b0aa6f157a2cd2d846]=HUpOjSJCqCftGcZlFLAD
question_key_val_ass_arrey[30200741827597cffbe7f2078957dac508984049]=liJxVKJYVHGAtAhdDcxA
question_key_val_ass_arrey[b94ce834a069e2498ab020a7bd050f1dfefa7a51]=otjHuTOFlrDMeDpmCvWz
question_key_val_ass_arrey[ef1d8f7d21b3d386d7f8de736ad2f3366403cc57]=DhyZCWOfteSIsegZRYze
question_key_val_ass_arrey[faab369b80189d1934c4c4e261203344e7b45d44]=nubOztIUhAbzuKwmnPuZ
question_key_val_ass_arrey[39dc7417ca0a3c29968887ab6d271561941ec1a9]=cbWyfFGtTvtNSTNLNfQl
question_key_val_ass_arrey[0d36cf07f34b41d4c9f1b45ea648852596b3314f]=tKsTXQwFkPxjSzJfrJSP
question_key_val_ass_arrey[11124100bd7c537a759c9626f351fc6807c60b3d]=CLEIdMxDGncPbWJIsDem
question_key_val_ass_arrey[bb01058c666a0853e8d1b6dbb758f5d7204d20f7]=YufeIFiRpCCJunBcGXwg
question_key_val_ass_arrey[b622ca4820f68a1e5b938864ae8c82ccb3b1fe23]=dSieKYapCOHHPnKpZtBs
question_key_val_ass_arrey[5dd243401a2490089c1d0512aa2bd271de5dbbd7]=JLypWNuGBERlFnqeAMcE
question_key_val_ass_arrey[7ac3f946eda6f2ed4c0fada44c51e67b2a5bf507]=kemCDDHBnbxYEzVIOtZy
question_key_val_ass_arrey[e9be95feb2a28767db843cd703a03ef97bea50ab]=IGSQtYSHJigXOrpYdTAC
question_key_val_ass_arrey[7613c56560099f57b63f457d68c6773f3702d5c9]=clhCAfrtvziylEhEtnPE
question_key_val_ass_arrey[c45db56f27794104c142dd33f20100dd3ae3d1cb]=JJJskcJWktkywkIwZMzf
question_key_val_ass_arrey[c527a1c7a5a91163e0e32ae43950bfdf61f2661e]=SOEroSMgdaePjMhzRTDt
question_key_val_ass_arrey[9c58b335593a423eec70d0b159b369fd1f307e76]=lGEAlmtsTqRCfwaViRTy
question_key_val_ass_arrey[4f4c87fbb41244bb757cc34397de78422b810189]=SIKcEWCBvgQsJMnePOhL
question_key_val_ass_arrey[61a957a17aea059cec858cf23b1b68e03c09c36c]=rrgPjABHQZTQVtIgGWVb
question_key_val_ass_arrey[3e49222ea384fc7b9b6af143446bbb9e54d1d833]=etuaIHROewnOIjPIiPum
question_key_val_ass_arrey[5254c058ae69a9979e9745774b6b2b835daa4968]=ghYmTsMneHCaPKULGjTM
question_key_val_ass_arrey[bc8352adcf37df2db2961ef1095800eb811908dc]=kooyhwGrlHEYcheEyaJu
question_key_val_ass_arrey[0619f8b457ee55da937b265c7c61d710cf49a361]=YnCrbSeRTHziKjSkFhqm
question_key_val_ass_arrey[efeb45cb4432ef66366117c0a6e28c0a3447c207]=ufaxwBChtqDVcJJhGYzY
question_key_val_ass_arrey[9a6555d6d07be5d382c9158016c0f71601576104]=MNwvxSPkxxJNhIvSdOEy
question_key_val_ass_arrey[c40c4a10a96822c953b767ceed1f88c0073d1318]=oWZYeJdhXcGsuOshGfgB
question_key_val_ass_arrey[c9b1fb32dfcaebbb62026d85735a9ab17c86e64d]=nwVUofDScgaaFaEeenUu
question_key_val_ass_arrey[f0a5199f2f12b52d74dd4da26c364f537790a549]=fNCFnBOFPnzFGlzjpApc
question_key_val_ass_arrey[419a44bf36469d7b4b0328d7577b3fd44cb26f17]=HlGAhrtDMImSMhLQfBzE
question_key_val_ass_arrey[9dc6cfebd286357fbae0eb1b518b369edc415b48]=JTukNPtmLhZGykcfZbTD
question_key_val_ass_arrey[3195f7efd0a02c4e42d2c42d563b5977d8ba3251]=CrBvHiQKWEaixHZIRbgn
question_key_val_ass_arrey[004e3519ed1f34c699f182c9d4d3f4a669496947]=BSYwUAzdxVnTOumqWxWV
question_key_val_ass_arrey[088fe5d3cd3457f527194403a1de5539cc0d97d4]=qkAoetbzERiJDzVrOOLM
question_key_val_ass_arrey[c54c5f96aa57b15e1bfd8611db61672801a9b5dd]=jLKZSBYHnREkPXutMFXN
question_key_val_ass_arrey[0affc69f79f3b9b2f9696cb73bac915b35e502d9]=YAAFcsQDfQZAFfOwzrxN
question_key_val_ass_arrey[deaaa9d64eb95a40a72d336ccdf2bf02846dd9fa]=CfwMLghbuKKiREIfTxXC
question_key_val_ass_arrey[aba5828770cb52694516b5c48de172a7c1c7406e]=JLAwPpQFaqFjtgaQcgpx
question_key_val_ass_arrey[ea0e15d8d393ff811cb694620b4da2b07d82a95e]=wvkZWUxHlCJBxzcHIjkR
question_key_val_ass_arrey[c04ff7489a936c31fb87d626ebca67fa48dbb909]=idmJJfNjkAMFWdcXiPpl
question_key_val_ass_arrey[852fa5b940bcc1046bf6e99eda531ce5f93a0452]=EWStGzHWaYCjvLFIGgEd
question_key_val_ass_arrey[73945f72a2e5f6336c0b489c386a3bb61e3b9c91]=vKuXOVHoEyPaMIORdfqG
question_key_val_ass_arrey[f084713c053c16963a77b0441ee863ef9302942f]=TMoLWUlaytRHkOehyzAE
question_key_val_ass_arrey[67fc8d73f0268eff8252f6e2de86cec81f5f0ca6]=oJXffgLjdLGJmzgnNbZB
question_key_val_ass_arrey[c5a890c25cc31b26a4a3bf9809f06111d2438fb5]=nozxPWrnIPUFeWEYtsZv
question_key_val_ass_arrey[7c75021d1e15fadcfa841d99f290738f06de78a0]=TJpkfpbOxHrJtJkIwoYo
question_key_val_ass_arrey[22c9edae9d05f585d67e6f947e43cfbe3bb8e0f1]=mxVtLALzSzNCkhqzBstm
question_key_val_ass_arrey[0e553f9bd16cc46529104ce6e2a44714e0a94d38]=efJsphrqEFjNAihTOIPG
question_key_val_ass_arrey[b43c7ee9fd888d62c881ecb921fc8ac9a1ae348b]=QRzgmJYfXsqKHelLhrZR
question_key_val_ass_arrey[401211e7d9fb33498c4b7ed6cbf4880d5c1c11fc]=tqJEvqbKKbgqrxieuyAi
question_key_val_ass_arrey[634e95ff908365af035362e64ff832c71ad66782]=iuBSlRTrPYOUBIAolRgM
question_key_val_ass_arrey[54a74d43ae1e78f82c186e4c05e0c79fbaa89fad]=wTzHpXzycqllfXgZozIi
question_key_val_ass_arrey[890be2dfc7d276a20288584f404a25ab95f1db5d]=XsStzAQQxRcBNNwHJwqJ
question_key_val_ass_arrey[2f8c50b5f0abc995b5df333e1015f418fd0a0b90]=VsugVvfNQOanjZjqXULa
question_key_val_ass_arrey[e1e526f63e714481910b02ec5b5776cf3762ac08]=CtDrODMbggrrenFdXQFS
question_key_val_ass_arrey[420c2ff742d2edec55942922c12a75c36c224edc]=EkzAqbGpwBaHndncPgIC
question_key_val_ass_arrey[8fff6246149ea45a850b46db3be2e4b0901eb371]=qJQxmEWAmWGUERjiRsdw
question_key_val_ass_arrey[6f7515852b51b4b3b61072edb94dc190c9ec836e]=wTFhPNRuORDPbQlBQwmZ
question_key_val_ass_arrey[86b5435835bc67ac3786076635f10e869165e833]=TVSrTDjNKJFkpGSOgqot
question_key_val_ass_arrey[501964cfb303259cc8ba4676e8091a17d1200257]=hSlSSGIugdBXAImoIuaZ
question_key_val_ass_arrey[d0b79a0990c59d9a03977c4fc134d76be945685c]=gMrEHSLhpefJzAbTvgIq
question_key_val_ass_arrey[5721b23028e1450b7a2830ddd3e2eaf2eaf6e6f7]=hfizZZVxhevyfaJnmEyl
question_key_val_ass_arrey[dd373f939caca678cd1e9bae8eb90f77b11a6c89]=suTiIGqsBfKIOOiqrHae
question_key_val_ass_arrey[825d0ef04f203b4bade2407179a22f0db1f276b4]=YOawBcDhqudMXmOCEbbO
question_key_val_ass_arrey[dcaec8e9c36bfaac55d2a8edf514026891313574]=yjXJDSuhnBcBQToLtYHL
question_key_val_ass_arrey[318671ae7cd3403e4165c4924847608d0840aa05]=WqZsRtwzgDPynzcWhwOR
question_key_val_ass_arrey[7d96bea8125048c070e500b61592dfbb3efab895]=ucsMWDhglmUBbFxMbQeo
question_key_val_ass_arrey[0d350724fb23b083dd2cc2fe34fbb30bda150bc6]=lczTKjPVNORofhZvnAKV
question_key_val_ass_arrey[8e9b1ca3680bb31d117518c1c6eb4b01622ac952]=eHPYoXRgLHDaxvzRjdqG
question_key_val_ass_arrey[69c59ba7275c63b8a785796fc7d384ae6f106210]=YuTlCywXwdQJbGwdofhl
question_key_val_ass_arrey[f79043f43409e80592f5815f3b4c24f003810bbb]=LYJNWpwwetkiIuhULfoU
question_key_val_ass_arrey[c0084dd1f5aa1b9c02f6b3f636086ff942276d1a]=SYsQrLKvWKQbvgSfoOjd
question_key_val_ass_arrey[f54663f41ba8769d93ba922ba8d01860cbe81780]=ZsrYTNBEKyFumzPKmGEs
question_key_val_ass_arrey[bb74492b4f496bb681c74dbf06b53dd7e77de8be]=lKSeqIZTpiDnXAsahqky
question_key_val_ass_arrey[86ebc4790c067a35f44677db7f3d2ab70739e08e]=RFxkxJwBJndhmbcQXklY
question_key_val_ass_arrey[bf00fe4e064499cfcf577632fdb1e64ecc275d91]=rhozabcJAQDIriIDKNie
question_key_val_ass_arrey[53b608f9ddaf02ffd18d3db0020230ed79bcdff7]=LTOHenPGjEBIAcnxQlOr
question_key_val_ass_arrey[8e86d34b5b83cbf78a5d3a08f40f8d0a742347ea]=ntYBZTxTXFrrDhzRBick
question_key_val_ass_arrey[b1e91a5c8f7b786cbafc97e82c09ffd914cacb71]=mDiWzndpACkdTarwkbfX
question_key_val_ass_arrey[ff7f77f1bb8fda47c3408dd264bc81ccc93f6c4e]=MeNWOJXPNNQcvCfdeCAh
question_key_val_ass_arrey[acb57a7f8cef18e26679509b91e7d9a667136526]=aILJIXWbrxyAabsSekZr
question_key_val_ass_arrey[8533a71e460e3b978444df18fd7f9873c8577449]=VYFTSBEVHQmxhABycFyT
question_key_val_ass_arrey[4cfbe9eca538bc198ddb02c3883804869e459d9e]=RZjWdFdmqLwnnSzFTZMG
question_key_val_ass_arrey[babe2b92e88ee590f6182783444cde8e4c5e8bdd]=SHjYSQeyeSYQUMiAKHkr
question_key_val_ass_arrey[dccd6b2d5efcdc9313c3f07fa32fc998e0cfc5ed]=CHtMUMifRdmzeOXhmijv
question_key_val_ass_arrey[b11ae96c7ea28a6ebc5a9135f202a3e87fa415cb]=wSJrQHkmnDgTziiYlKmP
question_key_val_ass_arrey[db48abe954b46b91f70bca37cdd81595b1e89bae]=OSebSBAzzTBHhvHqvZLd
question_key_val_ass_arrey[a7f57c5b62cdf8a4c41cb8281a74ea10efa7a511]=klWXWESZnBxjnFnqeYZx
question_key_val_ass_arrey[04d57b37797d1118e8f30cddd797b2b310fc359a]=NUrCJkFxlrnuhlOFKKUu
question_key_val_ass_arrey[3fdf0e0efcf4f4bded011abcdfb8518d9028ab83]=NwPSLQwXALqElpVuikNn
question_key_val_ass_arrey[6f2b04aacb39443f655687c16c2f20c16d43e34d]=BGSgSxLovoXlLHRddPaW
question_key_val_ass_arrey[36c44bbaa0c07f840947d49a423d3b95e13bb569]=kKoAxvPkxWMRekRZCqXT
question_key_val_ass_arrey[388e1ab057ba512621c673ca7587f229ab76610d]=kuZIZZpRBeDWmjUNOdEW
question_key_val_ass_arrey[a25e38942cb990f44fcd1d2bfc22d02a80f7a960]=BHrtaGCcvyeeRhIwkHjv
question_key_val_ass_arrey[1d5e33088d2f99e57eab2c762733e32064c29bec]=EthCMoDKJnPReDQkEtKa
question_key_val_ass_arrey[9447c83416d80ec6f363fd1de9593e4e784814ca]=yMlfOkywXgFKetHzOivL
question_key_val_ass_arrey[ff1d6d285173149c85a5f9dbfc5fb86249df6331]=mWvdsMXcsVttFdwJvhbC
question_key_val_ass_arrey[e3b27f2d20913917e707fbf4601da6b9df5f2653]=rEkqfJhQMhtlTuPHoGTQ
question_key_val_ass_arrey[31d5e861e6759018e9d6f3ef2d854193fbb2bb79]=BXJakLrSwithXjaXKcBL
question_key_val_ass_arrey[080de59d4bbefd712d5b4a979c2b0bd16d074ef5]=bPrLbZynVfXwTKDCLnMS
question_key_val_ass_arrey[28f059f582e472e1e98a4c73d5ac37273f51955e]=AkwMePIHzvfwROyhKArx
question_key_val_ass_arrey[adb5bd2ca5a6a1ce52b98f15de77a009e14ef2f8]=zAPGwipOVCalHIjDSBtf
question_key_val_ass_arrey[b28e8f40a63a307b0991dbcdfa4c9cd4841476ee]=ZMugSmzzHbxrJLXjEjnh
question_key_val_ass_arrey[0923b04cbbfa7123c988586b8d2364b2299a80e9]=CBqlXijUkdrKRAZOOnaT
question_key_val_ass_arrey[8acd7092d0424b02241f8a3fcc6834bdb358e0e0]=mghJvyIpwBLgjupkajvA
question_key_val_ass_arrey[cafb9ad496e58d0e3ee84b26e90245c236dda205]=LBCcQBwfTrPLbBjgLjzg
question_key_val_ass_arrey[43b976da6606a4940eab16993598746874e79d66]=LIvMmmTxrDzpRHJYVHEB
question_key_val_ass_arrey[aae62b18eadd51b20d3f689cb446cbdbb427d9e6]=bdZAUqcItZRgCYNRQsSr
question_key_val_ass_arrey[11668f49c0dc5e7c42d559e6f28fd80399b32c1c]=pnGeDdPTGulghJXEkgIk
question_key_val_ass_arrey[c6c22d99f1b53c46ed77509ea68e87299af60cb6]=LJMdfAdpGEFDkygQpNTd
question_key_val_ass_arrey[179ca2f6d5cb2eb4b0e5ff64e092a38ed215b38c]=lJKDqZuJUxkwVhLzEktP
question_key_val_ass_arrey[abd8acfc84fc633b65ebe1d9909c2ee6273f2c55]=CeDNjaKtVgRzxKlnxFbw
question_key_val_ass_arrey[8c2347876d7623aa3f1ebe0502f032504f462f4b]=uzTaYlBmUFtuQHDJtnmn
question_key_val_ass_arrey[f80634e54729850de86cd5d7f3b5c7542950647e]=rApaafWkzqljNusdjSAo
question_key_val_ass_arrey[d43469cbcf85a7fef48fab6e227cf5d86bbc82b3]=PYQvkxYsfLoWtsZxTyOv
question_key_val_ass_arrey[77a8f35fe6b8bd86de736b9fbc8d27c1cfad69b2]=dcwaqMgljLdXSLbglQSQ
question_key_val_ass_arrey[91d9640e0dba52f7512307c4b9f0d566e6df38b5]=qNUMcStMvjNCKeHFiLjQ
question_key_val_ass_arrey[8083bbe851c9649dc259afc66c59e0d8448f174e]=OvPCyPponUQPrWmnpLgC
question_key_val_ass_arrey[4552338bbb9ebdbdf7c4110937bf1e720f31e398]=iYrVRheMLuuACzkPgMVE
question_key_val_ass_arrey[6dd3b5a9965ae0dc12a937f54dd4629af0ca9e0f]=RDHyNBsViyWRsRFKEFul
question_key_val_ass_arrey[ee55c130bcc2c1d76534252574c30f635c20b0b4]=obZGokTrMYdLVxSlqioA
question_key_val_ass_arrey[b66d7a0c6c588989b3e77eae684664168cfe1ef7]=tfMtCRFdxSpzaxGFRYEU
question_key_val_ass_arrey[e920aec29895f7bb8c257948d1f31579319764a6]=sKkZyVHWOHTgyYbuhNCW
question_key_val_ass_arrey[d4406b2b60a0f115f7a89e42a8d2ad21581358ff]=LgHtleSSqnieGKZOmoWC
question_key_val_ass_arrey[8b7b1282173847d1e03a1cda0f6612c64968ee99]=gQeDCPTISbkhgANBtuSz
question_key_val_ass_arrey[c9a3cab36bffe647c01d3a2ef6357ae2d5a50768]=TmCnpMKEUaCWzbKCuwDC
question_key_val_ass_arrey[6cd2ff1e3fe221f5940e4476d5b72eda3c9415d4]=JuKRjFmPBzFbCURcvTJD
question_key_val_ass_arrey[ccd6f122e0c2c7cf9dbe7cb08eb96b59898d1c1f]=zCgPpOjecNQqkAyPZUrV
question_key_val_ass_arrey[995eef1ff12f339f5859bc05765c45e1d38dfac6]=bUoUbaPgzhVsXKFiHUQq
question_key_val_ass_arrey[66887dce67e0062f638dff527a082b7ad14a839e]=fbdlayIKnOauqXufVwbg
question_key_val_ass_arrey[0c53f564b89af8726ae9e610424a499ddcb6b36a]=gCRneDtsZFlZeZyKnKex
question_key_val_ass_arrey[5677feab37be6dd75b3129be2f8832b5e3be10fa]=ATaUieTPLkXIWOqunmGQ
question_key_val_ass_arrey[39411d4c045772a6d15742ec2d48e5ae7b3a4740]=zUmSAQKxcDfpJzwlmalJ
question_key_val_ass_arrey[71259fd04b36c5598ebccc414aa0b9503c57375a]=mxjZfrBAtGNmVEuPJDaP
question_key_val_ass_arrey[45243f13741c07be984ab4e383f756be23cbd2ef]=ViQDtimlzFhYuMpteMqv
question_key_val_ass_arrey[ad7843d19d82de20cbc50846b6d2978c16f2c6e3]=XrmUyHwmlcQRuhWWfGGM
question_key_val_ass_arrey[9fb8361413bb79d8e22ad9185f462098c40c6d3a]=BTWGvdQBejqvgoHTDcFH
question_key_val_ass_arrey[2e23132208a90d7f611d279d42bb253aaaeb83d4]=yYbRBJynxIhpFxNOOnxf
question_key_val_ass_arrey[18b9ade553d0cccdcfa71714bb193c85e2be0e17]=RdXuKRygBRZZjXqeVUvV
question_key_val_ass_arrey[a3fe7d504322070f115feceed522dc1991400df3]=eowxHJRKuYYroFVrrswF
question_key_val_ass_arrey[169f45970e0ed64ad11e52fac922d9dd552264fe]=pFOBFTjjIcwinfZFHhGM
question_key_val_ass_arrey[e492f6857f403be7d88bc8e6c0463bc9e40f95b5]=FJwMBBuaCQrWhLNAdKgH
question_key_val_ass_arrey[a7511c97ba3a56451e9dc9f80e3b3e8ab67302ad]=mcHJPFmJqRiKcQFiXMrR
question_key_val_ass_arrey[e00863dfd336e4134eec6a78d96137b71596016c]=IwcbSmNYmVlvEiOlDwsg
question_key_val_ass_arrey[db4547ec82a44a59ed8eb7d9278450e08852c622]=iYqFZTEeHpNNlFqPUqMT
question_key_val_ass_arrey[425a8a11ad7b79548a05a3cb5c95e2dbb389defe]=DvZDbbKrodXnqdfdRMFT
question_key_val_ass_arrey[1ae2c9946d390627bc2b60edb165aaa1baa12b42]=gwkhTNmmVronDbqQjvGB
question_key_val_ass_arrey[0a71b7be0d73a5c0ca3d1c36cd442d2745b971ec]=dDCjRoUpFlLXzWWApqEO
question_key_val_ass_arrey[a8a3af8fe5ca7dae92b3343efb4ea73267dc5c3a]=fhnflKlvKTPFHsZIMrBh
question_key_val_ass_arrey[39263c418faac6ff27a3385e9b0372adb2c9c159]=aNSGNuJZfgFBgsubpxEr
question_key_val_ass_arrey[5225a7f1c808534eabf7a94ae0b41342aa00ef80]=MnhOfXVUULFQXxjtCVZR
question_key_val_ass_arrey[562ad7c30eba7cafe08a84fc3e2db043387ac0fa]=lnVAzTFmvdacnSFxkXmH
question_key_val_ass_arrey[e355535a6da302f6d13e36c37e29632d0f67a258]=CQXrrPlwpPBCxEATSMVX
question_key_val_ass_arrey[e7aebf54d3b20b8724f2f45e2cc912e6365f7611]=wSrXxfwbSHgNltjLZxTN
question_key_val_ass_arrey[178de38640afb19f2380c4e759915799123ef7ee]=epLlhvaDolAZeRGvjOPd
question_key_val_ass_arrey[6b704f20b866262b18b770d7b7e59cd64c7884e3]=cqOQiaOBWGXSpyPuihUi
question_key_val_ass_arrey[82a975efe488f318549329b0fffec181525aeac5]=EBdYMaJbYBsdfZrkRSgs
question_key_val_ass_arrey[2561ec091d181cbe902a00e283376cea2e0d0b26]=VCaBFNIldKCdAMjRdzJF
question_key_val_ass_arrey[52245a0a77719bfbb99b0fd936ed3626323ddd89]=goKvdYGpEVVMvBqDbMzl
question_key_val_ass_arrey[c63a01c6f34d22d2ebd638ac2411d992f4611a2b]=LyBpJLSYqbxXXCVQoNHn
question_key_val_ass_arrey[81555a0cf42c39b455d4d2a0d8526b6dd9134462]=kMMbwTCwGEmWJRvghnhf
question_key_val_ass_arrey[9d789d83b204f545dfe8f51d721c7b4d18bad6a5]=xWbzcQpPwHgHRVspQzJa
question_key_val_ass_arrey[2bdc70809289ff7e1237bd5d83549c024d364e06]=EmEusdvgqmsnZjIQpBkS
question_key_val_ass_arrey[9ef269ea3deea6575c2aa917706e08b1f08dbf34]=mJpQqoJUuxvMSaQpQHda
question_key_val_ass_arrey[ee0cd09eea36e9244098a46c15cc7b9a50e2079f]=GUKzaPzNUCdgWaQNxCZI
question_key_val_ass_arrey[26380161fe956de04e54b288a2d8c5619ad17c3a]=YNtxaPpwXqOCGgtWDBRI
question_key_val_ass_arrey[31f3554ef204e1a2a1d9d23d8b6d21d568392172]=weCacIYZMwaiiTQdEkyE
question_key_val_ass_arrey[bd873eff4273ef14536cacb9d1beb35ca937c0e5]=NhIJiXFQjwBzRtdtfOSA
question_key_val_ass_arrey[66d375f1a214f8f113adae049b909b8edfb2700a]=dzqsUIGrfclGYpTBwHKO
question_key_val_ass_arrey[910801524269fd20e88993617bbe98a89ea496d9]=VZdTIXdmNsXdKfvvxZya
question_key_val_ass_arrey[3885a3a349fe003ff71f8e4d4faf2c7854035213]=ujKuaQSvDHaONpJTGUtu
question_key_val_ass_arrey[68a44ed42ecf765171ea1667cb62c95007b4251b]=krZPdkCBUCRzidZsziml
question_key_val_ass_arrey[d391a210f2a3aa2f2bfbb39d586cdc9aa7bb78e2]=kjfMCFDQDpYAEguFLYfX
question_key_val_ass_arrey[b11726d8398afae2c966e5137d74f497dbb8fedf]=DHbtfxsqkUBGODNtIOEq
question_key_val_ass_arrey[27f02f2b6f90b72ac2dd51d97d33eacf9cc63bce]=UapIkNXtSoijqrxdCTXt
question_key_val_ass_arrey[d0dc191ef8998a7cfb1ce0de7d5f4c69faa9f2a2]=thkPhPqvMumLkhszAwqU
question_key_val_ass_arrey[ce76e9173cce2b8de92609455312fbea52c16765]=gXAgQLdbOfhqwOxVNUsN
question_key_val_ass_arrey[ba0bc749d113708927b49d197a535558e5d63d24]=INDRqxULCpGHVGOQmwsu
question_key_val_ass_arrey[c452337089552abed49d70cbe17a3bd3b933873e]=CImdwtQUpqggWhWNxymj
question_key_val_ass_arrey[4ece8640fb3c306aff95f1f0301c9212a6e28afb]=PhoEYalJnOADGgnVzmem
question_key_val_ass_arrey[a6e83d62adbebde9f692db449671f5284217347f]=UcaHnpTZBjPTopibCArf
question_key_val_ass_arrey[d57657f3a925c0378f76b81bf8932e6a992709a7]=bYLeEcxvOjYaZVanTSdb
question_key_val_ass_arrey[3feada360d8e01739d11f15de727ecb2130cf9fd]=pHosgIOJACzZpDPSJVgq
question_key_val_ass_arrey[4f66bd35ef3f0c397056da6a654c4bd76700925d]=SqjZQfkLFoVEsHuCPoHG
question_key_val_ass_arrey[89b89dd7c92c0003e932db312a681764911f5ef2]=RXiDpWEEMuLTdTNNFynA
question_key_val_ass_arrey[86082c91668f128b599bc258f2e74bdca819df75]=mdVRKzbAVbilCjLMBdUL
question_key_val_ass_arrey[9e1c39347d70c9c2600fa2f248a1449330877e25]=WgQedxEnTNyvdslLZakA
question_key_val_ass_arrey[680983d9659bfd3b2d0427ecb707cbacceadbc38]=DJcSisMhbJQZOavypmKe
question_key_val_ass_arrey[ac2716daacd9e030194091c24d9891d1d7a4134c]=ZHzPfvoNcrYlNpIQreNJ
question_key_val_ass_arrey[eb3e92bbb3a280049f731a92dd202d6ec5c4a8c3]=mzvVnAVUCuwafvOZcYtq
question_key_val_ass_arrey[c23509ac39790532f3dd9308e949742820433395]=uzKGAEmcjExYSjwaMEUA
question_key_val_ass_arrey[08a2310ddcd437be7151293ae97f2d8b33d7274b]=YieRoqmyVVtCVYFTAlQg
question_key_val_ass_arrey[e33b1ef364d86486dc2f23a48570248d273987c0]=oLcVBsnTILJxaJKNJMqz
question_key_val_ass_arrey[81d3f8e1bd45c01211d49963d7969bf076838ac9]=fCrrBeIucKnVGuBkQUqL
question_key_val_ass_arrey[5b896f2a6ef9de751fa5ba8a167467b283efee86]=aehKfKSfSIeHikSWPivc
question_key_val_ass_arrey[c448e75f96f67f0a8a05e7f0f957ba8f5d678a27]=VnioPpqEUClWletquRsC
question_key_val_ass_arrey[d99b426a21618b2b736b44baac800d4f1d116639]=JqmWYtCaxuMgRhFMHCtp
question_key_val_ass_arrey[a79ad6d07eadab405690f1107a2be800703c6b58]=onXyumhKOXWJFXViIbsi
question_key_val_ass_arrey[11b25d94a51fe966d28f8267ba6fa0d9f19f0216]=dMoiqqLLwvVNhUHWVQma
question_key_val_ass_arrey[c3d0f9a55a4064e2bf800e39896543a5f2c522a4]=oLwcwEfFeLpehNtIrTTp
question_key_val_ass_arrey[c04638556b3bf37e80f473e471a8d5b1255b6583]=EjcXHObSSHNbCxxaxqyg
question_key_val_ass_arrey[1e3bf8b7d99c025407f7344754906772a4969c32]=dGlViCHpKCJygbBLJAaq
question_key_val_ass_arrey[8d4bd426d0f61bd8e76c778fd239c66b89da8d99]=CmCmeptWaOQDLzEikjRU
question_key_val_ass_arrey[abc6f4539a0b262471cb90bd4f064ef4cce1e5ae]=DklxlyRPOQITUEmXThqG
question_key_val_ass_arrey[9529e4cf7d8cefc0304c3befc5b15b5667fcf96f]=TNsuphwyBbsVnWudwVrn
question_key_val_ass_arrey[074581f61966605a180f54696978873c9168cac3]=dEULNZafeEyyhXvexOAN
question_key_val_ass_arrey[275dddfe7ed427c5dfbee9e4e28f3a941d6863b8]=ypUwKTJYQPoLXYkUmUEw
question_key_val_ass_arrey[afc5474aeee5807d82f954bd285b599692626a28]=DKURTwxrZqhJxRZQbJRm
question_key_val_ass_arrey[b84c3b245cc5f97142b07fdaabb2faa99f9a46ac]=IlcoykZBISRJVwAPfGrf
question_key_val_ass_arrey[433a79f713c21717d658ab80b65235760cbc91cc]=bcPIwFhGUMIdclPIhkiH
question_key_val_ass_arrey[1ed2c9ba172082210e64450dfd12d9519bc60a31]=jaZAqSSHYDFQbivsACwX
question_key_val_ass_arrey[d38121272a3139f32121a275b25efef74e46a638]=krldeHRdUZczyjTtgfNc
question_key_val_ass_arrey[134e1b37da091c72f169375f99756ebd97d7460a]=rcVZdgoxeiNEniRqWkwH
question_key_val_ass_arrey[59bd6eecf3093dd7845212c8a46d7f828281e45a]=JjSlNvkoeEsLvQKqHcFs
question_key_val_ass_arrey[0f13170c7c7d6760b8aad8ba22cd2c5b0d98a5c0]=GLRSiwMfSbnHnTvIcVBi
question_key_val_ass_arrey[9d18841eb774f673fea63245687968b0c08bf362]=yYcabJJEimaLdvpSOCkt
question_key_val_ass_arrey[1b6bb6c33e92aa2e2440bddae9632c21cd27655c]=shLXmaOwfNXmhAvoVrMo
question_key_val_ass_arrey[5e75db110bf9111d0767ec7b9d059844d47e5095]=nVDckznagmNyPrrspEQp
question_key_val_ass_arrey[40857a62fd7d23eedd2ed1d47fea6f528feff5a5]=AOPfufhmudrzdIGBPvPi
question_key_val_ass_arrey[5d51541db6fc85d89ab3839042ee570927a7c5c1]=bFtKicIxBvraRPwiYnwE
question_key_val_ass_arrey[4a7c8860e0605f805087df75e07b71970b8bc45a]=kwvQSOELUAHEGpnvkehw
question_key_val_ass_arrey[24bdb5df2cf162a64242f33c67b64d2bec6d242a]=KsfKzaFTGfSVwsYowIkS
question_key_val_ass_arrey[76c43bb453683ae7290ea31b70aa5c590bf63c9d]=kJZGXusXauOkWxcsAGVK
question_key_val_ass_arrey[c3d9dc144a21335571189e72c2d3316898025aaf]=WoybFrIwtfOiipvUMKqg
question_key_val_ass_arrey[89bc00b3cfeb674bbb815ad2a9a43c4aa0d674bf]=mmBFLeXEfjoDofJDRxLM
question_key_val_ass_arrey[85c83b32561b315e00b6a7944d60ffd706fd1c19]=KVyoqHfiQQNygUXBxQac
question_key_val_ass_arrey[638916e90185878274cb3d48065f42ef50dc33cc]=XjbIsCDBOhwikCEpiIrI
question_key_val_ass_arrey[06074b474fa737bb49223f735c4792fdaea0f8b4]=mQDwEQoprtPDyxFkdvRL
question_key_val_ass_arrey[5c74474ab3468448c6638886a87239ea49ae9ef1]=gIOezbDOhoDtqAHdGxvp
question_key_val_ass_arrey[11ec7f392f33a7e6a9822f355a7730150d400371]=LdoXvOXgBxjQyONkcBac
question_key_val_ass_arrey[b4ced86f5ee48d8113a7cad15559a52351d0a108]=pWofsQVwvdNOQIePlaVv
question_key_val_ass_arrey[12c051415042abe5d79131294317346c2a3fad01]=SbQLAIQLFJoxlsIaDXfM
question_key_val_ass_arrey[750385aaac3049c74f1718159120b2f4390ecf3a]=eTumAHnXiyQtWZIpgEbr
question_key_val_ass_arrey[8eb85365ded1da0c8fdeb22c2443f98ac9a9f630]=mEFhswORnTFASDdxsvOR
question_key_val_ass_arrey[5f6dfe1d47eabddc836b106d538899ad9fe99383]=qqoAnOrCkTqHQTRqTXXH
question_key_val_ass_arrey[e1457af9a99359bcc4c4f3ed4000f852554417da]=MdciSPSqcVBaiAOQMZSm
question_key_val_ass_arrey[f9dddf854bcce9858a684924bc929a66472ff265]=iMsURHuYwiUpcAPjzEMh
question_key_val_ass_arrey[dece45b17a2c4d944a7984d32bf9ceb1ec041d2e]=nkwizyXDfdRJjzXaQcJd
question_key_val_ass_arrey[eb9e2c6df68b1d7cc57d702561e26e5fbdc4228d]=XmmcTDqqMmIKzJZHMdrr
question_key_val_ass_arrey[74875cd134697c187def845f6cdcb3e07cb0c23b]=qedafQXwFNRdpkUjKjaT
question_key_val_ass_arrey[9ab474ae053d6a198938068bc798a5e454a8ecdb]=kUIXELhrcboQpbdJPfeW
question_key_val_ass_arrey[895b12557877edfd419ea0bd54a14646fb63ac81]=jWqVqAsxCdMLYnDPmfYU
question_key_val_ass_arrey[3434c534f1e828cde7fb4dac37ccff7f7d3eba9a]=wruuYtFBRZNtcSdSiWyR
question_key_val_ass_arrey[47d3ea9fd1391f3b711bef648b2c15771c64ef75]=yEgGjksCEMErsaeAlgtr
question_key_val_ass_arrey[72c4b4fd3c4a7e79775d3a33e414103fbf4d400f]=qoaUFjhkSUDghCymhelP
question_key_val_ass_arrey[0a591e04e7ea779a4abacb134d878f3a0626b322]=ZTguNOTYqolgEBliQsaX
question_key_val_ass_arrey[ce9ffe4b761c5a80b0f0eb4eea20ea45793f663d]=ntQMBCZMQuTYSVivdick
question_key_val_ass_arrey[60f9d2c343b505474e5af1b37f41985ea70a5de9]=RJDZaKzckjfTcPYOajNj
question_key_val_ass_arrey[8710a7960b0478ca7626d91f9e60af7924db11a3]=RGXPfDjtNJZeEmlHuvLN
question_key_val_ass_arrey[05270b74532fa28380d7c0c291185e7a1d22db79]=cbIMuKrgTBJnlLJeypEf
question_key_val_ass_arrey[8ed7385a0e1378d7ed8b6a047ec853dd9ff31bf2]=hmuVtuEdWfzOtTXeOaNP
question_key_val_ass_arrey[a8c31e3f7961b8b95e18d82301fb4d2b5c690400]=eCyJbkBmBalZjVwwIvQr
question_key_val_ass_arrey[06b0007ad50ff95d2ba09848ff1ed6a33e43eda6]=JrpCGDYhXAWpfnVQFeWy
question_key_val_ass_arrey[9a93d3a5a2b4397da1a5f2b167f940c97904b92a]=SkiKfQIpJtWHdyVRrCKb
question_key_val_ass_arrey[d6a917fb448bd7ca10ca850ad1b20cffc118ba07]=dlMktXuReJPfrROmzRrQ
question_key_val_ass_arrey[4047943314354fd4af9421490ed86b85a82531a9]=HdAYCSEDLgqwYUxNrwdl
question_key_val_ass_arrey[5e0d0cbc0d2b6efc8cbf6ddb5c926bff07f2c618]=mYZQMCajBtufeoLMJLer
question_key_val_ass_arrey[ba0927d3422b8535423444f19c6e36b9eb7857ea]=oDVjGjniNLlCtPtGJfmO
question_key_val_ass_arrey[30b3b320eb7fc7c9f415d94ef2d3e22163be3f07]=LCkVUWBPJXIkMhxZmXnC
question_key_val_ass_arrey[cbc411888e60cf4191ad448302e577001a9115f1]=LzSRjJTCRNAMolZICZhU
question_key_val_ass_arrey[5e52d4e053ed7dabf9660c2a86321805e7bd40f6]=JsaDzHjUdpgKDQuaAany
question_key_val_ass_arrey[f606a8d0e6e3442d04b5eec751e397ac5487b68b]=JRgRAnKTvOoBsVwcVock
question_key_val_ass_arrey[6405940a4f0d7fe30023918bcdceefe8970afec4]=xlTEAHJyIdkYxkvbItGm
question_key_val_ass_arrey[ccb711f9b540f7ebb448f65725c1659d95b53655]=EYhPCMuIGJdeigxuljne
question_key_val_ass_arrey[65ba2c7bece39f3eb08d5cf5a7700d8433dbe63b]=DzVudyhHhHKByIKHMnyu
question_key_val_ass_arrey[f4fdba0cae0a81edd62e12bb3675d1174995c266]=HIAVhXctcmJWtEbsdjyj
question_key_val_ass_arrey[6f742e913025fa5da7748980a9bc851c1339a453]=IPCRaXjlWkhfcrdMGyFm
question_key_val_ass_arrey[bd3d83e1793afd4f7755690622dccb526df238d4]=OvmQQBAjHzAIoajHroir
question_key_val_ass_arrey[1de1da13d7cf0d3206f26e99e1def8cf7d622d3e]=WZpKtDuoshnfvegLfsFx
question_key_val_ass_arrey[5351ba373b890a9cbb55fd94ab327ebf565d0ee6]=LsgiZuasfCexIhtXWaMU
question_key_val_ass_arrey[3813659d643045f282498f0b79a54ceaf86df4b9]=AtMIkiYkIlcQmQeYBXOB
question_key_val_ass_arrey[a290368697fdd96d480f1a22a333a16f05866c5c]=QBhzplCNJxphxwvdwnjD
question_key_val_ass_arrey[b5c77199d8540cc76873372fbac42736ec3eaa3d]=HgZsymDyyUUPrxLDtxdg
question_key_val_ass_arrey[41a32a5f23b10b4259aa1f885609f10ce7f6bcf8]=zMtCTIeRCAKgJtXjoBAh
question_key_val_ass_arrey[579f248ed662c6446f9e966d2149dc1200f1a3c9]=zmTebBpDtGwuDBSiQUwg
question_key_val_ass_arrey[7df450a5b7613ffeb42a13fb4ef2823e1ab9ce04]=AIEtpQnZJFTCafJYmDOy
question_key_val_ass_arrey[0ada2bab8be325ef4e18de05933ca57136a56b96]=LUriSdGwGhddPABcvYuS
question_key_val_ass_arrey[e0e0239f7a29ece00e221782635694ebe28cdd93]=KScHmEpFUuviahOaZYYM
question_key_val_ass_arrey[1ff6eb4152a41ab2b5b12c147651b5c1ab1adbc4]=jCZdPnhestMNDYqHaMDb
question_key_val_ass_arrey[b9d52de7687c953bae0ba7de8b520fd27110bb73]=WAVLOgxLxnrRsIBOTEQZ
question_key_val_ass_arrey[deea9d80922fb4d98b9b5999456f2946474ea799]=BxDbVRlxFoDGeNlAzVor
question_key_val_ass_arrey[3bdcefbdfd8c29d08525a8ff46b5b466515c937d]=oSbJJpyySTPprLLvlgws
question_key_val_ass_arrey[01f71f5525e88957f8b081f57152e8a2f410e9d3]=afivosRIXcQXTztgjvVw
question_key_val_ass_arrey[16ca2494ef685a41fe00b44b33df6c7624be2f52]=IHkVGrbXMCUpHDrIlTLG
question_key_val_ass_arrey[c9a1b13a0aa1d0e58244dbc344b01e5b53cf85fd]=sEPNpWrspwIZHYPbxZWS
question_key_val_ass_arrey[c5ac1569ce87796ae60601151bfc513e44484974]=kXrHzHzEhihwPyfYeoQd
question_key_val_ass_arrey[f494b54850d1a5f87c4e4ab4563ed6d85c5d5285]=JmrqCKkJfYSlpCLQpkHy
question_key_val_ass_arrey[9bbe56f2b739cb71ac4eecdc520d657fa4c0867b]=NHYNjNARTLlyXDltxfBg
question_key_val_ass_arrey[4bd8683a10d0e0964d672a717811b91f06327b61]=UXBBMIeTPqHOqOQupfXU
question_key_val_ass_arrey[d71b9bf55c801ae27bf144e370518a233ad32987]=guZIJwVuxCNLswazuWBm
question_key_val_ass_arrey[19459f364694623c5ad4c3235cba22828d99a539]=aRKVVVpqVLoKNAaevZHs
question_key_val_ass_arrey[090e1bf09a50d0de0616ab9e93d6ac4eff5629dc]=mXuMDAIFhBFngpzAWEnM
question_key_val_ass_arrey[14c49a06e6a60ced4c779870ff0d18688db355dd]=aDeRIMuCujUfLFDfsNnn
question_key_val_ass_arrey[f8dea0e091d21449e67bb91d935c7be2d474036c]=pRVSmHrPYCtaPsBfKYsH
question_key_val_ass_arrey[3fd2385c39cf4848e69f4c123712910060063473]=WDhAhMFKSVHsNQLQrdxU
question_key_val_ass_arrey[e79fc0830d0c70aaf9c23298f56650ae94ff437d]=bAQcyatFbSxWWsDqrYIJ
question_key_val_ass_arrey[4af8bc0309c3e5bf46aac4b4e7ddbce6ad7bad7b]=xdGZmZitaTCgLHjEzGtw
question_key_val_ass_arrey[e9d82f0c0cc05af1cbd6a0d8882cd2fa2b2a8364]=yMMwkFGlJYCbXdxCtmPa
question_key_val_ass_arrey[32db6e3683faaa0bc953331ad0932647712e0340]=PUKoxklgidZpiZoVHJYZ
question_key_val_ass_arrey[0d357c5312f46519019c631a2ab702067a1543d2]=umGyXtslWpSWsfWMeddG
question_key_val_ass_arrey[bb684c89db5365aa5b2997f55c5b7e1e6e900441]=PkhGrLuzFjPYQDldmkhn
question_key_val_ass_arrey[99886d87cc379454ee4f93f5c7ce836feb7be14e]=UVfwnrlHOofGjpWiNtFN
question_key_val_ass_arrey[03fc5ce5435d5dd8356ddb6897a241feb94512ff]=HwjrIRPMGQcdIFrXlWVw
question_key_val_ass_arrey[78aa2377b3e16b6437855b135d6f4bb7a9abfabc]=FFQssPapxMeqcPiDwhqM
question_key_val_ass_arrey[4623ca428fdfaea49653a2f8d63c4d34b9b33877]=VlbddwkDJpKMADGecvLK
question_key_val_ass_arrey[42e62037fff8dc3b3f94307dbc6b0994c1b0be9a]=nwkjKycMsiFqZWQKNswo
question_key_val_ass_arrey[c4b9f5b4a0d9cfba7f82d0aad03f0a0a0c7c456c]=POMYLKGbPBMAsSPdKBlp
#--------------------------------------------------------------------------------------------------#

function get_key_for_gpg_file_function {
    local  key_name=$1
    echo ${question_key_val_ass_arrey[$key_name]} 
}

#--------------------------------------------------------------------------------------------------#
_decrypt_question_file_function ()
{

# question_file="${question_dir}"/."${i}"
question_file="${selected_exam_path}/.${question_file_only_name}"
if [[ -f $question_file_loop_var ]]; then
    #statements
    [[ -f "${question_file}" ]] && rm -rf "${question_file}" >>  /dev/null 2>&1 

    # shellcheck disable=SC2086
    gpg --batch --output "${question_file}"  --passphrase $key_for_the_question  --decrypt "${question_file_loop_var}" >>  /dev/null 2>&1 

else 
    warn_msg "encrypted_question_file: $question_file_loop_var no present. Exiting"
    exit 1 
fi

}
#--------------------------------------------------------------------------------------------------#
_check_valid_input_option ()
{

RESET="\033[0m"
BOLD="\033[5m"
YELLOW="\033[38;5;11m"
# read -p "$(echo -e $BOLD$YELLOW"foo bar "$RESET)" INPUT_VARIABLE

magenta "Case insensitive : Please Select only valid Option: Valid Options are A|B|C|D "
draw_line_function
# shellcheck disable=SC2086,SC2162
read -p "$(echo -e $BOLD$YELLOW"Please input your answer option : "$RESET)" sltd_ans
# read -p "Please input your answer option:" sltd_ans
draw_line_function
sltd_ans=${sltd_ans,}
local correct_selection=false

if [[ $sltd_ans == "a" || $sltd_ans == "b" || $sltd_ans == "c" || $sltd_ans == "d"  ]]; then
    #statements
    green "You have Entered valid Option: $sltd_ans" 
    question_completed_count=$((question_completed_count+1))
else 
    error_msg "You have Enter a wrong option: $sltd_ans" 
    draw_line_function 
    _check_valid_input_option
fi

}
#--------------------------------------------------------------------------------------------------#
_correct_answer_funtion ()
{
    draw_line_function "=" magenta 
    printf "\033[32;5mHurry: You have Selected Correct Answer\033[0m\n"
    # yellow "Hurry: You have Selected Correct Answer"
    draw_line_function "=" magenta 
    green "Explanation: ==>"
    draw_line_function
    sed -n '7p' "$question_file"
    draw_line_function
    # declare -i chapter_correct_answer_count
    chapter_correct_answer_count=$((chapter_correct_answer_count+1))
    # question_complted=$((question_complted+1)) 
    draw_line_function "#" magenta
    # Question_no:Answer 
    # echo "_ans_file:$_ans_file"
    echo "$question_file_only_name:Correct:$sltd_ans:$correct_ans:$userid_exam:$doname_Seleted:$question_completed_count:$chapter_correct_answer_count:${chapter_incorrect_answer_count:-0}:$total_question_for_chapter_count" >> "${_user_exam_report_record_loop_file}"
    wait
    # 
    echo 
    # shellcheck disable=SC2086
    read -t $wait_timeout_after_answer -n 1 -s -r -p "Press any key to continue $wait_timeout_after_answer Second Timeout"
    echo 
}
#--------------------------------------------------------------------------------------------------#
_incorrect_answer_funtion ()
{
    draw_line_function "=" magenta 
     printf "\033[31;5mOOPS: You have Selected INCorrect Answer\033[0m\n"
    # red "OOPS: You have Selected INCorrect Answer"
    draw_line_function "=" magenta 
    green "Correct Answer : $correct_ans"
    draw_line_function - magenta 
    green "Explanation: ==>"
    draw_line_function
    sed -n '7p' "$question_file"
    draw_line_function
    draw_line_function - magenta
    # declare -i chapter_incorrect_answer_count
    chapter_incorrect_answer_count=$((chapter_incorrect_answer_count+1))
    # question_complted=$((question_complted+1)) 
    draw_line_function "#" magenta
    # echo "_ans_file:$_ans_file"
    # Question_no:Answer 
    echo "$question_file_only_name:Wrong:$sltd_ans:$correct_ans:$userid_exam:$doname_Seleted:$question_completed_count:${chapter_correct_answer_count:-0}:$chapter_incorrect_answer_count:$total_question_for_chapter_count" >> "${_user_exam_report_record_loop_file}"
    wait
    # 
    echo 
    read -t $wait_timeout_after_answer -n 1 -s -r -p "Press any key to continue $wait_timeout_after_answer Second Timeout"
    echo 
}
#--------------------------------------------------------------------------------------------------#
__check_end_of_chpter_loop ()
{
    EndLoop_Keywork
    if [[ ${file}  == "EndLoop_Keywork" ]]; then
        #statements
        info_msg "You have attempted to all question in Chapter"
        draw_line_function
        info_msg "Starting again .."
        # 
        _check_and_start_exam_function
    fi
}
# 
#--------------------------------------------------------------------------------------------------#
_run_fresh_exam_for_user ()
{
# echo "selected_exam_path: $selected_exam_path"
# declare count_of_total_question_at_selected_exam_dir=$( find "$selected_exam_path" -name "*.gpg" -type f 2>/dev/null | wc -l )
# 
if [[ -d $selected_exam_path ]]; then
    #statements
    # 
    # shellcheck disable=SC2164
    cd "$selected_exam_path"
    # 
    # starting exam counter with 0 
    declare -i question_completed_count=0
    # shellcheck disable=SC2013
    for file in $(cat "${_user_total_question_dbloop_file}"); do
        # find "$selected_exam_path" -name "*.gpg" -type f | while read question_file_loop_var  ; do 
        __check_end_of_chpter_loop
        # 
        question_file_loop_var=$(realpath "$file")
        # 
        local question_file
        question_file=$(basename "$question_file_loop_var")
        question_file_only_name="${question_file%.gpg}"
        # 
        # info_msg "question_file: $question_file question_file_only_name:$question_file_only_name"
        # shellcheck disable=SC2086
        key_for_the_question=$(get_key_for_gpg_file_function $question_file_only_name)
        # 
        # info_msg "question_file_only_name: $question_file_only_name key_for_the_question:$key_for_the_question"
        if [[ -n $key_for_the_question ]]; then
            #statements
            _decrypt_question_file_function
            # 
            info_msg "question_file: $question_file"
            # cat $question_file
            # sleep 5

            if [[ -f "$question_file" ]]; then
                #statements
                clear 
                # 
                _header_window_creation
                # 
                draw_line_function "="  yellow  
                # 
                awk -v a="$question_completed_count" 'NR == 1 {printf "%s) \x1b[45;1m%s\x1b[0m\n",a,$0 }' "$question_file"
                # awk 'NR == 1 {printf "\x1b[45;1m%s\x1b[0m\n", $0 }'  "$question_file"
                draw_line_function "="  yellow
                # 
                blue "Option ) Information"
                for (( a = 2; a <= 5; a++ )); do
                    #statements
                    # shellcheck disable=SC2086
                    awk -v  num=$a '{if(NR==num) print " " $0 }' "$question_file" 
                done
                # echo ""
                draw_line_function
                _check_valid_input_option
                # 
                correct_ans=$(sed -n '6p;s@\s*@@g' "$question_file")
                # shellcheck disable=SC2053
                if [[  $correct_ans == ${sltd_ans^^} ]]; then
                    #statements
                     _correct_answer_funtion
                else
                    _incorrect_answer_funtion   
                fi
                draw_line_function "="  yellow  
                _remove_question_file
                _calculate_remaining_question_function
                # 
            else 
                warn_msg "question_file $question_file not exist. Exiting with code 11 "
                exit 11    
            fi 
            # 
            # 
        else 
           error_msg "Unable to get key for the question_file_only_name:$question_file_only_name"    
        fi
        # 
        # 
    done
    # 
    # 
else 
    warn_msg "selected_exam_path $selected_exam_path not exist"
    __get_chapter_name
    _run_fresh_exam_for_user
    # 
fi
# 
# 
}
#--------------------------------------------------------------------------------------------------#
_run_resume_exam_for_user ()
{
# echo "selected_exam_path: $selected_exam_path"
# declare count_of_total_question_at_selected_exam_dir=$( find "$selected_exam_path" -name "*.gpg" -type f 2>/dev/null | wc -l )
# 
question_completed_count=$(cut -d ':' -f 7 "${_user_exam_report_record_loop_file}" | tail -n 1 )
chapter_correct_answer_count=$(cut -d ':' -f 8 "${_user_exam_report_record_loop_file}" | tail -n 1 )
chapter_incorrect_answer_count=$(cut -d ':' -f 9 "${_user_exam_report_record_loop_file}"| tail -n 1 )
total_question_for_chapter_count=$(cut -d ':' -f 10 "${_user_exam_report_record_loop_file}" | tail -n 1 )
chapter_name_only_dir=$(cut -d ':' -f 6 "${_user_exam_report_record_loop_file}" | tail -n 1 )
# 
selected_exam_path="${_question_assets_dir}/${chapter_name_only_dir}"
# echo "question_completed_count:$question_completed_count chapter_correct_answer_count:$chapter_correct_answer_count chapter_incorrect_answer_count:$chapter_incorrect_answer_count total_question_in_chapter:$total_question_for_chapter_count"
# 
if [[ -d $selected_exam_path ]]; then
    # shellcheck disable=SC2164
    cd "$selected_exam_path"

    # shellcheck disable=SC2013
    for file in $(cat "${_user_total_question_dbloop_file}"); do
        # find "$selected_exam_path" -name "*.gpg" -type f | while read question_file_loop_var  ; do 
        __check_end_of_chpter_loop
        # 
        question_file_loop_var=$(realpath "$file")
        # 
        local question_file
        question_file=$(basename "$question_file_loop_var")
        question_file_only_name="${question_file%.gpg}"
        # 
        # info_msg "question_file: $question_file question_file_only_name:$question_file_only_name"
        # shellcheck disable=SC2086
        key_for_the_question=$(get_key_for_gpg_file_function $question_file_only_name)
        # 
        # info_msg "question_file_only_name: $question_file_only_name key_for_the_question:$key_for_the_question"
        if [[ -n $key_for_the_question ]]; then
            #statements
            _decrypt_question_file_function
            # 
            info_msg "question_file: $question_file"
            # cat $question_file
            # sleep 5
            # 
            if [[ -f "$question_file" ]]; then
                #statements
                clear 
                # 
                _header_window_creation
                # 
                draw_line_function "="  yellow  
                # 
                awk -v a="$question_completed_count" 'NR == 1 {printf "%s) \x1b[45;1m%s\x1b[0m\n",a,$0 }' "$question_file"
                # 
                draw_line_function "="  yellow
                # 
                blue "Option ) Information"
                for (( a = 2; a <= 5; a++ )); do
                    #statements
                    # shellcheck disable=SC2086
                    awk -v  num=$a '{if(NR==num) print " " $0 }' "$question_file" 
                done
                # echo ""
                draw_line_function
                _check_valid_input_option
                # 
                correct_ans=$(sed -n '6p;s@\s*@@g' "$question_file")
                # shellcheck disable=SC2053
                if [[  $correct_ans == ${sltd_ans^^} ]]; then
                    #statements
                     _correct_answer_funtion
                else
                    _incorrect_answer_funtion   
                fi
                draw_line_function "="  yellow  
                _remove_question_file
                _calculate_remaining_question_function
                # 
            else 
                warn_msg "question_file $question_file not exist. Exiting with code 11 "
                exit 11    
            fi 
            # 
            # 
        else 
           error_msg "Unable to get key for the question_file_only_name:$question_file_only_name"    
        fi
        # 
        # 
    done
    # 
    # 
else 
    warn_msg "selected_exam_path $selected_exam_path not exist"
#     __get_chapter_name
#     _run_fresh_exam_for_user

fi
# 
# 
}
#--------------------------------------------------------------------------------------------------#
promptyn () {
    while true; do
        # shellcheck disable=SC2162
        read -p "$1 " yn
        case $yn in
            [Yy]* ) return 0;;
            [Nn]* ) return 1;;
            * ) echo "Please answer yes or no.";;
        esac
    done
}
#--------------------------------------------------------------------------------------------------#
_run_yes_no_choise_prompt ()
{
   # info_msg "User ${userid_exam} record found. Do you want resume? " 
if promptyn "DO you want to resume the last exam ? Enter only yes or no : "; then
    echo "yes"
    _user_choice_resume=1
    _run_resume_exam_for_user
else
    echo "no"
    _user_choice_resume=0
    draw_line_function
    info_msg "Starting fresh session for user: $userid_exam"
    draw_line_function
    __check_tests_before_and_start_fresh_exam_function
fi
}
#--------------------------------------------------------------------------------------------------#
_header_window_creation ()
{
 # chapter_name_without_space="${doname_Seleted//_/ }"   
 draw_line_function 
 newLine=false
 printf "\x1b[33;1;5m%s\x1b[0m" "${__utility_name_header}" 
 white " | " 
 magenta " ${__developer_credit}"
 white " | "
 white "Utility Version: "
 newLine=true
 green "${__utility_version}"
 draw_line_function 
 newLine=false
 white "Mail: santosh.kulkarni4u@gmail.com | " 
 newLine=true
 red " Mobile: +91 99xxxxxx64"
 draw_line_function "="
 newLine=false
 yellow "Total Questions in Chapter: "
 red "${total_question_for_chapter_count}"
 white " | "
 green "Total Questions in Exam: "
 newLine=true
 magenta "1000"
 draw_line_function "="
 newLine=false
 magenta "Questions Completed:"
 green " ${question_completed_count:-0} "
 white " | "
 magenta "Correct Answers: "
 green " ${chapter_correct_answer_count:-0}"
 echo -n  " | "
magenta "  Incorrect Answers: "
newLine=true
green "${chapter_incorrect_answer_count:-0}"
draw_line_function "="
newLine=false
magenta "Current Exam Chapter : "
green  "${chapter_name_without_space}"
 white " | " 
magenta "  User : "
newLine=true
green "${userid_exam}"
# 
# draw_line_function "="
 # echo "chap_password:$chap_password"
 # draw_line_function "="
}
#--------------------------------------------------------------------------------------------------#
#--------------------------------------------------------------------------------------------------#
_remove_question_file ()
{
[[ -f "${question_file}" ]] && rm -f "${question_file}" >>  /dev/null 2>&1
}
#--------------------------------------------------------------------------------------------------#
_calculate_remaining_question_function ()
{
echo "${file}" >> "${_user_completed_question_dbloop_file}"

awk 'NR==FNR{a[$0]++;next} !a[$0] ' "${_user_completed_question_dbloop_file}"  "${_user_total_question_dbloop_file}" > "${_user_remaining_question_dbloop_file}"
}
#--------------------------------------------------------------------------------------------------#
############################# Global Function  Section Ended #######################################
#--------------------------------------------------------------------------------------------------#
#--------------------------------------------------------------------------------------------------#
#
#
#
#==================================================================================================#
# Running Script : Script Body section started  
#==================================================================================================#
# ----------------------------------------------------

_question_assets_dir="$script_dir/._question_assets_dir"
# Clearing Runcontrl_dir dir if exist
user_session_dir="${script_dir}/.user_session"
#sleep 10
wait_timeout_after_answer=10
# __get_chapter_name
# Utility Name 
# CompTIA Linux Plus MCQ 1000 Question
__utility_name_header="CompTIA Linux Plus MCQ 1000 Questions"
# CompTIA Linux Plus MCQ 1000 Questions
# User Credit header
__developer_credit="By Santosh Kulkarni"
# utility version
__utility_version="2.11.26"
# 
_get_email_id_from_user
#
_check_for_fresh_or_resume_exam_function
# _run_fresh_exam_for_user
#==================================================================================================#
# Running Script : Script Body section Ended  
#==================================================================================================#
# 

# for k in "${!question_key_val_ass_arrey[@]}"
# do
#   printf "%s\n" "$k=${array[$k]}"
# done


