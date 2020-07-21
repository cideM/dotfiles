let Colors =
      https://raw.githubusercontent.com/cideM/dhall-alacritty/master/colors.dhall sha256:a6abc9e4f4717cad5e4991896708baa6e14a86381cc54e4c3a77231298a32272

let scheme
    : Colors.Schema.Type
    = { primary =
        { background = "0xeeeeee"
        , foreground = "0x4d4d4c"
        , dim_background = None Text
        , dim_foreground = None Text
        }
      , cursor = Some { text = "0xf3f3f3", cursor = "0x4d4d4c" }
      , vi_mode_cursor = Some { text = "0xf3f3f3", cursor = "0x4d4d4c" }
      , indexed_colors = [] : List Colors.IndexColor
      , selection = None Colors.Selection
      , dim = None Colors.Block
      , normal =
        { black = "0xededed"
        , red = "0xd7005f"
        , green = "0x718c00"
        , yellow = "0xd75f00"
        , blue = "0x4271ae"
        , magenta = "0x8959a8"
        , cyan = "0x3e999f"
        , white = "0x4d4d4c"
        }
      , bright =
        { black = "0x949494"
        , red = "0xd7005f"
        , green = "0x718c00"
        , yellow = "0xd75f00"
        , blue = "0x4271ae"
        , magenta = "0x8959a8"
        , cyan = "0x3e999f"
        , white = "0xf5f5f5"
        }
      }

in  scheme
