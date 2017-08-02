bucket = "examples.atomaka.com" # your bucket that exists in us-east-2

# DO NOT EDIT BELOW HERE
key = "business-hours.zip"
yarnbin = $(shell yarn bin)

deploy: upload
	AWS_DEFAULT_REGION=us-east-2 aws lambda update-function-code \
    --function-name business-hours \
		--s3-bucket $(bucket) \
		--s3-key $(key)

upload: build
	AWS_DEFAULT_REGION=us-east-2 aws s3 cp \
    build/business-hours.zip s3://$(bucket)/$(key)

build: clean
	mkdir build/
	cp index.js build/
	cd build/ \
		&& zip -q -r $(key) . \
		&& cd ../

clean:
	rm -rf build/

setup: build
	bash setup.sh
