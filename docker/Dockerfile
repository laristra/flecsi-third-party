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
          .. && make -j2 || \
	  { cat legion-prefix/src/legion-stamp/legion-build-err.log; exit 1; }

USER root
RUN chown -R root:root /usr/local
USER flecsi

# Build FleCSI if it is not for DockerHub and master branch
WORKDIR /home/flecsi
RUN if [ ${TRAVIS_BRANCH} = master ]; then \
      git clone --depth 1 --recursive https://github.com/laristra/flecsi flecsi && \
      cd flecsi && mkdir build && cd build && \
      cmake -DENABLE_PARTITION=ON -DENABLE_IO=ON \
           -DENABLE_MPI=ON \
           -DENABLE_UNIT_TESTS=ON -DFLECSI_RUNTIME_MODEL=mpilegion .. && \
      make -j2 && make test && \
      cd ../.. && \
      rm -rf flecsi; \
    fi;
