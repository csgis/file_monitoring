FROM alpine:3.12.3

MAINTAINER toni.schoenbuchner@csgis.de

# Install  required dependencies
RUN apk --update upgrade && \
    apk add --update inotify-tools && \
    rm -rf /var/cache/apk/*



# Add  init script.
ADD file_monitor.sh /file_monitor.sh
RUN chmod 750 /file_monitor.sh

# Create linked directory
RUN mkdir /archive
WORKDIR /

# run watcher script
CMD ["sh","/file_monitor.sh", "/archive"]
