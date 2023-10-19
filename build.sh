#!/usr/bin/env bash 

#########################################
set -x
set -o errexit
set -o pipefail
#created by: Silent-Mobius aka Alex M. Schapelle for Vaiolabs ltd.
#purpose: build script for jetporch class
#verion: 0.7.9
#########################################

. /etc/os-release

PROJECT="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
WORKDIR="$PROJECT/out"
THEME="${PROJECT}/99_misc/.theme/"
BUILD_DIR_ARRAY=($(ls $PROJECT|grep -vE '99_*|README.md|LICENSE|TODO.md|build.sh|presentation.md|presentation.html|presentation.pdf'))
BUILDER=$(which darkslide)
DEPENDENCY_ARRAY=(python3-darkslide python3-landslide weasyprint) # single crucial point of failure for multi-type environments (Linux-Distro's,MacOS)
SEPERATOR='-------------------------------------------'
NULL=/dev/null


main(){
    if [[ ${#} -le 0 ]];then
        _help
    fi
    if [[ ! -d $WORKDIR ]];then
        mkdir -p $WORKDIR
        for _dir in "${BUILD_DIR_ARRAY[@]}"
            do 
                ln -s "$PROJECT/$_dir" "$WORKDIR/$_dir"
            done
    fi
    
    BUILD_WORKDIR_ARRAY=($(ls $WORKDIR|grep -vE '99_*|README.md|TODO.md|build.sh|presentation.md|presentation.html|presentation.pdf'))
    
    # get_installer
    get_builder
    
    while getopts "bch" opt
    do
        case $opt in
            b)
                deco  '[+] Cleaning Up The Previous Builds' 
                    clean_up  
                deco '[+] Building presentation' 
                    seek_all_md_files "$WORKDIR/presentation.md"
                deco '[+] Converting Data     ' 
                    convert_data "$WORKDIR/presentation.md" "$WORKDIR/presentation.html"
                deco '[+] Converting HTML to PDF     ' 
                    convert_html_to_pdf "$WORKDIR/presentation.html" "$WORKDIR/presentation.pdf"
                ;;
            c) 
                deco  '[+] Cleaning Up The Previous Builds' 
                    clean_up
                ;;
            h) _help
                    exit 1
                ;;
            *) _help
                ;;
        esac
    done

}

function deco(){
    IN="$*"
    printf "\n%s \n%s \n%s\n " \
             "$SEPERATOR" \
             "$IN"        \
             "$SEPERATOR"
}

function _help() {
    deco "[?] Incorrect use" \
         "[?] Please use $0 \"-b\" for build and \"-c\" for clean up"  \
         "[?] example: $0 -c"
}

function clean_up() {
    if find "${BUILD_WORKDIR_ARRAY[@]}" -type f \( -name "presentation.*" -o -name "build.md" -o -name "out" \) &> $NULL ;then
         find "${BUILD_WORKDIR_ARRAY[@]}" -type f \( -name "presentation.*" -o -name "build.md" -o -name "out" \) -exec rm {} \;
    fi
    # rm -rf $WORKDIR
    deco '[+] Cleanup Ended Successfully   '
}

function get_installer(){
    if [[ $ID == 'debian' ]] || [[ $ID == 'ubnutu' ]] || [[ $ID == 'linuxmint' ]];then
         INSTALLER=apt-get
    elif [[ $ID == 'redhat' ]] || [[ $ID == 'fedora' ]] || [[ $ID == 'rocky' ]];then
         INSTALLER=yum
    else  
        deco '[!] OS Not Supported [!]' \
             '[+] Please Contact Instructor   '
    fi
}

function get_builder(){
    if [[ -n $BUILDER ]];then
        BUILDER=$(which darkslide)
    elif ! which darkslide &> $NULL ;then
        BUILDER=$(which landslide)
    else
        deco '[+] Dependency Missing: Trying To Fix   '
        for dep in "${DEPENDENCY_ARRAY[@]}"
            do
                printf "\n%s \n " "[+] Trying To Install:  $dep"
                if ! sudo "${INSTALLER}" install -y "${dep}" &> /dev/null;then
                    deco '[!] Install Failed [!] ' \
                         '[+] Please Contact Instructor   '
                    exit 1
                fi
            done
        if which darkslide &> $NULL;then
            BUILDER=$(which darkslide)
        elif ! which darkslide &> $NULL ;then
            BUILDER=$(which landslide)
        fi
    fi

}

function seek_all_md_files() {
    IN=$1
    find "${BUILD_WORKDIR_ARRAY[@]}" -name '*.md' | sort|xargs cat > $IN 2> $NULL

}

function convert_data() {
    IN=$1
    OUT=$2
        if [[ $ID == 'ubuntu' ]] || [[ $ID == 'linuxmint' ]];then
            ${BUILDER} -v  -t $THEME -x fenced_code,codehilite,extra,toc,smarty,sane_lists,meta,tables $IN -d $OUT
        elif [[ $ID == 'fedora' ]] || [[ $ID == 'rocky' ]];then
            ${BUILDER} -v  -t $THEME -x fenced_code,codehilite,extra,toc,smarty,sane_lists,meta,tables $IN -d $OUT
        else
            ${BUILDER} -v  -t $THEME -x fenced_code,codehilite,extra,toc,smarty,sane_lists,meta,md_in_html,tables $IN -d $OUT
        fi
}

function convert_html_to_pdf(){
    IN=$1
    OUT=$2
    sed -i 's#<link rel="stylesheet" href="file:///usr/lib/python3/dist-packages/darkslide/themes/default/css/base.css">##' $IN
    sed -i 's#<link rel="stylesheet" href="file:///usr/lib/python3/dist-packages/darkslide/themes/default/css/theme.css">##' $IN
        weasyprint -v  $IN $OUT
}

#######
# Main
#######
main "$@"

# TODO - build script: wrap up in docker
