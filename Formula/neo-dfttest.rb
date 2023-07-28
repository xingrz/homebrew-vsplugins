class NeoDfttest < Formula
  homepage "https://github.com/HomeOfAviSynthPlusEvolution/neo_DFTTest"
  url "https://github.com/HomeOfAviSynthPlusEvolution/neo_DFTTest/archive/refs/tags/r8.zip"
  sha256 "3c236997f8e8980103d3b27e7cd22293c8cb61c636e359b1f22e0d2367f93f6f"
  license "GPL-2.0"
  head "https://github.com/HomeOfAviSynthPlusEvolution/neo_DFTTest.git", branch: "master"

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
    (lib/"vapoursynth").install "build/#{shared_library("libneo-dfttest")}"
  end

  test do
    python = Formula["vapoursynth"].deps
                                   .find { |d| d.name.match?(/^python@\d\.\d+$/) }
                                   .to_formula
                                   .opt_libexec/"bin/python"
    system python, "-c", "from vapoursynth import core; core.neo_dfttest"
  end
end
__END__
diff --git a/CMakeLists.txt b/CMakeLists.txt
index 3018c18..6e20ead 100644
--- a/CMakeLists.txt
+++ b/CMakeLists.txt
@@ -8,10 +8,6 @@ set_property(TARGET neo-dfttest PROPERTY CXX_STANDARD 17)
 option(ENABLE_PAR "Enable C++17 Parallel Execution" ON)
 add_compile_definitions(VS_TARGET_CPU_X86)

-find_package(Git REQUIRED)
-execute_process(COMMAND ${GIT_EXECUTABLE} describe --first-parent --tags --always OUTPUT_VARIABLE GIT_REPO_VERSION)
-string(REGEX REPLACE "(r[0-9]+).*" "\\1" VERSION ${GIT_REPO_VERSION})
-
 configure_file (
   "${PROJECT_SOURCE_DIR}/src/version.hpp.in"
   "${PROJECT_SOURCE_DIR}/src/version.hpp"
@@ -81,8 +77,3 @@ endif()
 if (NOT WIN32)
   target_link_libraries(neo-dfttest dl)
 endif()
-
-add_custom_command(
-  TARGET neo-dfttest POST_BUILD
-  COMMAND ${CMAKE_COMMAND} -E copy $<TARGET_FILE:neo-dfttest> "../Release_${VERSION}/${_DIR}/$<TARGET_FILE_NAME:neo-dfttest>"
-)
