let Colors =
      https://raw.githubusercontent.com/cideM/dhall-alacritty/master/colors.dhall sha256:a6abc9e4f4717cad5e4991896708baa6e14a86381cc54e4c3a77231298a32272

let scheme
    : Colors.Schema.Type
    = { primary =
        { background = "0xeeeeee"
        , foreground = "0x878787"
        , dim_background = None Text
        , dim_foreground = None Text
        }
      , cursor = Some { text = "0xeeeeee", cursor = "0x878787" }
      , vi_mode_cursor = Some { text = "0xeeeeee", cursor = "0x878787" }
      , indexed_colors = [] : List Colors.IndexColor
      , selection = None Colors.Selection
      , dim = None Colors.Block
      , normal =
        { black = "0xeeeeee"
        , red = "0xaf0000"
        , green = "0x008700"
        , yellow = "0x5f8700"
        , blue = "0x0087af"
        , magenta = "0x878787"
        , cyan = "0x005f87"
        , white = "0x444444"
        }
      , bright =
        { black = "0xbcbcbc"
        , red = "0xd70000"
        , green = "0xd70087"
        , yellow = "0x8700af"
        , blue = "0xd75f00"
        , magenta = "0xd75f00"
        , cyan = "0x005faf"
        , white = "0x005f87"
        }
      }

in  scheme
