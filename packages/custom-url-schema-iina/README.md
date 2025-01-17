# Custom URL Schema for IINA

## Configure Chrome

### Privacy and security > Site settings > Permissions

Set `Automatic downloads` to `Allow`.

### Clear the cache

Execute the following command.

```sh
rm -rf ~/Library/Caches/Google/Chrome/Default
```

## Launch Services

### Clear the cache

Execute the following command.

```sh
/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -kill -r -domain local -domain system -domain user
```

## References

- [macOS でのカスタム URL Sceheme の設定](https://github.com/l3tnun/EPGStation/blob/master/doc/mac-url-scheme.md)
- [AppleScript でカスタム URL スキーム](https://qiita.com/CorecaraBiz/items/9a1fc60aada31858d582)
- [カスタム URL スキームの乗っ取りとその対策](https://akaki.io/2021/url_scheme_hijack)
