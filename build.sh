#!/usr/bin/env bash 

#########################################
set -x
set -o errexit
set -o pipefail
#created by: Silent-Mobius aka Alex M. Schapelle for Vaiolabs ltd.
#purpose: build script for jetporch class
#verion: 0.8.11
#########################################

. /etc/os-release

PROJECT="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
WORKDIR="$PROJECT/out"
THEME="${PROJECT}/99_misc/.theme/"
BUILD_DIR_ARRAY=($(ls $PROJECT|grep -vE '99_*|README.md|LICENSE|TODO.md|build.sh|presentation.md|presentation.html|presentation.pdf|out|spell.txt'))
BUILD_TOOL=$(which darkslide)
BUILD_TOOL_VERSION=$(darkslide --version|awk '{print $2}')
DEPENDENCY_ARRAY=(python3-darkslide python3-landslide weasyprint) # single crucial point of failure for multi-type environments (Linux-Distro's,MacOS)
SEPERATOR='-------------------------------------------'
SPELLCHECK=$(which codespell)
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
    get_build_tool
    
    while getopts "bcht" opt
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
            t)  
               deco '[+] Checking Spelling'
                for folder in 0[0-9]_*;
                    do 
                        codespell -I spell.txt $folder/README.md 
                    done            
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

function get_build_tool(){
    if [[ -n $BUILD_TOOL ]];then
        BUILD_TOOL=$(which darkslide)
        BUILD_TOOL_VERSION=$($BUILD_TOOL --version | awk '{print $2}')
        if [[ $BUILD_TOOL_VERSION == '6.0.0' ]];then
            deco '
    [!] Newer build tool detected [!]
    [+] Downgrade to version 5.1.0 for build to work 
    [+] Or use docker branch to build inside docker 
    [+] Link to package: http://ftp.de.debian.org/debian/pool/main/p/python-darkslide/darkslide_5.1.0-1_all.deb
    [+] In case package not avaible on that address check on : https://pkgs.org
            '
            exit 1
        fi
    elif ! which landslide &> $NULL ;then
        BUILD_TOOL=$(which landslide)
    else
        deco '[+] Dependency Missing: Trying To Fix   '
        for dep in "${DEPENDENCY_ARRAY[@]}"
            do
                printf "\n%s \n " "[+] Trying To Install:  $dep"
                if ! sudo "${INSTALLER}" install -y "${dep}" 1>&2 2>&1 $NULL;then
                    deco '[!] Install Failed [!] ' \
                         '[+] Please Contact Instructor   '
                    exit 1
                fi
            done
        if which darkslide &> $NULL;then
            BUILD_TOOL=$(which darkslide)
        elif ! which darkslide &> $NULL ;then
            BUILD_TOOL=$(which landslide)
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
            ${BUILD_TOOL} -v  -t $THEME -x fenced_code,codehilite,extra,toc,smarty,sane_lists,meta,tables $IN -d $OUT
        elif [[ $ID == 'fedora' ]] || [[ $ID == 'rocky' ]];then
            ${BUILD_TOOL} -v  -t $THEME -x fenced_code,codehilite,extra,toc,smarty,sane_lists,meta,tables $IN -d $OUT
        else
            ${BUILD_TOOL} -v  -t $THEME -x fenced_code,codehilite,extra,toc,smarty,sane_lists,meta,md_in_html,tables $IN -d $OUT
        fi
}

function convert_html_to_pdf(){
    IN=$1
    OUT=$2
    # SED operation is required on darkslide version 6.0.0 + use older version of tool or user docker branch for making your life easier
    # sed -i 's#<link rel="stylesheet" href="file:///usr/lib/python3/dist-packages/darkslide/themes/default/css/base.css">##' $IN
    # sed -i 's#<link rel="stylesheet" href="file:///usr/lib/python3/dist-packages/darkslide/themes/default/css/theme.css">##' $IN
        weasyprint -v  $IN $OUT
}

function spell_check(){
    IN=$1
        $SPELLCHECK --ignore-words spell.txt $IN
    }

#######
# Main
#######
main "$@"

# TODO - build script: wrap up in docker
#
