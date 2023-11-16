class Lsmash < Formula
  homepage "https://github.com/vimeo/l-smash"
  url "https://github.com/vimeo/l-smash/archive/refs/tags/v2.18.0.zip"
  sha256 "8b4233ba98039b35fca7bac48949a6314a10ae1c9544d097d4024b3a1fb4e0f8"
  license "ISC"
  head "https://github.com/vimeo/l-smash.git", branch: "master"

  depends_on "obuparse"

  def install
    system "./configure", "--prefix=#{prefix}", "--libdir=#{lib}"
    system "make", "install-lib"
  end
end
