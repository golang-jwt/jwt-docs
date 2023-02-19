# jwt-docs

Repository contains documentation for the [golang-jwt/jwt](https://github.com/golang-jwt/jwt)
package.

## Tools

The documentation is built with [MkDocs](https://www.mkdocs.org/) and the
[Material for MkDocs](https://squidfunk.github.io/mkdocs-material) theme.

We use a pre-built
[docker image](https://squidfunk.github.io/mkdocs-material/getting-started/#with-docker) which comes
with all dependencies pre-installed.

Note, we're using the recommended third-party image because the official one only supports
`linux/amd64`.

```
docker pull ghcr.io/afritzler/mkdocs-material
```

Ensure you have Docker installed, run `make preview`, and open http://127.0.0.1:8000 to see a
preview of the site locally.
