.PHONY: appbundle
appbundle: guard-BUILDNAME guard-BUILDNUMBER
	flutter build appbundle \
		--no-sound-null-safety \
		--build-name=$(BUILDNAME) \
		--build-number=$(BUILDNUMBER) 

.PHONY: apk
apk:
	flutter build apk --no-sound-null-safety

.PHONY: lint
lint:
	flutter analyze

.PHONY: guard-BUILDNAME
guard-BUILDNAME:
ifndef BUILDNAME
	$(error BUILDNAME env var missing)
endif

.PHONY: guard-BUILDNUMBER
guard-BUILDNUMBER:
ifndef BUILDNUMBER
	$(error BUILDNUMBER env var missing)
endif
