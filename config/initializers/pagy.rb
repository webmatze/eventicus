# Pagy configuration
# See https://ddnexus.github.io/pagy/

require "pagy/extras/overflow"
require "pagy/extras/i18n"

Pagy::DEFAULT[:limit] = 20
Pagy::DEFAULT[:overflow] = :last_page
