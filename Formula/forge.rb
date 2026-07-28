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
  version "0.7.3"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/e2p-ai/forge/releases/download/v#{version}/forge-v#{version}-aarch64-apple-darwin.tar.gz", using: PrivateAssetStrategy
      sha256 "d1469fd54aacaceef6bcf7cf5a3e60dacbde3072ac63e63aafdc468a8ef8828a"
    else
      url "https://github.com/e2p-ai/forge/releases/download/v#{version}/forge-v#{version}-x86_64-apple-darwin.tar.gz", using: PrivateAssetStrategy
      sha256 "c35e761406fd8aff16a079595bf73255f8bdb3fba318f60ac7fab599155b1ba3"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/e2p-ai/forge/releases/download/v#{version}/forge-v#{version}-aarch64-unknown-linux-gnu.tar.gz", using: PrivateAssetStrategy
      sha256 "2a3ea15a99d93c3e85e1714a0d0f817de966b44f510c51ae9401fd3d60ee1cf2"
    else
      url "https://github.com/e2p-ai/forge/releases/download/v#{version}/forge-v#{version}-x86_64-unknown-linux-gnu.tar.gz", using: PrivateAssetStrategy
      sha256 "c64e0341ca50839bab3f70fadb3f0a7abea3d2428a0e9f6cbae8a30b35b72177"
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
