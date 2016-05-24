class DockerForward < Formula
  desc "Listens to docker-machine and creates ssh tunnels for all ports"
  homepage "https://github.com/vultron81/docker-forward"
  url "https://github.com/vultron81/docker-forward/archive/v1.2.1.tar.gz"
  sha256 "c3a11380c4bfce4544e6aeaa5c31f9b362d2837b93ea55bf6c0a7969c4bfc3e2"
  depends_on :python if MacOS.version <= :snow_leopard

  resource "pythondaemon" do
    url "https://pypi.python.org/packages/ae/e4/82870b5e01d761a04597fa332e4aaf285acfa1e675350fda55c6686f16ef/python-daemon-2.1.1.tar.gz"
    sha256 "58a8c187ee37c3a28913bef00f83240c9ecd4a59dce09a24d92f5c941606689f"
  end

  resource "dockerpy" do
    url "https://pypi.python.org/packages/d9/af/4c4edd438a1d132a30c7877d929841a6b8e843ee281f41d91500ad7fac65/docker-py-1.8.1.tar.gz"
    sha256 "4f47a05e677472b5e022be1ab1dfd91b473ab3fc14a6b71337042ac2caaafa0b"
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
