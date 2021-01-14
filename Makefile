DIRECTORY = chart
URL = https://matrus2.github.io/secret-provider-class-library/chart

*.tgz: generate
	mv $@ ${DIRECTORY}/
	helm repo index ${DIRECTORY} --url ${URL} --merge index.yaml

generate:
	helm package . --debug
