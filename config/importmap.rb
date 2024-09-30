# Pin npm packages by running ./bin/importmap

pin "application"
pin_all_from "app/javascript/controllers", under: "controllers"

pin "@popperjs/core", to: "popper.js", preload: true
pin "bootstrap", to: "bootstrap.min.js", preload: true
pin "@rails/ujs", to: "@rails--ujs.js" # @7.1.3
