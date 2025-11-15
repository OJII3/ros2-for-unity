#!/bin/bash
SCRIPT=$(readlink -f $0)
SCRIPTPATH=`dirname $SCRIPT`

# display_usage() {
#     echo "Usage: "
#     echo ""
#     echo "build.sh [--with-tests] [--standalone] [--clean-install]"
#     echo ""
#     echo "Options:"
#     echo "--with-tests - build with tests"
#     echo "--standalone - standalone version"
#     echo "--clean-install - makes a clean installation, removes install directory before deploying"
# }

if [ ! -d "$SCRIPTPATH/src/ros2cs" ]; then
    echo "Pull repositories with 'pull_repositories.sh' first."
    exit 1
fi

# OPTIONS=""
STANDALONE=1
TESTS=0
CLEAN_INSTALL=0

ANDROID_NDK=""

while [[ $# -gt 0 ]]; do
  key="$1"
  case $key in
    -p|--ndk-path)
      ANDROID_NDK="$2"
      shift # past argument
      shift # past argument
      ;;
    *)    # unknown option
      shift # past argument
      ;;
  esac
done

if [ -z "${ANDROID_NDK}" ]; then
    echo "need -p option"
else 
    rm -rf build install
    $SCRIPTPATH/build.sh --standalone

    mkdir -p $SCRIPTPATH/tmp_install/ 
    cp -R $SCRIPTPATH/install/asset $SCRIPTPATH/tmp_install 

    rm -rf build install
    $SCRIPTPATH/build_android.sh -p ${ANDROID_NDK}

    cp -R $SCRIPTPATH/tmp_install/asset/Ros2ForUnity/Plugins/Linux $SCRIPTPATH/install/asset/Ros2ForUnity/Plugins

    rm -rf $SCRIPTPATH/tmp_install/ 
fi


