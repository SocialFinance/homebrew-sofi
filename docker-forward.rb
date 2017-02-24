class DockerForward < Formula
  desc "Listens to docker-machine and creates ssh tunnels for all ports"
  homepage "https://github.com/vultron81/docker-forward"
  url "https://github.com/vultron81/docker-forward/archive/v1.3.0.tar.gz"
  sha256 "951a2826a2add3543ee7f3a2209dead96555789d0bd010b52fed5caec9b7fccf"
  depends_on :python if MacOS.version <= :snow_leopard

  resource "pythondaemon" do
    url "https://pypi.python.org/packages/ae/e4/82870b5e01d761a04597fa332e4aaf285acfa1e675350fda55c6686f16ef/python-daemon-2.1.1.tar.gz"
    sha256 "58a8c187ee37c3a28913bef00f83240c9ecd4a59dce09a24d92f5c941606689f"
  end

  resource "dockerpy" do
    url "https://pypi.python.org/packages/32/bb/90c22f5aa3562ea0de676657568a7988a49a8dd020a8bb654bbc31194aa2/docker-2.1.0.tar.gz"
    sha256 "0a9c6965752e9dbc6b35d9f7541e70ac7cb4ff23fdd73bb20491b42a7c996ac7"
  end

  def install
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python2.7/site-packages"
    %w[pythondaemon dockerpy].each do |r|
      resource(r).stage do
        system "python", *Language::Python.setup_install_args(libexec/"vendor")
      end
    end

    ENV.prepend_create_path "PYTHONPATH", libexec

    bin.install "docker-forward"
  end

  test do
    system "#{bin}/docker-forward" " -h"
  end
end
