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
  version "0.6.2"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/e2p-ai/forge/releases/download/v#{version}/forge-v#{version}-aarch64-apple-darwin.tar.gz", using: PrivateAssetStrategy
      sha256 "8614b3c16675ee27e077d39c704a0b72c6b7bfeef3b7bde926899885b1bfc169"
    else
      url "https://github.com/e2p-ai/forge/releases/download/v#{version}/forge-v#{version}-x86_64-apple-darwin.tar.gz", using: PrivateAssetStrategy
      sha256 "2a3ae720e1e347f230c4d0a5bdcc9e9e23589b24c3f6b43f78f42f54b2cacff5"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/e2p-ai/forge/releases/download/v#{version}/forge-v#{version}-aarch64-unknown-linux-gnu.tar.gz", using: PrivateAssetStrategy
      sha256 "134a19e38c1d62be3ae7a04fce6cedaea9a15466bbed197854c3f1fe9f3cd767"
    else
      url "https://github.com/e2p-ai/forge/releases/download/v#{version}/forge-v#{version}-x86_64-unknown-linux-gnu.tar.gz", using: PrivateAssetStrategy
      sha256 "81df28e6f92da60f8af6ac164f2826efe5f10185302b02a2021fc9191d570d86"
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
