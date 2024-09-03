.PHONY: presentation
presentation: presentation.min.html

PRESENTATION_SOURCE := presentation.xhtml style.css package-lock.json package.json

presentation.min.html: $(PRESENTATION_SOURCE)
	npm run build --theme=./style.scss

serve: $(PRESENTATION_SOURCE)
	npm run start --theme=./style.scss
