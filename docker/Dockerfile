FROM laristra/flecsi-buildenv:fedora

ARG SYSTEM_LIBS
ARG CMAKE_BUILD_TYPE
#Skip some tests
ARG CI
ARG TRAVIS
ARG TRAVIS_BRANCH

RUN pwd
RUN ls
COPY flecsi-third-party/ /home/flecsi/tpl
USER root
RUN df -h
RUN chown -R flecsi:flecsi /home/flecsi/tpl
USER flecsi

WORKDIR /home/flecsi/tpl
RUN mkdir build
WORKDIR build
RUN cmake -DBUILD_SHARED_LIBS=ON \
          -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE} \
          -DUSE_SYSTEM_LIBS=${SYSTEM_LIBS} \
          ..
RUN make -j2

RUN make DESTDIR=$PWD install

USER root
RUN make install
USER flecsi


# Build FleCSI if it is not for DockerHub and master branch
WORKDIR /home/flecsi
RUN if [ ${TRAVIS_BRANCH} != refactor ]; then \
      git clone -b master --depth 1 --recursive https://github.com/laristra/flecsi flecsi && \
      cd flecsi && mkdir build && cd build && \
      cmake -DENABLE_UNIT_TESTS=ON \
            -DFLECSI_RUNTIME_MODEL=legion \
            -DENABLE_LEGION=ON .. && \
      make -j2 && make test && \
      cd ../.. && \
      rm -rf flecsi; \
    fi;
