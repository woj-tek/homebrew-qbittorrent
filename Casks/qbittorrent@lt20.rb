cask "qbittorrent@lt20" do
    on_monterey :or_older do
        version "5.0.5"
        sha256 "f0180356f89590d2de639ba700813fb9ba1d90dde1af5353fc7621a048cccbb2"

        livecheck do
            skip "Legacy version"
        end
    end

    on_ventura :or_newer do
        version "5.2.3"
        sha256 "4dde4f357cf8d7271f7e25140d2986d076126566edf2d2ad441cdd382b2a333d"

        livecheck do
            url :url
            regex(/^qbittorrent[._-]v?(\d+(?:\.\d+)+)_lt20\.dmg$/i)
            strategy :github_releases do |json, regex|
                json.map do |release|
                    next if release["draft"] || release["prerelease"]

                    release["assets"]&.map do |asset|
                        match = asset["name"]&.match(regex)
                        next if match.blank?

                        match[1]
                    end
                end
            end
        end
    end

    # Renamed for consistency: app name is different in the Finder and in a shell.
    app "qbittorrent.app", target: "qBittorrent.app"

    url "https://github.com/qbittorrent/qBittorrent/releases/download/release-#{version}/qbittorrent-#{version}_lt20.dmg"
    name "qBittorrent"
    desc "Edition of qBitorrent based on libtorrent-rasterbar 2.0.x"
    homepage "https://www.qbittorrent.org/"

    depends_on macos: :monterey

    conflicts_with cask: [
        "c0re100-qbittorrent",
        "qbittorrent",
    ]

    zap trash: [
      "~/.config/qBittorrent",
      "~/Library/Application Support/qBittorrent",
      "~/Library/Caches/qBittorrent",
      "~/Library/Preferences/org.qbittorrent.qBittorrent.plist",
      "~/Library/Preferences/qBittorrent",
      "~/Library/Saved Application State/org.qbittorrent.qBittorrent.savedState",
    ]
end
