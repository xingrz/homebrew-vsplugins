class Lsmashsource < Formula
  homepage "https://github.com/VFR-maniac/L-SMASH-Works"
  license "ISC"
  head "https://github.com/VFR-maniac/L-SMASH-Works.git", branch: "master"

  depends_on "vapoursynth"
  depends_on "ffmpeg@4" => :build
  depends_on "lsmash"

  def install
    chdir "VapourSynth" do
      system "./configure", "--prefix=#{prefix}",
                            "--libdir=#{lib}",
                            "--vs-plugindir=#{lib}/vapoursynth"
      system "make", "install"
    end
  end

  test do
    python = Formula["vapoursynth"].deps
                                   .find { |d| d.name.match?(/^python@\d\.\d+$/) }
                                   .to_formula
                                   .opt_libexec/"bin/python"
    system python, "-c", "from vapoursynth import core; core.lsmas"
  end
end
