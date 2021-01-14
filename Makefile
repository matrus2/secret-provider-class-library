DIRECTORY = chart
URL = def

*.tgz: generate
	mv $@ ${DIRECTORY}/
	helm repo index ${DIRECTORY} --url ${URL}

generate:
	helm package . --debug
