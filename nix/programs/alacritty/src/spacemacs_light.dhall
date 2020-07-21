let Colors =
      https://raw.githubusercontent.com/cideM/dhall-alacritty/master/colors.dhall sha256:a6abc9e4f4717cad5e4991896708baa6e14a86381cc54e4c3a77231298a32272

let scheme
    : Colors.Schema.Type
    = { primary =
        { foreground = "0x64526F"
        , background = "0xFAF7EE"
        , dim_background = None Text
        , dim_foreground = None Text
        }
      , cursor = Some { cursor = "0x64526F", text = "0xFAF7EE" }
      , vi_mode_cursor = Some { cursor = "0x64526F", text = "0xFAF7EE" }
      , indexed_colors = [] : List Colors.IndexColor
      , selection = None Colors.Selection
      , dim = None Colors.Block
      , normal =
        { black = "0xFAF7EE"
        , red = "0xDF201C"
        , green = "0x29A0AD"
        , yellow = "0xDB742E"
        , blue = "0x3980C2"
        , magenta = "0x2C9473"
        , cyan = "0x6B3062"
        , white = "0x64526F"
        }
      , bright =
        { black = "0x9F93A1"
        , red = "0xDF201C"
        , green = "0x29A0AD"
        , yellow = "0xDB742E"
        , blue = "0x3980C2"
        , magenta = "0x2C9473"
        , cyan = "0x6B3062"
        , white = "0x64526F"
        }
      }

in  scheme
