.PHONY: presentation
presentation: presentation.min.html

PRESENTATION_SOURCE := presentation.xhtml style.css package-lock.json package.json

presentation.min.html: $(PRESENTATION_SOURCE)
	npm run build

start: $(PRESENTATION_SOURCE)
	npm run start
