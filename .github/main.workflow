    # Workflow to publish plugin release to wordpress.org
    workflow "Release Plugin" {
        on = "push"
        resolves = ["wordpress"]
    }

    # Filter for tag
    action "tag" {
        uses = "actions/bin/filter@master"
        args = "tag"
    }

    # Install Dependencies
    action "install" {
        uses = "actions/npm@e7aaefe"
        needs = "tag"
        args = "install"
    }

    # Create Release ZIP archive
    action "archive" {
        uses = "lubusIN/actions/archive@master"
        needs = ["build"]
        env = {
                ZIP_FILENAME = "vr-woocommerce-forma-de-pagamento"
            }
    }

    # Publish to wordpress.org repository
    action "wordpress" {
        uses = "lubusIN/actions/wordpress@master"
        needs = ["archive"]
        env = {
            WP_SLUG = "vr-woocommerce-forma-de-pagamento"
        }
        secrets = [
            "WP_USERNAME",
            "WP_PASSWORD"
        ]
    }
