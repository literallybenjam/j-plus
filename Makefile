everything: jplus.js jplus-pkg.js

again: jplus jplus-pkg

jplus.js jplus: README.litcoffee
	coffee -c README.litcoffee
	mv README.js jplus.js

jplus-pkg.js jplus-pkg: README-PKG.litcoffee
	coffee -c README-PKG.litcoffee
	mv README-PKG.js jplus-pkg.js

clean gone:
	rm -f jplus.js jplus-pkg.js

.PHONY: again clean everything gone jplus jplus-pkg
