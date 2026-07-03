# Download strategy for release assets in private GitHub repos.
# Authenticates with (in order): HOMEBREW_GITHUB_API_TOKEN, GITHUB_TOKEN,
# or the gh CLI's stored token. The browser_download_url of a private asset
# 404s anonymously; the API asset endpoint with Accept: application/octet-stream
# serves the bytes when authorized.
require "download_strategy"
require "utils/curl"
require "json"

class PrivateAssetStrategy < CurlDownloadStrategy
  def initialize(url, name, version, **meta)
    super
    m = url.match(%r{github\.com/([^/]+)/([^/]+)/releases/download/([^/]+)/(.+)$})
    raise "PrivateAssetStrategy: unrecognized release URL #{url}" unless m
    @owner, @repo, @tag, @asset = m.captures
  end

  private

  def github_token
    ENV["HOMEBREW_GITHUB_API_TOKEN"] || ENV["GITHUB_TOKEN"] ||
      %w[/opt/homebrew/bin/gh /usr/local/bin/gh gh].filter_map { |g| t = Utils.popen_read(g, "auth", "token").strip rescue ""; t.empty? ? nil : t }.first ||
      raise("PrivateAssetStrategy: no GitHub token (set HOMEBREW_GITHUB_API_TOKEN or `gh auth login`)")
  end

  def asset_api_url
    api = Utils::Curl.curl_output(
      "--fail", "--silent",
      "--header", "Authorization: token #{github_token}",
      "--header", "Accept: application/vnd.github+json",
      "https://api.github.com/repos/#{@owner}/#{@repo}/releases/tags/#{@tag}"
    ).stdout
    asset = JSON.parse(api).fetch("assets").find { |a| a["name"] == @asset }
    raise "PrivateAssetStrategy: asset #{@asset} not on release #{@tag}" unless asset
    asset.fetch("url")
  end

  def _fetch(url:, resolved_url:, timeout:)
    curl_download(
      asset_api_url,
      "--header", "Authorization: token #{github_token}",
      "--header", "Accept: application/octet-stream",
      to: temporary_path, timeout: timeout
    )
  end
end
