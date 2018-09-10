FROM laristra/flecsi-buildenv:fedora

ARG SYSTEM_LIBS
ARG CMAKE_BUILD_TYPE
#Skip some tests
ARG CI
ARG TRAVIS
ARG TRAVIS_BRANCH

RUN pwd
RUN mkdir -p /home/flecsi/tpl
USER root
RUN chown -R flecsi:flecsi /home/flecsi/tpl
USER flecsi

WORKDIR /home/flecsi/tpl
RUN mkdir build
WORKDIR build
RUN cmake -DBUILD_SHARED_LIBS=ON \
          -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE} \
          -DUSE_SYSTEM_LIBS=${SYSTEM_LIBS} \
          /home/flecsi/flecsi-third-party
RUN make -j2

RUN make DESTDIR=$PWD install

USER root
RUN make install
