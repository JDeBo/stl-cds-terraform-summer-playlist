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
  type = map(object({
  name = string
  limit = number
  }))
}

# variable "artists" {
#   type = list
#   default = ["Mayday Parade", "Quietdrive", "Yellowcard", "Fall Out Boy"]
  
# }
provider "spotify" {
  api_key = var.spotify_api_key
}

resource "spotify_playlist" "playlist" {
  name        = "STL CDS Summer Playlist"
  description = "This playlist was created by the fine CDS folks at Slalom STL"
  public      = true

  tracks = concat(flatten(
    # [for x in range(20): data.spotify_search_track.search_tracks["Mayday Parade"].tracks[x].id]
    [for artist in var.artists: [for x in range(artist.limit): data.spotify_search_track.search_tracks[artist.name].tracks[x].id]]
    # tolist([for x in range(20): data.spotify_search_track.Quietdrive.tracks[x].id]),
    # tolist([for x in range(10): data.spotify_search_track.Elliot-Yamin.tracks[x].id])
  ))
  # tracks = [
  #   data.spotify_search_track.by_artist.tracks[0].id,
  #   data.spotify_search_track.by_artist.tracks[1].id,
  #   data.spotify_search_track.by_artist.tracks[2].id,
  # ]
}

data "spotify_search_track" "search_tracks" {
  for_each = var.artists
  artists = [each.value.name]
  limit = each.value.limit
}

# data "spotify_search_track" "Quietdrive" {
#   artists = ["Quietdrive"]
#   limit = 20
# }

# data "spotify_search_track" "Elliot-Yamin" {
#   artists = ["Elliot Yamin"]
#   limit = 10
# }

# output "tracks" {
#   # value = data.spotify_search_track.by_artist.tracks
#   # spotify_playlist.playlist.url
# }
