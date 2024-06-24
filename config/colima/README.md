# Colima

# Setup

aarch64

`--profile` オプションを未指定にして `default` に設定する

```sh
colima template
colima start
docker context ls
docker context use colima-default
```

x86_64

```sh
colima template x86_64
colima start --profile x86_64
docker context ls
docker context use colima-x86_64
```

# References
