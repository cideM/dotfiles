{ pkgs, ... }:

with pkgs;

{
  home.packages = [
    libnotify
    # This fails on MacOS
    # test tests::cases::ui::two_windows_split_vertically ... ok(B
    # test tests::cases::ui::two_windows_split_horizontally ... ok(B
    # failures:
    # ---- tests::cases::ui::pause_by_space stdout ----
    # thread 'tests::cases::ui::pause_by_space' panicked at 'assertion failed: `(left == right)`
    #   left: `[Clear, HideCursor, Draw, HideCursor, Flush, Draw, HideCursor, Flush, Draw, HideCursor, Flush, Draw, HideCursor, Flush, Clear, ShowCursor]`,
    #   right: `[Clear, HideCursor, Draw, HideCursor, Flush, Draw, HideCursor, Flush, Draw, HideCursor, Flush, Clear, ShowCursor]`', src/tests/cases/ui.rs:96:5
    # note: run with `RUST_BACKTRACE=1` environment variable to display a backtrace
    # failures:
    #   tests::cases::ui::pause_by_space
    # test result: FAILED(B. 56 passed; 1 failed; 0 ignored; 0 measured; 0 filtered out

    bandwhich
    iotop
    xsel
    feh
    escrotum
    kanji-stroke-order-font
    source-han-sans-japanese
    source-han-serif-japanese
    iosevka
  ];
}
