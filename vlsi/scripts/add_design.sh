#!/bin/bash

show_usage() {
    cat << EOF
Usage:

		add_design.sh <DESIGN_SOURCE_SCRIPT_PATH> <DESIGN_RTL_DESTINATION> [<DESIGN_CONFIG_DESTINATION> <TECH>]

		DESIGN_SOURCE_SCRIPT_PATH must export DESIGN_NICKNAME and DESIGN_SRC_PATH

EOF
}

########################
### Input Validation ###
########################

# get arguments
DESIGN_SOURCE_SCRIPT_PATH="$1"
DESIGN_RTL_DESTINATION="$2"
[ -z "${DESIGN_SOURCE_SCRIPT_PATH}" ] && show_usage && exit 1
source $DESIGN_SOURCE_SCRIPT_PATH

# check required variables
[ -z "${DESIGN_NICKNAME}" ] || [ -z "${DESIGN_SRC_PATH}" ]  && show_usage && exit 1
mkdir -p $DESIGN_RTL_DESTINATION

#################
### Execution ###
#################

echo "Copying design $DESIGN_NICKNAME from $DESIGN_SRC_PATH"

## Copy core sources
for file in ${DESIGN_SRC_PATH}/${DESIGN_SRC_GLOB}; do
	# Get extension and module name
	ext=${file##*.}
	module=$(basename -s .$ext "$file")
	dst_file="${DESIGN_RTL_DESTINATION}/${module}.v"

	if [[ $ext = "v" ]]; then
		# copy Verilog file
		cp $file $dst_file
	elif [[ $ext = "sv" ]]; then
		# convert SystemVerilog file
    sv2v \
      $DESIGN_SYNTH_FLAGS \
      $DESIGN_PACKAGE_GLOB \
      $DESIGN_INCLUDE_DIRS \
      "$file" \
      > "$dst_file"
	else
		echo "Unrecognized extension ${ext} in file $file"
	fi
done

## Remove simulation files
pushd $DESIGN_RTL_DESTINATION
if [ ! -z "$DESIGN_SRC_EXCLUSIONS_GLOB" ]; then
  echo "Removing with glob: $DESIGN_SRC_EXCLUSIONS_GLOB"
  rm -f $DESIGN_SRC_EXCLUSIONS_GLOB
fi
if [ ! -z "$DESIGN_SRC_EXCLUSIONS_REGEX" ]; then
  echo "Removing with regex: $DESIGN_SRC_EXCLUSIONS_REGEX"
  ls -1 | egrep "$DESIGN_SRC_EXCLUSIONS_REGEX" |
  while read f; do
    rm $f
  done
fi
popd

echo $TECH
echo $CONFIG
echo $CONFIG_NICKNAME
echo $CORE
echo $DESIGN_CONFIG_SRC

## Optionally create configuration directories
if [ ! -z "$DESIGN_CONFIG_DESTINATION" ]; then

  ## Copy configuration directory
  rm -rf ${DESIGN_CONFIG_DESTINATION}
  mkdir -p ${DESIGN_CONFIG_DESTINATION}
  cp -r ${DESIGN_CONFIG_SRC}/* ${DESIGN_CONFIG_DESTINATION}
  echo "Design config source is $DESIGN_CONFIG_SRC"
  echo "Design config destination is $DESIGN_CONFIG_DESTINATION"

  if [ -f "${DESIGN_CONFIG_SRC}/config_generic.mk" ]; then
    # inject some variables
    echo "" > "${DESIGN_CONFIG_DESTINATION}/config.mk"
    echo "export PLATFORM               = ${TECH}" >> "${DESIGN_CONFIG_DESTINATION}/config.mk"
    echo "export DESIGN_NICKNAME        = ${DESIGN_NICKNAME}" >> "${DESIGN_CONFIG_DESTINATION}/config.mk"
    echo "export DESIGN_NAME            = ${DESIGN_NAME}" >> "${DESIGN_CONFIG_DESTINATION}/config.mk"

    cat ${DESIGN_CONFIG_SRC}/config_generic.mk >> "${DESIGN_CONFIG_DESTINATION}/config.mk"
    rm -f ${DESIGN_CONFIG_DESTINATION}/config_generic.mk
  fi
fi
