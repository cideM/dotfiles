let Alacritty =
      https://raw.githubusercontent.com/cideM/dhall-alacritty/master/linux.dhall sha256:59eaf0c7be181c4b5236168522b9dc76a481eae536442545169e8e99cb4550fc

let mono = ./mono.dhall with size = 12.0

in  Alacritty.Config::{
    , font = mono
    , env = [ { mapKey = "TERM", mapValue = "alacritty" } ]
    , colors = ./papercolor.dhall
    , shell = None { program : Text, args : List Text }
    , key_bindings = ./keys_common.dhall
    }
  with window.decorations = Alacritty.Window.Decoration.full
  with window.dynamic_padding = True
  with window.padding = { x = +10, y = +10 }
