#!/usr/bin/env bash 

#########################################
# created by Silent-Mobius
# purpose: build script for docker class
# verion: 0.7.6
set -x
set -o errexit
set -o pipefail
#########################################

. /etc/os-release

PROJECT="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
WORKDIR="$PROJECT/out"
THEME="${PROJECT}/99_misc/.theme/"
STYLE="fenced_code,codehilite,extra,toc,smarty,sane_lists,meta,md_in_html,tables"
BUILD_DIR_ARRAY=($(ls $PROJECT|grep -vE '99_*|README.md|LICENSE|TODO.md|build.sh|presentation.*'))
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
        for _dir in ${BUILD_DIR_ARRAY[@]}
            do 
                ln -s "$PROJECT/$_dir" "$WORKDIR/$_dir"
            done
    fi
    
    BUILD_WORKDIR_ARRAY=($(ls $WORKDIR|grep -vE '99_*|README.md|TODO.md|build.sh|presentation.*'))
    
    get_installer
    get_builder
    
    while getopts "bch" opt
    do
        case $opt in
            b|-build)
                clean_up  
                seek_all_md_files
                convert_md_to_html "$WORKDIR/presentation.md" "$WORKDIR/presentation.html"
                verify_html_convert_theme "$WORKDIR/presentation.html"
                convert_html_to_pdf "$WORKDIR/presentation.html" "$WORKDIR/presentation.pdf"
                ;;
            c|-clean) clean_up
                ;;
            h|-help) _help
                ;;
            *) _help
                ;;
        esac
    done

}

function _help() {
    printf "\n%s \n%s \n%s\n " "[?] Incorrect use" \
    "[?] Please use $0 \"-b\" for build and \"-c\" for clean up"  \
    "[?] example: $0 -c"
}

function clean_up() {
    printf "\n%s \n%s \n%s\n " "$SEPERATOR" '[+] Cleaning Up The Previous Builds' "$SEPERATOR"
    if find ${BUILD_WORKDIR_ARRAY[@]} -type f \( -name "presentation.*" -o -name "presentation.md" -o -name "out" \) &> $NULL ;then
         find ${BUILD_WORKDIR_ARRAY[@]} -type f \( -name "presentation.*" -o -name "presentation.md" -o -name "out" \) -exec rm {} \;
    fi
    # rm -rf $WORKDIR
    printf "\n%s \n%s \n%s\n " "$SEPERATOR" '[+] Cleanup Ended Successfully   ' "$SEPERATOR"
}

function get_installer(){
    if [[ $ID == 'debian' ]] || [[ $ID == 'debian' ]] || [[ $ID == 'linuxmint' ]];then
         INSTALLER=apt-get
    elif [[ $ID == 'redhat' ]] || [[ $ID == 'fedora' ]] || [[ $ID == 'rocky' ]];then
         INSTALLER=yum
    else  
        printf "\n%s \n%s \n%s\n \n%s \n%s \n%s\n" \
        "$SEPERATOR" '[!] OS Not Supported [!]   ' "$SEPERATOR" \
        "$SEPERATOR" '[+] Please Contact Instructor   ' "$SEPERATOR"
    fi
}

function get_builder(){
    if [[ -n $BUILDER ]];then
        BUILDER=$(which darkslide)
    elif ! which darkslide &> $NULL ;then
        BUILDER=$(which landslide)
    else
        printf "\n%s \n%s \n%s\n " "$SEPERATOR" '[+] Dependency Missing: Trying To Fix   ' "$SEPERATOR"
        for dep in ${DEPENDENCY_ARRAY[@]}
            do
                printf "\n%s \n " "[+] Trying To Install:  $dep"
                if ! sudo ${INSTALLER} install -y ${dep} &> /dev/null;then
                    printf "\n%s \n%s \n%s\n %s\n" "$SEPERATOR" \
                                                        '[!] Install Failed [!] ' \
                                                        '[+] Please Contact Instructor   ' \
                                                        "$SEPERATOR"
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
    printf "\n%s \n%s \n%s\n " "$SEPERATOR" '[+] Building presentation' "$SEPERATOR"
    find ${BUILD_WORKDIR_ARRAY[@]} -name '*.md' | sort|xargs cat > ${WORKDIR}/presentation.md 2> /dev/null

    printf "\n%s \n%s \n%s\n " "$SEPERATOR"  '[+] Generate ended successfully  '  "$SEPERATOR"
}

function convert_md_to_html() {
    IN=$1
    OUT=$2
    printf "\n%s \n%s \n%s\n " "$SEPERATOR" '[+] Converting MD to HTML    ' "$SEPERATOR"
        if [[ $ID == 'ubuntu' ]] || [[ $ID == 'linuxmint' ]];then
            ${BUILDER} -v  -t $THEME -x fenced_code,codehilite,extra,toc,smarty,sane_lists,meta,tables $IN -d $OUT
        elif [[ $ID == 'fedora' ]] || [[ $ID == 'rocky' ]];then
            ${BUILDER} -v  -t $THEME -x fenced_code,codehilite,extra,toc,smarty,sane_lists,meta,tables $IN -d $OUT
        else
            ${BUILDER} -v  -t $THEME -x $STYLE $IN -d $OUT
        fi
}

function verify_html_convert_theme(){
    IN=$1
    if grep '<link rel="stylesheet" href="file:///usr/lib/python3/dist-packages/darkslide/themes/default/css/base.css">' $IN;
    then
        sed -i 's#<link rel="stylesheet" href="file:///usr/lib/python3/dist-packages/darkslide/themes/default/css/base.css">##' $IN
    fi
   
    if grep '<link rel="stylesheet" media="all" href="file:///usr/lib/python3/dist-packages/darkslide/themes/default/css/theme.css">' $IN;
    then
        sed -i 's#<link rel="stylesheet" media="all" href="file:///usr/lib/python3/dist-packages/darkslide/themes/default/css/theme.css">##' $IN
    fi
}

function convert_html_to_pdf(){
    IN=$1
    OUT=$2
    printf "\n%s \n%s \n%s\n " "$SEPERATOR" '[+] Converting HTML to PDF     ' "$SEPERATOR"
        weasyprint $IN $OUT
}

#######
# Main  - _ - _ - _ - _ - _ - _ - _ Do Not Remove _ - _ - _ - _ - _ - _ - _ - _ - _ - _ 
#######
main "$@"

# TODO - build script: fix dependency use
