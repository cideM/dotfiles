let Colors =
      https://raw.githubusercontent.com/cideM/dhall-alacritty/master/colors.dhall sha256:a6abc9e4f4717cad5e4991896708baa6e14a86381cc54e4c3a77231298a32272

let scheme
    : Colors.Schema.Type
    = { primary =
        { background = "0x161821"
        , foreground = "0xd2d4de"
        , dim_background = None Text
        , dim_foreground = None Text
        }
      , cursor = None Colors.Cursor
      , vi_mode_cursor = None Colors.Cursor
      , indexed_colors = [] : List Colors.IndexColor
      , selection = None Colors.Selection
      , dim = None Colors.Block
      , normal =
        { black = "0x161821"
        , red = "0xe27878"
        , green = "0xb4be82"
        , yellow = "0xe2a478"
        , blue = "0x84a0c6"
        , magenta = "0xa093c7"
        , cyan = "0x89b8c2"
        , white = "0xc6c8d1"
        }
      , bright =
        { black = "0x6b7089"
        , red = "0xe98989"
        , green = "0xc0ca8e"
        , yellow = "0xe9b189"
        , blue = "0x91acd1"
        , magenta = "0xada0d3"
        , cyan = "0x95c4ce"
        , white = "0xd2d4de"
        }
      }

in  scheme
