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
while true; do
    clear
    echo -e "Select language:"
    echo -e "1) English"
    echo -e "2) Português (Brasil)"
    echo -e "3) Русский (Russian)"
    echo -e "============================"
    read -p "Choice (1-3): " lang_option

    case "$lang_option" in
        1) source english.sh; break ;;
        2) source brazilian.sh; break ;;
        3) source russian.sh; break ;;
        *) echo -e "\nInvalid option. Try again..."; sleep 2 ;;
    esac
done

# Langs Depots
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
    [schinese]=247 [korean]=249 [tchinese]=250 [japonese]=251
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

if ! command -v depotdownloader >/dev/null 2>&1; then
    echo -e "${RED}$LANG_ERROR:${RESET} $LANG_DEPOT"
    exit 1
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
    read -p "$LANG_PROMPT_CHOOSE " main_menu

    if [[ "$main_menu" == "3" ]]; then
        echo -e "${RED}$LANG_EXITING${RESET}"
        exit 0
    fi

    # Functions
    add_goldsrc_pre25() {
        commands+=(
            "-branch steam_legacy -app 70  -depot 1   -dir goldsrc_old" # Half-Life
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
            "-branch steam_legacy -app 220 -depot 389 -dir source" # HL2: Episode 1
            "-branch steam_legacy -app 220 -depot 380 -dir source" # HL2: Episode 1 (maps)
            "-branch steam_legacy -app 220 -depot 420 -dir source" # HL2: Episode 2
            "-branch steam_legacy -app 320 -depot 321 -dir source" # HL2: Deathmatch
            "-app 280 -depot 280 -dir source" # HL: Source
            "-branch previous_build -app 240 -depot 241 -dir source" # CS: Source
            "-branch previous_build -app 300 -depot 301 -dir source" # DOD: Source
            "-app 400 -depot 401 -dir source" # Portal
        )
    }

    # Menu principal...
    # (Mantém igual ao seu código atual até montar o array "commands")

    # =========================
    # Aqui entra o novo sistema de idiomas
    # =========================

    # Lista de idiomas disponíveis
    available_langs=()

    add_available_langs() {
        local app_array_name="$1"
        declare -n arr="$app_array_name"
        for lang in "${!arr[@]}"; do
            if [[ ! " ${available_langs[*]} " =~ " $lang " ]]; then
                available_langs+=("$lang")
            fi
        done
    }

    # Detect avalable languages
    for args in "${commands[@]}"; do
        appid=$(echo "$args" | grep -oP '(?<=-app\s)[0-9]+')
        case "$appid" in
            220) add_available_langs HL2_LANG_DEPOTS ;;
            240) add_available_langs CSS_LANG_DEPOTS ;;
            400) add_available_langs PORTAL_LANG_DEPOTS ;;
            70)  add_available_langs HL_LANG_DEPOTS ;;
            130) add_available_langs HLBS_LANG_DEPOTS ;;
            50)  add_available_langs HLOF_LANG_DEPOTS ;;
            10)  add_available_langs CS_LANG_DEPOTS ;;
            20)  add_available_langs TFC_LANG_DEPOTS ;;
        esac
    done

    available_langs=($(printf "%s\n" "${available_langs[@]}" | sort -u))

    if [[ ${#available_langs[@]} -gt 0 ]]; then
        clear
        echo "$LANG_ASK_LANGUAGE_PACKS"
        echo "1) $LANG_YES"
        echo "2) $LANG_NO"
        read -p "$LANG_PROMPT_CHOOSE_YES_NO " choose_langpacks
    else
        choose_langpacks="2"
    fi

    if [[ "$choose_langpacks" == "1" ]]; then
        clear
        echo "$LANG_SELECT_LANGUAGE_PACK"
        for i in "${!available_langs[@]}"; do
            echo "$((i+1))) ${available_langs[i]^}"
        done
        read -p "$LANG_PROMPT_CHOOSE_LANGUAGES " lang_choice
        selected_lang="${available_langs[$((lang_choice-1))]}"
    else
        selected_lang=""
    fi

    echo
    for args in "${commands[@]}"; do
        echo -e "${BOLD}$LANG_RUNNING${RESET} depotdownloader $args"
        depotdownloader $args || { echo -e "${RED}$LANG_COMMANDS_ABOVE${RESET}"; exit 1; }

        # Download language
        if [[ "$choose_langpacks" == "1" && -n "$selected_lang" ]]; then
            appid=$(echo "$args" | grep -oP '(?<=-app\s)[0-9]+')
            depot=$(echo "$args" | grep -oP '(?<=-depot\s)[0-9]+')
            depot_id=""

            case "$appid" in
                220)
                    case "$depot" in
                        221) depot_id="${HL2_LANG_DEPOTS[$selected_lang]} -dir source" ;;
                        389|380) depot_id="${HL2_EP1_LANG_DEPOTS[$selected_lang]} -dir source" ;;
                        420) depot_id="${HL2_EP2_LANG_DEPOTS[$selected_lang]} -dir source" ;;
                    esac ;;
                240) depot_id="${CSS_LANG_DEPOTS[$selected_lang]} -dir source" ;;
                400) depot_id="${PORTAL_LANG_DEPOTS[$selected_lang]} -dir source" ;;
                70)  depot_id="${HL_LANG_DEPOTS[$selected_lang]} -dir goldsrc" ;;
                130) depot_id="${HLBS_LANG_DEPOTS[$selected_lang]} -dir goldsrc" ;;
                50)  depot_id="${HLOF_LANG_DEPOTS[$selected_lang]} -dir goldsrc" ;;
                10)  depot_id="${CS_LANG_DEPOTS[$selected_lang]} -dir goldsrc" ;;
                20)  depot_id="${TFC_LANG_DEPOTS[$selected_lang]} -dir goldsrc" ;;
            esac

            if [[ -n "$depot_id" ]]; then
                echo -e "${GREEN}Baixando pacote: ${selected_lang^}${RESET}"
                eval "depotdownloader -app $appid -depot $depot_id" || { echo -e "${RED}$LANG_COMMANDS_ABOVE${RESET}"; exit 1; }
            fi
        fi
    done

    read -p "$LANG_PRESS_ENTER" _
done
