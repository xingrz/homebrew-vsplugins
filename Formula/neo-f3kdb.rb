class NeoF3kdb < Formula
  homepage "https://github.com/HomeOfAviSynthPlusEvolution/neo_f3kdb"
  url "https://github.com/HomeOfAviSynthPlusEvolution/neo_f3kdb/archive/refs/tags/r9.zip"
  sha256 "7abb7ee6b21ef27895e9c1ff4068905209a6005d0bb5d976bc4b58adab8ab642"
  license "GPL-3.0"
  head "https://github.com/HomeOfAviSynthPlusEvolution/neo_f3kdb.git", branch: "master"

  depends_on "cmake" => :build
  depends_on "vapoursynth"

  uses_from_macos "llvm"

  stable do
    patch :DATA
  end

  def install
    system "cmake", "-S", ".",
                    "-B", "build",
                    "-DVERSION=r#{version}",
                    *std_cmake_args
    system "cmake", "--build", "build"
    (lib/"vapoursynth").install "build/#{shared_library("libneo-f3kdb")}"
  end

  test do
    python = Formula["vapoursynth"].deps
                                   .find { |d| d.name.match?(/^python@\d\.\d+$/) }
                                   .to_formula
                                   .opt_libexec/"bin/python"
    system python, "-c", "from vapoursynth import core; core.neo_f3kdb"
  end
end
__END__
diff --git a/CMakeLists.txt b/CMakeLists.txt
index d4ba6d3..b06ca4c 100644
--- a/CMakeLists.txt
+++ b/CMakeLists.txt
@@ -6,10 +6,6 @@ add_library(neo-f3kdb SHARED main.cpp src/version.rc ${CODE} ${CODE_IMPL})
 set_property(TARGET neo-f3kdb PROPERTY CXX_STANDARD 17)
 option(ENABLE_PAR "Enable C++17 Parallel Execution" ON)

-find_package(Git REQUIRED)
-execute_process(COMMAND ${GIT_EXECUTABLE} describe --first-parent --tags --always OUTPUT_VARIABLE GIT_REPO_VERSION OUTPUT_STRIP_TRAILING_WHITESPACE)
-string(REGEX REPLACE "(r[0-9]+).*" "\\1" VERSION ${GIT_REPO_VERSION})
-
 configure_file (
   "${PROJECT_SOURCE_DIR}/src/version.hpp.in"
   "${PROJECT_SOURCE_DIR}/src/version.hpp"
@@ -72,8 +68,3 @@ if(ENABLE_PAR AND HAS_EXECUTION)
     target_link_libraries(neo-f3kdb tbb)
   endif()
 endif()
-
-add_custom_command(
-  TARGET neo-f3kdb POST_BUILD
-  COMMAND ${CMAKE_COMMAND} -E copy $<TARGET_FILE:neo-f3kdb> "../Release_${VERSION}/${_DIR}/$<TARGET_FILE_NAME:neo-f3kdb>"
-)
