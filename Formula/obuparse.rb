class Obuparse < Formula
  homepage "https://github.com/dwbuiten/obuparse"
  license "ISC"
  head "https://github.com/dwbuiten/obuparse.git", branch: "master"

  head do
    patch :DATA
  end

  def install
    system "make"
    lib.install "#{shared_library("libobuparse")}"
    lib.install "libobuparse.a"
    include.install "obuparse.h"
  end
end
__END__
diff --git a/Makefile b/Makefile
index 8643bac..1599c04 100644
--- a/Makefile
+++ b/Makefile
@@ -10,8 +10,7 @@ ifneq (,$(findstring mingw,$(CC)))
 	EXESUF=.exe
 	SYSTEM=MINGW
 else
-	LIBSUF=.so
-	LDFLAGS=-Wl,--version-script,obuparse.v
+	LIBSUF=.dylib
 endif

 all: libobuparse$(LIBSUF) libobuparse.a
