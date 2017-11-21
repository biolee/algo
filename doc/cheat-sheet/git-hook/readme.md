# hook_location

${repo_root}/.git/hooks

# use hooks

`ln -s hooks/pre-commit .git/hooks/`

# pre-commit/pre-commit

- [doc](http://pre-commit.com/)
- [hook](http://pre-commit.com/hooks.html)

1. add `.pre-commit-config.yaml` to ${repo_root}
2. run `pip install pre-commit`
3. install `pre-commit install`
4. (optional) update hooks `pre-commit autoupdate`
5. run hook mannuly `pre-commit run --all-files` or `pre-commit run <hook_id>`

```yaml
exclude: '^$'
fail_fast: false
-   repo: https://github.com/troian/pre-commit-golang
    sha: HEAD
    exclude: "^protos/.*"
    hooks:
    -   id: go-fmt
    -   id: go-build
    -   id: go-metalinter
        args:
        - --exclude=corefoundation.go
        - --deadline=60s
        - --vendor
        - --cyclo-over=20
        - --dupl-threshold=100
        - --disable=gotype
```