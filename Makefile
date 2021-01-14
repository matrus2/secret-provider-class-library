DIRECTORY = chart
URL = https://matrus2.github.io/csi-secret-provider-class/chart

*.tgz: generate
	mv $@ ${DIRECTORY}/
	helm repo index ${DIRECTORY} --url ${URL} --merge

generate:
	helm package . --debug
