SUPPORTFILES=./SupportFiles/
PLATFORM=x86_64-apple-macosx
BUILD_DIRECTORY=./.build/${PLATFORM}/debug
APP_DIRECTORY=./Squirrel.app
CFBUNDLEEXECUTABLE=Squirrel
XPCEXECUTABLE=ServiceProvider

install: build copySupportFiles

build:
	swift build --product ${CFBUNDLEEXECUTABLE}
	swift build --product ${XPCEXECUTABLE}

copySupportFiles:
	mkdir -p ${APP_DIRECTORY}/Contents/MacOS/ && \
	mkdir -p ${APP_DIRECTORY}/Contents/XPCServices/${XPCEXECUTABLE}.xpc/Contents/MacOS/
	cp ${SUPPORTFILES}/Info.plist ${APP_DIRECTORY}/Contents && \
	cp ${SUPPORTFILES}/XPCInfo.plist ${APP_DIRECTORY}/Contents/XPCServices/${XPCEXECUTABLE}.xpc/Contents/Info.plist
	cp ${BUILD_DIRECTORY}/${CFBUNDLEEXECUTABLE} ${APP_DIRECTORY}/Contents/MacOS/
	cp ${BUILD_DIRECTORY}/${XPCEXECUTABLE} ${APP_DIRECTORY}/Contents/XPCServices/${XPCEXECUTABLE}.xpc/Contents/MacOS/

run: build
	open -a ${APP_DIRECTORY}

clean:
	rm -rf .build
	rm -rf ${APP_DIRECTORY}

.PHONY: run build copySupportFiles clean
