# Custom URL Schema for IINA

# Clear the cache

Launch Services のキャッシュをクリアする

```sh
/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -kill -r -domain local -domain system -domain user
```

Google Chrome のキャッシュをクリアする

```sh
rm -rf ~/Library/Caches/Google/Chrome/Default
```

# Reference

- [macOS でのカスタム URL Sceheme の設定](https://github.com/l3tnun/EPGStation/blob/master/doc/mac-url-scheme.md)
- [AppleScript でカスタム URL スキーム](https://qiita.com/CorecaraBiz/items/9a1fc60aada31858d582)
- [カスタム URL スキームの乗っ取りとその対策](https://akaki.io/2021/url_scheme_hijack)
