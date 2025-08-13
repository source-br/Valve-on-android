#!/data/data/com.termux/files/usr/bin/env bash

# ANSI Colors
BOLD="\033[1m"
RESET="\033[0m"
YELLOW="\033[33m"
ORANGE="\033[38;5;208m"
BLUE="\033[34m"
GREEN="\033[32m"
RED="\033[31m"

# Language
# Loop to select the language
while true; do
    clear
    echo -e "Select language:"
    echo
    echo -e "1) English"
    echo -e "2) Português (Brasil)"
    echo -e "3) Русский"
    echo -e "============================"
    read -p "Choice (1-3): " lang_option

load_language_script() {
    local lang_file_local="$1"
    local lang_file_url="$2"

    if [[ -f "$lang_file_local" ]]; then
        # If the local file exists, use it
        source "$lang_file_local"
    else
        # If it doesn't exist, download and execute it from the internet
        curl -sSL "$lang_file_url" | bash
    fi
}

    case "$lang_option" in
        1)
            load_language_script "english.sh" "https://raw.githubusercontent.com/source-br/Valve-on-android/main/english.sh"
            break
            ;;
        2)
            load_language_script "brazilian.sh" "https://raw.githubusercontent.com/source-br/Valve-on-android/main/brazilian.sh"
            break
            ;;
        3)
            load_language_script "russian.sh" "https://raw.githubusercontent.com/source-br/Valve-on-android/main/russian.sh"
            break
            ;;
        *)
            echo -e "\nInvalid option. Try again..."
            sleep 2
            ;;
    esac

done

# Langs Depots
# Language depots for each game
declare -A HL2_LANG_DEPOTS=(
    [french]=227 [german]=228 [russian]=225 [spanish]=226
    [korean]=229 [tchinese]=230 [schinese]=231 [italian]=232
)
declare -A HL2_EP1_LANG_DEPOTS=(
    [french]=381 [german]=382 [russian]=383 [spanish]=384
    [korean]=385 [tchinese]=386 [schinese]=387 [italian]=388
)
declare -A HL2_EP2_LANG_DEPOTS=(
    [french]=421 [german]=422 [russian]=423 [spanish]=424
)
declare -A CSS_LANG_DEPOTS=(
    [french]=243 [italian]=244 [german]=245 [spanish]=246
    [schinese]=247 [korean]=249 [tchinese]=250 [japanese]=251
    [russian]=252 [thai]=253
)
declare -A PORTAL_LANG_DEPOTS=(
    [spanish]=406 [russian]=405 [french]=407 [german]=408
)
declare -A HL_LANG_DEPOTS=(
    [french]=72 [italian]=73 [german]=74 [spanish]=75 
    [schinese]=77 [korean]=78 [tchinese]=79 [russian]=141
)
declare -A HLBS_LANG_DEPOTS=(
    [french]=131 [german]=132 
)
declare -A HLOF_LANG_DEPOTS=(
    [german]=52 [french]=53 [korean]=56 
)
declare -A CS_LANG_DEPOTS=(
    [french]=12 [italian]=13 [german]=14 [spanish]=15
    [schinese]=17 [korean]=18 [tchinese]=19 [russian]=142
)
declare -A TFC_LANG_DEPOTS=(
    [french]=22 [italian]=23 [german]=24 [spanish]=25
)

# Display names for languages
declare -A lang_display_names=(
    [english]="$LANG_ENGLISH"
    [thai]="$LANG_THAI"
    [french]="$LANG_FRENCH"
    [german]="$LANG_GERMAN"
    [russian]="$LANG_RUSSIAN"
    [spanish]="$LANG_SPANISH"
    [korean]="$LANG_KOREAN"
    [tchinese]="$LANG_TCHINESE"
    [schinese]="$LANG_SCHINESE"
    [italian]="$LANG_ITALIAN"
    [japanese]="$LANG_JAPANESE"
)

# Check if depotdownloader is installed
if ! command -v depotdownloader >/dev/null 2>&1; then
    echo -e "${RED}$LANG_ERROR:${RESET} $LANG_DEPOT"
    exit 1
fi

# Main loop
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
    echo "============================"
    read -p "$LANG_PROMPT_CHOOSE_MAIN " main_menu

    if [[ "$main_menu" == "3" ]]; then
        echo -e "${RED}$LANG_EXITING${RESET}"
        exit 0
    fi

    get_game_name() {
        local appid=$1
        local depot=$2
        case "$appid" in
            220)
                case "$depot" in
                    221) echo "Half-Life 2" ;;
                    389|380) echo "Half-Life 2: Episode 1" ;;
                    420) echo "Half-Life 2: Episode 2" ;;
                    *) echo "Half-Life 2 (unknown depot)" ;;
                esac
                ;;
            240) echo "Counter-Strike: Source" ;;
            400) echo "Portal" ;;
            70)  echo "Half-Life" ;;
            130) echo "Half-Life: Blue Shift" ;;
            50)  echo "Half-Life: Opposing Force" ;;
            10)  echo "Counter-Strike" ;;
            20)  echo "Team Fortress Classic" ;;
            320) echo "Half-Life 2: Deathmatch" ;;
            300) echo "Day of Defeat: Source" ;;
            *)   echo "Unknown game (app $appid depot $depot)" ;;
        esac
    }

    # Functions
    add_goldsrc_pre25() {
        # Add commands for pre-25th Anniversary Goldsrc games
        commands+=(
            "-branch steam_legacy -app 70  -depot 1   -dir goldsrc_old"
            "-branch steam_legacy -app 10  -depot 11  -dir goldsrc_old"
            "-branch steam_legacy -app 20  -depot 21  -dir goldsrc_old"
        )
    }
    add_goldsrc_25() {
        # Add commands for 25th Anniversary Goldsrc games
        commands+=(
            "-app 70  -depot 1   -dir goldsrc"
            "-app 130 -depot 130 -dir goldsrc"
            "-app 50  -depot 51  -dir goldsrc"
            "-app 10  -depot 11  -dir goldsrc"
            "-app 20  -depot 21  -dir goldsrc"
        )
    }
    add_source() {
        # Add commands for Source games
        commands+=(
            "-branch steam_legacy -app 220 -depot 221 -dir source"
            "-branch steam_legacy -app 220 -depot 389 -dir source"
            "-branch steam_legacy -app 220 -depot 380 -dir source"
            "-branch steam_legacy -app 220 -depot 420 -dir source"
            "-branch steam_legacy -app 320 -depot 321 -dir source"
            "-app 280 -depot 280 -dir source"
            "-branch previous_build -app 240 -depot 241 -dir source"
            "-branch previous_build -app 300 -depot 301 -dir source"
            "-app 400 -depot 401 -dir source"
        )
    }

    # Game selection
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
        read -p "$LANG_PROMPT_CHOOSE " all_option

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
            read -p "$LANG_PROMPT_CHOOSE " goldsrc_version

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
            read -p "$LANG_PROMPT_CHOOSE_GAMES " selections

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
                    read -p "$LANG_PROMPT_CHOOSE " manual_version

                    if [[ "$manual_version" == "b" ]]; then
                        back_to_main=true
                        break
                    fi

                    for choice in "${goldsrc_choices[@]}"; do
                        if [[ "$manual_version" == "1" || "$manual_version" == "3" ]]; then
                            case "$choice" in
                                9)  commands+=("-app 70 -depot 1 -dir goldsrc") ;; # Half-Life
                                10) commands+=("-app 130 -depot 130 -dir goldsrc") ;; # Half-Life: Blue Shift
                                11) commands+=("-app 50 -depot 51 -dir goldsrc") ;; # Half-Life: Opposing Force
                                12) commands+=("-app 10 -depot 11 -dir goldsrc") ;; # Counter-Strike
                                13) commands+=("-app 20 -depot 21 -dir goldsrc") ;; # Team Fortress Classic
                            esac
                        fi
                        if [[ "$manual_version" == "2" || "$manual_version" == "3" ]]; then
                            case "$choice" in
                                9)  commands+=("-branch steam_legacy -app 70 -depot 1 -dir goldsrc_old") ;; # Half-Life
                                10) commands+=("-app 130 -depot 130 -dir goldsrc_old") ;; # Half-Life: Blue Shift
                                11) commands+=("-app 50 -depot 51 -dir goldsrc_old") ;; # Half-Life: Opposing Force
                                12) commands+=("-branch steam_legacy -app 10 -depot 11 -dir goldsrc_old") ;; # Counter-Strike
                                13) commands+=("-branch steam_legacy -app 20 -depot 21 -dir goldsrc_old") ;; # Team Fortress Classic
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
        echo -e "${RED}$LANG_INVALID_OPTION${RESET}"
        sleep 2
        continue
    fi

    if [[ "${#commands[@]}" -eq 0 ]]; then
        echo -e "${RED}$LANG_NO_COMMANDS${RESET}"
        sleep 2
        continue
    fi

    # Ask if the user wants to download language packs
	back_to_main=false

	while true; do
		clear
		echo
		echo "$LANG_ASK_LANGUAGE_PACKS"
		echo
		echo "1) $LANG_YES"
		echo "2) $LANG_NO"
		echo -e "${RED}b) $LANG_OPTION_BACK${RESET}"
		echo "============================"
		read -p "$LANG_PROMPT_CHOOSE_YES_NO " choose_langpacks

		if [[ "$choose_langpacks" == "b" ]]; then
			back_to_main=true
			break
		fi

		case "$choose_langpacks" in
			1)
				# Language selection only for supported games
				available_langs=()
				for args in "${commands[@]}"; do
					appid=$(echo "$args" | awk '{for(i=1;i<=NF;i++) if($i=="-app") print $(i+1)}')
					depot=$(echo "$args" | awk '{for(i=1;i<=NF;i++) if($i=="-depot") print $(i+1)}')
					case "$appid" in
						220)
							if [[ $depot == 221 ]]; then
								available_langs+=("${!HL2_LANG_DEPOTS[@]}")
							elif [[ $depot == 389 || $depot == 380 ]]; then
								available_langs+=("${!HL2_EP1_LANG_DEPOTS[@]}")
							elif [[ $depot == 420 ]]; then
								available_langs+=("${!HL2_EP2_LANG_DEPOTS[@]}")
							fi
							;;
						240) available_langs+=("${!CSS_LANG_DEPOTS[@]}") ;;
						400) available_langs+=("${!PORTAL_LANG_DEPOTS[@]}") ;;
						70)  available_langs+=("${!HL_LANG_DEPOTS[@]}") ;;
						130) available_langs+=("${!HLBS_LANG_DEPOTS[@]}") ;;
						50)  available_langs+=("${!HLOF_LANG_DEPOTS[@]}") ;;
						10)  available_langs+=("${!CS_LANG_DEPOTS[@]}") ;;
						20)  available_langs+=("${!TFC_LANG_DEPOTS[@]}") ;;
					esac
				done
				available_langs=($(printf "%s\n" "${available_langs[@]}" | sort -u))

				clear
				echo
				echo "$LANG_SELECT_LANGUAGE_PACK"
				echo
				i=1
				declare -A lang_menu
				for lang in "${available_langs[@]}"; do
					echo "$i) ${lang_display_names[$lang]}"
					lang_menu[$i]=$lang
					((i++))
				done
				echo -e "${RED}b) $LANG_OPTION_BACK${RESET}"
				echo "============================"

				read -p "$LANG_PROMPT_CHOOSE (1-$((i-1))): " lang_choice

				if [[ "$lang_choice" == "b" ]]; then
					continue
				elif [[ "$lang_choice" =~ ^[0-9]+$ ]] && (( lang_choice >= 1 && lang_choice <= i-1 )); then
					selected_lang="${lang_menu[$lang_choice]}"
					break
				else
					echo -e "\n${RED}$LANG_INVALID_OPTION${RESET} $LANG_TRY_AGAIN"
					sleep 2
					continue
				fi
				;;
			2)
				selected_lang=""
				break
				;;
			*)
				echo -e "\n${RED}$LANG_INVALID_OPTION${RESET} $LANG_TRY_AGAIN"
				sleep 2
				;;
		esac
	done

	if $back_to_main; then
		continue  
	fi


    # Login
    clear
    read -p "$LANG_ENTER_USERNAME " username
    echo -n "$LANG_ENTER_PASSWORD "
    password=""
    while IFS= read -r -s -n1 char; do
        [[ -z "$char" ]] && echo && break
        if [[ "$char" == $'\x7f' ]]; then
            password="${password%?}"
            echo -ne "\b \b"
        else
            password+="$char"
            echo -n "*"
        fi
    done
    base_command="depotdownloader -username \"$username\" -password \"$password\" -remember-password -validate"

    # Main download
    for args in "${commands[@]}"; do
        appid=$(echo "$args" | awk '{for(i=1;i<=NF;i++) if($i=="-app") print $(i+1)}')
        depot=$(echo "$args" | awk '{for(i=1;i<=NF;i++) if($i=="-depot") print $(i+1)}')
        game_name=$(get_game_name "$appid" "$depot")

        echo -e "${BOLD}${GREEN}$LANG_DOWNLOADING${RESET} $game_name"
        eval "$base_command $args" || {
            echo -e "${RED}Error executing the command above.${RESET}"
            exit 1
        }

        # Download language pack
        if [[ -n "$selected_lang" ]]; then
            appid=$(echo "$args" | awk '{for(i=1;i<=NF;i++) if($i=="-app") print $(i+1)}')
            depot=$(echo "$args" | awk '{for(i=1;i<=NF;i++) if($i=="-depot") print $(i+1)}')
            depot_id=""
            case "$appid" in
                220)
                    if [[ $depot == 221 ]]; then
                        depot_id="${HL2_LANG_DEPOTS[$selected_lang]} -dir source"
                    elif [[ $depot == 389 || $depot == 380 ]]; then
                        depot_id="${HL2_EP1_LANG_DEPOTS[$selected_lang]} -dir source"
                    elif [[ $depot == 420 ]]; then
                        depot_id="${HL2_EP2_LANG_DEPOTS[$selected_lang]} -dir source"
                    fi
                    ;;
                240) depot_id="${CSS_LANG_DEPOTS[$selected_lang]} -dir source" ;;
                400) depot_id="${PORTAL_LANG_DEPOTS[$selected_lang]} -dir source" ;;
                70)  depot_id="${HL_LANG_DEPOTS[$selected_lang]} -dir goldsrc" ;;
                130) depot_id="${HLBS_LANG_DEPOTS[$selected_lang]} -dir goldsrc" ;;
                50)  depot_id="${HLOF_LANG_DEPOTS[$selected_lang]} -dir goldsrc" ;;
                10)  depot_id="${CS_LANG_DEPOTS[$selected_lang]} -dir goldsrc" ;;
                20)  depot_id="${TFC_LANG_DEPOTS[$selected_lang]} -dir goldsrc" ;;
            esac
            if [[ -n "$depot_id" ]]; then
                echo -e "${BOLD}${GREEN}$LANG_DOWNLOADING_LANG_PACK${RESET} ${lang_display_names[$selected_lang]}"
                eval "$base_command -app $appid -depot $depot_id" || { echo -e "${RED}$LANG_COMMANDS_ABOVE${RESET}"; exit 1; }
            fi
        fi
    done

    read -p "$LANG_PRESS_ENTER" _
done
