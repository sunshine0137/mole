#!/usr/bin/env bash

export PATH="$PATH:/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin:/root/bin"

# BASE DIR DEF
BASE_DIR=$( cd $(dirname $0) && pwd)
SRC_FTMP="/var/tmp/.srcdir.md5db"
DST_FTMP="/var/tmp/.dstdir.md5db"
RESULT_F="/var/tmp/diffdir.result"
RESULT_CFG="/var/tmp/update.cfg"
SEPERATOR="~~~"

# REQUIRED_UTILS DEF
REQUIRED_UTILS=(
        "/bin/awk"
        "/bin/sed"
        "/usr/bin/md5sum"
	"/bin/sort"
	"/bin/find"
	"/usr/bin/uniq"
	"/usr/bin/tee"
	"/usr/bin/column"
	"/bin/touch"
)


### Function Def

# Terminal color
#
echo_green() {
  local content=$*
  echo -e "\033[1;32m${content}\033[0m\c "
}
echo_yellow() {
  local content=$*
  echo -e "\033[1;33m${content}\033[0m\c "
}
echo_red() {
  local content=$*
  echo -e "\033[1;31m${content}\033[0m\c "
}

# Print Help
# 
show_help() {
cat << EOF
	Usage:		./${0##*/}  srcdir  dstdir   [cfg] [prefix]
	Example:	./${0##*/}  /etc/   /tmp/etc.1
	Example:	./${0##*/}  srcdir  dstdir   cfg  "esop_web/files/"
EOF
exit 0
}

util_check() {
  local total=0 err=0 lacklst=
  for util in ${REQUIRED_UTILS[*]}; do
	((total++))
	if [ ! -f "${util}" -o ! -x "${util}" ]; then
		((err++))
		lacklst="${lacklst} ${util}"
	fi
  done
  [ $err -ne 0 ] && echo -en "${lacklst}"
}

# Build MD5 List for Directory
#
build_md5db() {
  local dirname="$1" md5dbfile="$2"
  if [ -z "${dirname}" -o ! -d "${dirname}" ]; then
	echo_red "pls check your input [${dirname}]";echo
	exit 1
  fi

  if ! /bin/touch "${md5dbfile}" >/dev/null 2>&1; then
	echo_red "touch file: [${md5dbfile}] failed";echo
	exit 1
  fi

  if cd "${dirname}" >/dev/null 2>&1; then
  	/bin/find . -follow -type f -exec /usr/bin/md5sum {} \; > "${md5dbfile}" 2>&-
	if [ "$?" != "0" ]; then
		echo_red "search [${dirname}] all files and build md5sum failed";echo
		exit 1
	fi
	if ! cd "${BASE_DIR}" >/dev/null 2>&1; then
		echo_red "return to nower workdir [${BASE_DIR}]";echo
		exit 1
	fi
  else
	echo_red "changing into [${dirname}] failed";echo
	exit 1
  fi
}

### Main Body Begin

# 0. check utils
UTIL_LACK=$( util_check )
if [ -n "${UTIL_LACK}" ]; then
        echo_red "lack utils: [${UTIL_LACK}]";echo
        exit 1
fi

# 1. remove last /
srcdir=$(echo "$1"|sed -e 's#/$##')
dstdir=$(echo "$2"|sed -e 's#/$##')
workmode="$3"
prefix="$4"
MODE=0

# 2. check input args 
[ -z "${srcdir}" -o -z "${dstdir}" ] && show_help
if [ ! -d "${srcdir}" -o ! -d "${dstdir}" ]; then
	echo_red "[${srcdir}] or [${dstdir}] isn't an exist directory.";echo
	exit 1
fi

if [ "${workmode}" == "cfg" ]; then
	if [ -z "${prefix}" ]; then
		echo_red "prefix required on work mode=cfg";echo
		exit 1
	else
		MODE=1
	fi
else
	if [ -n "${workmode}" ]; then
		echo_red "work mode must be [cfg]";echo
		exit 1
	fi
fi

# 3. build md5sum list 
echo -e "building md5sum list ... \c "
if build_md5db "${srcdir}" "${SRC_FTMP}"; then
	if build_md5db "${dstdir}" "${DST_FTMP}"; then
		src_files=$( /bin/awk '{$1="";print;}' "${SRC_FTMP}" )
		dst_files=$( /bin/awk '{$1="";print;}' "${DST_FTMP}" )
		echo_green " [OK]";echo;
	else
		echo_red "build md5sum list for [${dstdir}] failed!";echo
		exit 1
	fi
else
	echo_red "build md5sum list for [${srcdir}] failed!";echo
	exit 1
fi

# 4. check add/delete
echo -e "checking add/delete files ... \c "
tmp_files=$( echo -e "${src_files}\n${dst_files}" | /bin/sort | /usr/bin/uniq -u )  ### \n is important
src_only=$( echo -e "${src_files}\n${tmp_files}"  | /bin/sort | /usr/bin/uniq -d | sed -e 's#^ .#'${srcdir}'#' )
dst_only=$( echo -e "${dst_files}\n${tmp_files}"  | /bin/sort | /usr/bin/uniq -d | sed -e 's#^ .#'${dstdir}'#' )
src_onlynum=$( echo -e "${src_only}" | sed -e '/^[ \t]*$/d' | awk -v RS="\n" 'END{print NR}' )
dst_onlynum=$( echo -e "${dst_only}" | sed -e '/^[ \t]*$/d' | awk -v RS="\n" 'END{print NR}' )
echo_green " [OK]";echo

# 5. check modify 
echo -e "checking modify files ... \c "
mod_files=$( while read  -a line ; do awk -v s="${srcdir}" -v d="${dstdir}" '( $1!="'"${line[0]}"'" && $2=="'"${line[1]}"'" ) {gsub(/ *\.\//,"/",$2);printf "%s%s %s%s\n",s,$2,d,$2;exit;}' "${DST_FTMP}" ; done < "${SRC_FTMP}" )
mod_filesnum=$( echo -e "${mod_files}" | sed -e '/^[ \t]*$/d' | awk -v RS="\n" 'END{print NR}' )
echo_green " [OK]";echo

# 6. output result
if [ "${MODE}" == "0" ]; then
	{ 
	echo -e "\n$(echo_green "Result:")\n"
	echo -e "$(echo_green "Files Only in [${srcdir}] (${src_onlynum}):")"
	echo -e "${src_only}"
	echo -e "\n"
	echo -e "$(echo_green "Files Only in [${dstdir}] (${dst_onlynum}):")"
	echo -e "${dst_only}"
	echo -e "\n"
	echo -e "$(echo_green "Files Different (${mod_filesnum}):")"
	echo -e "${mod_files}" | /usr/bin/column -t
	echo -e "\n\n"
	} | /usr/bin/tee "${RESULT_F}"
	echo_green "Result File: ${RESULT_F}";echo;
elif [ "${MODE}" == "1" ]; then
	echo_green "Result File: ${RESULT_CFG}";echo;echo;
	{
	echo -e "[remove]"
	echo -e "${src_only}\n" | while read file
	do
		[ -z "${file}" ] && continue 1
		file=$(echo -e "${file}" | awk -F "${srcdir}|${dstdir}" '{gsub(/^\//,"",$2);gsub(" ","",$2);print $2;exit;}')
		echo -e "${file}"
	done
	echo

	echo -e "[add]"
	echo -e "${dst_only}\n" | while read file
	do
		[ -z "${file}" ] && continue 1
		file=$(echo -e "${file}" | awk -F "${srcdir}|${dstdir}" '{gsub(/^\//,"",$2);gsub(" ","",$2);print $2;exit;}')
		echo -e "${file}${SEPERATOR}${prefix}"
	done
	echo

	echo -e "[modify]"
	echo -e "${mod_files}\n" | while read file
	do
		[ -z "${file}" ] && continue 1
		file=$(echo -e "${file}" | awk -F "${srcdir}|${dstdir}" '{gsub(/^\//,"",$2);gsub(" ","",$2);print $2;exit;}')
		echo -e "${file}${SEPERATOR}${prefix}"
	done
	echo
	} | /usr/bin/tee "${RESULT_CFG}"
	echo_green "Result File: ${RESULT_CFG}";echo;
fi
