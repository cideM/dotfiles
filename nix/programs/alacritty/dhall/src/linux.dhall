let Alacritty =
      https://raw.githubusercontent.com/cideM/dhall-alacritty/master/linux.dhall sha256:7910af41711cb1b062e95943b3d078c861d52f09fe6866c8b7a83e71e7df192e

in  Alacritty.Config::{
    , font = ./hack.dhall
    , env = [ { mapKey = "TERM", mapValue = "alacritty" } ]
    , colors = ./papercolor.dhall
    , shell = None { program : Text, args : List Text }
    , key_bindings = ./keys_common.dhall
    }
  with window.decorations = Alacritty.Window.Decoration.full
  with window.dynamic_padding = True
  with window.padding = { x = +40, y = +40 }
