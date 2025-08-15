#!/data/data/com.termux/files/usr/bin/env bash

# ANSI Colors
BOLD="\033[1m"
RESET="\033[0m"
YELLOW="\033[33m"
ORANGE="\033[38;5;208m"
BLUE="\033[34m"
GREEN="\033[32m"
RED="\033[31m"

# Function to load the language script
load_language_script() {
    local lang_file_local="$1"
    local lang_file_url="$2"
    local temp_file="$PWD/lang_temp.sh"

    # If the local file exists and is not empty, source it
    if [[ -s "$lang_file_local" ]]; then
        source "$lang_file_local"
        return 0
    fi

    # Otherwise, download the language file
    curl -sSL "$lang_file_url" -o "$temp_file" || return 1

    # Check if the downloaded file is not empty
    [[ -s "$temp_file" ]] || return 1

    # Source the downloaded file
    source "$temp_file"
    return 0
}

# Language
while true; do
    clear
	echo
    echo -e "${BOLD}Select language:${RESET}"
    echo
    echo "1) English"
    echo "2) Português (Brasil)"
    echo "3) Русский (Russian)"
    echo "============================"
    read -p "Choice (1-3): " lang_option

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
        b|B)
            echo "Returning..."
            exit 0
            ;;
        *)
            echo -e "\nInvalid option. Try again..."
            sleep 2
            ;;
    esac
done

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
    clear
    echo -e "${RED}[!] $LANG_ERROR:${RESET} $LANG_DEPOT"
	echo -e "$LANG_INSTALL_DEPOT"
 	sleep 5
  	echo -e "${BOLD}${GREEN}$LANG_INSTALLING${RESET} depotdownloader"
   	sleep 3
	curl -LO "https://raw.githubusercontent.com/TheKingFireS/TermuxDepotDownloader/alpine/installproot.sh"
	chmod +x installproot.sh
	./installproot.sh
 	echo -e "${BOLD}${GREEN}[*] depotdownloader $LANG_SUCCESS${RESET}"
  	#sleep 3
fi

# Main loop
while true; do
    commands=()
    back_to_main=false

   # clear
    echo
    echo -e "${BOLD}$LANG_TITLE${RESET}"
    echo
    echo "1) $LANG_MAIN_OPTION_ALL"
    echo "2) $LANG_MAIN_OPTION_MANUAL"
    echo -e "${RED}3) $LANG_EXIT${RESET}"
    echo "============================"
    read -p "$LANG_PROMPT_CHOOSE (1-3):" main_menu

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
        echo -e "${BOLD}$LANG_TITLE${RESET}"
        echo
        echo "1) $LANG_MAIN_OPTION_ALL"
        echo "2) $LANG_ALL_SOURCE"
        echo "3) $LANG_ALL_GOLDSRC"
        echo -e "${RED}b) $LANG_OPTION_BACK${RESET}"
        echo "============================"
        read -p "$LANG_PROMPT_CHOOSE " all_option

        if [[ "$all_option" == "b" ]]; then
            continue
        fi

        if [[ "$all_option" == "1" || "$all_option" == "3" ]]; then
            clear
            echo
            echo "${BOLD}$LANG_GOLDSRCVERSION_TITLE${RESET}"
            echo
            echo "1) $LANG_GOLDSRCVERSION_OPTION_25TH"
            echo -e "${YELLOW}$LANG_WARNING_NEW_VERSION${RESET}"
            echo "2) $LANG_GOLDSRCVERSION_OPTION_PRE25TH"
            echo -e "${YELLOW}$LANG_WARNING_OLD_VERSION${RESET}"
            echo "3) $LANG_BOTH"
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
            echo -e "${BOLD}$LANG_TITLE${RESET}"
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
            read -p "$LANG_PROMPT_CHOOSE_MORE (1–13):" selections

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
                    echo -e "${BOLD}$LANG_GOLDSRCVERSION_TITLE${RESET}"
                    echo
                    echo "1) $LANG_GOLDSRCVERSION_OPTION_25TH"
                    echo -e "${YELLOW}$LANG_WARNING_NEW_VERSION${RESET}"
                    echo "2) $LANG_GOLDSRCVERSION_OPTION_PRE25TH"
                    echo -e "${YELLOW}$LANG_WARNING_OLD_VERSION${RESET}"
                    echo "3) $LANG_BOTH"
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
		echo -e "${BOLD}$LANG_ASK_LANGUAGE_PACKS${RESET}"
		echo
		echo "1) $LANG_YES"
		echo "2) $LANG_NO"
		echo -e "${RED}b) $LANG_OPTION_BACK${RESET}"
		echo "============================"
		read -p "$LANG_PROMPT_CHOOSE (1-2):" choose_langpacks

		if [[ "$choose_langpacks" == "b" ]]; then
			back_to_main=true
			break
		fi

		case "$choose_langpacks" in
			1)
				# Tela intermediária: Oficial ou Comunidade
				while true; do
					clear
					echo
					echo -e "${BOLD}$LANG_TRANSLATION_TYPE${RESET}"
					echo
					echo "1) $LANG_TRANSLATION_OFFICIAL"
					echo "2) $LANG_TRANSLATION_COMMUNITY"
					echo -e "${RED}b) $LANG_OPTION_BACK${RESET}"
					echo "============================"
					read -p "$LANG_PROMPT_CHOOSE (1-2): " translation_type

					if [[ "$translation_type" == "b" ]]; then
						break
					fi

					case "$translation_type" in
						1) # Traduções oficiais
							available_langs=()
							for args in "${commands[@]}"; do
								appid=$(echo "$args" | awk '{for(i=1;i<=NF;i++) if($i=="-app") print $(i+1)}')
								depot=$(echo "$args" | awk '{for(i=1;i<=NF;i++) if($i=="-depot") print $(i+1)}')
								case "$appid" in
									220)
										if [[ $depot == 221 ]]; then available_langs+=("${!HL2_LANG_DEPOTS[@]}"); fi
										if [[ $depot == 389 || $depot == 380 ]]; then available_langs+=("${!HL2_EP1_LANG_DEPOTS[@]}"); fi
										if [[ $depot == 420 ]]; then available_langs+=("${!HL2_EP2_LANG_DEPOTS[@]}"); fi
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
							echo -e "${BOLD}$LANG_SELECT_LANGUAGE_PACK${RESET}"
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

							if [[ "$lang_choice" == "b" ]]; then break; fi
							if [[ "$lang_choice" =~ ^[0-9]+$ ]] && (( lang_choice >= 1 && lang_choice <= i-1 )); then
								selected_lang="${lang_menu[$lang_choice]}"
								break 2
							else
								echo -e "\n${RED}$LANG_INVALID_OPTION${RESET} $LANG_TRY_AGAIN"
								sleep 2
							fi
							;;
						2) # Traduções da comunidade
							# Mapeamento dos links de pacotes da comunidade
							declare -A COMMUNITY_PACKS
							COMMUNITY_PACKS["220,pt-BR"]="https://example.com/hl2_pt-BR.zip"
							COMMUNITY_PACKS["220,es-ES"]="https://example.com/hl2_es-ES.zip"
							COMMUNITY_PACKS["240,pt-BR"]="https://example.com/css_pt-BR.zip"
							COMMUNITY_PACKS["400,pt-BR"]="https://example.com/portal_pt-BR.zip"
							COMMUNITY_PACKS["400,fr-FR"]="https://example.com/portal_fr-FR.zip"
							COMMUNITY_PACKS["70,pt-BR"]="https://github.com/source-br/Xash3D-pt-br/releases/download/1.0/Half.life.1.7z"
							COMMUNITY_PACKS["10,pt-BR"]="https://example.com/cs_pt-BR.zip"

							# Seleção do idioma da comunidade
							clear
							echo
							echo -e "${BOLD}$LANG_SELECT_COMMUNITY_LANG${RESET}"
							echo
							community_langs=()
							for key in "${!COMMUNITY_PACKS[@]}"; do
								lang="${key#*,}"
								community_langs+=("$lang")
							done
							community_langs=($(printf "%s\n" "${community_langs[@]}" | sort -u))
							i=1
							declare -A community_menu
							for lang in "${community_langs[@]}"; do
								echo "$i) ${lang}"
								community_menu[$i]=$lang
								((i++))
							done
							echo -e "${RED}b) $LANG_OPTION_BACK${RESET}"
							echo "============================"

							read -p "$LANG_PROMPT_CHOOSE (1-$((i-1))): " lang_choice
							if [[ "$lang_choice" == "b" ]]; then break; fi
							if [[ "$lang_choice" =~ ^[0-9]+$ ]] && (( lang_choice >= 1 && lang_choice <= i-1 )); then
								selected_lang="${community_menu[$lang_choice]}"
							else
								echo -e "\n${RED}$LANG_INVALID_OPTION${RESET} $LANG_TRY_AGAIN"
								sleep 2
								continue
							fi

							# Download dos pacotes de comunidade
							echo -e "${BOLD}${GREEN}$LANG_DOWNLOADING_COMMUNITY_LANG${RESET} ${selected_lang}"
							mkdir -p ./downloads
							for args in "${commands[@]}"; do
								appid=$(echo "$args" | awk '{for(i=1;i<=NF;i++) if($i=="-app") print $(i+1)}')
								game_name=$(get_game_name "$appid")
								pack_url="${COMMUNITY_PACKS["$appid,$selected_lang"]}"
								if [[ -n "$pack_url" ]]; then
									echo -e "${BOLD}$LANG_DOWNLOADING${RESET} $game_name ($selected_lang)"
									curl -L -o "./downloads/${appid}_${selected_lang}.zip" "$pack_url" || \
										echo -e "${RED}$LANG_FAILED_DOWNLOAD $game_name ($selected_lang)${RESET}"
								else
									echo -e "${YELLOW}$LANG_NO_COMMUNITY_PACK $game_name ($selected_lang)${RESET}"
								fi
							done
							break 2
							;;
						*)
							echo -e "\n${RED}$LANG_INVALID_OPTION${RESET} $LANG_TRY_AGAIN"
							sleep 2
							;;
					esac
				done
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

        clear
        echo -e "${BOLD}${GREEN}$LANG_DOWNLOADING${RESET} $game_name"
        eval "$base_command $args" || {
            echo -e "${RED}$LANG_COMMANDS_ABOVE${RESET}"
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