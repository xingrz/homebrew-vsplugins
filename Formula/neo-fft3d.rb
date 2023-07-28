class NeoFft3d < Formula
  homepage "https://github.com/HomeOfAviSynthPlusEvolution/neo_FFT3D"
  url "https://github.com/HomeOfAviSynthPlusEvolution/neo_FFT3D/archive/refs/tags/r11.zip"
  sha256 "5590d15a19193bab996bb39ddfe04e5765d226ade15b8ec4fdfdf82cb4523b07"
  license "GPL-2.0"
  head "https://github.com/HomeOfAviSynthPlusEvolution/neo_FFT3D.git", branch: "master"

  depends_on "cmake" => :build
  depends_on "vapoursynth"

  stable do
    patch :DATA
  end

  def install
    system "cmake", "-S", ".",
                    "-B", "build",
                    "-DVERSION=r#{version}",
                    *std_cmake_args
    system "cmake", "--build", "build"
    (lib/"vapoursynth").install "build/#{shared_library("libneo-fft3d")}"
  end

  test do
    python = Formula["vapoursynth"].deps
                                   .find { |d| d.name.match?(/^python@\d\.\d+$/) }
                                   .to_formula
                                   .opt_libexec/"bin/python"
    system python, "-c", "from vapoursynth import core; core.neo_fft3d"
  end
end
__END__
diff --git a/CMakeLists.txt b/CMakeLists.txt
index 5c56fdf..0434d99 100644
--- a/CMakeLists.txt
+++ b/CMakeLists.txt
@@ -8,11 +8,6 @@ add_library(neo-fft3d SHARED main.cpp src/version.rc ${CODE} ${CODE_IMPL})
 set_property(TARGET neo-fft3d PROPERTY CXX_STANDARD 17)
 option(ENABLE_PAR "Enable C++17 Parallel Execution" ON)

-find_package(Git REQUIRED)
-execute_process(COMMAND ${GIT_EXECUTABLE} describe --first-parent --tags --always OUTPUT_VARIABLE GIT_REPO_VERSION)
-string(APPEND GIT_REPO_VERSION "r0")
-string(REGEX REPLACE "(r[0-9]+).*" "\\1" VERSION ${GIT_REPO_VERSION})
-
 configure_file (
   "${PROJECT_SOURCE_DIR}/src/version.hpp.in"
   "${PROJECT_SOURCE_DIR}/src/version.hpp"
@@ -76,8 +71,3 @@ endif()
 if (NOT WIN32)
   target_link_libraries(neo-fft3d dl)
 endif()
-
-add_custom_command(
-  TARGET neo-fft3d POST_BUILD
-  COMMAND ${CMAKE_COMMAND} -E copy $<TARGET_FILE:neo-fft3d> "../Release_${VERSION}/${_DIR}/$<TARGET_FILE_NAME:neo-fft3d>"
-)
