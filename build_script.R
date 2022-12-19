# Run with Rscript build_script.R
# Prints the location of the site to terminal.
# Use Ctrl+C to stop.
# See https://carpentries.github.io/sandpaper-docs/

rmarkdown::pandoc_version()
site_dir <- tempfile(tmpdir = "./build")
sandpaper::no_package_cache()
sandpaper::create_lesson(site_dir, open = FALSE)
sandpaper::build_lesson(site_dir, preview = FALSE)
sandpaper::serve()
