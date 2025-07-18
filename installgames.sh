#!/bin/bash

# ANSI Colors
BOLD="\033[1m"
RESET="\033[0m"
YELLOW="\033[33m"
ORANGE="\033[38;5;208m"
BLUE="\033[34m"
GREEN="\033[32m"
RED="\033[31m"

while true; do
    commands=()
    back_to_main=false

    clear
    echo
    echo "Which games do you want to download?"
    echo
    echo "1) All games"
    echo "2) Select manually"
    echo -e "${RED}3) Exit${RESET}"
    echo
    read -p "Choose an option (1-3): " main_menu

    if [[ "$main_menu" == "3" ]]; then
        echo "Exiting..."
        exit 0
    fi

    # Functions
    add_goldsrc_pre25() {
        commands+=(
            "-branch steam_legacy -app 70  -depot 1   -dir goldsrc_old"
            "-branch steam_legacy -app 130 -depot 130 -dir goldsrc_old"
            "-branch steam_legacy -app 50  -depot 51  -dir goldsrc_old"
            "-branch steam_legacy -app 10  -depot 11  -dir goldsrc_old"
            "-branch steam_legacy -app 20  -depot 21  -dir goldsrc_old"
        )
    }

    add_goldsrc_25() {
        commands+=(
            "-app 70  -depot 1   -dir goldsrc"
            "-app 130 -depot 130 -dir goldsrc"
            "-app 50  -depot 51  -dir goldsrc"
            "-app 10  -depot 11  -dir goldsrc"
            "-app 20  -depot 21  -dir goldsrc"
        )
    }

    add_source() {
        commands+=(
            "-app 220 -depot 221 -dir source"
            "-app 220 -depot 389 -dir source"
            "-app 220 -depot 380 -dir source"
            "-app 220 -depot 420 -dir source"
            "-branch previous_build -app 240 -depot 241 -dir source"
        )
    }

    if [[ "$main_menu" == "1" ]]; then
        clear
        echo
        echo "Which games do you want to download?"
        echo
        echo "1) All games"
        echo "2) All Source games"
        echo "3) All Goldsrc games"
        echo -e "${RED}b) Back${RESET}"
        echo "============================"
        read -p "Choose an option (1-3): " all_option

        if [[ "$all_option" == "b" ]]; then
            continue
        fi

        if [[ "$all_option" == "1" || "$all_option" == "3" ]]; then
            clear
            echo
            echo "Which version of the Goldsrc games do you want?"
            echo
            echo "1) 25th Anniversary version"
            echo -e "${YELLOW}! Warning: Newer version, better for Xash3D-FWGS (New engine)${RESET}"
            echo "2) Pre-25th Anniversary version"
            echo -e "${YELLOW}! Warning: Older version, better for mods and Xash3D (Old engine)${RESET}"
            echo "3) Both"
            echo -e "${RED}b) Back${RESET}"
            echo "============================"
            read -p "Choose an option (1-3): " goldsrc_version

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
            echo "Which games do you want to download?"
            echo
            echo -e "${BOLD}Source Games:${RESET}"
            echo -e "${ORANGE}1) Half-Life 2${RESET}"
            echo -e "${ORANGE}2) Half-Life 2: Episode 1${RESET}"
            echo -e "${ORANGE}3) Half-Life 2: Episode 2${RESET}"
            echo -e "${ORANGE}4) Half-Life 2: Deathmatch${RESET}"
            echo -e "${ORANGE}5) Half-Life: Source${RESET}"
            echo "6) Counter-Strike: Source"
            echo "7) Day of Defeat: Source"
            echo -e "${BLUE}8) Portal${RESET}"
            echo
            echo -e "${BOLD}Goldsrc Games:${RESET}"
            echo -e "${ORANGE}9) Half-Life${RESET}"
            echo -e "${BLUE}10) Half-Life: Blue Shift${RESET}"
            echo -e "${GREEN}11) Half-Life: Opposing Force${RESET}"
            echo "12) Counter-Strike"
            echo -e "${YELLOW}13) Team Fortress Classic${RESET}"
            echo -e "${RED}b) Back${RESET}"
            echo "============================"
            read -p "Choose one or more options, separated by commas Ex:1,3 (1-13): " selections

            if [[ "$selections" == "b" ]]; then
                back_to_main=true
                break
            fi

            IFS=',' read -ra choices <<< "$selections"
            goldsrc_choices=()

            for choice in "${choices[@]}"; do
                case "$choice" in
                    1) commands+=("-branch steam_legacy -app 220 -depot 221 -dir source") ;;
                    2) commands+=("-branch steam_legacy -app 220 -depot 389 -dir source") ;;
                    3) commands+=("-branch steam_legacy -app 220 -depot 380 -dir source") ;;
                    4) commands+=("-branch steam_legacy -app 220 -depot 420 -dir source") ;;
                    5) commands+=("-branch steam_legacy -app 220 -depot 380 -dir source") ;;
                    6) commands+=("-app 240 -depot 241 -dir source -branch previous_build") ;;
                    7) commands+=("-branch previous_build -app 300 -depot 301 -dir source") ;;
                    8) commands+=("-app 400 -depot 401 -dir source") ;;
                    9|10|11|12|13) goldsrc_choices+=("$choice") ;;
                esac
            done

            if [[ "${#goldsrc_choices[@]}" -gt 0 ]]; then
                while true; do
                    clear
                    echo
                    echo "Which version of the Goldsrc games do you want?"
                    echo
                    echo "1) 25th Anniversary version"
                    echo -e "${YELLOW}! Warning: Newer version, better for Xash (new engine)${RESET}"
                    echo "2) Pre-25th Anniversary version"
                    echo -e "${YELLOW}! Warning: Older version, better for mods and Xash old engine${RESET}"
                    echo "3) Both"
                    echo -e "${RED}b) Back${RESET}"
                    echo "============================"
                    read -p "Choose an option (1-3): " manual_version

                    if [[ "$manual_version" == "b" ]]; then
                        back_to_main=true
                        break
                    fi

                    for choice in "${goldsrc_choices[@]}"; do
                        if [[ "$manual_version" == "1" || "$manual_version" == "3" ]]; then
                            case "$choice" in
                                9)  commands+=("-app 70  -depot 1   -dir goldsrc") ;;
                                10) commands+=("-app 130 -depot 130 -dir goldsrc") ;;
                                11) commands+=("-app 50  -depot 51  -dir goldsrc") ;;
                                12) commands+=("-app 10  -depot 11  -dir goldsrc") ;;
                                13) commands+=("-app 20  -depot 21  -dir goldsrc") ;;
                            esac
                        fi
                        if [[ "$manual_version" == "2" || "$manual_version" == "3" ]]; then
                            case "$choice" in
                                9)  commands+=("-branch steam_legacy -app 70  -depot 1   -dir goldsrc_old") ;;
                                10) commands+=("-branch steam_legacy -app 130 -depot 130 -dir goldsrc_old") ;;
                                11) commands+=("-branch steam_legacy -app 50  -depot 51  -dir goldsrc_old") ;;
                                12) commands+=("-branch steam_legacy -app 10  -depot 11  -dir goldsrc_old") ;;
                                13) commands+=("-branch steam_legacy -app 20  -depot 21  -dir goldsrc_old") ;;
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
                echo -e "${RED}No games selected. Returning to main menu...${RESET}"
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
        echo "Invalid option."
        sleep 2
        continue
    fi

    if [[ "${#commands[@]}" -eq 0 ]]; then
        echo -e "${RED}No commands selected. Returning to main menu...${RESET}"
        sleep 2
        continue
    fi

    # Request for login
    echo
    read -p "Enter your Steam username: " username
    echo -n "Enter your Steam password: "
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
            echo -e "${RED}Failed to run the command above.${RESET}"
            exit 1
        }
    done

    read -p "Press ENTER to return to the main menu..." _
done
