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
  version "0.6.3"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/e2p-ai/forge/releases/download/v#{version}/forge-v#{version}-aarch64-apple-darwin.tar.gz", using: PrivateAssetStrategy
      sha256 "b82bf03f62d67782d295dbd0a7613c1d6e38339d4518a34aa3fcb204306ee557"
    else
      url "https://github.com/e2p-ai/forge/releases/download/v#{version}/forge-v#{version}-x86_64-apple-darwin.tar.gz", using: PrivateAssetStrategy
      sha256 "0d899827fb375f0b8393c7b77ed78a88bc70cfba785304eb902c8cb8ac6958a3"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/e2p-ai/forge/releases/download/v#{version}/forge-v#{version}-aarch64-unknown-linux-gnu.tar.gz", using: PrivateAssetStrategy
      sha256 "4412ac204bf8ed59a0c48dd58419c99ab791c6829ade141e31b1cc3afae03361"
    else
      url "https://github.com/e2p-ai/forge/releases/download/v#{version}/forge-v#{version}-x86_64-unknown-linux-gnu.tar.gz", using: PrivateAssetStrategy
      sha256 "b9d69e5add3fdcb45923ef98266990a13709cb6a1de2e4c92a7b247a42672f0c"
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
