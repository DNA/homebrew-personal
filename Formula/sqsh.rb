class Sqsh < Formula
  desc "SQshelL, a replacement for the venerable 'isql' program supplied by Sybase"
  homepage "https://sourceforge.net/projects/sqsh/"
  url "https://downloads.sourceforge.net/project/sqsh/sqsh/sqsh-2.5/sqsh-2.5.16.1.tgz"
  sha256 "d6641f365ace60225fc0fa48f82b9dbed77a4e506a0e497eb6889e096b8320f2"
  license "GPL-2.0-only"

  depends_on "cmake" => :build
  depends_on "freetds"
  depends_on "readline"

  patch :DATA

  def install
    ENV["SYBASE"] = Formula["freetds"].opt_prefix

    args = %W[
      --prefix=#{prefix}
      --mandir=#{man}
      --with-readline
    ]

    system "./configure", *args
    system "make", "clean"
    system "make"
    system "make", "install"
    system "make", "install.man"
  end

  test do
    assert_equal "sqsh-#{version}", shell_output("#{bin}/sqsh -v").chomp
  end
end

__END__
diff --git a/configure b/configure
index b2ae01f..6492120 100755
--- a/configure
+++ b/configure
@@ -3937,12 +3937,12 @@ $as_echo_n "checking Open Client libraries... " >&6; }
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
diff --git a/src/cmd_connect.c b/src/cmd_connect.c
index e1d35cb..b9013c8 100644
--- a/src/cmd_connect.c
+++ b/src/cmd_connect.c
@@ -40,6 +40,13 @@
 #include "cmd.h"
 #include "sqsh_expand.h" /* sqsh-2.1.6 */
 
+#define CS_TDS_70 7365
+#define CS_TDS_71 7366
+#define CS_TDS_72 7367
+#define CS_TDS_73 7368
+#define CS_TDS_74 7369
+#define CS_TDS_80 CS_TDS_71
+
 /*-- Current Version --*/
 #if !defined(lint) && !defined(__LINT__)
 static char RCS_Id[] = "$Id: cmd_connect.c,v 1.40 2014/04/04 08:22:38 mwesdorp Exp $";
@@ -860,6 +867,14 @@ int cmd_connect( argc, argv )
         /* Then we use freetds which uses enum instead of defines */
         else if (strcmp(tds_version, "7.0") == 0)
             version = CS_TDS_70;
+        else if (strcmp(tds_version, "7.1") == 0)
+            version = CS_TDS_71;
+        else if (strcmp(tds_version, "7.2") == 0)
+            version = CS_TDS_72;
+        else if (strcmp(tds_version, "7.3") == 0)
+            version = CS_TDS_73;
+        else if (strcmp(tds_version, "7.4") == 0)
+            version = CS_TDS_74;
         else if (strcmp(tds_version, "8.0") == 0)
             version = CS_TDS_80;
 #endif
@@ -1258,9 +1273,18 @@ int cmd_connect( argc, argv )
                 case CS_TDS_70:
                     env_set( g_env, "tds_version", "7.0" );
                     break;
-                case CS_TDS_80:
-                    env_set( g_env, "tds_version", "8.0" );
+                case CS_TDS_71:
+                    env_set( g_env, "tds_version", "7.1" );
                     break;
+                case CS_TDS_72:
+                    env_set( g_env, "tds_version", "7.2" );
+                    break;
+                case CS_TDS_73:
+                    env_set( g_env, "tds_version", "7.3" );
+                    break;
+                case CS_TDS_74:
+                    env_set( g_env, "tds_version", "7.4" );
+                     break;
 #endif
                 default:
                     env_set( g_env, "tds_version", "unknown" );
@@ -1875,7 +1899,7 @@ static CS_RETCODE SetNetAuth (conn, principal, keytab_file, secmech, req_options
     CS_CHAR       *req_options;
 {
 
-#if defined(CS_SEC_NETWORKAUTH)
+#if 0 && defined(CS_SEC_NETWORKAUTH)
 
     CS_CHAR buf[CS_MAX_CHAR+1];
     CS_INT  buflen;
@@ -2051,7 +2075,7 @@ static CS_RETCODE ShowNetAuthCredExp (conn, cmdname)
     CS_CONNECTION *conn;
     CS_CHAR       *cmdname;
 {
-#if defined(CS_SEC_NETWORKAUTH)
+#if 0 && defined(CS_SEC_NETWORKAUTH)
     CS_INT     CredTimeOut;
     CS_BOOL    NETWORKAUTH;
     char      *datetime;
