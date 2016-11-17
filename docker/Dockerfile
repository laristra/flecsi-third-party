FROM flecsi/flecsi-buildenv:fedora

COPY flecsi-third-party/ /home/flecsi/tpl
COPY ccache/ /home/flecsi/.ccache
USER root
RUN chown -R flecsi:flecsi /home/flecsi/tpl /home/flecsi/.ccache
USER flecsi

WORKDIR /home/flecsi/tpl
RUN ccache -z
RUN mkdir -p build && cd build && \
    cmake -DBUILD_SHARED_LIBS=ON \
          -DENABLE_CINCH_UTILS=ON \
          .. && make -j2;
RUN ccache -s

# Build FleCSI if it is not for DockerHub and master branch
WORKDIR /home/flecsi
RUN git clone --depth 1 --recursive https://github.com/losalamos/flecsi flecsi && \
    cd flecsi && mkdir build && cd build && \
    cmake -DENABLE_PARTITION=ON -DENABLE_IO=ON \
         -DENABLE_UNIT_TESTS=ON -DFLECSI_RUNTIME_MODEL=legion .. && \
    make -j2 && make test && \
    cd ../.. && \
    rm -rf flecsi;
