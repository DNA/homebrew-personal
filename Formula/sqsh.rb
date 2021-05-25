# Documentation: https://docs.brew.sh/Formula-Cookbook
#                https://rubydoc.brew.sh/Formula
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!
class Sqsh < Formula
  desc "Sqsh (pronounced skwish) is short for SQshelL (pronounced s-q-shell), a replacement for the venerable 'isql' program supplied by Sybase."
  homepage "https://sourceforge.net/projects/sqsh/"
  url "https://downloads.sourceforge.net/project/sqsh/sqsh/sqsh-2.5/sqsh-2.5.16.1.tgz"
  sha256 "d6641f365ace60225fc0fa48f82b9dbed77a4e506a0e497eb6889e096b8320f2"
  license "GPL-2.0"

  depends_on "cmake" => :build
  depends_on "readline"
  depends_on "freetds"

  patch :DATA

  def install
    # ENV.deparallelize  # if your formula fails when building in parallel
    # Remove unrecognized options if warned by configure
    # https://rubydoc.brew.sh/Formula.html#std_configure_args-instance_method


    # args = %W[
    #   --prefix=#{prefix}
    #   --mandir=#{man}
    #   --with-debug
    #   --with-readline
    # ]

    # readline = Formula["readline"]
    # ENV["LIBDIRS"] = readline.opt_lib
    # ENV["INCDIRS"] = readline.opt_include    

    # ENV["SYBASE"] = Formula["freetds"].opt_prefix
    # system "./configure", *args
    # system "make", "install"
    # system "make", "install.man"


    system "./configure", *std_configure_args, "--disable-silent-rules"
    # system "cmake", "-S", ".", "-B", "build", *std_cmake_args
  end

  test do
    assert_equal "sqsh-#{version}", shell_output("#{bin}/sqsh -v").chomp
  end
end

__END__
diff -Naur sqsh-2.5-orig/configure sqsh-2.5/configure
--- sqsh-2.5-orig/configure	2014-06-08 11:10:37.000000000 +0200
+++ sqsh-2.5/configure	2014-06-08 13:46:17.000000000 +0200
@@ -3937,12 +3937,12 @@
		# Assume this is a FreeTDS build
		#
			SYBASE_VERSION="FreeTDS"
-			if [ "$ac_cv_bit_mode" = "64" -a -f $SYBASE_OCOS/lib64/libct.so ]; then
+			if [ "$ac_cv_bit_mode" = "64" -a -f $SYBASE_OCOS/lib64/libct.a ]; then
				SYBASE_LIBDIR="$SYBASE_OCOS/lib64"
			else
				SYBASE_LIBDIR="$SYBASE_OCOS/lib"
			fi
-			if [ ! -f $SYBASE_LIBDIR/libct.so ]; then
+			if [ ! -f $SYBASE_LIBDIR/libct.a ]; then
				{ $as_echo "$as_me:${as_lineno-$LINENO}: result: fail" >&5
 $as_echo "fail" >&6; }
				as_fn_error $? "No properly installed FreeTDS or Sybase environment found in ${SYBASE_OCOS}." "$LINENO" 5
--- sqsh-2.5-orig/src/cmd_connect.c	2014-04-04 03:22:38.000000000 -0500
+++ sqsh-2.5/src/cmd_connect-new.c	2017-01-15 12:38:06.000000000 -0600
@@ -860,8 +860,14 @@
         /* Then we use freetds which uses enum instead of defines */
         else if (strcmp(tds_version, "7.0") == 0)
             version = CS_TDS_70;
-        else if (strcmp(tds_version, "8.0") == 0)
-            version = CS_TDS_80;
+        else if (strcmp(tds_version, "7.1") == 0)
+            version = CS_TDS_71;
+        else if (strcmp(tds_version, "7.2") == 0)
+            version = CS_TDS_72;
+        else if (strcmp(tds_version, "7.3") == 0)
+            version = CS_TDS_73;
+        else if (strcmp(tds_version, "7.4") == 0)
+            version = CS_TDS_74;
 #endif
         else version = CS_TDS_50; /* default version */
 
@@ -1258,8 +1264,17 @@
                 case CS_TDS_70:
                     env_set( g_env, "tds_version", "7.0" );
                     break;
-                case CS_TDS_80:
-                    env_set( g_env, "tds_version", "8.0" );
+                case CS_TDS_71:
+                    env_set( g_env, "tds_version", "7.1" );
+                    break;
+                case CS_TDS_72:
+                    env_set( g_env, "tds_version", "7.2" );
+                    break;
+                case CS_TDS_73:
+                    env_set( g_env, "tds_version", "7.3" );
+                    break;
+                case CS_TDS_74:
+                    env_set( g_env, "tds_version", "7.4" );
                     break;
 #endif
                 default:
