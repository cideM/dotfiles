let Alacritty =
      https://raw.githubusercontent.com/cideM/dhall-alacritty/master/macos.dhall sha256:181daf4868487419edf1af93c951e90404e232e32117e334303eec1c1d9f577a

let hack =
      ./hack.dhall
      with italic.style = "Italic"
      with offset = { x = +0, y = +4 }
      with glyph_offset = { x = +0, y = +2 }
      with size = 14.0

let mono =
      ./mono.dhall
      with normal.style = "Book"
      with italic.style = "Book Italic"
      with offset = { x = +0, y = +4 }
      with glyph_offset = { x = +0, y = +2 }
      with size = 13.0

let menlo =
      ./menlo.dhall
      with offset = { x = +0, y = +6 }
      with glyph_offset = { x = +0, y = +3 }
      with size = 12.0

let jb =
      ./jetbrains.dhall
      with size = 13.0
      with offset = { x = +0, y = +6 }
      with glyph_offset = { x = +0, y = +3 }

in  Alacritty.Config::{
    , font = mono ⫽ { use_thin_strokes = True }
    , shell = None { program : Text, args : List Text }
    , env = [ { mapKey = "TERM", mapValue = "alacritty" } ]
    , colors = ./spacemacs_light.dhall
    , key_bindings = ./keys_common.dhall
    }
  with window.decorations = Alacritty.Window.Decoration.full
  with window.dynamic_padding = True
  with window.padding = { x = +4, y = +4 }
