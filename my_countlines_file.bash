print_result() {
	path=$3
	name=$4

	if [ $1 == $2 ]; then
	  echo "File: $name, Lines: $(awk ' END { print NR }' $path) $name"
	fi
}

check_options() {
	while getopts ":o:m:" option; do
	case ${option} in
	o)
		echo "Looking for files where the owner is: "${OPTARG^^}
		search_dir=$(pwd)

		for entry in "$search_dir"/*
		do

		   file_path="$entry"
		   file_name="$(basename $file_path)"
		   file_owner=$(stat -c "%U" "$entry")

		   print_result ${OPTARG^^} ${file_owner^^} $file_path $file_name

		done
	;;
	m)
		echo "Looking for files where the month is: "${OPTARG^^}
		search_dir=$(pwd)

		for entry in "$search_dir"/*
		do
		   file_path="$entry"
		   file_name="$(basename $file_path)"
		   file_date=$(stat -c "%w" "$entry")
		   format_date="$(echo $file_date| cut -d'-' -f 1)-$(echo $file_date| cut -d'-' -f 2)-01"
		   month=$(date -d $format_date '+%b')

		   print_result ${OPTARG^^} ${month^^} $file_path $file_name      		  

		done

	;;
	:)
	echo "You have entered an invalid option. The valid options are [o],[m]"
	;;
	esac
	done
}

check_options $1 $2
