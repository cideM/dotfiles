let keys =
      https://raw.githubusercontent.com/cideM/dhall-alacritty/master/keys/common.dhall sha256:d0ce879f656b0e8a75e8ff887411d4ab2fae14e391a9287c7864d34719f989bc

let K = keys.CommonBinding

let Mod = keys.Modifier

let Mode = keys.Mode

let Action = keys.Action

in  keys.showCommonBindings
      [ K.Chars
          { key = "P", mods = Some [ Mod.Alt ], mode = None Mode, chars = "`" }
      , K.Chars
          { key = "N", mods = Some [ Mod.Alt ], mode = None Mode, chars = "` " }
      , K.Chars
          { key = "O"
          , mods = Some [ Mod.Alt ]
          , mode = None Mode
          , chars = "\u001Bo"
          }
      , K.Chars
          { key = "O"
          , mods = Some [ Mod.Shift, Mod.Alt ]
          , mode = None Mode
          , chars = "\u001BO"
          }
      , K.Chars
          { key = "Key0"
          , mods = Some [ Mod.Alt ]
          , mode = None Mode
          , chars = "\u001B0"
          }
      , K.Chars
          { key = "C"
          , mods = Some [ Mod.Alt ]
          , mode = None Mode
          , chars = "\u001Bc"
          }
      , K.Chars
          { key = "C"
          , mods = Some [ Mod.Shift, Mod.Alt ]
          , mode = None Mode
          , chars = "\u001BC"
          }
      , K.Chars
          { key = "L"
          , mods = Some [ Mod.Alt ]
          , mode = None Mode
          , chars = "\u001Bl"
          }
      , K.Chars
          { key = "H"
          , mods = Some [ Mod.Alt ]
          , mode = None Mode
          , chars = "\u001Bh"
          }
      , K.Chars
          { key = "K"
          , mods = Some [ Mod.Alt ]
          , mode = None Mode
          , chars = "\u001Bk"
          }
      , K.Chars
          { key = "J"
          , mods = Some [ Mod.Alt ]
          , mode = None Mode
          , chars = "\u001Bj"
          }
      , K.Chars
          { key = "S"
          , mods = Some [ Mod.Control, Mod.Shift ]
          , mode = None Mode
          , chars = "`c"
          }
      , K.Chars
          { key = "X"
          , mods = Some [ Mod.Control, Mod.Shift ]
          , mode = None Mode
          , chars = "`x"
          }
      , K.Chars
          { key = "Subtract"
          , mods = Some [ Mod.Control ]
          , mode = None Mode
          , chars = "`-"
          }
      , K.Chars
          { key = "Minus"
          , mods = Some [ Mod.Control ]
          , mode = None Mode
          , chars = "`-"
          }
      , K.Chars
          { key = "Backslash"
          , mods = Some [ Mod.Control ]
          , mode = None Mode
          , chars = "`|"
          }
      , K.Chars
          { key = "Grave"
          , mods = Some [ Mod.Control ]
          , mode = None Mode
          , chars = "`z"
          }
      , K.Action
          { key = "N"
          , mods = Some [ Mod.Control, Mod.Alt ]
          , mode = None Mode
          , action = Action.SpawnNewInstance
          }
      , K.Action
          { key = "Minus"
          , mods = Some [ Mod.Control ]
          , mode = None Mode
          , action = Action.None
          }
      , K.Action
          { key = "Subtract"
          , mods = Some [ Mod.Control ]
          , mode = None Mode
          , action = Action.None
          }
      ]
