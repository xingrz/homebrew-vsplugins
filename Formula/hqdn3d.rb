class Hqdn3d < Formula
  desc "High Quality DeNoise 3D performs a 3-way low-pass filter, which can completely remove high-frequency noise while minimizing blending artifacts"
  homepage "https://github.com/theChaosCoder/vapoursynth-hqdn3d"
  url "https://github.com/theChaosCoder/vapoursynth-hqdn3d/archive/refs/tags/r2.0.1.zip"
  sha256 "f254976ce45a8783af08abb7c971a3cef3f2d8217513ac78550461abb220b28d"
  head "https://github.com/theChaosCoder/vapoursynth-hqdn3d.git", branch: "master"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "vapoursynth"

  def install
    system "./autogen.sh"
    system "./configure", *std_configure_args
    system "make"
    (lib/"vapoursynth").install ".libs/#{shared_library("libhqdn3d")}"
  end

  test do
    python = Formula["vapoursynth"].deps
                                   .find { |d| d.name.match?(/^python@\d\.\d+$/) }
                                   .to_formula
                                   .opt_libexec/"bin/python"
    system python, "-c", "from vapoursynth import core; core.hqdn3d"
  end
end
