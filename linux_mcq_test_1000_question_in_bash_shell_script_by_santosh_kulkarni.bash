#!/bin/bash
#Title          : run_linux_test.bash
#Description    :       
#Author         : Santosh Kulkarni
#Date           : 12-Sep-2022 12-48
#Version        :       
#Usage          : ./run_linux_test.bash
#Notes:                 
#Tested on Bash Version: 4.2.46(2)-release
#Mail ID:       santosh.kulkarni4u@gmail.com
# 
# shellcheck disable=SC2034
utility_version="2.11.20"
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
Runcontrl_dir="/tmp/$utility_name_space_removed"
# 
LOCKFILE="/tmp/lock_${scriptName_space_removed}"
# 

trap "rm -f ${LOCKFILE}; exit" INT TERM EXIT

#--------------------------------------------------------------------------------------------------#
#--------------------------------------------------------------------------------------------------#
# UNComment Following line if Standard Error STDERR and Standard  output  STDRR is thrown on following Line 
# exec >log_${date_and_time_stamp}.txt 2>&1
#--------------------------------------------------------------------------------------------------#
############################### Global Array Declaration Section Started ###########################
#--------------------------------------------------------------------------------------------------#
# Declare packages you want to check before running the script.
# Use below function to check the packages 
# check_binary_with_check_packges_before_arrey_function "check_packges_before_arrey" or  "package name to check"
declare -a check_packges_before_arrey=( sudo  gpg awk sed  bash read mkdir date basename readlink realpath )
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
    draw_line_function "=" green 
    warn_msg "Control -c or SIGINT or one of the following signal received for the process"
    warn_msg "SIGHUP or SIGFPE "
    warn_msg "SIGKILL or SIGTERM "
    # shellcheck disable=SC2283
    draw_line_function "=" green 
    pidof_shell_session=$( cat "$LOCKFILE" ) 




    [[ -f "${LOCKFILE}"  ]] && rm -f "${LOCKFILE}"
    # shellcheck disable=SC2086
    # if ps -p $pidof_shell_session  2>&1 /dev/null ; then
        #statements
        kill -9  $pidof_shell_session
    # fi
    # tput cnorm
    exit 255 
}
#--------------------------------------------------------------------------------------------------#
function trap_exit () { 

    info_msg "Exiting script "
    [[ -f "${LOCKFILE}"  ]] && rm -f "${LOCKFILE}"
    # find -not -name "*.gpg
    # 
    exit 
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

# 
#--------------------------------------------------------------------------------------------------#

#--------------------------------------------------------------------------------------------------#

# 
#--------------------------------------------------------------------------------------------------#
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
            exit 100
        else
            error_msg "Missing dependency: $1"
            error_msg "Install $1 package to  continue with MCQ exam. Exiting"
            draw_line_function - white 50
            exit 100
            # return 1
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
# draw_line_function "=" cyan
# draw_line_function "=" white 50 
}
# 
#--------------------------------------------------------------------------------------------------#

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

#--------------------------------------------------------------------------------------------------#
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
printf "%2s | %s %s\n" "NO" "Chapter Name (Choose Chapter Number)"
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
#--------------------------------------------------------------------------------------------------#
promptyn () {
    while true; do
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
    __get_chapter_name
    _run_fresh_exam_for_user
fi
}

#--------------------------------------------------------------------------------------------------#
_clean_user_name_function () {
    local a=${1//[^[:alnum:]]/}
    echo "${a,,}"
}
#--------------------------------------------------------------------------------------------------#

#--------------------------------------------------------------------------------------------------#
# Linux Multi Choice Knowledge EXAM
# "Linux Knowledge MCQ 1000 Questions L3+"
_get_email_id_from_user ()
{

    draw_line_function 
    newLine=false
    yellow "Linux MCQ Test 1000 Questions created in Bash Shell Script" 
    white " | " 
    magenta "Created and compiled by Santosh Kulkarni"
    white " | "
    white "Utility Version: "
    newLine=true
    green "$utility_version"
    # 
    draw_line_function 
    green "Please Enter user name without spaces to begin or resume Linux MCQ Test 1000"
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
    user_session_dir="${script_dir}/.user_session" 
    _ans_file="${user_session_dir}/${userid_exam}/_ans_file"
    _full_userid_record_path_dir="${user_session_dir}/${userid_exam}"
    # 
    if [[ -d  ${_full_userid_record_path_dir} ]]; then
        #statements
        draw_line_function
        green "Exam record found for user ${userid_exam} found."
        draw_line_function
        _run_yes_no_choise_prompt
    else
            mkdir -p "${_full_userid_record_path_dir}/"
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
            draw_line_function -
            info_msg "Welcome  $userid_exam for Linux MCQ in Bash Shell"
            info_msg "Creating fresh session for user : $userid_exam "
            draw_line_function -
            # info_msg "_ans_file : $_ans_file"
            __get_chapter_name
            _run_fresh_exam_for_user
            # _run_yes_no_choise_prompt
    fi
    draw_line_function
}
#--------------------------------------------------------------------------------------------------#
#--------------------------------------------------------------------------------------------------#
_check_valid_input_option ()
{

RESET="\033[0m"
BOLD="\033[5m"
YELLOW="\033[38;5;11m"
# read -p "$(echo -e $BOLD$YELLOW"foo bar "$RESET)" INPUT_VARIABLE

magenta "Case insensitive : Please Select only valid Option: Valid Options are A|B|C|D "
draw_line_function
read -p "$(echo -e $BOLD$YELLOW"Please input your answer option : "$RESET)" sltd_ans
# read -p "Please input your answer option:" sltd_ans
draw_line_function
sltd_ans=${sltd_ans,}
local correct_selection=false

if [[ $sltd_ans == "a" || $sltd_ans == "b" || $sltd_ans == "c" || $sltd_ans == "d"  ]]; then
    #statements
    green "You have Entered valid Option: $sltd_ans" 
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
    chapter_correct_answer=$((chapter_correct_answer+1))
    question_complted=$((question_complted+1)) 
    draw_line_function "#" magenta
    # Question_no:Answer 
    # echo "_ans_file:$_ans_file"
    echo "$i:Correct:$sltd_ans:$correct_ans:$selected_exam_path:$doname_Seleted:$question_complted" >> "$_ans_file"
    # 
    echo 
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
    chapter_incorrect_answer=$((chapter_incorrect_answer+1))
    question_complted=$((question_complted+1)) 
    draw_line_function "#" magenta
    # echo "_ans_file:$_ans_file"
    # Question_no:Answer 
    echo "$i:Wrong:$sltd_ans:$correct_ans:$selected_exam_path:$doname_Seleted:$question_complted" >> "$_ans_file"
    # 
    echo 
    read -t $wait_timeout_after_answer -n 1 -s -r -p "Press any key to continue $wait_timeout_after_answer Second Timeout"
    echo 
}
#--------------------------------------------------------------------------------------------------#
_header_window_creation ()
{
 chapter_name_without_space="${doname_Seleted//_/ }"   
 draw_line_function 
 newLine=false
 yellow "Linux MCQ Test 1000 Questions in Bash Shell Script"  #"Linux Multi Choice Knowledge EXAM" 
 white " | " 
 magenta " Created by Santosh Kulkarni"
 white " | "
 white "Utility Version: "
 newLine=true
 green "$utility_version"
 draw_line_function 
 newLine=false
 white "Mail: santosh.kulkarni4u@gmail.com | " 
 newLine=true
 red " Mobile: 99xxxx8564"
 draw_line_function "="
 newLine=false
 yellow "Total Questions in Chapter: "
 red "$total_question_in_chapter"
 white " | "
 green "Total Questions in Exam: "
 newLine=true
 magenta "1000"
 draw_line_function "="
 newLine=false
 magenta "Questions Completed:"
 green " $question_complted "
 white " | "
 magenta "Correct Answers: "
 green " $chapter_correct_answer "
 echo -n  " | "
magenta "  Incorrect Answers: "
newLine=true
green "$chapter_incorrect_answer"
draw_line_function "="
newLine=false
magenta "Current Exam Chapter : "
green  "$chapter_name_without_space"
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
_decrypt_question_file ()
{

question_file="${question_dir}"/."${i}"
encrypted_question_file="${question_dir}/${i}.gpg"
if [[ -f $encrypted_question_file ]]; then
    #statements
    [[ -f "${question_file}" ]] && rm -rf "${question_file}" >>  /dev/null 2>&1 

    # shellcheck disable=SC2086
    gpg --batch --output "${question_file}"  --passphrase $chap_password  --decrypt "${encrypted_question_file}" >>  /dev/null 2>&1 

else 
    warn_msg "encrypted_question_file: $encrypted_question_file no present. Exiting"
    exit 1 
fi

}
#--------------------------------------------------------------------------------------------------#
#--------------------------------------------------------------------------------------------------#
_remove_question_file ()
{
[[ -f "${question_file}" ]] && rm -f "${question_file}" >>  /dev/null 2>&1
}
#--------------------------------------------------------------------------------------------------#
get_total_question_count_in_exam ()
{ 

# Practice_Exam_102_Questions
# Scripting_Containers_and_Automation_171_Questions
# System_Management_286_Questions
# System_Operations_and_Maintenance_189_Questions
# System_Troubleshooting_252_Questions

selected_exam_dir_name=$(basename  "$selected_exam_path" )

case $selected_exam_dir_name  in
    # 
    Practice_Exam_102_Questions )  total_question_in_chapter=102 ;;
    Scripting_Containers_and_Automation_171_Questions )  total_question_in_chapter=171 ;;
    System_Management_286_Questions )  total_question_in_chapter=286 ;;
    System_Operations_and_Maintenance_189_Questions )  total_question_in_chapter=189 ;;
    System_Troubleshooting_252_Questions )  total_question_in_chapter=252 ;;

esac
magenta "$selected_exam_dir_name has $total_question_in_chapter questions"
}
#--------------------------------------------------------------------------------------------------#

_run_fresh_exam_for_user () 
{

if [[ -d $selected_exam_path ]]; then
    #statements
    echo "selected_exam_path:$selected_exam_path"
    get_total_question_count_in_exam
    # total_question_in_chapter=$(( $(stat -c %h "$selected_exam_path") -2 ))
    # total_question_in_chapter=$( ls -l "$selected_exam_path" | wc -l )
    # echo "selected_exam_path:$selected_exam_path | total_question_in_chapter:$total_question_in_chapter"

    _get_key_for_chapter
    local chapter_correct_answer=0
    local chapter_incorrect_answer=0
    for (( i = 1; i < total_question_in_chapter; i++ )); do
        #statements
        question_dir=$(realpath "${selected_exam_path}")
        if [[ -d  $question_dir  ]]; then
            # encrypted_question_file="${question_dir}/${i}.gpg"
            _decrypt_question_file
            # question_file="${question_dir}/${i}.txt"
            #statements
            if [[ -f "$question_file" ]]; then
                #statements
                clear 
                _header_window_creation
                draw_line_function "="  yellow  
                awk 'NR == 1 {printf "\x1b[45;1m%s\x1b[0m\n", $0 }'  "$question_file"
                # awk 'NR == 1 {printf "\x1b[45;1;5m%s\x1b[0m\n", $0 }' "$question_file"
                # awk 'NR == 1 {printf "\x1b[1;32m%s\x1b[0m\n", $0 }' "$question_file"
                # sed -n '1p' "$question_file" 
                draw_line_function "="  yellow
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

            else 
                warn_msg "question_file $question_file not exist. Exiting with code 11 "
                exit 11    
            fi    
            
        else 
            warn_msg "question_dir $question_dir not exist. Exiting with code 10 "
            exit 10    
        fi
    done
    draw_line_function
    info_msg "All Question in selected chapter completed."
    draw_line_function
    __get_chapter_name

else 
    warn_msg "selected_exam_path $selected_exam_path not exist"
    __get_chapter_name
    _run_fresh_exam_for_user

fi
}
# 
#--------------------------------------------------------------------------------------------------#
_get_key_for_chapter ()
{

# Practice_Exam_102_Questions
# Scripting_Containers_and_Automation_171_Questions
# System_Management_286_Questions
# System_Operations_and_Maintenance_189_Questions
# System_Troubleshooting_252_Questions


#  System_Management_286_Questions_pass="vN/rr8auXmFEvRUIbehVm7CtGo4V0jLkDJ5qEr9ARuw="
#  System_Operations_and_Maintenance_189_Questions="nAW5sd9X8qbfs4EuGWAYn/wHuWOF5SyYXWRcmto2zzY="
#  Scripting_Containers_and_Automation_171_Questions="MbCtdyMtTXOgDvJSE+CpF+SsEIDEgmXHvYbhXcgfnNA="
#  System_Troubleshooting_252_Questions="KJm8ARxcosEpleKXSBwDYLS4+ZkathbE7mxWXgZ+T7Q="
#  Practice_Exam_102_Questions="Q5FvPyYmUy3H2/0UPnp5rsclfaAt064SjHHN+6mWA10="

if [[ $doname_Seleted == "System_Management_286_Questions" ]]; then
    chap_password="vN/rr8auXmFEvRUIbehVm7CtGo4V0jLkDJ5qEr9ARuw="
elif [[ $doname_Seleted == "System_Operations_and_Maintenance_189_Questions" ]]; then
    chap_password="nAW5sd9X8qbfs4EuGWAYn/wHuWOF5SyYXWRcmto2zzY="
elif [[ $doname_Seleted == "Scripting_Containers_and_Automation_171_Questions" ]]; then
    chap_password="MbCtdyMtTXOgDvJSE+CpF+SsEIDEgmXHvYbhXcgfnNA="
elif [[ $doname_Seleted == "System_Troubleshooting_252_Questions" ]]; then
    chap_password="KJm8ARxcosEpleKXSBwDYLS4+ZkathbE7mxWXgZ+T7Q="
elif [[ $doname_Seleted == "Practice_Exam_102_Questions" ]]; then
    chap_password="Q5FvPyYmUy3H2/0UPnp5rsclfaAt064SjHHN+6mWA10="
else 
    #statements
    error_msg "Key not available for this exam $doname_Seleted"
fi
}
#--------------------------------------------------------------------------------------------------#
#--------------------------------------------------------------------------------------------------#
_run_resume_exam_for_user() 
{

# 70:Wrong:d:B
# 71:Correct:c:C

if [[ -f "${_ans_file}" ]]; then

        local chapter_correct_answer=$( grep -i ":Correct:"    "${_ans_file}"  | wc -l )
        local chapter_incorrect_answer=$( grep -i ":Wrong:"   "${_ans_file}"  | wc -l )
        declare -i last_resume_question=$(tail -n 1 "${_ans_file}"  | cut -f 1 -d ":")
        declare  selected_exam_path=$(tail -n 1 "${_ans_file}" | cut -f 5 -d ":" | sed 's@ @\\ @g')
        declare  doname_Seleted=$(tail -n 1 "${_ans_file}"  | cut -f 6 -d ":" )
        declare  question_complted=$(tail -n 1 "${_ans_file}" | cut -f 1 -d ":" )
        last_resume_question=$((last_resume_question+1))
    #statements
    if [[ -d $selected_exam_path ]]; then
        #statements
        get_total_question_count_in_exam
        # total_question_in_chapter=$(( $(stat -c %h "$selected_exam_path") -2 ))
        # total_question_in_chapter=$( ls -l "$selected_exam_path" | wc -l )
        # echo "selected_exam_path:$selected_exam_path | total_question_in_chapter:$total_question_in_chapter"
        for (( i = ${last_resume_question}; i < total_question_in_chapter; i++ )); do
            #statements
            question_dir=$(realpath "${selected_exam_path}")
            _get_key_for_chapter
            if [[ -d  $question_dir  ]]; then
                _decrypt_question_file
                # question_file="${question_dir}/${i}.txt"
                #statements
                if [[ -f "$question_file" ]]; then
                    #statements
                    clear 
                    _header_window_creation
                    draw_line_function "="  yellow  
                    # awk 'NR == 1 {printf "\x1b[31m%s\x1b[0m\n", $0 }' "$question_file"
                    # awk 'NR == 1 {printf "\x1b[45;1;5m%s\x1b[0m\n", $0 }' "$question_file"
                     # 
                     awk 'NR == 1 {printf "\x1b[45;1m%s\x1b[0m\n", $0 }'  "$question_file"
                    draw_line_function "="  yellow
                    blue "Option ) Information"
                    for (( a = 2; a <= 5; a++ )); do
                        #statements
                        # shellcheck disable=SC2086
                        awk -v  num=$a '{if(NR==num) print " " $0 }' "$question_file" 
                    done
                    draw_line_function
                    # echo ""
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

                else 
                    warn_msg "question_file $question_file not exist. Exiting with code 11 "
                    exit 11    
                fi    
                
            else 
                warn_msg "question_dir $question_dir not exist. Exiting with code 10 "
                exit 10    
            fi
        done
        draw_line_function
        info_msg "All Question in selected chapter completed."
        draw_line_function
        __get_chapter_name

    else 
        warn_msg "selected_exam_path $selected_exam_path not exist"
        __get_chapter_name

    fi

    warn_msg "$_ans_file not found starting fresh exam"
    _run_fresh_exam_for_user
else 
    info_msg "No valid exam record found for user. Starting fresh session for user"
    _run_fresh_exam_for_user    
fi
}
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
# # ----------------------------------------------------
# # 
# # Trap control mechanism to cleanup the shell after execution 
# # =====================================
trap trap_SIGINT_Cntrl_C_signal_function  SIGHUP SIGINT SIGQUIT  SIGFPE  SIGTERM
trap trap_exit EXIT
# # =====================================
# # Configuration file mechanism added 

#
wait_timeout_after_answer=10
# _ans_file="$Temp_dir/${userid_exam}/._ans_file"
#==================================================================================================#
# Running Script : Script Body section Ended  
#==================================================================================================#
# checking required package before run
yellow "Checking dependency for Linux MCQ test exam script"
draw_line_function 

check_binary_with_check_packges_before_arrey_function 
# 
# 
# sleep 2 
clear
# 
__new_create_directors_function "$Temp_dir"
# 
_question_assets_dir="$script_dir/.question_assets"
# info_msg "_question_assets_dir : $_question_assets_dir"
# info_msg "script_dir: $script_dir"
# getting userid from user to get 
_get_email_id_from_user

# _run_exam_path


