#!/data/data/com.termux/files/usr/bin/env sh
# WIP
# setting env var
username="user"
# end of setting env var
# setting function
# end of setting function

proot-distro login alpine --user $username --no-arch-warning --shared-tmp -- ash -c "cd /storage/emulated/0 && DepotDownloader \"\$@\"" -- "$@"
if [ $? -eq 0 ]; then
	if [ "$#" -ne 0 ] && ! echo "$@" | grep -qE '(^|\s)(-V|--version)($|\s)'; then
		printf "%s\n" "$LANG_SUCCESS_DOWNLOAD"
	fi
else
	printf "%s\n" "$LANG_FAILED_DOWNLOAD"
fi
