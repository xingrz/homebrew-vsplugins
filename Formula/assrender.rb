class Assrender < Formula
  desc "Vapoursynth plugin: libass-based subtitle renderer"
  homepage "https://github.com/AmusementClub/assrender"
  url "https://github.com/AmusementClub/assrender/archive/refs/tags/0.38.0.zip"
  sha256 "6c16235efaaa04f66b738a3654fcb76bceb4ff534c51b32f85add48a5a3fa813"
  head "https://github.com/AmusementClub/assrender.git", branch: "master"

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "vapoursynth"
  depends_on "libass"

  def install
    system "cmake", "-S", ".",
                    "-B", "build",
                    *std_cmake_args
    system "cmake", "--build", "build"
    (lib/"vapoursynth").install "build/src/#{shared_library("libassrender")}"
  end

  test do
    python = Formula["vapoursynth"].deps
                                   .find { |d| d.name.match?(/^python@\d\.\d+$/) }
                                   .to_formula
                                   .opt_libexec/"bin/python"
    system python, "-c", "from vapoursynth import core; core.assrender"
  end
end
