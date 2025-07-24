#!/data/data/com.termux/files/usr/bin/env bash

# ANSI Colors
BOLD="\033[1m"
RESET="\033[0m"
YELLOW="\033[33m"
ORANGE="\033[38;5;208m"
BLUE="\033[34m"
GREEN="\033[32m"
RED="\033[31m"

if ! command -v depotdownloader >/dev/null 2>&1; then
    echo -e "${RED}Error:${RESET} DepotDownloader is required but not found.\nPlease install it as mentioned in README and try again."
    exit 1
fi

# language
LANG_CHOICE="${1:-pt}"

if [[ "$LANG_CHOICE" == "en" ]]; then
    source english.sh
else
    source brazilian.sh
fi


while true; do
    commands=()
    back_to_main=false

    clear
    echo
    echo "$LANG_TITLE"
    echo
    echo "1) $LANG_MAIN_OPTION_ALL"
    echo "2) $LANG_MAIN_OPTION_MANUAL"
    echo -e "${RED}3) $LANG_MAIN_OPTION_EXIT${RESET}"
    echo
    read -p "$LANG_PROMPT_CHOOSE" main_menu

    if [[ "$main_menu" == "3" ]]; then
        echo "${RED}$LANG_EXITING${RESET}"
        exit 0
    fi

    # Functions
    add_goldsrc_pre25() {
        commands+=(
            "-branch steam_legacy -app 70  -depot 1   -dir goldsrc_old" # Half-Life
            "-app 130 -depot 130 -dir goldsrc_old" # Half-Life: Blue Shift
            "-app 50  -depot 51  -dir goldsrc_old" # Half-Life: Opposing Force
            "-branch steam_legacy -app 10  -depot 11  -dir goldsrc_old" # Counter-Strike
            "-branch steam_legacy -app 20  -depot 21  -dir goldsrc_old" # Team Fortress Classic
        )
    }

    add_goldsrc_25() {
        commands+=(
            "-app 70  -depot 1   -dir goldsrc" # Half-Life
            "-app 130 -depot 130 -dir goldsrc" # Half-Life: Blue Shift
            "-app 50  -depot 51  -dir goldsrc" # Half-Life: Opposing Force
            "-app 10  -depot 11  -dir goldsrc" # Counter-Strike
            "-app 20  -depot 21  -dir goldsrc" # Team Fortress Classic
        )
    }

    add_source() {
        commands+=(
            "-branch steam_legacy -app 220 -depot 221 -dir source" # Half-Life 2
            "-branch steam_legacy -app 220 -depot 389 -dir source" # Half-Life 2: Episode 1
            "-branch steam_legacy -app 220 -depot 380 -dir source" # Half-Life 2: Episode 1 (maps)
            "-branch steam_legacy -app 220 -depot 420 -dir source" # Half-Life 2: Episode 2
            "-branch steam_legacy -app 320 -depot 321 -dir source" # Half-Life 2: Deathmatch
            "-app 280 -depot 280 -dir source" # Half-Life: Source
            "-branch previous_build -app 240 -depot 241 -dir source" # Counter-Strike: Source
            "-branch previous_build -app 300 -depot 301 -dir source" # Day of Defeat: Source
            "-app 400 -depot 401 -dir source" # Portal
        )
    }

    if [[ "$main_menu" == "1" ]]; then
        clear
        echo
        echo "$LANG_DOWNLOADS_OPTION_ALL_TITLE"
        echo
        echo "1) $LANG_MAIN_OPTION_ALL"
        echo "2) $LANG_DOWNLOADS_OPTION_ALL_SOURCE"
        echo "3) $LANG_DOWNLOADS_OPTION_ALL_GOLDSRC"
        echo -e "${RED}b) $LANG_OPTION_BACK${RESET}"
        echo "============================"
        read -p "$LANG_PROMPT_CHOOSE" all_option

        if [[ "$all_option" == "b" ]]; then
            continue
        fi

        if [[ "$all_option" == "1" || "$all_option" == "3" ]]; then
            clear
            echo
            echo "$LANG_GOLDSRCVERSION_TITLE"
            echo
            echo "1) $LANG_GOLDSRCVERSION_OPTION_25TH"
            echo -e "${YELLOW}$LANG_WARNING_NEW_VERSION${RESET}"
            echo "2) $LANG_GOLDSRCVERSION_OPTION_PRE25TH"
            echo -e "${YELLOW}$LANG_WARNING_OLD_VERSION${RESET}"
            echo "3) $LANG_OPTION_BOTH"
            echo -e "${RED}b) $LANG_OPTION_BACK${RESET}"
            echo "============================"
            read -p "$LANG_PROMPT_CHOOSE" goldsrc_version

            if [[ "$goldsrc_version" == "b" ]]; then
                continue
            fi

            [[ "$goldsrc_version" == "1" || "$goldsrc_version" == "3" ]] && add_goldsrc_25
            [[ "$goldsrc_version" == "2" || "$goldsrc_version" == "3" ]] && add_goldsrc_pre25
        fi

        [[ "$all_option" == "1" || "$all_option" == "2" ]] && add_source

    elif [[ "$main_menu" == "2" ]]; then
        while true; do
            clear
            echo
            echo "$LANG_GAMES_TITLE"
            echo
            echo -e "${BOLD}$LANG_GAMES_TITLE_SOURCE${RESET}"
            echo -e "${ORANGE}1) Half-Life 2${RESET}"
            echo -e "${ORANGE}2) Half-Life 2: Episode 1${RESET}"
            echo -e "${ORANGE}3) Half-Life 2: Episode 2${RESET}"
            echo -e "${ORANGE}4) Half-Life 2: Deathmatch${RESET}"
            echo -e "${ORANGE}5) Half-Life: Source${RESET}"
            echo "6) Counter-Strike: Source"
            echo "7) Day of Defeat: Source"
            echo -e "${BLUE}8) Portal${RESET}"
            echo
            echo -e "${BOLD}$LANG_GAMES_TITLE_GOLDSRC${RESET}"
            echo -e "${ORANGE}9) Half-Life${RESET}"
            echo -e "${BLUE}10) Half-Life: Blue Shift${RESET}"
            echo -e "${GREEN}11) Half-Life: Opposing Force${RESET}"
            echo "12) Counter-Strike"
            echo -e "${YELLOW}13) Team Fortress Classic${RESET}"
            echo -e "${RED}b) $LANG_OPTION_BACK${RESET}"
            echo "============================"
            read -p "$LANG_PROMPT_CHOOSE_GAMES" selections

            if [[ "$selections" == "b" ]]; then
                back_to_main=true
                break
            fi

            IFS=',' read -ra choices <<< "$selections"
            goldsrc_choices=()

            for choice in "${choices[@]}"; do
                case "$choice" in
                    1) commands+=("-branch steam_legacy -app 220 -depot 221 -dir source") ;; # Half-Life 2
                    2) 
                    commands+=("-branch steam_legacy -app 220 -depot 389 -dir source") # Half-Life 2: Episode 1
                    commands+=("-branch steam_legacy -app 220 -depot 380 -dir source") # Half-Life 2: Episode 1 (maps)
                    ;;
                    3) commands+=("-branch steam_legacy -app 220 -depot 420 -dir source") ;; # Half-Life 2: Episode 2
                    4) commands+=("-branch steam_legacy -app 320 -depot 321 -dir source") ;; # Half-Life 2: Deathmatch
                    5) commands+=("-app 280 -depot 280 -dir source") ;; # Half-Life: Source
                    6) commands+=("-branch previous_build -app 240 -depot 241 -dir source ") ;; # Counter-Strike: Source
                    7) commands+=("-branch previous_build -app 300 -depot 301 -dir source") ;; # Day of Defeat: Source
                    8) commands+=("-app 400 -depot 401 -dir source") ;; # Portal
                    9|10|11|12|13) goldsrc_choices+=("$choice") ;; # Goldsrc games
                esac
            done

            if [[ "${#goldsrc_choices[@]}" -gt 0 ]]; then
                while true; do
                    clear
                    echo
                    echo "$LANG_GOLDSRCVERSION_TITLE"
                    echo
                    echo "1) $LANG_GOLDSRCVERSION_OPTION_25TH"
                    echo -e "${YELLOW}$LANG_WARNING_NEW_VERSION${RESET}"
                    echo "2) $LANG_GOLDSRCVERSION_OPTION_PRE25TH"
                    echo -e "${YELLOW}$LANG_WARNING_OLD_VERSION${RESET}"
                    echo "3) $LANG_OPTION_BOTH"
                    echo -e "${RED}b) $LANG_OPTION_BACK${RESET}"
                    echo "============================"
                    read -p "$LANG_PROMPT_CHOOSE" manual_version

                    if [[ "$manual_version" == "b" ]]; then
                        back_to_main=true
                        break
                    fi

                    for choice in "${goldsrc_choices[@]}"; do
                        if [[ "$manual_version" == "1" || "$manual_version" == "3" ]]; then
                            case "$choice" in
                                9)  commands+=("-app 70  -depot 1   -dir goldsrc") ;; # Half-Life
                                10) commands+=("-app 130 -depot 130 -dir goldsrc") ;; # Half-Life: Blue Shift
                                11) commands+=("-app 50  -depot 51  -dir goldsrc") ;; # Half-Life: Opposing Force
                                12) commands+=("-app 10  -depot 11  -dir goldsrc") ;; # Counter-Strike
                                13) commands+=("-app 20  -depot 21  -dir goldsrc") ;; # Team Fortress Classic
                            esac
                        fi
                        if [[ "$manual_version" == "2" || "$manual_version" == "3" ]]; then
                            case "$choice" in
                                9)  commands+=("-branch steam_legacy -app 70  -depot 1   -dir goldsrc_old") ;; # Half-Life
                                10) commands+=("-app 130 -depot 130 -dir goldsrc_old") ;; # Half-Life: Blue Shift
                                11) commands+=("-app 50  -depot 51  -dir goldsrc_old") ;; # Half-Life: Opposing Force
                                12) commands+=("-branch steam_legacy -app 10  -depot 11  -dir goldsrc_old") ;; # Counter-Strike
                                13) commands+=("-branch steam_legacy -app 20  -depot 21  -dir goldsrc_old") ;; # Team Fortress Classic
                            esac
                        fi
                    done
                    break
                done
            fi

            if $back_to_main; then
                break
            fi

            if [[ "${#commands[@]}" -eq 0 ]]; then
                echo -e "${RED}$LANG_NO_GAMES${RESET}"
                sleep 2
                back_to_main=true
                break
            fi

            break
        done

        if $back_to_main; then
            continue
        fi

    else
        echo "${RED}$LANG_INVALID_OPTION${RESET}"
        sleep 2
        continue
    fi

    if [[ "${#commands[@]}" -eq 0 ]]; then
        echo -e "${RED}$LANG_NO_COMMANDS${RESET}"
        sleep 2
        continue
    fi

    # Request for login
    echo
    read -p "$LANG_ENTER_USERNAME" username
    echo -n "$LANG_ENTER_PASSWORD"
    password=""
    while IFS= read -r -s -n1 char; do
        if [[ -z "$char" ]]; then
            echo
            break
        fi
        if [[ "$char" == $'\x7f' ]]; then
            password="${password%?}"
            echo -ne "\b \b"
        else
            password+="$char"
            echo -n "*"
        fi
    done

    base_command="depotdownloader -username $username -password '$password' -remember-password -validate"

    echo
    for args in "${commands[@]}"; do
        echo -e "${BOLD}Running:${RESET} $base_command $args"
        eval "$base_command $args" || {
            echo -e "${RED}$LANG_COMMANDS_ABOVE${RESET}"
            exit 1
        }
    done

    read -p "$LANG_PRESS_ENTER" _
done
