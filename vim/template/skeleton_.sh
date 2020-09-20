# Absolute path to this script, e.g. /home/user/Pwngdb/install.sh
SCRIPT=$(readlink -f "$0")
# Absolute path this script is in, thus /home/user/Pwngdb
SCRIPTLOCATION=$(dirname "$SCRIPT")

# option parser
while [[ ! $# -eq 0 ]]; do
    key="$1"
    shift
    case $key in
        -a|--option-a)
            OPTIONA="$1"
            shift
            ;;
        -b|--option-b)
            OPTIONB="$1"
            shift
            ;;
        -c|--option-c)
            OPTIONC="$1"
            shift
            ;;
        *)
            if [[ $FILE != "" ]]; then
                echo "unknown option \"$FILE\""
                exit 1
            fi
            FILE="$key"
            ;;
    esac
done
echo "OPTIONA = ${OPTIONA}"
echo "OPTIONB = ${OPTIONB}"
echo "OPTIONC = ${OPTIONC}"
echo "FILE    = ${FILE}"

