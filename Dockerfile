FROM elixir:1.5

MAINTAINER Dave Long <dlong@cagedata.com>

ENV BUILDER_VERSION 1.5

LABEL io.k8s.description="Platform for building Elixir applications" \
      io.k8s.display-name="elixir 1.5" \
      io.openshift.tags="builder,elixir,1.5" \
      io.openshift.expose-services="4000:http"

LABEL io.openshift.s2i.scripts-url=image:///usr/libexec/s2i \
      io.s2i.scripts-url=image:///usr/libexec/s2i
COPY ./s2i/bin/ /usr/libexec/s2i

ENV HOME=/opt/app-root/src \
    PORT=4000 \
    MIX_ENV=prod

RUN groupadd --gid 1001 app \
  && useradd --home-dir ${HOME} --no-create-home --uid 1001 --gid 1001 --groups 0 --system app \
  && mkdir -p ${HOME} && chown -R 1001:1001 ${HOME}

WORKDIR /opt/app-root/src
USER 1001

CMD ["/usr/libexec/s2i/usage"]
