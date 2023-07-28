class Fmtconv < Formula
  desc "Format conversion tools for Vapoursynth and Avisynth+"
  homepage "https://github.com/EleonoreMizo/fmtconv"
  url "https://github.com/EleonoreMizo/fmtconv/archive/refs/tags/r30.zip"
  sha256 "07b1d47ad2886972821d5b08029975f40d9554d5c99ecf74becf2fc1bc3d79ff"
  license "WTFPL"
  head "https://github.com/EleonoreMizo/fmtconv.git", branch: "master"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "vapoursynth"

  def install
    chdir "build/unix" do
      system "./autogen.sh"
      system "./configure", *std_configure_args
      system "make"
      (lib/"vapoursynth").install ".libs/#{shared_library("libfmtconv")}"
    end
  end

  test do
    python = Formula["vapoursynth"].deps
                                   .find { |d| d.name.match?(/^python@\d\.\d+$/) }
                                   .to_formula
                                   .opt_libexec/"bin/python"
    system python, "-c", "from vapoursynth import core; core.fmtc"
  end
end
