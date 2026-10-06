cask "qbittorrent" do
    on_monterey :or_older do
        version "5.0.5"
        sha256 "7285e98b5ef4b9a227247dcd933f1a556bfc1ff10901fc7aedb0c4b7ad082814"

        livecheck do
            skip "Legacy version"
        end
    end

    on_ventura :or_newer do
        version "5.2.3"
        sha256 "9e37f6c7ff848c7bdd3c10167614c0cb78c00e2ddcc323f1ad3ac6c008a0481f"

        livecheck do
            url :url
            regex(/^qbittorrent[._-]v?(\d+(?:\.\d+)+)\.dmg$/i)
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

    url "https://github.com/qbittorrent/qBittorrent/releases/download/release-#{version}/qbittorrent-#{version}.dmg"
    name "qBittorrent"
    desc "Peer to peer Bitorrent client"
    homepage "https://www.qbittorrent.org/"

    depends_on macos: :monterey

    conflicts_with cask: [
        "c0re100-qbittorrent",
        "qbittorrent@lt20",
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
