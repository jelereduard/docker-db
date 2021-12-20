FROM debian

# Install comands
RUN apt-get update
RUN apt-get install curl -y

# Install sudo
RUN apt-get -y install sudo

# Download CockroachDB archive
RUN curl https://binaries.cockroachdb.com/cockroach-v21.2.2.linux-amd64.tgz | \
  tar -xz && sudo cp -i cockroach-v21.2.2.linux-amd64/cockroach /usr/local/bin/

# Create directory for GEOS libraries
RUN mkdir -p /usr/local/lib/cockroach

# Copy GEOS libraries
RUN cp -i cockroach-v21.2.2.linux-amd64/lib/libgeos.so /usr/local/lib/cockroach/
RUN cp -i cockroach-v21.2.2.linux-amd64/lib/libgeos_c.so /usr/local/lib/cockroach/

# Should return /usr/local/bin/cockroach
RUN which cockroach

# Test
# RUN cockroach demo
# RUN exit

# Set workdir
WORKDIR /cockroach/

# Set env variables (path & channel)
ENV PATH=/cockroach:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
ENV COCKROACH_CHANNEL=official-docker

# Expose port
EXPOSE 26257 9999


ENTRYPOINT [ "cockroach" ]

CMD [ "start-single-node", "--insecure" ]
