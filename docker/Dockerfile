FROM laristra/flecsi-buildenv:fedora

ARG SYSTEM_LIBS
ARG CMAKE_BUILD_TYPE
#Skip some tests
ARG TRAVIS
ARG TRAVIS_BRANCH

COPY flecsi-third-party/ /home/flecsi/tpl
COPY ccache/ /home/flecsi/.ccache
USER root
RUN chown -R flecsi:flecsi /home/flecsi/tpl /home/flecsi/.ccache /usr/local
USER flecsi

WORKDIR /home/flecsi/tpl
RUN mkdir -p build && cd build && \
    cmake -DBUILD_SHARED_LIBS=ON \
          -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE} \
          -DUSE_SYSTEM_LIBS=${SYSTEM_LIBS} \
          .. && make -j2;

USER root
RUN chown -R root:root /usr/local
USER flecsi

# Build FleCSI if it is not for DockerHub and master branch
WORKDIR /home/flecsi
RUN if [ ${TRAVIS_BRANCH} != refactor ]; then \
      git clone --depth 1 --recursive https://github.com/laristra/flecsi flecsi && \
      cd flecsi && mkdir build && cd build && \
      cmake -DENABLE_PARTITION=ON -DENABLE_IO=ON \
           -DENABLE_MPI=ON -DENABLE_LEGION=ON \
           -DENABLE_UNIT_TESTS=ON -DFLECSI_RUNTIME_MODEL=legion .. && \
      make -j2 && ctest --verbose -E "(simple_task|internal_task)" && \
      cd ../.. && \
      rm -rf flecsi; \
    fi;
