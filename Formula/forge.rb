# Homebrew formula for forge.
#
# Drop this into a tap repo at e2p-ai/homebrew-forge/Formula/forge.rb.
# Users then install with:
#
#     brew install e2p-ai/forge/forge
#
# The sha256 values are placeholders — `scripts/publish-homebrew.sh`
# (next file) updates them from the GitHub Release artifacts on every
# tag push, then commits + pushes the tap repo.

require_relative "../lib/private_asset_strategy"

class Forge < Formula
  desc "Agentic coding REPL — model-agnostic, multi-voice, with debate, MCP, hooks, signed WALs"
  homepage "https://github.com/e2p-ai/forge"
  version "0.7.2"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/e2p-ai/forge/releases/download/v#{version}/forge-v#{version}-aarch64-apple-darwin.tar.gz", using: PrivateAssetStrategy
      sha256 "7b302bf8e91ac826213cd7a4dc49f8791e899196eddbd38549eb18948c6112d5"
    else
      url "https://github.com/e2p-ai/forge/releases/download/v#{version}/forge-v#{version}-x86_64-apple-darwin.tar.gz", using: PrivateAssetStrategy
      sha256 "b89c04f84dce4b1dd91ae5ef1ab5c8b70e3e7952384c128cbdd2eded551d4e8d"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/e2p-ai/forge/releases/download/v#{version}/forge-v#{version}-aarch64-unknown-linux-gnu.tar.gz", using: PrivateAssetStrategy
      sha256 "47adc716f23dbcf8d9c225b859b82bb4d6feed0ee866b803e8f23b93ac701fe0"
    else
      url "https://github.com/e2p-ai/forge/releases/download/v#{version}/forge-v#{version}-x86_64-unknown-linux-gnu.tar.gz", using: PrivateAssetStrategy
      sha256 "2164f2755514e7f4f51f444f3eb4f3af579376528927ee9b25356d508cd64ce8"
    end
  end

  def install
    bin.install "forge"
    bin.install "forge-voice"
    bin.install "forge-server"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/forge-voice --help")
  end

  def caveats
    <<~EOS
      Next steps:
        forge init       — interactive setup (OpenRouter key, persona, voice)
        forge --doctor   — verify connectivity
        forge            — start the REPL

      Default voice is kimi (Moonshot Kimi K2.7). Set FORGE_KIMI_ENDPOINT +
      FORGE_KIMI_API_KEY to route it direct (e.g. Fireworks) for sovereign
      inference; otherwise voices route through OpenRouter.
      Get an OpenRouter key: https://openrouter.ai/keys
    EOS
  end
end
