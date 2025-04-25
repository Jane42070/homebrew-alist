class Alist < Formula
  version "3.44.0"
  homepage "https://github.com/alist-org"
  desc "A file list program that supports multiple storages, powered by Gin and Solidjs"

  if Hardware::CPU.arch == :arm64
    url "https://github.com/alist-org/alist/releases/download/v#{version}/alist-darwin-arm64.tar.gz"
    sha256 "be363afb2a2bc48267dd7b6dfbca4280fde3d296bdddb994da2410218cfbc936"
  else
    url "https://github.com/alist-org/alist/releases/download/v#{version}/alist-darwin-amd64.tar.gz"
    sha256 "d072741af0b9735d2a32351d42f80c63f819577146d359782085591289341464"
  end

  def install
    bin.install "alist"
  end

  def post_install
    # Check if the directory exists before creating it
    unless File.directory?("#{etc}/alist-data")
      system "mkdir", "#{etc}/alist-data"
    end
  end

  def caveats
    return unless latest_version_installed?

    <<~EOS
      You need to run alist once after installation is done.
        Using: #{bin}/alist server --data #{etc}/alist-data

      On start, alist will print admin credentials once. Then you can stop it again via: STRG+C
      
      You can access the running service via: http://127.0.0.1:5244
    EOS
  end

  service do
    run ["#{bin}/alist", "server", "--data", "#{etc}/alist-data"]
    keep_alive crashed: false
  end
end
