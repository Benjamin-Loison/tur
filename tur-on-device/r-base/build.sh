TERMUX_PKG_HOMEPAGE=https://www.r-project.org/
TERMUX_PKG_DESCRIPTION="A free software environment for statistical computing and graphics"
TERMUX_PKG_LICENSE="GPL-2.0, GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=4.2.2
TERMUX_PKG_SRCURL=https://mirrors.tuna.tsinghua.edu.cn/CRAN/src/base/R-${TERMUX_PKG_VERSION::1}/R-$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=0ff62b42ec51afa5713caee7c4fde7a0c45940ba39bef8c5c9487fef0c953df5
TERMUX_PKG_DEPENDS="libandroid-glob, libiconv, libbz2, libcurl, liblzma, pcre2, readline, zlib"
TERMUX_PKG_BUILD_DEPENDS="binutils, gcc-11, openjdk-17"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
ac_cv_have_decl_wctrans=yes
--with-x=no
--enable-R-shlib
"

source $TERMUX_SCRIPTDIR/common-files/setup_toolchain_gcc.sh

termux_step_pre_configure() {
    CFLAGS="${CFLAGS/-Oz/-O0}"
	CXXFLAGS="${CXXFLAGS/-Oz/-O0}"
	LDFLAGS="${LDFLAGS/-static-openmp/''}"
	LDFLAGS+=" -landroid-glob"
	export JAVA_HOME=$TERMUX_PREFIX/opt/openjdk-17

	CROSS_PREFIX=$TERMUX_ARCH-linux-android
	if [ "$TERMUX_ARCH" == "arm" ]; then
		CROSS_PREFIX=arm-linux-androideabi
	fi

	export AR=$CROSS_PREFIX-ar
	export AS=$CROSS_PREFIX-as
	export LD=$CROSS_PREFIX-ld
	export NM=$CROSS_PREFIX-nm
	export CC=$CROSS_PREFIX-gcc-11
	export FC=$CROSS_PREFIX-gfortran-11
	export CXX=$CROSS_PREFIX-g++-11
	unset CPP CXXCPP STRINGS
	export STRIP=$CROSS_PREFIX-strip
	export RANLIB=$CROSS_PREFIX-ranlib
}
