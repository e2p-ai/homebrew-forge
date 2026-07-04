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
  version "0.6.1"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/e2p-ai/forge/releases/download/v#{version}/forge-v#{version}-aarch64-apple-darwin.tar.gz", using: PrivateAssetStrategy
      sha256 "ab5d9d049a2ddc87c705f5d0798530ff2a00aa7e9e579b80334fd701633669c3"
    else
      url "https://github.com/e2p-ai/forge/releases/download/v#{version}/forge-v#{version}-x86_64-apple-darwin.tar.gz", using: PrivateAssetStrategy
      sha256 "db318675e18bc1893ff4a7bc8188d2e476b1590385abed0baf45ecf25f3328e7"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/e2p-ai/forge/releases/download/v#{version}/forge-v#{version}-aarch64-unknown-linux-gnu.tar.gz", using: PrivateAssetStrategy
      sha256 "4f270434e1e691912601b4dbddf6744f17f450186030c610dda72e448ee0d855"
    else
      url "https://github.com/e2p-ai/forge/releases/download/v#{version}/forge-v#{version}-x86_64-unknown-linux-gnu.tar.gz", using: PrivateAssetStrategy
      sha256 "97ecca6a1d55b9cd496516f17c2040fcaf9f220b4f3bc07cae6005b1599e9e28"
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
