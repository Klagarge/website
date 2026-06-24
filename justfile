prefix := "/"

serve-now:
    #!/usr/bin/env bash
    uv run properdocs serve --livereload

serve-next-week:
    #!/usr/bin/env bash
    set -euxo pipefail
    CALENDAR_TODAY="today in 7 days" uv run properdocs serve --livereload

serve-all:
    #!/usr/bin/env bash
    set -euxo pipefail
    CALENDAR_TODAY="today in 10 years" uv run properdocs serve --livereload

serve-timeless:
    #!/usr/bin/env bash
    set -euxo pipefail
    uv run properdocs serve -f properdocs-timeless.yml --livereload

archive YEAR:
    #!/usr/bin/env bash
    set -euxo pipefail
    target="csel1-website-{{ YEAR }}.wzip"
    rm -Rf public
    rm $target || true
    CALENDAR_TODAY="today in 10 years" uv run properdocs build -d public -f properdocs.yml
    echo {{ prefix }} >public/.prefix
    cd public && zip -FS -r ../$target . && cd ..
