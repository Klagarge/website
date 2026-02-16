prefix := "/"

serve-now:
    #!/usr/bin/env bash
    uv run mkdocs serve --livereload

serve-next-week:
    #!/usr/bin/env bash
    set -euxo pipefail
    CALENDAR_TODAY="today in 7 days" uv run mkdocs serve --livereload

serve-all:
    #!/usr/bin/env bash
    set -euxo pipefail
    CALENDAR_TODAY="today in 10 years" uv run mkdocs serve --livereload

archive YEAR:
    #!/usr/bin/env bash
    set -euxo pipefail
    target="csel1-website-{{ YEAR }}.wzip"
    rm -Rf public
    rm $target || true
    CALENDAR_TODAY="today in 10 years" uv run mkdocs build -d public -f mkdocs.yml
    echo {{ prefix }} >public/.prefix
    cd public && zip -FS -r ../$target . && cd ..
