#!/usr/bin/env bash 
# set -x
#########################################
#created by Silent-Mobius
#purpose: build script for jenkins class
#verion: 0.4.18
#########################################

. /etc/os-release

PROJECT="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
BUILD_DIR_ARRAY=($(ls |grep -vE '99_*|README.md|TODO.md|build.sh|LICENSE'))
BUILDER=${get_builder:-'/usr/bin/darkslide'}
SEPERATOR='-------------------------------------------'


main(){
    if [[ ${#} -le 0 ]];then
        _help
    fi

        get_installer
    
    while getopts "bch" opt
    do
        case $opt in
            b)  seek_all_md_files
                convert_data
                ;;
            c) clean_up
                ;;
            h) _help
                ;;
            *) _help
                ;;
        esac
    done

}

function _help() {
    printf "\n%s \n%s \n%s\n " "[?] Incorrect use" "[?] Please use $0 \"-b\" for build and \"-c\" for clean up"  "[?] example: $0 -c"
}

function clean_up() {
    printf "\n%s \n%s \n%s\n " "$SEPERATOR" '[+] Cleaning Up The Previous Builds' "$SEPERATOR"
    if [ -e $PROJECT/build.md ];then
      rm -rf $PROJECT/build.md
    fi

    if [ -e $PROJECT/presentation.html ];then
        rm -rf $PROJECT/presentation.html
    fi
    
    if [ -e $PROJECT/presentation.pdf ];then
        rm -rf $PROJECT/presentation.pdf
    fi
    find . -name presentation.html -exec rm {} \;
    printf "\n%s \n%s \n%s\n " "$SEPERATOR" '[+] Cleanup Ended Successfully   ' "$SEPERATOR"
}

function get_installer(){
    if [[ ${ID,,} == 'debian' ]] || [[ ${ID,,} == 'debian' ]] || [[ ${ID,,} == 'linuxmint' ]];then
        export INSTALLER=apt-get
    elif [[ ${ID,,} == 'RedHat' ]] || [[ ${ID,,} == 'fedora' ]] || [[ ${ID,,} == 'rocky' ]];then
        export INSTALLER=yum
    else  
        clear
        printf "\n%s \n%s \n%s\n " "$SEPERATOR" '[!] OS Not Supported [!]   ' "$SEPERATOR"
        sleep 2
        printf "\n%s \n%s \n%s\n " "$SEPERATOR" '[+] Please Contact Instructor   ' "$SEPERATOR"
        sleep 2
        exit 1
    fi
}

function get_builder(){
    if [[ -e /usr/bin/darkslide ]];then
        echo '/usr/bin/darkslide'
    elif [[ -e /usr/bin/landslide ]];then
        echo '/usr/bin/landslide'
    else
        printf "\n%s \n%s \n%s\n " "$SEPERATOR" '[+] Dependency Missing: Trying To Fix   ' "$SEPERATOR"
        
        if sudo ${INSTALLER} install -y python3-landslide darkslide &> /dev/null;then   
                printf "\n%s \n%s \n%s\n " "$SEPERATOR" '[+] Install Ended Successfully   ' "$SEPERATOR"
                    if [[ -e /usr/bin/darkslide ]];then
                        echo '/usr/bin/darkslide'
                    elif [[ -e /usr/bin/landslide ]];then
                        echo '/usr/bin/landslide'
                    fi
        else
            printf "\n%s \n%s \n%s\n " "$SEPERATOR" '[!] Install Failed [!]   ' "$SEPERATOR"
            printf "\n%s \n%s \n%s\n " "$SEPERATOR" '[+] Please Contact Instructor   ' "$SEPERATOR"
            exit 1
        fi
    fi

}

function seek_all_md_files() {
    clean_up
    printf "\n%s \n%s \n%s\n " "$SEPERATOR" '[+] Building Presentation' "$SEPERATOR"
    find "${BUILD_DIR_ARRAY[@]}" -name '*.md'|sort|xargs cat > build.md 2> /dev/null

    printf "\n%s \n%s \n%s\n " "$SEPERATOR"  '[+] Generate ended successfully  '  "$SEPERATOR"
}

function convert_data() {
    printf "\n%s \n%s \n%s\n " "$SEPERATOR" '[+] Converting Data     ' "$SEPERATOR"
        if [[ $ID == 'ubuntu' ]] || [[ $ID == 'linuxmint' ]];then # there is a bug on ubuntu and linuxmint ubuntu based distro - not using regular darkslide
            ${BUILDER} -v  -t ${PROJECT}/99_misc/.theme/ -x fenced_code,codehilite,extra,toc,smarty,sane_lists,meta,tables build.md
        else
            ${BUILDER} -v  -t ${PROJECT}/99_misc/.theme/ -x fenced_code,codehilite,extra,toc,smarty,sane_lists,meta,md_in_html,tables build.md
        fi
}



#######
# Main
#######
main "$@"