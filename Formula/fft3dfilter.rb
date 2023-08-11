class Fft3dfilter < Formula
  desc "VapourSynth port of FFT3DFilter"
  homepage "https://github.com/myrsloik/VapourSynth-FFT3DFilter"
  url "https://github.com/myrsloik/VapourSynth-FFT3DFilter/archive/refs/tags/R2.zip"
  sha256 "595dce713826829f0bac75d422788bc67859e4b0deb4d4185e3915ceef7c0442"
  head "https://github.com/myrsloik/VapourSynth-FFT3DFilter.git", branch: "master"

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "vapoursynth"
  depends_on "fftw"

  def install
    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build"
    (lib/"vapoursynth").install "build/#{shared_library("libfft3dfilter")}"
  end

  test do
    python = Formula["vapoursynth"].deps
                                   .find { |d| d.name.match?(/^python@\d\.\d+$/) }
                                   .to_formula
                                   .opt_libexec/"bin/python"
    system python, "-c", "from vapoursynth import core; core.fft3dfilter"
  end
end
