# Run with Rscript build_script.R
# Prints the location of the site to terminal.
# Use Ctrl+C to stop.
# See https://carpentries.github.io/sandpaper-docs/

rmarkdown::pandoc_version()
tmp <- tempfile()
sandpaper::no_package_cache()
sandpaper::create_lesson(tmp, open = FALSE)
sandpaper::build_lesson(tmp, preview = FALSE)
sandpaper::serve()
