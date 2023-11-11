#!/usr/bin/env bash 
###################################################
# Created by: Silent-Mobius Aka Alex M. Schapelle
# Purpose: validate yaml files
# Version: 0.1.0
# Date: 10.10.2023
#
NULL=/dev/null

function validate_yaml(){
    IN=$1
    python3 -c "import yaml,pprint;pprint.pprint(yaml.load(open('$IN').read(), Loader=yaml.FullLoader))"

}

function main(){
    IN="$@"
    if which python3 > $NULL 2>&1;then
        #python3 -c 'try:    import yaml;except Exception as e:    print(f"#"*100,"\n# ","Error Occured: \n {e}")'
        
        validate_yaml "$IN"
    else
        echo "Python missing"
        exit 1
    fi
    }

########
# Main  - _ - _ - _ - _ - _ - _ - _ - _ - _ - _ - _ - _ - _ - _ - _ - _ - _ - _ - _ 
########
main "$@"
