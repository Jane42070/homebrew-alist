class Alist < Formula
  version "3.30.0"
  homepage "https://github.com/alist-org"
  desc "A file list program that supports multiple storages, powered by Gin and Solidjs"

  if Hardware::CPU.arch == :arm64
    url "https://github.com/alist-org/alist/releases/download/v#{version}/alist-darwin-arm64.tar.gz"
    sha256 "6bf1fe1d7fd80545666269301528d2f382f3b155fd10e56c87bd41a16b291968"
  else
    url "https://github.com/alist-org/alist/releases/download/v#{version}/alist-darwin-amd64.tar.gz"
    sha256 "d54b1e20a50de533459b6a8c3d4e97e30f10e5605fa0d32d03691b90a747bdce"
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
      Afterwards, you can simply run: brew service start alist
      
      Then you can access the service via: http://127.0.0.1:5244
    EOS
  end

  service do
    run ["#{bin}/alist", "server", "--data", "#{etc}/alist-data"]
    keep_alive crashed: false
  end
end
