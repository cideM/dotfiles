let Alacritty =
      https://raw.githubusercontent.com/cideM/dhall-alacritty/master/macos.dhall sha256:6e2fa0df3e2f6eb9b80324901a3eaf7d489670d31bda5b70d39803e940c082a6

let hack =
      ./hack.dhall
      with italic.style = "Italic"
      with offset = { x = +0, y = +4 }
      with glyph_offset = { x = +0, y = +2 }
      with size = 14.0

let mono =
      ./mono.dhall
      with normal.style = "Light"
      with italic.style = "Light Italic"
      with offset = { x = +0, y = +4 }
      with glyph_offset = { x = +0, y = +2 }
      with size = 12.0

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
    , shell = Some { program = "/usr/local/bin/fish", args = [ "-l" ] }
    , colors = ./papercolor.dhall
    , key_bindings = ./keys_common.dhall
    }
  with window.decorations = Alacritty.Window.Decoration.full
  with window.dynamic_padding = True
  with window.padding = { x = +4, y = +4 }
