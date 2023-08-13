class Bm3d < Formula
  desc "BM3D denoising filter for VapourSynth"
  homepage "https://github.com/HomeOfVapourSynthEvolution/VapourSynth-BM3D"
  url "https://github.com/HomeOfVapourSynthEvolution/VapourSynth-BM3D/archive/refs/tags/r9.zip"
  sha256 "21fe4ca546e470f6cfbc19488dbaebede7b7136ea9f26358f994b02023fcfff3"
  head "https://github.com/HomeOfVapourSynthEvolution/VapourSynth-BM3D.git", branch: "master"

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "vapoursynth"
  depends_on "fftw"

  def install
    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build"
    (lib/"vapoursynth").install "build/#{shared_library("libbm3d")}"
  end

  test do
    python = Formula["vapoursynth"].deps
                                   .find { |d| d.name.match?(/^python@\d\.\d+$/) }
                                   .to_formula
                                   .opt_libexec/"bin/python"
    system python, "-c", "from vapoursynth import core; core.bm3d"
  end
end
