terraform {
  required_providers {
    spotify = {
      version = "~> 0.1.5"
      source  = "conradludgate/spotify"
    }
  }
}

variable "spotify_api_key" {
  type = string
}

variable "artists" {
  type = list
  default = ["Mayday Parade", "Quietdrive", "Yellowcard", "Fall Out Boy"]
  
}
provider "spotify" {
  api_key = var.spotify_api_key
}

resource "spotify_playlist" "playlist" {
  name        = "Terraform Summer Playlist"
  description = "This playlist was created by Terraform"
  public      = true

  tracks = concat(
    [ for artist in var.artists: [for x in range(20): data.spotify_search_track.search_tracks["${artist}"].tracks[x].id]]
    # tolist([for x in range(20): data.spotify_search_track.Quietdrive.tracks[x].id]),
    # tolist([for x in range(10): data.spotify_search_track.Elliot-Yamin.tracks[x].id])
  )
  # tracks = [
  #   data.spotify_search_track.by_artist.tracks[0].id,
  #   data.spotify_search_track.by_artist.tracks[1].id,
  #   data.spotify_search_track.by_artist.tracks[2].id,
  # ]
}

data "spotify_search_track" "search_tracks" {
  for_each = toset( var.artists )
  artists = ["${each.key}"]
  limit = 20
}

data "spotify_search_track" "Quietdrive" {
  artists = ["Quietdrive"]
  limit = 20
}

data "spotify_search_track" "Elliot-Yamin" {
  artists = ["Elliot Yamin"]
  limit = 10
}

# output "tracks" {
#   # value = data.spotify_search_track.by_artist.tracks
#   # spotify_playlist.playlist.url
# }
